#INCLUDE "NDJ.CH"
/*/
	Funcao: 	MT110END
	Autor:		Marinaldo de Jesus
	Data:		28/11/2011
	Descricao:	Ponto de Entrada MT110END. Sera utilizado para verificar qual Opcao Selecionada na Rotina de Aprovacao de SC
/*/
User Function MT110END()

	Local cNumSc	:= ParamIxb[ 1 ]
	Local nOpcA		:= ParamIxb[ 2 ]

    StaticCall( NDJLIB004 , SetPublic , "__lMT110END" , .T.		, "L"    , 1				, .T. )
    StaticCall( NDJLIB004 , SetPublic , "__cMT110END" , cNumSc	, "C"    , Len( cNumSc )	, .T. )
    StaticCall( NDJLIB004 , SetPublic , "__nMT110END" , nOpcA	, "N"    , 1				, .T. )    //C1_APROV: 1->"L";2->"R";3->"B"

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