#INCLUDE "NDJ.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NDJ0144   º Autor ³ Jose Carlos Noronhaº Data ³  07/12/10  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                                                            º±±
±±º          ³ Rotina especifica para envio de email da Solicitacao de    º±±
±±º          ³ compras chamada apartir de menu do PMS.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
User Function NDJ0144( cNumSC )

	Local aArea			:= GetArea()
	Local aSC1Area		:= SC1->( GetArea() )
	Local aCodUsr		:= {}

	Local bKeySeek

	Local cCodUsr
	Local cKeySeek
	Local cC1XNumSc
	Local cSC1Filial	:= xFilial( "SC1" )

	Local lC1XREFCNT	:= .F.

	Local nCodUsr
	Local nSC1Order		:= RetOrder( "SC1" , "C1_FILIAL+C1_NUM+C1_ITEM" )

    Private aNDJCom01	:= StaticCall( NDJLIB001 , NDJMV2Mail , "NDJ_COM01" )	//email dos responsaveis por compras na NDJ

	cKeySeek			:= ( cSC1Filial + cNumSC )

	SC1->( dbSetOrder( nSC1Order ) )
	SC1->( MsSeek( cKeySeek , .F. ) )

    lC1XREFCNT            := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_XREFCNT" , .T. )
	DEFAULT lC1XREFCNT	:= .F.
	IF ( lC1XREFCNT )
        cC1XNumSc        := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_XNUMSC" , .T. )
		lC1XREFCNT		:= !Empty( cC1XNumSc )
	EndIF

	IF ( lC1XREFCNT )

		nSC1Order		:= RetOrder( "SC1" , "C1_FILIAL+C1_XNUMSC+C1_XITEMSC" )
		bKeySeek		:= { || C1_FILIAL+C1_XNUMSC }

	Else

		nSC1Order		:= RetOrder( "SC1" , "C1_FILIAL+C1_NUM+C1_ITEM" )
		bKeySeek		:= { || C1_FILIAL+C1_NUM }

	EndIF

	cKeySeek			:= SC1->( Eval( bKeySeek ) )

	SC1->( dbSetOrder( nSC1Order ) )

	IF ( lC1XREFCNT )
		SC1->( dbSeek( cKeySeek , .F. ) )
	Else
		SC1->( MsSeek( cKeySeek , .F. ) )
	EndIF	

	While SC1->( !Eof() .and. Eval( bKeySeek ) == cKeySeek )

		cCodUsr	:= SC1->C1_USER
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

	Local aItensNF   	:= {}
	
	Local cB1Cod
	Local cB1Desc
	Local cProject   	:= ""
	Local cTarefa    	:= ""
	Local cCCusto    	:= ""
	Local cC1Filial		:= xFilial( "SC1" )
	Local cB1Filial		:= xFilial( "SB1" )
	Local cAF8Filial	:= xFilial( "AF8" )
	Local cSB1KeySeek

	Local nCodUsr
	Local nCodUsrs		:= Len( aCodUsr )
	
	Local nRecno
	Local nRecnos
	Local nSC1Recno
	
	Local nSB1Order		:= RetOrder( "SB1" , "B1_FILIAL+B1_COD" )
	Local nAF8Order		:= RetOrder( "AF8" , "AF8_FILIAL+AF8_PROJET+AF8_DESCRI" )
	
	Private aNumSC		:={}
    Private aNDJEmail    := {}
    Private nNDJEmail    := 0
	
	SB1->( dbSetOrder( nSB1Order ) )

	For nCodUsr := 1 To nCodUsrs
		aItensNF	:= {}
		nRecnos 	:= Len( aCodUsr[ nCodUsr ][ 4 ] )
		For nRecno := 1 To nRecnos
			nSC1Recno	:= aCodUsr[ nCodUsr ][ 4 ][ nRecno ]
			SC1->( dbGoto( nSC1Recno ) )
			IF SC1->( Eof() .or. Bof() )
				Loop
			EndIF
 			cSB1KeySeek	:= ( cB1Filial + SC1->C1_PRODUTO )
			cB1Cod		:= Posicione("SB1",nSB1Order,cSB1KeySeek,"B1_COD")
			cB1Desc		:= Posicione("SB1",nSB1Order,cSB1KeySeek,"B1_DESC")
			SB1->( dbSeek( cB1Filial + SC1->C1_PRODUTO ) )
			SC1->( aAdd(aItensNF,{;
									C1_NUM,;
									C1_ITEM,;
									cB1Cod,;
									cB1Desc,;
									Transform(C1_QUANT,"@e 999,999"),;
									Transform(C1_XTOTAL,"@e 999,999,999.99"),;
									IF( lC1XREFCNT , "Sim" , "Nao" ),;
									IF( lC1XREFCNT , Dtoc( C1_XDTPPAG ) , "//" );
								 };
					   );
				 )
		Next nRecno
        aNDJEmail    := aItensNF
        nNDJEmail    := Len( aNDJEmail )    
        IF ( nNDJEmail > 0 )
			MsAguarde( { || SC1->( EnviaEmail( @nSC1Recno , @cNumSC , @aCodUsr[ nCodUsr ][ 1 ] , @aCodUsr[ nCodUsr ][ 2 ] , @lC1XREFCNT , @cAF8Filial , @nAF8Order ) ) } , "Aguarde, Enviando e-mail..." )
		EndIF
	Next nCodUsr

Return( NIL )

//************************************************************************************************
Static Function EnviaEmail( nSC1Recno , cNumSC , _UserMail , cUserFullName , lC1XREFCNT , cAF8Filial , nAF8Order )
//************************************************************************************************

	Local aTo			:= {}
	Local cBody         := ""
	Local cCC           := ""
	Local i,j

    Local cDest1           := StaticCall( NDJLIB014 , UsrRetMail , _UserMail )
	Local cDest2		:= ""
	Local cDest3   		:= ""
	
	Local cAF8KeySeek

	SC1->( MsGoto( nSC1Recno ) )

    aEval( aNDJCom01 , { |cMail| cDest3 += ( cMail + ";" ) } )    

	cProject 	:= SC1->C1_XPROJET
	cAF8KeySeek	:= ( cAF8Filial + cProject )
	cNomProj 	:= Posicione("AF8",nAF8Order,cAF8KeySeek,"AF8_DESCRI")
	cGerProj 	:= Posicione("AF8",nAF8Order,cAF8KeySeek,"AF8_XCODGE")
    cDest2       := StaticCall( NDJLIB014 , UsrRetMail , cGerProj )

	cSubject := "ALTERACAO S.C n."+ cNumSC +" - PROJETO "+cProject+"-"+cNomProj
	
	cBody :='<html>'
	cBody +=	'<head>'
	cBody +=		'<meta http-equiv="Content-Type" content="text/html charset=ISO-8859-1">'
	cBody +=	'</head>'
	cBody +='<body>'
	cBody +=	'<div marginheight="0" marginwidth="0">'
	cBody +=	'<table border="0" cellpadding="0" cellspacing="0">'
	cBody +=		'<tbody>'
    cBody +=            '<tr bgcolor="#eeeeee"><td> <img src="' + GetNewPar("NDJ_ELGURL " , "" ) + '" border="0"></td></tr>'
	cBody +=			'<tr bgcolor="#bebebe"><td height="20"></td></tr>'
	cBody +=			'<tr><td><font face="arial" size="2"><br><b>ALTERAÇÃO DA SOLICITAÇÃO DE COMPRAS No. '+cNumSC+'</b></br><p></font></td></tr>'
	cBody +=			'<tr><td><p><font face="arial" size="2">Prezado Controlador,</p>'
	cBody +=					'<p>A solicitação de compras foi alterada. Favor verificar e dar continuidade ao processo: </p></font>'
	cBody +=			'</td></tr></table>'
	cBody +=	'<table border="0" cellpadding="0" cellspacing="0">'
	cBody +='<tr><td><font face="arial" size="2">Numero da SC:</td><td></font><font face="arial" size="2">'+cNumSC+'</td></tr></font>'
	cBody +='<tr><td><font face="arial" size="2">Data Emissao:</td><td></font><font face="arial" size="2">'+DTOC(SC1->C1_EMISSAO)+'</td></tr></font>'
	cBody +='<tr><td><font face="arial" size="2">Projeto:</td><td></font><font face="arial" size="2">'+SC1->C1_XPROJET+"-"+cNomProj+'</td></tr></font>'
	cBody +='<tr><td><font face="arial" size="2">Tarefa:</td><td></font><font face="arial" size="2">'+SC1->C1_XTAREFA+'</td></tr></font>'
	cBody +='<tr><td><font face="arial" size="2">Centro de Custo:</td><td></font><font face="arial" size="2">'+SC1->C1_CC+'</td></tr></font>'
	cBody +=	'</table>'
	cBody +=	'<br>'
	cBody +=	'<br>'
	cBody += 	"<Table Border=1 width=750>"
	cBody += '<TR bgcolor="#BEBEBE">'
	cBody += '<font face="arial" size="2">'
	cBody += "   <td width=30>Numero</td>"
	cBody += "   <td width=30>Item</td>"
	cBody += "   <td width=150>Codigo</td>"
	cBody += "   <td width=320>Descrição</td>"
	cBody += "   <td width=100>Quantidade</td>"
	cBody += "   <td width=100>Valor</td>"
	cBody += "   <td width=10>Contrato</td>"
	cBody += "   <td width=15>Prev.1o.Pgto</td>"
	cBody += "</font>"
	cBody += "</TR>"

    For i:=1 to len(aNDJEmail)
		cBody += "<tr>"
        For j:=1 to len(aNDJEmail[i])
            cBody += '<td><font face="arial" size="2">'+ aNDJEmail[i,j] + '</font></td>'
		Next
		cBody += "</tr>"
	Next

	cBody += "</Table><P>"
	
	cBody += '<tr><td><br><br>'
    cBody += '<font face="arial" size="2" color="#D3D3D3"><TR><TD>NDJ0144</td></tr></font></Table>'
	cBody +='</body>'
	cBody +='</html>'

    StaticCall( NDJLIB002 , AddMailDest , @aTo , @cDest1 )
    StaticCall( NDJLIB002 , AddMailDest , @aTo , @cDest2 )
    StaticCall( NDJLIB002 , AddMailDest , @aTo , @cDest3 )

    StaticCall( NDJLIB002 , SendMail , @cSubject , @cBody , @aTo )

Return( NIL )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
		lRecursa	:= __Dummy( .F. )
		__cCRLF		:= NIL
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )