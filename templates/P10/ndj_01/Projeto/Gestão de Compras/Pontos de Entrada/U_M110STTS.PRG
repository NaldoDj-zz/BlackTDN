#INCLUDE "NDJ.CH"
/*/
	Programa: 	M110STTS
	Data:		17/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    1 ) Reabilitar o Help se o parametro NDJ_SCNOHL estiver True
				2 ) Excluir Vinclulos de Documentos da SC com a Base de Conhecimento na Exclusao da SC
				3 ) Vincular o Documento da SC na Base de Conhecimento AC9
				4 ) Enviar e-mail de acordo com o Status da SC
/*/
User Function M110STTS()

	Local aArea			:= GetArea()
	Local aSC1Area		:= SC1->( GetArea() )
	Local aRecno		:= {}

	Local cA110Num		:= ParamIxb[1]

	Local lFT340Grv		:= .F.

	Local oException

	TRYEXCEPTION

        IF GetNewPar("NDJ_SCNOHL",.F.)
			HelpInDark(.F.)
		EndIF

		IF IsInCallStack( "A110Deleta" )

			//Garanto o Posicionamento no Documento a Ser Excluido
			StaticCall( U_FT340MNU , LinkedFile , cA110Num )
            //Carrega a Variavel de Memoria com o Conteudo do Campo
            StaticCall( NDJLIB001 , SetMemVar , "ACB_CODOBJ" , ACB->ACB_CODOBJ , .T. , .T. )
            //Carrega a Variavel de Memoria com o Conteudo do Campo
            StaticCall( NDJLIB001 , SetMemVar , "ACB_OBJETO" , AllTrim( ACB->ACB_OBJETO ) , .T. , .T. )
			IF ACB->( !Eof() .and. !Bof() )
				lFT340Grv := .T.
				//Exclui o Relacionamento na AC9
				StaticCall( U_FT340GRV , DocSc1ToAC9 , 3 , @cA110Num )
				//Exclui o Documento
				FT340Grv( 3 , @aRecno )
				StaticCall( U_FT340GRV , FT340Commit )
			EndIF	
		
		Else	//Inclusao e/ou Alteracao
			
			//Vincular o Documento da SC na Base de Conhecimento AC9
			StaticCall( U_FT340GRV , DocSc1ToAC9 , 1 , @cA110Num )

			//Carrego as variaveis que serao utilizadas no Ponto de Entrada PMA220AB
            StaticCall( NDJLIB001 , SetMemVar , "__c220NRSC"   , cA110Num )
            StaticCall( NDJLIB001 , SetMemVar , "__l220Inclui" , INCLUI )
            StaticCall( NDJLIB001 , SetMemVar , "__l220Altera" , ALTERA )

		EndIF

		//Forca o Commit dos Destinos da SC1
        StaticCall( U_NDJA001 , SZ2SZ3Commit )

		//Forca o Commit das Alteracoes de Empenho
        StaticCall( U_NDJBLKSCVL , SZ0TTSCommit )

	CATCHEXCEPTION USING oException

		IF ( lFT340Grv )
			StaticCall( U_FT340GRV , FT340Commit )
		EndIF

		IF ( ValType( oException ) == "O" )
			ConOut( oException:Description , oException:ErrorStack )
		EndIF

	ENDEXCEPTION

	//Libera os Locks Pendentes
    StaticCall( NDJLIB003 , AliasUnLock )

	SendMail( @cA110Num )	//By Noronha

	RestArea( aSC1Area )
	RestArea( aArea )

Return( .T. )

/*/
	Funcao: 	SendMail()
	Autor:		Noronha
	Data:		10/12/2010
	Uso:		Envio de Email
	Sintaxe:	StaticCall( U_M110STTS , SendMail , cA110Num )
/*/
Static Function SendMail( cA110Num )

	Local aArea			:= GetArea()
	Local aSC1Area		:= SC1->( GetArea() )
	
	Local cC1XNumSc
	
	Local cSC1Filial	:= xFilial( "SC1" )
	Local cSC1KeySeek	:= ( cSC1Filial + cA110Num )
	
	Local lC1XREFCNT	:= .F.
	
	Local nSC1Order		:= RetOrder( "SC1" , "C1_FILIAL+C1_NUM+C1_ITEM" )

	BEGIN SEQUENCE

		SC1->( dbSetOrder( nSC1Order ) )
		IF SC1->( !MsSeek( cSC1KeySeek , .F. ) )
			BREAK
		EndIF

		IF !( Type( "INCLUI" ) == "L" )
			Private INCLUI := .F.
		EndIF

		// 10/12/10 - Noronha
		// Envio de email ao solicitante, gerente e responsaveis por compras.
		IF ( INCLUI )
            lC1XREFCNT            := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_XREFCNT" , .T. )
			DEFAULT lC1XREFCNT	:= .F.
			IF ( lC1XREFCNT )
                cC1XNumSc        := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_XNUMSC" , .T. )
				lC1XREFCNT		:= !Empty( cC1XNumSc )
				IF ( lC1XREFCNT )
                    U_NDJ0143( @cA110Num )  // Chama a rotina de envio de email na Inclusao da SC
				EndIF
			Else
                U_NDJ0143( @cA110Num )         // Chama a rotina de envio de email na Inclusao da SC
			EndIF	
			BREAK
		EndIF

		IF !( Type( "ALTERA" ) == "L" )
			Private ALTERA := .F.
		EndIF

		IF ( ALTERA )
            U_NDJ0144( @cA110Num )  //Chama a rotina de envio de email na Alteracao da SC
	    EndIF

	END SEQUENCE

	RestArea( aSC1Area )
	RestArea( aArea )

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