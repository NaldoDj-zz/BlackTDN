#INCLUDE "NDJ.CH"
/*/
	Programa: 	PMXBRCOL
	Data:		24/08/2011
	Autor:		Marinaldo de Jesus
	Descricao:	Ponto de Entrada PMXBRCOL, executado em PmsPlanAF8 no progama PMSXFUN.PRX sera utilizado para:
				1 ) Atualizar as Areas de Trabalho para Obtencao dos Valores Previstos, Empenhados e Realizados
/*/
User Function PMXBRCOL()

	Local oBrowse		:= ParamIxb[ 1 ]
*	Local cArquivo		:= ParamIxb[ 2 ]

    Local bEmpFrmTrab	:= { || StaticCall( U_NDJBLKSCVL , EmpFrmTrab ) }
	Local bLDBLClick	:= oBrowse:bLDBLClick

	//Redefine Bloco para Atualizar as Areas de Trabalho para Obtencao dos Valores Previstos, Empenhados e Realizados
    oBrowse:bLDBLClick    := { || StaticCall( U_NDJBLKSCVL , EmpFrmTrab ) , Eval( bLDBLClick ) }

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