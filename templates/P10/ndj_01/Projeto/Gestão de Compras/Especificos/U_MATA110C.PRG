#INCLUDE "NDJ.CH"
/*/
	Function:	U_MATA110C
	Autor:		Marinaldo de Jesus
	Data:		15/03/2011
	Descricao:	Conhecimento vs Solicitacao de Compras
	Sintaxe:	U_MATA110C
/*/
User Function MATA110C()

	Local aArea 			:= GetArea()
	Local aIndex 			:= {}
	Local aAC9Area			:= AC9->( GetArea() )
	Local aSC1Area			:= SC1->( GetArea() )

	Local cExprFilTop		:= ""
	
	Local nAC9Order			:= RetOrder( "AC9" , "AC9_FILIAL+AC9_CODOBJ+AC9_ENTIDA+AC9_FILENT+AC9_CODENT" )

	BEGIN SEQUENCE

		Private aRotina		:= {;
									{ "Pesquisar"	, "PesqBrw"													, 0 , 01 } ,;
									{ "Sol.Compras"	, "StaticCall(U_MATA110C,MATA110SC,'AC9',AC9->(Recno()),2)"	, 0 , 02 }  ;
								}

		Private aTela    	:= {}
		Private aGets    	:= {}

		Private cCadastro	:= OemToAnsi( "Base de Conhecimento vs Solicitação de Compras" )
		Private bFiltraBrw	:= { || .F. }

		AC9->( dbSetOrder( nAC9Order ) )

		cExprFilTop	:= "AC9_CODENT "
		cExprFilTop	+= "IN "
		cExprFilTop	+= "("
		cExprFilTop	+= 	"SELECT "
		cExprFilTop	+=		"SC1.C1_FILIAL+SC1.C1_NUM+SC1.C1_ITEM "
		cExprFilTop	+=	"FROM "
		cExprFilTop	+=		RetSqlName( "AC9" ) + " AC9, "
		cExprFilTop	+=		RetSqlName( "SC1" ) + " SC1 "
		cExprFilTop	+=	"WHERE "
		cExprFilTop	+=		"AC9.D_E_L_E_T_<>'*' "
		cExprFilTop	+=	" AND "
		cExprFilTop	+=		"SC1.D_E_L_E_T_<>'*' "
		cExprFilTop	+=	" AND "
		cExprFilTop	+=		"AC9.AC9_FILIAL = '" + xFilial( "AC9" ) + "'"
		cExprFilTop	+=	" AND "
		cExprFilTop	+=		"SC1.C1_FILIAL = '" + xFilial( "SC1" ) + "'"
		cExprFilTop	+=	" AND "
		cExprFilTop	+=		"AC9.AC9_ENTIDA = 'SC1'"
		cExprFilTop	+=	" AND "
		cExprFilTop	+=		"AC9.AC9_FILENT = SC1.C1_FILIAL"
		cExprFilTop	+=	" AND "
		cExprFilTop	+=		"SC1.C1_FILIAL+SC1.C1_NUM+SC1.C1_ITEM = AC9.AC9_CODENT"
		cExprFilTop	+= ")"

		AC9->( dbSetOrder( nAC9Order ) )

        StaticCall( NDJLIB001 , GetSetMbFilter , cExprFilTop )

		mBrowse( 6 , 1 , 22 , 75 , "AC9" , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , cExprFilTop )

	END SEQUENCE

	RestArea( aSC1Area )
	RestArea( aAC9Area )
	RestArea( aArea )

Return( NIL )

/*/
	Function:	MATA110SC
	Autor:		Marinaldo de Jesus
	Data:		15/03/2011
	Descricao:	Chama a Rotina de Solicitacao de Compras
	Sintaxe:	StaticCall(U_MATA110C,MATA110SC,cAlias,nReg,nOpc)
/*/
Static Function MATA110SC( cAlias , nReg , nOpc )

	Local aArea			:= GetArea()
	Local aIndex		:= {}
	Local aSC1Area		:= SC1->( GetArea() )
	Local aModuloReSet	:= SetModulo( "SIGACOM" , "COM" )
	
	Local cFiltra		:= ""
	Local cNumSC
	Local cSC1Alias		:= "SC1"
	
	Local cAC9CodEnt
	Local cExprFilTop	:= ""
	
	Local nSC1Reg
	Local nSC1Order		:= RetOrder( cSC1Alias , "C1_FILIAL+C1_NUM+C1_ITEM" )

	Local uRet

	Private aTela    	:= {}
	Private aGets    	:= {}

	EndFilBrw( "AC9" , @aIndex )

	TRYEXCEPTION

		( cAlias )->( MsGoto( nReg ) )
		
		cAC9CodEnt	:= ( cAlias )->( AC9_CODENT )
		cNumSC		:= SubStr( cAC9CodEnt , ( GetSx3Cache( "C1_FILIAL" , "X3_TAMANHO" )  + 1 ) , GetSx3Cache( "C1_NUM" , "X3_TAMANHO" ) )

		SC1->( dbSetOrder( nSC1Order ) )

		cExprFilTop := "C1_NUM='" + cNumSC + "'"

        cSvExprFilTop    := StaticCall( NDJLIB001 , GetSetMbFilter , cExprFilTop )
	
		SetMBTopFilter( "AC9" , ""  )
		SetMBTopFilter( "SC1" , cExprFilTop , .F. )

		uRet	:= __Execute( "MATA110()" , "xxxxxxxxxxxxxxxxxxxx" , "MATA110" , AllTrim(Str(nModulo)) , "" , 1 , .T. )

        StaticCall( NDJLIB001 , GetSetMbFilter , cSvExprFilTop )

		SetMBTopFilter( "SC1" , "" )

		SetMBTopFilter( "AC9" , cSvExprFilTop )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
		EndIF

	ENDEXCEPTION
    
	ReSetModulo( aModuloReSet )

	RestArea( aSC1Area )
	RestArea( aArea )

Return( uRet )

/*/
	Function:	AC9SC1SetFilter
	Autor:		Marinaldo de Jesus
	Data:		15/03/2011
	Descricao:	Filtro de Relacionamento da Tabela de Entidades de Conhecimento vs SC1 (Solicitacao de Compras)
	Sintaxe:	StaticCall( U_MATA110C , AC9SC1SetFilter )
/*/
Static Function AC9SC1SetFilter()

	Local cAC9Filial	:= xFilial( "AC9" )
	Local cACBFilial	:= xFilial( "ACB" )
	Local cSC1Filial	:= xFilial( "SC1" )
	Local cExprFilTop 	:= ""
    Local cSvExprFilTop := StaticCall( NDJLIB001 , GetSetMbFilter , cExprFilTop )
	
	Local oObjBrow

	IF ( SC1->( FieldPos( "C1_XPANEXO" ) ) > 0 )

		cExprFilTop := "C1_XPANEXO='T'"

	Else

		cExprFilTop := "C1_FILIAL+C1_NUM+C1_ITEM "
		cExprFilTop += "IN"
		cExprFilTop += "("
		cExprFilTop +=		"SELECT "
		cExprFilTop +=			"AC9.AC9_CODENT "
		cExprFilTop +=		"FROM "
		cExprFilTop +=		RetSqlName("AC9" ) + " AC9, "
		cExprFilTop +=		RetSqlName("ACB" ) + " ACB, "
		cExprFilTop +=		RetSqlName("SC1" ) + " SC1  "
		cExprFilTop +=		"WHERE "
		cExprFilTop +=			"AC9.D_E_L_E_T_ <> '*'"
		cExprFilTop +=		" AND "
		cExprFilTop +=			"ACB.D_E_L_E_T_ <> '*'"
		cExprFilTop +=		" AND "
		cExprFilTop +=			"SC1.D_E_L_E_T_ <> '*'"
		cExprFilTop +=		" AND "
		cExprFilTop +=			"AC9.AC9_FILIAL = '" + cAC9Filial + "'"
		cExprFilTop +=		" AND "
		cExprFilTop +=			"ACB.ACB_FILIAL = '" + cACBFilial + "'"
		cExprFilTop +=		" AND "
		cExprFilTop +=			"SC1.C1_FILIAL = '" + cSC1Filial + "'"
		cExprFilTop +=		" AND "
		cExprFilTop +=			"AC9.AC9_ENTIDA = 'SC1'"
		cExprFilTop +=		" AND "
		cExprFilTop +=			"AC9.AC9_CODOBJ = ACB.ACB_CODOBJ"
		cExprFilTop +=		" AND "
		cExprFilTop +=			"AC9.AC9_FILENT = SC1.C1_FILIAL"
		cExprFilTop +=		" AND "
		cExprFilTop +=			"AC9.AC9_CODENT = SC1.C1_FILIAL+SC1.C1_NUM+SC1.C1_ITEM"
		cExprFilTop += ")"

	EndIF

    cSvExprFilTop    := StaticCall( NDJLIB001 , GetSetMbFilter , cExprFilTop )

	SetMBTopFilter( "SC1" , ""  )
	SetMBTopFilter( "SC1" , cExprFilTop , .T. )
	
	oObjBrow	:= GetObjBrow()
	oObjBrow:GoTop()
	oObjBrow:Refresh()

Return( cSvExprFilTop )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
    	MATA110SC()
    	AC9SC1SetFilter()
		lRecursa	:= __Dummy( .F. )
		__cCRLF		:= NIL
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )