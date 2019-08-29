#INCLUDE "NDJ.CH"
/*/
    Programa:     MT110CON
    Data:        17/11/2010
    Autor:        Marinaldo de Jesus
    Descricao:    Implementação do Ponto de Entrada MT110CON Executado na funcao A110Grava do Programa MATA110
/*/
User Function MT110CON()

    Local cA110Num
    
    Local oException
    
    TRYEXCEPTION
    
        cA110Num := ParamIxb[1]
        
        PutHlpInD()
        
        IsInA110Del( cA110Num )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
            ConOut( oException:Description , oException:ErrorStack )
        EndIF

    ENDEXCEPTION

Return( .T. )

/*/
    Programa:     IsInA110Del
    Data:        21/03/2011
    Autor:        Marinaldo de Jesus
    Descricao:    Verifica se esta em processo de Delecao da Solicitacao de Compras e Envia e-mail aos Compradores.
/*/
Static Function IsInA110Del( cA110Num )

    Local aArea            := GetArea()
    Local aSC1Area        := SC1->( GetArea() )
    Local aTo            := {}

    Local bSendMail

    Local cBody
    Local cSubject
    
    Local cC1Filial        := xFilial( "SC1" )
    Local cAF8Filial    := xFilial( "AF8" )
    Local cAF8XCODGE
    Local cC1KeySeek
    
    Local nSC1Order        := RetOrder( "SC1" , "C1_FILIAL+C1_NUM+C1_ITEM" )
    Local nAF8Order        := RetOrder( "AF8" , "AF8_FILIAL+AF8_PROJET" )
    
    Local lA110Deleta    := .F.

    BEGIN SEQUENCE

        lA110Deleta    := IsInCallStack( "A110Deleta" )

        IF !( lA110Deleta )
            BREAK
        EndIF

        AddMail( @aTo , __cUserID )

        SC1->( dbSetOrder( nSC1Order ) )
        cC1KeySeek := ( cC1Filial + cA110Num )
        IF SC1->( dbSeek( cC1Filial + cA110Num , .F. ) )
            
            While SC1->( !Eof() .and. C1_FILIAL + C1_NUM == cC1KeySeek )

                cAF8XCODGE := SC1->( Posicione( "AF8" , nAF8Order , cAF8Filial + C1_XPROJET , "AF8_XCODGE" ) )

                AddMail( @aTo , SC1->C1_USER )
                AddMail( @aTo , SC1->C1_XCODGE )
                AddMail( @aTo , cAF8XCODGE )

                SC1->( dbSkip() )

            End While

        EndIF

        StaticCall( NDJLIB002 , AddMailDest , @aTo , GetNewPar("NDJ_ECOM","ndjadvpl@gmail.com") )
        cSubject    := OemToAnsi( "EXCLUSAO DE SC: " + cA110Num )
        cBody        := BuildHtml( @cA110Num , .T. )
        bSendMail    := { || StaticCall( NDJLIB002 , SendMail , @cSubject , @cBody , @aTo ) }

        MSAguarde( bSendMail , "Enviando e-mail aos compradores", "aguarde..." , .F. )

    END SEQUENCE

    RestArea( aSC1Area )
    RestArea( aArea )

Return( lA110Deleta )

/*/
    Funcao: AddMail
    Autor:    Marinaldo de Jesus
    Data:    08/04/2011
    Uso:    Adicionar um e-mail valido
/*/
Static Function AddMail( aMailList , cCodUser )
    Local cUserMail := StaticCall( NDJLIB014 , UsrRetMail , cCodUser )
Return( StaticCall( NDJLIB002 , AddMailDest , @aMailList , @cUserMail ) )

/*/
    Funcao: BuildHtml
    Autor:    Marinaldo de Jesus
    Data:    03/01/2011
    Uso:    Monta o HTML de Solicitacao de Contrato
/*/
Static Function BuildHtml( cA110Num , lRmvCRLF )

    Local cHtml         := ""

    BEGIN SEQUENCE

        cHtml += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' + CRLF
        cHtml += '<html xmlns="http://www.w3.org/1999/xhtml">' + CRLF 
        cHtml += '    <head>' + CRLF 
        cHtml += '        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />' + CRLF 
        cHtml += '        <title>NDJ - ENVIO DE E-MAIL - Exclusão de Solicitação de Compras</title>' + CRLF 
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
        cHtml += '                            EXCLUSÃO DE SOLICITAÇÃO DE COMPRAS'
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
        cHtml += '                            Prezado(s) Comprador(es),'
        cHtml += '                        </font>' + CRLF 
        cHtml += '                        <font face="arial" size="2">' + CRLF 
        cHtml += '                            <br />' + CRLF
        cHtml += '                            <br />' + CRLF
        cHtml += ' A solicitação de Compras: ' + cA110Num + ' foi excluída pelo projeto. Favor providenciar o cancelamento do processo de compras/contratação.'  
        cHtml += '                        </font>' + CRLF
        cHtml += '                        <br />' + CRLF
        cHtml += '                    </p>' + CRLF 
        cHtml += '                </td>' + CRLF
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

    END SEQUENCE        

Return( cHtml )

/*/
    Sera utilizado para desabilitar o Help durante o Processo de Gravacao da Solicitacao de Compras
    Motivo: Existe uma nao conformidade no sistema que tenta criar variaveis de memoria para os campos
    AFG_ALI_WT e AFG_REC_WT
/*/
Static Function PutHlpInD()
    IF GetNewPar("NDJ_SCNOHL",.F.)
        HelpInDark(.T.)
    EndIF    
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
