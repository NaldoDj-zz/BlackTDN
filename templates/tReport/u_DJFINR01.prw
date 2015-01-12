#include "totvs.ch"
#include "tryexception.ch"
//------------------------------------------------------------------------------------------------
Static _cSA2F3Ret
//------------------------------------------------------------------------------------------------
Static _nPGPx2Prn:=0.0695

//------------------------------------------------------------------------------------------------
    /*
        Programa:u_DJFINR01.prw
        Funcao:u_DJFINR01()
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:01/01/2015
        Descricao:Autorização para emissão de DOC/TED
    */
//------------------------------------------------------------------------------------------------
User Function DJFINR01()

    //------------------------------------------------------------------------------------------------
        //Define Array que armazenara informações de LOG
    //------------------------------------------------------------------------------------------------
    Local aLogCab:=Array(0)
    Local aLogDet:=Array(0)
    Local aLogAll

    //------------------------------------------------------------------------------------------------
        //Define Array que armazenara os Recnos que não serão impressos
    //------------------------------------------------------------------------------------------------
    Local aNotPrint:=Array(0)

    //------------------------------------------------------------------------------------------------
        //Salva "Ponteiros" de Entrada
    //------------------------------------------------------------------------------------------------
    Local aArea:=GetArea()

    //------------------------------------------------------------------------------------------------
        //Define Objeto que conterá o Retorno da ParamBox
    //------------------------------------------------------------------------------------------------
    Local oReportQst:=tHash():New()

    //------------------------------------------------------------------------------------------------
        //Define Hash que armazenara informações de LOG
    //------------------------------------------------------------------------------------------------
    Local oLog:=tHash():New()

    Local cLogT
    Local cAlias

    //------------------------------------------------------------------------------------------------
        //Verifica as Perguntas do Relatório
    //------------------------------------------------------------------------------------------------
    Local lRPrint:=ReportQst(@oReportQst)

    Local nD
    Local nJ
    Local nRecCount

    Private cCadastro:=OemToAnsi("Autorização para emissão de DOC/TED")

    BEGIN SEQUENCE

        //------------------------------------------------------------------------------------------------
            //Se não Confirmou os Parâmetros para a Emissão do Relatório...
        //------------------------------------------------------------------------------------------------
        IF .NOT.(lRPrint)
            //------------------------------------------------------------------------------------------------
                //...Abandona
            //------------------------------------------------------------------------------------------------
            BREAK
        ENDIF

        //------------------------------------------------------------------------------------------------
            //Obtem um Alias Valido para a Montagem da View
        //------------------------------------------------------------------------------------------------
        cAlias:=GetNextAlias()

        //------------------------------------------------------------------------------------------------
            //Inicializa Hash que armazenara informações de LOG
        //------------------------------------------------------------------------------------------------
        oLog:Set("VALOR",Array(0))
        oLog:Set("BANCO",Array(0))

        //------------------------------------------------------------------------------------------------
            //Elabora a View Conforme Filtro e retorna numero de Registros a serem impressos
        //------------------------------------------------------------------------------------------------
        MsAguarde({||nRecCount:=ReportView(@cAlias,@oReportQst,@oLog,@aNotPrint)},"Selecionando dados no SGBD","Aguarde...")

        //------------------------------------------------------------------------------------------------
            //Verifica se Existem informações a Serem Impressas e...
        //------------------------------------------------------------------------------------------------
        lRPrint:=(nRecCount>0)
        //------------------------------------------------------------------------------------------------
            //...Se não existir...
        //------------------------------------------------------------------------------------------------
        IF .NOT.(lRPrint)
            //------------------------------------------------------------------------------------------------
                //...Avisa ao usuário e...
            //------------------------------------------------------------------------------------------------
            ApMsgInfo("Não existem dados a serem impressos",ProcName())
            //------------------------------------------------------------------------------------------------
                //...Abandona
            //------------------------------------------------------------------------------------------------
            BREAK
        ENDIF

        //------------------------------------------------------------------------------------------------
            //Emite o Relatório
        //------------------------------------------------------------------------------------------------
        lRPrint:=DJFINR01(@cAlias,@oReportQst,@nRecCount,@aNotPrint)

        //------------------------------------------------------------------------------------------------
            //Libera a View da Memória
        //------------------------------------------------------------------------------------------------
        IF (Select(cAlias)>0)
            (cAlias)->(dbCloseArea())
        EndIF

    END SEQUENCE

    //------------------------------------------------------------------------------------------------
        //Se existirem informações de LOG...
    //------------------------------------------------------------------------------------------------
    aLogAll:=oLog:GetAllSessions()
    nJ:=Len(aLogAll)
    For nD:=1 To nJ
        cLogT:=aLogAll[nD]
        IF .NOT.(Empty(oLog:Get(cLogT)))
            //------------------------------------------------------------------------------------------------
                //Prepara o LOG
            //------------------------------------------------------------------------------------------------
            aAdd(aLogCab,"Log de Ocorrências ["+cLogT+"]")
            aAdd(aLogDet,oLog:Get(cLogT))
        EndIF
    Next nD
    //------------------------------------------------------------------------------------------------
        //Se Algum LOG foi Preparado...
    //------------------------------------------------------------------------------------------------
    IF .NOT.(Empty(aLogCab))
        //------------------------------------------------------------------------------------------------
            //...Mostra-o ao usuário
        //------------------------------------------------------------------------------------------------
        TRY EXCEPTION
            cLogT:="LOG: "+cCadastro
            fMakeLog(@aLogDet,@aLogCab,NIL,.T.,NIL,@cLogT,NIL,NIL,NIL,.F.)
        CATCH EXCEPTION USING oException
            cLogT:="Problema na Geração do LOG."
            IF (ValType(oException=="O"))
                cLogT+=CRLF
                cLogT+=CRLF
                cLogT+=oException:Description
                //-------------------------------------------------------------------------------------
                    //Salva o Erro
                //-------------------------------------------------------------------------------------
                IF .NOT.(IsBlind())
                    MemoWrite(GetTempPath()+"ReportLog_u_DJFINR01.err",CaptureError())
                EndIF
            EndIF
            ApMsgAlert(cLogT,ProcName())
        END EXCEPTION
    EndIF

    //------------------------------------------------------------------------------------------------
        //Restaura "Ponteiros" de Entrada
    //------------------------------------------------------------------------------------------------
    RestArea(aArea)

Return(lRPrint)

//------------------------------------------------------------------------------------------------
    /*
        Programa:u_DJFINR01.prw
        Funcao:DJFINR01()
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:01/01/2015
        Descricao:Autorização para emissão de DOC/TED
    */
//------------------------------------------------------------------------------------------------
Static Function DJFINR01(cAlias,oReportQst,nRecCount,aNotPrint)
    Local oReport:=ReportDef(@cAlias,@oReportQst,@aNotPrint)
    //------------------------------------------------------------------------------------------------
        //Define o Numero de Elementos para a Regua de Processamento
    //------------------------------------------------------------------------------------------------
    oReport:SetMeter(nRecCount)
//------------------------------------------------------------------------------------------------
    //Ativa a Interface com o Usuário e Inicia a Impressão do Relatório
//------------------------------------------------------------------------------------------------
Return(oReport:PrintDialog())

//------------------------------------------------------------------------------------------------
    /*
        Programa:u_DJFINR01.prw
        Funcao:ReportQst()
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:01/01/2015
        Descricao:Autorização para emissão de DOC/TED
    */
//------------------------------------------------------------------------------------------------
Static Function ReportQst(oReportQst)

    //------------------------------------------------------------------------------------------------

    Local aRadio:=Array(0)
    Local aPBoxPrm:=Array(0)
    Local aPBoxRet:=Array(0)

    //------------------------------------------------------------------------------------------------

    Local cSizeFil
    Local cSizeFor
    Local cSizeLoj
    Local cSizeRem
    Local cSizeBco
    Local cSizeAge
    Local cSizeCta
    Local cSizeDvC

    //------------------------------------------------------------------------------------------------

    Local dSizeEmi
    Local dSizeVct

    //------------------------------------------------------------------------------------------------

    Local lParamBox:=.F.

    //------------------------------------------------------------------------------------------------

    Local nPBox

    //------------------------------------------------------------------------------------------------

    Local nSizeFil:=FWSizeFilial()
    Local nSizeFor:=GetSx3Cache("E2_FORNECE","X3_TAMANHO")
    Local nSizeLoj:=GetSx3Cache("E2_LOJA","X3_TAMANHO")
    Local nSizeEmi:=GetSx3Cache("E2_EMISSAO","X3_TAMANHO")
    Local nSizeVct:=GetSx3Cache("E2_VENCTO","X3_TAMANHO")
    Local nSizeRem:=nSizeFil
    Local nSizeBco:=GetSx3Cache("A6_COD","X3_TAMANHO")
    Local nSizeAge:=GetSx3Cache("A6_AGENCIA","X3_TAMANHO")
    Local nSizeCta:=GetSx3Cache("A6_NUMCON","X3_TAMANHO")
    Local nSizeDvC:=GetSx3Cache("A6_DVCTA","X3_TAMANHO")

    //------------------------------------------------------------------------------------------------

    Local nGSizeFil:=nSizeFil+100
    Local nGSizeFor:=nSizeFor+100
    Local nGSizeLoj:=nSizeLoj+100
    Local nGSizeEmi:=nSizeEmi+100
    Local nGSizeVct:=nSizeVct+100
    LocaL nGSizeRem:=nSizeRem+100
    LocaL nGSizeBco:=nSizeBco+100
    LocaL nGSizeAge:=nSizeAge+100
    LocaL nGSizeCta:=nSizeCta+100
    Local nGSizeDvC:=nSizeDvC+100

    //------------------------------------------------------------------------------------------------
    cSizeFil:=Space(nSizeFil)
    cSizeFor:=Space(nSizeFor)
    cSizeLoj:=Space(nSizeLoj)
    cSizeRem:=Space(nSizeRem)
    cSizeBco:=Space(nSizeBco)
    cSizeAge:=Space(nSizeAge)
    cSizeCta:=Space(nSizeCta)
    cSizeDvC:=Space(nSizeDvC)
    //------------------------------------------------------------------------------------------------
    dSizeEmi:=CtoD("")
    dSizeVct:=dSizeEmi
    //------------------------------------------------------------------------------------------------

    //------------------------------------------------------------------------------------------------
        //Carrega as Perguntas do Programa
    //------------------------------------------------------------------------------------------------
    aAdd(aPBoxPrm,Array(9))
    nPBox:=Len(aPBoxPrm)
    //01----------------------------------------------------------------------------------------------
    aPBoxPrm[nPBox][1]:=1                       //[1]:1 - MsGet
    aPBoxPrm[nPBox][2]:="Filial De"             //[2]:Descricao
    aPBoxPrm[nPBox][3]:=cSizeFil                //[3]:String contendo o inicializador do campo
    aPBoxPrm[nPBox][4]:=""                      //[4]:String contendo a Picture do campo
    aPBoxPrm[nPBox][5]:="AllWaysTrue()"         //[5]:String contendo a validacao
    aPBoxPrm[nPBox][6]:="SM0"                   //[6]:Consulta F3
    aPBoxPrm[nPBox][7]:="AllWaysTrue()"         //[7]:String contendo a validacao When
    aPBoxPrm[nPBox][8]:=nGSizeFil               //[8]:Tamanho do MsGet
    aPBoxPrm[nPBox][9]:=.F.                     //[9]:Flag .T./.F. Parametro Obrigatorio ?
    //------------------------------------------------------------------------------------------------
    aAdd(aPBoxPrm,Array(9))
    nPBox:=Len(aPBoxPrm)
    //02----------------------------------------------------------------------------------------------
    aPBoxPrm[nPBox][1]:=1                       //[1]:1 - MsGet
    aPBoxPrm[nPBox][2]:="Filial Ate"            //[2]:Descricao
    aPBoxPrm[nPBox][3]:=cSizeFil                //[3]:String contendo o inicializador do campo
    aPBoxPrm[nPBox][4]:=""                      //[4]:String contendo a Picture do campo
    aPBoxPrm[nPBox][5]:="NaoVazio()"            //[5]:String contendo a validacao
    aPBoxPrm[nPBox][6]:="SM0"                   //[6]:Consulta F3
    aPBoxPrm[nPBox][7]:="AllWaysTrue()"         //[7]:String contendo a validacao When
    aPBoxPrm[nPBox][8]:=nGSizeFil               //[8]:Tamanho do MsGet
    aPBoxPrm[nPBox][9]:=.T.                     //[9]:Flag .T./.F. Parametro Obrigatorio ?
    //------------------------------------------------------------------------------------------------
    aAdd(aPBoxPrm,Array(9))
    nPBox:=Len(aPBoxPrm)
    //03----------------------------------------------------------------------------------------------
    aPBoxPrm[nPBox][1]:=1                       //[1]:1 - MsGet
    aPBoxPrm[nPBox][2]:="Fornecedor De"         //[2]:Descricao
    aPBoxPrm[nPBox][3]:=cSizeFor                //[3]:String contendo o inicializador do campo
    aPBoxPrm[nPBox][4]:=""                      //[4]:String contendo a Picture do campo
    aPBoxPrm[nPBox][5]:="AllWaysTrue()"         //[5]:String contendo a validacao
    aPBoxPrm[nPBox][6]:="SA2"                   //[6]:Consulta F3
    aPBoxPrm[nPBox][7]:="AllWaysTrue()"         //[7]:String contendo a validacao When
    aPBoxPrm[nPBox][8]:=nGSizeFor               //[8]:Tamanho do MsGet
    aPBoxPrm[nPBox][9]:=.F.                     //[9]:Flag .T./.F. Parametro Obrigatorio ?
    //------------------------------------------------------------------------------------------------
    aAdd(aPBoxPrm,Array(9))
    nPBox:=Len(aPBoxPrm)
    //04----------------------------------------------------------------------------------------------
    aPBoxPrm[nPBox][1]:=1                       //[1]:1 - MsGet
    aPBoxPrm[nPBox][2]:="Loja De"               //[2]:Descricao
    aPBoxPrm[nPBox][3]:=cSizeLoj                //[3]:String contendo o inicializador do campo
    aPBoxPrm[nPBox][4]:=""                      //[4]:String contendo a Picture do campo
    aPBoxPrm[nPBox][5]:="AllWaysTrue()"         //[5]:String contendo a validacao
    aPBoxPrm[nPBox][6]:=""                      //[6]:Consulta F3
    aPBoxPrm[nPBox][7]:="AllWaysTrue()"         //[7]:String contendo a validacao When
    aPBoxPrm[nPBox][8]:=nGSizeLoj               //[8]:Tamanho do MsGet
    aPBoxPrm[nPBox][9]:=.F.                     //[9]:Flag .T./.F. Parametro Obrigatorio ?
    //------------------------------------------------------------------------------------------------
    aAdd(aPBoxPrm,Array(9))
    nPBox:=Len(aPBoxPrm)
    //05----------------------------------------------------------------------------------------------
    aPBoxPrm[nPBox][1]:=1                       //[1]:1 - MsGet
    aPBoxPrm[nPBox][2]:="Fornecedor Ate"        //[2]:Descricao
    aPBoxPrm[nPBox][3]:=cSizeFor                //[3]:String contendo o inicializador do campo
    aPBoxPrm[nPBox][4]:=""                      //[4]:String contendo a Picture do campo
    aPBoxPrm[nPBox][5]:="NaoVazio()"            //[5]:String contendo a validacao
    aPBoxPrm[nPBox][6]:="SA2"                   //[6]:Consulta F3
    aPBoxPrm[nPBox][7]:="AllWaysTrue()"         //[7]:String contendo a validacao When
    aPBoxPrm[nPBox][8]:=nGSizeFor               //[8]:Tamanho do MsGet
    aPBoxPrm[nPBox][9]:=.T.                     //[9]:Flag .T./.F. Parametro Obrigatorio ?
    //------------------------------------------------------------------------------------------------
    aAdd(aPBoxPrm,Array(9))
    nPBox:=Len(aPBoxPrm)
    //06----------------------------------------------------------------------------------------------
    aPBoxPrm[nPBox][1]:=1                       //[1]:1 - MsGet
    aPBoxPrm[nPBox][2]:="Loja Ate"              //[2]:Descricao
    aPBoxPrm[nPBox][3]:=cSizeLoj                //[3]:String contendo o inicializador do campo
    aPBoxPrm[nPBox][4]:=""                      //[4]:String contendo a Picture do campo
    aPBoxPrm[nPBox][5]:="NaoVazio()"            //[5]:String contendo a validacao
    aPBoxPrm[nPBox][6]:=""                      //[6]:Consulta F3
    aPBoxPrm[nPBox][7]:="AllWaysTrue()"         //[7]:String contendo a validacao When
    aPBoxPrm[nPBox][8]:=nGSizeLoj               //[8]:Tamanho do MsGet
    aPBoxPrm[nPBox][9]:=.T.                     //[9]:Flag .T./.F. Parametro Obrigatorio ?
    //------------------------------------------------------------------------------------------------
    aAdd(aPBoxPrm,Array(9))
    nPBox:=Len(aPBoxPrm)
    //07----------------------------------------------------------------------------------------------
    aPBoxPrm[nPBox][1]:=1                       //[1]:1 - MsGet
    aPBoxPrm[nPBox][2]:="Emissao De"            //[2]:Descricao
    aPBoxPrm[nPBox][3]:=dSizeEmi                //[3]:String contendo o inicializador do campo
    aPBoxPrm[nPBox][4]:=""                      //[4]:String contendo a Picture do campo
    aPBoxPrm[nPBox][5]:="AllWaysTrue()"         //[5]:String contendo a validacao
    aPBoxPrm[nPBox][6]:=""                      //[6]:Consulta F3
    aPBoxPrm[nPBox][7]:="AllWaysTrue()"         //[7]:String contendo a validacao When
    aPBoxPrm[nPBox][8]:=nGSizeEmi               //[8]:Tamanho do MsGet
    aPBoxPrm[nPBox][9]:=.F.                     //[9]:Flag .T./.F. Parametro Obrigatorio ?
    //------------------------------------------------------------------------------------------------
    aAdd(aPBoxPrm,Array(9))
    nPBox:=Len(aPBoxPrm)
    //08----------------------------------------------------------------------------------------------
    aPBoxPrm[nPBox][1]:=1                       //[1]:1 - MsGet
    aPBoxPrm[nPBox][2]:="Emissao Ate"           //[2]:Descricao
    aPBoxPrm[nPBox][3]:=dSizeEmi                //[3]:String contendo o inicializador do campo
    aPBoxPrm[nPBox][4]:=""                      //[4]:String contendo a Picture do campo
    aPBoxPrm[nPBox][5]:="NaoVazio()"            //[5]:String contendo a validacao
    aPBoxPrm[nPBox][6]:=""                      //[6]:Consulta F3
    aPBoxPrm[nPBox][7]:="AllWaysTrue()"         //[7]:String contendo a validacao When
    aPBoxPrm[nPBox][8]:=nGSizeEmi               //[8]:Tamanho do MsGet
    aPBoxPrm[nPBox][9]:=.T.                     //[9]:Flag .T./.F. Parametro Obrigatorio ?
    //------------------------------------------------------------------------------------------------
    aAdd(aPBoxPrm,Array(9))
    nPBox:=Len(aPBoxPrm)
    //09----------------------------------------------------------------------------------------------
    aPBoxPrm[nPBox][1]:=1                       //[1]:1 - MsGet
    aPBoxPrm[nPBox][2]:="Vencimento De"         //[2]:Descricao
    aPBoxPrm[nPBox][3]:=dSizeVct                //[3]:String contendo o inicializador do campo
    aPBoxPrm[nPBox][4]:=""                      //[4]:String contendo a Picture do campo
    aPBoxPrm[nPBox][5]:="AllWaysTrue()"         //[5]:String contendo a validacao
    aPBoxPrm[nPBox][6]:=""                      //[6]:Consulta F3
    aPBoxPrm[nPBox][7]:="AllWaysTrue()"         //[7]:String contendo a validacao When
    aPBoxPrm[nPBox][8]:=nGSizeVct               //[8]:Tamanho do MsGet
    aPBoxPrm[nPBox][9]:=.F.                     //[9]:Flag .T./.F. Parametro Obrigatorio ?
    //------------------------------------------------------------------------------------------------
    aAdd(aPBoxPrm,Array(9))
    nPBox:=Len(aPBoxPrm)
    //10----------------------------------------------------------------------------------------------
    aPBoxPrm[nPBox][1]:=1                       //[1]:1 - MsGet
    aPBoxPrm[nPBox][2]:="Vencimento Ate"        //[2]:Descricao
    aPBoxPrm[nPBox][3]:=dSizeVct                //[3]:String contendo o inicializador do campo
    aPBoxPrm[nPBox][4]:=""                      //[4]:String contendo a Picture do campo
    aPBoxPrm[nPBox][5]:="NaoVazio()"            //[5]:String contendo a validacao
    aPBoxPrm[nPBox][6]:=""                      //[6]:Consulta F3
    aPBoxPrm[nPBox][7]:="AllWaysTrue()"         //[7]:String contendo a validacao When
    aPBoxPrm[nPBox][8]:=nGSizeVct               //[8]:Tamanho do MsGet
    aPBoxPrm[nPBox][9]:=.T.                     //[9]:Flag .T./.F. Parametro Obrigatorio ?
    //------------------------------------------------------------------------------------------------
    aAdd(aPBoxPrm,Array(8))
    nPBox:= Len(aPBoxPrm)
    //------------------------------------------------------------------------------------------------
    aSize(aRadio,0)
    aAdd(aRadio,"1-Sim")
    aAdd(aRadio,"2-Não" )
    //11----------------------------------------------------------------------------------------------
    aPBoxPrm[nPBox][1]:=3                       //[1]:3 - Radio
    aPBoxPrm[nPBox][2]:="Filtrar Fornecedor"    //[2]:Descricao
    aPBoxPrm[nPBox][3]:=2                       //[3]:Numerico contendo a opcao inicial do Radio
    aPBoxPrm[nPBox][4]:=aClone(aRadio)          //[4]:Array contendo as opcoes do Radio
    aPBoxPrm[nPBox][5]:=100                     //[5]:Tamanho do Radio
    aPBoxPrm[nPBox][6]:="AllWaysTrue()"         //[6]:Valicacao
    aPBoxPrm[nPBox][7]:=.T.                     //[7]:Flag .T./.F. Par?metro Obrigatorio ?
    aPBoxPrm[nPBox][8]:="AllWaysTrue()"         //[8]:String contendo a validacao When
    //------------------------------------------------------------------------------------------------
    aAdd(aPBoxPrm,Array(9))
    nPBox:=Len(aPBoxPrm)
    //12----------------------------------------------------------------------------------------------
    aPBoxPrm[nPBox][1]:=1                       //[1]:1 - MsGet
    aPBoxPrm[nPBox][2]:="Remetente"             //[2]:Descricao
    aPBoxPrm[nPBox][3]:=cSizeRem                //[3]:String contendo o inicializador do campo
    aPBoxPrm[nPBox][4]:=""                      //[4]:String contendo a Picture do campo
    aPBoxPrm[nPBox][5]:="NaoVazio()"            //[5]:String contendo a validacao
    aPBoxPrm[nPBox][6]:="SM0"                   //[6]:Consulta F3
    aPBoxPrm[nPBox][7]:="AllWaysTrue()"         //[7]:String contendo a validacao When
    aPBoxPrm[nPBox][8]:=nGSizeRem               //[8]:Tamanho do MsGet
    aPBoxPrm[nPBox][9]:=.T.                     //[9]:Flag .T./.F. Parametro Obrigatorio ?
    //------------------------------------------------------------------------------------------------
    aAdd(aPBoxPrm,Array(9))
    nPBox:=Len(aPBoxPrm)
    //13----------------------------------------------------------------------------------------------
    aPBoxPrm[nPBox][1]:=1                       //[1]:1 - MsGet
    aPBoxPrm[nPBox][2]:="Banco"                 //[2]:Descricao
    aPBoxPrm[nPBox][3]:=cSizeBco                //[3]:String contendo o inicializador do campo
    aPBoxPrm[nPBox][4]:=""                      //[4]:String contendo a Picture do campo
    aPBoxPrm[nPBox][5]:="NaoVazio()"            //[5]:String contendo a validacao
    aPBoxPrm[nPBox][6]:="SA6"                   //[6]:Consulta F3
    aPBoxPrm[nPBox][7]:="AllWaysTrue()"         //[7]:String contendo a validacao When
    aPBoxPrm[nPBox][8]:=nGSizeBco               //[8]:Tamanho do MsGet
    aPBoxPrm[nPBox][9]:=.T.                     //[9]:Flag .T./.F. Parametro Obrigatorio ?
    //------------------------------------------------------------------------------------------------
    aAdd(aPBoxPrm,Array(9))
    nPBox:=Len(aPBoxPrm)
    //14----------------------------------------------------------------------------------------------
    aPBoxPrm[nPBox][1]:=1                       //[1]:1 - MsGet
    aPBoxPrm[nPBox][2]:="Agencia"               //[2]:Descricao
    aPBoxPrm[nPBox][3]:=cSizeAge                //[3]:String contendo o inicializador do campo
    aPBoxPrm[nPBox][4]:=""                      //[4]:String contendo a Picture do campo
    aPBoxPrm[nPBox][5]:="NaoVazio()"            //[5]:String contendo a validacao
    aPBoxPrm[nPBox][6]:=""                      //[6]:Consulta F3
    aPBoxPrm[nPBox][7]:="AllWaysTrue()"         //[7]:String contendo a validacao When
    aPBoxPrm[nPBox][8]:=nGSizeAge               //[8]:Tamanho do MsGet
    aPBoxPrm[nPBox][9]:=.T.                     //[9]:Flag .T./.F. Parametro Obrigatorio ?
    //------------------------------------------------------------------------------------------------
    aAdd(aPBoxPrm,Array(9))
    nPBox:=Len(aPBoxPrm)
    //15----------------------------------------------------------------------------------------------
    aPBoxPrm[nPBox][1]:=1                       //[1]:1 - MsGet
    aPBoxPrm[nPBox][2]:="Conta"                 //[2]:Descricao
    aPBoxPrm[nPBox][3]:=cSizeCta                //[3]:String contendo o inicializador do campo
    aPBoxPrm[nPBox][4]:=""                      //[4]:String contendo a Picture do campo
    aPBoxPrm[nPBox][5]:="NaoVazio()"            //[5]:String contendo a validacao
    aPBoxPrm[nPBox][6]:=""                      //[6]:Consulta F3
    aPBoxPrm[nPBox][7]:="AllWaysTrue()"         //[7]:String contendo a validacao When
    aPBoxPrm[nPBox][8]:=nGSizeCta               //[8]:Tamanho do MsGet
    aPBoxPrm[nPBox][9]:=.T.                     //[9]:Flag .T./.F. Parametro Obrigatorio ?
    //------------------------------------------------------------------------------------------------
    aAdd(aPBoxPrm,Array(9))
    nPBox:=Len(aPBoxPrm)
    //16----------------------------------------------------------------------------------------------
    aPBoxPrm[nPBox][1]:=1                       //[1]:1 - MsGet
    aPBoxPrm[nPBox][2]:="DV Conta"              //[2]:Descricao
    aPBoxPrm[nPBox][3]:=cSizeDvC                //[3]:String contendo o inicializador do campo
    aPBoxPrm[nPBox][4]:=""                      //[4]:String contendo a Picture do campo
    aPBoxPrm[nPBox][5]:="AllWaysTrue()"         //[5]:String contendo a validacao
    aPBoxPrm[nPBox][6]:=""                      //[6]:Consulta F3
    aPBoxPrm[nPBox][7]:="AllWaysTrue()"         //[7]:String contendo a validacao When
    aPBoxPrm[nPBox][8]:=nGSizeDvC               //[8]:Tamanho do MsGet
    aPBoxPrm[nPBox][9]:=.F.                     //[9]:Flag .T./.F. Parametro Obrigatorio ?
    //------------------------------------------------------------------------------------------------

    //------------------------------------------------------------------------------------------------
        //Carrega a Interface com o usuário
        //Parambox(aParametros,@cTitle,@aRet,[bOk],[aButtons],[lCentered],[nPosX],[nPosy],[oDlgWizard],[cLoad],[lCanSave],[lUserSave])
    //------------------------------------------------------------------------------------------------
    While (.NOT.(lParamBox:=ParamBox(@aPBoxPrm,"Informe os Parâmetros para Filtro dos Dados",@aPBoxRet,NIL,NIL,.T.,NIL,NIL,NIL,NIL,.T.,.T.)))
        //------------------------------------------------------------------------------------------------
            //...Verifica se Deseja "Aborta" a Geração e...
        //------------------------------------------------------------------------------------------------
        lParamBox:=MsgYesNo("Deseja Abortar a Geração?","Atenção!")
        //------------------------------------------------------------------------------------------------
            //...Se optou por "Abortar" ...
        //------------------------------------------------------------------------------------------------
        IF (lParamBox)
            //------------------------------------------------------------------------------------------------
                //...Inverte o Estado de lParamBox ...
            //------------------------------------------------------------------------------------------------
            lParamBox:=.F.
            //------------------------------------------------------------------------------------------------
                //...Abandona.
            //------------------------------------------------------------------------------------------------
            EXIT
        EndIF
    End While

    //------------------------------------------------------------------------------------------------
        //Se confirmou ParamBox...
    //------------------------------------------------------------------------------------------------
    IF (lParamBox)
        //------------------------------------------------------------------------------------------------
            //...Processa cada elemento e...
        //------------------------------------------------------------------------------------------------
        For nPBox:=1 To Len(aPBoxPrm)
            //------------------------------------------------------------------------------------------------
                //...Carrega os Parâmetros/Conteúdos em oReportQst
            //------------------------------------------------------------------------------------------------
            oReportQst:Set(aPBoxPrm[nPBox][2],aPBoxRet[nPBox])
        Next nPBox
    EndIF

//------------------------------------------------------------------------------------------------
    //Retorna .T. se confirmou ParamBox, caso contrário: .F.
//------------------------------------------------------------------------------------------------
Return(lParamBox)

//------------------------------------------------------------------------------------------------
    /*
        Programa:u_DJFINR01.prw
        Funcao:ReportDef()
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:01/01/2015
        Descricao:Autorização para emissão de DOC/TED
    */
//------------------------------------------------------------------------------------------------
Static Function ReportDef(cAlias,oReportQst,aNotPrint)

    Local aSections

    Local bLocalData
    Local bAssineAqui
    Local bAssinatura

    Local cTitulo:=cCadastro
    Local cDescricao:=OemToAnsi("Este programa irá emitir a "+cTitulo)

    Local cSection

    //-------------------------------------------------------------------------------------
        //Obtem a Filial da Tabela SA6
    //-------------------------------------------------------------------------------------
    Local cSA6Filial:=xFilial("SA6")

    Local nPGPxToPrn
    Local nPageWidth

    Local oReport
    Local oSection

    Local oFChange:=tHash():New()
    Local oSections:=tHash():New()

    //-------------------------------------------------------------------------------------
        //Define as Propriedades da Fonte que poderão ser Alteradas durante a Impressao
    //-------------------------------------------------------------------------------------
    oFChange:AddNewSession("lBold")
    oFChange:AddNewSession("lItalic")

    //-------------------------------------------------------------------------------------
        //Instancia o Componente de Impressão
    //-------------------------------------------------------------------------------------
    oReport:=TReport():New("DJFINR01",cTitulo,NIL,{|oReport|ReportPrint(@oReport,@oSections,@cAlias,@oReportQst,@oFChange,@aNotPrint)},cDescricao)

    //-------------------------------------------------------------------------------------
        //Desabilita personalizacao do Relatorio
    //-------------------------------------------------------------------------------------
    oReport:SetEdit(.F.)
    oReport:SetPortrait()
    oReport:SetTotalInLine(.F.)
    //-------------------------------------------------------------------------------------
        //Habilita(.T.)/Desabilita(.F.) a Impressão do Header
    //-------------------------------------------------------------------------------------
    oReport:lHeaderVisible:=.F.

    //-------------------------------------------------------------------------------------
        //Redefine a Fonte
    //-------------------------------------------------------------------------------------
    oReport:cFontBody:="Courier New"

    //-------------------------------------------------------------------------------------
        //Instancia o Objeto oPrint. Por padrão este objeto seria instanciado em PrintDialog
        //Mas, considerando que preciso obter as dimensões do relatório,   mas precisamente,
        //PageWidth(), forço o instanciamento aqui.
    //-------------------------------------------------------------------------------------
    oReport:oPrint:=tMSPrinter():New(cTitulo)
    //-------------------------------------------------------------------------------------
        //Define o Modo de Impressão
    //-------------------------------------------------------------------------------------
    oReport:oPrint:SetPortrait()
    //-------------------------------------------------------------------------------------
        //Define as Dimensões do Relatório (/*A4 210 x 297 mm*/)
    //-------------------------------------------------------------------------------------
    oReport:oPrint:SetpaperSize(9/*A4 210 x 297 mm*/)

    //-------------------------------------------------------------------------------------
        //Calcula o Tamanho da Pagina (Para que, neste ponto, PageWidth() retorne um  conteú
        //do válido, foi necessário instanciar oPrint.
    //-------------------------------------------------------------------------------------
    nPageWidth:=oReport:PageWidth()
    nPGPxToPrn:=Int(nPageWidth*_nPGPx2Prn)

    //-------------------------------------------------------------------------------------
        //Redefine a Margem Esquerda do Relatório
        //(Obs.: oReport:LeftMargin()->Retorna a Margem)
    //-------------------------------------------------------------------------------------
    oReport:SetLeftMargin(3)

    //-------------------------------------------------------------------------------------
        //TRSection():New(oParent,cTitle,uTable,aOrder,lLoadCells,lLoadOrder,uTotalText,lTotalInLine,lHeaderPage,lHeaderBreak,lPageBreak,lLineBreak,nLeftMargin,lLineStyle,nColSpace,lAutoSize,cCharSeparator,nLinesBefore,nCols,nClrBack,nClrFore,nPercentage)
    //-------------------------------------------------------------------------------------

    //-------------------------------------------------------------------------------------
        //Instancia a Section SkipLine
        //(Workaround para que nLinesBefore funcione corretamente qdo lHeaderVisible==.F.)
    //-------------------------------------------------------------------------------------
    cSection:="SkipLine"
    oSection:=TRSection():New(oReport,cSection)
    oSections:Set(cSection,oSection)

    //-------------------------------------------------------------------------------------
        //Instancia as Células SkipLine
    //-------------------------------------------------------------------------------------
    TRCell():New(oSection,cSection,"",/*Titulo*/,/*Picture*/,nPGPxToPrn/*Tamanho*/,/*lPixel*/,{||""}/*{|| CB de Impressao }*/)

    //-------------------------------------------------------------------------------------
        //Instancia a Section Local&Data
    //-------------------------------------------------------------------------------------
    cSection:="Local&Data"
    oSection:=TRSection():New(oReport,cSection,,,,,,,,,,,,,,,,10/*nLinesBefore*/)
    oSections:Set(cSection,oSection)

    //-------------------------------------------------------------------------------------
        //Instancia as Células Local&Data
    //-------------------------------------------------------------------------------------
    bLocalData:={||PadL(AllTrim(SM0->M0_CIDCOB)+", "+Day2Str(dDataBase)+" de "+MesExtenso(dDataBase)+" de "+Year2Str(dDataBase),nPGPxToPrn/2)}
    TRCell():New(oSection,cSection,"SM0",/*Titulo*/,/*Picture*/,nPGPxToPrn/*Tamanho*/,/*lPixel*/,bLocalData/*{|| CB de Impressao }*/)
    //-------------------------------------------------------------------------------------
        //Redefine a Fonte
    //-------------------------------------------------------------------------------------
    oSection:Cell(cSection):oFontBody:=TFont():New("Lucida Console",NIL,12,NIL,.T./*lBold*/,NIL,NIL,NIL,NIL,.F./*lUnderline*/,.T./*lItalic*/)

    //-------------------------------------------------------------------------------------
        //Define o(s) Posicionamento(s)
    //-------------------------------------------------------------------------------------
    TRPosition():New(oSection,"SM0",1,{||cEmpAnt+oReportQst:Get("Remetente")}/*{|| CB de Impressao }*/)

    //-------------------------------------------------------------------------------------
        //Instancia a Section AutorizacaoCab
    //-------------------------------------------------------------------------------------
    cSection:="AutorizacaoCab"
    oSection:=TRSection():New(oReport,cSection)
    oSections:Set(cSection,oSection)

    //-------------------------------------------------------------------------------------
        //Instancia as Células Autorizacao
    //-------------------------------------------------------------------------------------
    TRCell():New(oSection,cSection,"",/*Titulo*/,/*Picture*/,nPGPxToPrn/*Tamanho*/,/*lPixel*/,{||PaDC(" AUTORIZAÇÃO ",Int(nPGPxToPrn/2))}/*{|| CB de Impressao }*/)
    //-------------------------------------------------------------------------------------
        //Redefine a Fonte
    //-------------------------------------------------------------------------------------
    oSection:Cell(cSection):oFontBody:=TFont():New("Lucida Console",NIL,16,NIL,.T./*lBold*/,NIL,NIL,NIL,NIL,.F./*lUnderline*/,.T./*lItalic*/)

    //-------------------------------------------------------------------------------------
        //Instancia a Section AutorizacaoDet
    //-------------------------------------------------------------------------------------
    cSection:="AutorizacaoDet"
    oSection:=TRSection():New(oReport,cSection)
    oSections:Set(cSection,oSection)

    //-------------------------------------------------------------------------------------
        //Instancia as Células Autorizacao
    //-------------------------------------------------------------------------------------
    TRCell():New(oSection,cSection,"",/*Titulo*/,/*Picture*/,nPGPxToPrn/*Tamanho*/,/*lPixel*/,{||PaDR("Autorizamos a debitar em nossa conta corrente para emissão de DOC/TED.",nPGPxToPrn)}/*{|| CB de Impressao }*/)
    //-------------------------------------------------------------------------------------
        //Redefine a Fonte
    //-------------------------------------------------------------------------------------
    oSection:Cell(cSection):oFontBody:=TFont():New("Tahoma",NIL,12,NIL,.F./*lBold*/,NIL,NIL,NIL,NIL,.F./*lUnderline*/,.T./*lItalic*/)

    //-------------------------------------------------------------------------------------
        //Instancia a Section Remetente
    //-------------------------------------------------------------------------------------
    cSection:="Remetente"
    oFChange:AddNewProperty("lBold",Upper(cSection),.T.)
    oFChange:AddNewProperty("lItalic",Upper(cSection),.T.)
    oSection:=TRSection():New(oReport,cSection)
    oSections:Set(cSection,oSection)

    //-------------------------------------------------------------------------------------
        //Instancia as Células Remetente
    //-------------------------------------------------------------------------------------
    TRCell():New(oSection,"CAB","",""/*Titulo*/,/*Picture*/,Int((nPGPxToPrn*(14/100)))/*Tamanho*/,/*lPixel*/,/*{|| CB de Impressao }*/)
    TRCell():New(oSection,"SEP","",""/*Titulo*/,/*Picture*/,Int((nPGPxToPrn*(02/100)))/*Tamanho*/,/*lPixel*/,/*{|| CB de Impressao }*/)
    TRCell():New(oSection,"DET","",""/*Titulo*/,/*Picture*/,Int((nPGPxToPrn*(84/100)))/*Tamanho*/,/*lPixel*/,/*{|| CB de Impressao }*/)
    //-------------------------------------------------------------------------------------
        //Redefine a Fonte
    //-------------------------------------------------------------------------------------
    oSection:Cell("DET"):oFontBody:=TFont():New("Tahoma",NIL,10,NIL,.F./*lBold*/,NIL,NIL,NIL,NIL,.F./*lUnderline*/,.F./*lItalic*/)

    //-------------------------------------------------------------------------------------
        //Define o(s) Posicionamento(s)
    //-------------------------------------------------------------------------------------
    TRPosition():New(oSection,"SM0",1,{||cEmpAnt+oReportQst:Get("Remetente")}/*{|| CB de Impressao }*/)
    TRPosition():New(oSection,"SA6",RetOrder("SA6","A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON"),{||cSA6Filial+oReportQst:Get("Banco")+oReportQst:Get("Agencia")+oReportQst:Get("Conta")}/*{|| CB de Impressao }*/)

    //-------------------------------------------------------------------------------------
        //Instancia a Section Favorecido
    //-------------------------------------------------------------------------------------
    cSection:="Favorecido"
    //-------------------------------------------------------------------------------------
    oFChange:AddNewProperty("lBold",Upper(cSection),.T.)
    oFChange:AddNewProperty("lItalic",Upper(cSection),.T.)
    //-------------------------------------------------------------------------------------
    oFChange:AddNewProperty("lBold","VALOR",.T.)
    oFChange:AddNewProperty("lItalic","VALOR",.T.)
    //-------------------------------------------------------------------------------------
    oSection:=TRSection():New(oReport,cSection)
    oSections:Set(cSection,oSection)

    //------------------------------------------------------------------------------------
        //Instancia as Células Favorecido
    //-------------------------------------------------------------------------------------
    TRCell():New(oSection,"CAB","",""/*Titulo*/,/*Picture*/,Int((nPGPxToPrn*(14/100)))/*Tamanho*/,/*lPixel*/,/*{|| CB de Impressao }*/)
    TRCell():New(oSection,"SEP","",""/*Titulo*/,/*Picture*/,Int((nPGPxToPrn*(02/100)))/*Tamanho*/,/*lPixel*/,/*{|| CB de Impressao }*/)
    TRCell():New(oSection,"DET","",""/*Titulo*/,/*Picture*/,Int((nPGPxToPrn*(84/100)))/*Tamanho*/,/*lPixel*/,/*{|| CB de Impressao }*/)
    //-------------------------------------------------------------------------------------
        //Redefine a Fonte
    //-------------------------------------------------------------------------------------
    oSection:Cell("DET"):oFontBody:=TFont():New("Tahoma",NIL,10,NIL,.F./*lBold*/,NIL,NIL,NIL,NIL,.F./*lUnderline*/,.F./*lItalic*/)

    //-------------------------------------------------------------------------------------
        //Instancia a Section VlrExtenso
    //-------------------------------------------------------------------------------------
    cSection:="VlrExtenso"
    oSection:=TRSection():New(oReport,cSection)
    oSections:Set(cSection,oSection)

    //--------------------------------------------------------------------------------------
        //Instancia as Células VlrExtenso
    //-------------------------------------------------------------------------------------
    TRCell():New(oSection,cSection,"",""/*Titulo*/,/*Picture*/,nPGPxToPrn/*Tamanho*/,/*lPixel*/,/*{|| CB de Impressao }*/)
    //-------------------------------------------------------------------------------------
        //Redefine a Fonte
    //-------------------------------------------------------------------------------------
    oSection:Cell(cSection):oFontBody:=TFont():New("Tahoma",NIL,10,NIL,.T./*lBold*/,NIL,NIL,NIL,NIL,.F./*lUnderline*/,.T./*lItalic*/)

    //-------------------------------------------------------------------------------------
        //Instancia a Section AssineAqui
    //-------------------------------------------------------------------------------------
    cSection:="AssineAqui"
    oSection:=TRSection():New(oReport,cSection,,,,,,,,,,,,,,,,15/*nLinesBefore*/)
    oSections:Set(cSection,oSection)

    //-------------------------------------------------------------------------------------
        //Instancia as Células AssineAqui
    //-------------------------------------------------------------------------------------
    bAssineAqui:={||PadC(Replicate("_",Int(nPGPxToPrn/3)),nPGPxToPrn)}
    TRCell():New(oSection,cSection,"",/*Titulo*/,/*Picture*/,nPGPxToPrn/*Tamanho*/,/*lPixel*/,bAssineAqui/*{|| CB de Impressao }*/)
    //-------------------------------------------------------------------------------------
        //Redefine a Fonte
    //-------------------------------------------------------------------------------------
    oSection:Cell(cSection):oFontBody:=TFont():New("Lucida Console",NIL,10,NIL,.T./*lBold*/,NIL,NIL,NIL,NIL,.F./*lUnderline*/,.T./*lItalic*/)

    //-------------------------------------------------------------------------------------
        //Instancia a Section Assinatura
    //-------------------------------------------------------------------------------------
    cSection:="Assinatura"
    oSection:=TRSection():New(oReport,cSection)
    oSections:Set(cSection,oSection)

    //-------------------------------------------------------------------------------------
        //Instancia as Células AssineAqui
    //-------------------------------------------------------------------------------------
    bAssinatura:={||PadC("Assinatura",nPGPxToPrn)}
    TRCell():New(oSection,cSection,"",/*Titulo*/,/*Picture*/,nPGPxToPrn/*Tamanho*/,/*lPixel*/,bAssinatura/*{|| CB de Impressao }*/)
    //-------------------------------------------------------------------------------------
        //Redefine a Fonte
    //-------------------------------------------------------------------------------------
    oSection:Cell(cSection):oFontBody:=TFont():New("Lucida Console",NIL,10,NIL,.T./*lBold*/,NIL,NIL,NIL,NIL,.F./*lUnderline*/,.T./*lItalic*/)

    //-------------------------------------------------------------------------------------
        //Define os Valores Padrões para Cada Section do Relatório
    //-------------------------------------------------------------------------------------
    aSections:=oSections:GetAllSessions()
    nJ:=Len(aSections)
    For nD:=1 To nJ
       cSection:=aSections[nD]
       oSection:=oSections:Get(cSection)
       oSection:SetEdit(.F.)
       oSection:SetHeaderPage(.F.)
       oSection:SetTotalInLine(.F.)
       oSection:SetHeaderBreak(.F.)
       oSection:SetHeaderSection(.F.)
    Next nD

    //-------------------------------------------------------------------------------------
        //Libera oSection
    //-------------------------------------------------------------------------------------
    oSection:=NIL

Return(oReport)

//------------------------------------------------------------------------------------------------
    /*
        Programa:u_DJFINR01.prw
        Funcao:ReportPrint()
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:01/01/2015
        Descricao:Autorização para emissão de DOC/TED
    */
//------------------------------------------------------------------------------------------------
Static Procedure ReportPrint(oReport,oSections,cAlias,oReportQst,oFChange,aNotPrint)

    Local aRemetente
    Local aFavorecido

    //-------------------------------------------------------------------------------------
        //Obtem a Picture para CGC
    //-------------------------------------------------------------------------------------
    Local cCGCPict:=GetSx3Cache("A2_CGC","X3_PICTURE")

    //-------------------------------------------------------------------------------------
        //Obtem a Picture para CPF
    //-------------------------------------------------------------------------------------
    Local cCPFPict:=GetSx3Cache("RA_CIC","X3_PICTURE")

    Local cSection
    Local cKeyBreak

    //-------------------------------------------------------------------------------------
        //Obtem a Filial da Tabela SA6
    //-------------------------------------------------------------------------------------
    Local cSA6Filial:=xFilial("SA6")

    Local nD
    Local nJ

    Local lSA6Found:=.F.

    //-------------------------------------------------------------------------------------
        //Calcula o Tamanho da Pagina
    //-------------------------------------------------------------------------------------
    Local nPageWidth:=oReport:PageWidth()

    Local nTSaldo
    Local nSA2RecNo
    Local nSE2RecNo

    Local oSection

    Local oRemetente:=tHash():New()
    Local oFavorecido:=tHash():New()

    //-------------------------------------------------------------------------------------
        //Instancia um novo Objeto do Tipo tBrush
    //-------------------------------------------------------------------------------------
    Local oBrush:=tBrush():New(NIL,CLR_BLACK)

    Local oFontRPT:=TFont():New(oReport:cFontBody,NIL,10,NIL,.F./*lBold*/,NIL,NIL,NIL,NIL,.F./*lUnderline*/,.F./*lItalic*/)
    Local oFontBUI:=TFont():New("Lucida Console",NIL,10,NIL,.T./*lBold*/,NIL,NIL,NIL,NIL,.F./*lUnderline*/,.T./*lItalic*/)

    //-------------------------------------------------------------------------------------
        //Define os Blocos de Impressão para a Section Remetente
    //-------------------------------------------------------------------------------------
    oRemetente:Set("REMETENTE",{||AllTrim(SM0->M0_NOMECOM)})
    oRemetente:Set("CNPJ/CPF",{||Transform(AllTrim(SM0->M0_CGC),cCGCPict)})
    oRemetente:Set("Banco",{||IF(lSA6Found,SA6->A6_COD,oReportQst:Get("Banco"))})
    oRemetente:Set("Agencia",{||IF(lSA6Found,SA6->A6_AGENCIA,oReportQst:Get("Agencia"))})
    oRemetente:Set("Conta",{||IF(lSA6Found,SA6->A6_NUMCON,oReportQst:Get("Conta"))})
    oRemetente:Set("DV Conta",{||IF(lSA6Found,SA6->A6_DVCTA,oReportQst:Get("DV Conta"))})

    //-------------------------------------------------------------------------------------
        //Obtem Todas as Chaves de oRemetente
    //-------------------------------------------------------------------------------------
    aRemetente:=oRemetente:GetAllSessions()

    //-------------------------------------------------------------------------------------
        //Define os Blocos de Impressão para a Section Favorecido
    //-------------------------------------------------------------------------------------
    oFavorecido:Set("FAVORECIDO",{||AllTrim(SA2->A2_NOME)})
    oFavorecido:Set("CNPJ/CPF",{||SA2->(Transform(A2_CGC,IF(A2_TIPO=="J",cCGCPict,cCPFPict)))})
    oFavorecido:Set("Banco",{||SA2->A2_BANCO})
    oFavorecido:Set("Agencia",{||SA2->A2_AGENCIA})
    oFavorecido:Set("Conta",{||SA2->A2_NUMCON})
    oFavorecido:Set("VALOR",{||Transform(nTSaldo,"@E 999,999,999,999.99")})

    //-------------------------------------------------------------------------------------
        //Obtem Todas as Chaves de oFavorecido
    //-------------------------------------------------------------------------------------
    aFavorecido:=oFavorecido:GetAllSessions()

    //-------------------------------------------------------------------------------------
        //Define os Blocos de Impressão da Section Remetente
    //-------------------------------------------------------------------------------------
    cSection:="Remetente"
    oSection:=oSections:Get(cSection)
    oSection:Cell("CAB"):SetBlock({||aRemetente[nD]})
    oSection:Cell("SEP"):SetBlock({||":"})
    oSection:Cell("DET"):SetBlock({||Eval(oRemetente:Get(aRemetente[nD]))})

    //-------------------------------------------------------------------------------------
        //Define os Blocos de Impressao da Section Favorecido
    //-------------------------------------------------------------------------------------
    cSection:="Favorecido"
    oSection:=oSections:Get(cSection)
    oSection:Cell("CAB"):SetBlock({||aFavorecido[nD]})
    oSection:Cell("SEP"):SetBlock({||":"})
    oSection:Cell("DET"):SetBlock({||Eval(oFavorecido:Get(aFavorecido[nD]))})

    //-------------------------------------------------------------------------------------
        //Define o Bloco de Impressão da Section VlrExtenso
    //-------------------------------------------------------------------------------------
    cSection:="VlrExtenso"
    oSection:=oSections:Get(cSection)
    oSection:Cell(cSection):SetBlock({||"("+AllTrim(Extenso(nTSaldo))+")"})

    //-------------------------------------------------------------------------------------
        //Inicio do Processo de Impressão
    //-------------------------------------------------------------------------------------
    While (cAlias)->(.NOT.(Eof()))

        //-------------------------------------------------------------------------------------
            //Reinicializa Saldo a Cada Quebra
        //-------------------------------------------------------------------------------------
        nTSaldo:=0

        //-------------------------------------------------------------------------------------
            //Obtem o RecNo para posicionamento na Tabela SA2
        //-------------------------------------------------------------------------------------
        nSA2RecNo:=(cAlias)->__SA2RECNO

        //-------------------------------------------------------------------------------------
            //Garanto o Posicionamento no Registro da Tabela SA2
        //-------------------------------------------------------------------------------------
        SA2->(MsGoTo(nSA2RecNo))

        //-------------------------------------------------------------------------------------
            //Verifica se o Registro será impresso
        //-------------------------------------------------------------------------------------
        IF (aScan(aNotPrint,{|nRecNo|(nRecNo==nSA2RecNo)})>0)
            (cAlias)->(dbSkip())
            Loop
        EndIF

        //-------------------------------------------------------------------------------------
            //Obtem o RecNo para posicionamento na Tabela SE2
        //-------------------------------------------------------------------------------------
        nSE2RecNo:=(cAlias)->__SE2RECNO

        //-------------------------------------------------------------------------------------
            //Garanto o Posicionamento no Registro da Tabela SE2
        //-------------------------------------------------------------------------------------
        SE2->(MsGoTo(nSE2RecNo))

        //-------------------------------------------------------------------------------------
            //Obtem a chave Atual para Quebra no Fornecedor/Loja
        //-------------------------------------------------------------------------------------
        cKeyBreak:=SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA)

        //-------------------------------------------------------------------------------------
            //Inicia a Impressão da  Section SkipLine
        //-------------------------------------------------------------------------------------
        cSection:="SkipLine"
        oSection:=oSections:Get(cSection)
        oSection:Init()
            //-------------------------------------------------------------------------------------
                //Imprime a Linha
            //-------------------------------------------------------------------------------------
            oSection:PrintLine()
        oSection:Finish()

        //-------------------------------------------------------------------------------------
            //Inicia a Impressão da  Section Local&Data
        //-------------------------------------------------------------------------------------
        cSection:="Local&Data"
        oSection:=oSections:Get(cSection)
        oSection:Init()
            //-------------------------------------------------------------------------------------
                //Imprime a Linha
            //-------------------------------------------------------------------------------------
            oSection:PrintLine()
        oSection:Finish()

        //-------------------------------------------------------------------------------------
            //Salta n Linhas
        //-------------------------------------------------------------------------------------
        For nD:=1 To 2
            oReport:SkipLine()
        Next nD

        //-------------------------------------------------------------------------------------
            //Desenha o Retangulo Para AutorizacaoCab
        //-------------------------------------------------------------------------------------
        oReport:Box(oReport:Row(),oReport:Col(),oReport:Row()+100,nPageWidth)

        //-------------------------------------------------------------------------------------
            //Inicia a Impressão da  Section AutorizacaoCab
        //-------------------------------------------------------------------------------------
        cSection:="AutorizacaoCab"
        oSection:=oSections:Get(cSection)
        oSection:Init()
            //-------------------------------------------------------------------------------------
                //Imprime a Linha
            //-------------------------------------------------------------------------------------
            oSection:PrintLine()
        oSection:Finish()

        //-------------------------------------------------------------------------------------
            //Salta n Linhas
        //-------------------------------------------------------------------------------------
        For nD:=1 To 2
            oReport:SkipLine()
        Next nD

        //-------------------------------------------------------------------------------------
            //Inicia a Impressão da  Section AutorizacaoDet
        //-------------------------------------------------------------------------------------
        cSection:="AutorizacaoDet"
        oSection:=oSections:Get(cSection)
        oSection:Init()
            //-------------------------------------------------------------------------------------
                //Imprime a Linha
            //-------------------------------------------------------------------------------------
            oSection:PrintLine()
        oSection:Finish()

        //-------------------------------------------------------------------------------------
            //Salta n Linhas
        //-------------------------------------------------------------------------------------
        For nD:=1 To 2
            oReport:SkipLine()
        Next nD

        //-------------------------------------------------------------------------------------
            //Inicia a Impressão da  Section Remetente
        //-------------------------------------------------------------------------------------
        cSection:="Remetente"
        oSection:=oSections:Get(cSection)
        nJ:=Len(aRemetente)
        For nD:=1 To nJ
            oSection:Init()
                //-------------------------------------------------------------------------------------
                    //Verifica se o Banco/Agencia/Conta do Remetente estão Cadastrados no SA6
                //-------------------------------------------------------------------------------------
                lSA6Found:=SA6->(MsSeek(cSA6Filial+oReportQst:Get("Banco")+oReportQst:Get("Agencia")+oReportQst:Get("Conta"),.F.))
                //-------------------------------------------------------------------------------------
                    //Verifica se vai alterar as propriedades da Fonte
                //-------------------------------------------------------------------------------------
                oReport:lBold:=oFChange:GetPropertyValue("lBold",aRemetente[nD],.F.)
                oReport:lItalic:=oFChange:GetPropertyValue("lItalic",aRemetente[nD],.F.)
                //-------------------------------------------------------------------------------------
                    //Redefine a Fonte
                //-------------------------------------------------------------------------------------
                BEGIN SEQUENCE
                    IF .NOT.(oReport:lBold)
                        BREAK
                    ENDIF
                    IF .NOT.(oReport:lItalic)
                        BREAK
                    ENDIF
                    //-------------------------------------------------------------------------------------
                        //Redefine a Fonte (BUI)
                    //-------------------------------------------------------------------------------------
                    oSection:Cell("CAB"):oFontBody:=oFontBUI
                RECOVER
                    //-------------------------------------------------------------------------------------
                        //Redefine a Fonte (RPT)
                    //-------------------------------------------------------------------------------------
                    oSection:Cell("CAB"):oFontBody:=oFontRPT
                END SEQUENCE
                //-------------------------------------------------------------------------------------
                    //Imprime a Linha
                //-------------------------------------------------------------------------------------
                oSection:PrintLine()
            oSection:Finish()
        Next nD

        //-------------------------------------------------------------------------------------
            //Salta uma Linha
        //-------------------------------------------------------------------------------------
        oReport:SkipLine()

        //-------------------------------------------------------------------------------------
            //Desenha o Retangulo Separador Remetente/Fornecedor
        //-------------------------------------------------------------------------------------
        oReport:FillRect({oReport:Row(),oReport:Col(),oReport:Row()+25,nPageWidth},oBrush)

        //-------------------------------------------------------------------------------------
            //Salta uma Linha
        //-------------------------------------------------------------------------------------
        oReport:SkipLine()

        //-------------------------------------------------------------------------------------
            //Percorre Todos os Registros para a Totalização dos Valores do Fornecedor/Loja
        //-------------------------------------------------------------------------------------
        While (cAlias)->(.NOT.(Eof()))

            //-------------------------------------------------------------------------------------
                //Acumula os Saldos do Fornecedor/Loja
            //-------------------------------------------------------------------------------------
            IF ("PA"$SE2->E2_TIPO)
                //-------------------------------------------------------------------------------------
                    //Subtrai Pagamento Antecipado
                //-------------------------------------------------------------------------------------
                nTSaldo-=SE2->E2_SALDO
            Else
                //-------------------------------------------------------------------------------------
                    //Soma Valores a Pagar
                //-------------------------------------------------------------------------------------
                nTSaldo+=SE2->E2_SALDO
            EndIF

            //-------------------------------------------------------------------------------------
                //Salta para o Proximo Registro
            //-------------------------------------------------------------------------------------
            (cAlias)->(dbSkip())

            //-------------------------------------------------------------------------------------
                //Obtem o proximo RecNo para posicionamento no SE2
            //-------------------------------------------------------------------------------------
            nSE2RecNo:=(cAlias)->__SE2RECNO

            //-------------------------------------------------------------------------------------
                //Posiciona no Registro Correspondente
            //-------------------------------------------------------------------------------------
            SE2->(dbGoTo(nSE2RecNo))

            //-------------------------------------------------------------------------------------
                //Verifica a Quebra Baseado no Fornecedor/Loja
            //-------------------------------------------------------------------------------------
            IF .NOT.(cKeyBreak==SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA))
                EXIT
            ENDIF

            //-------------------------------------------------------------------------------------
                //Incrementa a Regua de Processamento
            //-------------------------------------------------------------------------------------
            oReport:IncMeter()

        End While

        //-------------------------------------------------------------------------------------
            //Inicia a Impressão da  Section Favorecido
        //-------------------------------------------------------------------------------------
        cSection:="Favorecido"
        oSection:=oSections:Get(cSection)
        nJ:=Len(aFavorecido)
        For nD:=1 To nJ
            oSection:Init()
                //-------------------------------------------------------------------------------------
                    //Verifica se vai alterar as propriedades da Fonte
                //-------------------------------------------------------------------------------------
                oReport:lBold:=oFChange:GetPropertyValue("lBold",aFavorecido[nD],.F.)
                oReport:lItalic:=oFChange:GetPropertyValue("lItalic",aFavorecido[nD],.F.)
                //-------------------------------------------------------------------------------------
                    //Redefine a Fonte
                //-------------------------------------------------------------------------------------
                BEGIN SEQUENCE
                    IF .NOT.(oReport:lBold)
                        BREAK
                    ENDIF
                    IF .NOT.(oReport:lItalic)
                        BREAK
                    ENDIF
                    //-------------------------------------------------------------------------------------
                        //Redefine a Fonte (BUI)
                    //-------------------------------------------------------------------------------------
                    oSection:Cell("CAB"):oFontBody:=oFontBUI
                RECOVER
                    //-------------------------------------------------------------------------------------
                        //Redefine a Fonte (RPT)
                    //-------------------------------------------------------------------------------------
                    oSection:Cell("CAB"):oFontBody:=oFontRPT
                END SEQUENCE
                //-------------------------------------------------------------------------------------
                    //Imprime a Linha
                //-------------------------------------------------------------------------------------
                oSection:PrintLine()
            oSection:Finish()
        Next nD

        //-------------------------------------------------------------------------------------
            //Salta n Linhas
        //-------------------------------------------------------------------------------------
        For nD:=1 To 3
            oReport:SkipLine()
        Next nD

        //-------------------------------------------------------------------------------------
            //Desenha o Retangulo Para Impressão do Extenso
        //-------------------------------------------------------------------------------------
        oReport:Box(oReport:Row(),oReport:Col(),oReport:Row()+100,nPageWidth)

        //-------------------------------------------------------------------------------------
            //Inicia a Impressão da  Section VlrExtenso
        //-------------------------------------------------------------------------------------
        cSection:="VlrExtenso"
        oSection:=oSections:Get(cSection)
        oSection:Init()
            //-------------------------------------------------------------------------------------
                //Imprime a Linha
            //-------------------------------------------------------------------------------------
            oSection:PrintLine()
        oSection:Finish()

        //-------------------------------------------------------------------------------------
            //Inicia a Impressão da Section AssineAqui
        //-------------------------------------------------------------------------------------
        cSection:="AssineAqui"
        oSection:=oSections:Get(cSection)
        oSection:Init()
            //-------------------------------------------------------------------------------------
                //Imprime a Linha
            //-------------------------------------------------------------------------------------
            oSection:PrintLine()
        oSection:Finish()

        //-------------------------------------------------------------------------------------
            //Inicia a Impressão da Section Assinatura
        //-------------------------------------------------------------------------------------
        cSection:="Assinatura"
        oSection:=oSections:Get(cSection)
        oSection:Init()
            //-------------------------------------------------------------------------------------
                //Imprime a Linha
            //-------------------------------------------------------------------------------------
            oSection:PrintLine()
        oSection:Finish()

        //-------------------------------------------------------------------------------------
            //Força a Quebra de Página
        //------------------------------------------------------------------------------------
        cSection:="SkipLine"
        oSection:=oSections:Get(cSection)
        oSection:SetPageBreak(.T.)

    End While

    //-------------------------------------------------------------------------------------
        //Finaliza o Objeto oBrush
    //-------------------------------------------------------------------------------------
    oBrush:=oBrush:End()

Return

//------------------------------------------------------------------------------------------------
    /*
        Programa:u_DJFINR01.prw
        Funcao:ReportQst()
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:01/01/2015
        Descricao:Autorização para emissão de DOC/TED
    */
//------------------------------------------------------------------------------------------------
Static Function ReportView(cAlias,oReportQst,oLog,aNotPrint)

    Local aNDJ

    Local cFilDe:=oReportQst:Get("Filial De")
    Local cFilAte:=oReportQst:Get("Filial Ate")
    Local cForDe:=oReportQst:Get("Fornecedor De")
    Local cForAte:=oReportQst:Get("Fornecedor Ate")
    Local cLojaDe:=oReportQst:Get("Loja De")
    Local cLojaAte:=oReportQst:Get("Loja Ate")
    Local cEmissDe:=DtoS(oReportQst:Get("Emissao De"))
    Local cEmissAte:=DtoS(oReportQst:Get("Emissao Ate"))
    Local cVctoDe:=DtoS(oReportQst:Get("Vencimento De"))
    Local cVctoAte:=DtoS(oReportQst:Get("Vencimento Ate"))

    Local cLogT
    Local cToken:=","
    Local cDToken:=Replicate(cToken,2)
    Local cExpFor:="1=1"
    Local cKeyBreak

    Local nD
    Local nJ
    Local nSA2RecNo
    Local nSE2RecNo

    Local nTSaldo:=0
    Local nRCount:=0
    Local nRecCount:=0

    Local oException

    //-------------------------------------------------------------------------------------
        //Verifica se Vai Filtrar Fornecedor
    //-------------------------------------------------------------------------------------
    IF (oReportQst:Get("Filtrar Fornecedor")==1)
        //-------------------------------------------------------------------------------------
            //Obtem os Fornecedores Filtrados
        //-------------------------------------------------------------------------------------
        cExpFor:=A2CodVendF3()
        //-------------------------------------------------------------------------------------
            //Remove Asteriscos
        //-------------------------------------------------------------------------------------
        cExpFor:=StrTran(cExpFor,"*","")
        //-------------------------------------------------------------------------------------
            //Remove "Double Token"
        //-------------------------------------------------------------------------------------
        While (cDToken$cExpFor)
            cExpFor:=StrTran(cExpFor,cDToken,cToken)
        End While
        //-------------------------------------------------------------------------------------
            //Remove First Token
        //-------------------------------------------------------------------------------------
        IF (SubStr(cExpFor,1,1)==cToken)
            cExpFor:=SubStr(cExpFor,2)
        EndIF
        //-------------------------------------------------------------------------------------
            //Remove Last Token
        //-------------------------------------------------------------------------------------
        IF (SubStr(cExpFor,-1,1)==cToken)
            cExpFor:=SubStr(cExpFor,1,Len(cExpFor)-1)
        EndIF
        //-------------------------------------------------------------------------------------
            //Tokeniza
        //-------------------------------------------------------------------------------------
        aNDJ:=_StrToKArr(cExpFor,cToken)
        cExpFor:=""
        nJ:=Len(aNDJ)
        For nD:=1 To nJ
            cExpFor+="'"
            cExpFor+=aNDJ[nD]
            cExpFor+="'"
            //-------------------------------------------------------------------------------------
                //Inclui o Separador
            //-------------------------------------------------------------------------------------
            IF (nD<nJ)
                cExpFor+=cToken
            EndIF
        Next nD
        //-------------------------------------------------------------------------------------
            //Adiciona Clausula IN
        //-------------------------------------------------------------------------------------
        cExpFor:="SE2.E2_FORNECE+':'+SE2.E2_LOJA IN("+cExpFor+")"
    EndIF

    //-------------------------------------------------------------------------------------
        //Prepara cExpFor para EmbeddedSQL
    //-------------------------------------------------------------------------------------
    cExpFor:="%"+cExpFor+"%"

    TRY EXCEPTION

        //-------------------------------------------------------------------------------------
            //Elabora a Consulta usando EmbeddedSQL
        //-------------------------------------------------------------------------------------
        BEGINSQL ALIAS cAlias

            COLUMN E2_EMISSAO   AS DATE
            COLUMN E2_VENCTO    AS DATE

            SELECT SE2.R_E_C_N_O_ AS __SE2RECNO
                  ,SA2.R_E_C_N_O_ AS __SA2RECNO
              FROM %table:SE2% SE2
                  ,%table:SA2% SA2
             WHERE SE2.%notDel%
               AND SA2.%notDel%
               AND SE2.E2_FILIAL  BETWEEN %exp:cFilDe% AND %exp:cFilAte%
               AND SA2.A2_FILIAL=%xFilial:SA2%
               AND SE2.E2_SALDO>0
               AND SE2.E2_DATALIB<>' '
               AND SE2.E2_FORNECE BETWEEN %exp:cForDe% AND %exp:cForAte%
               AND SE2.E2_LOJA    BETWEEN %exp:cLojaDe% AND %exp:cLojaAte%
               AND SE2.E2_EMISSAO BETWEEN %exp:cEmissDe% AND %exp:cEmissAte%
               AND SE2.E2_VENCTO  BETWEEN %exp:cVctoDe% AND %exp:cVctoAte%
               AND SA2.A2_COD=SE2.E2_FORNECE
               AND SA2.A2_LOJA=SE2.E2_LOJA
               AND (%exp:cExpFor%)
            ORDER BY SE2.E2_FILIAL
                    ,SE2.E2_FORNECE
                    ,SE2.E2_LOJA
                    ,SE2.E2_PREFIXO
                    ,SE2.E2_NUM
                    ,SE2.E2_PARCELA
                    ,SE2.E2_TIPO
        ENDSQL

        //-------------------------------------------------------------------------------------
            //Salva Query Statement
        //-------------------------------------------------------------------------------------
        IF .NOT.(IsBlind())
            MemoWrite(GetTempPath()+"ReportView_u_DJFINR01.sql",GetLastQuery()[2])
        EndIF

        //-------------------------------------------------------------------------------------
            //Garante que a Area de Trabalho será a da View
        //-------------------------------------------------------------------------------------
        dbSelectArea(cAlias)

        //-------------------------------------------------------------------------------------
            //Obtem o Número de Registros a serem Processados
        //-------------------------------------------------------------------------------------
        While (cAlias)->(.NOT.(Eof()))

            //-------------------------------------------------------------------------------------
                //Reinicializa Saldo a Cada Quebra
            //-------------------------------------------------------------------------------------
            nTSaldo:=0

            //-------------------------------------------------------------------------------------
                //Obtem o RecNo para posicionamento na Tabela SA2
            //-------------------------------------------------------------------------------------
            nSA2RecNo:=(cAlias)->__SA2RECNO

            //-------------------------------------------------------------------------------------
                //Garanto o Posicionamento no Registro da Tabela SA2
            //-------------------------------------------------------------------------------------
            SA2->(MsGoTo(nSA2RecNo))

            //-------------------------------------------------------------------------------------
                //Obtem o RecNo para posicionamento na Tabela SE2
            //-------------------------------------------------------------------------------------
            nSE2RecNo:=(cAlias)->__SE2RECNO

            //-------------------------------------------------------------------------------------
                //Garanto o Posicionamento no Registro da Tabela SE2
            //-------------------------------------------------------------------------------------
            SE2->(MsGoTo(nSE2RecNo))

            //-------------------------------------------------------------------------------------
                //Obtem a chave Atual para Quebra no Fornecedor/Loja
            //-------------------------------------------------------------------------------------
            cKeyBreak:=SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA)

            //-------------------------------------------------------------------------------------
                //Percorre Todos os Registros para a Totalização dos Valores do Fornecedor/Loja
            //-------------------------------------------------------------------------------------
            While (cAlias)->(.NOT.(Eof()))

                //-------------------------------------------------------------------------------------
                    //Contador de Numero de Registros a serem processados
                //-------------------------------------------------------------------------------------
                ++nRCount

                //-------------------------------------------------------------------------------------
                    //Acumula os Saldos do Fornecedor/Loja
                //-------------------------------------------------------------------------------------
                IF ("PA"$SE2->E2_TIPO)
                    //-------------------------------------------------------------------------------------
                        //Subtrai Pagamento Antecipado
                    //-------------------------------------------------------------------------------------
                    nTSaldo-=SE2->E2_SALDO
                Else
                    //-------------------------------------------------------------------------------------
                        //Soma Valores a Pagar
                    //-------------------------------------------------------------------------------------
                    nTSaldo+=SE2->E2_SALDO
                EndIF

                //-------------------------------------------------------------------------------------
                    //Salta para o Proximo Registro
                //-------------------------------------------------------------------------------------
                (cAlias)->(dbSkip())

                //-------------------------------------------------------------------------------------
                    //Obtem o proximo RecNo para posicionamento no SE2
                //-------------------------------------------------------------------------------------
                nSE2RecNo:=(cAlias)->__SE2RECNO

                //-------------------------------------------------------------------------------------
                    //Posiciona no Registro Correspondente
                //-------------------------------------------------------------------------------------
                SE2->(dbGoTo(nSE2RecNo))

                //-------------------------------------------------------------------------------------
                    //Verifica a Quebra Baseado no Fornecedor/Loja
                //-------------------------------------------------------------------------------------
                IF .NOT.(cKeyBreak==SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA))
                    EXIT
                ENDIF

            End While

            //-------------------------------------------------------------------------------------
                //Se Saldo Menor ou Igual a Zero...
            //-------------------------------------------------------------------------------------
            IF (nTSaldo<=0)
                //-------------------------------------------------------------------------------------
                    //...Define o Grupo do LOG
                //-------------------------------------------------------------------------------------
                cLogT:="VALOR"
                //-------------------------------------------------------------------------------------
                    //...Adiciona informação ao LOG
                //-------------------------------------------------------------------------------------
                SA2->(aAdd(oLog:Get(cLogT),"Fornecedor não possui saldo a Receber: Código:["+A2_COD+"] Loja:["+A2_LOJA+"] Nome:["+A2_NOME+"] Valor:["+Transform(nTSaldo,"@E 999,999,999,999.99")+"]"))
                //-------------------------------------------------------------------------------------
                    //...Carrega RecNo em a NotPrint
                //-------------------------------------------------------------------------------------
                aAdd(aNotPrint,nSA2RecNo)
                //-------------------------------------------------------------------------------------
                    //...Zera Contador de Registros
                //-------------------------------------------------------------------------------------
                nRCount:=0
            EndIF

           //-------------------------------------------------------------------------------------
                //Se Banco,Agencia ou Conta (em branco)
            //-------------------------------------------------------------------------------------
            IF SA2->(Empty(A2_BANCO).or.Empty(A2_AGENCIA).or.Empty(A2_NUMCON))
                //-------------------------------------------------------------------------------------
                    //...Define o Grupo do LOG
                //-------------------------------------------------------------------------------------
                cLogT:="BANCO"
                //-------------------------------------------------------------------------------------
                    //...Adiciona informação ao LOG
                //-------------------------------------------------------------------------------------
                IF SA2->(Empty(A2_BANCO))
                    SA2->(aAdd(oLog:Get(cLogT),"Fornecedor não possui BANCO   : Código:["+A2_COD+"] Loja:["+A2_LOJA+"] Nome:["+A2_NOME+"] Valor:["+Transform(nTSaldo,"@E 999,999,999,999.99")+"]"))
                EndIF
                //-------------------------------------------------------------------------------------
                    //...Adiciona informação ao LOG
                //-------------------------------------------------------------------------------------
                IF SA2->(Empty(A2_AGENCIA))
                    SA2->(aAdd(oLog:Get(cLogT),"Fornecedor não possui AGÊNCIA : Código:["+A2_COD+"] Loja:["+A2_LOJA+"] Nome:["+A2_NOME+"] Valor:["+Transform(nTSaldo,"@E 999,999,999,999.99")+"]"))
                EndIF
                //-------------------------------------------------------------------------------------
                    //...Adiciona informação ao LOG
                //-------------------------------------------------------------------------------------
                IF SA2->(Empty(A2_NUMCON))
                    SA2->(aAdd(oLog:Get(cLogT),"Fornecedor não possui CONTA   : Código:["+A2_COD+"] Loja:["+A2_LOJA+"] Nome:["+A2_NOME+"] Valor:["+Transform(nTSaldo,"@E 999,999,999,999.99")+"]"))
                EndIF
                //-------------------------------------------------------------------------------------
                    //...Carrega RecNo em a NotPrint
                //-------------------------------------------------------------------------------------
                aAdd(aNotPrint,nSA2RecNo)
                //-------------------------------------------------------------------------------------
                    //...Zera Contador de Registros
                //-------------------------------------------------------------------------------------
                nRCount:=0
            EndIF

            //-------------------------------------------------------------------------------------
                //Obtem o Numero de Registros a Serem Processados
            //-------------------------------------------------------------------------------------
            nRecCount+=nRCount
            nRCount:=0

        End While

        //-------------------------------------------------------------------------------------
            //Remonta a View
        //-------------------------------------------------------------------------------------
        (cAlias)->(dbGoTop())

    CATCH EXCEPTION USING oException

        //-------------------------------------------------------------------------------------
            //Salva o Erro
        //-------------------------------------------------------------------------------------
        IF (ValType(oException)=="O")
            IF .NOT.(IsBlind())
                MemoWrite(GetTempPath()+"ReportView_u_DJFINR01.err",CaptureError())
            EndIF
        EndIF

    END EXCEPTION

//-------------------------------------------------------------------------------------
    //Retorna Número de Registros a Serem Processados
//-------------------------------------------------------------------------------------
Return(nRecCount)


//-------------------------------------------------------------------------------------
    /*
        Programa:u_DJFINR01.prw
        Funcao:A2CodVendF3()
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:30/12/2014
        Desc.:Programa para retornar Consulta Padrao "Específica" baseada em f_Opcoes
        Uso:Retorno da Consulta F3 (A2REF3)
    */
//-------------------------------------------------------------------------------------
Static Function A2CodVendF3()

    //------------------------------------------------------------------------------------------------
        // Salva os Dados de Entrada que serao restaurados antes do Retorno do Procedimento
    //------------------------------------------------------------------------------------------------
    Local aArea:= GetArea()

    Local aOpcoes:= Array(0)

    //------------------------------------------------------------------------------------------------
        // Define o Titulo para f_Opcoes
    //------------------------------------------------------------------------------------------------
    Local cTitulo:= OemToAnsi("Consulta de Fornecedores")

    //------------------------------------------------------------------------------------------------
        // Obtem uma Alias Temporário Válido para uso
    //------------------------------------------------------------------------------------------------
    Local cAlias:= GetNextAlias()

    Local cSA2Filial:=xFilial("SA2")
    Local cSA2Cod:=""

    Local cF3Ret:=""
    Local cOpcoes:=""
    Local cCodRet:=""

    Local nD
    Local nJ

    //------------------------------------------------------------------------------------------------
        //Utiliza X3Tamanho para retornar o Tamanho do Campo baseado no Dicionário de Dados (SX3)
    //------------------------------------------------------------------------------------------------
    Local nTamKey:=(GetSx3Cache("A2_COD","X3_TAMANHO")+1+GetSx3Cache("A2_LOJA","X3_TAMANHO"))
    //------------------------------------------------------------------------------------------------
        //Calcula o Máximo de Elementos a serem Selecionados de Acordo com o Tamanho da Chave+Separador
    //------------------------------------------------------------------------------------------------
    Local nElemRet:=SA2->(RecCount())
    //------------------------------------------------------------------------------------------------
        //Obtem a Ordem para Pesquisa dos Registros na SA2
    //------------------------------------------------------------------------------------------------
    Local nSA2Order:=RetOrder("SA2","A2_FILIAL+A2_COD")

    Local uVarRet

    //------------------------------------------------------------------------------------------------
        //Obtem o conteúdo do campo utilizado na Consulta Padrao Customizada
    //------------------------------------------------------------------------------------------------
    DEFAULT _cSA2F3Ret:=(Space(GetSx3Cache("A2_COD","X3_TAMANHO"))+":"+Space(GetSx3Cache("A2_LOJA","X3_TAMANHO")))

    //------------------------------------------------------------------------------------------------
        //Remove o Separador
    //------------------------------------------------------------------------------------------------
    uVarRet:=StrTran(_cSA2F3Ret,",","")

    //------------------------------------------------------------------------------------------------
        //Define a Ordem para Pesquisa na Tabela SA2
    //------------------------------------------------------------------------------------------------
    SA2->(dbSetOrder(nSA2Order))

    //------------------------------------------------------------------------------------------------
        //Seleciona Todos os Vendedores
    //------------------------------------------------------------------------------------------------
    BEGINSQL ALIAS cAlias
        SELECT SA2.A2_COD
              ,SA2.A2_LOJA
              ,SA2.A2_NOME
          FROM %table:SA2% SA2
         WHERE SA2.%notDel%
           AND SA2.A2_FILIAL=%exp:cSA2Filial%
      ORDER BY %Order:SA2%
    ENDSQL

    //------------------------------------------------------------------------------------------------
        //Carrega as Opcoes para Consulta (Codigo e Nome)
    //------------------------------------------------------------------------------------------------
    While (cAlias)->(.NOT.(Eof()))
        (cAlias)->(aAdd(aOpcoes,A2_COD+":"+A2_LOJA+"-"+A2_NOME))
        cOpcoes+=(cAlias)->(A2_COD+":"+A2_LOJA)
        (cAlias)->(dbSkip())
    End While

    //------------------------------------------------------------------------------------------------
        //Libera a View da Memória
    //------------------------------------------------------------------------------------------------
    (cAlias)->(dbCloseArea())

    //------------------------------------------------------------------------------------------------
        //Executa f_Opcoes para Selecionar ou Mostrar os Registros Selecionados
    //------------------------------------------------------------------------------------------------
    IF f_Opcoes(    @uVarRet    ,;  //Variavel de Retorno
                    cTitulo     ,;  //Titulo da Coluna com as opcoes
                    @aOpcoes    ,;  //Opcoes de Escolha (Array de Opcoes)
                    @cOpcoes    ,;  //String de Opcoes para Retorno
                    NIL         ,;  //Nao Utilizado
                    NIL         ,;  //Nao Utilizado
                    .F.         ,;  //Se a Selecao sera de apenas 1 Elemento por vez
                    nTamKey     ,;  //Tamanho da Chave
                    nElemRet    ,;  //No maximo de elementos na variavel de retorno
                    .T.         ,;  //Inclui Botoes para Selecao de Multiplos Itens
                    .F.         ,;  //Se as opcoes serao montadas a partir de ComboBox de Campo ( X3_CBOX )
                    NIL         ,;  //Qual o Campo para a Montagem do aOpcoes
                    .F.         ,;  //Nao Permite a Ordenacao
                    .F.         ,;  //Nao Permite a Pesquisa
                    .F.         ,;  //Forca o Retorno Como Array
                    "%SA2"       ;  //Consulta F3
                  )
        //------------------------------------------------------------------------------------------------
            //Ajusta o Retorno caso exista o separador
        //------------------------------------------------------------------------------------------------
        IF (","$cOpcoes)
            aOpcoes:=_StrToKArr(uVarRet)
            uVarRet:=""
            aEval(aOpcoes,{uVarRet+=PadR(e,nTamKey)})
        EndIF
        //------------------------------------------------------------------------------------------------
            //Analisa o Retorno
        //------------------------------------------------------------------------------------------------
        nJ:=Len(uVarRet)
        For nD:=1 To nJ Step nTamKey
            //------------------------------------------------------------------------------------------------
                //Obtem o Codigo de Retorno Baseado no Tamanho da Chave
            //------------------------------------------------------------------------------------------------
             cCodRet:=SubStr(uVarRet,nD,nTamKey)
            //------------------------------------------------------------------------------------------------
                //Normaliza
            //------------------------------------------------------------------------------------------------
            cF3Ret+=PadR(cCodRet,nTamKey)
            //------------------------------------------------------------------------------------------------
                //Define o Retorno com o separador ","
            //------------------------------------------------------------------------------------------------
            IF (nD<nJ)
                cF3Ret+=","
            EndIF
        Next nD
    Else
        //------------------------------------------------------------------------------------------------
            //Se nao confirmou a f_Opcoes retorna o Conteudo de entrada
        //------------------------------------------------------------------------------------------------
        cF3Ret:=uVarRet
    EndIF

    //------------------------------------------------------------------------------------------------
        //Alimenta a variável Static para uso no Retorno da Consulta Padrao.
    //------------------------------------------------------------------------------------------------
    _cSA2F3Ret:=cF3Ret

    //------------------------------------------------------------------------------------------------
        //Restaura os Dados de Entrada
    //------------------------------------------------------------------------------------------------
    RestArea(aArea)

Return(cF3Ret)

//-------------------------------------------------------------------------------------
    /*
        Programa:u_DJFINR01.prw
        Funcao:_StrToKArr()
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:30/12/2014
        Desc.:Autorização para emissão de DOC/TED
        Uso:Impressão do Relatório Autorização para emissão de DOC/TED
    */
//-------------------------------------------------------------------------------------
Static Function _StrToKArr(cStr,cToken)
    Local cDToken
    DEFAULT cStr:=""
    DEFAULT cToken:=","
    cDToken:=(cToken+cToken)
    While (cDToken$cStr)
        cStr:=StrTran(cStr,cDToken,cToken+" "+cToken)
    End While
Return(StrToKArr(cStr,cToken))