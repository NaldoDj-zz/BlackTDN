#INCLUDE "NDJ.CH"
/*/
    Funcao: MT160OK
    Autor:    Marinaldo de Jesus
    Data:    27/11/2010
    Uso:    Executada a partir da A160Analis em MATA160. Originalmente usado para Verificar se o Processo de Analise de Contacao ira continuar ou nao.
            Sera utilizado para enviar e-mails aos solicitantes e compradores referente as cotacoes.
/*/
User Function MT160OK()

    Local aArea            := GetArea()
    Local aAreaSC8        := SC8->( GetArea() )
    Local aStackParam

    Local bExecute        := { |bBlock,cMsgAguarde|;
                                            cMsgAguarde := IF( Empty( cMsgAguarde ) , "Preparando o Envio de E-mail" , cMsgAguarde ) ,;
                                            MSAguarde( bBlock , OemToAnsi( "Aguarde..." ) , OemToAnsi( cMsgAguarde ) , .F.);
                            }
    
    Local cMsgHelp

    Local lU_MATA160    := IsInCallStack( "U_MATA160" )
    Local lMt160Ok        := lU_MATA160
    Local l160Visual
    Local oException

    TRYEXCEPTION
    
        l160Visual        := StaticCall( NDJLIB006 , ReadStackParameters , Upper( "A160Analis" ) , Upper( "l160Visual" ) , NIL , NIL , @aStackParam )
        IF !( ValType( l160Visual ) == "L" )
            l160Visual    := ( StaticCall( NDJLIB006 , ReadStackParameters , Upper( "A160Analis" ) , Upper( "nOpcX" ) , NIL , NIL , @aStackParam )     == 2 )
            IF !( ValType( l160Visual ) == "L" )
                l160Visual := .F.
            EndIF
        EndIF

        IF ( l160Visual )
            BREAK
        EndIF

        IF ( lU_MATA160 )    //A(Re)provacapo Cotacao

            lMt160Ok := MsgYesNo( "Deseja Aprovar a Cotação?" , ProcName() + " :: Atenção!" )
            IF !( lMt160Ok )
                Eval( bExecute , { || MT160NotOk( @ParamIxb ) } )
                IF ( lMt160Ok )
                    lMt160Ok    := .F.
                EndIF
            Else
                Eval( bExecute , { || lMt160Ok    := MT160Aprov( @ParamIxb ) } , "Aprovando Cotação" )
            EndIF

        Else    //Analise de Cotacao

            Eval( bExecute , { || lMt160Ok    := MT160OK( ParamIxb ) } )
            
            IF ( lMt160Ok )
                lMt160Ok    := .F.
            EndIF

        EndIF

    CATCHEXCEPTION USING oException

        lMt160Ok    := .F.

        IF ( ValType( oException ) == "O" )
            cMsgHelp := oException:Description + CRLF
            Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            ConOut( CaptureError() )
        EndIF

    ENDEXCEPTION

    RestArea( aAreaSC8 )
    RestArea( aArea )

Return( lMt160Ok )

/*/
    Funcao: MT160Aprov
    Autor:    Marinaldo de Jesus
    Data:    27/11/2010
    Uso:    Altera o Status da Cotacao se Aprovada
/*/
Static Function MT160Aprov( aPlanilha )

    Local aArea            := GetArea()
    Local aSC8Area        := SC8->( GetArea() )

    Local cMsgHelp
    Local cSC8Filial
    Local cSC8KeySeek

    Local lLock
    Local lIsLocked
    Local lMT160Aprov    := .T.

    Local nSC8Order
    
    Local oException

    TRYEXCEPTION

        aPlanilha[1][1][PLAN_MARK] := "XX"

        nSC8Order    := RetOrder( "SC8" , "C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO+C8_ITEMGRD" )

        SC8->( dbSetOrder( nSC8Order ) )

        cSC8Filial    := xFilial( "SC8" )

        cSC8KeySeek := cSC8Filial
        cSC8KeySeek += cA160num

        IF SC8->( !dbSeek( cSC8KeySeek , .F. ) )
            UserException( "A cotação de Número: " + cA160num + " não foi Localizada na Tabela de Cotações SC8. Entre em Contato com o Administrador do Sistema" )
        EndIF

        While SC8->( !Eof() .and. C8_FILIAL+C8_NUM == cSC8KeySeek )
            lIsLocked    := SC8->( IsLocked() )
            IF ( lIsLocked )    
                lLock := lIsLocked
            Else
                lLock := SC8->( RecLock( "SC8" , .F. ) )
            EndIF    
            IF ( lLock )
                SC8->C8_XSTATCO := " "
                IF !( lIsLocked )
                    SC8->( MsUnLock() )
                EndIF
            EndIF
            SC8->( dbSkip() )
        End While

        lMt160Ok    := MT160OK( @aPlanilha )

    CATCHEXCEPTION USING oException

        lMT160Aprov    := .F.
        
        IF ( ValType( oException ) == "O" )
            cMsgHelp := oException:Description
            Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            ConOut( CaptureError() )
        EndIF

    ENDEXCEPTION

    RestArea( aSC8Area )
    RestArea( aArea )

Return( lMT160Aprov )

/*/
    Funcao: MT160NotOk
    Autor:    Marinaldo de Jesus
    Data:    14/12/2010
    Uso:    Acao a Ser Executada Quanto Cotacao Reprovada pelo Solicitante
/*/
Static Function MT160NotOk( aPlanilha )

    Local aArea            := GetArea()
    Local aSC8Area        := SC8->( GetArea() )
    Local aSZ6Area        := SZ6->( GetArea() )
    
    Local cSC8Filial    := xFilial( "SC8" )
    Local cMsgReprova    := ""
    Local cSC8KeySeek    := ""
    
    Local lOk            := .F.
    Local lPutLog        := .F.
    Local lMT160NotOk    := .T.
    
    Local nAttempts        := 0
    Local nSC8Recno        := 0
    Local nSC8Order        := RetOrder( "SC8" , "C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO+C8_ITEMGRD" )
    Local nSZ6Order        := RetOrder( "SZ6" , "Z6_FILIAL+Z6_XFILIAL+Z6_NUMSC8+Z6_FORSC8+Z6_LOJSC8+Z6_ITEMSC8+DTOS(Z6_DATA)+Z6_HORA" )

    TRYEXCEPTION

        While (;
                    Empty( cMsgReprova );
                    .or.;
                    ( Len( cMsgReprova ) < 10 );
                )
            cMsgReprova := StaticCall( NDJLIB001 , DlgMemoEdit , NIL , "Justificativa da Recusa" , NIL , NIL , NIL , cMsgReprova )
            IF ( ( ++nAttempts ) > 5 )
                cMsgReprova += CRLF
                cMsgReprova += " Aprovador: "
                cMsgReprova += StaticCall( NDJLIB014 , RetCodUsr )
                cMsgReprova += ": "
                cMsgReprova += StaticCall( NDJLIB014 , UsrRetName )
                cMsgReprova += " "
                cMsgReprova += "não incluiu uma justiticativa plausível!"
                cMsgReprova += CRLF
                cMsgReprova += CRLF
                cMsgReprova += " REPROVADO AUTOMATICAMENTE PELO SISTEMA EM "
                cMsgReprova += Dtoc( Date() )
                cMsgReprova += " "
                cMsgReprova += Time()
                Exit
            EndIF
        End While

        lMT160NotOk    := MT160OK( @aPlanilha , @lOk , @cMsgReprova )
    
        SC8->( dbSetOrder( nSC8Order ) )
    
        cSC8KeySeek := cSC8Filial
        cSC8KeySeek += cA160num
    
        IF SC8->( dbSeek( cSC8KeySeek , .F. ) )
            While SC8->( !Eof() )
                lPutLog    := ( SC8->C8_XSTATCO $ Upper( "1X" ) )
                IF ( lPutLog )
                    nSC8Recno    := SC8->( Recno() )
                    Exit
                EndIF
                SC8->( dbSkip() )
            End While
        EndIF
    
        IF ( lPutLog )
            SC8->( MsGoto( nSC8Recno ) )
            SZ6->( dbSetOrder( nSZ6Order ) )
            IF SZ6->( RecLock( "SZ6" , .T. ) )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_FILIAL"     , xFilial( "SZ6" )    , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ALIAS"        , "SC8"             , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_XFILIAL"     , SC8->C8_FILIAL    , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_NUMSC"        , SC8->C8_NUMSC        , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ITEMSC"    , SC8->C8_ITEMSC    , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_NUMPC"        , SC8->C8_NUMPED    , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ITEMPC"    , SC8->C8_ITEMPED    , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_NUMSC8"     , SC8->C8_NUM        , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_FORSC8"     , SC8->C8_FORNECE    , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_LOJSC8"     , SC8->C8_LOJA        , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ITEMSC8"     , SC8->C8_ITEM        , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_USER"         , SC8->C8_USERSC    , .T. ) 
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_DATA"         , Date()            , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_HORA"         , Time()            , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_OBS"         , cMsgReprova        , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_HRECCOT"     , .T.                , .T. )
                SZ6->( MsUnLock() )
                StaticCall( NDJLIB001 , __FieldPut , "SC8" , "C8_XHRECOT"     , .T.                , .T. )
            EndIF
        EndIF

    CATCHEXCEPTION

        lMT160NotOk    := .F.    

    ENDEXCEPTION

    RestArea( aSZ6Area )
    RestArea( aSC8Area )
    RestArea( aArea )

Return( lMT160NotOk )

/*/
    Funcao: MT160OK
    Autor:    Marinaldo de Jesus
    Data:    27/11/2010
    Uso:    Envio de e-mail e alteracao do Status da Cotacao
/*/
Static Function MT160OK( aPlanilha , lOk , cMsgReprova )

    Local aTo            := {}
    Local aErr            := {}
    Local aArea            := GetArea()
    Local aSC1Area        := SC1->( GetArea() )
    Local aSC8Area        := SC8->( GetArea() )
    Local aSY1Area        := SY1->( GetArea() )
    Local aSC8Recnos    := {}
    Local aProjetos    := {}

    Local cMsgErr        := ""
    Local cMsgMail    
    Local cSubject
    Local cGeCodUser
    Local cMailGeUsr
    Local cC1XPROJET

    Local cSC1Filial
    Local cSC8Filial
    Local cSY1Filial

    Local cSC8NumCot
    Local cSC1KeySeek
    Local cSC8KeySeek

    Local lLock
    Local lAprova        := ( IsInCallStack( "MT160Aprov" ) .and. IsInCallStack( "U_MATA160" ) )
    Local lMT160OK        := .T.
    Local lIsLocked
    Local lVencedora

    Local nLoop
    Local nLoops
    Local nItem
    Local nItens
    Local nRecno
    Local nRecnos
    Local nSC1Order
    Local nSC8Order
    Local nSY1Order
    Local nSC8Recno

    Local nProjeto
    Local nProjetos
    Local nProposta

    Local oException

    TRYEXCEPTION
    
        DEFAULT lOk    := .T.
        
        nSC1Order    := RetOrder( "SC1" , "C1_FILIAL+C1_NUM+C1_ITEM" )
        nSC8Order    := RetOrder( "SC8" , "C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO+C8_ITEMGRD" )
        nSY1Order    := RetOrder( "SY1" , "Y1_FILIAL+Y1_USER" )

        SC1->( dbSetOrder( nSC1Order ) )
        SC8->( dbSetOrder( nSC8Order ) )
        SY1->( dbSetOrder( nSY1Order ) )

        cSC1Filial    := xFilial( "SC1" )
        cSC8Filial    := xFilial( "SC8" )
        cSY1Filial    := xFilial( "SY1" )
        
        nLoops := Len( aPlanilha )
        For nLoop := 1 To nLoops
            nItens := Len( aPlanilha[ nLoop ] )
            aSort( aPlanilha[ nLoop ] , NIL , NIL , { |x,y| IF(Empty(x[PLAN_MARK]),"1","0") < IF(Empty(y[PLAN_MARK]),"1","0") } )
            For nItem := 1 To nItens
                cSC8KeySeek := cSC8Filial
                cSC8KeySeek += cA160num
                cSC8KeySeek += Padr( aPlanilha[nLoop][nItem][PLAN_FORNECEDOR]         , GetSx3Cache( "C8_FORNECE"    , "X3_TAMANHO" ) )
                cSC8KeySeek += Padr( aPlanilha[nLoop][nItem][PLAN_LOJA_FORNECEDOR]    , GetSx3Cache( "C8_LOJA"    , "X3_TAMANHO" ) )
                cSC8KeySeek += Padr( aPlanilha[nLoop][nItem][PLAN_ITEM_COTACAO]     , GetSx3Cache( "C8_ITEM"     , "X3_TAMANHO" ) )
                cSC8KeySeek += Padr( aPlanilha[nLoop][nItem][PLAN_PROPOSTA]         , GetSx3Cache( "C8_NUMPRO"     , "X3_TAMANHO" ) )
                cSC8KeySeek += Padr( aPlanilha[nLoop][nItem][PLAN_ITEM_GRADE]         , GetSx3Cache( "C8_ITEMGRD"    , "X3_TAMANHO" ) )
                IF SC8->( !dbSeek( cSC8KeySeek , .F. ) )
                    Loop
                EndIF
                lVencedora    := !( Empty( aPlanilha[nLoop][nItem][PLAN_MARK] ) )    //Proposta Vencedora
                IF !( lAprova )
                    IF ( lIsLocked )
                        lLock := lIsLocked
                    Else
                        lLock := SC8->( RecLock( "SC8" , .F. ) )
                    EndIF
                    IF !( lLock )
                        UserException( "Impossível Atualizar Informações de Cotação!" )
                    EndIF
                    IF ( lVencedora )
                        SC8->C8_XSTATCO := IF( lOk , "1" , Upper( "X" ) )
                    Else
                        SC8->C8_XSTATCO := IF( lOk , "0" , Lower( "x" ) )
                    EndIF
                    IF !( lIsLocked )
                        SC8->( MsUnLock() )
                    EndIF
                EndIF
                IF (;
                        ( lAprova );
                        .and.;
                        !( lVencedora );
                    )
                    Loop
                EndIF
                nProjeto    := SC8->( aScan( aProjetos , { |aPrj| aPrj[ 1 ] == C8_XPROJET } ) )
                IF ( nProjeto == 0 )
                    SC8->( aAdd( aProjetos , { C8_XPROJET , {} , {} } ) )
                    nProjeto    := Len( aProjetos )
                EndIF
                cSC1KeySeek        := cSC1Filial
                cSC1KeySeek        += SC8->C8_NUMSC
                cSC1KeySeek        += SC8->C8_ITEMSC
                IF SC1->( !dbSeek( cSC1KeySeek , .F. ) )
                    Loop
                EndIF
                cGeCodUser        := PosAlias("AF8",SC1->(C1_XPROJET+C1_XREVISA),NIL,"AF8_XCODGE",RetOrder("AF8","AF8_FILIAL+AF8_PROJET+AF8_REVISA"),.T.) //Código do Usuario Gerente
                cMailGeUsr        := StaticCall( NDJLIB014 , UsrRetMail , cGeCodUser )
                StaticCall( NDJLIB002 , AddMailDest , @aProjetos[ nProjeto ][ 2 ] , cMailGeUsr         )
                StaticCall( NDJLIB002 , AddMailDest , @aProjetos[ nProjeto ][ 2 ] , GetNewPar("NDJ_ECOM","ndjadvpl@gmail.com") )
                StaticCall( NDJLIB002 , AddMailDest , @aProjetos[ nProjeto ][ 2 ] , StaticCall( NDJLIB014 , UsrRetMail , SC1->C1_USER ) )
                SC8->( aAdd( aProjetos[ nProjeto ][ 3 ] , { Recno() , lVencedora , {} } ) )
                nProposta        := Len( aProjetos[ nProjeto ][ 3 ] )
                SC1->( aAdd( aProjetos[ nProjeto ][ 3 ][ nProposta ][ 3 ] , Recno() ) )
            Next nItem
        Next nLoop

        nProjetos := Len( aProjetos )
        For nProjeto := 1 To nProjetos
            aTo            := aProjetos[ nProjeto ][ 2 ]
            aSC8Recnos    := aProjetos[ nProjeto ][ 3 ]
            cSubject    := "A Cotação Número: "
            cSubject    += cA160num
            IF ( lOk )
                IF ( lAprova )
                    cSubject    += " foi APROVADA" 
                Else
                    cSubject    += " foi ANALISADA e aguarda a sua APROVAÇÃO. " 
                EndIF
            Else
                cSubject    += " Foi REPROVADA. "
            EndIF
            cSubject    += " Processo Número: " + SC8->C8_XNUMPRO
            cSubject    := OemToAnsi( cSubject ) 
            cMsgMail    := OemToAnsi( BuildHtml( .T. , @aSC8Recnos , SC8->C8_XNUMPRO , @lAprova , @lOk , cMsgReprova ) )
            IF !( StaticCall( NDJLIB002 , SendMail , @cSubject , @cMsgMail , @aTo , NIL , NIL , NIL , .F. ) )
                aAdd( aErr , "Problema no Envio de Email: "  )
                aAdd( aErr , "Cotação:  "         + cA160num )
                aAdd( aErr , "Processo: "         + SC8->C8_XNUMPRO )
                aAdd( aErr , "Projeto:  "         + aProjetos[ nProjeto ][ 1 ] )
                aAdd( aErr , "Destinatarios: " )
                aEval( aTo , { |cMail| aAdd( aErr , cMail ) } )
            EndIF
        Next nProjeto

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            aAdd( aErr , oException:Description )
        EndIF    

        lMT160OK    := .F.

    ENDEXCEPTION

    RestArea( aSC1Area )
    RestArea( aSY1Area )
    RestArea( aSC8Area )
    RestArea( aArea )

    IF !Empty( aErr )
        cMsgErr := "Problema no Envio de e-mail de Analise de Cotação"
        fMakeLog( { aErr } , { cMsgErr }    , NIL , .T.    , NIL , "Log no Processo de Análise de Cotação" , "G" , "L"     )
    EndIF

Return( lMT160OK )

/*/
    Funcao: BuildHtml
    Autor:    Marinaldo de Jesus
    Data:    14/12/2010
    Uso:    Monta o HTML a ser Enviado para Solicitante e para o Grupo de Compradores
/*/
Static Function BuildHtml( lRmvCRLF , aSC8Recnos , cProcesso , lAprova , lOk , cMsgReprova )

    Local cHtml := ""

    Local lVencedora
    
    Local nSC1Recno
    Local nSC1Recnos

    Local nSC8Recno
    Local nSC8Recnos    := Len( aSC8Recnos )

    cHtml += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' + CRLF
    cHtml += '<html xmlns="http://www.w3.org/1999/xhtml">' + CRLF 
    cHtml += '    <head>' + CRLF 
    cHtml += '        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />' + CRLF 
    IF ( lOk )
        IF ( lAprova )
            cHtml += '        <title>NDJ - ENVIO DE E-MAIL - Aprovação de Cotação</title>' + CRLF 
        Else
            cHtml += '        <title>NDJ - ENVIO DE E-MAIL - Analise de Cotação</title>' + CRLF 
        EndIF    
    Else
        cHtml += '        <title>NDJ - ENVIO DE E-MAIL - Reprovação de Cotação</title>' + CRLF 
    EndIF    
    cHtml += '    </head>' + CRLF 
    cHtml += '    <body bgproperties="0" bottommargin="0" leftmargin="0" marginheight="0" marginwidth="0" >' + CRLF 
    cHtml += '        <table cellpadding="0" cellspacing="0"  width"100%" border="0" >' + CRLF 
    cHtml += '            <tr bgcolor="#EEEEEE">' + CRLF 
    cHtml += '                <td>' + CRLF 
    cHtml += '                    <img src="' + GetNewPar("NDJ_ELGURL " , "" ) + '" border="0">' + CRLF 
    cHtml += '                </td>' + CRLF 
    cHtml += '            </tr>' + CRLF 
    cHtml += '            <tr bgcolor="#BEBEBE">' + CRLF 
    cHtml += '                <td height="20">' + CRLF 
    cHtml += '                </td>' + CRLF 
    cHtml += '            </tr>' + CRLF 
    cHtml += '            <tr>' + CRLF 
    cHtml += '                <td>' + CRLF 
    cHtml += '                    <br />' + CRLF 
    cHtml += '                    <font face="arial" size="2">' + CRLF 
    cHtml += '                        <b>' + CRLF 
    IF ( lOk )
        IF ( lAprova )
            cHtml += '                        APROVAÇÃO DE COTAÇÃO'
        Else
            cHtml += '                        ANÁLISE DE COTAÇÃO'
        EndIF    
    Else
        cHtml += '                            REPROVAÇÃO DE COTAÇÃO'
    EndIF    
    cHtml += '                        </b>' + CRLF 
    cHtml += '                        <br />' + CRLF 
    cHtml += '                        <br />' + CRLF 
    cHtml += '                    </font>' + CRLF 
    cHtml += '                </td>' + CRLF 
    cHtml += '            </tr>' + CRLF 
    cHtml += '            <tr>' + CRLF  
    cHtml += '                <td>' + CRLF 
    cHtml += '                    <p>' + CRLF 
    cHtml += '                        <font face="arial" size="2">' + CRLF  
    IF ( lOk )
        cHtml += '                            Prezado Solicitante,'
    Else
        cHtml += '                            Prezado(s) Compradore(s),'
    EndIF
    cHtml += '                        </font>' + CRLF 
    cHtml += '                        <font face="arial" size="2">' + CRLF 
    cHtml += '                            <br />' + CRLF
    cHtml += '                            <br />' + CRLF
    cHtml += 'A cotação No '
    cHtml += cA160num + "-" + cProcesso
    IF ( lOk )
        cHtml += ' teve cotações/propostas analisadas e necessita de sua aprovação para que possa dar continuidade aos processos pertinentes.'  
        cHtml += '                            <br />' + CRLF
        cHtml += 'Favor verficiar validade da proposta e dar continuidade.'  
    Else
        cHtml += ' Foi Reprovada.'  
        cHtml += '                            <br />' + CRLF
        cHtml += 'Favor verficiar reprovação, alinhar necessidades com fornecedor e solicitante para nova aprovação.'  
    EndIF    
    cHtml += '                            <br />' + CRLF
    cHtml += '                        </font>' + CRLF
    cHtml += '                        <br />' + CRLF
    cHtml += '                    </p>' + CRLF 
    cHtml += '                </td>' + CRLF
    cHtml += '            </tr>' + CRLF
    cHtml += '            <tr>' + CRLF
    cHtml += '                <td align="right" valign="top">' + CRLF 
    cHtml += '                    <br />' + CRLF  
    cHtml += '                    <font face="arial" size="2">' + CRLF 
    For nSC8Recno    := 1 To nSC8Recnos
        SC8->( dbGoto( aSC8Recnos[ nSC8Recno ][ 1 ] ) )
        lVencedora    := aSC8Recnos[ nSC8Recno ][ 2 ]
        cHtml += '                        <table width="100%" border="0" cellspacing="2" cellpadding="0">' + CRLF
        nSC1Recnos    := Len( aSC8Recnos[ nSC8Recno ][ 3 ] )
        For nSC1Recno := 1 To nSC1Recnos
            SC1->( dbGoto( aSC8Recnos[ nSC8Recno ][ 3 ][ nSC1Recno ] ) )
            cHtml += '                        <tr>' + CRLF
            cHtml += '                            <td width="18%" height="19" >' + CRLF 
            cHtml += '                                <b>' + CRLF 
            cHtml += '                                    <font face="arial" size="2">' + CRLF  
            cHtml += '                                        Número da SC:'  
            cHtml += '                                    </font>' + CRLF  
            cHtml += '                                </b>' + CRLF 
            cHtml += '                            </td>' + CRLF
            cHtml += '                            <td width="82%">' + CRLF 
            cHtml += '                                <font size="2" face="arial">' + CRLF 
            cHtml += SC1->C1_NUM      
            cHtml += '                                   </font>' + CRLF 
            cHtml += '                               </td>' + CRLF
            cHtml += '                           </tr>' + CRLF
            cHtml += '                           <tr>' + CRLF    
            cHtml += '                               <td>' + CRLF 
            cHtml += '                                   <b>' + CRLF 
            cHtml += '                                    <font face="arial" size="2">' + CRLF  
            cHtml += '                                        Data:'  
            cHtml += '                                    </font>' + CRLF  
            cHtml += '                                </b>' + CRLF 
            cHtml += '                            </td>' + CRLF  
            cHtml += '                            <td>' + CRLF 
            cHtml += '                                 <font size="2" face="arial">' + CRLF 
            cHtml += DTOC(SC1->C1_EMISSAO)  
            cHtml += '                                   </font>' + CRLF 
            cHtml += '                               </td>' + CRLF
            cHtml += '                           </tr>' + CRLF
        Next nSC1Recno
        cHtml += '                               <tr>' + CRLF 
        cHtml += '                                   <td>' + CRLF 
        cHtml += '                                       <b>' + CRLF 
        cHtml += '                                        <font face="arial" size="2">' + CRLF  
        cHtml += '                                               Projeto:'  
        cHtml += '                                        </font>' + CRLF  
        cHtml += '                                       </b>'
        cHtml += '                                   </td>' + CRLF
        cHtml += '                                   <td>' + CRLF 
        cHtml += '                                       <font size="2" face="arial">' + CRLF 
        cHtml += SC8->C8_XPROJET + " - " + PosAlias( "AF8" , SC8->C8_XPROJET , NIL , "AF8_DESCRI" , RetOrder( "AF8" , "AF8_FILIAL+AF8_PROJET" ) , .F. )  
        cHtml += '                                       </font>' + CRLF 
        cHtml += '                                   </td>' + CRLF
        cHtml += '                               </tr>' + CRLF
        cHtml += '                               <tr>' + CRLF
        cHtml += '                                   <td>' + CRLF 
        cHtml += '                                       <b>' + CRLF 
        cHtml += '                                        <font face="arial" size="2">' + CRLF  
        cHtml += '                                               Tarefa:'  
        cHtml += '                                        </font>' + CRLF  
        cHtml += '                                       </b>' + CRLF 
        cHtml += '                                   </td>' + CRLF
        cHtml += '                                   <td>' + CRLF 
        cHtml += '                                      <font size="2" face="arial">' + CRLF 
        cHtml += SC8->C8_XTAREFA  
        cHtml += '                                      </font>' + CRLF 
        cHtml += '                                  </td>' + CRLF
        cHtml += '                              </tr>' + CRLF
        cHtml += '                              <tr>' + CRLF
        cHtml += '                                  <td>' + CRLF 
        cHtml += '                                      <b>' + CRLF 
        cHtml += '                                        <font face="arial" size="2">' + CRLF  
        cHtml += '                                              Centro de Custo:'  
        cHtml += '                                        </font>' + CRLF  
        cHtml += '                                      </b>' + CRLF 
        cHtml += '                                  </td>' + CRLF
        cHtml += '                                  <td>' + CRLF 
        cHtml += '                                      <font size="2" face="arial">' + CRLF 
        cHtml += SC8->C8_CC  
        cHtml += '                                    </font>' + CRLF 
        cHtml += '                                </td>' + CRLF
        cHtml += '                            </tr>' + CRLF
        cHtml += '                        </table>' + CRLF
        cHtml += '                    </font>' + CRLF 
        cHtml += '                </td>' + CRLF
        cHtml += '            </tr>' + CRLF 
        cHtml += '            <tr>' + CRLF
        cHtml += '                <td colspan="2">' + CRLF
        cHtml += '                    <font face="arial" size="2">' + CRLF 
        cHtml += '                        <table width="100%" border="0" cellspacing="2" cellpadding="0">' + CRLF
        cHtml += '                        <table width="100%" border="0" cellspacing="2" cellpadding="0">' + CRLF
        cHtml += '                            <tr>' + CRLF
        cHtml += '                                <td width="18%" height="19">' + CRLF
        cHtml += '                                    &nbsp;'  
        cHtml += '                                </td>' + CRLF
        cHtml += '                                <td width="82%">' + CRLF 
        cHtml += '                                    &nbsp;'  
        cHtml += '                                </td>' + CRLF
        cHtml += '                            </tr>' + CRLF
        cHtml += '                            <tr>' + CRLF
        cHtml += '                                <td>' + CRLF 
        cHtml += '                                    &nbsp;'  
        cHtml += '                                </td>' + CRLF
        cHtml += '                                <td>' + CRLF 
        cHtml += '                                    &nbsp;'  
        cHtml += '                                </td>' + CRLF
        cHtml += '                            </tr>' + CRLF
        cHtml += '                            <tr>' + CRLF
        cHtml += '                                <td>' + CRLF 
        cHtml += '                                    <b>' + CRLF 
        cHtml += '                                        <font face="arial" size="2">' + CRLF  
        cHtml += '                                            Código do Fornecedor:'
        cHtml += '                                        </font>' + CRLF  
        cHtml += '                                    </b>' + CRLF 
        cHtml += '                                </td>' + CRLF
        cHtml += '                                <td>' + CRLF 
        cHtml += SC8->C8_FORNECE
        IF ( lVencedora )
            IF ( lAprova )
                cHtml += ' <font face="arial" size="2" color="GREEN">' + CRLF
                cHtml += ' :: PROPOSTA APROVADA '
                cHtml += ' </font>'     + CRLF
            Else
                cHtml += ' <font face="arial" size="2" color="GREEN">' + CRLF
                cHtml += ' :: PROPOSTA RECOMENDADA '
                cHtml += ' </font>'     + CRLF
            EndIF
        EndIF
        cHtml += '                                </td>' + CRLF
        cHtml += '                            <tr>' + CRLF
        cHtml += '                                <td>' + CRLF 
        cHtml += '                                    <b>' + CRLF 
        cHtml += '                                        <font face="arial" size="2">' + CRLF  
        cHtml += '                                            Loja:'
        cHtml += '                                        </font>' + CRLF  
        cHtml += '                                    </b>' + CRLF 
        cHtml += '                                </td>' + CRLF
        cHtml += '                                <td>' + CRLF 
        cHtml += SC8->C8_LOJA
        cHtml += '                                </td>' + CRLF
        cHtml += '                            </tr>' + CRLF
        cHtml += '                            <tr>' + CRLF
        cHtml += '                                <td>' + CRLF 
        cHtml += '                                    <b>' + CRLF 
        cHtml += '                                        <font face="arial" size="2">' + CRLF  
        cHtml += '                                            Nome do Fornecedor:'
        cHtml += '                                        </font>' + CRLF  
        cHtml += '                                    </b>' + CRLF 
        cHtml += '                                </td>' + CRLF
        cHtml += '                                <td>' + CRLF 
        cHtml += '                                    <font face="arial" size="2">' + CRLF  
        cHtml += PosAlias( "SA2" , SC8->(C8_FORNECE+C8_LOJA) , NIL , "A2_NOME" , RetOrder( "SA2" , "A2_FILIAL+A2_COD+A2_LOJA" ) , .F. )
        cHtml += '                                    </font>' + CRLF  
        cHtml += '                                </td>' + CRLF
        cHtml += '                            </tr>' + CRLF
        cHtml += '                            <tr>' + CRLF
        cHtml += '                                <td>' + CRLF 
        cHtml += '                                    <b>' + CRLF 
        cHtml += '                                        <font face="arial" size="2">' + CRLF  
        cHtml += '                                            Nome Fantasia:'
        cHtml += '                                        </font>' + CRLF  
        cHtml += '                                    </b>' + CRLF 
        cHtml += '                                </td>' + CRLF
        cHtml += '                                <td>' + CRLF 
        cHtml += '                                    <font face="arial" size="2">' + CRLF  
        cHtml += PosAlias( "SA2" , SC8->(C8_FORNECE+C8_LOJA) , NIL , "A2_NREDUZ" , RetOrder( "SA2" , "A2_FILIAL+A2_COD+A2_LOJA" ) , .F. )
        cHtml += '                                    </font>' + CRLF  
        cHtml += '                                </td>' + CRLF
        cHtml += '                            </tr>' + CRLF
        cHtml += '                    </font>' + CRLF
        cHtml += '                </td>' + CRLF 
        cHtml += '            </tr>' + CRLF
        cHtml += '        </table>' + CRLF
        cHtml += '        <table width="800" border="1" cellspacing="1" cellpadding="2">' + CRLF
        cHtml += '            <tr  bgcolor="#cccccc">' + CRLF
        cHtml += '                <td width="60">' + CRLF 
        cHtml += '                    <b>' + CRLF 
        cHtml += '                        <font face="arial" size="2">' + CRLF  
        cHtml += '                            Código do Produto'  
        cHtml += '                        </font>' + CRLF  
        cHtml += '                    </b>' + CRLF 
        cHtml += '                </td>' + CRLF
        cHtml += '                <td width="58">' + CRLF 
        cHtml += '                    <b>' + CRLF 
        cHtml += '                        <font face="arial" size="2">' + CRLF  
        cHtml += '                            Descrição'  
        cHtml += '                        </font>' + CRLF  
        cHtml += '                    </b>' + CRLF 
        cHtml += '                </td>' + CRLF
        cHtml += '                <td width="72">' + CRLF 
        cHtml += '                    <b>' + CRLF 
        cHtml += '                        <font face="arial" size="2">' + CRLF  
        cHtml += '                            Quantidade'  
        cHtml += '                        </font>' + CRLF  
        cHtml += '                    </b>' + CRLF 
        cHtml += '                </td>' + CRLF
        cHtml += '                <td width="46">' + CRLF 
        cHtml += '                    <b>' + CRLF 
        cHtml += '                        <font face="arial" size="2">' + CRLF  
        cHtml += '                            Marca'  
        cHtml += '                        </font>' + CRLF  
        cHtml += '                    </b>' + CRLF 
        cHtml += '                </td>' + CRLF
        cHtml += '                <td width="49">' + CRLF 
        cHtml += '                    <b>' + CRLF 
        cHtml += '                        <font face="arial" size="2">' + CRLF  
        cHtml += '                            Modelo'  
        cHtml += '                        </font>' + CRLF  
        cHtml += '                    </b>' + CRLF 
        cHtml += '                </td>' + CRLF
        cHtml += '                <td width="109">' + CRLF 
        cHtml += '                    <b>' + CRLF 
        cHtml += '                        <font face="arial" size="2">' + CRLF  
        cHtml += '                            Garantia'  
        cHtml += '                        </font>' + CRLF  
        cHtml += '                    </b>' + CRLF 
        cHtml += '                </td>' + CRLF
        cHtml += '                <td width="107">' + CRLF 
        cHtml += '                    <b>' + CRLF 
        cHtml += '                        <font face="arial" size="2">' + CRLF  
        cHtml += '                            Prazo de Entrega'  
        cHtml += '                        </font>' + CRLF  
        cHtml += '                    </b>' + CRLF 
        cHtml += '                </td>' + CRLF  
        cHtml += '                <td width="102">' + CRLF 
        cHtml += '                    <b>' + CRLF 
        cHtml += '                        <font face="arial" size="2">' + CRLF  
        cHtml += '                            Valor Total'  
        cHtml += '                        </font>' + CRLF  
        cHtml += '                    </b>' + CRLF 
        cHtml += '                </td>' + CRLF
        cHtml += '            </tr>' + CRLF
        cHtml += '            <tr>' + CRLF
        cHtml += '                <td>' + CRLF 
        cHtml += SC8->C8_PRODUTO  
        cHtml += '                </td>' + CRLF
        cHtml += '                <td>' + CRLF 
        cHtml += '                    <font face="arial" size="2">' + CRLF  
        cHtml += PosAlias( "SB1" , SC8->C8_PRODUTO , NIL , "B1_DESC" , RetOrder( "SB1" , "B1_FILIAL+B1_COD" ) , .F. )
        cHtml += '                    </font>' + CRLF      
        cHtml += '                </td>' + CRLF
        cHtml += '                <td>' + CRLF 
        cHtml += '                    <font face="arial" size="2">' + CRLF  
        cHtml += Transform( SC8->C8_QUANT , GetSx3Cache( "C8_QUANT" , "X3_PICTURE" ) )
        cHtml += '                    </font>' + CRLF      
        cHtml += '                </td>' + CRLF
        cHtml += '                <td>' + CRLF 
        cHtml += SC8->C8_XMARCA
        cHtml += '                </td>' + CRLF
        cHtml += '                <td>' + CRLF 
        cHtml += SC8->C8_XMODELO
        cHtml += '                </td>' + CRLF
        cHtml += '                <td>' + CRLF 
        cHtml += '                    <font face="arial" size="2">' + CRLF  
        cHtml += Transform( SC8->C8_XGARA , GetSx3Cache( "C8_XGARA" , "X3_PICTURE" ) )
        cHtml += '                    </font>' + CRLF  
        cHtml += '                </td>' + CRLF
        cHtml += '                <td>' + CRLF 
        cHtml += '                    <font face="arial" size="2">' + CRLF  
        cHtml += Transform( SC8->C8_PRAZO , GetSx3Cache( "C8_PRAZO" , "X3_PICTURE" ) )
        cHtml += '                    </font>' + CRLF  
        cHtml += '                </td>' + CRLF 
        cHtml += '                <td>' + CRLF 
        cHtml += '                    <font face="arial" size="2">' + CRLF  
        cHtml += Transform( SC8->C8_TOTAL , GetSx3Cache( "C8_TOTAL" , "X3_PICTURE" ) )
        cHtml += '                    </font>' + CRLF  
        cHtml += '                </td>' + CRLF
        cHtml += '            </tr>' + CRLF
        cHtml += '            <tr bgcolor="#cccccc">' + CRLF
        cHtml += '                <td colspan="8">' + CRLF 
        cHtml += '                    <b>' + CRLF 
        cHtml += '                        <font face="arial" size="2">' + CRLF  
        cHtml += '                            Proposta do Fornecedor'  
        cHtml += '                        </font>' + CRLF  
        cHtml += '                    </b>' + CRLF 
        cHtml += '                </td>' + CRLF 
        cHtml += '            </tr>' + CRLF
        cHtml += '            <tr>' + CRLF 
        cHtml += '                <td colspan="8">' + CRLF 
        cHtml += SC8->C8_XPROP1
        cHtml += '                </td>' + CRLF 
        cHtml += '            </tr>' + CRLF
        IF !( lOk )
            cHtml += '            <tr bgcolor="#cccccc">' + CRLF
            cHtml += '                <td colspan="8">' + CRLF 
            cHtml += '                    <b>' + CRLF 
            cHtml += '                        <font face="arial" size="2">' + CRLF  
            cHtml += '                            Justificativa do Solicitante (Motivo da Reprovação)'
            cHtml += '                        </font>' + CRLF  
            cHtml += '                    </b>' + CRLF 
            cHtml += '                </td>' + CRLF 
            cHtml += '            </tr>' + CRLF
            cHtml += '            <tr>' + CRLF 
            cHtml += '                <td colspan="8">' + CRLF 
            cHtml += cMsgReprova
            cHtml += '                </td>' + CRLF 
            cHtml += '            </tr>' + CRLF
        EndIF
        cHtml += '        </table>' + CRLF
        cHtml += '        <hr/>' + CRLF
        cHtml += '                        </table>' + CRLF
    Next nSC8Recno
    cHtml += '                    </font>' + CRLF 
    cHtml += '                </td">' + CRLF
    cHtml += '            </tr>' + CRLF
    cHtml += '            <tr>' + CRLF
    cHtml += '                <td>' + CRLF
    cHtml += '                    <br />' + CRLF
    cHtml += '                    <font face="arial" size="2" color="#CC0000">' + CRLF
    IF ( lOk )
        IF ( lAprova )
            cHtml += '                    OBS.:'
            cHtml += '                    <br />' + CRLF
            cHtml += '                    (1) APROVADA PELO SOLICITANTE EM: ' + Dtoc( Date() ) + " AS " + Time() + " HORAS"
            cHtml += '                    <br />' + CRLF
            cHtml += '                    (2) APROVADA POR: ' + StaticCall( NDJLIB014 , RetCodUsr ) + ' ' + StaticCall( NDJLIB014 , UsrRetName )
        Else
            cHtml += '                    OBS.:'
            cHtml += '                    <br />' + CRLF
            cHtml += '                    (1) Para APROVAR a COTAÇÃO acesse PMS e selecione a opção &quot;Projeto &gt; Aprovação de Cotação&quot;'
            cHtml += '                    <br />' + CRLF
            cHtml += '                    (2) ANALISADA POR: ' + StaticCall( NDJLIB014 , RetCodUsr ) + ' ' + StaticCall( NDJLIB014 , UsrRetName )
        EndIF
    Else
        cHtml += '                        OBS.:'
        cHtml += '                        <br />' + CRLF
        cHtml += '                        (1) REPROVADA PELO SOLICITANTE EM: ' + Dtoc( Date() ) + " AS " + Time() + " HORAS"
        cHtml += '                        <br />' + CRLF
        cHtml += '                        (2) REPROVADA POR: ' + StaticCall( NDJLIB014 , RetCodUsr ) + ' ' + StaticCall( NDJLIB014 , UsrRetName )
    EndIF    
    cHtml += '                        <br />' + CRLF 
    cHtml += '                        <br />' + CRLF 
    cHtml += '                        <br />' + CRLF 
    cHtml += '                    </font>' + CRLF 
    cHtml += '                 </td>' + CRLF 
    cHtml += '            </tr>' + CRLF
    cHtml += '            <tr bgcolor="#BEBEBE">'
    cHtml += '                <td>' + CRLF 
    cHtml += '                    .'  
    cHtml += '                </td>' + CRLF 
    cHtml += '            </tr>' + CRLF
    cHtml += '        </table>' + CRLF
    cHtml += '    </body>' + CRLF
    cHtml += '</html>' + CRLF
    
    DEFAULT lRmvCRLF := .F.
    IF ( lRmvCRLF )
        cHtml := StrTran( cHtml , CRLF , "" )
    EndIF

Return( cHtml )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        lRecursa    := __Dummy( .F. )
        __cCRLF        := NIL
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
