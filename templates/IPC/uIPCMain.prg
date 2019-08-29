#DEFINE N_9REPLICATE  0100
#DEFINE N_IPCSLEEP      0500
#DEFINE N_IPCTHREADS     5
#DEFINE N_GLBLOCK         0

Static __c9Replicate := Replicate("9",N_9REPLICATE)
Static __c0Replicate := Replicate("0",N_9REPLICATE)

/*
    Progama:    uIPCMain.prg
    Funcao:     U_IPCMain
    Autor:      Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:       21/11/2013
    Descricao:  Exemplo de uso das funcoes IPCGo e IPCWaitEx
*/
Function U_IPCMain()    
    Local aParameters := Array(N_9REPLICATE)
    Local nThreads      := N_IPCTHREADS
    Local cGlbValue
    aFill(aParameters,9)
    PutGlbValue("U_IPCExec",__c9Replicate)
    StartTIPC(nThreads)
    While ( .NOT.( KillApp() ) .and. .NOT.( AllZeros() ) )
        IF ( N_GLBLOCK == 1 )
            While .NOT.( GlbLock() )
                Sleep(N_IPCSLEEP)
            End While
        EndIF
        cGlbValue := GetGlbValue("U_IPCExec")
        IF ( N_GLBLOCK == 1 )
            GlbUnLock()
        EndIF    
        ConOut(cGlbValue)
        aEval(aParameters,{|n,y|aParameters[y]:=Val(SubStr(cGlbValue,y,1))})
        IF ( IPCGo("U_IPCExec",@aParameters) )
            Sleep(N_IPCSLEEP)
            IF ( AllZeros() )
                EXIT 
            EndIF    
        EndIF
        Sleep(N_IPCSLEEP)
    End While
    ConOut("Final")
    ConOut("ThreadID: "+Str(ThreadID()))
    IF ( N_GLBLOCK == 1 )
        While .NOT.( GlbLock() )
            Sleep(N_IPCSLEEP)
        End While
    EndIF    
    cGlbValue := GetGlbValue("U_IPCExec")
    IF ( N_GLBLOCK == 1 )
        GlbUnLock()
    EndIF    
    aEval(aParameters,{|n,y|aParameters[y]:=Val(SubStr(cGlbValue,y,1))})
    ConOut(cGlbValue)
Return( NIL )

/*
    Progama:    uIPCMain.prg
    Funcao:     StartTIPC
    Autor:      Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:       21/11/2013
    Descricao:  Carrega as Threads que ficarao aguardando alguma requisocao via IPCGO
*/
Static Function StartTIPC(nThreads)
    Local nTh
    For nTh := 1 To nThreads
        StartJob("U_IPCExec",GetEnvServer(),.F.)
    Next nTh
Return( NIL )

/*
    Progama:    uIPCMain.prg
    Funcao:     U_IPCExec
    Autor:      Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:       21/11/2013
    Descricao:  Utiliza IPCWaitEx que fica escutando e repondendo as requisicoes de IPCGo
*/
Function U_IPCExec()
    Local aParameters   := Array(0)
    Local bError         := ErrorBlock( {|e| ErrorIPC(e) } )
    Local cGlbValue
    Local nBL
    Local nEL
    BEGIN SEQUENCE
        While ( .NOT.( KillApp() ) .and. .NOT.( AllZeros() ) )
            IF IPCWaitEx("U_IPCExec",N_IPCSLEEP,@aParameters)
                IF .NOT.( AllZeros() )
                    ConOut("ThreadID: "+Str(ThreadID()))
                    nEL := Len(aParameters)
                    IF .NOT.( AllZeros() )
                        For nBL := 1 To nEL
                            aParameters[nBL]--
                        Next nBL
                        cGlbValue := ""
                        aEval(aParameters,{|n|cGlbValue+=AllTrim(Str(n))})
                        IF ( N_GLBLOCK == 1 )
                            While .NOT.( GlbLock() )
                                Sleep(N_IPCSLEEP)
                            End While
                        EndIF    
                        PutGlbValue("U_IPCExec",cGlbValue)
                        IF ( N_GLBLOCK == 1 )
                            GlbUnLock()
                        EndIF    
                    EndIF
                EndIF        
            EndIF
        End While
    END SEQUENCE
    ErrorBlock(bError)
Return(NIL)

/*
    Progama:    uIPCMain.prg
    Funcao:     AllZeros
    Autor:      Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:       21/11/2013
    Descricao:  Utiliza variavel Global para o Controle de Processamento
*/
Static Function AllZeros()
    Local cGlbValue
    IF ( N_GLBLOCK == 1 )
        While .NOT.( GlbLock() )
            Sleep(N_IPCSLEEP)
        End While
    EndIF
    cGlbValue := GetGlbValue("U_IPCExec")
    IF ( N_GLBLOCK == 1 )
        GlbUnLock()
    EndIF    
Return((cGlbValue==__c0Replicate))

/*
    Progama:    uIPCMain.prg
    Funcao:     ErrorIPC
    Autor:      Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:       21/11/2013
    Descricao:  Tratamento de erro customizado
*/
Static Function ErrorIPC(e)    
    ConOut(e:Description)
    BREAK
Return( NIL )
