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
        Obs.:pscp.exe devera ser adicionado como Resource no Projeto do IDE (TDS)
        TODO:(1) Implementar o envio via socket utilizando o Harbour como conector sftp (https://github.com/NaldoDj/PuTTY)
        
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
    DATA cClassName
    METHOD New() CONSTRUCTOR
    METHOD FreeObj() /*DESTRUCTOR*/
    METHOD ClassName()
    METHOD SetParameter(cParameter,cValue)
    METHOD Run()
END CLASS

User Function SCP()
Return(uSCP():New())

METHOD New() CLASS uSCP
    _Super:New()
    self:ClassName()
    self:Set("nStatus",0)
    self:Set("ltLogReport",self:Get("lLog",.T.))
    IF (self:Get("ltLogReport",.F.))
        self:Set("otLogReport",tLogReport():New())
        self:Get("otLogReport"):AddGroup("SCP Error")
        self:Get("otLogReport"):AddGroup("SCP Warning")
        self:Get("otLogReport"):AddGroup("SCP Process")
        self:Get("otLogReport"):AddGroup("SCP Transfer")
        self:Get("otLogReport"):AddGroup("SCP Command")
    EndIF
    LoadMsgs()
    self:Set("aMsgs",aClone(aMsgs))
    self:AddNewSession("aParameters")
Return(self)

METHOD FreeObj() CLASS uSCP
    Local aSessions:=self:GetAllSessions()
    aEval(aSessions,{|c|self:Del(c)})
    aSize(aSessions,0)
    IF (self:Get("ltLogReport",.F.))       
        IF (ValType(self:Get("otLogReport"))=="O")
            self:Set("otLogReport",self:Get("otLogReport"):FreeObj())
        EndIF
    EndIF
    self:=FreeObj(self)
Return(self)

METHOD ClassName() CLASS uSCP
    self:cClassName:=(_Super:ClassName()+"_"+GetClassName(self))
Return(self:cClassName)

METHOD SetParameter(cParameter,cValue) CLASS uSCP       
Return(self:AddNewProperty("aParameters",cParameter,cValue))

METHOD Run() CLASS uSCP
 
    Local aFiles
    Local aParameters
    
    Local cAppSCP:=self:Get("cAppSCP","pscp.exe")
    Local cBatSCP:=self:Get("cBatSCP","pscp.bat")

    Local cURL:=self:Get("cURL","")
    Local cMode:=self:Get("cMode","P")
    Local cSource:=self:Get("cSource","")
    Local cTarget:=self:Get("cTarget","")
   
    Local cMsg
    Local cFile
    Local cDirSCP
    Local cDirTmp
    Local cSrvPath
    Local cSCPPath
    Local cTmpFile
    Local cRootPath
    Local cfLogAppSCP
    Local ctLogAppSCP
    Local cFullAppSCP
    Local cFullBatSCP

    Local cKParameter
    Local cVParameter

    Local cCommandLine

    Local lCopyFile

    Local lSrv:=self:Get("lSrv",.T.)
    Local ltLogReport:=self:Get("ltLogReport",.F.)
    Local lForceClient:=self:Get("lForceClient",.T.)

    Local nD
    Local nJ
    
    Local nFile
    Local nFiles

    Local nStatus:=0

    Local nSWMode:=self:Get("nSWMode",SW_MAXIMIZE)
    
    Local oufT
    
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
                        cMsg:="["+self:cClassName+"]["+LoadMsgs(nStatus)+"]["+cDirTmp+"]"
                        IF (ltLogReport)
                            self:Get("otLogReport"):AddDetail("SCP Error",cMsg)
                        EndIF
                        ConOut(cMsg)
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
                            cMsg:="["+self:cClassName+"][Impossivel copiar arquivo][Origem]["+cFile+"][Destino]["+cTmpFile+"]"
                            IF (ltLogReport)
                                self:Get("otLogReport"):AddDetail("SCP Warning",cMsg)
                            EndIF
                        Else
                            cMsg:="["+self:cClassName+"][Arquivo copiado com sucesso][Origem]["+cFile+"][Destino]["+cTmpFile+"]"
                            IF (ltLogReport)
                                self:Get("otLogReport"):AddDetail("SCP Process",cMsg)
                            EndIF
                        EndIF
                        ConOut(cMsg)
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
                            cMsg:="["+self:cClassName+"]["+LoadMsgs(nStatus)+"]["+cSrvPath+"]"
                            IF (ltLogReport)
                                self:Get("otLogReport"):AddDetail("SCP Error",cMsg)
                            EndIF
                            ConOut(cMsg)
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
                cMsg:="["+self:cClassName+"]["+LoadMsgs(nStatus)+"]["+cDirSCP+"]"
                IF (ltLogReport)
                    self:Get("otLogReport"):AddDetail("SCP Error",cMsg)
                EndIF
                ConOut(cMsg)
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
            //Obs:Pressupoe, para a extracao, que ele foi adicionado como Resource no processo de compilacao
            IF .NOT.(Resource2File(cAppSCP,cFullAppSCP))
                nStatus:=-2
                cMsg:="["+self:cClassName+"]["+LoadMsgs(nStatus)+"]["+cFullAppSCP+"]"
                IF (ltLogReport)
                    self:Get("otLogReport"):AddDetail("SCP Error",cMsg)
                EndIF
                ConOut(cMsg)
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
        IF (ltLogReport)
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
            cCommandLine:=self:Get("cModeCon","mode con:lines=45 cols=165")+CRLF+cCommandLine
        EndIF   

        //-------------------------------------------------------------------------------
        //Grava o Comando no Batch File
        MemoWrite(cFullBatSCP,cCommandLine)

        //------------------------------------------------------------------------------
        //Adiciona o Command ao Log
        IF (ltLogReport)
            self:Get("otLogReport"):AddDetail("SCP Command",cCommandLine)
        EndIF   
        
        //-------------------------------------------------------------------------------
        //Redefine cCommandLine
        cCommandLine:=cFullBatSCP

        //------------------------------------------------------------------------------
        //Adiciona o Command ao Log
        IF (ltLogReport)
            self:Get("otLogReport"):AddDetail("SCP Command",cCommandLine)
        EndIF   
        
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
            cWaitRunPath+=IF(Left(cDirSCP,1)=="\",SubStr(cDirSCP,2),cDirSCP)
            //------------------------------------------------------------------------------
            //Adiciona o cWaitRunPath ao Log
            IF (ltLogReport)
                self:Get("otLogReport"):AddGroup("WaitRunPath")
                self:Get("otLogReport"):AddDetail("WaitRunPath",cWaitRunPath)
            EndIF        
            //------------------------------------------------------------------------------
            //Executa o Comando
            IF .NOT.(WaitRunSrv(cWaitRunPath+cCommandLine,.T.,cWaitRunPath))
                nStatus:=-3
                cMsg:="["+self:cClassName+"]["+LoadMsgs(nStatus)+"]["+cCommandLine+"][Path]["+cRootPath+"]"
                IF (ltLogReport)
                    self:Get("otLogReport"):AddDetail("SCP Error",cMsg)
                EndIF
                ConOut(cMsg)
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
                cMsg:="["+self:cClassName+"]["+LoadMsgs(nStatus)+"]["+cCommandLine+"]"
                IF (ltLogReport)
                    self:Get("otLogReport"):AddDetail("SCP Error",cMsg)
                EndIF
                ConOut(cMsg)
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
                        cMsg:="["+self:cClassName+"][Impossivel copiar arquivo][Origem]["+cFile+"][Destino]["+cTmpFile+"]"
                        IF (ltLogReport)
                            self:Get("otLogReport"):AddDetail("SCP Warning",cMsg)
                        EndIF
                        ConOut(cMsg)
                    Else
                        cMsg:="["+self:cClassName+"][Arquivo copiado com sucesso][Origem]["+cFile+"][Destino]["+cTmpFile+"]"
                        IF (ltLogReport)
                            self:Get("otLogReport"):AddDetail("SCP Process",cMsg)
                        EndIF
                    EndIF
                Next nFile
            EndIF

        EndIF
    
    END SEQUENCE

    //-------------------------------------------------------------------------------
    //Obtem o Log de Execucao
    IF .NOT.(Empty(cfLogAppSCP))
        IF File(cfLogAppSCP)
            oufT:=ufT():New()
            oufT:ft_fUse(cfLogAppSCP)
            While .NOT.(oufT:ft_fEof())
                cMsg:="["+self:cClassName+"][SCP Transfer]["+oufT:ft_fReadLn()+"]"
                IF (ltLogReport)
                    self:Get("otLogReport"):AddDetail("SCP Transfer",cMsg)
                EndIF 
                ConOut(cMsg)
                oufT:ft_fSkip()
            End While
            oufT:ft_fUse()
            oufT:=oufT:FreeObj()
            fErase(cfLogAppSCP)
        EndIF
    EndIF
    
    IF (lForceClient)
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
                cMsg:="["+self:cClassName+"][Diretorio de trabalho excluido com sucesso]["+cDirTmp+"]"
                IF (ltLogReport)
                    self:Get("otLogReport"):AddDetail("SCP Process",cMsg)
                EndIF
            Else
                cMsg:="["+self:cClassName+"][Problema na exclusao do diretorio de trabalho]["+cDirTmp+"]"
                IF (ltLogReport)
                    self:Get("otLogReport"):AddDetail("SCP Warning",cMsg)
                EndIF
            EndIF
            ConOut(cMsg)
        EndIF
    EndIF    
    
    //-------------------------------------------------------------------------------
    //Seta o Retorno do Erro
    self:Set("nStatus",nStatus)    

//-------------------------------------------------------------------------------
//Retorno o Erro
Return(self:Get("nStatus"))

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
