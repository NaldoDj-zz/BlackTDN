#INCLUDE "NDJ.CH"
/*/
	Function:	U_MATA103P
	Autor:		Marinaldo de Jesus
	Data:		18/01/2011
	Descricao:	Cadastro de Projetos/Doc.Entrada
	Sintaxe:	U_MATA103P
/*/
User Function MATA103P()

	Local aArea 			:= GetArea()
	Local aIndex 			:= {}
	Local aAF8Area			:= AF8->( GetArea() )
	Local aSF1Area			:= SF1->( GetArea() )

	Local cExprFilTop		:= ""
	
	Local nAF8Order			:= RetOrder( "AF8" , "AF8_FILIAL+AF8_PROJET+AF8_REVISA" )

	BEGIN SEQUENCE

		Private aRotina		:= {;
									{ "Pesquisar"		, "PesqBrw"														, 0 , 01 } ,;
									{ "Doc. de Entrada"	, "StaticCall(U_MATA103P,MATA103NFE,'AF8',AF8->(Recno()),2)"	, 0 , 02 }  ;
								}

		Private aTela    	:= {}
		Private aGets    	:= {}

		Private cCadastro	:= OemToAnsi( "Cadastro de Fornecedores vs Contratos" )
		Private bFiltraBrw	:= { || .F. }

		AF8->( dbSetOrder( nAF8Order ) )

		cExprFilTop	:= "AF8_PROJET "
		cExprFilTop	+= "IN "
		cExprFilTop	+= "("
		cExprFilTop	+= 	"SELECT DISTINCT "
		cExprFilTop	+=		"AF8_PROJET "
		cExprFilTop	+=	"FROM "
		cExprFilTop	+=		RetSqlName( "AF8" ) + " AF8, "
		cExprFilTop	+=		RetSqlName( "SD1" ) + " SD1 "
		cExprFilTop	+=	"WHERE "
		cExprFilTop	+=		"AF8.D_E_L_E_T_<>'*' "
		cExprFilTop	+=	" AND "
		cExprFilTop	+=		"SD1.D_E_L_E_T_<>'*' "
		cExprFilTop	+=	" AND "
		cExprFilTop	+=		"AF8.AF8_FILIAL = '" + xFilial( "AF8" ) + "'"
		cExprFilTop	+=	" AND "
		cExprFilTop	+=		"SD1.D1_FILIAL = '" + xFilial( "SD1" ) + "'"
		cExprFilTop	+=	" AND "
		cExprFilTop	+=		"AF8.AF8_PROJET=SD1.D1_XPROJET "
		cExprFilTop	+= ")"

		AF8->( dbSetOrder( nAF8Order ) )

        StaticCall( NDJLIB001 , GetSetMbFilter , cExprFilTop )

		MBrowse( 6 , 1 , 22 , 75 , "AF8" , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , cExprFilTop )

	END SEQUENCE

	RestArea( aSF1Area )
	RestArea( aAF8Area )
	RestArea( aArea )

Return( NIL )

/*/
	Function:	MATA103NFE
	Autor:		Marinaldo de Jesus
	Data:		18/01/2011
	Descricao:	Chamada a Rotina de Nota Fiscal de Entrada
	Sintaxe:	StaticCall(U_MATA103P,MATA103NFE,cAlias,nReg,nOpc)
/*/
Static Function MATA103NFE( cAlias , nReg , nOpc )

	Local aArea			:= GetArea()
	Local aIndex		:= {}
	Local aSF1Area		:= SF1->( GetArea() )
	Local aModuloReSet	:= SetModulo( "SIGACOM" , "COM" )
	
	Local cFiltra		:= ""
	Local cProjeto
	Local cSF1Alias		:= "SF1"
	
	Local cExprFilTop	:= ""
	
	Local nSF1Reg
	Local nSF1Order		:= RetOrder( cSF1Alias , "F1_FILIAL+F1_FORNECE+F1_LOJA+F1_DOC" )

	Local uRet

	Private aTela    	:= {}
	Private aGets    	:= {}

	EndFilBrw( "AF8" , @aIndex )

	TRYEXCEPTION

		( cAlias )->( MsGoto( nReg ) )
		
		cProjeto		:= ( cAlias )->( AF8_PROJET )

		SF1->( dbSetOrder( nSF1Order ) )

		cExprFilTop := "F1_DOC+F1_SERIE "
		cExprFilTop +=	"IN "
		cExprFilTop +=	"("
		cExprFilTop += 		"SELECT DISTINCT "
		cExprFilTop += 			" SF1.F1_DOC+SF1.F1_SERIE "
		cExprFilTop +=		"FROM "
		cExprFilTop +=			RetSqlName( "SF1" ) + " SF1, "
		cExprFilTop +=			RetSqlName( "AF8" ) + " AF8, "
		cExprFilTop +=			RetSqlName( "SD1" ) + " SD1 "
		cExprFilTop +=		" WHERE "
		cExprFilTop +=			"SF1.D_E_L_E_T_<>'*'"
		cExprFilTop +=		" AND "
		cExprFilTop +=			"AF8.D_E_L_E_T_<>'*'"
		cExprFilTop +=		" AND "
		cExprFilTop +=			"SD1.D_E_L_E_T_<>'*'"
		cExprFilTop +=		" AND "
		cExprFilTop +=			"SF1.F1_FILIAL = '" + xFilial( "SF1" ) + "'"
		cExprFilTop +=		" AND "
		cExprFilTop +=			"AF8.AF8_FILIAL = '" + xFilial( "AF8" ) + "'"
		cExprFilTop +=		" AND "
		cExprFilTop +=	   		"SD1.D1_FILIAL = '" + xFilial( "SD1" ) + "'"
		cExprFilTop +=	   	" AND "
		cExprFilTop +=	   		"AF8.AF8_PROJET = '" + cProjeto + "'"
		cExprFilTop +=	   	" AND "
		cExprFilTop +=	   		"SD1.D1_XPROJET = '" + cProjeto + "'"
		cExprFilTop +=	   	" AND "
		cExprFilTop +=	   		"SF1.F1_DOC = SD1.D1_DOC"
		cExprFilTop +=	   	" AND "
		cExprFilTop +=	   		"AF8.AF8_PROJET = SD1.D1_XPROJET"
		cExprFilTop += 		")"

        cSvExprFilTop    := StaticCall( NDJLIB001 , GetSetMbFilter , cExprFilTop )
	
		SetMBTopFilter( "AF8" , ""  )
		SetMBTopFilter( "SF1" , cExprFilTop , .F. )

		uRet := __Execute( "MATA103()" , "xxxxxxxxxxxxxxxxxxxx" , "MATA103" , AllTrim(Str(nModulo)) , "" , 1 , .T. )

        StaticCall( NDJLIB001 , GetSetMbFilter , cSvExprFilTop )

		SetMBTopFilter( "SF1" , "" )

		SetMBTopFilter( "AF8" , cSvExprFilTop )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
			ConOut( CaptureError() )
		EndIF

	ENDEXCEPTION

	ReSetModulo( aModuloReSet )

	RestArea( aSF1Area )
	RestArea( aArea )

Return( uRet )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
    	MATA103NFE()
		lRecursa	:= __Dummy( .F. )
		__cCRLF		:= NIL
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )