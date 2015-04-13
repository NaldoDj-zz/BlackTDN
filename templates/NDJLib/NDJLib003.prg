#include "totvs.ch"
#include "tryexception.ch"

Static __aUseCode:=Array(0)
Static __nUseCode:=0

Static __aFreeLocks:=Array(0)
Static __nFreeLocks:=0

Static __aSetFreeLock:=Array(0)
Static __nSetFreeLock:=0

Static __aAliasLock:=Array(0)
Static __nAliasLock:=0

Static oNDJLIB003

CLASS NDJLIB003

    METHOD NEW() CONSTRUCTOR
    
    METHOD UseCode(cCodeIUse)
    METHOD ReleaseCode(cCodeRelease)
    METHOD FreeAllCodes()
    METHOD UnLockAll()
    METHOD IFreeLocks(cAlias,lForce)
    METHOD _FreeLocks(aFreeLocks)
    METHOD FreeLocks(aFreeLocks)
    METHOD SetFreeLock(cAlias,aRecnos,aKeys)
    METHOD GetFreeLock(cAlias)
    METHOD LockSoft(cAlias,aAliasLock)
    METHOD AliasLock(cAlias)
    METHOD AliasUnLock(aAliasLock)
    
END CLASS

User Function DJLIB003()
    DEFAULT oNDJLIB003:=NDJLIB003():New()
Return(oNDJLIB003)

METHOD NEW() CLASS NDJLIB003
RETURN(self)

/*/
    Funcao:UseCode()
    Autor:Marinaldo de Jesus
    Data:20/11/2010
    Descricao:Lock by Name
    Sintaxe:StaticCall(NDJLIB003,UseCode,cCodeIUse)
/*/
METHOD UseCode(cCodeIUse) CLASS NDJLIB003
RETURN(UseCode(@cCodeIUse))
Static Function UseCode(cCodeIUse)

    Local cUserID

    Local lUsed:=.F.
    
    Local nUsed
    
    Local oException

    TRYEXCEPTION

        cCodeIUse:=AllTrim(cCodeIUse)
        
        nUsed:=aScan(__aUseCode,{|cCode|(cCode==cCodeIUse)})
        
        IF (lUsed:=(nUsed>0))
            BREAK
        EndIF

        lUsed:=LockByName(cCodeIUse)
        IF .NOT.(lUsed)
            BREAK
        EndIF

        aAdd(__aUseCode,cCodeIUse)
        ++__nUseCode

        cUserID:=StaticCall(NDJLIB001,RetCodUsr)

        StaticCall(NDJLIB013,PutSemaphore,cCodeIUse,cCodeIUse)
        StaticCall(NDJLIB013,PutSemaphore,cCodeIUse,__cCRLF)
        StaticCall(NDJLIB013,PutSemaphore,cCodeIUse,"Usuário:"+ cUserID)
        StaticCall(NDJLIB013,PutSemaphore,cCodeIUse,__cCRLF)
        StaticCall(NDJLIB013,PutSemaphore,cCodeIUse,"Nome:"+ StaticCall(NDJLIB014,UsrRetName,cUserID))
        StaticCall(NDJLIB013,PutSemaphore,cCodeIUse,__cCRLF)
        StaticCall(NDJLIB013,PutSemaphore,cCodeIUse,"Nome Completo:"+ StaticCall(NDJLIB014,UsrFullName,cUserID))
        StaticCall(NDJLIB013,PutSemaphore,cCodeIUse,__cCRLF)
        StaticCall(NDJLIB013,PutSemaphore,"Computador:"+ GetComputerName())
        StaticCall(NDJLIB013,PutSemaphore,cCodeIUse,__cCRLF)
        StaticCall(NDJLIB013,PutSemaphore,cCodeIUse,"Client IP:"+ GetClientIp())
        StaticCall(NDJLIB013,PutSemaphore,cCodeIUse,__cCRLF)
        StaticCall(NDJLIB013,PutSemaphore,cCodeIUse,"Thread Id:"+ AllTrim(Str(ThreadId(),0)))
        StaticCall(NDJLIB013,PutSemaphore,cCodeIUse,__cCRLF)

    CATCHEXCEPTION USING oException

        IF (ValType(oException)=="O")
            lUsed:=.F.
        EndIF    

    ENDEXCEPTION

Return (lUsed)

/*/
    Funcao:ReleaseCode()
    Autor:Marinaldo de Jesus
    Data:20/11/2010
    Descricao:UnLock by Name
    Sintaxe:StaticCall(NDJLIB003,ReleaseCode,cCodeRelease)
/*/
METHOD ReleaseCode(cCodeRelease) CLASS NDJLIB003
RETURN(ReleaseCode(@cCodeRelease))
Static Function ReleaseCode(cCodeRelease)

    Local cFSemaphore
    
    Local lRelease:=.F.
    
    Local nUsed
    
    Local oException

    TRYEXCEPTION

        cCodeRelease:=AllTrim(cCodeRelease)
        nUsed:=aScan(__aUseCode,{|cCode|(cCode==cCodeRelease)})

        IF (lRelease:=.NOT.(nUsed>0))
            BREAK
        EndIF

        lRelease:=UnlockByName(cCodeRelease)
        IF .NOT.(lRelease)
            BREAK
        EndIF

        aDel(__aUseCode,nUsed)
        aSize(__aUseCode,(--__nUseCode))

        cFSemaphore:=GetPathSemaforo()
        cFSemaphore+=StaticCall(APLIB050,PrepareKey, cCodeRelease)
        cFSemaphore+=".lck"
        cFSemaphore:=Lower(cFSemaphore)
        IF File(cFSemaphore)
            fErase(cFSemaphore)
        EndIF

        StaticCall(NDJLIB013,RmvSemaphore,cCodeRelease)

    CATCHEXCEPTION USING oException

        IF (ValType(oException)=="O")
            lRelease:=.F.
        EndIF    

    ENDEXCEPTION

Return(lRelease)

/*/
    Funcao:FreeAllCodes()
    Autor:Marinaldo de Jesus
    Data:20/11/2010
    Descricao:UnLock All by Name
    Sintaxe:StaticCall(NDJLIB003,FreeAllCodes)
/*/
METHOD FreeAllCodes() CLASS NDJLIB003
RETURN(FreeAllCodes())
Static Function FreeAllCodes()

    Local aCode:=aClone(__aUseCode)
    Local cCode

    Local lReleased:=.T.

    Local nCode
    Local nCodes:=__nUseCode

    For nCode:=1 To nCodes
        cCode:=aCode[nCode]
        lReleased:=ReleaseCode(cCode)
        IF .NOT.(lReleased)
            Exit
        EndIF
    Next nCode

Return(lReleased)

/*/
    Funcao:UnLockAll()
    Autor:Marinaldo de Jesus
    Data:09/08/2011
    Descricao:Commit e UnLockAll
    Sintaxe:StaticCall(NDJLIB003,UnLockAll)
/*/
METHOD UnLockAll() CLASS NDJLIB003
RETURN(UnLockAll())
Static Function UnLockAll()

    Local cAlias:=Alias()

    IF (;
            .NOT.(Empty(cAlias));
            .and.;
            (Select(cAlias)>0);
        )
        (cAlias)->(MsUnLock())
        (cAlias)->(MsUnLockAll())
        IF .NOT.(InTransact())
            (cAlias)->(dbUnLockAll())
        EndIF    
        FreeAllCodes()
    EndIF    

Return(NIL)

/*/
    Funcao:IFreeLocks
    Autor:Marinaldo de Jesus
    Data:09/08/2011
    Descricao:Libera o Lock
    Sintaxe:StaticCall(NDJLIB003,IFreeLocks,cAlias,lForce)
/*/
METHOD IFreeLocks(cAlias,lForce) CLASS NDJLIB003
RETURN(IFreeLocks(@cAlias,@lForce))
Static Function IFreeLocks(cAlias,lForce)

    Local lFreeLocks:=.F.
    
    Local nAT

    DEFAULT cAlias:=Alias()
    DEFAULT lForce:=.F.

    cAlias:=Upper(AllTrim(cAlias))
    nAT:=aScan(__aFreeLocks,{|aAliasFree|(aAliasFree[1]==cAlias)})

    IF (nAT==0)
        IF .NOT.(lForce)
            aAdd(__aFreeLocks,{cAlias,.F.})
            ++__nFreeLocks
        Else
            lFreeLocks:=.T.
        EndIF    
    Else
        IF (lForce)
            lFreeLocks:=.T.
        Else
            lFreeLocks:=__aFreeLocks[nAT][2]
        EndIF    
        IF .NOT.(lFreeLocks)
            __aFreeLocks[nAT][2]:=.T.
        Else
            aDel(__aFreeLocks,nAT)
            aSize(__aFreeLocks,(--__nFreeLocks))
        EndIF
    EndIF

Return(lFreeLocks)

/*/
    Funcao:_FreeLocks
    Autor:Marinaldo de Jesus
    Data:22/12/2010
    Uso:Liberar Multiplos Locks
    Sintaxe:StaticCall(NDJLIB003,_FreeLocks,aFreeLocks)
/*/
METHOD _FreeLocks(aFreeLocks) CLASS NDJLIB003
RETURN(_FreeLocks(@aFreeLocks))
Static Function _FreeLocks(aFreeLocks)

    Local nLoop
    Local nLoops

    Local oException

    TRYEXCEPTION

        nLoops:=Len(aFreeLocks)
        For nLoop:=1 To nLoops
            FreeLocks(aFreeLocks[nLoop,1],aFreeLocks[nLoop,2],.T.,aFreeLocks[nLoop,3])
        Next nLoop
        
    CATCHEXCEPTION USING oException

        IF (ValType(oException)=="O")
            ConOut(oException:Description,oException:ErrorStack)
        EndIF

    ENDEXCEPTION    

Return(NIL)

/*/
    Funcao:SetFreeLock
    Autor:Marinaldo de Jesus
    Data:22/12/2010
    Uso:Armazena Locks Para Liberacao Futura
    Sintaxe:StaticCall(NDJLIB003,SetFreeLock,cAlias,aRecnos,aKeys)
/*/
METHOD SetFreeLock(cAlias,aRecnos,aKeys) CLASS NDJLIB003
RETURN(SetFreeLock(@cAlias,@aRecnos,@aKeys))
Static Function SetFreeLock(cAlias,aRecnos,aKeys)
    DEFAULT cAlias:=Alias()

    cAlias:=Upper(AllTrim(cAlias))

    IF .NOT.(Empty(cAlias))
        aAdd(__aSetFreeLock,{cAlias,aRecnos,aKeys})
        ++__nSetFreeLock
    EndIF    

Return(__aSetFreeLock)

/*/
    Funcao:GetFreeLock
    Autor:Marinaldo de Jesus
    Data:22/12/2010
    Uso:Obtem os Locks a serem Liberados
    Sintaxe:StaticCall(NDJLIB003,GetFreeLock,cAlias)
/*/
METHOD GetFreeLock(cAlias) CLASS NDJLIB003
RETURN(GetFreeLock(@cAlias))
Static Function GetFreeLock(cAlias)

    Local aFreeLock:=Array(0)

    Local nAT:=0

    DEFAULT cAlias:=Alias()

    cAlias:=Upper(AllTrim(cAlias))

    While ((nAT:=aScan(__aSetFreeLock,{|aFreeLck|(aFreeLck[1]==cAlias)},++nAT))>0)
        aAdd(aFreeLock,__aSetFreeLock[nAT])
        aDel(__aSetFreeLock,nAT)
        aSize(__aSetFreeLock,(--__nSetFreeLock))
    End While    

Return(aFreeLock)

/*/
    Funcao:LockSoft
    Autor:Marinaldo de Jesus
    Data:11/08/2011
    Uso:Adiciona Alias para AliasUnLock
    Sintaxe:StaticCall(NDJLIB003,LockSoft,cAlias,@aAliasLock)
/*/
METHOD LockSoft(cAlias,aAliasLock) CLASS NDJLIB003
RETURN(LockSoft(@cAlias,@aAliasLock))
Static Function LockSoft(cAlias,aAliasLock)

    Local aLock:=Array(0)
    Local lLock:=.F.

    Local nBL
    Local nEL

    DEFAULT cAlias:=Alias()

    cAlias:=Upper(AllTrim(cAlias))

    IF .NOT.(Empty(cAlias))    

        lLock:=(cAlias)->(SoftLock(@cAlias))

        IF (lLock)
            aLock:=AliasLock(@cAlias)
            nEL:=__nAliasLock
            DEFAULT aAliasLock:=Array(0)
            For nBL:=1 To nBL
                IF (aScan(aAliasLock,{|cAlias|cAlias==aLock[nBL]})==0)
                    aAdd(aAliasLock,aLock[nBL])
                EndIF
            Next nEL
        EndIF

    EndIF    

Return(lLock)

/*/
    Funcao:AliasLock
    Autor:Marinaldo de Jesus
    Data:11/08/2011
    Uso:Adiciona Alias para AliasUnLock
    Sintaxe:StaticCall(NDJLIB003,AliasLock,cAlias)
/*/
METHOD AliasLock(cAlias) CLASS NDJLIB003
RETURN(AliasLock(@cAlias))
Static Function AliasLock(cAlias)

    DEFAULT cAlias:=Alias()

    cAlias:=Upper(AllTrim(cAlias))

    IF .NOT.(Empty(cAlias))
        IF (aScan(__aAliasLock,{|cAliasLck|cAliasLck==cAlias})==0)
            aAdd(__aAliasLock,cAlias)
            ++__nAliasLock
        EndIF
    EndIF    

Return(__aAliasLock)

/*/
    Funcao:AliasUnLock
    Autor:Marinaldo de Jesus
    Data:11/08/2011
    Uso:Libera Todos os Locks Obtidos pela AliasLock 
    Sintaxe:StaticCall(NDJLIB003,AliasUnLock,aAliasLock)
/*/
METHOD AliasUnLock(aAliasLock) CLASS NDJLIB003
RETURN(AliasUnLock(@aAliasLock))
Static Function AliasUnLock(aAliasLock)

    Local aFreeLocks
    
    Local cAlias

    Local nBL
    Local nEL
    Local nAT

    DEFAULT aAliasLock:=aClone(__aAliasLock)

    nEL:=Len(aAliasLock)
    For nBL:=1 To nEL
        cAlias:=Upper(AllTrim(aAliasLock[nBL]))
        IFreeLocks(cAlias,.T.)
        aFreeLocks:=GetFreeLock(cAlias)
        _FreeLocks(@aFreeLocks)
        While ((nAT:=aScan(__aAliasLock,{|cAliasLck|cAliasLck==cAlias},++nAT))>0)
            (cAlias)->(UnLockAll())
            aDel(__aAliasLock,nAT)
            aSize(__aAliasLock,(--__nAliasLock))
        End While
    Next nBL

Return(NIL)