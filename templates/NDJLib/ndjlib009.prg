#include "ndj.ch"

#DEFINE __CSXP_LOG_DIRECTORY__    "\sxplog\"
#DEFINE __TC_LINK_ATTEMPTS__    0

/*/
    Funcao:NDJSXPExp
    Autor:Marinaldo de Jesus 
    Data:28/03/2011
    Descricao:Exportar os dados do SXP local para SXP em DataBase Gerenciado pelo TopConnect
    Sintaxe:<vide parametros formais>
/*/
User Function NDJSXPExp(cEmp,cFil,lSchedule,cTopAlias,cTopServer,nTopPort)

    Local bExec
    
    Local cTitle:="Exportacao do SXP"

    Local oException
    
    TRYEXCEPTION
    
        DEFAULT lSchedule:=.F.
    
        bExec:={||;
                        IF(!(lSchedule),StaticCall(NDJLIB014,"InGrpAdmin"),.T.),;
                        ExecuteExpSXP(@cTitle,@lSchedule,@cEmp,@cFil,@cTopAlias,@cTopServer,@nTopPort),;
                        IF(!(lSchedule),MsgInfo(OemToAnsi("Exportação do SXP Finalizada"),cTitle),.T.);
       }
    
        StaticCall(NDJLIB010,Execute,cTitle,bExec,"SIGACFG",!(lSchedule),"",!(lSchedule),lSchedule)
    
    CATCHEXCEPTION USING oException
    
        ConOut(CaptureError())
    
    ENDEXCEPTION

Return(NIL)

/*/
    Funcao:NDJSchSXPExp
    Autor:Marinaldo de Jesus 
    Data:28/03/2011
    Descricao:Automacao do Processo de Exportacao de Dados
    Sintaxe:<vide parametros formais>
/*/
User Function NDJSchSXPExp(aParamUser) /*/ Array com dois elementos 1=cEmp (Codigo da Empresa),2=cFil (Codigo da Filial)  /*/

    Local bExec:={|cEmp,cFil|IF((Select("SXP")>0),SXP->(dbCloseArea()),NIL),U_NDJSXPExp(@cEmp,@cFil,.T.,@cTopAlias,@cTopServer,@nTopPort)}
    
    Local cTopAlias
    Local cTopServer
    Local nTopPort
    
    IF Empty(aParamUser)
        aParamUser:={"",""}
    EndIF
    
    IF (ValType(aParamUser)=="A")
        IF (Len(aParamUser)>=4)
            cTopAlias:=aParamUser[4]
        EndIF
        IF (Len(aParamUser)>=5)
            cTopServer:=aParamUser[5]
        EndIF
        IF (Len(aParamUser)>=6)
            nTopPort:=aParamUser[6]
        EndIF
    EndIF
    
    aAdd(aParamUser,bExec)

    IF (Select("SXP")>0)
        SXP->(dbCloseArea())
    EndIF

Return(StaticCall(NDJLib011,Scheduler,@aParamUser))

/*/
    Funcao:ExecuteExpSXP
    Autor:Marinaldo de Jesus 
    Data:28/03/2011
    Descricao:Exportar os dados do SXP local para SXP em DataBase Gerenciado pelo TopConnect
    Sintaxe:<vide parametros formais>
/*/
Static Function ExecuteExpSXP(cTitle,lSchedule,cEmp,cFil,cTopAlias,cTopServer,nTopPort)

    Begin Sequence
    
        IF !(lSchedule)
            IF (Select("SXP")>0)
                IF (SXP->(RddName())=="TOPCONN")
                    SXP->(dbCloseArea())
                    MsOpenDbf(.T.,__LocalDriver,SXPSrc(),"SXP",.T.,.F.)
                EndIF
            EndIF
            Proc2BarGauge(;
                            {||ExpSXP(@lSchedule,@cTopAlias,@cTopServer,@nTopPort)},;//Variavel do Tipo Bloco de Codigo com a Acao ser Executada
                            @cTitle,;//Variavel do Tipo Texto (Caractere/String) com o Titulo do Dialogo
                            NIL,;//Variavel do Tipo Texto (Caractere/String) com a Mensagem para a 1a. BarGauge
                            NIL,;//Variavel do Tipo Texto (Caractere/String) com a Mensagem para a 2a. BarGauge
                            .T.,;//Variavel do Tipo Logica que habilitara o botao para "Abortar" o processo
                            .T.,;//Variavel do Tipo Logica que definira o uso de controle de estimativa de tempo na 1a. BarGauge
                            .F.,;//Variavel do Tipo Logica que definira o uso de controle de estimativa de tempo 2a. BarGauge
                            .F.;//Variavel do Tipo Logica que definira se a 2a. BarGauge devera ser mostrada
                     )
            Break
        EndIF

        PREPARE ENVIRONMENT EMPRESA (cEmp) FILIAL (cFil) MODULO "CFG"

            InitPublic()

            SetsDefault()

            SetModulo("SIGACFG","CFG")

            __cInterNet:=NIL
            lMsHelpAuto:=.T.
            lMsFinalAuto:=.T.
            
            ExpSXP(@lSchedule,@cTopAlias,@cTopServer,@nTopPort)

        RESET ENVIRONMENT
    
    End Sequence

Return(NIL)

/*/
    Funcao:ExpSXP
    Autor:Marinaldo de Jesus 
    Data:28/03/2011
    Descricao:Exporta SXP To TOP
    Sintaxe:<vide parametros formais>
/*/
Static Function ExpSXP(lSchedule,cTopAlias,cTopServer,nTopPort)

    Local adbStruct
    Local aFieldPos
    
    Local bPackSXP:={||lPackSXP:=CompactSXP()}
    
    Local cTime
    Local cField
    Local cTitulo
    Local cSrcFileSXP:=SXPSrc()
    Local cTrgFileSXP:=SXPTrg()
    Local cMsgIncProc
    Local cSXPNewAlias
    
    Local lPackSXP
    
    Local nField
    Local nFields
    Local nAttempts
    Local nRecCount
    Local nTcLinkSXP
    Local nFieldPos1
    Local nFieldPos2
    
    Local uXPVal
    Local uXPANTVAL
    Local uXPNOVVAL
    
    Begin Sequence
    
        DEFAULT lSchedule:=.F.
    
        cTime:=Time()
    
        IF (lSchedule)
            ConOut("Aguarde...","Compactando "+cSrcFileSXP)
            Eval(bPackSXP)
            IF !(lPackSXP)
                ConOut("Nao foi possivel compactar o arquivo "+cSrcFileSXP)
            EndIF
        Else
            MSAguarde(bPackSXP,"Aguarde...","Compactando "+cSrcFileSXP,.F.)
            IF !(lPackSXP)
                MsgInfo(OemToAnsi("Não foi possível compactar o arquivo "+cSrcFileSXP))
            EndIF
        EndIF    
    
        IF (Select("SXP")==0)
            OpenSxs()
            IF (Select("SXP")==0)
                ConOut("Falha  na Exportacao do "+cSrcFileSXP)
                ConOut("Nao foi possivel Abir a Tabela:"+cSrcFileSXP)
                Break
            EndIF    
        EndIF
    
        DEFAULT cTopServer:=SXPTop("Server")
        DEFAULT nTopPort:=SXPTop("Port")
        DEFAULT cTopAlias:=SXPTop("Alias")
    
        IF !(lSchedule)
            IF !(GetTopSource(@cTopServer,@nTopPort,@cTopAlias))
                Break
            EndIF    
        EndIF    
    
        nAttempts:=0
        While ((nTcLinkSXP:=TcLink(@cTopAlias,@cTopServer,@nTopPort))<0)
            IF !(lSchedule)
                IF !(GetTopSource(@cTopServer,@nTopPort,@cTopAlias))
                    Break
                EndIF    
            EndIF    
            IF ((++nAttempts)>__TC_LINK_ATTEMPTS__)
                IF (lSchedule)
                    ConOut("Falha  na Exportacao do "+SXP->(dbInfo(DBI_FULLPATH)))
                    ConOut("Nao foi possivel efetuar o link com o Top Connect.")
                EndIF
                Break
            EndIF
        End While
    
        TCSetConn(@nTcLinkSXP)
    
        adbStruct:=SXP->(dbStruct())
    
        IF !(MsFile(@cTrgFileSXP,NIL,"TOPCONN"))
            IF !(MsCreate(@cTrgFileSXP,@adbStruct,"TOPCONN"))
                IF (lSchedule)
                    ConOut("Falha  na Exportacao do "+SXP->(dbInfo(DBI_FULLPATH)))
                    ConOut("Nao foi possivel criar a Tabela:"+cTrgFileSXP)
                Else
                    MsgInfo(;
                                OemToAnsi("Falha  na Exportação do "+SXP->(dbInfo(DBI_FULLPATH)));
                    +CRLF+;
                                OemToAnsi("Não foi possível criar a Tabela:"+cTrgFileSXP); 
                    )
                EndIF
                Break
            EndIF
            //Por problema na geracao da CONSTRAINT PRIMARY KEY r_e_c_n_o_ pelo TopConnect
            TcSqlExec("ALTER TABLE "+cTrgFileSXP+" DROP CONSTRAINT "+cTrgFileSXP+"_pkey;")
            //modificamos a CONSTRAINT PRIMARY KEY
            TcSqlExec("ALTER TABLE "+cTrgFileSXP+" ADD CONSTRAINT  "+cTrgFileSXP+"_pkey PRIMARY KEY (r_e_c_n_o_,d_e_l_e_t_,xp_alias,xp_oper,xp_user,xp_id,xp_data,xp_time,xp_campo);")
        EndIF
    
        cSXPNewAlias:=GetNextAlias()
        IF !(MsOpenDbf(.T.,"TOPCONN",@cTrgFileSXP,@cSXPNewAlias,.T.,.F.))
            IF (lSchedule)
                ConOut("Falha  na Exportacao do "+cSrcFileSXP)
                ConOut("Nao foi possivel abrir a Tabela:"+SXP->(dbInfo(DBI_FULLPATH)))
            EndIF
            Break
        EndIF
    
        IF !(lSchedule)
            SXP->(nRecCount:=RecCount())
            BarGauge1Set(@nRecCount)
        EndIF    

        aFieldPos:={}
        nFields:=Len(adbStruct)
        For nField:=1 To nFields
            cField:=adbStruct[ nField,DBS_NAME ]
            nFieldPos1:=SXP->(FieldPos(@cField))
            nFieldPos2:=(cSXPNewAlias)->(FieldPos(@cField))
            IF (;
                    (nFieldPos1>0);
                    .and.;
                    (nFieldPos2>0);
               )    
                aAdd(aFieldPos,{nFieldPos1,nFieldPos2})
                IF (adbStruct[nField,DBS_TYPE] $ "'D','L','N'")
                    TcSetField(cSXPNewAlias,adbStruct[nField,DBS_NAME],adbStruct[nField,DBS_TYPE],adbStruct[nField,DBS_LEN],adbStruct[nField,DBS_DEC])
                EndIF    
            EndIF    
        Next nField
    
        nFields:=Len(aFieldPos)
    
        SXP->(dbGotop())
        While SXP->(!Eof())
    
            IF !(lSchedule)
                IncPrcG1Time(NIL,;//01 -> Inicio da Mensagem
                             @nRecCount,;//02 -> Numero de Registros a Serem Processados
                             @cTime,;//03 -> Tempo Inicial
                             .F.,;//04 -> Defina se eh um processo unico ou nao (DEFAULT .T.)
                             0,;//05 -> Contador de Processos
                             1,;//06 -> Percentual para Incremento
                             NIL,;//07 -> Se Deve Incrementar a Barra ou Apenas Atualizar a Mensagem
                             .T.;//08 -> Se Forca a Atualizacao das Mensagens
                         )
                IF (lAbortPrint)
                    Break
                EndIF
            EndIF
    
            IF SXP->(!UsrRecLock("SXP",.F.,.F.))
                SXP->(dbSkip())
                Loop
            EndIF

            uXPANTVAL:=AllTrim(StaticCall(NDJLIB001,__FieldGet,"SXP","XP_NOVVAL",.T.))
            uXPNOVVAL:=AllTrim(StaticCall(NDJLIB001,__FieldGet,"SXP","XP_ANTVAL",.T.))
    
            IF !(uXPANTVAL==uXPNOVVAL)
                (cSXPNewAlias)->(dbAppend(.T.))
                For nField:=1 To nFields
                    cField:=adbStruct[ aFieldPos[ nField,1 ],DBS_NAME ]
                    uXPVal:=StaticCall(NDJLIB001,__FieldGet,"SXP",@cField,.T.)
                    StaticCall(NDJLIB001,__FieldPut,@cSXPNewAlias,@cField,@uXPVal,.T.)
                Next nField
            EndIF    

            SXP->(dbDelete())
            SXP->(MsUnLock())
            SXP->(dbSkip())

        End While
    
        IF (Select(cSXPNewAlias)>0)
            (cSXPNewAlias)->(dbCommit())
            (cSXPNewAlias)->(dbCloseArea())
        EndIF
    
        cSrcFileSXP:=SXP->(dbInfo(DBI_FULLPATH))
    
        IF (lSchedule)
            ConOut("Aguarde...","Compactando "+cSrcFileSXP)
            Eval(bPackSXP)
            IF !(lPackSXP)
                ConOut("Nao foi possivel compactar o arquivo "+cSrcFileSXP)
            EndIF
        Else
            MSAguarde(bPackSXP,"Aguarde...","Compactando "+cSrcFileSXP,.F.)
            IF !(lPackSXP)
                MsgInfo(OemToAnsi("Não foi possível compactar o arquivo "+cSrcFileSXP))
            EndIF
        EndIF    
    
        cSrcFileSXP:=SXP->(dbInfo(DBI_FULLPATH))
        
        SXP->(dbCloseArea())
    
    End Sequence

Return(NIL)

/*/
    Funcao:GetTopSource
    Autor:Marinaldo de Jesus 
    Data:28/03/2011
    Descricao:Obter os Parametros para o Link com o TopConnect
    Sintaxe:<vide parametros formais>
/*/
Static Function GetTopSource(cTopServer,nTopPort,cTopAlias)
Return(StaticCall(NDJLIB001,GetTopSource,@cTopServer,@nTopPort,@cTopAlias,"Conexão para Destino dos Dados"))

/*/
    Funcao:CompactSXP
    Autor:Marinaldo de Jesus 
    Data:28/03/2011
    Descricao:Compactar o arquivo de Logs SXP
    Sintaxe:<vide parametros formais>
/*/
Static Function CompactSXP()

    Local aFilesSXPLog
    
    Local cSXPSrc:=SXPSrc()
    Local cFileSXPLog
    Local cLowerFile
    
    Local lCompactSXP:=.T.
    
    Local nFile
    Local nFiles
    
    aFilesSXPLog:=Array(aDir(__CSXP_LOG_DIRECTORY__+"sxp*.log"))
    nFiles:=aDir(__CSXP_LOG_DIRECTORY__+"sxp*.log",@aFilesSXPLog)
    cFileSXPLog:=(cSXPSrc+Dtos(MsDate())+".log")
    
    StaticCall(NDJLIB001,DirMake,__CSXP_LOG_DIRECTORY__,10,5)
    IF !File(__CSXP_LOG_DIRECTORY__+cFileSXPLog)
        StaticCall(NDJLIB007,FileCreate,__CSXP_LOG_DIRECTORY__+cFileSXPLog)
        lCompactSXP:=StaticCall(NDJLIB015,PackSXP,cSXPSrc)
    EndIF
    
    For nFile:=1 To nFiles
        cLowerFile:=Lower(AllTrim(aFilesSXPLog[ nFile ]))
        IF (cFileSXPLog==cLowerFile)
            Loop
        ElseIF (cSXPSrc $ cLowerFile)
            StaticCall(NDJLIB007,FileErase,__CSXP_LOG_DIRECTORY__+cLowerFile)
        EndIF
    Next nFile

Return(lCompactSXP)

/*/
    Funcao:SXPSrc
    Autor:Marinaldo de Jesus 
    Data:28/03/2011
    Descricao:Retorna o Nome Original do SXP
    Sintaxe:<vide parametros formais>
/*/
Static Function SXPSrc()
Return("sxp"+cEmpAnt+"0")

/*/
    Funcao:SXPTrg
    Autor:Marinaldo de Jesus 
    Data:28/03/2011
    Descricao:Retorna o Nome de Origem do SXP
    Sintaxe:<vide parametros formais>
/*/
Static Function SXPTrg()
Return((SXPSrc()+AnoMes(MsDate())))

/*/
    Funcao:ChangeSXP
    Autor:Marinaldo de Jesus 
    Data:28/03/2011
    Descricao:Tenta Alterar o Modo de Acesso ao SXP de RDD Local para TOP
    Sintaxe:<vide parametros formais>
/*/
Static Function ChangeSXP(lCreateIndex)

    Local cSrcFileSXP:=SXPSrc()
    Local cTrgFileSXP:=SXPTrg()
    
    Local lChange:=(SXPTop("EnableSXPTop")=="1")
    Local lChanged:=.T.
    Local lSxpTopConn:=.F.
    
    Local nAttempts
    
    Local nTcLink:=AdvConnection()
    Local nTopPort:=SXPTop("Port")
    Local cTopAlias:=SXPTop("Alias")
    Local cTopServer:=SXPTop("Server")
    Local cSXPRddName:=SXP->(RddName())
    
    Local nTcLinkSXP
    
    Begin Sequence
    
        IF !(lChange)
            Break
        EndIF
    
        IF (lSxpTopConn:=(cSXPRddName=="TOPCONN"))
            Break
        EndIF
    
        IF (Select("SXP")>0)
            SXP->(dbCloseArea())
        EndIF    
    
        IF ((nTcLinkSXP:=TcLink(@cTopAlias,@cTopServer,@nTopPort))<0)
            nTcLinkSXP:=nTcLink
        EndIF
    
        IF !(TCSetConn(@nTcLinkSXP))
            Break
        EndIF
    
        ExpSXP(.T.,@cTopAlias,@cTopServer,@nTopPort)
    
        IF (Select("SXP")>0)
            SXP->(dbCloseArea())
        EndIF
    
        lSxpTopConn:=MsFile(@cTrgFileSXP,NIL,"TOPCONN")
        IF (lSxpTopConn)
            lSxpTopConn:=MsOpenDbf(.T.,"TOPCONN",@cTrgFileSXP,"SXP",.T.,.F.)
            IF (lSxpTopConn)
                DEFAULT lCreateIndex:=.F.
                IF (;
                        (Type("cModulo")=="C");
                        .and.;
                        (cModulo=="CFG");
                        .and.;
                        (lCreateIndex);
                 )    
                    SXPCreateIndex(cTrgFileSXP)
                EndIF    
            EndIF
        EndIF
    
    End Sequence
    
    IF (;
            (lChange);
            .and.;
            !(lSxpTopConn);
            .and.;
            (Select("SXP")==0);
     )    
        cSXPRddName:=IF((cSXPRddName=="TOPCONN"),__LocalDriver,cSXPRddName)
        MsOpenDbf(.T.,@cSXPRddName,@cSrcFileSXP,"SXP",.T.,.F.)
    EndIF    
    
    IF !(lChanged:=(Select("SXP")>0))
        Final(;
                OemToAnsi("Finalização do Sistema"),;
                OemToAnsi("Não Foi possível Carregar o Dicionário de Logs."),;
                .F.;
          )
    EndIF
    
    IF !(TCSetConn(@nTcLink))
    
        nTopPort:=TopGetInfo("Port")
        cTopAlias:=TopGetInfo("Alias")
        cTopServer:=TopGetInfo("Server")
    
           nAttempts:=0
        While ((nTcLink:=TcLink(@cTopAlias,@cTopServer,@nTopPort))<0)
            IF ((++nAttempts)>__TC_LINK_ATTEMPTS__)
                Final(;
                        OemToAnsi("Finalização do Sistema"),;
                        OemToAnsi("Não Foi possível Conectar ao TopConnect."),;
                        .F.;
                  )
            EndIF
        End While
    
        TCSetConn(@nTcLink)
    
    EndIF

Return(lChanged)

/*/
    Funcao:SXPTop
    Autor:Marinaldo de Jesus 
    Data:28/03/2011
    Descricao:Retorna Informacoes do INI sobre o SXP
    Sintaxe:<vide parametros formais>
/*/
Static Function SXPTop(cType)

    Local cIniFile:=GetAdv97()
    Local cEnvServer:=GetEnvServer() 
    
    Local uSXPTop
    
    Begin Sequence
    
        IF (Upper(AllTrim(cType))=="ENABLESXPTOP")
            uSXPTop:=SXPTopGetString(@cEnvServer,@cIniFile,"EnableSXPTop")
            Break
        EndIF
    
        IF (Upper(AllTrim(cType))=="SERVER")
            uSXPTop:=SXPTopGetString(@cEnvServer,@cIniFile,"Server")
            Break
        EndIF
    
        IF (Upper(AllTrim(cType))=="PORT")
            uSXPTop:=Val(SXPTopGetString(@cEnvServer,@cIniFile,"Port"))
            Break
        EndIF
    
        IF (Upper(AllTrim(cType))=="ALIAS")
            uSXPTop:=SXPTopGetString(@cEnvServer,@cIniFile,"DataBase")
            uSXPTop+="/"
            uSXPTop+=SXPTopGetString(@cEnvServer,@cIniFile,"Alias")
            Break
        EndIF
    
    End Sequence

Return(uSXPTop)

/*/
    Funcao:SXPTopGetString
    Autor:Marinaldo de Jesus 
    Data:28/03/2011
    Descricao:Retorna Informacoes do INI sobre o SXP
    Sintaxe:<vide parametros formais>
/*/
Static Function SXPTopGetString(cEnvServer,cIniFile,cSXPTopString)

    Local cSXPTopGetString:=GetPvProfString(cEnvServer,"SXPTop"+cSXPTopString,"",cIniFile)
    
    IF Empty(cSXPTopGetString)
        cSXPTopGetString:=GetPvProfString("SXPTOP","SXPTop"+cSXPTopString,"",cIniFile)
    EndIF    
    
    IF Empty(cSXPTopGetString)
        cSXPTopGetString:=GetPvProfString(cEnvServer,"Top"+cSXPTopString,"",cIniFile)
    EndIF
    
    IF Empty(cSXPTopGetString)
        cSXPTopGetString:=GetPvProfString("TopConnect",cSXPTopString,"",cIniFile)
    EndIF

Return(cSXPTopGetString)

/*/
    Funcao:TopGetInfo
    Autor:Marinaldo de Jesus 
    Data:28/03/2011
    Descricao:Retorna Informacoes do INI sobre o SXP
    Sintaxe:<vide parametros formais>
/*/
Static Function TopGetInfo(cType)
Return(StaticCall(NDJLIB001,TopGetInfo,cType))

/*/
    Funcao:SXPCreateIndex
    Autor:Marinaldo de Jesus 
    Data:28/03/2011
    Descricao:Cria Indice para o SXP
    Sintaxe:<vide parametros formais>
/*/
Static Function SXPCreateIndex(cTrgFileSXP)

    Local aOrdBag:={}
    
    Local bExec:={||SXP->(StaticCall(NDJLIB007,tbCreateIndex,"SXP","TOPCONN",@cTrgFileSXP,@aOrdBag))}
    Local bWaitExec:={||MayIIndexSXP(cSemaphore,.F.,cTrgFileSXP)}
    Local bMsgInfo:={||MayIIndexSXP(cSemaphore,.T.,cTrgFileSXP)}

    Local cTitleProc:="Tentando Obter Exclusividade na Tabela de LOG:"+cTrgFileSXP

    Local lIndexed:=.T.
    
    aAdd(;
            aOrdBag,{;
                        "XP_ALIAS+XP_ID",;// 01 - Chave do Indice String
                        {||XP_ALIAS+XP_ID},;// 02 - Chave do Indice Block
                        cTrgFileSXP+"1",;// 03 - Nome Fisico do Arquivo de Indice
                        "1",;// 04 - Ordem do Indice
                        "ALIASID";// 05 - Apelido do Indice
                    };
     )

    lIndexed:=StaticCall(NDJLIB013,SemaphoreWait,@bExec,@bWaitExec,@bMsgInfo,@cTitleProc)

Return(lIndexed)

/*/
    Funcao:MayIIndexSXP
    Autor:Marinaldo de Jesus 
    Data:28/03/2011
    Descricao:Tenta Obter Exclusividade aa rotina MayIIndexSXP
    Sintaxe:<vide parametros formais>
/*/
Static Function MayIIndexSXP(cSemaphore,lRetMsg,cTrgFileSXP)
    Local cMsg:="Outro Usuário está criando índice(s) para a Tabela de LOG:"+cTrgFileSXP
Return(StaticCAll(NDJLIB013,SemaBlock,@cSemaphore,@lRetMsg,@cMsg))

/*/
    Funcao:SXPOpenIdx
    Autor:Marinaldo de Jesus 
    Data:28/03/2011
    Descricao:Tenta abrir os Indices para o SXP quando Rotina CFGX053
    Sintaxe:<vide parametros formais>
/*/
Static Function SXPOpenIdx()

    Begin Sequence
    
        IF (;
                (;
                        (Type("ParamIxb")=="C");
                        .and.;
                        "CFGX053" $ Upper(Alltrim(ParamIxb));
             );
                .or.;
                (Upper(AllTrim(FunName()))=="CFGX053");
                .or.;
                IsInCallStack("CFGX053");
         )
            IF (Select("SXP")>0)
                IF (;
                        SXP->(RddName()=="TOPCONN");
                        .and.;
                        SXP->(IndexOrd()>=1);
                   )
                    Break
                EndIF
                SXP->(dbCloseArea())
                MsOpenDbf(.T.,__LocalDriver,SXPSrc(),"SXP",.T.,.F.)
            EndIF
            MSAguarde({||ChangeSXP(.T.)},"Aguarde...","Verificando Indice(s) para o SXP",.F.)
        EndIF

    End Sequence

Return(NIL)

Static Function __Dummy(lRecursa)
    Local oException
    TRYEXCEPTION
        lRecursa:=.F.
        IF !(lRecursa)
            BREAK
        EndIF
        SXPOpenIdx()
        lRecursa:=__Dummy(.F.)
        SYMBOL_UNUSED(__cCRLF)
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return(lRecursa)
