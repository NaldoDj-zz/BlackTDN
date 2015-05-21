#include "totvs.ch"
#include "dbstruct.ch"

Static oNDJLIB007

CLASS NDJLIB007

    DATA cClassName
    
    METHOD NEW() CONSTRUCTOR
    METHOD ClassName()
    
    METHOD MakeTmpFile(cAlias,cAliasTmp,cTempFile,bdbSeek,bWhileCond,bSkipCond,aBagName,aStructTmp,aRecnos,cRddName)
    METHOD CloseTmpFile(cAlias,cTableName,aBagName,cRddName)
    METHOD GetArrBagName(cAlias,cdbFile,cRddName)
    METHOD FileErase(cFile,nErr)
    METHOD FileCreate(cFile,nHandle,nErr)
    METHOD RetFileName(cFile)
    METHOD dbSX3Struct(cAlias,cPathFile,cRddName,aOrdBag,aFilesTemp)
    METHOD dbNewStruct(cAlias,cTable,cRddName,aOrdBag,aFilesTemp)
    METHOD dbFinalize(cAlias,cRddName,aOrdBag,cTable,lDropIndex,lRename)
    METHOD TCDropIndex(cTable,aOrdBag)
    METHOD tbCreateIndex(cAlias,cRddName,cTable,aOrdBag)
    METHOD GetOrdBag(cAlias,cTable,cRddName)
    METHOD dbGetNewStruct(cAlias)
    METHOD GetX2PathFile(cAlias,cRddName)
    
ENDCLASS

User Function DJLIB007()
    DEFAULT oNDJLIB007:=NDJLIB007():New()
Return(oNDJLIB007)

METHOD NEW() CLASS NDJLIB007
    self:ClassName()
RETURN(self)

METHOD ClassName() CLASS NDJLIB007
    self:cClassName:="NDJLIB007"
RETURN(self:cClassName)

/*/
    Funcao:MakeTmpFile
    Autor:Marinaldo de Jesus
    Data:29/01/2011
    Descricao:Cria Arquivo Temporario a Partir de um Alias
    Sintaxe:<Vide Parametros Formais>
/*/
METHOD MakeTmpFile(;
                                cAlias,;     //01->Alias aberto para a Criação do Temporario (Obrigatorio)
                                cAliasTmp,;  //02->Alias atribuido a Area de Trabalho do Temporario (Por Referencia)
                                cTempFile,;  //03->Nome do Arquivo Temporario Criado (Por Referencia)
                                bdbSeek,;    //04->Bloco para Posicionamento de Registro (Opcional)
                                bWhileCond,; //05->Bloco para a Condicao While (Opcional)
                                bSkipCond,;  //06->Bloco para a Skip de Registro (Opcional)
                                aBagName,;   //07->Indices a Serem Criados Para o Temporario (Opcional)
                                aStructTmp,; //08->Array com a Estrutura da Tabela (Opcional)
                                aRecnos,;    //09->Array com os Recnos para a Montagem do Arquivo (Opcional)
                                cRddName;    //10->Rdd Para a Criacao do Arquivo Temporario
             ) CLASS NDJLIB007

Return(MakeTmpFile(;
                                @cAlias,;     //01->Alias aberto para a Criação do Temporario (Obrigatorio)
                                @cAliasTmp,;  //02->Alias atribuido a Area de Trabalho do Temporario (Por Referencia)
                                @cTempFile,;  //03->Nome do Arquivo Temporario Criado (Por Referencia)
                                @bdbSeek,;    //04->Bloco para Posicionamento de Registro (Opcional)
                                @bWhileCond,; //05->Bloco para a Condicao While (Opcional)
                                @bSkipCond,;  //06->Bloco para a Skip de Registro (Opcional)
                                @aBagName,;   //07->Indices a Serem Criados Para o Temporario (Opcional)
                                @aStructTmp,; //08->Array com a Estrutura da Tabela (Opcional)
                                @aRecnos,;    //09->Array com os Recnos para a Montagem do Arquivo (Opcional)
                                @cRddName;    //10->Rdd Para a Criacao do Arquivo Temporario
             ))                        
STATIC Function MakeTmpFile(;
                                cAlias,;     //01->Alias aberto para a Criação do Temporario (Obrigatorio)
                                cAliasTmp,;  //02->Alias atribuido a Area de Trabalho do Temporario (Por Referencia)
                                cTempFile,;  //03->Nome do Arquivo Temporario Criado (Por Referencia)
                                bdbSeek,;    //04->Bloco para Posicionamento de Registro (Opcional)
                                bWhileCond,; //05->Bloco para a Condicao While (Opcional)
                                bSkipCond,;  //06->Bloco para a Skip de Registro (Opcional)
                                aBagName,;   //07->Indices a Serem Criados Para o Temporario (Opcional)
                                aStructTmp,; //08->Array com a Estrutura da Tabela (Opcional)
                                aRecnos,;    //09->Array com os Recnos para a Montagem do Arquivo (Opcional)
                                cRddName;    //10->Rdd Para a Criacao do Arquivo Temporario
             )                        
                        
    Local aFieldPos1:={}
    Local aFieldPos2:={}

    Local cBagName
    
    Local lMakeOk
    Local lRecnos
    
    Local nField
    Local nRecno
    Local nFields
    Local nRecnos
    
    Begin Sequence

        IF (Select(cAliasTmp)>0)
            DEFAULT cRddName:=(cAliasTmp)->(RddName())
        Else
            DEFAULT cRddName:="DBFCDXADS"
        EndIF

        DEFAULT aStructTmp:=(cAlias)->(dbStruct())
        DEFAULT cTempFile:=(CriaTrab(NIL,.F.)+IF(cRddName=="TOPCONN","",".dbf"))

        IF (MsFile(cTempFile,NIL,cRddName))
            CloseTmpFile(@cAliasTmp,@cTempFile,@aBagName,@cRddName)
        EndIF

        IF .NOT.(lMakeOk:=MsCreate(cTempFile,aStructTmp,cRddName))
            Break
        EndIF
    
        DEFAULT cAliasTmp:=GetNextAlias()
        IF .NOT.(lMakeOk:=MsOpenDbf(.T.,cRddName,cTempFile,cAliasTmp,.T.,.F.,.T.,.F.))
            Break
        EndIF
    
        DEFAULT bWhileCond:={||.T.}
        DEFAULT bSkipCond:={||.F.}
    
        nFields:=Len(aStructTmp)
        For nField:=1 To nFields
            aAdd(aFieldPos1,(cAliasTmp)->(FieldPos(aStructTmp[nField][DBS_NAME])))
            aAdd(aFieldPos2,(cAlias)->(FieldPos(aStructTmp[nField][DBS_NAME])))
        Next nPosCpo
    
        lRecnos:=(ValType(aRecnos)=="A").and.(.NOT.(Empty(aRecnos)))
    
        IF .NOT.(lRecnos)
            IF (ValType(bdbSeek)=="B")
                (cAlias)->(Eval(bdbSeek))
            Else
                (cAlias)->(dbGotop())
            EndIF
        Else
            nRecno:=0
            nRecnos:=Len(aRecnos)
        EndIF    
    
        While (;
                    IF(;
                            (lRecnos),;
                            ((++nRecno)<=nRecnos),;
                            (cAlias)->(;
                                            .NOT.(Eof());
                                            .and.;
                                            Eval(bWhileCond);
                             );
         );
 )                            
    
            IF .NOT.(lRecnos)
                IF (cAlias)->(Eval(bSkipCond))
                    (cAlias)->(dbSkip())
                    Loop
                EndIF
            Else
                (cAlias)->(dbGoto(aRecnos[nRecno]))
                IF (cAlias)->(Eof())
                    Loop
                EndIF
            EndIF    
    
            (cAliasTmp)->(dbAppend(.T.))
    
            For nField:=1 To nFields
                IF (aFieldPos2[nField]>0)
                    (cAliasTmp)->(FieldPut(aFieldPos1[nField],(cAlias)->(FieldGet(aFieldPos2[nField]))))
                EndIF    
            Next nField
    
            IF .NOT.(lRecnos)
                (cAlias)->(dbSkip())
            EndIF    
    
        End While

        IF ((ValType(aBagName)=="A").and.Empty(aBagName))
            aBagName:=GetArrBagName(@cAlias,@cTempFile,@cRddName)
        EndIF
    
        IF .NOT.(Empty(aBagName))
            (cAliasTmp)->(tbCreateIndex(cAliasTmp,RddName(),cTempFile,aBagName))
        EndIF
    
    End Sequence

RETURN(lMakeOk)

/*/
    Funcao:CloseTmpFile
    Autor:Marinaldo de Jesus
    Data:29/01/2011
    Descricao:Fechar e Apagar Temporarios Criados pela MakeTmpFile
    Sintaxe:<Vide Parametros Formais>
/*/
METHOD CloseTmpFile(cAlias,cTableName,aBagName,cRddName) CLASS NDJLIB007
Return(CloseTmpFile(@cAlias,@cTableName,@aBagName,@cRddName))
Static Function CloseTmpFile(cAlias,cTableName,aBagName,cRddName)
    Local lCloseOK:=.T.

    Begin Sequence

        IF (Select(cAlias)>0)
            DEFAULT cRddName:=(cAlias)->(RddName())
        Else
            DEFAULT cRddName:="DBFCDXADS"
        EndIF        

        IF (;
                MsFile(cTableName,NIL,cRddName);
                .or.;
                File(cTableName);
)    
            IF (;
                    (ValType(aBagName)=="A");
                    .and.;
                    .NOT.(Empty(aBagName));
                    .and.;
                    (Len(aBagName)>=1);
 )    
                IF (cRddName=="TOPCONN")
                    TCDropIndex(cTableName,aBagName)
                Else
                    IF (;
                            MsFile(cTableName,aBagName[1],cRddName);
                            .or.;
                            File(aBagName[1]);
         )
                        IF (Select(cAlias)>0)
                            (cAlias)->(dbClearIndex())
                        EndIF
                        MsErase(cTableName,aBagName[1],cRddName)
                        FileErase(aBagName[1])
                    EndIF
                EndIF
            EndIF
            IF (Select(cAlias)>0)
                (cAlias)->(dbCloseArea())
            EndIF        
            MsErase(cTableName,NIL,cRddName)
            FileErase(cTableName)
        EndIF

        lCloseOK:=.NOT.(MsFile(cTableName,NIL,cRddName).and.File(cTableName))

    End Sequence

RETURN(lCloseOK)

/*/
    Funcao:GetArrBagName
    Autor:Marinaldo de Jesus
    Data:29/01/2011
    Descricao:Obtem Array com as Ordens para o Arquivo Temporario
    Sintaxe:<Vide Parametros Formais>
/*/
METHOD GetArrBagName(cAlias,cdbFile,cRddName) CLASS NDJLIB007
RETURN(GetArrBagName(@cAlias,@cdbFile,@cRddName))
Static Function GetArrBagName(cAlias,cdbFile,cRddName)
    Local aBagName
    
    Local cBagName
    
    Local nBagName

    DEFAULT cdbFile:=CriaTrab(NIL,.F.)
    DEFAULT cRddName:=(Alias())->(RddName())

    cBagName:=RetFileName(cdbFile)+IF((cRddName=="TOPCONN"),"",RetIndExt())
    aBagName:={cBagName,{}}

    IF PosAlias("SIX",cAlias,NIL,NIL,1,.T.)
        While SIX->(INDICE==cAlias)
            aAdd(aBagName[2],Array(5))
            nBagName:=Len(aBagName[2])
               aBagName[2][nBagName][1]:=AllTrim(SIX->CHAVE)
               aBagName[2][nBagName][2]:=&("{||"+AllTrim(SIX->CHAVE)+"}")
               aBagName[2][nBagName][3]:=SIX->(INDICE+ORDEM)
               aBagName[2][nBagName][4]:=SIX->(ORDEM)
            aBagName[2][nBagName][5]:=SIX->NICKNAME
            SIX->(dbSkip())
        End While
    Else
        aAdd(aBagName[2],Array(5))
    EndIF

RETURN(aBagName)

/*/
    Funcao:FileErase
    Autor:Marinaldo de Jesus
    Data:29/01/2011
    Descricao:Exclui Arquivo e Retorna nErr por Referencia
    Sintaxe:<Vide Parametros Formais>
/*/
METHOD FileErase(cFile,nErr) CLASS NDJLIB007
Return(FileErase(@cFile,@nErr))
Static Function FileErase(cFile,nErr)

    Local lEraseOk:=.F.
    
    Local nEraseOk
    
    IF (lEraseOk:=File(cFile))
        fErase(cFile)
        nEraseOk:=0
        While (;
                    ((nErr:=fError())<> 0);
                    .and.;
                    (++nEraseOk<=3);
 )
            Sleep(100)
            IF (fErase(cFile)<> -1)
                Exit
            EndIF
        End While
        lEraseOk:=.NOT.(File(cFile))
    EndIF

RETURN(lEraseOk)

/*/
    Funcao:FileCreate
    Autor:Marinaldo de Jesus
    Data:28/03/2011
    Descricao:Cria Arquivo e Retorna nHandle e nErr por Referencia
    Sintaxe:<Vide Parametros Formais>
/*/
METHOD FileCreate(cFile,nHandle,nErr) CLASS NDJLIB007
Return(FileCreate(cFile,nHandle,nErr))
Static Function FileCreate(cFile,nHandle,nErr)

    Local lCreateOk:=.T.
    Local nCreateOk
    
    lCreateOk:=((nHandle:=fCreate(cFile))<> -1)
    nCreateOk:=0
    IF .NOT.(lCreateOk)
        While (;
                    .NOT.(lCreateOk:=((nErr:=fError())==0));
                    .and.;
                    (++nCreateOk<=3);
 )
            Sleep(100)
            IF (lCreateOk:=((nHandle:=fCreate(cFile))<> -1))
                Exit
            EndIF
        End While
    EndIF

RETURN(lCreateOk)

/*/
    Funcao:RetFileName
    Autor:Marinaldo de Jesus
    Data:29/01/2011
    Descricao:Retorna o Nome do Arquivo sem a Extensao e sem o Path
    Sintaxe:<Vide Parametros Formais>
/*/
METHOD RetFileName(cFile) CLASS NDJLIB007
Return(RetFileName(@cFile))
Static Function RetFileName(cFile)
    Local n:=rAt(".",cFile)
    Local nI:=rAt("\",cFile)
RETURN(SubStr(cFile,IF(nI>0,nI+1,1),IF(n>0,n-1,Len(cFile)-nI)))

/*/
    Funcao:dbSX3Struct
    Autor:Marinaldo de Jesus
    Data:08/11/2005
    Descricao:Atualiza a Estrutura de um arquivo de acordo com o SX3
    Sintaxe:<Vide Parametros Formais>
/*/
METHOD dbSX3Struct(cAlias,cPathFile,cRddName,aOrdBag,aFilesTemp) CLASS NDJLIB007
Return(dbSX3Struct(@cAlias,@cPathFile,@cRddName,@aOrdBag,@aFilesTemp))
Static Function dbSX3Struct(cAlias,cPathFile,cRddName,aOrdBag,aFilesTemp)
    Local lRet:=.F.
    
    DEFAULT cAlias:=Alias()
    DEFAULT cRddName:=(cAlias)->(RddName())

    Begin Sequence
    
        IF Empty(cPathFile)
            cPathFile:=GetX2PathFile(cAlias,cRddName)
            IF .NOT.(lRet:=.NOT.(Empty(cPathFile)))
                Break
            EndIF
        EndIF
    
        aOrdBag:=GetOrdBag(cAlias,cPathFile,cRddName)
        lRet:=dbNewStruct(@cAlias,@cPathFile,@cRddName,@aOrdBag,@aFilesTemp)
    
    End Sequence

RETURN(lRet)

/*/
    Funcao:dbNewStruct
    Autor:Marinaldo de Jesus
    Data:08/11/2005
    Descricao:Cria Nova Estrutura
    Sintaxe:<Vide Parametros Formais>
/*/
METHOD dbNewStruct(cAlias,cTable,cRddName,aOrdBag,aFilesTemp) CLASS NDJLIB007
Return(dbNewStruct(@cAlias,@cTable,@cRddName,@aOrdBag,@aFilesTemp))
Static Function dbNewStruct(cAlias,cTable,cRddName,aOrdBag,aFilesTemp)
    Local aNewStruct:={}
    
    Local cFileFpt
    Local cFptTemp
    Local cAliasTmp
    Local cFileTemp
    Local cTableFpt
    
    Local lRet:=.F.
    Local lTopConn
    
    DEFAULT aFilesTemp:={}
    
    Begin Sequence
    
        aNewStruct:=dbGetNewStruct(cAlias)
        IF .NOT.(lRet:=.NOT.(Empty(aNewStruct)))
            Break
        EndIF

        IF (Select(cAlias)>0)
            DEFAULT cRddName:=(cAlias)->(RddName())
            (cAlias)->(dbCloseArea())
        EndIF

        lTopConn:=(cRddName=="TOPCONN")
    
        cFileTemp:=(CriaTrab(NIL,.F.)+GetdbExtension())
        cFileTemp:=RetArq(cRddName,cFileTemp,lTopConn)
    
        IF (;
                MsFile(cFileTemp,NIL,cRddName);
                .or.;
                File(cFileTemp);
)    
            MsErase(cFileTemp,NIL,cRddName)
            FileErase(cFileTemp)
        EndIF
        
        While MsFile(cFileTemp,NIL,cRddName)
            cFileTemp:=(CriaTrab(NIL,.F.)+GetdbExtension())
            cFileTemp:=RetArq(cRddName,cFileTemp,lTopConn)
        End While
    
        dbCommitAll()
    
        IF MsFile(cTable,NIL,cRddName)
            IF .NOT.(lRet:=MsCopyFile(cTable,cFileTemp))
                Break
            EndIF
        Else
            lRet:=MsCreate(@cTable,@aNewStruct,@cRddName)
            Break
        EndIF
    
        dbCommitAll()
    
        cFileFpt:=(RetFileName(cTable)+".fpt")
        cTableFpt:=(AllTrim(SubStr(cTable,1,rAt("\",cTable)))+cFileFpt)
    
        IF File(cTableFpt)
            cFptTemp:=(RetFileName(cFileTemp)+".fpt")
            cFptTemp:=StrTran(cTableFpt,cFileFpt,cFptTemp)
            IF .NOT.(lRet:=MsCopyFile(cTableFpt,cFptTemp))
                Break
            EndIF
        EndIF
    
        dbCommitAll()
    
        cAliasTmp:=GetNextAlias()
        While (Select(cAliasTmp)>0)
            cAliasTmp:=GetNextAlias()
        End While
    
        dbUseArea(.T.,cRddName,cFileTemp,cAliasTmp,.T.,.F.)
        IF .NOT.(lRet:=(Select(cAliasTmp)>0))
            Break
        EndIF
    
        dbFinalize(@cAlias,@cRddName,@aOrdBag,@cTable,.T.,.T.,.T.)

        IF (;
                MsFile(cTable,NIL,cRddName);
                .or.;
                File(cTable);
)    
            MsErase(cTable,NIL,cRddName)
            FileErase(cTable)
            lRet:=.NOT.(MsFile(cTable,NIL,cRddName).and.File(cTable))
            IF .NOT.(lRet)
                Break
            EndIF    
        EndIF

        IF (;
                .NOT.(Empty(cTableFpt));
                .and.;
                (;
                    MsFile(cTableFpt,NIL,cRddName);
                    .or.;
                    File(cTableFpt);
 );    
)    
            MsErase(cTableFpt,NIL,cRddName)
            FileErase(cTableFpt)
            lRet:=.NOT.(MsFile(cTableFpt,NIL,cRddName).and.File(cTableFpt))
            IF .NOT.(lRet)
                MsRename(cFileTemp,cTable)
                Break
            EndIF
        EndIF
    
        IF .NOT.(lRet:=MsCreate(@cTable,@aNewStruct,@cRddName))
            IF MsRename(cFileTemp,cTable)
                IF File(cFptTemp)
                    MsRename(cFptTemp,cTableFpt)
                EndIF
            EndIF
            Break
        EndIF
    
        dbUseArea(.T.,cRddName,cTable,cAlias,.T.,.F.)
        IF .NOT.(lRet:=(Select(cAlias)>0))
            IF MsRename(cFileTemp,cTable)
                IF File(cFptTemp)
                    MsRename(cFptTemp,cTableFpt)
                EndIF
            EndIF
            Break
        EndIF
    
        aAdd(aFilesTemp,cFileTemp)
    
        IF .NOT.(Empty(cFptTemp))
            aAdd(aFilesTemp,cFptTemp)
        EndIF    
    
        lRet:=(cAlias)->(MsAppend(cTable,cFileTemp))
    
        IF (Select(cAlias)>0)
            (cAlias)->(dbCloseArea())
        EndIF
    
        IF (Select(cAliasTmp)>0)
            (cAliasTmp)->(dbCloseArea())
        EndIF
    
        IF (;
                MsFile(cFileTemp,NIL,cRddName);
                .or.;
                File(cFileTemp);
)    
            MsErase(cFileTemp,NIL,cRddName)
            FileErase(cFileTemp)
        EndIF
    
    End Sequence
    
    IF (;
            .NOT.(Empty(cFileTemp));
            .and.;
            (;
                MsFile(cFileTemp,NIL,cRddName);
                .or.;
                File(cFileTemp);
);    
)    
        MsErase(cFileTemp,NIL,cRddName)
        FileErase(cFileTemp)
    EndIF
    
    IF (;
            .NOT.(Empty(cFptTemp));
            .and.;
            (;
                MsFile(cFptTemp,NIL,cRddName);
                .or.;
                File(cFptTemp);
);    
)    
        MsErase(cFptTemp,NIL,cRddName)
        FileErase(cFptTemp)
    EndIF
    
    dbCommitAll()

RETURN(lRet)

/*/
    Funcao:dbFinalize
    Autor:Marinaldo de Jesus
    Data:08/11/2005
    Descricao:Finaliza os Arquivos e os Indices
    Sintaxe:<Vide Parametros Formais>
/*/
METHOD dbFinalize(cAlias,cRddName,aOrdBag,cTable,lDropIndex,lRename) CLASS NDJLIB007
RETURN(dbFinalize(@cAlias,@cRddName,@aOrdBag,@cTable,@lDropIndex,@lRename))
Static Function dbFinalize(cAlias,cRddName,aOrdBag,cTable,lDropIndex,lRename)

    Local lFinal:=.F.
    Local lTopConn:=(cRddName=="TOPCONN")
    Local cBagName:=(FileNoExt(cTable)+RetIndExt())
    
    DEFAULT lDropIndex:=.F.
    DEFAULT lRename:=.F.
    
    IF .NOT.(lDropIndex)
    
        IF (Select(cAlias)>0)
            (cAlias)->(dbCloseArea())
        EndIF    
    
        lFinal:=ChkFile(cAlias,.F.)
    
    ElseIF (lDropIndex.and..NOT.(Empty(aOrdBag)))
    
        Begin Sequence
    
            IF (Select(cAlias)>0)
                (cAlias)->(dbClearIndex())
            EndIF    
    
            #IFDEF BTV
                IF (lRename)
                    Break
                Else
                    IF .NOT.(lTopConn)
                        MsErase(cTable,cBagName,cRddName)
                        FileErase(cBagName)
                        lFinal:=.NOT.(MsFile(cTable,cBagName,cRddName).and.File(cBagName))
                    Else
                        lFinal:=TCDropIndex(cTable,aOrdBag)
                    EndIF
                EndIF
            #ELSE
                #IFDEF CTREE
                    IF (lRename)
                        Break
                    Else
                        IF .NOT.(lTopConn)
                            MsErase(cTable,cBagName,cRddName)
                            FileErase(cBagName)
                            lFinal:=.NOT.(MsFile(cTable,cBagName,cRddName).and.File(cBagName))
                        Else
                            lFinal:=TCDropIndex(cTable,aOrdBag)
                        EndIF    
                    EndIF
                #ELSE
                    IF .NOT.(lTopConn)
                        IF (;
                                MsFile(cTable,cBagName,cRddName);
                                .or.;
                                File(cBagName);
             )    
                            MsErase(cTable,cBagName,cRddName)
                            FileErase(cBagName)
                            lFinal:=.NOT.(MsFile(cTable,cBagName,cRddName).and.File(cBagName))
                        EndIF
                    Else
                        lFinal:=TCDropIndex(cTable,aOrdBag)
                    EndIF
                #ENDIF
            #ENDIF    
    
        End Sequence
        
    EndIF

RETURN(lFinal)

/*/
    Funcao:TCDropIndex
    Autor:Marinaldo de Jesus
    Data:08/11/2005
    Descricao:Drop dos Indices
    Sintaxe:<Vide Parametros Formais>
/*/
METHOD TCDropIndex(cTable,aOrdBag) CLASS NDJLIB007
RETURN(TCDropIndex(@cTable,@aOrdBag))
Static Function TCDropIndex(cTable,aOrdBag)

    Local cQuery:=""
    Local cTcGetDb:=""
    Local cTcSrvType:=Upper(AllTrim(TcSrvType()))
    
    Local lDroped:=.T.
    Local lAS400:=(cTcSrvType=="AS/400")
    
    Local nBag:=0
    Local nBags:=0
    
    nBags:=Len(aOrdBag[2])
    cTcGetDb:=Upper(AllTrim(TcGetDb()))
    
    For nBag:=1 To nBags
        IF TcCanOpen(cTable,aOrdBag[2][nBag][3])
            IF .NOT.(lAS400)
                IF .NOT.(cTcGetDb$"ORACLE/INFORMIX")
                    cQuery:=("Drop Index "+cTable+"."+aOrdBag[2][nBag][3])
                Else
                    cQuery:=("Drop Index "+aOrdBag[2][nBag][3])
                EndIF
                   lDroped:=(TcSqlExec(cQuery)==0)
            Else
                lDroped:=MsErase(cTable,aOrdBag[2][nBag][3],"TOPCONN")
            EndIF
        EndIF
    Next nBag

    TcRefresh(cTable)

RETURN(lDroped)

/*/
    Funcao:tbCreateIndex
    Autor:Marinaldo de Jesus
    Data:08/11/2005
    Descricao:Cria os Indices
    Sintaxe:<Vide Parametros Formais>
/*/
METHOD tbCreateIndex(cAlias,cRddName,cTable,aOrdBag) CLASS NDJLIB007
RETURN(tbCreateIndex(@cAlias,@cRddName,@cTable,@aOrdBag))
Static Function tbCreateIndex(cAlias,cRddName,cTable,aOrdBag)

    Local cBagName

    Local lIndexOK:=.F.
    Local lTopConn

    Local nBag:=0
    Local nBags:=0

    DEFAULT cRddName:=(cAlias)->(RddName())

    lTopConn:=(cRddName=="TOPCONN")
    cBagName:=(RetFileName(FileNoExt(aOrdBag[1]))+IF(lTopConn,"",RetIndExt()))
    aOrdBag[1]:=cBagName

    nBags:=Len(aOrdBag[2])
    For nBag:=1 To nBags
        IF .NOT.((cAlias)->(MsFile(cBagName,aOrdBag[2][nBag][3],cRddName)))
             IF (lTopConn)
                 (cAlias)->(dbCreateIndex(aOrdBag[2][nBag][3],aOrdBag[2][nBag][1],aOrdBag[2][nBag][2],IF(.F.,.T.,NIL)))
             Else
                (cAlias)->(OrdCreate(cBagName,aOrdBag[2][nBag][3],aOrdBag[2][nBag][1],aOrdBag[2][nBag][2],IF(.F.,.T.,NIL)))
             EndIF
         EndIF
    Next nBag
    
    (cAlias)->(dbClearIndex())

    For nBag:=1 To nBags
        IF (lTopConn)
            (cAlias)->(dbSetIndex(aOrdBag[2][nBag][3]))
            (cAlias)->(OrdListAdd(aOrdBag[2][nBag][3],aOrdBag[2][nBag][3]))
        Else
            (cAlias)->(OrdListAdd(cBagName,aOrdBag[2][nBag][3]))
        EndIF
        (cAlias)->(dbSetNickName(aOrdBag[2][nBag][3],aOrdBag[2][nBag][5]))
    Next nBag

    For nBag:=1 To nBags
        lIndexOK:=(cAlias)->(MsFile(cTable,aOrdBag[2][nBag][3],cRddName))
        IF .NOT.(lIndexOK)
            BREAK
        EndIF
    Next nBag

    IF (lIndexOK)
        (cAlias)->(dbSetorder(1))
    EndIF    
    
RETURN(lIndexOK)

/*/
    Funcao:GetOrdBag
    Autor:Marinaldo de Jesus
    Data:08/11/2005
    Descricao:Retorna a bolsa de ordens
    Sintaxe:<Vide Parametros Formais>
/*/
METHOD GetOrdBag(cAlias,cTable,cRddName) CLASS NDJLIB007
RETURN(GetArrBagName(@cAlias,@cTable,@cRddName))

/*/
    Funcao:dbGetNewStruct
    Autor:Marinaldo de Jesus
    Data:08/11/2005
    Descricao:Obtem a Estrutura do SX3 para a Criacao do Arquivo
    Sintaxe:<Vide Parametros Formais>
/*/
METHOD dbGetNewStruct(cAlias) CLASS NDJLIB007
RETURN(dbGetNewStruct(@cAlias))
Static Function dbGetNewStruct(cAlias)

    Local aNewStruct:={}
    
    SX3->(dbSetOrder(1))
    IF SX3->(dbSeek(cAlias))
        While SX3->(.NOT.(Eof()).and.X3_ARQUIVO==cAlias)
            IF .NOT.(Upper(AllTrim(SX3->X3_CONTEXT))=="V")
                SX3->(aAdd(aNewStruct,{AllTrim(X3_CAMPO),X3_TIPO,X3_TAMANHO,X3_DECIMAL}))
            EndIF
            SX3->(dbSkip())
        End While
    EndIF

RETURN(aNewStruct)

/*/
    Funcao:GetX2PathFile
    Autor:Marinaldo de Jesus
    Data:08/11/2005
    Descricao:Obtem o Caminho completo de Uma Tabela do Siga baseado no X2
    Sintaxe:<Vide Parametros Formais>
/*/
METHOD GetX2PathFile(cAlias,cRddName) CLASS NDJLIB007
RETURN(GetX2PathFile(@cAlias,@cRddName))
Static Function GetX2PathFile(cAlias,cRddName)

    Local cPathFile
    Local lTopConn

    DEFAULT cAlias:=Alias()
    IF (GetCache("SX2",cAlias,NIL,NIL,1,.F.))
        cPathFile:=AllTrim(GetCache("SX2",cAlias,NIL,"X2_PATH",1,.F.))
        IF .NOT.(SubStr(cPathFile,-1)=="\")
            cPathFile+="\"
        EndIF
        cPathFile+=AllTrim(GetCache("SX2",cAlias,NIL,"X2_ARQUIVO",1,.F.))
        DEFAULT cRddName:=(cAlias)->(RddName())
        lTopConn:=(cRddName=="TOPCONN")
        cPathFile:=RetArq(cRddName,cPathFile,lTopConn)
    EndIF

RETURN(cPathFile)

#include "tryexception.ch"
