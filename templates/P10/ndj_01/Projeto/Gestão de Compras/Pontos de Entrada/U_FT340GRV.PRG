#INCLUDE "NDJ.CH"
/*/
	Data:		14/03/2011
	Autor:		Marinaldo de Jesus
	Programa:	FT340GRV
	Descricao:	Implementacao do Ponto de Entrada FT340GRV, executado em Ft340Grv no Programa FATA340
				Sera utilizado para gravar informacoes complementares na Base de Conhecimento
/*/
User Function FT340GRV()

    Local lNDJSCDoc		:= IsInCallStack( "NDJSCDoc" )
	Local lUM110EXIT	:= IsInCallStack( "U_M110EXIT" )
	
	Local nTipo
	
	Local oException
	
	TRYEXCEPTION
	
		nTipo	:= ParamIxb[1]

		IF (;
                ( lNDJSCDoc );
				.or.;
				( lUM110EXIT );
			)	
			IF ( lUM110EXIT )
				nTipo := 3
			EndIF
			DocSc1ToAC9( @nTipo , @cA110Num )
		EndIF

	CATCHEXCEPTION USING oExeption

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
			ConOut( oException:Description , oException:ErrorStack )
		EndIF
		
	ENDEXCEPTION

Return( NIL )

/*/
	Data:		14/03/2011
	Autor:		Marinaldo de Jesus
	Programa:	DocSc1ToAC9
	Descricao:	Cria o Relacionamento dos Documentos da SC com a Entidade SC1 na tabela AC9
	Sintaxe:	StaticCall( U_FT340GRV , DocSc1ToAC9 , nTipo , cA110Num )
/*/
Static Function DocSc1ToAC9( nTipo , cA110Num )

	Local aArea			:= GetArea()
	Local aAC9Area		:= AC9->( GetArea() )
	Local aSC1Area		:= SC1->( GetArea() )
	
	Local cDocFile
	Local cDirDocs
	Local cDirFile
	Local cSC1Filial
	Local cAC9Filial
	Local cNextAlias
	Local cAC9CodEnt
	Local cAC9KeySeek

	Local lFound
	Local lAddNew
	Local lDelete		:= ( nTipo == 3 )
	Local lLinked		:= .F.
	Local lUM110EXIT	:= IsInCallStack( "U_M110EXIT" )
	Local lA110INCLUI	:= IsInCallStack( "A110INCLUI" )
	
	Local nSC1Recno
	Local nAC9Order

	BEGIN SEQUENCE

		lLinked := StaticCall( U_FT340MNU , LinkedFile , cA110Num , .F. )
		IF !( lLinked )
			BREAK
		EndIF

		IF ( lDelete )
			IF (;
					FindFunction( "MsMultDir" );
					.and.;
					MsMultDir();
					.and.;
					!Empty( ACB->ACB_PATH );
				)	
				cDirDocs := Alltrim( ACB->ACB_PATH )
			Else
				cDirDocs := AllTrim( MsDocPath() )
			EndIF
			IF !( SubStr( cDirDocs , -1 ) == "\" )
				cDirDocs += "\"
			EndIF
			cDocFile	:= AllTrim( ACB->ACB_OBJETO )
			cDirFile	:= cDirDocs + cDocFile
		EndIF

		IF (;
				( lUM110EXIT );
				.and.;
				( lA110INCLUI );
			)
			IF File( cDirFile )
                StaticCall( NDJLIB007 , FileErase , cDirFile )
			EndIF
		EndIF		

		cSC1Filial	:= xFilial( "SC1" )
		cAC9Filial	:= xFilial( "AC9" )

		nAC9Order	:= RetOrder( "AC9" , "AC9_FILIAL+AC9_ENTIDA+AC9_FILENT+AC9_CODENT+AC9_CODOBJ" )
	
		cNextAlias	:= GetNextAlias()
		
		BEGINSQL Alias cNextAlias
			SELECT
				SC1.C1_ITEM,
				SC1.R_E_C_N_O_
			FROM
				%table:SC1% SC1
			WHERE
				SC1.%NotDel%
			AND
				SC1.C1_FILIAL = %exp:cSC1Filial%
			AND
				SC1.C1_NUM = %exp:cA110Num%
		ENDSQL

		AC9->( dbSetOrder( nAC9Order ) )
	
		While ( cNextAlias )->( !Eof() )
	
			BEGIN SEQUENCE
	
				cAC9CodEnt	:= cSC1Filial
				cAC9CodEnt	+= cA110Num
				cAC9CodEnt	+= ( cNextAlias )->C1_ITEM
				
				cAC9CodEnt	:= Padr( cAC9CodEnt , GetSx3Cache( "AC9_CODENT" , "X3_TAMANHO" ) )
	
				cAC9KeySeek := cAC9Filial		//AC9_FILIAL
				cAC9KeySeek += "SC1"			//AC9_ENTIDA
				cAC9KeySeek += cSC1Filial		//AC9_FILENT
				cAC9KeySeek += cAC9CodEnt		//AC9_CODENT
				cAC9KeySeek += ACB->ACB_CODOBJ	//AC9_CODOBJ
		
				lFound		:= AC9->( dbSeek( cAC9KeySeek , .F. ) )
				lAddNew		:= !( lFound )
	
				IF (;
						( lDelete );
						.and.;
						( lAddNew );
					)	
					BREAK
				EndIF	
	
				IF AC9->( RecLock( "AC9" , lAddNew ) )
					IF ( lDelete )
						AC9->( dbDelete() )
						IF File( cDirFile )
                            StaticCall( NDJLIB007 , FileErase , cDirFile )
						EndIF
					Else
						AC9->AC9_FILIAL	:= cAC9Filial
						AC9->AC9_ENTIDA	:= "SC1"
						AC9->AC9_FILENT	:= cSC1Filial
						AC9->AC9_CODENT	:= cAC9CodEnt
						AC9->AC9_CODOBJ	:= ACB->ACB_CODOBJ
					EndIF
					AC9->( MsUnLock() )
					nSC1Recno	:= ( cNextAlias )->R_E_C_N_O_
					SC1->( dbGoto( nSC1Recno ) )
                    StaticCall( NDJLIB001 , __FieldPut , "SC1" , "C1_XPANEXO" , !( lDelete ) , .T. )
				EndIF

			END SEQUENCE
	
			( cNextAlias )->( dbSkip() )
		
		End While
	
		( cNextAlias )->( dbCloseArea() )
		
	END SEQUENCE	

	RestArea( aAC9Area )
	RestArea( aSC1Area )
	RestArea( aArea )

Return( lLinked )

/*/
	Funcao: 	FT340Commit()
	Autor:		Marinaldo de Jesus
	Data:		15/03/2011
	Uso:		Tratamento de commit na FT340Grv()
	Sintaxe:	StaticCall( U_FT340GRV , FT340Commit )
/*/
Static Function FT340Commit()

	Local bError		:= { |oError| &( cError ) , Break(oError) }
	Local cError    	:= "( nNivelTTS := __nNivelTTS , Eval( bGetTTS , @__aStackTTS ) )"
	Local nProcName
	
	Private bGetTTS		:= { |aTTS| aStackTTS  := aTTS }
	Private aStackTTS
	Private nNivelTTS
	
	TRYEXCEPTION USING bError
		IF InTransact()
			FileByTXT( MsDate() )
		EndIF
	CATCHEXCEPTION
		nProcName := aScan( aStackTTS , { |cProcName| ( Upper( cProcName ) == "FT340GRV" ) } ) 
		IF ( nProcName > 0 )
			aDel( aStackTTS , nProcName )
			aSize( aStackTTS , --nNivelTTS )
			While ( ( nProcName := aScan( aStackTTS , { |cProcName| ( Upper( cProcName ) == "FT340GRV" ) } ) ) > 0 )
				aDel( aStackTTS , nProcName )
				aSize( aStackTTS , --nNivelTTS )
			End While
			cError := "__nNivelTTS := nNivelTTS"
			TRYEXCEPTION USING bError
				FileByTXT( MsDate() )
			ENDEXCEPTION
			dbCommitAll()
			EndTran()
		EndIF	
	ENDEXCEPTION

Return( NIL )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
    	DocSc1ToAC9()
    	FT340Commit()
		lRecursa	:= __Dummy( .F. )
		__cCRLF		:= NIL
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )