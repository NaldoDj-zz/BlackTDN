#include "totvs.ch"
/*

    Funcao:Game15()
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:16/04/2012
    Uso:Jogo Game15

    * Copyright 2012-2912 marinaldo.jesus <http://www.blacktdn.com.br>

    Baseado no Original de:

     * MINIGUI - Harbour Win32 GUI library Demo
     *
     * Copyright 2002-09 Roberto Lopez <harbourminigui@gmail.com>
     * http://harbourminigui.googlepages.com/
     *
     * Copyright 2003-2009 Grigory Filatov <gfilatov@inbox.ru>

*/
User Function Game15()

    Local cTitle
    Local cRpoVersion
    Local nVarNameLen
    
    Local oTHash
    
    Local lExecute:=Empty(ProcName(1))

    BEGIN SEQUENCE

        IF .NOT.(lExecute)
            MsgAlert("Invalid Function Call:"+ProcName(),"By By")
            BREAK
        EndIF

        cTitle:="Jogo Game15::by Naldo DJ::v1"
        cRpoVersion:=GetSrvProfString("RpoVersion","")
        nVarNameLen:=SetVarNameLen(50)  //Redefino para poder usar Nomes Longos
        oTHash:=InitGame15()

        PTInternal(1,cTitle)

        IF (cRpoVersion =="101")
            StaticCall(U_Game1510,Game15,@oTHash,@cTitle)   //Protheus 10
        ElseIF (cRpoVersion =="110")
            StaticCall(U_Game1511,Game15,@oTHash,@cTitle)   //Protheus 11
        Else
            StaticCall(U_Game1511,Game15,@oTHash,@cTitle)   //Undefined Version (sera q funfa?)
        EndIF

        RemoveFiles(@oTHash,"Game15_Files_buttons")
        RemoveFiles(@oTHash,"Game15_Files_bmps_aux")
        RemoveFiles(@oTHash,"Game15_Files_bmps_play")

        oTHash :=FreeObj(oTHash)

        SetVarNameLen(nVarNameLen) //Restauro o Padrao

        __Quit()

    END SEQUENCE

Return(.T.)

/*/
    Funcao:InitGame15
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:16/04/2012
    Uso:Inicializa Parametros
/*/
Static Function InitGame15()

    Local cFile
    Local cTempPath:=(GetTempPath()+"Game15\")

    Local oTHash:=THash():New()
    
    Local nFile
    Local nFiles

    oTHash:AddNewSession("Game15_Path")
    oTHash:AddNewSession("Game15_Files_ico")
    oTHash:AddNewSession("Game15_Files_bmps_play")
    oTHash:AddNewSession("Game15_Files_bmps_aux")
    oTHash:AddNewSession("Game15_Files_buttons")

    oTHash:AddNewProperty("Game15_Path","Temp_Path",cTempPath)

    oTHash:AddNewProperty("Game15_Files_ico","ico","game15_ico.ico")

    nFiles:=16
    For nFile:=1 To nFiles
        cFile:=StrZero(nFile,2)
        oTHash:AddNewProperty("Game15_Files_bmps_play","b"+cFile,"game15_b"+cFile+".bmp")
    Next nFile

    oTHash:AddNewProperty("Game15_Files_bmps_aux","minbtn","game15_minbtn.bmp")
    oTHash:AddNewProperty("Game15_Files_bmps_aux","mainform","game15_mainform.bmp")
    oTHash:AddNewProperty("Game15_Files_bmps_aux","closebtn","game15_closebtn.bmp")

    oTHash:AddNewProperty("Game15_Files_buttons","about","game15_about.bmp")
    oTHash:AddNewProperty("Game15_Files_buttons","clear","game15_clear.bmp")
    oTHash:AddNewProperty("Game15_Files_buttons","exit","game15_exit.bmp")
    oTHash:AddNewProperty("Game15_Files_buttons","load","game15_load.bmp")
    oTHash:AddNewProperty("Game15_Files_buttons","ok","game15_ok.bmp")
    oTHash:AddNewProperty("Game15_Files_buttons","save","game15_save.bmp")
    oTHash:AddNewProperty("Game15_Files_buttons","start","game15_start.bmp")
    oTHash:AddNewProperty("Game15_Files_buttons","top10","game15_top10.bmp")

    ExtractFiles(@oTHash,"Game15_Files_buttons")
    ExtractFiles(@oTHash,"Game15_Files_bmps_aux")
    ExtractFiles(@oTHash,"Game15_Files_bmps_play")

Return(oTHash)

/*/
    Funcao:ExtractFiles
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:16/04/2012
    Uso:Extrai os arquivos do RPO
/*/
Static Procedure ExtractFiles(oTHash,cSession)

    Local aAllProperties:=oTHash:GetAllProperties(cSession)
    Local cTempPath:=oTHash:Getproperty("Game15_Path","Temp_Path")
    Local cProperty
    Local cResource
    Local cExtractFile

    Local nProperty
    Local nProperties

    IF .NOT.(lIsDir(cTempPath))
        MakeDir(cTempPath)
    EndIF

    nProperties:=Len(aAllProperties)
    For nProperty:=1 To nProperties
        cProperty:=aAllProperties[nProperty][1]
        cResource:=aAllProperties[nProperty][2]
        cExtractFile:=(cTempPath+cResource)
        Resource2File(cResource,cExtractFile)
        oTHash:SetPropertyValue(@cSession,@cProperty,@cExtractFile)
    Next nProperty

Return

/*/
    Funcao:RemoveFiles
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:16/04/2012
    Uso:Exclui os arquivos Temporarios
/*/
Static Procedure RemoveFiles(oTHash,cSession)

    Local aAllProperties:=oTHash:GetAllProperties(cSession)

    aEval(aAllProperties,{|f|IF(File(f[2]),fErase(f[2]),NIL)})

Return
