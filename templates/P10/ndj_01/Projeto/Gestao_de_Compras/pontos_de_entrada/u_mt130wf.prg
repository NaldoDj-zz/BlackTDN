#INCLUDE "NDJ.CH"
/*/
    Funcao: MT130WF
/*/
User Function MT130WF()

    Local aSc8Num    := ParamIxb[2]
    Local cSc8Num    := ParamIxb[1]

    ParamIxb[1] := cSC8Num
    ParamIxb[2] := aSc8Num

Return( NIL )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        lRecursa    := __Dummy( .F. )
        __cCRLF        := NIL
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
