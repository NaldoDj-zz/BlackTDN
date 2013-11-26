#INCLUDE "NDJ.CH"
/*/
	Funcao:	PMSAF8DLG
	Autor:	Marinaldo de Jesus
	Data:	24/08/2011
    Uso:    Ponto de Entrada PMSAF8DLG. Sera utilizado Para Preparar o Ambiente Para Apuracao dos Valores Empenhados e Realizados
/*/
User Function PMSAF8DLG()

	Local aCampos			:= ParamIxb[ 1 ]

	//Monta as Areas de Trabalho para Obtencao dos Valores Previstos, Empenhados e Realizados
    StaticCall( U_NDJBLKSCVL , EmpFrmTrab )

Return( aCampos )

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