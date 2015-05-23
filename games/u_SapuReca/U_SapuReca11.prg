#include "totvs.ch"
/*
    Funcao:SapuReca()
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:23/03/2012
    Uso:Jogo SapuReca PT11
*/
Static Procedure SapuReca(oTHash,cTitle)

    Local lExecute

    BEGIN SEQUENCE

        lExecute:=(Upper(ProcName(1))=="U_SAPURECA")
        IF .NOT.(lExecute)
            MsgAlert("Invalid Function Call:"+ProcName(),"By By")
            BREAK
        EndIF

        StaticCall(U_SapuReca10,Sapureca,@oTHash,@cTitle)

    END SEQUENCE

Return
