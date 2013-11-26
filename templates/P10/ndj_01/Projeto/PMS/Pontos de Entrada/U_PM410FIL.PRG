#INCLUDE "NDJ.CH"
/*/
	Funcao:		PM410FIL
	Autor:		Marinaldo de Jesus
	Data:		24/02/2011
	Descricao:	Ponto de Entrada PM410FIL, executado em PMSA410.
	Uso:		Originalmente Definido para Implementar Filtro na mBrowse, sera utilizado, tambem para Alterar as Opcoes do aRotina
/*/
User Function PM410FIL()

	Local cFiltBrw	:= ""
	
	Local oException
	
	TRYEXCEPTION

		IF ( Type( "aRotina" ) == "A" )
			ChgMenuDef()
		EndIF
	
	CATCHEXCEPTION oException

		IF ( ValType( oException ) == "O" )
			IF ( lShowHelp )
				Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
			Else
				ConOut( oException:Description , oException:ErrorStack )
			EndIF
		EndIF

	ENDEXCEPTION

Return( cFiltBrw )

/*/
	Funcao: 	ChgMenuDef
	Autor:		Marinaldo de Jesus
	Data:		24/02/2011
	Descricao:	Desabilitar a Opcao de Revisao no Menu do PMS
/*/
Static Function ChgMenuDef()

	Local nIndex

	BEGIN SEQUENCE
	
        IF GetNewPar( "NDJ_PMSREV" , .F. ) //Verifica se Permite a Revisao PluriAnual
			BREAK
		EndIF

		nIndex := aScan( aRotina , { |aElem| Upper( "Revisoes" ) $ Upper( aElem[1] ) } )
	
		IF .NOT.( nIndex > 0 )
			BREAK
		EndIF
		
		aRotina[ nIndex ][2] := "MsgInfo( 'Opção Disponível apenas na Revisão dos Projetos PluriAnuais' )"

	END SEQUENCE	

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