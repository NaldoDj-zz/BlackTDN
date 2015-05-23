#include "totvs.ch"
/*
    Funcao:Game15()
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:16/04/2012
    Uso:Jogo Game15 PT11
*/
Static Procedure Game15(oTHash,cTitle)

    Local lExecute

    BEGIN SEQUENCE

        lExecute:=(Upper(ProcName(1))=="U_GAME15")
        IF .NOT.(lExecute)
            MsgAlert("Invalid Function Call:"+ProcName(),"By By")
            BREAK
        EndIF

        StaticCall(U_Game1510,Game15,@oTHash,@cTitle)

    END SEQUENCE

Return

/*
    Funcao:__Dummy
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:16/04/2012
    Uso:Dummy
*/
Static Function __Dummy(lRecursa)
    DEFAULT lRecursa:=.F.
    BEGIN SEQUENCE
        IF .NOT.(lRecursa)
            BREAK
        EndIF
        Game15()
        lRecursa:=__Dummy(.F.)
    END SEQUENCE
Return(lRecursa)
