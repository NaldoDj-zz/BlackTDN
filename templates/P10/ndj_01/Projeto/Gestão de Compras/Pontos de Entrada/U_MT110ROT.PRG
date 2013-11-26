#INCLUDE "NDJ.CH"
/*/
	Funcao: 	MT110ROT
	Autor:		Marinaldo de Jesus
	Data:		04/11/2010
	Descricao:	Implementacao do Ponto de Entrada MT110ROT para a Inclusao de Novas Opcoes no Menu do aRotina do programa MATA110
/*/
User Function MT110ROT()

	Local aRotina	:= {}
	Local aMnuPopUP	:= {}

	Local nIndex	:= 0
	Local nOpcRot	:= 0
	Local nIndexAdd	:= 0

	BEGIN SEQUENCE

		aRotina		:= ParamIxb

		IF !( ValType( aRotina ) == "A" )
			BREAK
		EndIF

		nIndex		:= aScan( aRotina , { |aElem| Upper( "A110Aprov" ) $ Upper( aElem[2] ) } )

		IF ( nIndex > 0 ) //Achou a Rotina de Aprovacao
		
			IF StaticCall( U_MT120BRW , IsBuyer )	//Se For Comprador
			
				nOpcRot	:= aRotina[nIndex][4]
				nOpcRot := 2 //Estou Chumbando a opcao 2 pois por algum motivo, a opcao 7 padrao estava ocasionando erro. 
	
				//Adiciona a Opcao de Enviar para Pre-Analise
				aAdd( aMnuPopUP , aClone( aRotina[nIndex] ) )
				nIndexAdd := Len( aMnuPopUP )
				aMnuPopUP[nIndexAdd][1] := OemToAnsi( "Pré-Analise" )
                aMnuPopUP[nIndexAdd][2] := "StaticCall(U_MT110ROT,NDJMt110,"+AllTrim(Str(NDJ_PRE_ANALISE))+","+AllTrim(Str(nOpcRot))+")"
		
                //Adiciona a Opcao de NDJ_SUSPENDER
				aAdd( aMnuPopUP , aClone( aRotina[nIndex] ) )
				nIndexAdd := Len( aMnuPopUP )
				aMnuPopUP[nIndexAdd][1] := OemToAnsi( "Suspender" )
                aMnuPopUP[nIndexAdd][2] := "StaticCall(U_MT110ROT,NDJMt110,"+AllTrim(Str(NDJ_SUSPENDER))+","+AllTrim(Str(nOpcRot))+")"
	
				//Mantem a Opcao Padrao
				aAdd( aMnuPopUP , aClone( aRotina[nIndex] ) )
				nIndexAdd := Len( aMnuPopUP )
				aMnuPopUP[nIndexAdd][1] := OemToAnsi( "Liberação" )
                aMnuPopUP[nIndexAdd][2] := "StaticCall(U_MT110ROT,NDJMt110,"+AllTrim(Str(NDJ_APROVACAO_PADRAO))+","+AllTrim(Str(nOpcRot))+")"
		
				//Substitui a opcao padrao por um Sub-Menu (pop-up)
				aRotina[nIndex][2] := aMnuPopUP
	
			Else

				//Informa ao Usuário, não comprador, que opção não disponível.
				aRotina[nIndex][2] := "Help( '' , 1 , 'A110Aprov' , NIL , OemToAnsi( 'Opção Disponível apenas aos Gestores do Módulo de Compras' ) , 1 , 0 )"

			EndIF
			
		EndIF

	END SEQUENCE

Return( aRotina )

/*/
    Funcao:     NDJMt110
	Autor:		Marinaldo de Jesus
	Data:		04/11/2010
	Descricao:	Incluir Tratamento de Pre-Analise e Suspencao de Pedido.
/*/
Static Function NDJMt110( nOpc , nOpcRot )

	Local bPadrao		:= { || SC1->( A110Aprov( "SC1" , @nRecno , @nOpcRot ) ) }
	Local bSetKey		:= SetKey( VK_F12 , { || Pergunte( "MTA110" , .T. ) } )

	Local cNumSC
	Local cAprov
	Local cLastAprov

	Local nRecno		:= SC1->( Recno() )
	
	Local lSendMail		:= .F.
	Local lPorItem		:= .F.
	Local lContinua		:= .F.

	Local cMT110END		:= ""
	Local lMT110END		:= .F.
	Local nMT110END		:= 0

	Local nMT110BLO		:= 0

	BEGIN SEQUENCE

		//Passou pelo Ponto de Entrada MT110BLO
        StaticCall( NDJLIB004 , SetPublic , "__nMT110BLO" , 0 , "N" , 1 , .T. )

		//Verifica se Passou Pela Rotina de Aprovacao ( Ponto de Entrada MT110END )
        StaticCall( NDJLIB004 , SetPublic , "__lMT110END" , .F.	, "L"	, 1	, .T. )
        StaticCall( NDJLIB004 , SetPublic , "__cMT110END" , ""	, "C"	, 0	, .T. )
        StaticCall( NDJLIB004 , SetPublic , "__nMT110END" , 0	, "N"	, 1	, .T. )

		SC1->( MsGoto( nRecno ) )

        IF !( StaticCall( NDJLIB003 , LockSoft , "SC1" ) )
			BREAK
		EndIF

		IF !( Execblock( "MT110VLD" , .F. , .F. , { 4 } ) )
			BREAK
		EndIF

		Pergunte( "MTA110" , .T. )
		lPorItem		:= ( MV_PAR02 == 1 ) //Define a Aprovacao Por Item baseado no MV_PAR02 do Grupo MTA110
        StaticCall( NDJLIB004 , SetPublic , "__lSCPorItem" , lPorItem , "L" , 1 , .T. )

        cNumSC         := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_NUM"  , .T. )

        IF ( nOpc == NDJ_PRE_ANALISE )
    		PutC1Aprov( @nRecno , "1" )
	    	BREAK
		EndIF
		
        IF ( nOpc == NDJ_SUSPENDER )
			PutC1Aprov( @nRecno , "2" )
			//Avalio se De Fato O Status Foi Alterado Antes de Chamar a FAjustesSC
			IF ( PutC1Aprov( @nRecno , "2"  , .F. ) == "2" )
				fAjustesSC( @nRecno  , @cNumSC )	//by Noronha
			EndIF
			BREAK
		EndIF
		
        IF ( nOpc == NDJ_APROVACAO_PADRAO )

			IF !( SC1->C1_APROV $ "1,2" )

				cLastAprov	:= PutC1Aprov( @nRecno , "B" ) //Altero o Status Para Bloqueada para que a aprovacao se de pela Rotina Padrao
				
				Eval( bPadrao )

                lMT110END    := StaticCall( NDJLIB001 , GetMemVar , "__lMT110END" )
				IF !( lMT110END )
					PutC1Aprov( @nRecno , @cLastAprov , .F. , .T. )
					BREAK
				EndIF

                cMT110END    := StaticCall( NDJLIB001 , GetMemVar , "__cMT110END" )
                nMT110END    := StaticCall( NDJLIB001 , GetMemVar , "__nMT110END" )    //C1_APROV: 1->"L";2->"R";3->"B"

				SC1->( MsGoto( nRecno ) )
				cLastAprov	:= SC1->C1_APROV
				IF ( nMT110END == 1 )		//Liberado
					PutC1Aprov( @nRecno , @cLastAprov , .F. , .T. )
				ElseIF ( nMT110END == 2 )	//Reprovado
					PutC1Aprov( @nRecno , @cLastAprov , .F. , .T. , .T. )	//Se o Status for Rejeitado, Bloqueia o Registro para uso C1_MSBLQL == "1"
				ElseIF ( nMT110END == 3 )	//Bloqueado
					PutC1Aprov( @nRecno , @cLastAprov , .F. , .T. )
				Else
					PutC1Aprov( @nRecno , @cLastAprov , .F. , .T. )
				EndIF

				lSendMail	:= .T.

				BREAK

			EndIF

			DO CASE
			CASE ( SC1->C1_APROV == "1" )
				lContinua := MsgYesNo( "Em Pré-Analise. Deseja Continuar?" , "Atenção!!!!" )
				IF !( lContinua )
					BREAK
				EndIF
			CASE ( SC1->C1_APROV == "2" )
				lContinua := MsgYesNo( "Suspensa ou Aguardando Alterações. Deseja Continuar?" , "Atenção!!!!" )
				IF !( lContinua )
					BREAK
				EndIF
			END CASE

			cLastAprov	:= PutC1Aprov( @nRecno , "B" )

			Eval( bPadrao )

            lMT110END    := StaticCall( NDJLIB001 , GetMemVar , "__lMT110END" )
			IF !( lMT110END )
				PutC1Aprov( @nRecno , cLastAprov , .F. , .T. )
				BREAK
			EndIF

            nMT110BLO    := StaticCall( NDJLIB001 , GetMemVar , "__nMT110BLO" )
            cMT110END    := StaticCall( NDJLIB001 , GetMemVar , "__cMT110END" )
            nMT110END    := StaticCall( NDJLIB001 , GetMemVar , "__nMT110END" )    //C1_APROV: 1->"L";2->"R";3->"B"

			SC1->( MsGoto( nRecno ) )
			cLastAprov	:= SC1->C1_APROV
			IF ( nMT110END == 1 )	//Liberado
				PutC1Aprov( @nRecno , @cLastAprov , .F. , .T. )
			ElseIF ( nMT110END == 2 )	//Reprovado
				PutC1Aprov( @nRecno , @cLastAprov , .F. , .T. , .T. )	//Se o Status for Rejeitado, Bloqueia o Registro para uso C1_MSBLQL == "1"
			ElseIF ( nMT110END == 3 )	//Bloqueado
				PutC1Aprov( @nRecno , @cLastAprov , .F. , .T. )
			Else
				PutC1Aprov( @nRecno , @cLastAprov , .F. , .T. )
			EndIF

			lSendMail	:= .T.

			BREAK

		EndIF

	END SEQUENCE

	IF ( lSendMail )
        U_NDJ0146( @nRecno , @cNumSC )  //by Noronha Chamada da rotinade envio de email da aprovacao
	EndIF

	SetKey( VK_F12 , bSetKey )

    StaticCall( NDJLIB003 , AliasUnLock )

Return( NIL )

/*/
	Funcao: 	PutC1Aprov
	Autor:		Marinaldo de Jesus
	Data:		04/11/2010
	Descricao:	Definir o Status da Solicitacao de Compra baseado no Campo C1_XSTATUS.
				  - Permite que o programa padrao seja executado.
				1 - Em Pre-Analise. Programa padrao nao sera executado.
				2 - Suspenso. Programa padrao nao sera executado.
/*/
Static Function PutC1Aprov( nRecno , cStatus , lShowMsg , lForce , lMsBlQl , lC1XREFCNT , lPMTA110 )

	Local aArea			:= GetArea()
	Local aSC1Area		:= SC1->( GetArea() )

	Local bKeySeek

	Local cKeySeek		:= ""
	Local cC1Aprov
	Local cC1XNumSc
	Local cLastAprov

    Local cNUsrAprov    := StaticCall( NDJLIB014 , UsrRetName )

	Local lPorItem		:= .F.

	Local nSC1Recno		:= 0
	Local nSC1Order		:= RetOrder( "SC1" , "C1_FILIAL+C1_NUM+C1_ITEM" )
	
	BEGIN SEQUENCE
		
		DEFAULT lForce		:= .F.
		DEFAULT lMsBlQl		:= ( cStatus == "R" )
		DEFAULT lC1XREFCNT	:= .F.
		DEFAULT lPMTA110	:= .T.

		IF ( lPMTA110 )
		
			Pergunte( "MTA110" , .F. )
	
            lPorItem            := StaticCall( NDJLIB001 , GetMemVar , "__lSCPorItem" )
			DEFAULT lPorItem	:= ( MV_PAR02 == 1 ) //Define a Aprovacao Por Item baseado no MV_PAR02 do Grupo MTA110
	
            StaticCall( NDJLIB004 , SetPublic , "__lSCPorItem" , lPorItem , "L" , 1 , .T. )

		Else

            StaticCall( NDJLIB004 , SetPublic , "__lSCPorItem" , .F. , "L" , 1 , .T. )

		EndIF
	
		SC1->( MsGoto( nRecno ) )

        cLastAprov        := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_APROV" , .T. )

		IF !( lC1XREFCNT )
			IF !( lForce )
				IF !( SC1->C1_APROV $ " 1,2,B" )
					DEFAULT lShowMsg := .T.
					IF ( lShowMsg )
						MsgInfo( OemToAnsi( "Impossível alterar o Status em função do estágio da aprovação" ) , OemToAnsi( "Atenção!!!!" ) )
					EndIF
					BREAK
				EndIF
			EndIF
		EndIF	

		IF ( lC1XREFCNT )

			nSC1Order		:= RetOrder( "SC1" , "C1_FILIAL+C1_XNUMSC+C1_XITEMSC" )

			IF ( lPorItem )
				bKeySeek	:= { || C1_FILIAL+C1_XNUMSC+C1_XITEMSC }
			Else
				bKeySeek	:= { || C1_FILIAL+C1_XNUMSC }
			EndIF	

		Else
		
			nSC1Order		:= RetOrder( "SC1" , "C1_FILIAL+C1_NUM+C1_ITEM" )
	
			IF ( lPorItem )
				bKeySeek	:= { || C1_FILIAL+C1_NUM+C1_ITEM }
			Else
				bKeySeek	:= { || C1_FILIAL+C1_NUM }
			EndIF	

		EndIF
	
		cKeySeek		:= SC1->( Eval( bKeySeek ) )

		SC1->( dbSetOrder( nSC1Order ) )
		SC1->( dbSeek( cKeySeek , .F. ) )

		While SC1->( !Eof() .and. Eval( bKeySeek ) == cKeySeek )

			nSC1Recno	:= SC1->( Recno() )
            StaticCall( NDJLIB003 , LockSoft , "SC1" )
            cC1Aprov     := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_APROV" , .T. )

			IF (;
					( lForce );
					.or.;
					( cC1Aprov $ " 1,2,B" ); 
				)
				IF ( lMsBlQl )
					IF ( cStatus == "R" )
                        StaticCall( NDJLIB001 , __FieldPut , "SC1" , "C1_APROV"  , cStatus , .T. )	//Bloqueado: Sim
                        StaticCall( NDJLIB001 , __FieldPut , "SC1" , "C1_MSBLQL" , "1"		, .T. )	//Bloqueado: Sim
                        StaticCall( U_NDJBLKSCVL , AliasSZ0Lnk , "SC1" , .T. )						//Retira o Empenho
					EndIF	
				ElseIF !( cC1Aprov == cStatus )
                    StaticCall( NDJLIB001 , __FieldPut , "SC1" , "C1_APROV" , cStatus	, .T. )
                    IF Empty( StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_MSBLQL"	, .T. ) )
						IF ( cStatus == "R" )
                            StaticCall( NDJLIB001 , __FieldPut , "SC1" , "C1_MSBLQL" , "1"	, .T. )	//Bloqueado: Sim
                            StaticCall( U_NDJBLKSCVL , AliasSZ0Lnk , "SC1" , .T. )					//Retira o Empenho
						Else
                            StaticCall( NDJLIB001 , __FieldPut , "SC1" , "C1_MSBLQL" , "2"	, .T. )	//Bloqueado: Nao
						EndIF	
					EndIF	
				EndIF	
			EndIF

			IF ( cStatus $ "L/R" )
                StaticCall( NDJLIB001 , __FieldPut , "SC1" , "C1_NOMAPRO" , cNUsrAprov , .T. )		//Nome do Usuario Aprovador/Reprovador
			EndIF

			SC1->( dbSkip() )

		End While

		IF !( lC1XREFCNT )
            lC1XREFCNT            := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_XREFCNT" , .T. )
			DEFAULT lC1XREFCNT	:= .F.
			IF ( lC1XREFCNT )
                cC1XNumSc        := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_XNUMSC" , .T. )
				lC1XREFCNT		:= !Empty( cC1XNumSc )
			EndIF
		Else
			lC1XREFCNT			:= .F.
		EndIF	
		IF ( lC1XREFCNT )
			PutC1Aprov( @nRecno , @cStatus , @lShowMsg , @lForce , @lMsBlQl , @lC1XREFCNT )
		EndIF

	END SEQUENCE

	SC1->( MsGoto( nRecno ) )

	RestArea( aSC1Area )
	RestArea( aArea )

Return( cLastAprov )

/*/
	Funcao:	fAjustesSC( nRecno  , cNumSC )
	Autor:	Jose Carlos Noronha
/*/
Static Function fAjustesSC( nRecno  , cNumSC )

	Local aArea			:= GetArea()
	Local aSC1Area      := SC1->( GetArea() )

	Local bKeySeek

	Local cObsM			:= Space( 1024 )
	Local cTime			:= Time()
	Local cKeySeek 		:= ""
	Local cC1XNumSc
	Local cSZ6Filial	:= xFilial("SZ6")
	Local cSC1Filial	:= xFilial("SC1")

	Local dDate			:= MsDate()

    Local lPorItem        := StaticCall( NDJLIB001 , GetMemVar , "__lSCPorItem" )
	Local lC1XREFCNT	:= .F.

    Local nSC1Order

	Local oDlg
	Local oGet
	Local oSay
	Local oBtn
	
	Local oPanel

	SC1->( MsGoto( nRecno ) )

	Private cA110Num	:= cNumSc

	DEFINE MSDIALOG oDlg TITLE " Ajustes/Alterações da SC " FROM 000, 000  TO 265, 510 COLORS 0, 16777215 PIXEL

		@ 000,000 MSPANEL oPanel OF oDlg
		oPanel:Align	:= CONTROL_ALIGN_ALLCLIENT

	    @ 014, 010 SAY 		oSay PROMPT "Alteração:" SIZE 025, 007 OF oPanel COLORS 0, 16777215 PIXEL
	    @ 023, 009 GET 		oGet VAR cObsM MEMO      SIZE 233, 078 OF oPanel COLORS 0, 16777215 PIXEL
	    @ 109, 199 BUTTON	oBtn PROMPT "Gravar"	ACTION ( fGravaObs( @oDlg ) ) SIZE 042, 014 OF oPanel PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	cObsM	:= AllTrim( cObsM )

	cObsM	+= CRLF
	cObsM	+= CRLF
	cObsM	+= "Solicitação Suspensa por: " + __cUserId + " : " + UsrFullName( __cUserId ) + CRLF
	cObsM	+= "Em: " + Dtoc( dDate ) + " as: " + cTime + CRLF

    lC1XREFCNT            := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_XREFCNT" , .T. )
	DEFAULT lC1XREFCNT	:= .F.
	IF ( lC1XREFCNT )
        cC1XNumSc        := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_XNUMSC" , .T. )
		lC1XREFCNT		:= !Empty( cC1XNumSc )
	EndIF

	IF ( lC1XREFCNT )

		nSC1Order		:= RetOrder( "SC1" , "C1_FILIAL+C1_XNUMSC+C1_XITEMSC" )

		IF ( lPorItem )
			bKeySeek	:= { || C1_FILIAL+C1_XNUMSC+C1_XITEMSC }
		Else
			bKeySeek	:= { || C1_FILIAL+C1_XNUMSC }
		EndIF	

	Else
	
		nSC1Order		:= RetOrder( "SC1" , "C1_FILIAL+C1_NUM+C1_ITEM" )

		IF ( lPorItem )
			bKeySeek	:= { || C1_FILIAL+C1_NUM+C1_ITEM }
		Else
			bKeySeek	:= { || C1_FILIAL+C1_NUM }
		EndIF	

	EndIF

	SC1->( dbSetOrder( nSC1Order ) )

	cKeySeek		:= SC1->( Eval( bKeySeek ) )

	SC1->( dbSetOrder( nSC1Order ) )
	SC1->( dbSeek( cKeySeek , .F. ) )

	While SC1->( !Eof() .and. Eval( bKeySeek ) == cKeySeek )

        StaticCall( NDJLIB003 , LockSoft , "SC1" )

		dbselectarea("SZ6")
		IF SZ6->( Reclock( "SZ6" , .T. ) )
            StaticCall( NDJLIB003 , LockSoft , "SZ6" )
            StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_FILIAL"	, cSZ6Filial	, .T. )
            StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_XFILIAL"	, cSC1Filial	, .T. )
            StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ALIAS"		, "SC1"			, .T. )
            StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_NUMSC"		, SC1->C1_NUM	, .T. )
            StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ITEMSC"	, SC1->C1_ITEM	, .T. )
            StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_USER"		, __cUserID		, .T. )
            StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_DATA"		, dDate			, .T. )
            StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_HORA"		, cTime			, .T. )
            StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_SUSPNSC"	, .T.			, .T. )
            StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_OBS"		, cObsM			, .T. )
			SZ6->( MsUnLock() )
		EndIF

        StaticCall( NDJLIB001 , __FieldPut , "SC1" , "C1_XSUSPSC"   , .T.    , .T. )

		SC1->( dbSkip() )

	End While

	SC1->( MsGoto( nRecno ) )

    U_NDJ0145( @nRecno , @cNumSC , @cObsM )

	RestArea( aSC1Area )
	RestArea( aArea )

Return( NIL )

/*/
	Funcao:	fGravaObs(oDlg,cNumSC,cObsM)
	Autor:	Jose Carlos Noronha
/*/
Static Function fGravaObs( oDlg )
	oDlg:End()
Return( .T. )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
        NDJMt110()
		lRecursa	:= __Dummy( .F. )
		__cCRLF		:= NIL
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )