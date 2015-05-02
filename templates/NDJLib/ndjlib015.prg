#include "ndj.ch"

Static oNDJLIB015

CLASS NDJLIB015

    METHOD NEW() CONSTRUCTOR
    
    METHOD PackSX(cAlias,cFileSX,nAttempts,nSleep,cRddName)
    METHOD LockSX(cAlias,cFileSX,nAttempts,nSleep,cRddName)
    METHOD UnLockSX(cAlias,cFileSX,nAttempts,nSleep,cRddName)
    METHOD PackSXP(cFileSXP,nAttempts,nSleep,cRddName)
    
ENDCLASS

User Function DJLIB015()
    DEFAULT oNDJLIB015:=NDJLIB015():New()
Return(oNDJLIB015)

METHOD NEW() CLASS NDJLIB015
RETURN(self)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:PackSX
        Autor:Marinaldo de Jesus
        Data:08/11/2005
        Descricao:Tenta efetuar a Limpeza dos Registros Deletados do SX
        Sintaxe:<Vide Parametros Formais>
    /*/
//------------------------------------------------------------------------------------------------
METHOD PackSX(cAlias,cFileSX,nAttempts,nSleep,cRddName) CLASS NDJLIB015
RETURN(PackSX(@cAlias,@cFileSX,@nAttempts,@nSleep,@cRddName))
Static Function PackSX(cAlias,cFileSX,nAttempts,nSleep,cRddName)

    Local lLocked:=.F.
    Local lUnLocked:=.F.
    Local lSxPackOk:=.T.
    
    IF (Select(cAlias)>0)
        DEFAULT cRddName:=(cAlias)->(RddName())
    EndIF
    
    IF (lLocked:=LockSX(@cAlias,@cFileSX,@nAttempts,@nSleep,@cRddName))
        (cAlias)->(StaticCall(NDJLIB001,dbPack,cAlias,.F.,.F.,.F.,.F.,@cRddName,@cFileSX))
    EndIF
    
    lUnLocked:=UnLockSX(@cAlias,@cFileSX,@nAttempts,@nSleep,@cRddName)
    lSxPackOk:=(lLocked .and. lUnLocked)

Return(lSxPackOk)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:LockSX
        Autor:Marinaldo de Jesus
        Data:08/11/2005
        Descricao:Tenta efetuar a Lock no SX
        Sintaxe:<Vide Parametros Formais>
    /*/
//------------------------------------------------------------------------------------------------
METHOD LockSX(cAlias,cFileSX,nAttempts,nSleep,cRddName) CLASS NDJLIB015
RETURN(LockSX(@cAlias,@cFileSX,@nAttempts,@nSleep,@cRddName))
Static Function LockSX(cAlias,cFileSX,nAttempts,nSleep,cRddName)

    Local bLockFile:={||dbUseArea(.T.,cRddName,cFileSX,cAlias,.F.,.F.),(lLocked:=(Select(cAlias)>0))}
    
    Local lLocked:=.F.
    
    Local nAttempt:=0
    
    IF (Select(cAlias)>0)
        DEFAULT cRddName:=(cAlias)->(RddName())
        (cAlias)->(dbCloseArea())
    EndIF    
    
    DEFAULT nAttempts:=10
    DEFAULT nSleep:=3
    
    While !(Eval(bLockFile))
        IF ((++nAttempt)>nAttempts)
            Exit
        EndIF
        Sleep(nSleep)
    End While

Return(lLocked)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:UnLockSX
        Autor:Marinaldo de Jesus
        Data:08/11/2005
        Descricao:Tenta Liberar Lock no SX
        Sintaxe:<Vide Parametros Formais>
    /*/
//------------------------------------------------------------------------------------------------
METHOD UnLockSX(cAlias,cFileSX,nAttempts,nSleep,cRddName) CLASS NDJLIB015
RETURN(UnLockSX(@cAlias,@cFileSX,@nAttempts,@nSleep,@cRddName))
Static Function UnLockSX(cAlias,cFileSX,nAttempts,nSleep,cRddName)

    Local bUnLockFile:={||dbUseArea(.T.,cRddName,cFileSX,cAlias,.T.,.F.),(lUnLocked:=(Select(cAlias)>0))}
    
    Local lUnLocked:=.F.
    
    Local nAttempt:=0
    
    IF (Select(cAlias)>0)
        DEFAULT cRddName:=(cAlias)->(RddName())
        (cAlias)->(dbCloseArea())
    EndIF    
    
    DEFAULT nAttempts:=3
    DEFAULT nSleep:=5
    
    While !(Eval(bUnLockFile))
        IF ((++nAttempt)>nAttempts)
            Exit
        EndIF
        Sleep(nSleep)
    End While

Return(lUnLocked)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:PackSXP
        Autor:Marinaldo de Jesus
        Data:08/11/2005
        Descricao:Tenta efetuar a Limpeza dos Registros Deletados do SXP
        Sintaxe:<Vide Parametros Formais>
    /*/
//------------------------------------------------------------------------------------------------
METHOD PackSXP(cFileSXP,nAttempts,nSleep,cRddName) CLASS NDJLIB015
RETURN(PackSXP(@cFileSXP,@nAttempts,@nSleep,@cRddName))
Static Function PackSXP(cFileSXP,nAttempts,nSleep,cRddName)
    DEFAULT cRddName:=__LocalDriver
Return(PackSX("SXP",@cFileSXP,@nAttempts,@nSleep,cRddName))
