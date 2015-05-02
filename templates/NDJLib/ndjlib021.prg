#include "ndj.ch"

#ifdef SPANISH
        #DEFINE STR0001 "Salvando Tabelas"
        #DEFINE STR0002 "Impossivel Criar o Diretorio. Verifique o Conteudo da Configuracao "
        #DEFINE STR0003 " no arquivo "
        #DEFINE STR0004 "Impossivel Copiar o arquivo de senhas "
        #DEFINE STR0005 " para "
        #DEFINE STR0006 "Invalid Function Call:"
        #DEFINE STR0007 "Arquivo de Configuração não encontrado"
        #DEFINE STR0008 " Chave:"
        #DEFINE STR0009 " Não Configurada no arquivo:"
        #DEFINE STR0010 " Secao "
        #DEFINE STR0011 "Diretorio:"
        #DEFINE STR0012 " nao encontrado"
        #DEFINE STR0013 "O Diretorio Base Para Restauracao deve ser informado"
        #DEFINE STR0014 "Nao Existe arquivo de Configuracao no Diretorio Informado"
        #DEFINE STR0015 "Ambiente de Configuracao para Restauracao Inválido"
        #DEFINE STR0016 "Ponto de Restauracao"
        #DEFINE STR0017 "Ambiente de Restauracao em uso."
        #DEFINE STR0018 "Rotina de Restauração em Uso"
        #DEFINE STR0019 "Restauração do Sistema"
        #DEFINE STR0020 "Ambiente de Restauração Atualizado. Reload Será efetuado para Carga da Nova Configuração"
        #DEFINE STR0021 "Configuração atual não permite a Restauração do Sistema"
        #DEFINE STR0022 "Atenção"
        #DEFINE STR0023 "Aguarde"
        #DEFINE STR0024 "Carregando o Ambiente de Restauração"
        #DEFINE STR0025 "Problemas com a Conexão ao DMBS do ambiente de Restauração"
        #DEFINE STR0026 "Problema na Restauração do ambiente. Tabela:"
        #DEFINE STR0027 " Não encontrada"
        #DEFINE STR0028 "Impossível abrir a tabela:"
        #DEFINE STR0029 "Indexando..."
        #DEFINE STR0030 "Impossivel Conectar-se ao DBMS para Restauracao"
        #DEFINE STR0031 "Atualizando o Ambiente de Restauração"
        #DEFINE STR0032 "Chave para Pesquisa nao informada no Destino"
        #DEFINE STR0033 "Impossivel Criar o Diretorio para vinculo simbolico. Entre em contato com o Adminisrtador do sistema"
        #DEFINE STR0034 "Confirma a Restauração do Ambiente?"
#else
    #ifdef ENGLISH
        #DEFINE STR0001 "Salvando Tabelas"
        #DEFINE STR0002 "Impossivel Criar o Diretorio. Verifique o Conteudo da Configuracao "
        #DEFINE STR0003 " no arquivo "
        #DEFINE STR0004 "Impossivel Copiar o arquivo de senhas "
        #DEFINE STR0005 " para "
        #DEFINE STR0006 "Invalid Function Call:"
        #DEFINE STR0007 "Arquivo de Configuração não encontrado"
        #DEFINE STR0008 " Chave:"
        #DEFINE STR0009 " Não Configurada no arquivo:"
        #DEFINE STR0010 " Secao "
        #DEFINE STR0011 "Diretorio:"
        #DEFINE STR0012 " nao encontrado"
        #DEFINE STR0013 "O Diretorio Base Para Restauracao deve ser informado"
        #DEFINE STR0014 "Nao Existe arquivo de Configuracao no Diretorio Informado"
        #DEFINE STR0015 "Ambiente de Configuracao para Restauracao Inválido"
        #DEFINE STR0016 "Ponto de Restauracao"
        #DEFINE STR0017 "Ambiente de Restauracao em uso."
        #DEFINE STR0018 "Rotina de Restauração em Uso"
        #DEFINE STR0019 "Restauração do Sistema"
        #DEFINE STR0020 "Ambiente de Restauração Atualizado. Reload Será efetuado para Carga da Nova Configuração"
        #DEFINE STR0021 "Configuração atual não permite a Restauração do Sistema"
        #DEFINE STR0022 "Atenção"
        #DEFINE STR0023 "Aguarde"
        #DEFINE STR0024 "Carregando o Ambiente de Restauração"
        #DEFINE STR0025 "Problemas com a Conexão ao DMBS do ambiente de Restauração"
        #DEFINE STR0026 "Problema na Restauração do ambiente. Tabela:"
        #DEFINE STR0027 " Não encontrada"
        #DEFINE STR0028 "Impossível abrir a tabela:"
        #DEFINE STR0029 "Indexando..."
        #DEFINE STR0030 "Impossivel Conectar-se ao DBMS para Restauracao"
        #DEFINE STR0031 "Atualizando o Ambiente de Restauração"
        #DEFINE STR0032 "Chave para Pesquisa nao informada no Destino"
        #DEFINE STR0033 "Impossivel Criar o Diretorio para vinculo simbolico. Entre em contato com o Adminisrtador do sistema"
        #DEFINE STR0034 "Confirma a Restauração do Ambiente?"
    #else
        #DEFINE STR0001 "Salvando Tabelas"
        #DEFINE STR0002 "Impossivel Criar o Diretorio. Verifique o Conteudo da Configuracao "
        #DEFINE STR0003 " no arquivo "
        #DEFINE STR0004 "Impossivel Copiar o arquivo de senhas "
        #DEFINE STR0005 " para "
        #DEFINE STR0006 "Invalid Function Call:"
        #DEFINE STR0007 "Arquivo de Configuração não encontrado"
        #DEFINE STR0008 " Chave:"
        #DEFINE STR0009 " Não Configurada no arquivo:"
        #DEFINE STR0010 " Secao "
        #DEFINE STR0011 "Diretorio:"
        #DEFINE STR0012 " nao encontrado"
        #DEFINE STR0013 "O Diretorio Base Para Restauracao deve ser informado"
        #DEFINE STR0014 "Nao Existe arquivo de Configuracao no Diretorio Informado"
        #DEFINE STR0015 "Ambiente de Configuracao para Restauracao Inválido"
        #DEFINE STR0016 "Ponto de Restauracao"
        #DEFINE STR0017 "Ambiente de Restauracao em uso."
        #DEFINE STR0018 "Rotina de Restauração em Uso"
        #DEFINE STR0019 "Restauração do Sistema"
        #DEFINE STR0020 "Ambiente de Restauração Atualizado. Reload Será efetuado para Carga da Nova Configuração"
        #DEFINE STR0021 "Configuração atual não permite a Restauração do Sistema"
        #DEFINE STR0022 "Atenção"
        #DEFINE STR0023 "Aguarde"
        #DEFINE STR0024 "Carregando o Ambiente de Restauração"
        #DEFINE STR0025 "Problemas com a Conexão ao DMBS do ambiente de Restauração"
        #DEFINE STR0026 "Problema na Restauração do ambiente. Tabela:"
        #DEFINE STR0027 " Não encontrada"
        #DEFINE STR0028 "Impossível abrir a tabela:"
        #DEFINE STR0029 "Indexando..."
        #DEFINE STR0030 "Impossivel Conectar-se ao DBMS para Restauracao"
        #DEFINE STR0031 "Atualizando o Ambiente de Restauração"
        #DEFINE STR0032 "Chave para Pesquisa nao informada no Destino"
        #DEFINE STR0033 "Impossivel Criar o Diretorio para vinculo simbolico. Entre em contato com o Adminisrtador do sistema"
        #DEFINE STR0034 "Confirma a Restauração do Ambiente?"
    #endif
#endif

#DEFINE PATH_INI_FILE_SAVE_RESTORE "\ini\"

Static oNDJLIB021

CLASS NDJLIB021

    METHOD NEW() CONSTRUCTOR

    METHOD RPSAVE(cIniFile,cRPKey,cMsgError)
    METHOD RPRESTORE(cPathCustomExpr,cMsgError)
    METHOD PUTRPSX5(cRPKey,cTSX5Key)
    METHOD GETRPSX5(cRPKey)
    
ENDCLASS

User Function DJLIB021()
    DEFAULT oNDJLIB021:=NDJLIB021():New()
Return(oNDJLIB021)

METHOD NEW() CLASS NDJLIB021
RETURN(self)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:RPSave()
        Autor:Marinaldo de Jesus
        Data:01/11/2011
        Descricao:Funcao para Salvar Informacoes a serem Restauradas pela Funcao RPRestore()
        Sintaxe:StaticCall(NDJLIB021,RPSave,cIniFile,cRPKey,cMsgError)
    /*/
//------------------------------------------------------------------------------------------------
METHOD RPSAVE(cIniFile,cRPKey,cMsgError) CLASS NDJLIB021
RETURN(RPSave(@cIniFile,@cRPKey,@cMsgError))
Static Function RPSave(cIniFile,cRPKey,cMsgError)

    Local nVarNameLen:=SetVarNameLen(20)

    Local aTables
    Local aTConfig

    Local cMsgBlock
    
    Local cPathSXS
    Local cPathData
    Local cRootPath
    Local cCustomPath
    Local cPathCustomExpr

    Local cEnvRestore
    Local cSrvIniName
    Local cEnvRootPath
    Local cEnvStartPath

    Local cKeyEnvRestore

    Local lSetBell:=Set(_SET_BELL,"ON")
    Local lSetAutoOpen:=Set(_SET_AUTOPEN,.T.)
    Local lSuccessful:=.F.
    Local lPathCustomExpr:=.F.

    Local oRPIni
    
    Local oException

    TRYEXCEPTION

        IF !File(cINIFile)
            //"Arquivo de Configuração não encontrado"
            UserException(STR0007+":"+cINIFile)
        EndIF

        oRPIni:=U_TFINI(@cINIFile)

        cEnvRestore:=GetEnvServer()
        cSrvIniName:=GetSrvIniName()
        cEnvRootPath:=Lower(GetSrvProfString("RootPath",""))
        cEnvStartPath:=Lower(GetSrvProfString("StartPath",""))

        cKeyEnvRestore:=oRPIni:GetPropertyValue("GENERAL","KeyEnvRestore","_RP_")
        cEnvRestore+=cKeyEnvRestore
        cEnvRestore+="RESTORE"

        IF !(SubStr(cEnvRootPath,-1)=="\")
            cEnvRootPath+="\"    
        EndIF
        cRestoreRootPath:=Lower(GetPvProfString(cEnvRestore,"RootPath",cEnvRootPath,cSrvIniName))
        IF !(SubStr(cRestoreRootPath,-1)=="\")
            cRestoreRootPath+="\"    
        EndIF
        IF (;
                Empty(cRestoreRootPath);
                .or.;
                (cRestoreRootPath$cEnvRootPath);
            )
            //"Ambiente de Configuracao para Restauracao Inválido"
            UserException(STR0015+"["+cEnvRestore+"]")
        EndIF

        //"Rotina de Restauração em Uso"
        IF !(StaticCall(NDJLIB013,SemaBlock,cEnvRestore,.F.))
            cMsgBlock:=StaticCall(NDJLIB013,SemaBlock,cEnvRestore,.T.,STR0018)
            IF !Empty(cMsgBlock)
                //"Ambiente de Restauracao em uso."
                UserException(STR0017+__cCRLF+__cCRLF+cMsgBlock)
            EndIF
        Else
            StaticCall(NDJLIB013,SemaBlock,cEnvRestore,.T.,STR0018)            
        EndIF

        cCustomPath:=oRPIni:GetPropertyValue("GENERAL","CustomPath","")
        IF Empty(cCustomPath)
            //"Chave:"###"Não Configurada no arquivo:"###" Secao "
            UserException(STR0008+"CustomPath"+STR0009+cINIFile+STR0010+"[GENERAL]")
        EndIF

        cRootPath:=oRPIni:GetPropertyValue(cCustomPath,"RootPath","")
        IF Empty(cRootPath)
            //"Chave:"###"Não Configurada no arquivo:"###" Secao "
            UserException(STR0008+"RootPath"+STR0009+cINIFile+STR0010+"["+cCustomPath+"]")
        EndIF
        IF !(SubStr(cRootPath,-1)=="\")
            cRootPath+="\"
        EndIF

        IF !StaticCall(NDJLIB001,DirMake,cRootPath)
            //"Impossivel Criar o Diretorio. Verifique o Conteudo da Configuracao "###" no arquivo "            
            UserException(STR0004+cCustomPath+"\RootPath"+STR0003+cINIFile)
        EndIF

        cPathCustomExpr:=oRPIni:GetPropertyValue(cCustomPath,"PathCustomExpr","")
        IF !Empty(cPathCustomExpr)
            cPathCustomExpr:=&(cPathCustomExpr)
            IF !Empty(cPathCustomExpr)
                IF !(SubStr(cPathCustomExpr,-1)=="\")
                    cPathCustomExpr+="\"
                EndIF
                cPathCustomExpr:=(cRootPath+cPathCustomExpr)
                cPathCustomExpr:=StrTran(cPathCustomExpr,"\\","\")
                IF !StaticCall(NDJLIB001,DirMake,cPathCustomExpr)
                    //"Impossivel Criar o Diretorio. Verifique o Conteudo da Configuracao "###" no arquivo "
                    UserException(STR0004+cCustomPath+"\PathCustomExp"+STR0003+cINIFile)
                EndIF
                lPathCustomExpr:=.T.
            EndIF
        EndIF

        IF !(lPathCustomExpr)
            cPathCustomExpr:=cRootPath
            cRootPath:=""
        EndIF

        cPathSXS:=oRPIni:GetPropertyValue(cCustomPath,"PathSXS","")
        IF !Empty(cPathSXS)
            IF !(SubStr(cPathSXS,-1)=="\")
                cPathSXS+="\"
            EndIF
            cPathSXS:=(cPathCustomExpr+cPathSXS)
            cPathSXS:=StrTran(cPathSXS,"\\","\")
            IF !StaticCall(NDJLIB001,DirMake,cPathSXS)
                //"Impossivel Criar o Diretorio. Verifique o Conteudo da Configuracao "###" no arquivo "
                UserException(STR0004+cCustomPath+"\PathSXS"+STR0003+cINIFile)
            EndIF
        EndIF
    
        cPathData:=oRPIni:GetPropertyValue(cCustomPath,"PathData","")
        IF Empty(cPathData)
            //"Impossivel Criar o Diretorio. Verifique o Conteudo da Configuracao "###" no arquivo "
            UserException(STR0004+cCustomPath+"\PathData"+STR0003+cINIFile)
        EndIF
        IF !(SubStr(cPathData,-1)=="\")
            cPathData+="\"
        EndIF
        cPathData:=(cPathCustomExpr+cPathData)
        cPathData:=StrTran(cPathData,"\\","\")
        IF !StaticCall(NDJLIB001,DirMake,cPathData)
            //"Impossivel Criar o Diretorio. Verifique o Conteudo da Configuracao "###" no arquivo "
            UserException(STR0004+cCustomPath+"\PathData"+STR0003+cINIFile)
        EndIF

        aTables:=StrToKArr(oRPIni:GetPropertyValue("GENERAL","Tables",""),",")
        RPSaveTable(@oRPIni,@cPathData,@aTables)

        IF !Empty(cPathSXS)
            aTConfig:=StrToKArr(oRPIni:GetPropertyValue("GENERAL","TConfig",""),",")
            RPSaveTable(@oRPIni,@cPathSXS,@aTConfig)
        EndIF    

        RPPWDSave(@oRPIni,@cCustomPath,@cIniFile,@cPathCustomExpr)

        RPSaveIni(@oRPIni,@cCustomPath,@cPathCustomExpr)

        cRPKey:=cPathCustomExpr

        lSuccessful:=.T.

        StaticCall(NDJLIB003,ReleaseCode,cEnvRestore)
        StaticCall(NDJLIB013,RmvSemaphore,cEnvRestore)

    CATCHEXCEPTION USING oException

        IF !(cEnvRestore==NIL)
            StaticCall(NDJLIB003,ReleaseCode,cEnvRestore)
            StaticCall(NDJLIB013,RmvSemaphore,cEnvRestore)
        EndIF    

        IF (ValType(oException)=="O")
            cMsgError:=oException:Description
            ConOut(cMsgError)
        EndIF
        
    ENDEXCEPTION

    IF !(cEnvRestore==NIL)
        StaticCall(NDJLIB003,ReleaseCode,cEnvRestore)
        StaticCall(NDJLIB013,RmvSemaphore,cEnvRestore)
    EndIF    

    SetVarNameLen(nVarNameLen)

    IF (lSetBell)
        lSetBell:=Set(_SET_BELL,"ON")
    EndIF    

    IF !(lSetAutoOpen)
        Set(_SET_AUTOPEN,.F.)
    EndIF    

Return(lSuccessful)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:RPSaveTable()
        Autor:Marinaldo de Jesus
        Data:02/11/2011
        Descricao:Usada pela RPSave para salvar o Conteudo das Tabelas
        Sintaxe:RPSaveTable(oRPIni,cPath,aTables)
    /*/
//------------------------------------------------------------------------------------------------
Static Function RPSaveTable(oRPIni,cPath,aTables)

    Local aIndex
    Local aFields

    Local aAliasStruct
    Local aTAliasStruct
    
    Local bAddField

    Local cRDDExport
    Local cRDDDefault:="DBFCDXADS"

    Local cAlias
    Local cTAlias

    Local cTable
    Local cFileName
    Local cdbExtension

    Local cFields

    Local cFilter
    Local cFilterExpr

    Local cIndexKey

    Local lFilter:=.F.
    Local lSuccessful:=.F.

    Local lChkFile
    Local lSQLFilter
    Local lUniqueStructure

    Local nBL
    Local nEL

    Local nAT
    Local nATField

    Local nField
    Local nFields

    Local nTable
    Local nTables

    Local nIndexOrder

    IF !IsInCallStack("RPSave")
        UserException(STR0006+ProcName()) //"Invalid Function Call:"
    EndIF

    aIndex:={}
    aFields:={}

    cAlias:=GetNextAlias()
    cTAlias:=GetNextAlias()
    bAddField:={|abFields|aEval(abFields,{|cField|cField:=Upper(AllTrim(cField)),IF(!Empty(cField),IF((aScan(aFields,cField)==0),aAdd(aFields,cField),NIL),NIL)})}

    nEL:=    Len(aTables)
    For nBL:=1 To nEL

        cTable:=aTables[nBL]

        IF !(oRPIni:ExistSession(cTable))
            Loop
        EndIF

        lChkFile:=(oRPIni:GetPropertyValue(cTable,"ChkFile","1")=="1")
        
        IF (lChkFile)
            lChkFile:=ChkFile(cTable,.F.,cAlias)
            IF !(lChkFile)
                Loop
            EndIF
        Else
            cAlias:=cTable
        EndIF

        aAliasStruct:=(cAlias)->(dbStruct())

        cIndexKey:=oRPIni:GetPropertyValue(cTable,"IndexKey","")
        IF !Empty(cIndexKey)
            Eval(bAddField,StrToKArr(cIndexKey,"+"))
        EndIF

        cFields:=oRPIni:GetPropertyValue(cTable,"Fields","")
        IF ("*"$cFields)
            aTAliasStruct:=aAliasStruct
        Else
            Eval(bAddField,StrTokArr(cFields,","))
        EndIF

        lUniqueStructure:=(aTAliasStruct==aAliasStruct)

        cFilterExpr:=oRPIni:GetPropertyValue(cTable,"FilterExpr","")
        IF !Empty(cFilterExpr)
            cFilter:=&(cFilterExpr)
        Else
            cFilter:=oRPIni:GetPropertyValue(cTable,"Filter","")
        EndIF
        lSQLFilter:=(oRPIni:GetPropertyValue(cTable,"SQLFilter","0")=="1")

        nIndexOrder:=Val(oRPIni:GetPropertyValue(cTable,"IndexOrder","0"))
        IF (nIndexOrder==0)
            nIndexOrder:=RetOrder(cTable,cIndexKey)
        EndIF
        
        (cAlias)->(dbSetOrder(nIndexOrder))
        
        lFilter:=!Empty(cFilter)
        IF (lFilter)
            IF (lSQLFilter)
                cFilter:="@"+cFilter
            EndIF
            FilBrowse(cAlias,@aIndex,@cFilter)
        EndIF

        IF !(lUniqueStructure)
            aTAliasStruct:={}
            nFields:=Len(aFields)
            nATField:=0
            For nField:=1 To nFields
                cField:=aFields[nField]
                nAT:=aScan(aAliasStruct,{|aDBS|aDBS[DBS_NAME]==cField})
                IF (nAT==0)
                    Loop
                EndIF
                aAdd(aTAliasStruct,Array(DBS_ALEN))
                ++nATField
                aTAliasStruct[nATField][DBS_NAME]:=aAliasStruct[nAT][DBS_NAME]
                aTAliasStruct[nATField][DBS_TYPE]:=aAliasStruct[nAT][DBS_TYPE]
                aTAliasStruct[nATField][DBS_LEN]:=aAliasStruct[nAT][DBS_LEN]
                aTAliasStruct[nATField][DBS_DEC]:=aAliasStruct[nAT][DBS_DEC]
            Next nField
        EndIF

        cRDDExport:=    oRPIni:GetPropertyValue(cTable,"rddExport",cRDDDefault)
        IF Empty(cRDDExport)
            cRDDExport:=cRDDDefault
        EndIF

        cdbExtension:=oRPIni:GetPropertyValue(cTable,"DBEXTENSION",IF((cRDDExport==cRDDDefault),".dbf",""))

        cTableName:=RetFullName(cTable)
        IF Empty(cTableName)
            cTableName:=(cAlias)->(dbInfo(DBI_FULLPATH))
            cTableName:=StaticCall(NDJLIB007,RetFileName,cTableName)
            cTableName:=FileNoExt(cTableName)
        EndIF
        IF !(cRDDExport=="TOPCONN")
            IF Empty(cdbExtension)
                cdbExtension:=GetSrvProfString("localdbextension","")
            EndIF
            IF !Empty(cdbExtension)
                cTableName+=cdbExtension
            EndIF
            cTableName:=(cPath+cTableName)
        EndIF

        StaticCall(NDJLIB007,MakeTmpFile,@cAlias,@cTAlias,@cTableName,NIL,NIL,NIL,NIL,@aTAliasStruct,NIL,@cRDDExport)

        IF (lChkFile)
            IF (Select(cAlias)>0)
                (cAlias)->(dbCloseArea())
            EndIF
            IF (ChkFile(cTable))
                (cTable)->(dbCloseArea())
            EndIF
        ElseIF (lFilter)
            IF PosAlias("SIX",cAlias,NIL,NIL,1,.T.)
                EndFilBrw(cAlias,@aIndex)
                EndFilBrw(cTable,@aIndex)
            Else
                (cAlias)->(dbClearFilter())
            EndIF
        EndIF

        aSize(aIndex,0)
        aSize(aFields,0)

        IF (Select(cTAlias)>0)
            (cTAlias)->(dbCloseArea())
        EndIF

    Next nBL

    lSuccessful:=.T.

Return(lSuccessful)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:RPSaveIni()
        Autor:Marinaldo de Jesus
        Data:02/11/2011
        Descricao:Usada pela RPSave para salvar o Conteudo do Ini Utilizado durante o Processo
        Sintaxe:RPSaveIni(oRPIni,cCustomPath,cPathCustomExpr)
    /*/
//------------------------------------------------------------------------------------------------
Static Function RPSaveIni(oRPIni,cCustomPath,cPathCustomExpr)

    Local cPathIni

    Local cSPPath
    Local cSPDriver
    Local cSPFileName

    Local cExtension

    Local lSuccessful:=.F.

    BEGIN SEQUENCE

        IF !IsInCallStack("RPSave")
            UserException(STR0006+ProcName()) //"Invalid Function Call:"
        EndIF

        cPathIni:=PATH_INI_FILE_SAVE_RESTORE
        IF !(SubStr(cPathIni,-1)=="\")
            cPathIni+="\"
        EndIF
        cPathIni:=(cPathCustomExpr+cPathIni)
        cPathIni:=StrTran(cPathIni,"\\","\")
        IF !StaticCall(NDJLIB001,DirMake,cPathIni)
            cPathIni:=cPathCustomExpr
        EndIF

        SplitPath(oRPIni:cINIFile,@cSPDriver,@cSPPath,@cSPFileName)
        IF Empty(cSPFileName)
            BREAK    
        EndIF

        cExtension:=oRPIni:cINIFile
        cExtension:=StrTran(cExtension,cSPDriver,"")
        cExtension:=StrTran(cExtension,cSPPath,"")
        cExtension:=StrTran(cExtension,cSPFileName,"")
        
        cSPFileName+=cExtension
        IF !(lSuccessful:=__CopyFile(oRPIni:cINIFile,cPathIni+cSPFileName))
            lSuccessful:=oRPIni:SaveAs(cPathIni+cSPFileName)
        EndIF

    END SEQUENCE

Return(lSuccessful)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:RPRestore()
        Autor:Marinaldo de Jesus
        Data:01/11/2011
        Descricao:Funcao para Restaurar Informacoes que foram Salvas Funcao RPSave()
        Sintaxe:StaticCall(NDJLIB021,RPRestore,cIniFile,cPathCustomExpr)
    /*/
//------------------------------------------------------------------------------------------------
METHOD RPRESTORE(cPathCustomExpr,cMsgError) CLASS NDJLIB021
RETURN(RPRestore(@cPathCustomExpr,@cMsgError))
Static Function RPRestore(cPathCustomExpr,cMsgError)

    Local nVarNameLen:=SetVarNameLen(20)

    Local aTables
    Local aTConfig
    Local aIniFile
    
    Local cIniFile
    Local cPathIni
    Local cPathSXS
    Local cPathData
    Local cRootPath
    Local cCustomPath
    Local cKeyEnvRestore
    
    Local cMsgBlock

    Local cEnvRestore
    Local cSrvIniName
    Local cEnvRootPath
    Local cEnvStartPath

    Local cRestoreFullPath
    Local cRestoreRootPath
    Local cRestoreStartPath
    Local cRestoreSystemVPath

    Local cDBMSSrv
    Local cDBMSName
    Local cDBMSAlias
    Local nDBMSPort
    Local nTcLink:=AdvConnection()

    Local lSetBell:=Set(_SET_BELL,"OFF")
    Local lSetAutoOpen:=Set(_SET_AUTOPEN,.T.)
    Local lUniqueDBMS:=.F.
    Local lVirtualLink:=.F.
    Local lSuccessful:=.F.

    Local nIniFile

    Local oRPIni
    
    Local oException
    Local oFwdbAccess

    TRYEXCEPTION

        IF Empty(cPathCustomExpr)
            //"O Diretorio Base Para Restauracao deve ser informado"
            UserException(STR0013)
        EndIF

        cPathCustomExpr:=AllTrim(cPathCustomExpr)

        IF !(SubStr(cPathCustomExpr,-1)=="\")
            cPathCustomExpr+="\"
        EndIF

        IF !lIsDir(cPathCustomExpr)
            //"Diretorio:"###" nao encontrado"
            UserException(STR0011+cPathCustomExpr+STR0012)
        EndIF

        cPathIni:=PATH_INI_FILE_SAVE_RESTORE
        cPathIni:=(cPathCustomExpr+cPathIni)
        cPathIni:=StrTran(cPathIni,"\\","\")
        IF !lIsDir(cPathIni)
            cPathIni:=cPathCustomExpr
        EndIF

        aIniFile:=Array(aDir(cPathIni+"*.ini"))
        nIniFile:=aDir(cPathIni+"*.ini",@aIniFile)
        IF (nIniFile==0)
            //"Nao Existe arquivo de Configuracao no Diretorio Informado"
            UserException(STR0014)
        EndIF

        cINIFile:=aIniFile[nIniFile]
        cPathIniFile:=(cPathIni+cINIFile)

        IF !File(cPathIniFile)
            //"Arquivo de Configuração não encontrado"
            UserException(STR0007+":"+cPathIniFile)
        EndIF

        oRPIni:=U_TFINI(cPathIniFile)

        cEnvRestore:=GetEnvServer()
        cSrvIniName:=GetSrvIniName()
        cEnvRootPath:=Lower(GetSrvProfString("RootPath",""))
        cEnvStartPath:=Lower(GetSrvProfString("StartPath",""))

        cKeyEnvRestore:=oRPIni:GetPropertyValue("GENERAL","KeyEnvRestore","_RP_")
        cEnvRestore+=cKeyEnvRestore
        cEnvRestore+="RESTORE"

        IF !(SubStr(cEnvRootPath,-1)=="\")
            cEnvRootPath+="\"    
        EndIF
        cRestoreRootPath:=Lower(GetPvProfString(cEnvRestore,"RootPath",cEnvRootPath,cSrvIniName))
        IF !(SubStr(cRestoreRootPath,-1)=="\")
            cRestoreRootPath+="\"    
        EndIF
        IF (;
                Empty(cRestoreRootPath);
                .or.;
                (cRestoreRootPath$cEnvRootPath);
            )
            //"Ambiente de Configuracao para Restauracao Inválido"
            UserException(STR0015+"["+cEnvRestore+"]")
        EndIF
        
        //"Rotina de Restauração em Uso"
        IF !(StaticCall(NDJLIB013,SemaBlock,cEnvRestore,.F.))
            cMsgBlock:=StaticCall(NDJLIB013,SemaBlock,cEnvRestore,.T.,STR0018)
            IF !Empty(cMsgBlock)
                //"Ambiente de Restauracao em uso."
                UserException(STR0017+__cCRLF+__cCRLF+cMsgBlock)
            EndIF
        Else
            StaticCall(NDJLIB013,SemaBlock,cEnvRestore,.T.,STR0018)            
        EndIF

        cRestoreStartPath:=GetPvProfString(cEnvRestore,"StartPath","",cSrvIniName)
        IF Empty(cRestoreStartPath)
            //"Ambiente de Configuracao para Restauracao Inválido"
            UserException(STR0015+"["+cEnvRestore+"]")
        EndIF
        IF !(SubStr(cRestoreStartPath,-1)=="\")
            cRestoreStartPath+="\"    
        EndIF

        cCustomPath:=oRPIni:GetPropertyValue("GENERAL","CustomPath","")
        IF Empty(cCustomPath)
            //"Chave:"###"Não Configurada no arquivo:"###" Secao "
            UserException(STR0008+"CustomPath"+STR0009+cPathIniFile+STR0010+"[GENERAL]")
        EndIF

        cRootPath:=oRPIni:GetPropertyValue(cCustomPath,"RootPath","")
        IF Empty(cRootPath)
            //"Chave:"###"Não Configurada no arquivo:"###" Secao "
            UserException(STR0008+"RootPath"+STR0009+cPathIniFile+STR0010+"["+cCustomPath+"]")
        EndIF
        IF !(SubStr(cRootPath,-1)=="\")
            cRootPath+="\"
        EndIF

        IF !lIsDir(cRootPath)
            //"Diretorio:"###" nao encontrado"
            UserException(STR0011+cRootPath+STR0012)
        EndIF                                              

        cPathSXS:=oRPIni:GetPropertyValue(cCustomPath,"PathSXS","")
        IF !Empty(cPathSXS)
            IF !(SubStr(cPathSXS,-1)=="\")
                cPathSXS+="\"
            EndIF
            cPathSXS:=(cPathCustomExpr+cPathSXS)
            cPathSXS:=StrTran(cPathSXS,"\\","\")
            IF !lIsDir(cPathSXS)
                //"Diretorio:"###" nao encontrado"
                UserException(STR0011+cPathSXS+STR0012)
            EndIF
        EndIF
    
        cPathData:=oRPIni:GetPropertyValue(cCustomPath,"PathData","")
        IF Empty(cPathData)
            //"Impossivel Criar o Diretorio. Verifique o Conteudo da Configuracao "###" no arquivo "
            UserException(STR0004+cCustomPath+"\PathData"+STR0003+cPathIniFile)
        EndIF
        IF !(SubStr(cPathData,-1)=="\")
            cPathData+="\"
        EndIF
        cPathData:=(cPathCustomExpr+cPathData)
        cPathData:=StrTran(cPathData,"\\","\")
        IF !lIsDir(cPathData)
            //"Diretorio:"###" nao encontrado"
            UserException(STR0011+cPathData+STR0012)
        EndIF

        cRestoreSystemVPath:=oRPIni:GetPropertyValue(cCustomPath,"RestoreSystemVPath","")    
        lVirtualLink:=!Empty(cRestoreSystemVPath)
        IF (lVirtualLink)
            IF !(SubStr(cRestoreSystemVPath,-1)=="\")
                cRestoreSystemVPath+="\"
            EndIF
            cRestoreSystemVPath:=StrTran(cRestoreSystemVPath,"\\","\")
            lVirtualLink:=(lVirtualLink .and. lIsDir(cRestoreSystemVPath))
        EndIF

        cDBMSSrv:=GetDBMSSrv(@cEnvRestore,@cSrvIniName)
        cDBMSName:=GetDBMSName(@cEnvRestore,@cSrvIniName)
        cDBMSAlias:=GetDBMSAlias(@cEnvRestore,@cSrvIniName)
        nDBMSPort:=GetDBMSPort(@cEnvRestore,@cSrvIniName)

        IF (;
                (cDBMSSrv==GetDBMSSrv());
                .and.;
                (cDBMSName==GetDBMSName());
                .and.;
                (cDBMSAlias==GetDBMSAlias());
        )
            lUniqueDBMS:=.T.
        EndIF

        oFwdbAccess:=FWDBAccess():New(cDBMSName+"/"+cDBMSAlias,cDBMSSrv,nDBMSPort)
        oFwdbAccess:SetConsoleError(.T.)
        IF !(oFwdbAccess:OpenConnection())
            cMsgError:=STR0025    //"Problemas com a Conexão ao DMBS do ambiente de Restauração"
            cMsgError+=__cCRLF
            cMsgError+=__cCRLF
            cMsgError+=AllTrim(Str(oFwdbAccess:Handle()))
            cMsgError+=__cCRLF
            cMsgError+=__cCRLF
            cMsgError+=AllTrim(oFwdbAccess:ErrorMessage())
            oFwdbAccess:CloseConnection()
            oFwdbAccess:=oFwdbAccess:Destroy()
            UserException(cMsgError)
        EndIF

        IF !(TCSetConn(oFwdbAccess:nHandle))
            //"Impossivel Conectar-se ao DBMS para Restauracao"
            UserException(STR0030+__cCRLF+cDBMSName+"/"+cDBMSAlias+"/"+cDBMSSrv)
        EndIF

        IF (lVirtualLink)
            cRestoreFullPath:=cRestoreSystemVPath
        Else
            cRestoreFullPath:=(cRestoreRootPath+cRestoreStartPath)
            cRestoreFullPath:=StrTran(cRestoreFullPath,"\\","\")
        EndIF    

        IF !Empty(cPathSXS)
            aTConfig:=StrToKArr(oRPIni:GetPropertyValue("GENERAL","TConfig",""),",")
            RPRestoreTable(@oRPIni,@cPathSXS,@aTConfig,@lUniqueDBMS,@cEnvRestore,@cRestoreFullPath,@lVirtualLink)
        EndIF    

        aTables:=StrToKArr(oRPIni:GetPropertyValue("GENERAL","Tables",""),",")
        RPRestoreTable(@oRPIni,@cPathData,@aTables,@lUniqueDBMS,@cEnvRestore,@cRestoreFullPath,@lVirtualLink)

        RPPWDRestore(@oRPIni,@cCustomPath,@cIniFile,@cPathCustomExpr,@cRestoreFullPath,@lVirtualLink)

        lSuccessful:=.T.

        oFwdbAccess:CloseConnection()
        oFwdbAccess:=oFwdbAccess:Destroy()

        StaticCall(NDJLIB003,ReleaseCode,cEnvRestore)
        StaticCall(NDJLIB013,RmvSemaphore,cEnvRestore)

    CATCHEXCEPTION USING oException

        IF !(cEnvRestore==NIL)
            StaticCall(NDJLIB003,ReleaseCode,cEnvRestore)
            StaticCall(NDJLIB013,RmvSemaphore,cEnvRestore)
        EndIF    

        IF (ValType(oFwdbAccess)=="O")
            oFwdbAccess:CloseConnection()
            oFwdbAccess:=oFwdbAccess:Destroy()
        EndIF

        IF (ValType(oException)=="O")
            cMsgError:=oException:Description
            ConOut(cMsgError)
        EndIF                     

    ENDEXCEPTION

    IF !(lUniqueDBMS)
        TCSetConn(@nTcLink)
    EndIF    

    IF !(cEnvRestore==NIL)
        StaticCall(NDJLIB003,ReleaseCode,cEnvRestore)
        StaticCall(NDJLIB013,RmvSemaphore,cEnvRestore)
    EndIF    

    SetVarNameLen(nVarNameLen)

    IF (lSuccessful)
        //"Aguarde"###"Carregando o Ambiente de Restauração"
        MsgRun(OemToAnsi(STR0023),OemToAnsi(STR0024),{||RmtRPEnvLoad(cEnvRestore)})
    EndIF

    IF (lSetBell)
        lSetBell:=Set(_SET_BELL,"ON")
    EndIF    

    IF !(lSetAutoOpen)
        Set(_SET_AUTOPEN,.F.)
    EndIF    

Return(lSuccessful)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:RPRestoreTable()
        Autor:Marinaldo de Jesus
        Data:02/11/2011
        Descricao:Usada pela RPRestore para Restauras o Conteudo das Tabelas
        Sintaxe:RPRestoreTable(oRPIni,cPath,aTables,lUniqueDBMS,cEnvRestore,cRestoreFullPath,lVirtualLink)
    /*/
//------------------------------------------------------------------------------------------------
Static Function RPRestoreTable(oRPIni,cPath,aTables,lUniqueDBMS,cEnvRestore,cRestoreFullPath,lVirtualLink)

    Local aTopTables:={}
    
    Local aFileRestore
    Local aFileDelMerge

    Local aAliasStruct
    Local aTAliasStruct
    Local aFieldPosAlias
    Local aFieldPosTAlias

    Local cAlias
    Local cTAlias
    Local cKeySeek
    Local cIndexFile

    Local cRealRDD
    Local cRDDTable
    Local cRDDDefault:="DBFCDXADS"

    Local cTable
    Local cTempFile
    Local cFileRestore
    Local cFileDelMerge
    
    Local cCommandLine
    
    Local cIndexExt
    Local cOrdBagExt

    Local cRDDExport
    Local cRDDImport
    Local cdbExtension

    Local cSPPath
    Local cSPDriver
    Local cSPFileName

    Local cWaitRunDriver

    Local cSrvIniName
    Local cEnvFullPath
    Local cEnvRootPath
    Local cEnvStartPath
    Local cSymbolicPath
    Local cFullSymbolicPath

    Local lAddNew
    Local lTopConn
    Local lIsCTree
    Local lNoRestore

    Local nEL
    Local nBL

    Local nFile
    Local nFiles
    
    Local nField
    Local nFields

    IF !IsInCallStack("RPRestore")
        UserException(STR0006+ProcName()) //"Invalid Function Call:"
    EndIF

    cRealRDD:=RealRdd()
    lIsCTree:=(cRealRDD=="CTREE")
    cSrvIniName:=GetSrvIniName()
    cEnvRootPath:=Lower(GetSrvProfString("RootPath",""))
    cEnvStartPath:=Lower(GetSrvProfString("StartPath",""))
    IF !(SubStr(cEnvRootPath,-1)=="\")
        cEnvRootPath+="\"
    EndIF
    cEnvFullPath:=cEnvRootPath
    IF !(SubStr(cEnvFullPath,-1)=="\")
        cEnvFullPath+="\"
    EndIF
    cEnvFullPath+=cEnvStartPath
    IF !(SubStr(cEnvFullPath,-1)=="\")
        cEnvFullPath+="\"
    EndIF
    cEnvFullPath:=StrTran(cEnvFullPath,"\\","\")

    cAlias:=GetNextAlias()
    cTAlias:=GetNextAlias()

    aAliasStruct:={}
    aTAliasStruct:={}

    aFieldPosAlias:={}
    aFieldPosTAlias:={}

    nEL:=    Len(aTables)
    For nBL:=1 To nEL

        cTable:=aTables[nBL]

        IF !(oRPIni:ExistSession(cTable))
            Loop
        EndIF

        lNoRestore:=(oRPIni:GetPropertyValue(cTable,"NoRestore","0")=="1")
        IF (lNoRestore)
            Loop
        EndIF

        cRDDExport:=    oRPIni:GetPropertyValue(cTable,"rddExport",cRDDDefault)
        IF Empty(cRDDExport)
            cRDDExport:=cRDDDefault
        EndIF

        cdbExtension:=oRPIni:GetPropertyValue(cTable,"DBEXTENSION",IF((cRDDExport==cRDDDefault),".dbf",""))

        cFileRestore:=(cPath+aTables[nBL]+"*"+cdbExtension)
        aFileRestore:=Array(aDir(cFileRestore))
        nFile:=aDir(cFileRestore,@aFileRestore)
        IF (nFile==0)
            //"Problema na Restauração do ambiente. Tabela:"###" Não encontrada" 
            UserException(STR0026+cFileRestore+STR0027)
        EndIF
        cFileRestore:=(cPath+aFileRestore[nFile])
        IF !File(cFileRestore)
            //"Problema na Restauração do ambiente. Tabela:"###" Não encontrada" 
            UserException(STR0026+cFileRestore+STR0027)
        EndIF

        lSuccessful:=MsOpEndbf(.T.,cRDDExport,cFileRestore,cAlias,.T.,.F.,.F.,.F.)
           IF !(lSuccessful)
               //"Impossível abrir a tabela:"
               UserException(STR0028+cFileRestore)
           EndIF
        aAliasStruct:=(cAlias)->(dbStruct())

        cRDDTable:=(cTable)->(RddName())
        cRDDImport:=    oRPIni:GetPropertyValue(cTable,"rddImport",cRDDTable)
        IF Empty(cRDDImport)
            cRDDImport:=cRDDDefault
        EndIF
        lTopConn:=(cRDDImport=="TOPCONN")
        
        SplitPath(cFileRestore,@cSPDriver,@cSPPath,@cSPFileName)

        IF !(lVirtualLink)
            SplitPath(cRestoreFullPath,@cWaitRunDriver)
        EndIF    

        cIndexExt:=IndexExt()
        cOrdBagExt:=OrdBagExt()

        IF !(lTopConn)
            
            IF !(lVirtualLink)

                cSymbolicPath:=cPath
                IF !(SubStr(cSymbolicPath,-1)=="\")
                    cSymbolicPath+="\"
                EndIF
                cSymbolicPath:=StrTran(cSymbolicPath,"\\","\")
                cSymbolicPath+="\Symbolic\"
                cSymbolicPath:=StrTran(cSymbolicPath,"\\","\")
                IF !StaticCall(NDJLIB001,DirMake,cSymbolicPath)
                    //"Impossivel Criar o Diretorio para vinculo simbolico. Entre em contato com o Adminisrtador do sistema"
                    UserException(STR0033)
                EndIF

                cFullSymbolicPath:=cEnvRootPath
                IF !(SubStr(cFullSymbolicPath,-1)=="\")
                    cFullSymbolicPath+="\"
                EndIF
                cFullSymbolicPath:=StrTran(cFullSymbolicPath,"\\","\")
                cFullSymbolicPath+=cPath
                IF !(SubStr(cFullSymbolicPath,-1)=="\")
                    cFullSymbolicPath+="\"
                EndIF
                cFullSymbolicPath:=StrTran(cFullSymbolicPath,"\\","\")
                cFullSymbolicPath+="\Symbolic\"
                cFullSymbolicPath:=StrTran(cFullSymbolicPath,"\\","\")            

                cFileDelMerge:=cSPFileName
                
                cCommandLine:='xcopy'
                cCommandLine+=' "'
                cCommandLine+=cRestoreFullPath
                cCommandLine+=cFileDelMerge
                cCommandLine+='.*'
                cCommandLine+='" '
                cCommandLine+=' "'
                cCommandLine+=cFullSymbolicPath
                cCommandLine+='" '
                cCommandLine+='/c /q /y '
    
                WaitRunSrv(cCommandLine,.T.,cWaitRunDriver)
    
                cCommandLine:='del'
                cCommandLine+=' "'
                cCommandLine+=cFullSymbolicPath
                cCommandLine+=cIndexExt
                cCommandLine+='" '
                
                WaitRunSrv(cCommandLine,.T.,cWaitRunDriver)
    
                cCommandLine:='del'
                cCommandLine+=' "'
                cCommandLine+=cFullSymbolicPath
                cCommandLine+=cOrdBagExt
                cCommandLine+='" '
    
                WaitRunSrv(cCommandLine,.T.,cWaitRunDriver)
    
                cFileDelMerge:=(cSymbolicPath+cFileDelMerge)
                aFileDelMerge:=Array(aDir(cFileDelMerge+".*"))
                nFile:=aDir(cFileDelMerge+".*",@aFileDelMerge)
                IF (nFile==0)
                    //"Problema na Restauração do ambiente. Tabela:"###" Não encontrada" 
                    UserException(STR0026+cFileDelMerge+STR0027)
                EndIF
                cTempFile:=cFileDelMerge
            Else
                cTempFile:=(cRestoreFullPath+cSPFileName)
                aFileDelMerge:=Array(aDir(cTempFile+".*"))
                nFile:=aDir(cTempFile+".*",@aFileDelMerge)
                IF (nFile==0)
                    //"Problema na Restauração do ambiente. Tabela:"###" Não encontrada" 
                    UserException(STR0026+cTempFile+STR0027)
                EndIF
            EndIF
        Else
            cTempFile:=cSPFileName
            cIndexFile:=CriaTrab(NIL,.F.)
        EndIF    

        IF !(lVirtualLink)
            IF (lIsCTree)
                StaticCall(NDJLIB007,FileErase,cTempFile+cIndexExt)
                StaticCall(NDJLIB007,FileErase,cTempFile+cOrdBagExt)
            EndIF    
        EndIF    

        TAliasOpen(@cRDDImport,@lTopConn,@cTempFile,@cAlias,@cTAlias,@aAliasStruct,@aTAliasStruct,@aFieldPosAlias,@aFieldPosTAlias)

        IF (lTopConn)
            IF !(lUniqueDBMS)
                IF !(ArrayCompare(aAliasStruct,aTAliasStruct))
                    (cTAlias)->(dbCloseArea())
                    aAdd(aTopTables,cTable)
                    //"Aguarde"####"Atualizando o Ambiente de Restauração"
                    MsAguarde({||StartJob("U_RPUpdTable",cEnvRestore,.T.,aTopTables,cEmpAnt,cFilAnt)},OemToAnsi(STR0023),OemToAnsi(STR0031))
                    aSize(aTopTables,0)
                    TAliasOpen(@cRDDImport,@lTopConn,@cTempFile,@cAlias,@cTAlias,@aAliasStruct,@aTAliasStruct,@aFieldPosAlias,@aFieldPosTAlias)
                EndIF
            EndIF    
        EndIF

        cIndexKey:=oRPIni:GetPropertyValue(cTable,"IndexKey","")
        IF Empty(cIndexKey)
            UserException(STR0032)    //"Chave para Pesquisa nao informada no Destino"
        EndIF
        IF !(lTopConn)
            IF (;
                    (lIsCTree);
                    .and.;
                    !(lVirtualLink);
            )        
                StaticCall(NDJLIB007,FileErase,cTempFile+cIndexExt)
                StaticCall(NDJLIB007,FileErase,cTempFile+cOrdBagExt)
            EndIF    
            nIndexOrder:=RetOrder(cTable,cIndexKey,.T.)
            IF (nIndexOrder==0)
                nIndexOrder:=Val(oRPIni:GetPropertyValue(cTable,"IndexOrder","0"))
            EndIF
            IF (;
                    (nIndexOrder==0);
                    .or.;
                    (cTAlias)->(IndexOrd()==0);
            )
                cIndexFile:=(CriaTrab(NIL,.F.)+cIndexExt)
                IF Empty(cIndexKey)
                    UserException(STR0032)    //"Chave para Pesquisa nao informada no Destino"
                EndIF
                IndRegua(cTAlias,cIndexFile,cIndexKey,NIL,NIL,OemToAnsi(STR0029))    //"Indexando..."
            Else
                (cTAlias)->(dbSetOrder(nIndexOrder))
            EndIF
        Else
            IndRegua(cTAlias,cIndexFile,cIndexKey,NIL,NIL,OemToAnsi(STR0029))        //"Indexando..."
        EndIF

        IF Empty(cIndexKey)
            cIndexKey:=(cTAlias)->(IndexKey())
        EndIF

        nFields:=Len(aFieldPosAlias)

        While (cAlias)->(!Eof())

            cKeySeek:=(cAlias)->(&(cIndexKey))
            lAddNew:=(cTAlias)->(!dbSeek(cKeySeek,.F.))

            IF (cTAlias)->(RecLock(cTAlias,lAddNew))

                For nField:=1 To nFields
                    IF (aFieldPosTAlias[nField]>0)
                        (cTAlias)->(FieldPut(aFieldPosTAlias[nField],(cAlias)->(FieldGet(aFieldPosAlias[nField]))))
                    EndIF
                Next nField 

                (cTAlias)->(MsUnLock())

            EndIF

            (cAlias)->(dbSkip())

        End While

        (cAlias)->(dbCloseArea())
        (cTAlias)->(dbCloseArea())

        IF !(lTopConn)

            IF !Empty(cIndexFile)
                cIndexFile:=(cPath+cIndexFile)
                IF File(cIndexFile)
                    StaticCall(NDJLIB007,FileErase,cIndexFile)
                EndIF
            EndIF
            
            IF !(lVirtualLink)
    
                nFiles:=Len(aFileDelMerge)
                For nFile:=1 To nFiles
    
                    cCommandLine:='del '
                    cCommandLine+=' "'
                    cCommandLine+=cRestoreFullPath
                    cCommandLine+=aFileDelMerge[nFile]
                    cCommandLine+='" '
                    WaitRunSrv(cCommandLine,.T.,cWaitRunDriver)
    
                    cCommandLine:='xcopy'
                    cCommandLine+=' "'
                    cCommandLine+=cFullSymbolicPath
                    cCommandLine+=aFileDelMerge[nFile]
                    cCommandLine+='" '
                    cCommandLine+=' "'
                    cCommandLine+=cRestoreFullPath
                    cCommandLine+='" '
                    cCommandLine+='/c /q /y '
                    WaitRunSrv(cCommandLine,.T.,cWaitRunDriver)
    
                    cCommandLine:='del'
                    cCommandLine+=' "'
                    cCommandLine+=cFullSymbolicPath
                    cCommandLine+=aFileDelMerge[nFile]
                    cCommandLine+='" '
                    cCommandLine+='/s /q'
                    WaitRunSrv(cCommandLine,.T.,cWaitRunDriver)
    
                    StaticCall(NDJLIB007,FileErase,cSymbolicPath+aFileDelMerge[nFile])
    
                Next nFile
            
            Else

                nFiles:=Len(aFileDelMerge)
                For nFile:=1 To nFiles
                    cIndexFile:=(cRestoreFullPath+aFileDelMerge[nFile])
                    IF (;
                            (Lower(cIndexExt)$Lower(SubStr(cIndexFile,-Len(cIndexExt))));
                            .or.;
                            (Lower(cOrdBagExt)$Lower(SubStr(cIndexFile,-Len(cIndexExt))));
                    )    
                        StaticCall(NDJLIB007,FileErase,cIndexFile)
                    EndIF    
                Next nFile
            
            EndIF    
        
        EndIF

        IF !(lTopConn)
            IF !(lVirtualLink)
                aEval(aFileDelMerge,{|cFile|StaticCall(NDJLIB007,FileErase,cFile)})
            EndIF    
            aSize(aFileDelMerge,0)
        EndIF    
        aSize(aAliasStruct,0)
        aSize(aTAliasStruct,0)
        aSize(aFieldPosAlias,0)
        aSize(aFieldPosTAlias,0)

    Next nBL

    lSuccessful:=.T.

Return(lSuccessful)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:TAliasOpen
        Autor:Marinaldo de Jesus
        Data:02/11/2011
        Descricao:Abre as Tabelas a serem utilizadas
        Sintaxe:RPRestoreTable(oRPIni,cPath,aTables,lUniqueDBMS,cRestoreFullPath,lVirtualLink)
    /*/
//------------------------------------------------------------------------------------------------
Static Function TAliasOpen(cRDDImport,lTopConn,cTempFile,cAlias,cTAlias,aAliasStruct,aTAliasStruct,aFieldPosAlias,aFieldPosTAlias)

    Local lSuccessful:=MsOpEndbf(.T.,cRDDImport,cTempFile,cTAlias,.T.,.F.,.F.,.F.)

    Local nField
    Local nFields:=Len(aAliasStruct)

    IF !(lSuccessful)
        //"Impossível abrir a tabela:"
        UserException(STR0028+cTempFile)
    EndIF
    aTAliasStruct:=(cTAlias)->(dbStruct())

    For nField:=1 To nFields
        aAdd(aFieldPosAlias,(cAlias)->(FieldPos(aAliasStruct[nField,DBS_NAME])))
        aAdd(aFieldPosTAlias,(cTAlias)->(FieldPos(aAliasStruct[nField,DBS_NAME])))
        IF (;
                (lTopConn);
                .and.;
                (aFieldPosTAlias[nField]>0);
        )    
            IF (aAliasStruct[nField][DBS_TYPE]$"'D','L','N'")
                aTAliasStruct[aFieldPosTAlias[nField]][DBS_TYPE]:=aAliasStruct[nField][DBS_NAME]
                aTAliasStruct[aFieldPosTAlias[nField]][DBS_TYPE]:=aAliasStruct[nField][DBS_TYPE]
                aTAliasStruct[aFieldPosTAlias[nField]][DBS_TYPE]:=aAliasStruct[nField][DBS_LEN]
                aTAliasStruct[aFieldPosTAlias[nField]][DBS_TYPE]:=aAliasStruct[nField][DBS_DEC]
                (cTAlias)->(;
                                    TcSetField(;
                                                    cTAlias,;
                                                    aAliasStruct[nField][DBS_NAME],;
                                                    aAliasStruct[nField][DBS_TYPE],;
                                                    aAliasStruct[nField][DBS_LEN],;
                                                    aAliasStruct[nField][DBS_DEC];
                                   );
                   )
            EndIF                                  
        EndIF
    Next nField

    aTAliasStruct:=(cTAlias)->(dbStruct())

Return(lSuccessful)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:PutRPSX5()
        Autor:Marinaldo de Jesus
        Data:07/11/2011
        Descricao:Armazena o Ponto de Restauracao na Tabela SX5
        Sintaxe:StaticCall(NDJLIB021,PutRPSX5,cRPKey,cTSX5Key)
    /*/
//------------------------------------------------------------------------------------------------
METHOD PUTRPSX5(cRPKey,cTSX5Key) CLASS NDJLIB021
RETURN(PutRPSX5(@cRPKey,@cTSX5Key))
Static Function PutRPSX5(cRPKey,cTSX5Key)

    Local aArea:=GetArea()
    
    Local bGetNumExc:={||__Soma1(cX5Chave)}

    Local cAlias:=GetNextAlias()
    Local cDBMS:=Upper(Alltrim(TCGetDb()))
    Local cX5Chave:=""
    Local cX5Filial:=xFilial("SX5")
    Local cX5Tabela:=GetNewPar("NDJ_X5RPCD","R.")    //Codigo da Tabela Ponto de Restauracao

    Local cX5Descri
    Local cX5DescSPA
    Local cX5DescEng
    
    Local lSuccessful:=.F.

    Local nSX5Oder:=RetOrder("SX5","X5_FILIAL+X5_TABELA+X5_CHAVE")

    BEGIN SEQUENCE

        SX5->(dbSetOrder(nSX5Oder))
        IF SX5->(!dbSeek(cX5Filial+"00"+cX5Tabela))
            //Obtendo a Descricao da Tabela Ponto de Restauracao
            cX5Descri:=GetNewPar("NDJ_X5RPDC",STR0016)//"Ponto de Restauracao"
            cX5DescSPA:=GetNewPar("NDJ_X5RPDC",STR0016)//"Ponto de Restauracao"
            cX5DescEng:=GetNewPar("NDJ_X5RPDC",STR0016)//"Ponto de Restauracao"
            IF SX5->(RecLock("SX5",.T.))
                SX5->X5_TABELA:="00"
                SX5->X5_CHAVE:=cX5Tabela
                SX5->X5_DESCRI:=cX5Descri
                SX5->X5_DESCSPA:=cX5DescSPA
                SX5->X5_DESCENG:=cX5DescEng
                SX5->(MsUnLock())
            EndIF
        EndIF

        IF (cDBMS$"ORACLE")

            BEGINSQL ALIAS cAlias
                %NoParser%
                SELECT
                    X5_DESCRI
                FROM
                    %table:SX5% SX5 WITH (NOLOCK)
                WHERE
                    SX5.%NotDel% 
                AND
                    SX5.X5_FILIAL=%xFilial:SX5%
                AND
                    SX5.X5_TABELA=%exp:cX5Tabela%
                AND
                    SubStr(X5_CHAVE,1,2)=%exp:cRPKey%
                AND
                    X5_DESCRI=%exp:cTSX5Key%
            ENDSQL

        Else
        
            BEGINSQL ALIAS cAlias
                %NoParser%
                SELECT
                    X5_DESCRI
                FROM
                    %table:SX5% SX5 WITH (NOLOCK)
                WHERE
                    SX5.%NotDel% 
                AND
                    SX5.X5_FILIAL=%xFilial:SX5%
                AND
                    SX5.X5_TABELA=%exp:cX5Tabela%
                AND
                    SubString(X5_CHAVE,1,2)=%exp:cRPKey%
                AND
                    X5_DESCRI=%exp:cTSX5Key%
            ENDSQL
    
        EndIF

        cX5Descri:=Lower(AllTrim((cAlias)->X5_DESCRI))
        (cAlias)->(dbCloseArea())
        dbSelectArea("SX5")

        cTSX5Key:=Lower(AllTrim(cTSX5Key))
        lSuccessful:=(cTSX5Key==cX5Descri)

        IF (lSuccessful)
            BREAK
        EndIF

        IF (cDBMS$"ORACLE")

            BEGINSQL ALIAS cAlias
                %NoParser%
                SELECT
                    MAX(X5_CHAVE) X5_CHAVE
                FROM
                    %table:SX5% SX5 WITH (NOLOCK)
                WHERE
                    SX5.%NotDel%
                AND
                    SX5.X5_FILIAL=%xFilial:SX5%
                AND
                    SX5.X5_TABELA=%exp:cX5Tabela%
                AND
                    SubStr(X5_CHAVE,1,2)=%exp:cRPKey%
            ENDSQL

        Else

            BEGINSQL ALIAS cAlias
                %NoParser%
                SELECT
                    MAX(X5_CHAVE) X5_CHAVE
                FROM
                    %table:SX5% SX5 WITH (NOLOCK)
                WHERE
                    SX5.%NotDel%
                AND
                    SX5.X5_FILIAL=%xFilial:SX5%
                AND
                    SX5.X5_TABELA=%exp:cX5Tabela%
                AND
                    SubString(X5_CHAVE,1,2)=%exp:cRPKey%
            ENDSQL
        
        EndIF
        
        cX5Chave:=(cAlias)->X5_CHAVE
        (cAlias)->(dbCloseArea())
        dbSelectArea("SX5")
        
        IF Empty(cX5Chave)
            cX5Chave:=PadR(cRPKey,Len(SX5->X5_CHAVE),"0") 
        Else
            cX5Chave:=Eval(bGetNumExc)
        EndIF

        PutFileInEof("SX5")

        PRIVATE INCLUI:=.T. //GetNrExclOk tem que identificar que eh uma tentativa inclusao
        lGetNrExcl:=    GetNrExclOk(;
                                            @cX5Chave,;
                                            "SX5",;
                                            "X5_CHAVE",;
                                            "X5_FILIAL+X5_TABELA+X5_CHAVE",;
                                            bGetNumExc,;
                                            .T.,;
                                            .F.;
                         );

        IF (lGetNrExcl)
            IF SX5->(RecLock("SX5",.T.))
                SX5->X5_TABELA:=cX5Tabela
                SX5->X5_CHAVE:=cX5Chave
                SX5->X5_DESCRI:=cTSX5Key
                SX5->X5_DESCSPA:=cTSX5Key
                SX5->X5_DESCENG:=cTSX5Key
                SX5->(MsUnLock())
            EndIF
        EndIF

    END SEQUENCE

    RestArea(aArea)

Return(lSuccessful)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:GetRPSX5()
        Autor:Marinaldo de Jesus
        Data:07/11/2011
        Descricao:Obtem o Ponto de Restauracao da Tabela SX5
        Sintaxe:StaticCall(NDJLIB021,GetRPSX5,cRPKey)
    /*/
//------------------------------------------------------------------------------------------------
METHOD GETRPSX5(cRPKey) CLASS NDJLIB021
RETURN(GetRPSX5(@cRPKey))
Static Function GetRPSX5(cRPKey)

    Local aArea:=GetArea()
    Local aIndex:={}
    Local aBagName:={}
    Local adbStruct:=SX5->(dbStruct())
    Local aRecnos:={}

    Local cF3:=AllTrim(GetNewPar("NDJ_SXB_RP","NDJ_RP"))
    Local cRDD:="DBFCDXADS"
    Local cDBMS:=Upper(Alltrim(TCGetDb()))
    Local cFilter:=""
    Local cTSX5Key:=""
    Local cX5Filial:=xFilial("SX5")
    Local cTempFile:=(CriaTrab(NIL,.F.)+".dbf")
    Local cX5Tabela:=GetNewPar("NDJ_X5RPCD","R.")    //Codigo da Tabela Ponto de Restauracao
    
    Local lCpoRet:=.F.

    Local nBL
    Local nEL
    Local nATField
    Local nX5Recno

    aAdd(adbStruct,Array(DBS_ALEN))
    nATField:=Len(adbStruct)
    adbStruct[nATField][DBS_NAME]:="_X5_FILIAL
    adbStruct[nATField][DBS_TYPE]:="C"
    adbStruct[nATField][DBS_LEN]:=LEN(SX5->X5_FILIAL)
    adbStruct[nATField][DBS_DEC]:=0

    cFilter:="X5_FILIAL='"+cX5Filial+"'"
    cFilter+=" AND "
    cFilter+="X5_TABELA='"+cX5Tabela+"'"
    cFilter+=" AND "
    IF (cDBMS $"ORACLE")
        cFilter+="SUBSTR(X5_CHAVE,1,2)='"+cRPKey+"'"        
    Else
        cFilter+="SUBSTRING(X5_CHAVE,1,2)='"+cRPKey+"'"
    EndIF    
    cFilter+=" AND " 
    cFilter+="X5_DESCRI LIKE '%\"+cEmpAnt+"_%'"

    FilBrowse("SX5",@aIndex,"@"+cFilter)

    aBagName:=StaticCall(NDJLIB007,GetArrBagName,"SX5",@cTempFile,cRDD)

       aEval(aBagName[2],{|aElem,nAT|,aBagName[2][nAT][1]:=StrTran(aBagName[2][nAT][1],"X5_FILIAL","_X5_FILIAL")})
       aEval(aBagName[2],{|aElem,nAT|,aBagName[2][nAT][2]:=&(StrTran(GetCbSource(aBagName[2][nAT][2]),"X5_FILIAL","_X5_FILIAL"))})

    StaticCall(NDJLIB007,MakeTmpFile,"SX5","_X5",cTempFile,NIL,NIL,NIL,@aBagName,@adbStruct,NIL,cRDD)

    _X5->(dbGoTop())

    While _X5->(!Eof())
        _X5->(aAdd(aRecnos,Recno()))
        _X5->(dbSkip())
    End While

    nEL:=Len(aRecnos)
    For nBL:=1 To nEL
        _X5->(dbGoTo(aRecnos[nBL]))
        IF _X5->(!(Eof() .and. Bof()))
            IF _X5->(RLock())
                _X5->_X5_FILIAL:=cX5Filial
                _X5->(dbrUnLock())
            EndIF
        EndIF
    Next nBL

    _X5->(dbGoTop())

    IF (Type("aCpoRet")=="A")
        aSize(aCpoRet,0) //aCpoRet Public em Conpad1
    EndIF
    lConpad1:=ConPad1(NIL,NIL,NIL,@cF3)
    lCpoRet:=((Type("aCpoRet")=="A") .and. !Empty(aCpoRet))
    IF (;
            (lConpad1);
            .or.;
            (lCpoRet);
            .or.;
            !(nX5Recno==_X5->(Recno()));
        )
        //Confirma a Restauração do Ambiente?"###"Atenção"
        IF !(_X5->(Eof() .and. Bof()))
            IF MsgYesNo(OemToAnsi(STR0034),OemToAnsi(STR0022))
                cTSX5Key:=AllTrim(_X5->X5_DESCRI)
            EndIF    
        EndIF
    EndIF

    StaticCall(NDJLIB007,CloseTmpFile,"_X5",@cTempFile,@aBagName,cRDD)

    EndFilBrw("SX5",@aIndex)

    RestArea(aArea)

Return(cTSX5Key)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:RPPWDSave()
        Autor:Marinaldo de Jesus
        Data:07/11/2011
        Descricao:Sava o Arquivo de Senhas
        Sintaxe:StaticCall(NDJLIB021,RPPWDSave)
    /*/
//------------------------------------------------------------------------------------------------
Static Function RPPWDSave(oRPIni,cCustomPath,cIniFile,cPathCustomExpr)

    Local cPathPWD
    
    Local lSuccess:=.T.

    cPathPWD:=oRPIni:GetPropertyValue(cCustomPath,"PathPWD","")
    IF !Empty(cPathPWD)
        IF !(SubStr(cPathPWD,-1)=="\")
            cPathPWD+="\"
        EndIF
        cPathPWD:=(cPathCustomExpr+cPathPWD)
        cPathPWD:=StrTran(cPathPWD,"\\","\")
        IF !StaticCall(NDJLIB001,DirMake,cPathPWD)
            //"Impossivel Criar o Diretorio. Verifique o Conteudo da Configuracao "###" no arquivo "
            UserException(STR0004+cCustomPath+"\PathPWD"+STR0003+cINIFile)
        EndIF
    
        cPWDFile:=oRPIni:GetPropertyValue("GENERAL","PWDFile","sigapss.spf")
        IF (;
                !Empty(cPWDFile);
                .and.;
                File(cPWDFile);
            )    
            lSuccess:=__CopyFile(cPWDFile,cPathPWD+cPWDFile)
            IF !(lSuccess)
                //"Impossivel Copiar o arquivo de senhas "###" para "
                UserException(STR0004+cPWDFile+STR0005+cPathPWD)
            EndIF
        EndIF
    EndIF
    
Return(lSuccess)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:RPPWDRestore()
        Autor:Marinaldo de Jesus
        Data:07/11/2011
        Descricao:Sava o Arquivo de Senhas
        Sintaxe:StaticCall(NDJLIB021,RPPWDRestore)
    /*/
//------------------------------------------------------------------------------------------------
Static Function RPPWDRestore(oRPIni,cCustomPath,cIniFile,cPathCustomExpr,cRestoreFullPath,lVirtualLink)

    Local cPathPWD
    Local cCommandLine
    Local cWaitRunDriver

    Local lSuccess:=.T.

    Local cEnvRootPath:=Lower(GetSrvProfString("RootPath",""))
    Local cEnvStartPath:=Lower(GetSrvProfString("StartPath",""))
    Local cEnvFullPath
    Local cFullPathPWD

    cPWDFile:=oRPIni:GetPropertyValue("GENERAL","PWDFile","sigapss.spf")
    IF !Empty(cPWDFile)
    
        IF !(SubStr(cEnvRootPath,-1)=="\")
            cEnvRootPath+="\"
        EndIF
        cEnvFullPath:=cEnvRootPath
        IF !(SubStr(cEnvFullPath,-1)=="\")
            cEnvFullPath+="\"
        EndIF
        cEnvFullPath+=cEnvStartPath
        IF !(SubStr(cEnvFullPath,-1)=="\")
            cEnvFullPath+="\"
        EndIF
        cEnvFullPath:=StrTran(cEnvFullPath,"\\","\")
    
        cPathPWD:=oRPIni:GetPropertyValue(cCustomPath,"PathPWD","")
        IF !(SubStr(cPathPWD,-1)=="\")
            cPathPWD+="\"
        EndIF
        cPathPWD:=(cPathCustomExpr+cPathPWD)
        cPathPWD:=StrTran(cPathPWD,"\\","\")
    
        cPWDFile:=oRPIni:GetPropertyValue("GENERAL","PWDFile","sigapss.spf")
        IF (;
                !Empty(cPWDFile);
                .and.;
                File(cPWDFile);
        )    
    
            IF !(lVirtualLink)
        
                SplitPath(cRestoreFullPath,@cWaitRunDriver)
                
                cFullPathPWD:=cEnvFullPath
                cFullPathPWD+=cPathPWD
                cFullPathPWD+=cPWDFile
                cFullPathPWD:=StrTran(cFullPathPWD,"\\","\")
                
                cCommandLine:='xcopy'
                cCommandLine+=' "'
                cCommandLine+=cFullPathPWD
                cCommandLine+='" '
                cCommandLine+=' "'
                cCommandLine+=cRestoreFullPath
                cCommandLine+='" '
                cCommandLine+='/c /q /y '
                
                lSuccess:=WaitRunSrv(cCommandLine,.T.,cWaitRunDriver)
            
            Else
            
                lSuccess:=__CopyFile(cPathPWD+cPWDFile,cRestoreFullPath+cPWDFile)
            
            EndIF    
            
            IF !(lSuccess)
                //"Impossivel Copiar o arquivo de senhas "###" para "
                UserException(STR0004+cPathPWD+cPWDFile+STR0005+cPathPWD)
            EndIF            
        
        EndIF  

    EndIF    

Return(lSuccess)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:RmtRPEnvLoad()
        Autor:Marinaldo de Jesus
        Data:07/11/2011
        Descricao:Carrega o Ambiente de Restauracao
        Sintaxe:StaticCall(NDJLIB021,RmtRPEnvLoad,cRPEnv)
    /*/
//------------------------------------------------------------------------------------------------
Static Function RmtRPEnvLoad(cRPEnv,lQuit,lMsgInfo)

    Local cRmtExe
    Local cModule
    Local cParam:=""
    Local cEmpFilAnt:=(cEmpAnt+cFilAnt)

    IF (IsPlugin() .or. IsTelNet()) // Remote ActiveX ou Telnet
        //"Ambiente de Restauração não disponível"###"Configuração atual não permite a Restauração do Sistema"
        Final(STR0020,STR0021)
    EndIF

    DEFAULT lMsgInfo:=.T.
    IF (lMsgInfo)
        //"Ambiente de Restauração Atualizado. Reload Será efetuado para Carga do Novo Ambiente"###"Atenção"
        MsgInfo(OemToAnsi(STR0020),OemToAnsi(STR0022))
    EndIF    

    IF (SetMDI())
        cModule:="SIGAMDI"
        IF !(oApp:cMDIEmpFil==cEmpFilAnt)
            oApp:cMDIEmpFil:=cEmpFilAnt
        EndIF    
        oApp:cNumEmp:=oApp:cMDIEmpFil
        cParam:=" -A="+oApp:cModName
    ElseIF (SetMDIChild(0))
        IF (MDIChildUpdate(.T.))
            SetMDI(.T.)
            RmtRPEnvLoad(cRPEnv,.F.,.F.)
            SetMDI(.F.)
        EndIF
        Return(.F.)
    ElseIF uSigaadv
        cModule:="SIGAADV"
        cParam:=" -A="+oApp:cModName
    Else
        cModule:=oApp:cModName
    EndIF                                                             

    cRmtExe:=GetRemoteIniName()

    IF (GetRemoteType()==2)
        cRmtExe:=SubStr(cRmtExe,At(":",cRmtExe)+1)
        cRmtExe:=(StrTran(Lower(cRmtExe),".ini",".exe")+" -M -P="+cModule+" -E="+cRPEnv+" -A="+PswGetSession()+cParam)
    Else
        cRmtExe:=(StrTran(Lower(cRmtExe),".ini",".exe")+" -M -P="+cModule+" -E="+cRPEnv+" -A="+PswGetSession()+cParam)
    EndIF

    WinExec(cRmtExe)

    DEFAULT lQuit:=.T.
    IF (lQuit)
        CloseLog()
        MS_QUIT()
    EndIF
    
Return(.T.)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:GetDBMSSrv()
        Autor:Marinaldo de Jesus
        Data:05/11/2011
        Descricao:Obtem o DBMSSrv
        Sintaxe:StaticCall(NDJLIB021,GetDBMSSrv,cEnvironment,cSrvIniName)
    /*/
//------------------------------------------------------------------------------------------------
Static Function GetDBMSSrv(cEnvironment,cSrvIniName)

    Local cDBMSSrv

    DEFAULT cEnvironment:=GetEnvServer()
    DEFAULT cSrvIniName:=GetSrvIniName()

    cDBMSSrv:=GetPvProfString(cEnvironment,"TOPSERVER","ERROR",cSrvIniName)

    IF (cDBMSSrv=="ERROR")
        cDBMSSrv:=GetPvProfString(cEnvironment,"DBSERVER",cDBMSSrv,cSrvIniName)
        IF (cDBMSSrv=="ERROR")
            cDBMSSrv:=GetPvProfString("TOPCONNECT","SERVER",cDBMSSrv,cSrvIniName)
            IF (cDBMSSrv=="ERROR")
                cDBMSSrv:=GetPvProfString("TOTVSDBACCESS","SERVER",cDBMSSrv,cSrvIniName)    
                IF (cDBMSSrv=="ERROR")
                    cDBMSSrv:=GetPvProfString("TOTVSDBACCESS","DBSERVER",cDBMSSrv,cSrvIniName)    
                    IF (cDBMSSrv=="ERROR")
                        cDBMSSrv:=GetPvProfString("DBACCESS","SERVER",cDBMSSrv,cSrvIniName)    
                        IF (cDBMSSrv=="ERROR")
                            cDBMSSrv:=GetPvProfString("DBACCESS","DBSERVER",cDBMSSrv,cSrvIniName)
                        ENDIF
                    EndIF
                EndIF    
            EndIF
        EndIF    
    EndIF

Return(Lower(cDBMSSrv))

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:GetDBMSName()
        Autor:Marinaldo de Jesus
        Data:05/11/2011
        Descricao:Obtem o DBMSName
        Sintaxe:StaticCall(NDJLIB021,GetDBMSName,cEnvironment,cSrvIniName)
    /*/
//------------------------------------------------------------------------------------------------
Static Function GetDBMSName(cEnvironment,cSrvIniName)

    Local cDBMSName

    DEFAULT cEnvironment:=GetEnvServer()
    DEFAULT cSrvIniName:=GetSrvIniName()

    cDBMSName:=GetPvProfString(cEnvironment,"TOPDATABASE","ERROR",cSrvIniName)

    IF (cDBMSName=="ERROR")
        cDBMSName:=GetPvProfString(cEnvironment,"DBDATABASE",cDBMSName,cSrvIniName)
        IF (cDBMSName=="ERROR")
            cDBMSName:=GetPvProfString("TOPCONNECT","DATABASE",cDBMSName,cSrvIniName)
            IF (cDBMSName=="ERROR")
                cDBMSName:=GetPvProfString("TOTVSDBACCESS","DATABASE",cDBMSName,cSrvIniName)    
                IF (cDBMSName=="ERROR")
                    cDBMSName:=GetPvProfString("TOTVSDBACCESS","DBDATABASE",cDBMSName,cSrvIniName)    
                    IF (cDBMSName=="ERROR")
                        cDBMSName:=GetPvProfString("DBACCESS","DATABASE",cDBMSName,cSrvIniName)    
                        IF (cDBMSName=="ERROR")
                            cDBMSName:=GetPvProfString("DBACCESS","DBDATABASE",cDBMSName,cSrvIniName)
                        ENDIF
                    EndIF
                EndIF    
            EndIF
        EndIF    
    EndIF

Return(Lower(cDBMSName))

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:GetDBMSAlias()
        Autor:Marinaldo de Jesus
        Data:05/11/2011
        Descricao:Obtem o DBMSName
        Sintaxe:StaticCall(NDJLIB021,GetDBMSAlias,cEnvironment,cSrvIniName)
    /*/
//------------------------------------------------------------------------------------------------
Static Function GetDBMSAlias(cEnvironment,cSrvIniName)

    Local cDBMSAlias

    DEFAULT cEnvironment:=GetEnvServer()
    DEFAULT cSrvIniName:=GetSrvIniName()

    cDBMSAlias:=GetPvProfString(cEnvironment,"TOPALIAS","ERROR",cSrvIniName)

    IF (cDBMSAlias=="ERROR")
        cDBMSAlias:=GetPvProfString(cEnvironment,"DBALIAS",cDBMSAlias,cSrvIniName)
        IF (cDBMSAlias=="ERROR")
            cDBMSAlias:=GetPvProfString("TOPCONNECT","ALIAS",cDBMSAlias,cSrvIniName)
            IF (cDBMSAlias=="ERROR")
                cDBMSAlias:=GetPvProfString("TOTVSDBACCESS","ALIAS",cDBMSAlias,cSrvIniName)    
                IF (cDBMSAlias=="ERROR")
                    cDBMSAlias:=GetPvProfString("TOTVSDBACCESS","DBALIAS",cDBMSAlias,cSrvIniName)    
                    IF (cDBMSAlias=="ERROR")
                        cDBMSAlias:=GetPvProfString("DBACCESS","ALIAS",cDBMSAlias,cSrvIniName)    
                        IF (cDBMSAlias=="ERROR")
                            cDBMSAlias:=GetPvProfString("DBACCESS","DBALIAS",cDBMSAlias,cSrvIniName)
                        ENDIF
                    EndIF
                EndIF    
            EndIF
        EndIF    
    EndIF

Return(Lower(cDBMSAlias))

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:GetDBMSPort()
        Autor:Marinaldo de Jesus
        Data:05/11/2011
        Descricao:Obtem o DBMSName
        Sintaxe:StaticCall(NDJLIB021,GetDBMSPort,cEnvironment,cSrvIniName)
    /*/
//------------------------------------------------------------------------------------------------
Static Function GetDBMSPort(cEnvironment,cSrvIniName)

    Local nDBMSPort

    DEFAULT cEnvironment:=GetEnvServer()
    DEFAULT cSrvIniName:=GetSrvIniName()

    nDBMSPort:=GetPvProfString(cEnvironment,"TOPPORT","ERROR",cSrvIniName)

    IF (nDBMSPort=="ERROR")
        nDBMSPort:=GetPvProfString(cEnvironment,"DBPORT",nDBMSPort,cSrvIniName)
        IF (nDBMSPort=="ERROR")
            nDBMSPort:=GetPvProfString("TOPCONNECT","PORT",nDBMSPort,cSrvIniName)
            IF (nDBMSPort=="ERROR")
                nDBMSPort:=GetPvProfString("TOTVSDBACCESS","PORT",nDBMSPort,cSrvIniName)    
                IF (nDBMSPort=="ERROR")
                    nDBMSPort:=GetPvProfString("TOTVSDBACCESS","DBPORT",nDBMSPort,cSrvIniName)    
                    IF (nDBMSPort=="ERROR")
                        nDBMSPort:=GetPvProfString("DBACCESS","PORT",nDBMSPort,cSrvIniName)    
                        IF (nDBMSPort=="ERROR")
                            nDBMSPort:=GetPvProfString("DBACCESS","DBPORT",nDBMSPort,cSrvIniName)
                        ENDIF
                    EndIF
                EndIF    
            EndIF
        EndIF    
    EndIF

    nDBMSPort:=Val(nDBMSPort)
    IF (nDBMSPort==0)
        nDBMSPort:=7890
    EndIF

Return(nDBMSPort)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:U_RPUpdTable()
        Autor:Marinaldo de Jesus
        Data:05/11/2011
        Descricao:Atualizacao Fisica das Tabelas
        Sintaxe:U_RPUpdTable(aUpdTable)
    /*/
//------------------------------------------------------------------------------------------------
User Function RPUpdTable(aUpdTable,cEmp,cFil,bBefore,bAfter,lRPCSetEnv)
    DEFAULT bBefore:={||.T.}
    DEFAULT bAfter:={||.T.}
    RpcSetType(3)
    DEFAULT lRPCSetEnv:=.T.
    IF (lRPCSetEnv)
        RpcSetEnv(cEmp,cFil)
    EndIF    
    #IFDEF TOP
        SetTopType("A")
        TCInternal(5,"*OFF") // Desliga Refresh no Lock do Top
    #ENDIF
    SetsDefault()
    IF Eval(bBefore)
        SM0->(dbSeek(cEmp+cFil))
        StaticCall(NDJLIB010,PutInternal,ProcName())
        RPUpdTable(@aUpdTable)
    EndIF
    Eval(bAfter)
Return(.T.)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:RPUpdTable()
        Autor:Marinaldo de Jesus
        Data:05/11/2011
        Descricao:Atualizacao Fisica das Tabelas
        Sintaxe:RPUpdTable(aUpdTable)
    /*/
//------------------------------------------------------------------------------------------------
Static Function RPUpdTable(aUpdTable)

    Local cTCBuild:="TCGetBuild"
    Local cTopBuild

    Local lCLOBSup
    Local lCLOBActive

    Local nTable
    Local nTables

    __SetX31Mode(.F.)

    IF FindFunction(cTCBuild)
        cTopBuild:=&cTCBuild.()
    EndIF

    lCLOBSup:=((cTopBuild>="20090811") .and. (TcInternal(89)=="CLOB_SUPPORTED"))

    nTables:=Len(aUpdTable)
    For nTable:=1 To nTables

        IF (lCLOBSup)
            lCLOBActive:=TCCLOBActive(aUpdTable[nTable])
            IF (lCLOBActive)
                TcInternal(25,"CLOB")
            EndIF    
        EndIF

        IF (Select(aUpdTable[nTable])>0)
            (aUpdTable[nTable])->(dbCloseArea())
        EndIF

        X31UpdTable(aUpdTable[nTable])

        IF (__GetX31Error())
            ConOut(__GetX31Trace())
        EndIF

        IF (lCLOBSup)
            IF (lCLOBActive)
                TcInternal(25,"OFF")
            EndIF    
        EndIF

    Next nTable

    Static Function TCCLOBActive(cAlias)
    
        Local lActive:=.F.
    
        lActive:=((cAlias>="NQ ") .and. (cAlias<="NZZ"))
        IF !(lActive)
            lActive:=((cAlias>="O0 ") .and. (cAlias<="NZZ"))
        EndIF
        IF (lActive)
            lActive:=!(cAlias$"NQD,NQF,NQP,NQT")
        EndIF    
    
    Return(lActive)

Return(.T.)
