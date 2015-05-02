#include "ndj.ch"
#DEFINE KEY_ID_SIZE    15

#DEFINE SEMAPHORE_PATH "\semaforo\"

Static oNDJLIB013

CLASS NDJLIB013

    METHOD NEW() CONSTRUCTOR
    
    METHOD IsSemaphore(cSemaphore)
    METHOD GetSemaphore(cSemaphore)
    METHOD PutSemaphore(cSemaphore,cKey)
    METHOD RmvSemaphore(cSemaphore)
    METHOD SemaBlock(cSemaphore,lRetMsg,cMsg)    
    METHOD SemaphoreWait(bExec,bWaitExec,bMsgInfo,cTitleProc,cProcName)
    METHOD GetKeyID(cTableName,cTableIndex,cTableKey)
    METHOD FindKeyID(cKeyId,cTableName,cTableIndex,cTableKey)
    METHOD dbKeyIDOpen(cAlias,cTableName)
    METHOD MayIdbKeyIDOpen(cSemaphore,lRetMsg,cTableName)
    
ENDCLASS

User Function DJLIB013()
    DEFAULT oNDJLIB013:=NDJLIB013():New()
Return(oNDJLIB013)

METHOD NEW() CLASS NDJLIB013
RETURN(self)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:IsSemaphore
        Autor:Marinaldo de Jesus
        Data:28/03/2011
        Descricao:Verifica se a Chave esta semaforizada
        Sintaxe:<Vide Parametros Formais>
    /*/
//------------------------------------------------------------------------------------------------
METHOD IsSemaphore(cSemaphore) CLASS NDJLIB013
RETURN(IsSemaphore(@cSemaphore))
Static Function IsSemaphore(cSemaphore)
Return(File(SEMAPHORE_PATH+cSemaphore))

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:GetSemaphore
        Autor:Marinaldo de Jesus
        Data:28/03/2011
        Descricao:Obtem o conteudo do arquivo semaforizado
        Sintaxe:<Vide Parametros Formais>
    /*/
//------------------------------------------------------------------------------------------------
METHOD GetSemaphore(cSemaphore) CLASS NDJLIB013
RETURN(GetSemaphore(@cSemaphore))
Static Function GetSemaphore(cSemaphore)

    Local aGetSemaphore:={}
    
    IF IsSemaphore(cSemaphore)
        aGetSemaphore:=StaticCall(NDJLIB001,FileToArr,SEMAPHORE_PATH+cSemaphore)
    EndIF

Return(aGetSemaphore)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:PutSemaphore
        Autor:Marinaldo de Jesus
        Data:28/03/2011
        Descricao:Adiciona o conteudo do arquivo semaforizado
        Sintaxe:<Vide Parametros Formais>
    /*/
//------------------------------------------------------------------------------------------------
METHOD PutSemaphore(cSemaphore,cKey) CLASS NDJLIB013
RETURN(PutSemaphore(@cSemaphore,@cKey))
Static Function PutSemaphore(cSemaphore,cKey)

    Local bfOpen:={||((nHdlSemaphore:=fOpen(SEMAPHORE_PATH+cSemaphore,FO_READWRITE+FO_EXCLUSIVE))<>-1)}
    
    Local lfOpenOK:=.F.
    Local IsSemaphore:=IsSemaphore(cSemaphore)
    
    Local nErr
    Local nfOpenOk
    Local nBytesKey
    Local nHdlSemaphore
    
    Begin Sequence
    
        IF !(IsSemaphore)
            IF !(IsSemaphore:=StaticCall(NDJLIB001,DirMake,SEMAPHORE_PATH))
                Break
            EndIF
            IsSemaphore:=MemoWrite(SEMAPHORE_PATH+cSemaphore,cKey)
            Break
        EndIF
       
        lfOpenOK:=Eval(bfOpen)
        nfOpenOk:=0
        IF !(lfOpenOK)
            While (;
                        !(lfOpenOK:=((nErr:=fError())==0));
                        .and.;
                        (++nfOpenOk<=50);
      )
                Sleep(1000)
                IF (lfOpenOK:=Eval(bfOpen))
                    Exit
                EndIF
            End While
        EndIF
        
        IF !(lfOpenOK)
            UserException("Can't open file:"+SEMAPHORE_PATH+cSemaphore+" Dos Error:"+Str(fError()))
            Break
        EndIF
    
        fSeek(nHdlSemaphore,0,FS_END)
    
        nBytesKey:=Len(cKey)
        IsSemaphore:=(fWrite(nHdlSemaphore,cKey,nBytesKey)==nBytesKey)
    
        fClose(nHdlSemaphore)
    
    End Sequence
    
Return(IsSemaphore)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:RmvSemaphore
        Autor:Marinaldo de Jesus
        Data:28/03/2011
        Descricao:Remove o arquivo semaforizado
        Sintaxe:<Vide Parametros Formais>
    /*/
//------------------------------------------------------------------------------------------------
METHOD RmvSemaphore(cSemaphore) CLASS NDJLIB013
RETURN(RmvSemaphore(@cSemaphore))
Static Function RmvSemaphore(cSemaphore)
Return(StaticCall(NDJLIB007,FileErase,SEMAPHORE_PATH+cSemaphore))

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:SemaBlock
        Autor:Marinaldo de Jesus 
        Data:02/04/2011
        Descricao:Tenta Obter Bloqueio por Semaforo
        Sintaxe:<vide parametros formais>
    /*/
//------------------------------------------------------------------------------------------------
METHOD SemaBlock(cSemaphore,lRetMsg,cMsg) CLASS NDJLIB013
RETURN(SemaBlock(@cSemaphore,@lRetMsg,@cMsg))
Static Function SemaBlock(cSemaphore,lRetMsg,cMsg)

    Local aGetSemafore
    
    Local cMsgInfo
    
    Local nLoop
    Local nLoops
    
    Local uRet:=.T.
    
    DEFAULT lRetMsg:=.F.
    
    BEGIN SEQUENCE

        IF (StaticCall(NDJLIB003,UseCode,cSemaphore))
            IF (lRetMsg)
                uRet:=""
            EndIF
            BREAK
        EndIF

        IF !(lRetMsg)
            uRet:=.F.
            Break                
        EndIF

        aGetSemafore:=GetSemaphore(cSemaphore)
        nLoops:=Len(aGetSemafore)
        cMsgInfo:=cMsg
        cMsgInfo+=__cCRLF
        cMsgInfo+=__cCRLF
        For nLoop:=1 To nLoops
            cMsgInfo+=aGetSemafore[nLoop]
            cMsgInfo+=__cCRLF
        Next nLoop
        uRet:=cMsgInfo
    
    END SEQUENCE

Return(uRet)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:SemaphoreMsg
        Autor:Marinaldo de Jesus 
        Data:04/01/2011
        Descricao:Aguarda pela Liberacao do Semaforo
        Sintaxe:<vide parametros formais>
    /*/
//------------------------------------------------------------------------------------------------
METHOD SemaphoreWait(bExec,bWaitExec,bMsgInfo,cTitleProc,cProcName) CLASS NDJLIB013
RETURN(SemaphoreWait(@bExec,@bWaitExec,@bMsgInfo,@cTitleProc,@cProcName))
Static Function SemaphoreWait(bExec,bWaitExec,bMsgInfo,cTitleProc,cProcName)

    Local cUserID:=StaticCall(NDJLIB001,RetCodUsr)
    Local cSemaphore:=""
    Local cTitleInfo:="A T E N Ç Ã O!!!" 
    Local cMsgYesNo:="Tentar Novamente?"
    Local cTitleYesNo:=""
    Local cProcWaiting:="Aguarde..."

    Local lOk:=.T.

    DEFAULT cProcName:=ProcName(1)

    IF !(Type("cEmpAnt")=="C")
        Private cEmpAnt:=""
    EndIF
    cSemaphore:=(cProcName+cEmpAnt+".lck")
    cTitleYesNo:=cProcName
    
    Begin Sequence
    
        IF !(;
                StaticCall(;
                                    NDJLIB013,; 
                                    WhileYesNoWait,;
                                    @bWaitExec,;    //Bloco a Ser Executando Enquanto (Devera Retornar Valor Logico)
                                    10000,;         //Numero de Vezes que a ProcWaiting() sera executada
                                    .T.,;           //Se podera Encerrar as as Tentativas (Button Cancel Enabled)
                                    @bMsgInfo,;     //Mensagem de Corpo para a MsgInfo
                                    @cTitleInfo,;   //Titulo para a MsgInfo 
                                    @cMsgYesNo,;    //Mensagem de Corpo para a MsgYesNo
                                    @cTitleYesNo,;  //Titulo para a MsgYesNo
                                    @cProcWaiting,; //Mensagem de corpo para a ProcWaiting
                                    @cTitleProc;    //Titulo para a ProcWaiting
              );
)            
            lOk:=.F.
            Break
        EndIF
    
        RmvSemaphore(cSemaphore)

        PutSemaphore(cSemaphore,"Usuário:"+cUserID)
        PutSemaphore(cSemaphore,__cCRLF)
        PutSemaphore(cSemaphore,"Nome:"+StaticCall(NDJLIB014,UsrRetName,cUserID))
        PutSemaphore(cSemaphore,__cCRLF)
        PutSemaphore(cSemaphore,"Nome Completo:"+StaticCall(NDJLIB014,UsrFullName,cUserID))
        PutSemaphore(cSemaphore,__cCRLF)
        PutSemaphore(cSemaphore,"Computador:"+GetComputerName())
        PutSemaphore(cSemaphore,__cCRLF)
        PutSemaphore(cSemaphore,"Client IP:"+GetClientIp())
        PutSemaphore(cSemaphore,__cCRLF)
        PutSemaphore(cSemaphore,"Thread Id:"+AllTrim(Str(ThreadId(),0)))
        PutSemaphore(cSemaphore,__cCRLF)

        Eval(bExec)

        RmvSemaphore(cSemaphore)

        StaticCall(NDJLIB003,ReleaseCode,cSemaphore)
    
    End Sequence

Return(lOk)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:GetKeyID
        Autor:Marinaldo de Jesus
        Data:01/04/2011
        Descricao:Retorna um ID Valido
        Sintaxe:<Vide Parametros Formais>
    /*/
//------------------------------------------------------------------------------------------------
METHOD GetKeyID(cTableName,cTableIndex,cTableKey) CLASS NDJLIB013
RETURN(GetKeyID(@cTableName,@cTableIndex,@cTableKey))
Static Function GetKeyID(cTableName,cTableIndex,cTableKey)

    Local aFields

    Local bGetKey

    Local cData
    Local cAlias

    Local cIndex
    Local cQuery
    Local cNextKey
    Local cAliasQuery
    
    Begin Sequence

        IF !(dbKeyIDOpen(@cAlias,@cData))
            BREAK
        EndIF

        cQuery:="select max(ID) ID from "+cData
        cQuery:=ChangeQuery(cQuery)
    
        cAliasQuery:=GetNextAlias()
    
        dbUseArea(.T.,"TOPCONN",TcGenQry(NIL,NIL,cQuery),cAliasQuery)
    
        IF (cAliasQuery)->(Eof() .or. Bof())
            cNextKey:=Replicate("0",KEY_ID_SIZE)
        Else
            cNextKey:=(cAliasQuery)->ID
        EndIF
        (cAliasQuery)->(dbCloseArea())

        SetMaxCode(NDJ_MAX_CODE)
        StaticCall(RHLIBLCK,MySetMaxCode,NDJ_MAX_CODE)
    
        PutFileInEof(cAlias)
        bGetKey:={||cNextKey:=GetNewCodigo(cAlias,"ID","ID",{||cNextKey:=__Soma1(cNextKey)},.F.,.F.,"","",cNextKey,.F.)}

        cQuery:="select ID from "+cData+" where ID='"+cNextKey+"' order by ID,R_E_C_N_O_,D_E_L_E_T_"
        cQuery:=ChangeQuery(cQuery)
        dbUseArea(.T.,"TOPCONN",TcGenQry(NIL,NIL,cQuery),cAliasQuery)

        While ((cAliasQuery)->ID==Eval(bGetKey))
            (cAliasQuery)->(dbGoTop())
        End While
        (cAliasQuery)->(dbCloseArea())

        DEFAULT cTableName:=cData
        DEFAULT cTableIndex:="ID"
        DEFAULT cTableKey:=cNextKey

        IF (cAlias)->(UsrRecLock(cAlias,.T.,.F.))
            (cAlias)->ID:=cNextKey
            (cAlias)->TABLENAME:=cTableName
            (cAlias)->TABLEINDEX:=cTableIndex
            (cAlias)->TABLEKEY:=cTableKey
            (cAlias)->(MsUnLock())
        EndIF

        FreeLocks(NIL,NIL,.T.,NIL)

        IF (Select(cAlias)>0)
            (cAlias)->(dbCloseArea())
        EndIF    

    End Sequence

Return(cNextKey)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:FindKeyID
        Autor:Marinaldo de Jesus
        Data:01/04/2011
        Descricao:Retorna um ID Valido
        Sintaxe:<Vide Parametros Formais>
    /*/
//------------------------------------------------------------------------------------------------
METHOD FindKeyID(cKeyId,cTableName,cTableIndex,cTableKey) CLASS NDJLIB013
RETURN(FindKeyID(@cKeyId,@cTableName,@cTableIndex,@cTableKey))
Static Function FindKeyID(cKeyId,cTableName,cTableIndex,cTableKey)

    Local cData
    Local cAlias
    Local cQuery
    Local cAliasQuery
    
    Local lFound:=.F.

    Local nRecno:=0
    
    Begin Sequence

        IF !(dbKeyIDOpen(@cAlias,@cData))
            BREAK
        EndIF

        cQuery:="select R_E_C_N_O_ from "+cData+" where ID='"+cKeyId+"'"
        cQuery:=ChangeQuery(cQuery)
    
        cAliasQuery:=GetNextAlias()
    
        dbUseArea(.T.,"TOPCONN",TcGenQry(NIL,NIL,cQuery),cAliasQuery)

        lFound:=(cAliasQuery)->(!(Eof() .and. Bof()))
        IF (lFound)
            nRecno:=(cAliasQuery)->(R_E_C_N_O_)
        EndIF
        (cAliasQuery)->(dbCloseArea())

        (cAlias)->(dbGoto(nRecno))

        cTableName:=(cAlias)->TABLENAME
        cTableIndex:=(cAlias)->TABLEINDEX
        cTableKey:=(cAlias)->TABLEKEY    

        IF (Select(cAlias)>0)
            (cAlias)->(dbCloseArea())
        EndIF    

    End Sequence

Return(lFound)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:dbKeyIDOpen
        Autor:Marinaldo de Jesus
        Data:01/04/2011
        Descricao:Retorna um Numero Sequencial Valido
        Sintaxe:<Vide Parametros Formais>
    /*/
//------------------------------------------------------------------------------------------------
METHOD dbKeyIDOpen(cAlias,cTableName) CLASS NDJLIB013
RETURN(dbKeyIDOpen(@cAlias,@cTableName))
Static Function dbKeyIDOpen(cAlias,cTableName)

    Local aFields

    Local lOpenned:=.F.

    Local cRdd:="TOPCONN"

    Local cIndex
    Local cSemaphore

    DEFAULT cAlias:=GetNextAlias()
    
    cTableName:="NDJKEYID"
    cSemaphore:=cTableName

    BEGIN SEQUENCE

        lOpenned:=(Select(cAlias)>0)
        
        IF (lOpenned)
            BREAK
        EndIF

        lOpenned:=MayIdbKeyIDOpen(cSemaphore,.F.,cTableName)
        IF !(lOpenned)
            BREAK
        EndIF

        cIndex:=(cTableName+"1")

        IF !(MsFile(cTableName))
            aFields:={;
                            {"ID","C",KEY_ID_SIZE,0},;
                            {"TABLENAME","C",10,0},;
                            {"TABLEINDEX","C",255,0},;
                            {"TABLEKEY","C",255,0};
                    }
            dbCreate(cTableName,@aFields,cRdd)
        EndIF

        dbUseArea(.T.,cRdd,cTableName,cAlias,.T.)

        IF !(MsFile(cTableName,cIndex))
            (cAlias)->(dbCreateIndex(cIndex,"ID",{||ID},IF(.F.,.T.,NIL)))
        EndIF

        (cAlias)->(dbClearIndex())
        (cAlias)->(dbSetIndex(cIndex))
    
        StaticCall(NDJLIB003,ReleaseCode,cSemaphore)

        lOpenned:=.T.

    END SEQUENCE

Return(lOpenned)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:MayIdbKeyIDOpen
        Autor:Marinaldo de Jesus 
        Data:02/04/2011
        Descricao:Tenta Obter Exclusividade aa rotina dbKeyIDOpen
        Sintaxe:<vide parametros formais>
    /*/
//------------------------------------------------------------------------------------------------
METHOD MayIdbKeyIDOpen(cSemaphore,lRetMsg,cTableName) CLASS NDJLIB013
RETURN(MayIdbKeyIDOpen(@cSemaphore,@lRetMsg,@cTableName))
Static Function MayIdbKeyIDOpen(cSemaphore,lRetMsg,cTableName)
    Local cMsg:="Outro Usuário está criando a Tabela:"+cTableName 
Return(SemaBlock(@cSemaphore,@lRetMsg,@cMsg))
