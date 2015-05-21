#ifdef TOTVS
    #include "totvs.ch"
#else
    #include "protheus.ch"
#endif    
#include "dbstruct.ch"
#include "topconn.ch"
#include "ndj.ch"

#DEFINE TC_TRANS_BEGIN      1
#DEFINE TC_TRANS_END        2
#DEFINE TC_TRANS_ROLLBACK   3
#DEFINE TC_TRANS_COMMIT        4

#DEFINE SUPER_CLASS_METH    1
#DEFINE SUPER_CLASS_DATA    2

Static __lTopTable:=.F.

//------------------------------------------------------------------------------------------------------
    /*
         CLASS:TSQLite
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Prototipo da Classe TSQLite em ADVPL
    */
//------------------------------------------------------------------------------------------------------
CLASS TSQLite FROM FWDBAccess

    DATA aAlias
    DATA adbStruct
    #IFDEF __DEBUG
        DATA aSuperClass
    #ENDIF    

    DATA cCRLF
     DATA cCurrentAlias
    DATA nCurrentAlias

    DATA nAdvConnection
    DATA nCommitInterval

    METHOD New(cDBMSName,cDBMSAlias,cDBMSServer,nDBMSPort) CONSTRUCTOR
    METHOD Destroy()
    METHOD ClassName()

    METHOD OpenConnection()

    METHOD SQLExec(cQuery)
    METHOD SQLError()

    METHOD dbQuery(cAlias,cQuery,lNewArea)

    METHOD dbGoTo(nRec)
    METHOD dbGoTop()
    METHOD dbGoBottom()

    METHOD Eof()
    METHOD Bof()

    METHOD dbSkip()

    METHOD RecNo()

    METHOD SetFilter(bSetFilter,cSetFilter)
    METHOD ClearFilter()

    METHOD IndRegua(cExpress,cFor,cMens,lShow)

    METHOD dbAlter(cTable)
    METHOD dbCreate(cTable)
    METHOD dbUse(lNewArea,cDriver,cName,xcAlias,lShared,lReadonly)
    METHOD dbSelect(xcAlias)
    METHOD dbClose()
    METHOD dbStruct()

    METHOD BeginStruct()
    METHOD addField(cFieldName,cFieldType,nFieldLen,nFieldDec)
    METHOD EndStruct()
    METHOD SetStruct(adbStruct)

    METHOD Deleted()
    METHOD dbDelete()

    METHOD DropTable(cTable)

    METHOD SetCurrentAlias(xcAlias)

    METHOD Fields() 
    METHOD FieldGet(uField)
    METHOD FieldPut(uField,uFldPut)
    METHOD FieldPos(cField)
    METHOD FieldName(nField)

    METHOD dbrLock(nRec)
    METHOD dbrUnLock(nRec)
    METHOD dbAppend(lFreeLock)

    METHOD BeginTransaction()
    METHOD EndTransaction()
    METHOD RollBackTransaction()
    METHOD CommitTransaction()

    METHOD TopField()
    METHOD SQLiteTable(cTable)

    METHOD P2SQL(pVal)
    
    METHOD GetNextAlias()
    
    METHOD SetField(adbStruct)

    #IFDEF __DEBUG
        METHOD SuperClass()
    #ENDIF    

END CLASS

//------------------------------------------------------------------------------------------------------
    /*
         Funcao:U_TSQLite
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Instancia um novo Objeto da Classe TSQLite em ADVPL
    */
//------------------------------------------------------------------------------------------------------
User Function TSQLite(cDBMSName,cDBMSAlias,cDBMSServer,nDBMSPort)
Return(TSQLite():New(@cDBMSName,@cDBMSAlias,@cDBMSServer,@nDBMSPort))

//------------------------------------------------------------------------------------------------------
    /*
         Method:New
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Construtor
    */
//------------------------------------------------------------------------------------------------------
METHOD New(cDBMSName,cDBMSAlias,cDBMSServer,nDBMSPort) CLASS TSQLite

    Self:aAlias:=Array(0)
    Self:adbStruct:=Array(0)
    #IFDEF __DEBUG
        Self:aSuperClass:=Array(2)
    #ENDIF    
    Self:cCRLF:=__cCRLF
    Self:cCurrentAlias:=""
    Self:nCurrentAlias:=0
    Self:nCommitInterval:=10
    Self:nAdvConnection:=AdvConnection()

    DEFAULT Self:nAdvConnection:=-1
    
    SetTopTable(.F.)

    _Super:New(cDBMSName+"/"+cDBMSAlias,cDBMSServer,nDBMSPort)

Return(Self)

//------------------------------------------------------------------------------------------------------
    /*
         Method:Destroy
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Finalizador
    */
//------------------------------------------------------------------------------------------------------
METHOD Destroy() CLASS TSQLite

    Local nBL
    Local nEL

    TCSetConn(Self:nHandle)

    nEL:=Len(Self:aAlias)
    For nBL:=1 To nEL
        cAlias:=Self:aAlias[nBL]
        IF (;
                !Empty(cAlias);
                .and.;
                (Select(cAlias)>0);
          )
            (cAlias)->(dbCloseArea())
        EndIF    
    Next nBL    

    aSize(Self:aAlias,0)

    Self:cCurrentAlias:=""
    Self:nCurrentAlias:=0

    TCSetConn(Self:nAdvConnection)

Return(_Super:Destroy())

//------------------------------------------------------------------------------------------------------
    /*
         Method:ClassName
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Retorna o Nome da Classe
    */
//------------------------------------------------------------------------------------------------------
METHOD ClassName() CLASS TSQLite
Return("TSQLITE")

//------------------------------------------------------------------------------------------------------
    /*
         Method:OpenConnection
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Efetua uma nova Conexao do DBMS/SGBD via dbAccess
    */
//------------------------------------------------------------------------------------------------------
METHOD OpenConnection() CLASS TSQLite

    Local cDBMS

    Local lConnection:=.F.

    lConnection:=_Super:OpenConnection()
    IF (lConnection)
        cDBMS:=Self:cDBMSAlias
        cDBMS:=Upper(SubStr(cDBMS,1,AT("/",cDBMS)-1))
        lConnection:=(TCGetDB()==cDBMS)
    EndIF

    IF !(lConnection)
        Self:CloseConnection()
        Self:nHandle:=TCLink(Self:cDBMSAlias,Self:cServer,Self:nPort)
        lConnection:=(Self:nHandle>=0)
    EndIF

    IF (lConnection)
        Self:ClearError()
        IF (Self:nAdvConnection==-1)
            Self:nAdvConnection:=Self:nHandle
        EndIF
    EndIF    

Return(lConnection)

//------------------------------------------------------------------------------------------------------
    /*
         Method:SQLExec
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Enviar requisicoes ao DBMS
    */
//------------------------------------------------------------------------------------------------------
METHOD SQLExec(cQuery) CLASS TSQLite
    Local uSqlExec
    TCSetConn(Self:nHandle)
        uSqlExec:=TCSqlExec(cQuery) 
    TCSetConn(Self:nAdvConnection)
Return(uSqlExec)

//------------------------------------------------------------------------------------------------------
    /*
         Method:SQLError
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Retorna o ultimo erro ocorrido no DBMS
    */
//------------------------------------------------------------------------------------------------------
METHOD SQLError() CLASS TSQLite
    Local uSqlError
    TCSetConn(Self:nHandle)
        uSqlError:=TCSqlError()
    TCSetConn(Self:nAdvConnection)
Return(uSqlError)

//------------------------------------------------------------------------------------------------------
    /*
         Method:dbQuery
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Abre uma "View"
    */
//------------------------------------------------------------------------------------------------------
METHOD dbQuery(cAlias,cQuery,lNewArea) CLASS TSQLite

    Local ldbQuery:=.F.

    TCSetConn(Self:nHandle)

    DEFAULT cAlias:=Self:GetNextAlias()
    DEFAULT lNewArea:=.T.

    IF (lNewArea)
        TCQUERY (cQuery) ALIAS (cAlias) NEW
    Else
        TCQUERY (cQuery) ALIAS (cAlias)
    EndIF    

    ldbQuery:=(Alias()==cAlias)

    IF !(ldbQuery)
        ConOut(Self:SqlError())
    Else
        aAdd(Self:aAlias,cAlias)
        Self:SetCurrentAlias(@cAlias)
    EndIF

    TCSetConn(Self:nAdvConnection)

Return(ldbQuery)

//------------------------------------------------------------------------------------------------------
    /*
         Method:dbGoTo
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Simula dbGoTo padrao posicionando o "ponteiro" da Tabela no Registro selecionado
    */
//------------------------------------------------------------------------------------------------------
METHOD dbGoTo(nRec,lGoTop) CLASS TSQLite

    Local bSetFilter
    Local cSetFiler
    
    Local ldbGoTo:=.F.

    Local nRecno

    IF (Self:FieldPos("R_E_C_N_O_")>0)
        DEFAULT lGoTop:=.F.
        Self:ClearFilter()
        IF (lGoTop)
            Self:dbGoTop()
        EndIF
        nRecno:=(Self:cCurrentAlias)->(Recno())
        bSetFilter:={||R_E_C_N_O_==nRec}
        cSetFiler:="R_E_C_N_O_="+LTrim(Str(nRec))
        Self:SetFilter(@bSetFilter,@cSetFiler)
        Self:dbSkip()
        nRecno:=(Self:cCurrentAlias)->(Recno())
        ldbGoTo:=(nRecno==nRec)
        IF !(ldbGoTo)
            Self:ClearFilter()
            Self:dbSkip()
        EndIF
    EndIF

Return(ldbGoTo)

//------------------------------------------------------------------------------------------------------
    /*
         Method:dbGoTop
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Posiciona o "ponteiro" da Tabela em seu Primeiro Registro "Logico/Fisico"
    */
//------------------------------------------------------------------------------------------------------
METHOD dbGoTop() CLASS TSQLite
Return((Self:cCurrentAlias)->(dbGoTop()))

//------------------------------------------------------------------------------------------------------
    /*
         Method:dbGoBottom
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Posiciona o "ponteiro" da Tabela em seu Ultimo Registro "Logico/Fisico"
    */
//------------------------------------------------------------------------------------------------------
METHOD dbGoBottom() CLASS TSQLite
Return((Self:cCurrentAlias)->(dbGoBottom()))

//------------------------------------------------------------------------------------------------------
    /*
         Method:Eof
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Testa um Eof
    */
//------------------------------------------------------------------------------------------------------
METHOD Eof() CLASS TSQLite
Return((Self:cCurrentAlias)->(Eof()))

//------------------------------------------------------------------------------------------------------
    /*
         Method:Bof
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Testa um Bof
    */
//------------------------------------------------------------------------------------------------------
METHOD Bof() CLASS TSQLite
Return((Self:cCurrentAlias)->(Bof()))

//------------------------------------------------------------------------------------------------------
    /*
         Method:dbSkip
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Skip Rec
    */
//------------------------------------------------------------------------------------------------------
METHOD dbSkip() CLASS TSQLite
Return((Self:cCurrentAlias)->(dbSkip()))

//------------------------------------------------------------------------------------------------------
    /*
         Method:RecNo
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Obtem o Registo corrente.
         Obs.:Depende de R_E_C_N_O_
    */
//------------------------------------------------------------------------------------------------------
METHOD RecNo() CLASS TSQLite
Return((Self:cCurrentAlias)->(RecNo()))

//------------------------------------------------------------------------------------------------------
    /*
         Method:SetFilter
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Friltra a "View" de acordo com os parametros passados.
    */
//------------------------------------------------------------------------------------------------------
METHOD SetFilter(bSetFilter,cSetFilter) CLASS TSQLite
    Self:ClearFilter()
Return((Self:cCurrentAlias)->(dbSetFilter(bSetFilter,cSetFilter)))

//------------------------------------------------------------------------------------------------------
    /*
         Method:ClearFilter
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Limpa o Filtro.
    */
//------------------------------------------------------------------------------------------------------
METHOD ClearFilter() CLASS TSQLite
Return((Self:cCurrentAlias)->(dbClearFiler()))

//------------------------------------------------------------------------------------------------------
    /*
         Method:IndRegua
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Ordena a consulta conforme parametros. Equivalente a IndRegua Padrao. 
         Obs.:Depende de R_E_C_N_O_
    */
//------------------------------------------------------------------------------------------------------
METHOD IndRegua(cExpress,cFor,cMens,lShow) CLASS TSQLite
    Local cAlias:=Self:cCurrentAlias
    Local cNIndex:=CriaTrab(NIL,.F.)
    Local xOrdem:=NIL
    Local uIndRet
    DEFAULT cMens:=""
    DEFAULT lShow:=!(MyIsBlind())
    Self:dbGoTop()
        (cAlias)->(uIndRet:=IndRegua(@cAlias,@cNIndex,@cExpress,@xOrdem,@cFor,@cMens,@lShow))
    Self:dbGoTop()
    IF (Self:Eof() .or. Self:Bof())
        Self:dbGoTop()
    EndIF
Return(uIndRet)

//------------------------------------------------------------------------------------------------------
    /*
         Method:dbAlter
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Altera a Estrutura da Tabela
    */
//------------------------------------------------------------------------------------------------------
METHOD dbAlter(cTable,adbStruct) CLASS TSQLite
    TCSetConn(Self:nHandle)
    //TODO:Implementar
    TCSetConn(Self:nAdvConnection)
Return(.F.)

//------------------------------------------------------------------------------------------------------
    /*
         Method:dbCreate
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Cria uma nova Tabela para uso na Classe TSQLite
    */
//------------------------------------------------------------------------------------------------------
METHOD dbCreate(cTable) CLASS TSQLite

    Local lCreate:=.F.

    BEGIN SEQUENCE    

        IF !(Self:TopField())
            ConOut("TOP_FIELD nao encontrada") 
            BREAK
        EndIF

        TCSetConn(Self:nHandle)

        lCreate:=TableCreate(@Self,@cTable,Self:adbStruct)

    END SEQUENCE    

    TCSetConn(Self:nAdvConnection)

Return(lCreate)

//------------------------------------------------------------------------------------------------------
    /*
         Method:dbUse
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Abre uma Tabela/View
    */
//------------------------------------------------------------------------------------------------------
METHOD dbUse(lNewArea,cDriver,cName,xcAlias,lShared,lReadonly) CLASS TSQLite

    Local ldbUse:=.F.
    Local cAlias

    TCSetConn(Self:nHandle)
    
    DEFAULT lNewArea:=.T.
    DEFAULT cDriver:="TOPCONN"
    DEFAULT xcAlias:=Self:GetNextAlias()
    DEFAULT lShared:=.T.
    DEFAULT lReadonly:=.F.

    dbUseArea(@lNewArea,@cDriver,@cName,@xcAlias,@lShared,@lReadonly)

    IF (ValType(xcAlias)=="N")
        ldbUse:=(Select()==xcAlias)        
    Else
        ldbUse:=(Alias()==xcAlias)
    EndIF    
    
    IF (ldbUse)
        cAlias:=Alias()
        aAdd(Self:aAlias,cAlias)
        Self:SetCurrentAlias(@cAlias)
    EndIF

    TCSetConn(Self:nAdvConnection)

Return(ldbUse)

//------------------------------------------------------------------------------------------------------
    /*
         Method:dbSelect
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Seleciona a Area Corrente
    */
//------------------------------------------------------------------------------------------------------
METHOD dbSelect(xcAlias) CLASS TSQLite

    Local cAlias:=Alias()

    TCSetConn(Self:nHandle)

    DEFAULT xcAlias:=Self:cCurrentAlias
    IF !Empty(xcAlias)
        dbSelectArea(xcAlias)
    EndIF    
    IF (Select(xcAlias)>0)
        xcAlias:=Alias()
        Self:cCurrentAlias:=xcAlias
        Self:nCurrentAlias:=Select(xcAlias)
    ElseIF !Empty(cAlias)
        dbSelectArea(cAlias)
        Self:cCurrentAlias:=cAlias
        Self:cCurrentAlias:=Select(cAlias)
    EndIF    

    TCSetConn(Self:nAdvConnection)

Return(cAlias)

//------------------------------------------------------------------------------------------------------
    /*
         Method:SetCurrentAlias
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Seta a Area Corrente
    */
//------------------------------------------------------------------------------------------------------
METHOD SetCurrentAlias(xcAlias) CLASS TSQLite
    DEFAULT xcAlias:=Self:cCurrentAlias
Return(Self:dbSelect(xcAlias))

//------------------------------------------------------------------------------------------------------
    /*
         Method:dbClose
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Similar a dbCloseArea, fecha a area corrente
    */
//------------------------------------------------------------------------------------------------------
METHOD dbClose() CLASS TSQLite
    
    Local cAlias:=Self:cCurrentAlias
    Local nAT

    TCSetConn(Self:nHandle)

    IF (;
            !Empty(cAlias);
            .and.;
            (Select(cAlias)>0);
      )    
        (cAlias)->(dbCloseArea())
        nAT:=aScan(Self:aAlias,{|e|(e==cAlias)})
        IF (nAT>0)
            aDel(Self:aAlias,nAT)
            aSize(Self:aAlias,(Len(Self:aAlias)-1))
        EndIF
    EndIF        

    TCSetConn(Self:nAdvConnection)

Return(NIL)

//------------------------------------------------------------------------------------------------------
    /*
         Method:FieldGet
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Obtem o conteudo do Campo passado como parametro
    */
//------------------------------------------------------------------------------------------------------
METHOD FieldGet(uField) CLASS TSQLite
    Local cAlias:=Self:cCurrentAlias
    Local uFldGet
    Local nField
    IF (;
            !Empty(cAlias);
            .and.;
            (Select(cAlias)>0);
      )    
        IF (ValType(uField)=="C")
            nField:=Self:FieldPos(uField)
        Else
            nField:=uField
        EndIF
        uFldGet:=(cAlias)->(FieldGet(@nField))
    EndIF        
Return(uFldGet)

//------------------------------------------------------------------------------------------------------
    /*
         Method:FieldPut
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Atualiza o conteudo do Campo passado como parametro
    */
//------------------------------------------------------------------------------------------------------
METHOD FieldPut(uField,uFldPut) CLASS TSQLite
    Local cAlias:=Self:cCurrentAlias
    Local nField
    IF (;
            !Empty(cAlias);
            .and.;
            (Select(cAlias)>0);
      )    
        IF (ValType(uField)=="C")
            nField:=Self:FieldPos(uField)
        Else
            nField:=uField
        EndIF
        (cAlias)->(FieldPut(@nField,@uFldPut))
    EndIF        
Return(uFldGet)

//------------------------------------------------------------------------------------------------------
    /*
         Method:FieldPos
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Obtem o indice fisico do Campo passado como parametro
    */
//------------------------------------------------------------------------------------------------------
METHOD FieldPos(cField) CLASS TSQLite
    Local cAlias:=Self:cCurrentAlias
    Local nFldPos:=0
    IF (;
            !Empty(cAlias);
            .and.;
            (Select(cAlias)>0);
      )    
        nFldPos:=(cAlias)->(FieldPos(cField))
    EndIF        
Return(nFldPos)

//------------------------------------------------------------------------------------------------------
    /*
         Method:FieldName
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Obtem nome do Campo de acordo com o indice passado como parametro
    */
//------------------------------------------------------------------------------------------------------
METHOD FieldName(nField) CLASS TSQLite
    Local cAlias:=Self:cCurrentAlias
    IF (;
            !Empty(cAlias);
            .and.;
            (Select(cAlias)>0);
      )    
        cFldName:=(cAlias)->(FieldName(nField))
    EndIF        
Return(cFldName)

//------------------------------------------------------------------------------------------------------
    /*
         Method:dbrLock
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Tenta efetuar o Lock do Registro corrente
    */
//------------------------------------------------------------------------------------------------------
METHOD dbrLock(nRec) CLASS TSQLite
    TCSetConn(Self:nHandle)
    //TODO:Implementar
    TCSetConn(Self:nAdvConnection)
Return(.F.)

//------------------------------------------------------------------------------------------------------
    /*
         Method:dbrUnLock
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Libera o Lock do Registro Corrente
    */
//------------------------------------------------------------------------------------------------------
METHOD dbrUnLock(nRec) CLASS TSQLite
    TCSetConn(Self:nHandle)
    //TODO:Implementar
    TCSetConn(Self:nAdvConnection)
Return(.F.)

//------------------------------------------------------------------------------------------------------
    /*
         Method:dbAppend
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Adiciona um Registro em Branco a Tabela
    */
//------------------------------------------------------------------------------------------------------
METHOD dbAppend(lFreeLock) CLASS TSQLite
    TCSetConn(Self:nHandle)
    //TODO:Implementar
    TCSetConn(Self:nAdvConnection)
Return(.F.)

//------------------------------------------------------------------------------------------------------
    /*
         Method:BeginTransaction
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Inicia uma Transacao
    */
//------------------------------------------------------------------------------------------------------
METHOD BeginTransaction(cTransaction) CLASS TSQLite
    Local uTCCommit
    TCSetConn(Self:nHandle)
        uTCCommit:=TCCommit(TC_TRANS_BEGIN,cTransaction)
    TCSetConn(Self:nAdvConnection)
Return(uTCCommit)

//------------------------------------------------------------------------------------------------------
    /*
         Method:EndTransaction
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Finaliza uma Transacao
    */
//------------------------------------------------------------------------------------------------------
METHOD EndTransaction(cTransaction) CLASS TSQLite
    Local uTCCommit
    TCSetConn(Self:nHandle)
        uTCCommit:=TCCommit(TC_TRANS_END,cTransaction)
    TCSetConn(Self:nAdvConnection)
Return(uTCCommit)

//------------------------------------------------------------------------------------------------------
    /*
         Method:RollBackTransaction
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:"Desfaz" uma Transacao
    */
//------------------------------------------------------------------------------------------------------
METHOD RollBackTransaction(cTransaction) CLASS TSQLite
    Local uTCCommit
    TCSetConn(Self:nHandle)
        uTCCommit:=TCCommit(TC_TRANS_ROLLBACK,cTransaction)
    TCSetConn(Self:nAdvConnection)
Return(uTCCommit)

//------------------------------------------------------------------------------------------------------
    /*
         Method:CommitTransaction
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:"Confirma" uma Transacao
    */
//------------------------------------------------------------------------------------------------------
METHOD CommitTransaction(cTransaction) CLASS TSQLite
    Local uTCCommit
    TCSetConn(Self:nHandle)
        uTCCommit:=TCCommit(TC_TRANS_COMMIT,cTransaction)
    TCSetConn(Self:nAdvConnection)
Return(uTCCommit)

//------------------------------------------------------------------------------------------------------
    /*
         Method:TopField
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Verifica a Existencia da TopField
    */
//------------------------------------------------------------------------------------------------------
METHOD TopField() CLASS TSQLite
    Local lTopField:=.F.
    TCSetConn(Self:nHandle)
        lTopField:=TopField(Self)
    TCSetConn(Self:nAdvConnection)
Return(lTopField)

//------------------------------------------------------------------------------------------------------
    /*
         Method:SQLiteTable
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Verifica a Existencia da Tabela passada como Parametro
    */
//------------------------------------------------------------------------------------------------------
METHOD SQLiteTable(cTable) CLASS TSQLite
    Local lTable:=.F.
    TCSetConn(Self:nHandle)
        lTable:=SQLiteTable(@Self,@cTable)
    TCSetConn(Self:nAdvConnection)
Return(lTable)

//------------------------------------------------------------------------------------------------------
    /*
         Method:dbStruct
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Similar a dbStruct padrao, retorna a estrutura da Tabela Corrente
    */
//------------------------------------------------------------------------------------------------------
METHOD dbStruct() CLASS TSQLite
Return((Self:cCurrentAlias)->(dbStruct()))

//------------------------------------------------------------------------------------------------------
    /*
         Method:Fields
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Retorna o Numero de Campos/Colunas da Tabela Corrente
    */
//------------------------------------------------------------------------------------------------------
METHOD Fields() CLASS TSQLite
Return(Len(Self:dbStruct()))

//------------------------------------------------------------------------------------------------------
    /*
         Method:BeginStruct
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Inicia a Contrucao de uma Estrutura para a Criacao da Tabela
    */
//------------------------------------------------------------------------------------------------------
METHOD BeginStruct() CLASS TSQLite
    Local adbStruct:=aClone(Self:adbStruct)
    aSize(Self:adbStruct,0)
Return(adbStruct)

//------------------------------------------------------------------------------------------------------
    /*
         Method:addField
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Adiciona novos campos a Estrutura da Tabela
    */
//------------------------------------------------------------------------------------------------------
METHOD addField(cFieldName,cFieldType,nFieldLen,nFieldDec) CLASS TSQLite
    Local nField:=Len(Self:adbStruct)
    ++nField 
    aAdd(Self:adbStruct,Array(DBS_ALEN))
    Self:adbStruct[nField][DBS_NAME]:=cFieldName
    Self:adbStruct[nField][DBS_TYPE]:=cFieldType
    Self:adbStruct[nField][DBS_LEN]:=nFieldLen
    Self:adbStruct[nField][DBS_DEC]:=nFieldDec
Return(Self:adbStruct)

//------------------------------------------------------------------------------------------------------
    /*
         Method:EndStruct
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Finaliza a Contrucao de uma Estrutura para a Criacao da Tabela
    */
//------------------------------------------------------------------------------------------------------
METHOD EndStruct() CLASS TSQLite

    Local nField

    DEFAULT __lTopTable:=.F.
    nField:=aScan(Self:adbStruct,{|aField|aField[DBS_NAME]=="D_E_L_E_T_"})
    IF (nField==0)
        IF !(__lTopTable)
            aAdd(Self:adbStruct,Array(DBS_ALEN))
            nField:=Len(Self:adbStruct)
            Self:adbStruct[nField][DBS_NAME]:="D_E_L_E_T_"
            Self:adbStruct[nField][DBS_TYPE]:="C"
            Self:adbStruct[nField][DBS_LEN]:=1
            Self:adbStruct[nField][DBS_DEC]:=0
        EndIF
    Else
        IF (__lTopTable)
            aDel(Self:adbStruct,nField)
            aSize(Self:adbStruct,Len(Self:adbStruct)-1)
        EndIF
    EndIF
    nField:=aScan(Self:adbStruct,{|aField|aField[DBS_NAME]=="R_E_C_N_O_"})
    IF (nField==0)
        IF !(__lTopTable)
            aAdd(Self:adbStruct,Array(DBS_ALEN))
            nField:=Len(Self:adbStruct)
            Self:adbStruct[nField][DBS_NAME]:="R_E_C_N_O_"
            Self:adbStruct[nField][DBS_TYPE]:="N"
            Self:adbStruct[nField][DBS_LEN]:=15
            Self:adbStruct[nField][DBS_DEC]:=0
        EndIF
    Else
        IF (__lTopTable)
            aDel(Self:adbStruct,nField)
            aSize(Self:adbStruct,Len(Self:adbStruct)-1)
        EndIF
    EndIF
    nField:=aScan(Self:adbStruct,{|aField|aField[DBS_NAME]=="R_E_C_D_E_L_"})
    IF (nField==0)
        IF !(__lTopTable)
            aAdd(Self:adbStruct,Array(DBS_ALEN))
            nField:=Len(Self:adbStruct)
            Self:adbStruct[nField][DBS_NAME]:="R_E_C_D_E_L_"
            Self:adbStruct[nField][DBS_TYPE]:="N"
            Self:adbStruct[nField][DBS_LEN]:=15
            Self:adbStruct[nField][DBS_DEC]:=0
        EndIF    
    Else
        IF (__lTopTable)
            aDel(Self:adbStruct,nField)
            aSize(Self:adbStruct,Len(Self:adbStruct)-1)
        EndIF
    EndIF

Return(Self:adbStruct)

//------------------------------------------------------------------------------------------------------
    /*
         Method:SetStruct
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Define a Estrutura Corrente
    */
//------------------------------------------------------------------------------------------------------
METHOD SetStruct(adbStruct) CLASS TSQLite
    Local aLStruct:=aClone(Self:adbStruct)
    DEFAULT adbStruct:=aLStruct
    aSize(Self:adbStruct,0)
    aEval(adbStruct,{|e|aAdd(Self:adbStruct,e)})
Return(aLStruct)

//------------------------------------------------------------------------------------------------------
    /*
         Method:Deleted
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Verifica se o registro esta "Deletado" Logicamente
    */
//------------------------------------------------------------------------------------------------------
METHOD Deleted() CLASS TSQLite

    Local lDeleted:=.F.
    Local uDeleted
    Local cValType

    IF (Self:FieldPos("D_E_L_E_T_")>0)
        uDeleted:=Self:FieldGet("D_E_L_E_T_")
    ElseIF (Self:FieldPos("DELETED")>0)
        uDeleted:=Self:FieldGet("DELETED")
    EndIF

    cValType:=ValType(uDeleted)

    IF (cValType=="C")
        uDeleted:=Upper(AllTrim(uDeleted))
        lDeleted:=("*"==uDeleted)
        IF !(lDeleted)
            lDeleted:=("T"==uDeleted)
        EndIF
    ElseIF (cValType=="L")
        lDeleted:=uDeleted
    EndIF

Return(lDeleted)

//------------------------------------------------------------------------------------------------------
    /*
         Method:dbDelete
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Efetua a Delecao Logica do Registro corrente
    */
//------------------------------------------------------------------------------------------------------
METHOD dbDelete() CLASS TSQLite
    TCSetConn(Self:nHandle)
    //TODO:Implementar
    TCSetConn(Self:nAdvConnection)
Return(.F.)

//------------------------------------------------------------------------------------------------------
    /*
         Method:DropTable
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Exclusao Fisica da Tabela passada por parametro
    */
//------------------------------------------------------------------------------------------------------
METHOD DropTable(cTable) CLASS TSQLite
    TCSetConn(Self:nHandle)
        TCDelFile(cTable)
    TCSetConn(Self:nAdvConnection)
Return(Self:SQLiteTable(@cTable))

//------------------------------------------------------------------------------------------------------
    /*
         Method:P2SQL
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Converte os valores em ADVPL para SQL
    */
//------------------------------------------------------------------------------------------------------
METHOD P2SQL(pVal) CLASS TSQLite
Return(P2SQL(pVal))

//------------------------------------------------------------------------------------------------------
    /*
         Method:GetNextAlias
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Retorna o Proximo Alias Disponivel para Uso Prefixado como TRB
    */
//------------------------------------------------------------------------------------------------------
METHOD GetNextAlias() CLASS TSQLite

    Local bGetTrb:={||"TRB"+SubStr(GetNextAlias(),4)}
    Local cNextAlias:=Eval(bGetTrb)

    While (Select(cNextAlias)>0)
        cNextAlias:=Eval(bGetTrb)
    End While

Return(cNextAlias)

//------------------------------------------------------------------------------------------------------
    /*
         Method:SetField
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Chamada a TCSetField para Definir o Tipo do Campo na TOP_FIELD
    */
//------------------------------------------------------------------------------------------------------
METHOD SetField(adbStruct) CLASS TSQLite

    Local aTSQLStruct

    Local nAT
    Local nField
    Local nFields:=Len(adbStruct)

    For nField:=1 To nFields
        IF (adbStruct[nField][DBS_TYPE]$"[D][L][N]")
            IF (Self:FieldPos(adbStruct[nField][DBS_NAME])==0)
                Loop
            EndIF
            TCSetField(;
                            @Self:cCurrentAlias,;
                            adbStruct[nField][DBS_NAME],;
                            adbStruct[nField][DBS_TYPE],;
                            adbStruct[nField][DBS_LEN],;
                            adbStruct[nField][DBS_DEC];
                  )
        EndIF
    Next nField    

    aTSQLStruct:=Self:dbStruct()
    nFields:=Len(aTSQLStruct)

    For nField:=1 To nFields
        nAT:=aScan(adbStruct,{|aField|(aField[DBS_NAME]==aTSQLStruct[nField][DBS_NAME])})
        IF (nAT>0)
            Loop
        EndIF
        IF (Self:FieldPos(adbStruct[nField][DBS_NAME])==0)
            Loop
        EndIF
        IF ("DELETED"$aTSQLStruct[nField][DBS_NAME])
            TCSetField(;
                            @Self:cCurrentAlias,;
                            aTSQLStruct[nField][DBS_NAME],;
                            "L",;
                            1,;
                            0;
                  )
        ElseIF (aTSQLStruct[nField][DBS_TYPE]$"[D][L][N]")
            TCSetField(;
                            @Self:cCurrentAlias,;
                            aTSQLStruct[nField][DBS_NAME],;
                            aTSQLStruct[nField][DBS_TYPE],;
                            aTSQLStruct[nField][DBS_LEN],;
                            aTSQLStruct[nField][DBS_DEC];
                  )
        EndIF
    Next nField

Return(Self:dbStruct())

//------------------------------------------------------------------------------------------------------
    /*
         Method:SuperClass
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Obter informacoes da Classe Pai/Mae/Superior/SuperClass,Base enfim.
    */
//------------------------------------------------------------------------------------------------------
#IFDEF __DEBUG
    METHOD SuperClass() CLASS TSQLite
    
        Local oSuperClass

        IF Empty(Self:aSuperClass[SUPER_CLASS_METH])
            oSuperClass:=FWDBAccess():New(Self:cDBMSAlias,Self:cServer,Self:nPort)
        EndIF

        Self:aSuperClass[SUPER_CLASS_METH]:=ClassMethArr(oSuperClass,.T.)  
        Self:aSuperClass[SUPER_CLASS_DATA]:=ClassDataArr(oSuperClass,.T.)  
    
        IF (ValType(oSuperClass)=="O")
            oSuperClass:=oSuperClass:Destroy()
        EndIF    
    
    Return(Self:aSuperClass)
#ENDIF

//------------------------------------------------------------------------------------------------------
    /*
         Function:TopField
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Cria a Tabela TOP_FIELD caso essa nao exista
    */
//------------------------------------------------------------------------------------------------------
Static Function TopField(oTSQLite)

    Local adbStruct
    Local aTopField

    Local lTopField:=.F.

    TCSetConn(oTSQLite:nHandle)

    BEGIN SEQUENCE

        lTopField:=(SQLiteTable(@oTSQLite,"TOP_FIELD"))
        IF (lTopField)
            BREAK
        EndIF

        adbStruct:=oTSQLite:SetStruct()

        SetTopTable(.T.)

        oTSQLite:BeginStruct()
            oTSQLite:addField("FIELD_TABLE","C",64,0)
            oTSQLite:addField("FIELD_NAME","C",32,0)
            oTSQLite:addField("FIELD_TYPE","C",02,0)
            oTSQLite:addField("FIELD_PREC","C",04,2)
            oTSQLite:addField("FIELD_DEC","D",04,0)
        oTSQLite:EndStruct()

        aTopField:=oTSQLite:SetStruct()

        lTopField:=(TableCreate(@oTSQLite,"TOP_FIELD",@aTopField))

        SetTopTable(.F.)

        oTSQLite:SetStruct(adbStruct)

    END SEQUENCE

    TCSetConn(oTSQLite:nAdvConnection)

Return(lTopField)

//------------------------------------------------------------------------------------------------------
    /*
         Function:SQLiteTable
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Verifica a Existencia de Determinada tabela do DBMS SQLite
    */
//------------------------------------------------------------------------------------------------------
Static Function SQLiteTable(oTSQLite,cTable)
    
    Local cQuery
    Local cAlias:=oTSQLite:GetNextAlias()
    
    Local lSQLiteTable:=.F.

    cQuery:="SELECT "
    cQuery+=" cast(m.type as VARCHAR(10)) AS type "
    cQuery+=","
    cQuery+=" cast(m.name as VARCHAR(10)) AS name "
    cQuery+="FROM "
    cQuery+=" sqlite_master as m "
    cQuery+=" where m.name='"+cTable+"';"

    TCSetConn(oTSQLite:nHandle)

    TCQUERY (cQuery) ALIAS (cAlias) NEW    

    lSQLiteTable:=(.NOT. (cAlias)->(Eof() .and. Bof()))

    (cAlias)->(dbCloseArea())

    TCSetConn(oTSQLite:nAdvConnection)

Return(lSQLiteTable)

//------------------------------------------------------------------------------------------------------
    /*
         Function:TableCreate
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Cria uma nova Tabela Conforme parametros
    */
//------------------------------------------------------------------------------------------------------
Static Function TableCreate(oTSQLite,cTable,adbStruct)

    Local lCreate:=.F.
    
    Local cQuery
    Local cFType
    Local cFQuery

    Local nFLen
    Local nFDec

    Local nField
    Local nFields

    TCSetConn(oTSQLite:nHandle)

    BEGIN SEQUENCE

        IF Empty(adbStruct)
            BREAK
        EndIF

        lCreate:=SQLiteTable(@oTSQLite,@cTable)
        IF (lCreate)
            BREAK
        EndIF

        cQuery:="CREATE TABLE "
        cQuery+="["+cTable+"]("

        nFields:=Len(adbStruct)
        For nField:=1 To nFields

            cFName:=adbStruct[nField][DBS_NAME]
            cFType:=adbStruct[nField][DBS_TYPE]

            nFLen:=adbStruct[nField][DBS_LEN]
            nFDec:=adbStruct[nField][DBS_DEC]
            
            cQuery+="["+cFName+"]
            cQuery+=" "
            DO CASE
            CASE (cFType$"[C][D][L]")
                cQuery+="[VARCHAR("+LTrim(Str(nFLen))+")]"
                cQuery+=" "
                cQuery+="DEFAULT"
                cQuery+=" "
                cQuery+="('"+Space(nFLen)+"')"
            CASE (cFType=="N")
                IF (nFDec==0)
                    cQuery+="[INTEGER]"
                Else
                    cQuery+="[FLOAT]"
                EndIF    
                cQuery+=" "
                cQuery+="DEFAULT"
                cQuery+=" "
                cQuery+="(0)"
            CASE (cFType=="M")
                cQuery+="[BLOB]"
                cQuery+=" "
                cQuery+="DEFAULT"
                cQuery+=" "
                cQuery+="('"+Space(nFLen)+"')"
            END CASE
            cQuery+=" "
            IF (cFName=="R_E_C_N_O_")
                cQuery+="PRIMARY KEY"
            EndIF
            cQuery+=" "
            cQuery+="NOT NULL"
            cQuery+=" "
            IF (nField < nFields)
                cQuery+=","
            EndIF
        Next nField

        cQuery+=");"

        IF !(oTSQLite:SQLExec(@cQuery)==0)
            ConOut(oTSQLite:SqlError())
            BREAK
        EndIF

        lCreate:=SQLiteTable(@oTSQLite,cTable)
        IF !(lCreate)
            BREAK
        EndIF

        IF (__lTopTable)
            BREAK
        EndIF

        IF (.NOT. SQLiteTable(@oTSQLite,"TOP_FIELD"))
            BREAK
        EndIF

        cQuery:="INSERT INTO [TOP_FIELD]("
        cQuery+="[FIELD_TABLE],"
        cQuery+="[FIELD_NAME],"
        cQuery+="[FIELD_TYPE],"
        cQuery+="[FIELD_PREC],"
        cQuery+="[FIELD_DEC]"
        cQuery+=")"
        cQuery+=" "
        cQuery+="VALUES("
        cQuery+=oTSQLite:P2SQL(cTable)
        cQuery+=","

        For nField:=1 To nFields

            cFType:=adbStruct[nField][DBS_TYPE]
            IF !(cFType$"[D][L][N]")
                Loop
            EndIF

            cFName:=adbStruct[nField][DBS_NAME]
                                                                                                        
            nFLen:=adbStruct[nField][DBS_LEN]
            nFDec:=adbStruct[nField][DBS_DEC]

            cFQuery:=oTSQLite:P2SQL(cFName)
            cFQuery+=","

            IF (cFType=="N")
                cFQuery+=oTSQLite:P2SQL("P")
            Else
                cFQuery+=oTSQLite:P2SQL(cFType)            
            EndIF

            cFQuery+=","
            cFQuery+=oTSQLite:P2SQL(LTrim(Str(nFLen)))
            cFQuery+=","
            cFQuery+=oTSQLite:P2SQL(LTrim(Str(nFDec)))
            
            cFQuery:=(cQuery+ cFQuery)
            cFQuery+=");"

            oTSQLite:SQLExec(@cFQuery)

        Next nField

    END SEQUENCE

    TCSetConn(oTSQLite:nAdvConnection)

Return(lCreate)

//------------------------------------------------------------------------------------------------------
    /*
         Function:P2SQL
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Converte os valores em ADVPL para SQL
    */
//------------------------------------------------------------------------------------------------------
Static Function P2SQL(pVal)
    Local cSQL:=""
    Local cVType:=ValType(pVal)
    DO CASE
        CASE (cVType=="N")
            cSQL:=LTrim(Str(pVal))
        CASE (cVType=="D")
            cSQL:="'"+Dtos(pVal)+"'"
        CASE (cVType$"CM")
            IF Empty(pVal)
                cSQL:="' '"
            Else
                cSQL:="'"+pVal+"'"
            EndIF
        CASE (cVType=="L")
            cSQL:=IF(pVal,"'T'","'F'")
    OTHERWISE
        cSQL:="' '"
    ENDCASE
Return(cSQL)                                         

//------------------------------------------------------------------------------------------------------
    /*
         Function:SetTopTable
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Seta a Criacao da TOP_TABLE
    */
//------------------------------------------------------------------------------------------------------
Static Function SetTopTable(lSet)
    DEFAULT lSet:=.F.
    __lTopTable:=lSet
Return(__lTopTable)

//------------------------------------------------------------------------------------------------------
    /*
         Funcao:MyIsBlind
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:Verifica se Esta em Modo Blind
    */
//------------------------------------------------------------------------------------------------------
Static Function MyIsBlind()
    Local oWnd:=GetWndDefault()
    Local lIsBlind:=(IsBlind() .or. !(ValType(oWnd)=="O"))
Return(lIsBlind)

//------------------------------------------------------------------------------------------------------
    /*
         Function:__Dummy
         Autor:Marinaldo de jesus [ www.blacktdn.com.br ]
         Data:10/06/2012
         Uso:NAO FAZ NADA
    */
//------------------------------------------------------------------------------------------------------
Static Function __Dummy(lRecursa)
    Local oException
    TRYEXCEPTION
        lRecursa:=.F.
        IF !(lRecursa)
            BREAK
        EndIF
        lRecursa:=__Dummy(.F.)
        SYMBOL_UNUSED(__cCRLF)
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return(lRecursa)
