#include "totvs.ch"
#include "shell.ch"

static aMsgs

//------------------------------------------------------------------------------------------------
    /*/
        CLASS:uSCP
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:29/04/2015
        Descricao:Transferencia de dados segura usando o protocolo SCP a partir do pscp.exe
        Sintaxe:uSCP():New()->Objeto do Tipo uSCP
        
        //------------------------------------------------------------------------------------------------        
        Documentacao de uso de pscp.exe:
        http://tartarus.org/~simon/putty-snapshots/htmldoc/Chapter5.html#pscp-starting
        
        //------------------------------------------------------------------------------------------------        
        Downloads do pscp.exe:
        http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html
        
        //------------------------------------------------------------------------------------------------        
        Obs.: pscp.exe devera ser adicionado como Resource no Projeto do IDE (TDS)
        TODO: (1) Implementar o envio via socket utilizando o Harbour como conector sftp (https://github.com/NaldoDj/PuTTY)
        
        //------------------------------------------------------------------------------------------------        
        PuTTY Secure Copy client
        
        Release 0.64
        
        Usage:
        
        pscp [options] [user@]host:source target
        pscp [options] source [source...] [user@]host:target
        pscp [options] -ls [user@]host:filespec
 
        Options:
        
          -V        print version information and exit
          -pgpfp    print PGP key fingerprints and exit
          -p        preserve file attributes
          -q        quiet, don't show statistics
          -r        copy directories recursively
          -v        show verbose messages
          -load sessname  Load settings from saved session
          -P port   connect to specified port
          -l user   connect with specified username
          -pw passw login with specified password
          -1 -2     force use of particular SSH protocol version
          -4 -6     force use of IPv4 or IPv6
          -C        enable compression
          -i key    private key file for user authentication
          -noagent  disable use of Pageant
          -agent    enable use of Pageant
          -hostkey aa:bb:cc:...
                    manually specify a host key (may be repeated)
          -batch    disable all interactive prompts
          -unsafe   allow server-side wildcards (DANGEROUS)
          -sftp     force use of SFTP protocol
          -scp      force use of SCP protocol
        
     /*/
    
//------------------------------------------------------------------------------------------------
CLASS uSCP from tHash
    METHOD New() CONSTRUCTOR
    METHOD ClassName()
    METHOD Run()
END CLASS

User Function SCP()
Return(uSCP():New())

METHOD New() CLASS uSCP
    _Super:New()
    self:ClassName()
    self:Set("nStatus",0)
    IF self:Get("lLog",.T.)
        self:Set("aLog",Array(0))
    EndIF
    LoadMsgs()
    self:Set("aMsgs",aMsgs)
Return(self)

METHOD ClassName() CLASS uSCP
    self:cClassName:="uSCP"
Return(self:cClassName)

METHOD Run() CLASS uSCP
 
    Local aFiles
    Local aParameters
    
    Local cAppSCP:=self:Get("cAppSCP","pscp.exe")
    Local cBatSCP:=self:Get("cBatSCP","pscp.bat")

    Local cURL:=self:Get("cURL","")
    Local cMode:=self:Get("cMode","P")
    Local cSource:=self:Get("cSource","")
    Local cTarget:=self:Get("cTarget","")
   
    Local cFile
    Local cDirSCP
    Local cDirTmp
    Local cSrvPath
    Local cSCPPath
    Local cTmpFile
    Local cRootPath
    Local cLogAppSCP
    Local cfLogAppSCP
    Local ctLogAppSCP
    Local cFullAppSCP
    Local cFullBatSCP

    Local cKParameter
    Local cVParameter

    Local cCommandLine

    Local lCopyFile

    Local lSrv:=self:Get("lSrv",.T.)
    Local lForceClient:=self:Get("lForceClient",.T.)

    Local nD
    Local nJ
    
    Local nFile
    Local nFiles

    Local nStatus:=0

    Local nSWMode:=self:Get("nSWMode",SW_MAXIMIZE)
    
    BEGIN SEQUENCE
        
        //-------------------------------------------------------------------------------
        //Verifica se vai forcar a Execucao do comando a partir do Client
        IF (lForceClient)
            IF (lSrv)
                cDirTmp:=GetTempPath()
                IF .NOT.(Right(cDirTmp,1)=="\")
                    cDirTmp+="\"
                EndIF
                cDirTmp+=CriaTrab(NIL,.F.)
                cDirTmp+="\"
                //-------------------------------------------------------------------------------
                //Verifica a existencia do diretorio para Extracao dos Arquivos Temporarios
                IF .NOT.(lIsDir(cDirTmp))
                    IF .NOT.(MakeDir(cDirTmp)==0)
                        nStatus:=-1
                        ConOut("["+ProcName()+"]["+LoadMsgs(nStatus)+"]["+cDirTmp+"]")
                        BREAK
                    EndIF
                EndIF
                IF (cMode=="P")
                    //-------------------------------------------------------------------------------
                    //Obtem o Diretorio no Servidor
                    cSrvPath:=""
                    SplitPath(cSource,NIL,@cSrvPath)
                    IF .NOT.(Right(cSrvPath,1)=="\")
                        cSrvPath+="\"
                    EndIF
                    //-------------------------------------------------------------------------------
                    //Copia os arquivos do Srv para Client
                    nFiles:=aDir(cSource,@aFiles)
                    For nFile:=1 To nFiles
                        cFile:=cSrvPath
                        cFile+=aFiles[nFile]
                        cTmpFile:=cDirTmp
                        cTmpFile+=aFiles[nFile]
                        lCopyFile:=__CopyFile(cFile,cTmpFile)
                        IF .NOT.(lCopyFile)
                            ConOut("["+ProcName()+"][Impossivel Copiar Arquivo][Origem]["+cFile+"][Destino]["+cTmpFile+"]")
                        EndIF
                    Next nFile
                    //-------------------------------------------------------------------------------
                    //Redefine a Origim dos Dados
                    cSource:=cDirTmp
                    cSource+="*.*"
                    //-------------------------------------------------------------------------------
                    //Redefine para Modo Client
                    lSrv:=.F.
                Else
                    //-------------------------------------------------------------------------------
                    //Ajusta cTarget
                    IF .NOT.(Right(cTarget,1)=="\")
                        cTarget+="\"
                    EndIF
                    //-------------------------------------------------------------------------------
                    //Obtem o Diretorio no Servidor
                    cSrvPath:=cTarget
                    //-------------------------------------------------------------------------------
                    //Verifica a existencia do diretorio no servidor
                    IF .NOT.(lIsDir(cSrvPath))
                        IF .NOT.(MakeDir(cSrvPath)==0)
                            nStatus:=-1
                            ConOut("["+ProcName()+"]["+LoadMsgs(nStatus)+"]["+cSrvPath+"]")
                            BREAK
                        EndIF
                    EndIF            
                    //-------------------------------------------------------------------------------
                    //Redefine o Destino dos Arquivos
                    cTarget:=cDirTmp
                EndIF                    
            EndIF
        EndIF
        
        //-------------------------------------------------------------------------------
        //Define o Caminho para o aplicativo de Transferencia SCP
        IF (lSrv).and.(.NOT.(lForceClient))
            cDirSCP:="\SCP\"
            //-------------------------------------------------------------------------------
            //Obtem o RootPath do Protheus
            cRootPath:=AllTrim(GetSrvProfString("ROOTPATH",""))
            IF .NOT.(Right(cRootPath,1)=="\")
                cRootPath+="\"
            EndIF
        Else
            //-------------------------------------------------------------------------------
            //Neste caso, o caminho sera no diretorio Temporario do Client
            cDirSCP:=GetTempPath()
            IF .NOT.("\"$Right(cDirSCP,1))
                cDirSCP+="\"
            EndIF
            cDirSCP+="SCP\"
        EndIF
        
        //-------------------------------------------------------------------------------
        //Verifica a existencia do diretorio para Extracao do aplicativo de Transferencia SCP
        IF .NOT.(lIsDir(cDirSCP))
            IF .NOT.(MakeDir(cDirSCP)==0)
                nStatus:=-1
                ConOut("["+ProcName()+"]["+LoadMsgs(nStatus)+"]["+cDirSCP+"]")
                BREAK
            EndIF
        EndIF
        //-------------------------------------------------------------------------------
        //Obtem o Caminho completo do aplicativo de Transferencia SCP
        cFullAppSCP:=(cDirSCP+cAppSCP)
        
        //-------------------------------------------------------------------------------
        //Verifica a existencia aplicativo de Transferencia SCP
        IF .NOT.(File(cFullAppSCP))
            //-------------------------------------------------------------------------------
            //Extrai, do Repositorio de Objetos, o aplicativo de Transferencia SCP
            //Obs: Pressupoe, para a extracao, que ele foi adicionado como Resource no processo de compilacao
            IF .NOT.(Resource2File(cAppSCP,cFullAppSCP))
                nStatus:=-2
                ConOut("["+ProcName()+"]["+LoadMsgs(nStatus)+"]["+cFullAppSCP+"]")
                BREAK
            EndIF
        EndIF
       
        //-------------------------------------------------------------------------------
        //Elabora o Comando para execucao do Aplicativo de Transferencia SCP
        //-------------------------------------------------------------------------------
        //Exemplo Client:
        //P:pscp.exe -SCP -C -l cUSR -pw cPWD -P cPort C:\tmp\files\*.txt cURL:cTarget
        //G:pscp.exe -SCP -C -l cUSR -pw cPWD -P cPort cURL:cTarget/*.txt C:\tmp\files\ 
        //-------------------------------------------------------------------------------
        //Exemplo Server:
        //P:pscp.exe -SCP -C -l cUSR -pw cPWD -P cPort \tmp\files\*.txt cURL:cTarget
        //G:pscp.exe -SCP -C -l cUSR -pw cPWD -P cPort cURL:cTarget/*.txt \tmp\files\ 
        //-------------------------------------------------------------------------------
        cCommandLine:=""
        IF (lSrv).and.(.NOT.(lForceClient))
            cfLogAppSCP:=cRootPath
            cCommandLine+=cRootPath
            IF (Left(cDirSCP,1)=="\")
                cfLogAppSCP+=SubStr(cDirSCP,2)
                cCommandLine+=SubStr(cDirSCP,2)
            Else
                cfLogAppSCP+=cDirSCP
                cCommandLine+=cDirSCP
            EndIF
        Else
            cfLogAppSCP:=cDirSCP
            cCommandLine+=cDirSCP
        EndIF
        IF .NOT.(Right(cfLogAppSCP,1)=="\")
            cfLogAppSCP+="\"
        EndIF
        //-------------------------------------------------------------------------------
        //Define o arquivo que conterá o log de execucao do Aplicativo de Transferencia SCP
        ctLogAppSCP:=CriaTrab(NIL,.F.)+".log"
        cfLogAppSCP+=ctLogAppSCP
        //-------------------------------------------------------------------------------
        //Adiciona o Aplicativo de Transferencia SCP
        cCommandLine+=cAppSCP
        cCommandLine+=" "
        //-------------------------------------------------------------------------------
        //Carega os Parametros
        aParameters:=self:GetAllProperties("aParameters")
        nJ:=Len(aParameters)
        For nD:=1 To nJ
            cKParameter:=aParameters[nD][1]
            cVParameter:=self:GetPropertyValue("aParameters",cKParameter)
            cCommandLine+=cVParameter
            cCommandLine+=" "
        Next nD
        //-------------------------------------------------------------------------------
        //Verifica cMode
        IF (cMode=="P")
            //-------------------------------------------------------------------------------
            //Ajusta cTarget
            cTarget:=StrTran(cTarget,"\","/")
            IF (Right(cTarget,1)=="/")
                cTarget:=SubStr(cTarget,1,(Len(cTarget)-1))
            EndIF
            //-------------------------------------------------------------------------------
            //Verifica se a Transferencia vai ser feita a partir Servidor
            IF (lSrv)
                cCommandLine+=cRootPath
                IF (Left(cSource,1)=="\")
                    cCommandLine+=SubStr(cSource,2)
                Else
                    cCommandLine+=cSource
                EndIF    
            Else
                cCommandLine+=cSource            
            EndIF
            cCommandLine+=" "
            cCommandLine+=cURL
            cCommandLine+=":"
            cCommandLine+=cTarget
        Else //cMode=="G"
            cCommandLine+=cURL
            cCommandLine+=":"
            cCommandLine+=cSource
            cCommandLine+=" "
            IF (lSrv).and.(.NOT.(lForceClient))
                cCommandLine+=cRootPath
                IF (Left(cTarget,1)=="\")
                    cCommandLine+=SubStr(cTarget,2)
                Else
                    cCommandLine+=cTarget
                EndIF
            Else
                cCommandLine+=cTarget
            EndIF
        EndIF

        //-------------------------------------------------------------------------------
        //Adiciona a Saida do Log
        IF self:Get("lLog",.T.)
            cCommandLine+=" >> "
            cCommandLine+=cfLogAppSCP
            cCommandLine+=" "
        EndIF    
        
        //-------------------------------------------------------------------------------
        //Define o Batch File
        cFullBatSCP:=StrTran(cfLogAppSCP,ctLogAppSCP,cBatSCP)
        
        //-------------------------------------------------------------------------------
        //Redefine cCommandLine incluindo mode con 
        IF self:Get("lModeCon",.T.)
            cCommandLine:=self:Get("ModeCon","mode con:lines=45 cols=165")+CRLF+cCommandLine
        EndIF    

        //-------------------------------------------------------------------------------
        //Grava o Comando no Batch File
        MemoWrite(cFullBatSCP,cCommandLine)
        
        //-------------------------------------------------------------------------------
        //Redefine cCommandLine
        cCommandLine:=cFullBatSCP
        
        //-------------------------------------------------------------------------------
        //Redefine cTarget quando lForceClient:.T. e cMode:"G"
        IF (lForceClient)
            IF (cMode=="G")
                //-------------------------------------------------------------------------------
                //Copia os arquivos do Client para Srv
                IF .NOT.(Right(cTarget,1)=="\")
                    cTarget+="\"
                EndIF
                cTarget+="*.*"
            EndIF
        EndIF    
        
        //-------------------------------------------------------------------------------
        //Verifica se o comando vai ser executado a partir do servidor
        IF (lSrv).and.(.NOT.(lForceClient))
            //-------------------------------------------------------------------------------
            //Executa o Comando de Transferencia no Server
            //Onde:
            //cCommandLineLine:Instrucao a ser executada
            //lWaitRun:Se deve aguardar o termino da Execucao
            //Path:Onde, no server, a funcao devera ser executada
            //Retorna:.T. Se conseguiu executar o Comando, caso contrario, .F.
            //Read more:http://www.blacktdn.com.br/2011/04/protheus-executando-aplicacoes-externas.html#ixzz3YemwKcI7
            //WaitRunSrv(cCommandLineLine,lWaitRun,cPath):lSuccess
            cWaitRunPath:=cRootPath
            cWaitRunPath+=IF(Left(cDirSFTP,1)=="\",SubStr(cDirSFTP,2),cDirSFTP)
            IF .NOT.(WaitRunSrv(cCommandLine,.T.,cWaitRunPath))
                nStatus:=-3
                ConOut("["+ProcName()+"]["+LoadMsgs(nStatus)+"]["+cCommandLine+"][Path]["+cRootPath+"]")
                BREAK
            EndIF
            nStatus:=0
        Else
            //-------------------------------------------------------------------------------
            //Executa o Comando de Transferencia no Client
            //Onde:
            //cCommandLineLine:Instrucao a ser executada
            //nMode:Indica o modo de interface a ser criado para a execucao do programa
            //Read more:http://tdn.totvs.com/display/tec/WaitRun
            //WaitRun(cCommandLineLine,nMode):nSuccess
            nStatus:=WaitRun(cCommandLine,nSWMode)
            IF .NOT.(nStatus==0)
                nStatus:=-3
                ConOut("["+ProcName()+"]["+LoadMsgs(nStatus)+"]["+cCommandLine+"]")
                BREAK
            EndIF
            nStatus:=0
        EndIF

        //-------------------------------------------------------------------------------
        //Verificacao final quando lForceClient
        IF (lForceClient)
            IF (cMode=="G")
                nFiles:=aDir(cTarget,@aFiles)
                For nFile:=1 To nFiles
                    cFile:=cDirTmp
                    cFile+=aFiles[nFile]
                    cTmpFile:=cSrvPath
                    cTmpFile+=aFiles[nFile]
                    lCopyFile:=__CopyFile(cFile,cTmpFile)
                    IF .NOT.(lCopyFile)
                        ConOut("["+ProcName()+"][Impossivel Copiar Arquivo][Origem]["+cFile+"][Destino]["+cTmpFile+"]")
                    EndIF
                Next nFile
            EndIF
            //-------------------------------------------------------------------------------
            //Verifica se deve Excluir os Arquivos Temporarios
            cLogAppSCP:=uSCPCG(@aFiles,@cDirTmp,@cMode,@cSource,@cTarget,@cfLogAppSCP)
            IF .NOT.(Empty(cLogAppSCP))
                IF self:Get("lLog",.T.)
                    aAdd(self:Get("aLog"),cLogAppSCP)
                EndIF
            EndIF
        EndIF
    
    END SEQUENCE
    
    IF (lForceClient)
        //-------------------------------------------------------------------------------
        //Verifica se deve Excluir os Arquivos Temporarios
        cLogAppSCP:=uSCPCG(@aFiles,@cDirTmp,@cMode,@cSource,@cTarget,@cfLogAppSCP)
        IF .NOT.(Empty(cLogAppSCP))
            IF self:Get("lLog",.T.)
                aAdd(self:Get("aLog"),cLogAppSCP)
            EndIF
        EndIF
    EndIF
    
    //-------------------------------------------------------------------------------
    //Seta o Retorno do Erro
    self:Set("nStatus",nStatus)    

//-------------------------------------------------------------------------------
//Retorno o Erro
Return(self:Get("nStatus"))

Static Function uSCPCG(aFiles,cDirTmp,cMode,cSource,cTarget,cfLogAppSCP)

    Local cFile
    Local cLogAppSCP

    //-------------------------------------------------------------------------------
    //Obtem o Log de Execucao
    IF .NOT.(Empty(cfLogAppSCP))
        IF File(cfLogAppSCP)
            cLogAppSCP:=MemoRead(cfLogAppSCP)
            ConOut("["+ProcName()+"][LOG]",cfLogAppSCP)
            fErase(cfLogAppSCP)
        EndIF
    EndIF
    
    //-------------------------------------------------------------------------------
    //Verifica se deve Excluir os Arquivos Temporarios
    IF .NOT.(Empty(aFiles))
        aSize(aFiles,0)
        IF (cMode=="P")
            nFiles:=aDir(cSource,@aFiles)
        Else
            nFiles:=aDir(cTarget,@aFiles)
        EndIF   
        //-------------------------------------------------------------------------------
        //Excluindo os Arquivos Temporarios
        For nFile:=1 To nFiles
            cFile:=cDirTmp
            cFile+=aFiles[nFile]
            fErase(cFile)
        Next nFile
        //-------------------------------------------------------------------------------
        //Excluindo o Diretorio Temporario
        IF DirRemove(cDirTmp)
            ConOut("["+ProcName()+"][Diretorio de Trabalho Excluido com Sucesso]["+cDirTmp+"]")
        EndIF
    EndIF
    
    aSize(aFiles,0)

    DEFAULT cLogAppSCP:=""

return(cLogAppSCP)

Static Function LoadMsgs(nStatus)
    Local cMsg
    Local nMsg
    DEFAULT aMsgs:=Array(0)
    IF Empty(aMsgs)
        aAdd(aMsgs,{0,"OK"})
        aAdd(aMsgs,{-1,"Impossivel Criar Diretorio"})
        aAdd(aMsgs,{-2,"Recurso de Transferencia SCP nao Encontrado"})
        aAdd(aMsgs,{-3,"Problema na Execucao do Comando"})
        aAdd(aMsgs,{-4,""})
        aAdd(aMsgs,{-5,""})
        aAdd(aMsgs,{-6,""})
        aAdd(aMsgs,{-7,""})
        aAdd(aMsgs,{-8,""})
        aAdd(aMsgs,{-9,""})
    EndIF
    IF (ValType(nStatus)=="N")
        nMsg:=aScan(aMsgs,{|e|e[1]==nStatus})
        IF (nMsg>0)
            cMsg:=aMsgs[nMsg][2]
        EndIF
    EndIF
    DEFAULT cMsg:=""
Return(cMsg)
