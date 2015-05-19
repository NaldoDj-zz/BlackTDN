#include "totvs.ch"
#include "shell.ch"
#include "tryexception.ch"
//------------------------------------------------------------------------------------------------
    /*/
        Programa:u_scpsample.prw
        Funcao:u_scpPut()
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:29/04/2015
        Descricao:Transferencia de dados segura (PUT) usando o protocolo SFTP a partir do pscp.exe
        Sintaxe:u_scpPut()
    /*/
//------------------------------------------------------------------------------------------------
User Function SCPPut()
    Local ouSCP:=uSCP():New()
    //------------------------------------------------------------------------------------------------
    //Define os parametros do Metodo Run
    ouSCP:Set("cAppSCP","pscp.exe")
    ouSCP:Set("cBatSCP","pscp.bat")
    ouSCP:Set("cSource","\expordic\*.*")
    ouSCP:Set("cTarget","/Target/")
    ouSCP:Set("cURL","url")
    ouSCP:Set("cMode","P")
    ouSCP:Set("lSrv",.T.)    
    ouSCP:Set("lForceClient",.T.)
    //------------------------------------------------------------------------------------------------
    //Define os parametros para o App de Transferencia
    ouSCP:SetParameter("user","-l USER")
    ouSCP:SetParameter("passw","-pw P@ssWord")
    ouSCP:SetParameter("port","-P 22")
    ouSCP:SetParameter("show verbose messages","-v")
    ouSCP:SetParameter("enable compression","-C")    
    ouSCP:SetParameter("enable compression","-C")
    ouSCP:SetParameter("force use of SFTP protocol","-sftp")
    ouSCP:SetParameter("enable use of Pageant","-agent")    
    //------------------------------------------------------------------------------------------------
    //Executa o App de Transferencia
    ouSCP:Run()
    //------------------------------------------------------------------------------------------------
    //Verifica o Retorno do App de Transferencia
    ConOut(ouSCP:Get("nError",0))
    //------------------------------------------------------------------------------------------------
    //Verifica as Mensagens de Erro
    aEval(ouSCP:Get("aMsgs",Array(0)),{|aM|ConOut(aM[1],aM[2])})
    //------------------------------------------------------------------------------------------------
    //Verifica o Log de Processamento
    IF (ouSCP:Get("ltLogReport",.F.))
       TRY EXCEPTION
            ouSCP:Get("otLogReport"):PrintDialog()
       CATCH EXCEPTION
       END EXCEPTION
    EndIF
    //------------------------------------------------------------------------------------------------
    //Libera o Objeto da Memoria
    ouSCP:=ouSCP:FreeObj()
Return(NIL)

//------------------------------------------------------------------------------------------------
    /*/
        Programa:u_scpsample.prw
        Funcao:u_scpGet()
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:29/04/2015
        Descricao:Transferencia de dados segura (GET) usando o protocolo SFTP a partir do pscp.exe
        Sintaxe:u_scpPut()
    /*/
//------------------------------------------------------------------------------------------------
User Function SCPGet()
    Local ouSCP:=uSCP():New()
    //------------------------------------------------------------------------------------------------
    //Define os parametros do Metodo Run
    ouSCP:Set("cAppSCP","pscp.exe")
    ouSCP:Set("cBatSCP","pscp.bat")
    ouSCP:Set("cSource","/Source/*.*")
    ouSCP:Set("cTarget","\expordic\")
    ouSCP:Set("cURL","url")
    ouSCP:Set("cMode","G")
    ouSCP:Set("lSrv",.T.)    
    ouSCP:Set("lForceClient",.T.)
    //------------------------------------------------------------------------------------------------
    //Define os parametros para o App de Transferencia
    ouSCP:SetParameter("user","-l USER")
    ouSCP:SetParameter("passw","-pw P@ssWord")
    ouSCP:SetParameter("port","-P 22")
    ouSCP:SetParameter("show verbose messages","-v")
    ouSCP:SetParameter("enable compression","-C")    
    ouSCP:SetParameter("enable compression","-C")
    ouSCP:SetParameter("force use of SFTP protocol","-sftp")
    ouSCP:SetParameter("enable use of Pageant","-agent")    
    //------------------------------------------------------------------------------------------------
    //Executa o App de Transferencia
    ouSCP:Run()
    //------------------------------------------------------------------------------------------------
    //Verifica o Retorno do App de Transferencia
    ConOut(ouSCP:Get("nStatus",0))
    //------------------------------------------------------------------------------------------------
    //Verifica as Mensagens de Erro
    aEval(ouSCP:Get("aMsgs",Array(0)),{|aM|ConOut(aM[1],aM[2])})
    //------------------------------------------------------------------------------------------------
    //Verifica o Log de Processamento
    IF (ouSCP:Get("ltLogReport",.F.))
       TRY EXCEPTION
            ouSCP:Get("otLogReport"):PrintDialog()
       CATCH EXCEPTION
        END EXCEPTION
    EndIF
    //------------------------------------------------------------------------------------------------
    //Libera o Objeto da Memoria
    ouSCP:=ouSCP:FreeObj()
Return(NIL)
