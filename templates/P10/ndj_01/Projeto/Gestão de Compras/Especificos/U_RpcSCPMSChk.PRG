#INCLUDE "NDJ.CH"

#DEFINE QUERY_RECNO		1
#DEFINE QUERY_SC1_PMS	2
#DEFINE QUERY_SC1_AFG	3

#DEFINE QUERY_A_ELEM	3

/*/
	Funcao:	RpcSCPMSChk
	Autor:	Marinaldo de Jesus
	Data:	16/03/2011
    Uso:    Chamada Via RPC da Verificacao das Informacoes da Solicitacao de Compras
	Sintaxe: 1 - RpcSCPMSChk( { cEmp , cFil } )	 //Chamada Direta
			 2 - RpcSCPMSChk( cEmp , cFil )		 //Chamada Via Agendamento
/*/
User Function RpcSCPMSChk( aParameters )

	Local cEmp
	Local cFil

	Local oException

	TRYEXCEPTION

        IF !Empty( aParameters )
            IF ( Len( aParameters ) > 1 )
                cEmp    := aParameters[1]
			EndIF
            IF ( Len( aParameters ) > 2 )
                cFil    := aParameters[2]
			EndIF
		EndIF
	
		DEFAULT cEmp	:= "01"
		DEFAULT cFil	:= "01"
		
		PREPARE ENVIRONMENT EMPRESA ( cEmp ) FILIAL ( cFil )

			SCPMSChk()
			ChkC1Aprov()

		RESET ENVIRONMENT

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			ConOut( CaptureError() )
		EndIF

	ENDEXCEPTION

Return( NIL )

/*/
	Funcao:	SCPMSChk()
	Autor:	Marinaldo de Jesus
	Data:	16/03/2011
    Uso:    Chamada Via RPC da Verificacao das Informacoes da Solicitacao de Compras
/*/
Static Function SCPMSChk()

	Local aQuery		:= {}
	Local aSC1PMSF		:= {;
								{ "C1_XPROJET" , "C1_PROJET"   },;
								{ "C1_XREVISA" , "C1_REVISA"   },;
								{ "C1_XTAREFA" , "C1_TAREFA"   };
							}

	Local aSC1AFGF		:= {;
								{ "C1_XPROJET" , "AFG_PROJET" },;
								{ "C1_XREVISA" , "AFG_REVISA" },;
								{ "C1_XTAREFA" , "AFG_TAREFA" },;
								{ "C1_NUM"     , "AFG_NUMSC"  },;
								{ "C1_ITEM"    , "AFG_ITEMSC" },;
								{ "C1_PRODUTO" , "AFG_COD"    },;
								{ "C1_QUANT"   , "AFG_QUANT"  };
							}
	
	Local cDBMS 		:= TCGetDB()
	Local cAFGFilial
	Local cAFGKeySeek

	Local nLoop
	Local nLoops
	Local nRecno

	Local nSC1PMSF
	Local nSC1PMSFs

	Local nSC1AFGF
	Local nSC1AFGFs
    
	Local nAFGOrder

	Local lFound
	Local lAddNew
	Local lSC1PMS
	Local lSC1AFG

	Local uCntField

	IF ( "MSSQL" $ cDBMS )
		aQuery := MsSqlArray()
	Else
		aQuery := OtherdbArray()
	EndIF

	nSC1PMSFs	:= Len( aSC1PMSF )
	nSC1AFGFs	:= Len( aSC1AFGF )

	nLoops		:= Len( aQuery )
	For nLoop := 1 To nLoops

		nRecno	:= aQuery[ nLoop ][ QUERY_RECNO		]
		lSC1PMS	:= aQuery[ nLoop ][ QUERY_SC1_PMS 	]
		lSC1AFG	:= aQuery[ nLoop ][ QUERY_SC1_AFG 	]

		SC1->( MsGoto( nRecno ) )

		IF SC1->( Eof() .or. Bof() )
			Loop
		EndIF

		IF !( SC1->( MsRLock( nRecno ) ) )
			Loop
		EndIF

		IF ( lSC1PMS )

			For nSC1PMSF := 1 To nSC1PMSFs
                uCntField := StaticCall( NDJLIB001 , __FieldGet , "SC1" , aSC1PMSF[ nSC1PMSF , 1 ] , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SC1" , aSC1PMSF[ nSC1PMSF , 2 ] , uCntField , .T. )
			Next nSC1PMSF

		EndIF

		IF ( lSC1AFG )

			nAFGOrder	:= RetOrder( "AFG" , "AFG_FILIAL+AFG_PROJET+AFG_REVISA+AFG_TAREFA+AFG_NUMSC+AFG_ITEMSC" )
			AFG->( dbSetOrder( nAFGOrder ) )
			
			cAFGFilial	:= xFilial( "AFG" , SC1->C1_FILIAL )

			cAFGKeySeek := cAFGFilial
			cAFGKeySeek += SC1->C1_XPROJET
			cAFGKeySeek += SC1->C1_XREVISA
			cAFGKeySeek += SC1->C1_XTAREFA
			cAFGKeySeek += SC1->C1_NUM
			cAFGKeySeek += SC1->C1_ITEM

			lFound		:= AFG->( dbSeek( cAFGKeySeek , .F. ) )
			lAddNew		:= !( lFound )
			
			IF AFG->( !RecLock( "AFG" , lAddNew ) )
				Loop
			EndIF

            StaticCall( NDJLIB001 , __FieldPut , "AFG" , "AFG_FILIAL" , xFilial( "AFG" , SC1->C1_FILIAL ) , .T. )

			For nSC1AFGF := 1 To nSC1AFGFs
                uCntField := StaticCall( NDJLIB001 , __FieldGet , "SC1" , aSC1AFGF[ nSC1AFGF , 1 ] , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "AFG" , aSC1AFGF[ nSC1AFGF , 2 ] , uCntField , .T. )
			Next nSC1AFGF

			AFG->( MsUnLock() )

		EndIF

		SC1->( MsRUnlock( nRecno ) )
		
	Next nLoop

	AFGChkSC1()

Return( NIL )

/*/
	Funcao:	MsSqlArray
	Autor:	Marinaldo de Jesus
	Data:	16/03/2011
	Uso:	Retornar os Dados a Serem Processados quando MsSql
/*/
Static Function MsSqlArray()

	Local aQuery		:= {}

	Local cDBMS			:= TCGetDB()
	Local cQuery		:= ""
	Local cSC1Table		:= RetSqlName( "SC1" )
	Local cAFGTable		:= RetSqlName( "AFG" )
	Local cSC1Filial	:= xFilial( "SC1" )
	Local cAFGFilial	:= xFilial( "AFG" )
	Local cNextAlias	:= GetNextAlias()
	
	Local nIndex		:= 0

	cQuery := "SELECT" + __cCRLF
	cQuery += "		SC1_T.R_E_C_N_O_ ," + __cCRLF
	cQuery += "		SC1_T.SC1_PMS," + __cCRLF
	cQuery += "		SC1_T.SC1_AFG" + __cCRLF
	cQuery += "FROM" + __cCRLF
	cQuery += "	(" + __cCRLF
	cQuery += "		SELECT" + __cCRLF
	cQuery += "			SC1.R_E_C_N_O_," + __cCRLF
	cQuery += "			(" + __cCRLF
	cQuery += "				CASE" + __cCRLF
	cQuery += "					(" + __cCRLF
	cQuery += "						SELECT" + __cCRLF
	cQuery += "							SC1_RESULT.RESULT" + __cCRLF
	cQuery += "						FROM" + __cCRLF
	cQuery += "							(" + __cCRLF
	cQuery += "								SELECT" + __cCRLF
	cQuery += "									0 AS RESULT" + __cCRLF
	cQuery += "								FROM" + __cCRLF
	cQuery += "									(" + __cCRLF
	cQuery += "										SELECT" + __cCRLF
	cQuery += "											*" + __cCRLF
	cQuery += "										FROM" + __cCRLF
	cQuery += "											" + cSC1Table + " SC1_A " + __cCRLF
	cQuery += "										WHERE" + __cCRLF
	cQuery += "											SC1_A.D_E_L_E_T_ <> '*'" + __cCRLF
	cQuery += "										AND" + __cCRLF
	cQuery += "											SC1_A.C1_FILIAL = '" + cSC1Filial + "'" + __cCRLF
	cQuery += "										AND" + __cCRLF
	cQuery += "											SC1_A.R_E_C_N_O_ = SC1.R_E_C_N_O_" + __cCRLF
	cQuery += "									) SC1_0" + __cCRLF
	cQuery += "								WHERE" + __cCRLF
	cQuery += "									SC1_0.D_E_L_E_T_ <> '*'" + __cCRLF
	cQuery += "								AND" + __cCRLF
	cQuery += "									SC1_0.C1_FILIAL = '" + cSC1Filial + "'" + __cCRLF
	cQuery += "								AND" + __cCRLF
	cQuery += "									(" + __cCRLF
	cQuery += "										SC1_0.C1_PROJET = SC1_0.C1_XPROJET" + __cCRLF
	cQuery += "										AND" + __cCRLF
	cQuery += "										SC1_0.C1_REVISA = SC1_0.C1_XREVISA" + __cCRLF
	cQuery += "										AND" + __cCRLF
	cQuery += "										SC1_0.C1_TAREFA = SC1_0.C1_XTAREFA" + __cCRLF
	cQuery += "									)" + __cCRLF
	cQuery += "							UNION" + __cCRLF
	cQuery += "								SELECT" + __cCRLF
	cQuery += "									1 AS RESULT" + __cCRLF
	cQuery += "								FROM" + __cCRLF
	cQuery += "									(" + __cCRLF
	cQuery += "										SELECT" + __cCRLF
	cQuery += "											*" + __cCRLF
	cQuery += "										FROM" + __cCRLF
	cQuery += "											" + cSC1Table + "  SC1_B " + __cCRLF
	cQuery += "										WHERE" + __cCRLF
	cQuery += "											SC1_B.D_E_L_E_T_ <> '*'" + __cCRLF
	cQuery += "										AND" + __cCRLF
	cQuery += "											SC1_B.C1_FILIAL = '" + cSC1Filial + "'" + __cCRLF
	cQuery += "										AND" + __cCRLF
	cQuery += "											SC1_B.R_E_C_N_O_ = SC1.R_E_C_N_O_" + __cCRLF
	cQuery += "									) SC1_1" + __cCRLF
	cQuery += "								WHERE" + __cCRLF
	cQuery += "									SC1_1.D_E_L_E_T_ <> '*'" + __cCRLF
	cQuery += "								AND" + __cCRLF
	cQuery += "									SC1_1.C1_FILIAL = '" + cSC1Filial + "'" + __cCRLF
	cQuery += "								AND" + __cCRLF
	cQuery += "									(" + __cCRLF
	cQuery += "										SC1_1.C1_PROJET <> SC1_1.C1_XPROJET" + __cCRLF
	cQuery += "										OR" + __cCRLF
	cQuery += "										SC1_1.C1_REVISA <> SC1_1.C1_XREVISA" + __cCRLF
	cQuery += "										OR" + __cCRLF
	cQuery += "										SC1_1.C1_TAREFA <> SC1_1.C1_XTAREFA" + __cCRLF
	cQuery += "									)" + __cCRLF
	cQuery += "							) SC1_RESULT" + __cCRLF
	cQuery += "						WHERE" + __cCRLF
	cQuery += "							SC1_RESULT.RESULT = 1" + __cCRLF
	cQuery += "					)" + __cCRLF
	cQuery += "					WHEN" + __cCRLF
	cQuery += "						1" + __cCRLF
	cQuery += "					THEN" + __cCRLF
	cQuery += "						'.T.'" + __cCRLF
	cQuery += "					ELSE" + __cCRLF
	cQuery += "						'.F.'" + __cCRLF
	cQuery += "					END" + __cCRLF
	cQuery += "				) AS SC1_PMS," + __cCRLF
	cQuery += "				(" + __cCRLF
	cQuery += "					CASE" + __cCRLF
	cQuery += "					(" + __cCRLF
	cQuery += "						SELECT" + __cCRLF
	cQuery += "							SC1_AFG_RESULT.RESULT" + __cCRLF
	cQuery += "						FROM" + __cCRLF
	cQuery += "							(" + __cCRLF
	cQuery += "						SELECT" + __cCRLF
	cQuery += "							0 AS RESULT" + __cCRLF
	cQuery += "						FROM" + __cCRLF
	cQuery += "						(" + __cCRLF
	cQuery += "								SELECT" + __cCRLF
	cQuery += "									*" + __cCRLF
	cQuery += "								FROM" + __cCRLF
	cQuery += "									" + cSC1Table + "  SC1_C " + __cCRLF
	cQuery += "								WHERE" + __cCRLF
	cQuery += "									SC1_C.D_E_L_E_T_ <> '*'" + __cCRLF
	cQuery += "								AND" + __cCRLF
	cQuery += "									SC1_C.C1_FILIAL = '" + cSC1Filial + "'" + __cCRLF
	cQuery += "								AND" + __cCRLF
	cQuery += "									SC1_C.R_E_C_N_O_ = SC1.R_E_C_N_O_" + __cCRLF
	cQuery += "						 ) SC1_3" + __cCRLF
	cQuery += "						WHERE" + __cCRLF
	cQuery += "							SC1_3.D_E_L_E_T_ <> '*'" + __cCRLF
	cQuery += "						AND" + __cCRLF
	cQuery += "							SC1_3.C1_FILIAL = '" + cSC1Filial + "'" + __cCRLF
	cQuery += "						AND" + __cCRLF
	cQuery += "						EXISTS" + __cCRLF
	cQuery += "						(" + __cCRLF
	cQuery += "							SELECT" + __cCRLF
	cQuery += "								1" + __cCRLF
	cQuery += "							FROM" + __cCRLF
	cQuery += "								" + cAFGTable + " AFG " + __cCRLF
	cQuery += "							WHERE" + __cCRLF
	cQuery += "								AFG.D_E_L_E_T_ <> '*'" + __cCRLF
	cQuery += "							AND" + __cCRLF
	cQuery += "								AFG.AFG_FILIAL = '" + cAFGFilial + "'" + __cCRLF
	cQuery += "							AND" + __cCRLF
	cQuery += "								AFG.AFG_PROJET = SC1_3.C1_XPROJET" + __cCRLF
	cQuery += "							AND" + __cCRLF
	cQuery += "								AFG.AFG_REVISA = SC1_3.C1_XREVISA" + __cCRLF
	cQuery += "							AND" + __cCRLF
	cQuery += "								AFG.AFG_TAREFA = SC1_3.C1_XTAREFA" + __cCRLF
	cQuery += "							AND" + __cCRLF
	cQuery += "								AFG.AFG_NUMSC = SC1_3.C1_NUM" + __cCRLF
	cQuery += "							AND" + __cCRLF
	cQuery += "								AFG.AFG_ITEMSC = SC1_3.C1_ITEM" + __cCRLF
	cQuery += "						)" + __cCRLF
	cQuery += "						UNION" + __cCRLF
	cQuery += "						SELECT" + __cCRLF
	cQuery += "							1 AS RESULT" + __cCRLF
	cQuery += "						FROM" + __cCRLF
	cQuery += "							(" + __cCRLF
	cQuery += "								SELECT" + __cCRLF
	cQuery += "									*" + __cCRLF
	cQuery += "								FROM" + __cCRLF
	cQuery += "									" + cSC1Table + "  SC1_C " + __cCRLF
	cQuery += "								WHERE" + __cCRLF
	cQuery += "									SC1_C.D_E_L_E_T_ <> '*'" + __cCRLF
	cQuery += "								AND" + __cCRLF
	cQuery += "									SC1_C.C1_FILIAL = '" + cSC1Filial + "'" + __cCRLF
	cQuery += "								AND" + __cCRLF
	cQuery += "									SC1_C.R_E_C_N_O_ = SC1.R_E_C_N_O_" + __cCRLF
	cQuery += "							) SC1_4" + __cCRLF
	cQuery += "						WHERE" + __cCRLF
	cQuery += "							SC1_4.D_E_L_E_T_ <> '*'" + __cCRLF
	cQuery += "						AND" + __cCRLF
	cQuery += "							SC1_4.C1_FILIAL = '" + cSC1Filial + "'" + __cCRLF
	cQuery += "						AND" + __cCRLF
	cQuery += "							NOT EXISTS" + __cCRLF
	cQuery += "							(" + __cCRLF
	cQuery += "								SELECT" + __cCRLF
	cQuery += "									1" + __cCRLF
	cQuery += "								FROM" + __cCRLF
	cQuery += "									" + cAFGTable + "  AFG " + __cCRLF
	cQuery += "								WHERE" + __cCRLF
	cQuery += "									AFG.D_E_L_E_T_ <> '*'" + __cCRLF
	cQuery += "								AND" + __cCRLF
	cQuery += "									AFG.AFG_FILIAL = '" + cAFGFilial + "'" + __cCRLF
	cQuery += "								AND" + __cCRLF
	cQuery += "									AFG.AFG_PROJET = SC1_4.C1_XPROJET" + __cCRLF
	cQuery += "								AND" + __cCRLF
	cQuery += "									AFG.AFG_REVISA = SC1_4.C1_XREVISA" + __cCRLF
	cQuery += "								AND" + __cCRLF
	cQuery += "									AFG.AFG_TAREFA = SC1_4.C1_XTAREFA" + __cCRLF
	cQuery += "								AND" + __cCRLF
	cQuery += "									AFG.AFG_NUMSC = SC1_4.C1_NUM" + __cCRLF
	cQuery += "								AND" + __cCRLF
	cQuery += "									AFG.AFG_ITEMSC = SC1_4.C1_ITEM" + __cCRLF
	cQuery += "								AND" + __cCRLF
	cQuery += "									AFG.AFG_QUANT = SC1_4.C1_QUANT" + __cCRLF
	cQuery += "							)" + __cCRLF
	cQuery += "						) SC1_AFG_RESULT" + __cCRLF
	cQuery += "						WHERE" + __cCRLF
	cQuery += "							SC1_AFG_RESULT.RESULT = 1" + __cCRLF
	cQuery += "					)" + __cCRLF
	cQuery += "					WHEN" + __cCRLF
	cQuery += "						1" + __cCRLF
	cQuery += "					THEN" + __cCRLF
	cQuery += "						'.T.'" + __cCRLF
	cQuery += "					ELSE" + __cCRLF
	cQuery += "						'.F.'" + __cCRLF
	cQuery += "					END" + __cCRLF
	cQuery += "				) AS SC1_AFG" + __cCRLF
	cQuery += "			FROM" + __cCRLF
	cQuery += "				" + cSC1Table + "  SC1 ) SC1_T" + __cCRLF
	cQuery += "WHERE" + __cCRLF
	cQuery += "(" + __cCRLF
	cQuery += "		( SC1_T.SC1_PMS = '.T.' )" + __cCRLF
	cQuery += "		OR" + __cCRLF
	cQuery += "		( SC1_T.SC1_AFG = '.T.' )" + __cCRLF
	cQuery += ")" + __cCRLF

    cQuery := StaticCall( NDJLIB001 , ClearQuery , cQuery )

	TCQUERY ( cQuery ) ALIAS ( cNextAlias ) NEW

	While ( cNextAlias )->( !Eof() )

		++nIndex
		aAdd( aQuery , Array( QUERY_A_ELEM ) )

		aQuery[ nIndex ][ QUERY_RECNO		]	:= ( cNextAlias )->( R_E_C_N_O_ )
		aQuery[ nIndex ][ QUERY_SC1_PMS 	]   := ( cNextAlias )->( &( SC1_PMS ) )
		aQuery[ nIndex ][ QUERY_SC1_AFG 	]   := ( cNextAlias )->( &( SC1_AFG ) )

		( cNextAlias )->( dbSkip() )

	End While

	( cNextAlias )->( dbCloseArea() )
	dbSelectArea("SC1")

Return( aQuery )

/*/
	Funcao:	OtherdbArray
	Autor:	Marinaldo de Jesus
	Data:	16/03/2011
	Uso:	Retornar os Dados a Serem Processados quando Otherdb
/*/
Static Function OtherdbArray()
	
	Local aQuery		:= {}

	Local cQuery		:= ""
	Local cNextAlias	:= GetNextAlias()

	Local nIndex		:= 0

	cQuery := "SELECT" + __cCRLF
	cQuery += "		SC1.R_E_C_N_O_" + __cCRLF
	cQuery += "FROM" + __cCRLF
	cQuery += "		"+RetSqlName("SC1" ) + " SC1 " + __cCRLF
	cQuery += "WHERE" + __cCRLF
	cQuery += "(" + __cCRLF
	cQuery += "		SC1.C1_D_E_L_E_T <> '*'" + __cCRLF
	cQuery += "	AND" + __cCRLF
	cQuery += "		SC1.C1_FILIAL = '" + xFilial( "SC1" ) + "'" + __cCRLF
	cQuery += "	AND" + __cCRLF
	cQuery += "		(" + __cCRLF
	cQuery += "			(" + __cCRLF
	cQuery += "				SC1.C1_PROJET <> SC1.C1_XPROJET" + __cCRLF
	cQuery += "			OR" + __cCRLF
	cQuery += "				SC1.C1_REVISA <> SC1.C1_XREVISA" + __cCRLF
	cQuery += "			OR" + __cCRLF
	cQuery += "				SC1.C1_TAREFA <> SC1.C1_XTAREFA" + __cCRLF
	cQuery += "			)" + __cCRLF
	cQuery += "		OR" + __cCRLF
	cQuery += "			NOT EXISTS" + __cCRLF
	cQuery += "			(" + __cCRLF
	cQuery += "				SELECT" + __cCRLF
	cQuery += "					1" + __cCRLF
	cQuery += "				FROM" + __cCRLF
	cQuery += "				" + RetSqlName("AFG") + " AFG " + __cCRLF
	cQuery += "				WHERE" + __cCRLF
	cQuery += "					AFG.C1_D_E_L_E_T <> '*'" + __cCRLF
	cQuery += "				AND" + __cCRLF
	cQuery += "					AFG.AFG_FILIAL = '" + xFilial( "AFG" ) + "'" + __cCRLF
	cQuery += "				AND" + __cCRLF
	cQuery += "					AFG.AFG_PROJET = SC1.C1_XPROJET" + __cCRLF
	cQuery += "				AND" + __cCRLF
	cQuery += "					AFG.AFG_REVISA = SC1.C1_XREVISA" + __cCRLF
	cQuery += "				AND" + __cCRLF
	cQuery += "					AFG.AFG_TAREFA = SC1.C1_XTAREFA" + __cCRLF
	cQuery += "				AND" + __cCRLF
	cQuery += "					AFG.AFG_NUMSC = SC1.C1_NUM" + __cCRLF
	cQuery += "				AND" + __cCRLF
	cQuery += "					AFG.AFG_ITEMSC = SC1.C1_ITEM" + __cCRLF
	cQuery += "				AND" + __cCRLF
	cQuery += "					AFG.AFG_QUANT = SC1.C1_QUANT" + __cCRLF
	cQuery += "			)" + __cCRLF
	cQuery += "		)" + __cCRLF
	cQuery += ")" + __cCRLF

    cQuery := StaticCall( NDJLIB001 , ClearQuery , cQuery )

	TCQUERY ( cQuery ) ALIAS ( cNextAlias ) NEW

	While ( cNextAlias )->( !Eof() )

		++nIndex
		aAdd( aQuery , Array( QUERY_A_ELEM ) )

		aQuery[ nIndex ][ QUERY_RECNO		]	:= ( cNextAlias )->( R_E_C_N_O_ )
		aQuery[ nIndex ][ QUERY_SC1_PMS 	]   := .T.
		aQuery[ nIndex ][ QUERY_SC1_AFG 	]   := .T.

		( cNextAlias )->( dbSkip() )

	End While

	( cNextAlias )->( dbCloseArea() )
	dbSelectArea("SC1")

Return( aQuery )

/*/
	Funcao:	AFGChkSC1
	Autor:	Marinaldo de Jesus
	Data:	16/03/2011
	Uso:	Verifica os Relacionamentos perdidos na AFG vs SC1 e Deleta-os
/*/
Static Function AFGChkSC1()

	Local cQuery		:= ""
	Local cNextAlias	:= GetNextAlias()

	Local nRecno

	cQuery := "SELECT" + __cCRLF
	cQuery += "		AFG.R_E_C_N_O_" + __cCRLF
	cQuery += "FROM" + __cCRLF
	cQuery += "		" + RetSqlName( "AFG" ) + " AFG " + __cCRLF
	cQuery += "WHERE" + __cCRLF
	cQuery += "		AFG.D_E_L_E_T_ <> '*'" + __cCRLF
	cQuery += "AND" + __cCRLF
	cQuery += "		NOT EXISTS" + __cCRLF
	cQuery += "		(" + __cCRLF
	cQuery += "			SELECT" + __cCRLF 
	cQuery += "				1" + __cCRLF
	cQuery += "			FROM" + __cCRLF
	cQuery += "				" + RetSqlName( "SC1" ) + " SC1 " + __cCRLF
	cQuery += "			WHERE" + __cCRLF
	cQuery += "				AFG.D_E_L_E_T_ <> '*'" + __cCRLF
	cQuery += "			AND" + __cCRLF
	cQuery += "				SC1.D_E_L_E_T_ <> '*'" + __cCRLF
	cQuery += "			AND" + __cCRLF
	cQuery += "				AFG.AFG_FILIAL = '" + xFilial( "AFG" ) + "'" + __cCRLF
	cQuery += "			AND" + __cCRLF
	cQuery += "				SC1.C1_FILIAL = '" + xFilial( "SC1" ) + "'" + __cCRLF
	cQuery += "			AND" + __cCRLF
	cQuery += "				AFG.AFG_PROJET = SC1.C1_XPROJET" + __cCRLF
	cQuery += "			AND" + __cCRLF
	cQuery += "				AFG.AFG_REVISA = SC1.C1_XREVISA" + __cCRLF
	cQuery += "			AND" + __cCRLF
	cQuery += "				AFG.AFG_TAREFA = SC1.C1_XTAREFA" + __cCRLF
	cQuery += "			AND" + __cCRLF
	cQuery += "				AFG.AFG_NUMSC = SC1.C1_NUM" + __cCRLF 
	cQuery += "			AND" + __cCRLF 
	cQuery += "				AFG.AFG_ITEMSC = SC1.C1_ITEM" + __cCRLF 
	cQuery += ")" + __cCRLF

    cQuery := StaticCall( NDJLIB001 , ClearQuery , cQuery )

	TCQUERY ( cQuery ) ALIAS ( cNextAlias ) NEW

	While ( cNextAlias )->( !Eof() )
    
		nRecno := ( cNextAlias )->( R_E_C_N_O_ )

		AFG->( dbGoto( nRecno ) )

		IF AFG->( !Eof() .and. !Bof() )
			IF AFG->( RecLock( "AFG" , .F. ) )
				AFG->( dbDelete() )
				AFG->( MsUnLock() )
			EndIF
		EndIF

		( cNextAlias )->( dbSkip() )

	End While

	( cNextAlias )->( dbCloseArea() )
	dbSelectArea("AFG")

Return( NIL )

/*/
	Funcao:	ChkC1Aprov
	Autor:	Marinaldo de Jesus
	Data:	16/03/2011
	Uso:	Atualiza o campo C1_APROV
/*/
Static Function ChkC1Aprov()

	Local cQuery
	Local cAlias		:= GetNextAlias()

	Local cSC1Table		:= RetSqlName( "SC1" )
	Local cSC1Filial	:= xFilial( "SC1" )
	Local cSC1Pedido	:= Space( GetSx3Cache( "C1_PEDIDO"	, "X3_TAMANHO" ) )
	Local cSC1Cotacao	:= Space( GetSx3Cache( "C1_COTACAO"	, "X3_TAMANHO" ) )

	Local nMinRec
	Local nMaxRec

	Local nMinRecno
	Local nMaxRecno

	cQuery := "SELECT" + __cCRLF
	cQuery += "		MIN(R_E_C_N_O_) MINRECNO," + __cCRLF
	cQuery += "		MAX(R_E_C_N_O_) MAXRECNO" + __cCRLF
	cQuery += "FROM" + __cCRLF
	cQuery += "		" + cSC1Table + " SC1 " + __cCRLF
	cQuery += "WHERE" + __cCRLF
	cQuery += "(" + __cCRLF
	cQuery += "		SC1.D_E_L_E_T_ = ' '" + __cCRLF
	cQuery += "AND" + __cCRLF
	cQuery += "		SC1.C1_FILIAL = '" + cSC1Filial + "'" + __cCRLF
	cQuery += "AND" + __cCRLF
	cQuery += "		(" + __cCRLF
	cQuery += "				(" + __cCRLF
	cQuery += "					(" + __cCRLF
	cQuery += "						SC1.C1_APROV <> 'L'" + __cCRLF
	cQuery += "					AND" + __cCRLF
	cQuery += "					(" + __cCRLF
	cQuery += "							SC1.C1_PEDIDO <> '" + cSC1Pedido + "'" + __cCRLF
	cQuery += "						OR" + __cCRLF
	cQuery += "							SC1.C1_COTACAO <> '" + cSC1Cotacao + "'" + __cCRLF
	cQuery += "						)" + __cCRLF
	cQuery += "					)" + __cCRLF
	cQuery += "				)" + __cCRLF
	cQuery += "				OR" + __cCRLF
	cQuery += "				(" + __cCRLF
	cQuery += "						(" + __cCRLF
	cQuery += "							SC1.C1_APROV <> 'R'" + __cCRLF
	cQuery += "						AND" + __cCRLF
	cQuery += "							SC1.C1_MSBLQL = '1'" + __cCRLF
	cQuery += "						)" + __cCRLF
	cQuery += "				)" + __cCRLF
	cQuery += "				OR" + __cCRLF
	cQuery += "				(" + __cCRLF
	cQuery += "						(" + __cCRLF
	cQuery += "							SC1.C1_APROV = 'R'" + __cCRLF
	cQuery += "						AND" + __cCRLF
	cQuery += "							SC1.C1_MSBLQL <> '1'" + __cCRLF
	cQuery += "						)" + __cCRLF
	cQuery += "				)" + __cCRLF
	cQuery += "		)" + __cCRLF
	cQuery += ")" + __cCRLF

	TCQUERY ( cQuery ) ALIAS ( cAlias ) NEW

	TcSetField( cAlias , "MINRECNO" , "N" , 18 , 0 )
	TcSetField( cAlias , "MAXRECNO" , "N" , 18 , 0 )

	nMinRecno	:= ( cAlias )->MINRECNO
	nMaxRecno	:= ( cAlias )->MAXRECNO

	( cAlias )->( dbCloseArea() )

	dbSelectArea( "SC1" )

	While ( nMinRecno <= nMaxRecno )

		nMinRec	:= nMinRecno
		nMaxRec	:= ( nMinRec + 1024 )

		cQuery := "UPDATE" + __cCRLF
		cQuery += "		" + cSC1Table + __cCRLF
		cQuery += "	SET" + __cCRLF 
		cQuery += "		" + cSC1Table + ".C1_APROV = 'L'" + __cCRLF 
		cQuery += "	WHERE" + __cCRLF 
		cQuery += "	(" + __cCRLF 
		cQuery += "		" + cSC1Table + ".R_E_C_N_O_ >= " + Str( nMinRec ) + __cCRLF
		cQuery += "	AND" + __cCRLF 
		cQuery += "		" + cSC1Table + ".R_E_C_N_O_ <= " + Str( nMaxRec ) + __cCRLF 
		cQuery += "	AND" + __cCRLF 
		cQuery += "		" + cSC1Table + ".D_E_L_E_T_ = ' '" + __cCRLF 
		cQuery += "	AND" + __cCRLF 
		cQuery += "		" + cSC1Table + ".C1_FILIAL = '" + cSC1Filial + "'" + __cCRLF 
		cQuery += "	AND" + __cCRLF 
		cQuery += "		(" + __cCRLF 
		cQuery += "			" + cSC1Table + ".C1_PEDIDO <> '" + cSC1Pedido + "'" + __cCRLF 
		cQuery += "		OR" + __cCRLF 
		cQuery += "			" + cSC1Table + ".C1_COTACAO <> '" + cSC1Cotacao + "'" + __cCRLF 
		cQuery += "		)" + __cCRLF
		cQuery += "	AND" + __cCRLF 
		cQuery += "		" + cSC1Table + ".C1_APROV <> 'L'" + __cCRLF 
		cQuery += "	)" + __cCRLF 

		TcSqlExec( cQuery )

		cQuery := "UPDATE" + __cCRLF 
		cQuery += "		" + cSC1Table + __cCRLF
		cQuery += "SET" + __cCRLF 
		cQuery += "		" + cSC1Table + ".C1_APROV = 'R'" + __cCRLF 
		cQuery += "WHERE" + __cCRLF 
		cQuery += "(" + __cCRLF 
		cQuery += "		" + cSC1Table + ".R_E_C_N_O_ >= " + Str( nMinRec ) + __cCRLF
		cQuery += "AND" + __cCRLF 
		cQuery += "		" + cSC1Table + ".R_E_C_N_O_ <= " + Str( nMaxRec ) + __cCRLF 
		cQuery += "AND" + __cCRLF 
		cQuery += "		" + cSC1Table + ".D_E_L_E_T_ = ' '" + __cCRLF 
		cQuery += "AND" + __cCRLF 
		cQuery += "		" + cSC1Table + ".C1_FILIAL = '" + cSC1Filial + "'" + __cCRLF 
		cQuery += "AND" + __cCRLF 
		cQuery += "		" + cSC1Table + ".C1_MSBLQL = '1'" + __cCRLF 
		cQuery += "AND" + __cCRLF 		
		cQuery += "		" + cSC1Table + ".C1_APROV <> 'R'" + __cCRLF 
		cQuery += ")" + __cCRLF 

		TcSqlExec( cQuery )
			
		cQuery := "UPDATE" + __cCRLF 
		cQuery += "		" + cSC1Table + __cCRLF
		cQuery += "	SET" + __cCRLF 
		cQuery += "		" + cSC1Table + ".C1_MSBLQL = '1'" + __cCRLF 
		cQuery += "	WHERE" + __cCRLF 
		cQuery += "	(" + __cCRLF 
		cQuery += "		" + cSC1Table + ".R_E_C_N_O_ >= " + Str( nMinRec ) + __cCRLF
		cQuery += "	AND" + __cCRLF 
		cQuery += "		" + cSC1Table + ".R_E_C_N_O_ <= " + Str( nMaxRec ) + __cCRLF 
		cQuery += "	AND" + __cCRLF 
		cQuery += "		" + cSC1Table + ".D_E_L_E_T_ = ' '" + __cCRLF 
		cQuery += "	AND" + __cCRLF 
		cQuery += "		" + cSC1Table + ".C1_FILIAL = '" + cSC1Filial + "'" + __cCRLF 
		cQuery += "	AND" + __cCRLF 
		cQuery += "		" + cSC1Table + ".C1_APROV = 'R'" + __cCRLF 
		cQuery += "	AND" + __cCRLF
		cQuery += "		" + cSC1Table + ".C1_MSBLQL <> '1'" + __cCRLF 
		cQuery += "	)" + __cCRLF 

		TcSqlExec( cQuery )

		nMinRecno   += 1025

		SC1->( dbGoTop() )

	End While

Return( NIL )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
    	RpcSCPMSChk()
    	OtherdbArray()
		lRecursa := __Dummy( .F. )
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )
