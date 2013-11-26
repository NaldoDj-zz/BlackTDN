#INCLUDE "NDJ.CH"
/*/
	Function:	U_MATA103F
	Autor:		Marinaldo de Jesus
	Data:		18/01/2011
	Descricao:	Cadastro de Fornecedores/Doc.Entrada
	Sintaxe:	U_MATA103F
/*/
User Function MATA103F()

	Local aArea 			:= GetArea()
	Local aSA2Area			:= SA2->( GetArea() )
	Local aSF1Area			:= SF1->( GetArea() )
	
	Local cExprFilTop		:= ""

	BEGIN SEQUENCE

		Private aRotina		:= {;
									{ "Pesquisar"		, "PesqBrw"														, 0 , 01 } ,;
									{ "Doc. de Entrada"	, "StaticCall(U_MATA103F,MATA103NFE,'SA2',SA2->(Recno()),2)"	, 0 , 02 }  ;
								}

		Private aTela    	:= {}
		Private aGets    	:= {}

		Private cCadastro	:= OemToAnsi( "Cadastro de Fornecedores vs Contratos" )
		Private bFiltraBrw	:= { || .F. }

		cExprFilTop	:= "A2_COD+A2_LOJA "
		cExprFilTop	+= "IN "
		cExprFilTop	+= "("
		cExprFilTop	+= "SELECT DISTINCT "
		cExprFilTop	+= 		"SA2.A2_COD+SA2.A2_LOJA "
		cExprFilTop	+= "FROM "
		cExprFilTop	+= 		RetSqlName( "SA2" ) + " SA2, "
		cExprFilTop	+=		RetSqlName( "SF1" ) + " SF1 "
		cExprFilTop	+= "WHERE "
		cExprFilTop	+= 		"SA2.D_E_L_E_T_<>'*' "
		cExprFilTop	+=	" AND "
		cExprFilTop	+= 		"SF1.D_E_L_E_T_<>'*' "
		cExprFilTop	+=	" AND "
		cExprFilTop	+= 		"SA2.A2_FILIAL='" + xFilial( "SA2" ) + "'"
		cExprFilTop	+=	" AND "
		cExprFilTop	+= 		"SF1.F1_FILIAL='" + xFilial( "SF1" ) + "'"
		cExprFilTop	+=	" AND "
		cExprFilTop	+= 		"SA2.A2_COD=SF1.F1_FORNECE "
		cExprFilTop	+=	" AND "
		cExprFilTop	+= 		"SA2.A2_LOJA=SF1.F1_LOJA "
		cExprFilTop	+= ")"

		MBrowse( 6 , 1 , 22 , 75 , "SA2" , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , cExprFilTop )

	END SEQUENCE

	RestArea( aSF1Area )
	RestArea( aSA2Area )
	RestArea( aArea )

Return( NIL )

/*/
	Function:	MATA103NFE
	Autor:		Marinaldo de Jesus
	Data:		18/01/2011
	Descricao:	Chamada a Rotina de Nota Fiscal de Entrada
	Sintaxe:	StaticCall(U_MATA103F,MATA103NFE,cAlias,nReg,nOpc)
/*/
Static Function MATA103NFE( cAlias , nReg , nOpc )

	Local aArea			:= GetArea()
	Local aIndex		:= {}
	Local aSF1Area		:= SF1->( GetArea() )
	Local aModuloReSet	:= SetModulo( "SIGACOM" , "COM" )
	
	Local bSvFilBrw		:= bFiltraBrw
	
	Local cFiltra		:= ""
	Local cSF1Alias		:= "SF1"
	Local cSF1KeySeek

	Local nSF1Reg
	Local nSF1Order		:= RetOrder( cSF1Alias , "F1_FILIAL+F1_FORNECE+F1_LOJA+F1_DOC" )

	Local uRet

	Private aTela    	:= {}
	Private aGets    	:= {}

	TRYEXCEPTION

		( cAlias )->( MsGoto( nReg ) )

		cFiltra		:= SA2->( "@F1_FORNECE='"+A2_COD+"' AND F1_LOJA='"+A2_LOJA+ "'" )

		bFiltraBrw	:= { || FilBrowse( "SF1" , @aIndex , @cFiltra ) }

		SF1->( dbSetOrder( nSF1Order ) )
		
		SF1->( Eval( bFiltraBrw ) )		

		uRet := __Execute( "MATA103()" , "xxxxxxxxxxxxxxxxxxxx" , "MATA103" , AllTrim(Str(nModulo)) , "" , 1 , .T. )

		SF1->( EndFilBrw( "SF1" , aIndex ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
			ConOut( CaptureError() )
		EndIF

	ENDEXCEPTION

	bFiltraBrw	:= bSvFilBrw
	SA2->( Eval( bFiltraBrw ) )

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