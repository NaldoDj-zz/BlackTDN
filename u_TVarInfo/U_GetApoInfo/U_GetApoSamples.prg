#INCLUDE "NDJ.CH"
//------------------------------------------------------------------------------------------------
    /*/
        Funcao:U_GetApoSamples
        Autor:Marinaldo de Jesus
        Data:28/09/2011
        Descricao:Exemplo de uso da U_GetApoInfo()
        Sintaxe:U_GetApoSamples()
    /*/
//------------------------------------------------------------------------------------------------
User Function GetApoSamples()

    Local aArray:=Array(10, 20)
    Local aClone:={aArray,aArray,{aArray,aArray},{{{{aArray,aArray,aArray,{{aArray}}}}}}}
    Local aValues:={;
                            10.50,;
                            ProcName(),;
                            ProcLine(),;
                            Array(5,5),;
                            MsDate(),;
                            .T.,;
                            .F.,;
                            1579866589.25478,;
                            "Ola Mundo",;
                            {||.T.},;
                            {||.F.};
                       }

    Local bQuery1:={|aQuery,cPrgFile|aScan(aQuery,{|cQry|(SubStr(cPrgFile,1,Len(FileNoExt(cPrgFile)))==cQry)})>0}
    Local bQuery2:={|aQuery,cPrgFile|aScan(aQuery,{|cQry|(SubStr(cPrgFile,1,Len(cQry))==cQry)})>0}
    
    Local oVarInfo:=TVarInfo():New(aValues)

    oVarInfo:Save(.T.,.T.)
    oVarInfo:Show()

    oVarInfo:ReSet(aArray,NIL,.T.,.F.)
    oVarInfo:Save(.T.,.F.)
    oVarInfo:Show()

    oVarInfo:ReSet(aClone,NIL,.T.,.F.)
    oVarInfo:Save(.T.,.F.)
    oVarInfo:Show()

    oVarInfo:ReSet(oVarInfo,NIL,.T.,.F.)
    oVarInfo:Save(.T.,.F.)
    oVarInfo:Show()
    
    oVarInfo:Close(.T.,.F.)
    oVarInfo:=NIL

    U_GetApoInfo("*",NIL,NIL,NIL,NIL,NIL,NIL,.F.)
    U_GetApoInfo("MAT*")
    U_GetApoInfo("FINA,MATA",",")
    U_GetApoInfo("FINA*",",",NIL,.T.)
    U_GetApoInfo("*FIS*",",",NIL,.T.)
    U_GetApoInfo("FINA",",",NIL,.F.)
    U_GetApoInfo("FINA010,FINA040,MATA070",",",NIL,.F.)
    U_GetApoInfo({"FINA010","FINA040","MATA070"})
    U_GetApoInfo({"FINA010","FINA040","MATA070"},NIL,bQuery1,.F.)
    U_GetApoInfo("FINA010,MATA010",",",bQuery1,.F.,.F.,.T.)
    U_GetApoInfo("FINA010,MATA010",",",bQuery2,.F.)

Return(NIL)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:U_ExTVarInfo()
        Autor:Marinaldo de Jesus
        Data:28/09/2011
        Descricao:Exemplo de uso da TVarInfo
        Sintaxe:U_ExTVarInfo()
    /*/
//------------------------------------------------------------------------------------------------
User Function ExTVarInfo()

    Local oVarInfo:=TVarInfo():New(__FunArr())

    oVarInfo:Save(.T.,.F.)
    oVarInfo:Show()

    oVarInfo:ReSet(__ClsArr(),NIL,.T.,.F.)
    oVarInfo:Save(.T.,.F.)
    oVarInfo:Show()

Return(NIL)

Static Function __Dummy(lRecursa)
    Local oException
    TRYEXCEPTION
        lRecursa:=.F.
        IF !(lRecursa)
            BREAK
        EndIF
        lRecursa:=__Dummy(.F.)
        __cCRLF:=NIL
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return(lRecursa)
