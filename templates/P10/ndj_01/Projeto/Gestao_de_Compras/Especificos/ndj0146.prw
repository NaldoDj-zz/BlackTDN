#INCLUDE "NDJ.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NDJ0146   º Autor ³ Jose Carlos Noronhaº Data ³  10/12/10  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                                                            º±±
±±º          ³ Rotina especifica para envio de email da LIBERAÇÃO da SC.  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
User Function NDJ0146( nRecno , cNumSC )

    Local aArea            := GetArea()
    Local aSC1Area        := SC1->( GetArea() )
    Local aCodUsr        := {}

    Local bKeySeek
    
    Local cCodUsr
    Local cKeySeek
    Local cC1XNumSc

    Local lPorItem      := StaticCall( NDJLIB001 , GetMemVar , "__lSCPorItem" )
    Local lC1XREFCNT    := .F.

    Local nCodUsr
    Local nSC1Order

    Private aNDJCom01    := StaticCall( NDJLIB001 , NDJMV2Mail , "NDJ_COM01" )    //email dos responsaveis por compras na NDJ

    IF ( lPorItem == NIL )
        Pergunte( "MTA110" , .F. )
        lPorItem            := ( MV_PAR02 == 1 ) //Define a Aprovacao Por Item baseado no MV_PAR02 do Grupo MTA110
        StaticCall( NDJLIB004 , SetPublic , "__lSCPorItem" , lPorItem , "L" , 1 , .T. )
    EndIF

    SC1->( MsGoto( nRecno ) )

    lC1XREFCNT            := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_XREFCNT" , .T. )
    DEFAULT lC1XREFCNT    := .F.
    IF ( lC1XREFCNT )
        cC1XNumSc        := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_XNUMSC" , .T. )
        lC1XREFCNT        := !Empty( cC1XNumSc )
    EndIF

    IF ( lC1XREFCNT )

        nSC1Order        := RetOrder( "SC1" , "C1_FILIAL+C1_XNUMSC+C1_XITEMSC" )

        IF ( lPorItem )
            bKeySeek    := { || C1_FILIAL+C1_XNUMSC+C1_XITEMSC }
        Else
            bKeySeek    := { || C1_FILIAL+C1_XNUMSC }
        EndIF    

    Else

        nSC1Order        := RetOrder( "SC1" , "C1_FILIAL+C1_NUM+C1_ITEM" )

        IF ( lPorItem )
            bKeySeek    := { || C1_FILIAL+C1_NUM+C1_ITEM }
        Else
            bKeySeek    := { || C1_FILIAL+C1_NUM }
        EndIF    

    EndIF

    cKeySeek        := SC1->( Eval( bKeySeek ) )

    SC1->( dbSetOrder( nSC1Order ) )
    SC1->( dbSeek( cKeySeek , .F. ) )

    While SC1->( !Eof() .and. Eval( bKeySeek ) == cKeySeek )

        cCodUsr    := SC1->C1_XCODCOM
        nCodUsr := SC1->( aScan( aCodUsr , { |aElem| aElem[ 1 ] == cCodUsr } ) )
        IF ( nCodUsr == 0 )
            SC1->( aAdd( aCodUsr , { cCodUsr , AllTrim( UsrFullName( cCodUsr ) ) , UsrRetName( C1_USER ) , Array( 0 ) } ) )
            nCodUsr := Len( aCodUsr )
        EndIF

        SC1->( aAdd( aCodUsr[ nCodUsr ][ 4 ] , Recno() ) )

        SC1->( dbSkip() )

    End While

    CargaItens( @cNumSC , @aCodUsr , @lC1XREFCNT )

    RestArea( aSC1Area )
    RestArea( aArea )

Return( NIL )

Static Function CargaItens( cNumSC , aCodUsr , lC1XREFCNT )

    Local aItensNF       := {}
    
    Local cB1Cod
    Local cB1Desc
    Local cProject       := ""
    Local cTarefa        := ""
    Local cCCusto        := ""
    Local cC1Filial        := xFilial( "SC1" )
    Local cB1Filial        := xFilial( "SB1" )
    Local cAF8Filial    := xFilial( "AF8" )

    Local cSB1KeySeek
    Local cAF8KeySeek
    
    Local lRejeitada    := .F.
    
    Local nCodUsr
    Local nCodUsrs        := Len( aCodUsr )
    
    Local nRecno
    Local nRecnos
    Local nSC1Recno
    
    Local nSB1Order        := RetOrder( "SB1" , "B1_FILIAL+B1_COD" )
    Local nAF8Order        := RetOrder( "AF8" , "AF8_FILIAL+AF8_PROJET+AF8_DESCRI" )
    
    Private aNumSC        := {}
    Private aNDJEmail    := {}
    Private nNDJEmail    := 0
    
    SB1->( dbSetOrder( nSB1Order ) )

    For nCodUsr := 1 To nCodUsrs
        aItensNF    := {}
        nRecnos     := Len( aCodUsr[ nCodUsr ][ 4 ] )
        lRejeitada    := .F.
        For nRecno := 1 To nRecnos
            nSC1Recno    := aCodUsr[ nCodUsr ][ 4 ][ nRecno ]
            SC1->( dbGoto( nSC1Recno ) )
            IF SC1->( Eof() .or. Bof() )
                Loop
            EndIF
            IF !( lRejeitada )
                lRejeitada    := ( SC1->C1_APROV == "R" )
            EndIF    
             cProject    := SC1->C1_XPROJET
             cAF8KeySeek    := ( cAF8Filial + cProject )
             cSB1KeySeek    := ( cB1Filial + SC1->C1_PRODUTO )
            cB1Cod        := Posicione("SB1",nSB1Order,cSB1KeySeek,"B1_COD")
            cB1Desc        := Posicione("SB1",nSB1Order,cSB1KeySeek,"B1_DESC")
            SB1->( dbSeek( cB1Filial + SC1->C1_PRODUTO ) )
            SC1->(;
                    aAdd( aItensNF ,{;
                                        aCodUsr[ nCodUsr ][ 2 ],;
                                        C1_NUM,;
                                        C1_ITEM,;
                                        cB1Cod,;
                                        cB1Desc,;
                                        Transform(C1_QUANT,"@e 999,999"),;
                                        Transform(C1_XTOTAL,"@e 999,999,999.99"),;
                                        aCodUsr[ nCodUsr ][ 3 ],;
                                         cProject+" - "+Posicione("AF8",nAF8Order,cAF8KeySeek,"AF8_DESCRI"),;
                                        IF( lC1XREFCNT , "Sim" , "Nao" ),;
                                        IF( lC1XREFCNT , Dtoc( C1_XDTPPAG ) , "//" ),;
                                         C1_XEQUIPA;
                                     };
                         );
            )                         
        Next nRecno
        aNDJEmail    := aItensNF
        nNDJEmail    := Len( aNDJEmail )    
        IF ( nNDJEmail > 0 )
            MsAguarde( { || SC1->( EnviaEmail( @nSC1Recno , @cNumSC , @aCodUsr[ nCodUsr ][ 1 ] , @aCodUsr[ nCodUsr ][ 2 ] , @lRejeitada , @lC1XREFCNT , @cAF8Filial , @nAF8Order ) ) } , "Aguarde, Enviando e-mail..." )
        EndIF
    Next nCodUsr

Return( NIL )

//************************************************************************************************
Static Function EnviaEmail( nSC1Recno , cNumSC , _UserMail , cUserFullName , lRejeitada , lC1XREFCNT , cAF8Filial , nAF8Order )
//************************************************************************************************

    Local aTo            := {}

    Local cBody         := ""
    Local cCC           := ""
    Local i,j
    Local lEmail
    Local cDest1        := StaticCall( NDJLIB014 , UsrRetMail , _UserMail ) // 28-12-2010
    Local cDest2        := ""

    Local cProject
    Local cNomProj
    Local cGerProj
    Local cAF8KeySeek

    SC1->( MsGoto( nSC1Recno ) )

    aEval( aNDJCom01 , { |cMail| cDest2 += ( cMail + ";" ) } )

    cProject     := SC1->C1_XPROJET
    cAF8KeySeek := ( cAF8Filial + cProject )
    cNomProj     := Posicione("AF8",nAF8Order,cAF8KeySeek,"AF8_DESCRI")
    cGerProj     := Posicione("AF8",nAF8Order,cAF8KeySeek,"AF8_XCODGE")

    IF ( lRejeitada )
        cSubject := "REJEICAO S.C n."+cNumSC +" - PROJETO "+cProject+"-"+cNomProj
    Else
        cSubject := "LIBERACAO S.C n."+cNumSC +" - PROJETO "+cProject+"-"+cNomProj
    EndIF    

    cBody :='<html>'
    cBody +='<head>'
    cBody +='<meta http-equiv="Content-Type" content="text/html charset=ISO-8859-1">'
    cBody +='</head>'
    cBody +='<body>'
    cBody +='<table border="0" cellpadding="0" cellspacing="0">'
    cBody +='<tr bgcolor="#eeeeee">'
    cBody +='<td> <img src="' + GetNewPar("NDJ_ELGURL " , "" ) + '"'
    cBody +='border="0"></td>'
    cBody +='</tr>'
    cBody +='<tr bgcolor="#bebebe">'
    cBody +='<td height="20"> <br>'
    cBody +='</td>'
    cBody +='</tr>'
    cBody +='<tr>'
    cBody +='<td><br>'
    IF ( lRejeitada )
        cBody +='<font face="arial" size="2"><b>REJEIÇÃO DE SOLICITAÇÃO DE COMPRAS</b><br>'
    Else
        cBody +='<font face="arial" size="2"><b>LIBERAÇÃO DE SOLICITAÇÃO DE COMPRAS</b><br>'
    EndIF    
    cBody +='<br>'
    cBody +='</font></td>'
    cBody +='</tr>'
    cBody +='<tr>'
    cBody +='<td>'
    cBody +='<font face="arial" size="2">Prezado Comprador '+ cUserFullName + ',<br>'
    cBody +='</font><font face="arial" size="2"><br>'
    IF ( lRejeitada )
        cBody +='A solicitacao de compras No. '+cNumSC+' de sua responsabilidade foi REJEITADA e agora encontra-se BLOQUEADA. '
    Else
        cBody +='A solicitacao de compras No. '+cNumSC+' de sua responsabilidade foi APROVADA. favor verificar e dar continuidade ao processo. '
    EndIF    
    cBody +='<br>'
    cBody +='</font>'
    cBody +='</td>'
    cBody +='</tr>'
    cBody +='<tr>'
    cBody +='<td'
    cBody +='style="vertical-align: top; text-align: right; "><font'
    cBody +='face="arial" size="2">'
    cBody +='<table border="0" cellpadding="0" cellspacing="2" width="100%">'
    cBody +='<tr>'
    cBody +='<td><b><font face="arial" size="2">'
    cBody +='Numero da SC: '+ cNumSC +'<br>'
    cBody +='Data Emissão: '+DTOC(SC1->C1_EMISSAO)+'<br>'
    cBody +='</font></b><br><br></td>'
    cBody +='</tr>'
    cBody += "<tr>"
    cBody += "<td>"  
    cBody += "<table Border=1 width=750>"
    cBody += "    <tr>"
    cBody += "        <font face='arial' size='2'>"
    cBody += "            <td width=30>Comprador</td>"
    cBody += "               <td width=20>Numero</td>"
    cBody += "               <td width=20>Item</td>"
    cBody += "               <td width=30>Codigo</td>"
    cBody += "               <td width=200>Descrição</td>"
    cBody += "               <td width=50>Quantidade</td>"
    cBody += "               <td width=50>Valor Estimado</td>"
    cBody += "               <td width=50>Solicitante</td>"
    cBody += "               <td width=210>Projeto</td>"
    cBody += "           <td width=10>Contrato</td>"
    cBody += "           <td width=15>Prev.1o.Pgto</td>"
    cBody += "        </font>"
    cBody += "    </tr>"
    For i := 1 To nNDJEmail
        
        cBody += "<tr>"
        For j := 1 To 10
            cBody += '<td><font face="arial" size="2">' + aNDJEmail[i,j] + '</font></td>'
        Next j
        cBody += "</tr>"
        
        cBody += "<tr>"
        cBody += "    <font face='arial' size='2'>"
        cBody += "        <td colspan='8'>"
        cBody += "            <center>Especificacao Tecnica</center>"
        cBody += "        </td>"
        cBody += "    </font>"
        cBody += "</tr>"

        cBody += "<tr>"
        cBody += "    <font face='arial' size='2'>"
        cBody += "        <td colspan='10'>"
        cBody += aNDJEmail[ i ][ 11 ]
        cBody += "        </td>"
        cBody += "    </font>"
        cBody += "</tr>"

    Next i

    cBody +='</table><br><br><br><table><font face="arial" size="2" color="#D3D3D3"><tr><td>NDJ0146</td></tr></font></table>'
    cBody +='</body>'
    cBody +='</html>'

    StaticCall( NDJLIB002 , AddMailDest , @aTo , @cDest1 )
    StaticCall( NDJLIB002 , AddMailDest , @aTo , @cDest2 )

    StaticCall( NDJLIB002 , SendMail , @cSubject , @cBody , @aTo )

Return( NIL )

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
