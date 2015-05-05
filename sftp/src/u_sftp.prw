#include "totvs.ch"
#include "shell.ch"

static aMsgs

//------------------------------------------------------------------------------------------------
    /*/
        CLASS:uSFTP
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:29/04/2015
        Descricao:Transferencia de dados segura usando o protocolo SFTP a partir do pscp.exe
        Sintaxe:uSFTP():New()->Objeto do Tipo uSFTP
        
        //------------------------------------------------------------------------------------------------        
        Documentacao de uso de pscp.exe:
        http://tartarus.org/~simon/putty-snapshots/htmldoc/Chapter5.html#pscp-starting
        
        //------------------------------------------------------------------------------------------------        
        Downloads do pscp.exe:
        http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html
        
        //------------------------------------------------------------------------------------------------        
        Obs.: pscp.exe devera ser adicionado como Resource no Projeto do IDE (TDS)
        TODO: Implementar o envio via socket utilizando o Harbour como conector sftp (https://github.com/NaldoDj/PuTTY)
        
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
CLASS uSFTP

    DATA cClassName

    DATA nError

    DATA oParameters

    METHOD New() CONSTRUCTOR
    METHOD FreeObj() /*DESTRUCTOR*/

    METHOD ClassName()

    METHOD Get(cParameter)
    METHOD Set(cParameter,uValue)
    METHOD Execute(cSource,cTarget,cURL,cUSR,cPWD,cMode,lSrv,cPort,lForceClient)

END CLASS

METHOD New() CLASS uSFTP
    self:nError:=0
    IF FindFunction("U_THash")
        self:oParameters:=tHash():New()
    EndIF
    LoadMsgs()
Return(self)

METHOD FreeObj() CLASS uSFTP
    IF (Valtype(self:oParameters)=="O")
        self:oParameters:=self:oParameters:FreeObj()
    EndIF
    self:=FreeObj(self)
Return(self)

METHOD ClassName() CLASS uSFTP
    self:cClassName:="USFTP"
Return(self:cClassName)

METHOD Get(cParameter) CLASS uSFTP
    Local uValue
    IF (Valtype(self:oParameters)=="O")
        uValue:=self:oParameters:Get(cParameter)
    EndIF
Return(uValue)

METHOD Set(cParameter,uValue) CLASS uSFTP
    IF (Valtype(self:oParameters)=="O")
        uValue:=self:oParameters:Set(cParameter,uValue)
    EndIF
Return(self)

METHOD Execute(cSource,cTarget,cURL,cUSR,cPWD,cMode,lSrv,cPort,lForceClient) CLASS uSFTP
    IF (Valtype(self:oParameters)=="O")
        DEFAULT cSource:=self:Get("cSource")
        DEFAULT cTarget:=self:Get("cTarget")
        DEFAULT cURL:=self:Get("cURL")
        DEFAULT cUSR:=self:Get("cUSR")
        DEFAULT cPWD:=self:Get("cPWD")
        DEFAULT cMode:=self:Get("cMode")
        DEFAULT lSrv:=self:Get("lSrv")
        DEFAULT cPort:=self:Get("cPort")
        DEFAULT lForceClient:=self:Get("lForceClient")
    EndIF
    self:nError:=SFTP(@cSource,@cTarget,@cURL,@cUSR,@cPWD,@cMode,@lSrv,@cPort,@lForceClient)
Return(self:nError)

User Function SFTP()
Return(uSFTP():New())

Static Function SFTP(cSource,cTarget,cURL,cUSR,cPWD,cMode,lSrv,cPort,lForceClient)
 
    Local aFiles
    
    Local cAppSFTP:="pscp.exe"

    Local cFile
    Local cDirTmp
    Local cDirSFTP
    Local cSrvPath
    Local cTmpFile
    Local cRootPath
    Local cFullAppSFTP
    Local cCommandLine
    Local cWaitRunPath

    Local lCopyFile
 
    Local nError:=0
    
    Local nFile
    Local nFiles
 
    BEGIN SEQUENCE
    
        DEFAULT cSource:=""
        DEFAULT cTarget:=""
        DEFAULT cURL:=""
        DEFAULT cUSR:=""
        DEFAULT cPWD:=""
        DEFAULT cPort:="22"
        
        //-------------------------------------------------------------------------------
        //cMode=>P:Put;G:Get
        DEFAULT cMode:="P"
        
        DEFAULT lSrv:=.T.
        DEFAULT lForceClient:=.F.
        
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
                        nError:=-1
                        ConOut("["+ProcName()+"]["+LoadMsgs(nError)+"]["+cDirTmp+"]")
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
                            nError:=-1
                            ConOut("["+ProcName()+"]["+LoadMsgs(nError)+"]["+cSrvPath+"]")
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
        //Define o Caminho para o aplicativo de Transferencia SFTP
        IF (lSrv).and.(.NOT.(lForceClient))
            cDirSFTP:="\SFTP\"
            //-------------------------------------------------------------------------------
            //Obtem o RootPath do Protheus
            cRootPath:=AllTrim(GetSrvProfString("ROOTPATH",""))
            IF .NOT.(Right(cRootPath,1)=="\")
                cRootPath+="\"
            EndIF
        Else
            //-------------------------------------------------------------------------------
            //Neste caso, o caminho sera no diretorio Temporario do Client
            cDirSFTP:=GetTempPath()
            IF .NOT.("\"$Right(cDirSFTP,1))
                cDirSFTP+="\"
            EndIF
            cDirSFTP+="SFTP\"
        EndIF
        
        //-------------------------------------------------------------------------------
        //Verifica a existencia do diretorio para Extracao do aplicativo de Transferencia SFTP
        IF .NOT.(lIsDir(cDirSFTP))
            IF .NOT.(MakeDir(cDirSFTP)==0)
                nError:=-1
                ConOut("["+ProcName()+"]["+LoadMsgs(nError)+"]["+cDirSFTP+"]")
                BREAK
            EndIF
        EndIF

        //-------------------------------------------------------------------------------
        //Obtem o Caminho completo do aplicativo de Transferencia SFTP
        cFullAppSFTP:=(cDirSFTP+cAppSFTP)
        
        //-------------------------------------------------------------------------------
        //Verifica a existencia aplicativo de Transferencia SFTP
        IF .NOT.(File(cFullAppSFTP))
            //-------------------------------------------------------------------------------
            //Extrai, do Repositorio de Objetos, o aplicativo de Transferencia SFTP
            //Obs: Pressupoe, para a extracao, que ele foi adicionado como Resource no processo de compilacao
            IF .NOT.(Resource2File(cAppSFTP,cFullAppSFTP))
                nError:=-2
                ConOut("["+ProcName()+"]["+LoadMsgs(nError)+"]["+cFullAppSFTP+"]")
                BREAK
            EndIF
        EndIF
       
        //-------------------------------------------------------------------------------
        //Elabora o Comando para execucao do Aplicativo de Transferencia SFTP
        //-------------------------------------------------------------------------------
        //Exemplo Client:
        //P:pscp.exe -sftp -C -l cUSR -pw cPWD -P cPort C:\tmp\files\*.txt cURL:cTarget
        //G:pscp.exe -sftp -C -l cUSR -pw cPWD -P cPort cURL:cTarget/*.txt C:\tmp\files\ 
        //-------------------------------------------------------------------------------
        //Exemplo Server:
        //P:pscp.exe -sftp -C -l cUSR -pw cPWD -P cPort \tmp\files\*.txt cURL:cTarget
        //G:pscp.exe -sftp -C -l cUSR -pw cPWD -P cPort cURL:cTarget/*.txt \tmp\files\ 
        //-------------------------------------------------------------------------------
        cCommandLine:=""
        IF (lSrv).and.(.NOT.(lForceClient))
            cCommandLine+=cRootPath
            IF (Left(cDirSFTP,1)=="\")
                cCommandLine+=SubStr(cDirSFTP,2)
            Else
                cCommandLine+=cDirSFTP
            EndIF
        Else
            cCommandLine+=cDirSFTP
        EndIF
        cCommandLine+=cAppSFTP
        cCommandLine+=" "
        //-------------------------------------------------------------------------------
        //force use of SFTP protocol
        cCommandLine+="-sftp"
        cCommandLine+=" "
        //-------------------------------------------------------------------------------
        //enable compression
        cCommandLine+="-C"
        cCommandLine+=" "
        //-------------------------------------------------------------------------------
        //connect with specified username
        cCommandLine+="-l" 
        cCommandLine+=" "
        cCommandLine+=cUSR
        //-------------------------------------------------------------------------------
        //login with specified password
        cCommandLine+=" "
        cCommandLine+="-pw"
        cCommandLine+=" "
        cCommandLine+=cPWD
        cCommandLine+=" "
        //-------------------------------------------------------------------------------
        //connect to specified port
        cCommandLine+="-P"
        cCommandLine+=" "
        cCommandLine+=cPort
        cCommandLine+=" "
        //-------------------------------------------------------------------------------
        //Verifica cMode
        IF (cMode=="P")
            //-------------------------------------------------------------------------------
            //Ajusta cTarget
            cTarget:=StrTran(cTarget,"\","/")
            IF .NOT.(Left(cTarget,1)=="/")
                cTarget:="/"+cTarget
            EndIF
            IF .NOT.(Right(cTarget,1)=="/")
                cTarget:="/"
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
                nError:=-3
                ConOut("["+ProcName()+"]["+LoadMsgs(nError)+"]["+cCommandLine+"][Path]["+cRootPath+"]")
            EndIF
            nError:=0
        Else
            //-------------------------------------------------------------------------------
            //Executa o Comando de Transferencia no Client
            //Onde:
            //cCommandLineLine:Instrucao a ser executada
            //nMode:Indica o modo de interface a ser criado para a execucao do programa
            //Read more:http://tdn.totvs.com/display/tec/WaitRun
            //WaitRun(cCommandLineLine,nMode):nSuccess
            nError:=WaitRun(cCommandLine,SW_HIDE)
            IF .NOT.(nError==0)
                nError:=-3
                ConOut("["+ProcName()+"]["+LoadMsgs(nError)+"]["+cCommandLine+"]")
                BREAK
            EndIF
            nError:=0
        EndIF

        //-------------------------------------------------------------------------------
        //Verificacao final quando lForceClient
        IF (lForceClient)
            IF (cMode=="G")
                //-------------------------------------------------------------------------------
                //Copia os arquivos do Client para Srv
                IF .NOT.(Right(cTarget,1)=="\")
                    cTarget+="\"
                EndIF
                cTarget+="*.*"
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
        EndIF
    
    END SEQUENCE

Return(nError)

Static Function LoadMsgs(nError)
    Local cMsg
    Local nMsg
    DEFAULT aMsgs:=Array(0)
    IF Empty(aMsgs)
        aAdd(aMsgs,{0,"OK"})
        aAdd(aMsgs,{-1,"Impossivel Criar Diretorio"})
        aAdd(aMsgs,{-2,"Recurso de Transferencia SFTP nao Encontrado"})
        aAdd(aMsgs,{-3,"Problema na Execucao do Comando"})
        aAdd(aMsgs,{-4,""})
        aAdd(aMsgs,{-5,""})
        aAdd(aMsgs,{-6,""})
        aAdd(aMsgs,{-7,""})
        aAdd(aMsgs,{-8,""})
        aAdd(aMsgs,{-9,""})
    EndIF
    IF (ValType(nError)=="N")
        nMsg:=aScan(aMsgs,{|e|e[1]==nError})
        IF (nMsg>0)
            cMsg:=aMsgs[nMsg][2]
        EndIF
    EndIF
    DEFAULT cMsg:=""
Return(cMsg)
