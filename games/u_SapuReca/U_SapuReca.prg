#include "totvs.ch"
/*/
    Funcao:U_SapuReca()
    Autor:Marinaldo de Jesus
    Data:23/03/2012
    Uso:Jogo SapuReca
/*/
User Function SapuReca()

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

        cTitle:="Jogo SapuReca::by Naldo DJ [http://www.blacktdn.com.br]::v1.0b"
        cRpoVersion:=GetSrvProfString("RpoVersion","")
        nVarNameLen:=SetVarNameLen(50)  //Redefino para poder usar Nomes Longos
        oTHash:=InitSapuReca()

        PTInternal(1,cTitle)

        IF (cRpoVersion=="101")
            StaticCall(U_SapuReca10,Sapureca,@oTHash,@cTitle)   //Protheus 10
        ElseIF (cRpoVersion=="110")
            StaticCall(U_SapuReca11,Sapureca,@oTHash,@cTitle)   //Protheus 11
        EndIF
    
        RemoveFiles(@oTHash,"SapuReca_Files")
        RemoveFiles(@oTHash,"SapuReca_Waves")
    
        oTHash:=FreeObj(oTHash)
    
        SetVarNameLen(nVarNameLen) //Restauro o Padrao

        __Quit()

    END SEQUENCE

Return(.T.)

/*/
    Funcao:InitSapuReca
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:23/03/2012
    Uso:Inicializa Parametros
/*/
Static Function InitSapuReca()

    Local oTHash:=THash():New()

    oTHash:AddNewSession("FINALIZE")
    oTHash:AddNewproperty("FINALIZE","Finalize",.F.)

    oTHash:AddNewSession("SapuReca_Path")
    oTHash:AddNewProperty("SapuReca_Path","TEMP_PATH",GetTempPath()+"sapureca\")

    oTHash:AddNewSession("SapuReca_Index")
    oTHash:AddNewProperty("SapuReca_Index","ID",1)
    oTHash:AddNewProperty("SapuReca_Index","TYPE",2)
    oTHash:AddNewProperty("SapuReca_Index","LEFT",3)
    oTHash:AddNewProperty("SapuReca_Index","TOP",4)
    oTHash:AddNewProperty("SapuReca_Index","WIDTH",5)
    oTHash:AddNewProperty("SapuReca_Index","HEIGHT",6)
    oTHash:AddNewProperty("SapuReca_Index","IMAGE",7)
    oTHash:AddNewProperty("SapuReca_Index","TOOLTIP",8)
    oTHash:AddNewProperty("SapuReca_Index","MOVE",9)
    oTHash:AddNewProperty("SapuReca_Index","DEFORM",10)
    oTHash:AddNewProperty("SapuReca_Index","MARK",11)
    oTHash:AddNewProperty("SapuReca_Index","CONTAINER",12)
    oTHash:AddNewProperty("SapuReca_Index","STRING",13)
    oTHash:AddNewProperty("SapuReca_Index","VISIBLE",14)
    oTHash:AddNewProperty("SapuReca_Index","BACTION",15)
    oTHash:AddNewProperty("SapuReca_Index","DIRECTION",16)
    oTHash:AddNewProperty("SapuReca_Index","MOVE1_LEFT",17)
    oTHash:AddNewProperty("SapuReca_Index","MOVE1_TOP",18)
    oTHash:AddNewProperty("SapuReca_Index","MOVE1_WIDTH",19)
    oTHash:AddNewProperty("SapuReca_Index","MOVE1_HEIGHT",20)
    oTHash:AddNewProperty("SapuReca_Index","MOVE2_LEFT",21)
    oTHash:AddNewProperty("SapuReca_Index","MOVE2_TOP",22)
    oTHash:AddNewProperty("SapuReca_Index","MOVE2_WIDTH",23)
    oTHash:AddNewProperty("SapuReca_Index","MOVE2_HEIGHT",24)
    oTHash:AddNewProperty("SapuReca_Index","MOVE1_IMAGE",25)
    oTHash:AddNewProperty("SapuReca_Index","MOVE1_FRAME",26)
    oTHash:AddNewProperty("SapuReca_Index","MOVE2_IMAGE",27)
    oTHash:AddNewProperty("SapuReca_Index","MOVE2_FRAME",28)
    oTHash:AddNewProperty("SapuReca_Index","MOVE1_JUMP",29)
    oTHash:AddNewProperty("SapuReca_Index","MOVE2_JUMP",30)
    oTHash:AddNewProperty("SapuReca_Index","INDEX",31)
    oTHash:AddNewProperty("SapuReca_Index","CURRENT_FRAME",32)
    oTHash:AddNewProperty("SapuReca_Index","FRAME_EXIT",33)
    
    oTHash:AddNewProperty("SapuReca_Index","ELEMENTS",33)

    oTHash:AddNewSession("SapuReca_Files")
    oTHash:AddNewProperty("SapuReca_Files","JOGO_INSTRUCOES","instrucoes.gif")
    oTHash:AddNewProperty("SapuReca_Files","JOGO_BACKGROUND","pantano.jpg")
    oTHash:AddNewProperty("SapuReca_Files","JOGO_PARABENS","Parabens.gif")
    oTHash:AddNewProperty("SapuReca_Files","JOGO_ICO","perereca.ico")
    oTHash:AddNewProperty("SapuReca_Files","RECA_FRAME_START","reca_1_frame_0000.gif")
    oTHash:AddNewProperty("SapuReca_Files","RECA_JUMP_1","reca_J1.gif")
    oTHash:AddNewProperty("SapuReca_Files","RECA_JUMP_2","reca_J2.gif")
    oTHash:AddNewProperty("SapuReca_Files","JOGO_REINICIAR","reiniciar.gif")
    oTHash:AddNewProperty("SapuReca_Files","SAPO_DANCANTE","sapo_dancando.gif")
    oTHash:AddNewProperty("SapuReca_Files","SAPO_INSETO","sapoinseto.gif")
    oTHash:AddNewProperty("SapuReca_Files","SAPU_FRAME_START","sapu_1_frame_0000.gif")
    oTHash:AddNewProperty("SapuReca_Files","SAPU_JUMP_1","sapu_j1.gif")
    oTHash:AddNewProperty("SapuReca_Files","SAPU_JUMP_2","sapu_j2.gif")
    oTHash:AddNewProperty("SapuReca_Files","PASSARO_VOANDO","passaro_voando.gif")

    ExtractFiles(oTHash,"SapuReca_Files")

    oTHash:AddNewSession("SapuReca_Waves")
    oTHash:AddNewProperty("SapuReca_Waves","SOM_APLAUSOS","aplausos.wav")
    oTHash:AddNewProperty("SapuReca_Waves","SOM_SAPU_RECA","sapo.wav")
    oTHash:AddNewProperty("SapuReca_Waves","SOM_BACKGROUND","sapos.wav")
    
    ExtractFiles(oTHash,"SapuReca_Waves")

Return(oTHash)

/*/
    Funcao:ExtractFiles
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:23/03/2012
    Uso:Extrai os arquivos do RPO
/*/
Static Procedure ExtractFiles(oTHash,cSession)

    Local aAllProperties:=oTHash:GetAllProperties(cSession)
    Local cTempPath:=oTHash:Getproperty("SapuReca_Path","TEMP_PATH")
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
    Data:23/03/2012
    Uso:Exclui os arquivos Temporarios
/*/
Static Procedure RemoveFiles(oTHash,cSession)

    Local aAllProperties:=oTHash:GetAllProperties(cSession)

    aEval(aAllProperties,{|f|IF(File(f[2]),fErase(f[2]),NIL)})

Return
