#include "totvs.ch"
#include "tryexception.ch"

#ifdef SPANISH
        #define STR0000 "AVISO!!!"
        #define STR0001 "Este Programa Ira efetuar a Contabilizacao CSV conforme parametros Selecionados"
        #define STR0002 "Contabilizacao CSV"
        #define STR0003 "Inicio da Contabilizacao"
        #define STR0004 "Final da Contabilizacao"
        #define STR0005 "Arquivo: "
        #define STR0006 "Nao Encontrado"
        #define STR0007 "Lote Contabil ("
        #define STR0008 ")"
        #define STR0009 "Lancamento Padrao ("
        #define STR0010 ") Invalido"
        #define STR0011 "O arquivo Informado ("
        #define STR0012 ") Nao possui conteudo para Contabilizacao"
        #define STR0013 "Contabilizando. Aguarde..."
        #define STR0014 "Ocorreram Erros Durante o Processo de Contabilizacao. Retorne a Rotina para Visualizar o LOG de Processo"
        #define STR0015 "Contabilizando Arquivo: "
        #define STR0016 "Contabilizando no Lote: "
        #define STR0017 "Arquivo Contabilizado: "
        #define STR0018 "Para essa conta ("
        #define STR0019 ")o Codigo de Centro de Custo e de Preenchimento Obrigatorio"
        #define STR0020 "Cancelado Pelo Usuario"
        #define STR0021 "Processando: "
#else
    #ifdef ENGLISH
        #define STR0000 "AVISO!!!"
        #define STR0001 "Este Programa Ira efetuar a Contabilizacao CSV conforme parametros Selecionados"
        #define STR0002 "Contabilizacao CSV"
        #define STR0003 "Inicio da Contabilizacao"
        #define STR0004 "Final da Contabilizacao"
        #define STR0005 "Arquivo: "
        #define STR0006 "Nao Encontrado"
        #define STR0007 "Lote Contabil ("
        #define STR0008 ")"
        #define STR0009 "Lancamento Padrao ("
        #define STR0010 ") Invalido"
        #define STR0011 "O arquivo Informado ("
        #define STR0012 ") Nao possui conteudo para Contabilizacao"
        #define STR0013 "Contabilizando. Aguarde..."
        #define STR0014 "Ocorreram Erros Durante o Processo de Contabilizacao. Retorne a Rotina para Visualizar o LOG de Processo"
        #define STR0015 "Contabilizando Arquivo: "
        #define STR0016 "Contabilizando no Lote: "
        #define STR0017 "Arquivo Contabilizado: "
        #define STR0018 "Para essa conta ("
        #define STR0019 ")o Codigo de Centro de Custo e de Preenchimento Obrigatorio"
        #define STR0020 "Cancelado Pelo Usuario"
        #define STR0021 "Processando: "
    #else
        #define STR0000 "AVISO!!!"
        #define STR0001 "Este Programa Ira efetuar a Contabilizacao CSV conforme parametros Selecionados"
        #define STR0002 "Contabilizacao CSV"
        #define STR0003 "Inicio da Contabilizacao"
        #define STR0004 "Final da Contabilizacao"
        #define STR0005 "Arquivo: "
        #define STR0006 "Nao Encontrado"
        #define STR0007 "Lote Contabil ("
        #define STR0008 ")"
        #define STR0009 "Lancamento Padrao ("
        #define STR0010 ") Invalido"
        #define STR0011 "O arquivo Informado ("
        #define STR0012 ") Nao possui conteudo para Contabilizacao"
        #define STR0013 "Contabilizando. Aguarde..."
        #define STR0014 "Ocorreram Erros Durante o Processo de Contabilizacao. Retorne a Rotina para Visualizar o LOG de Processo"
        #define STR0015 "Contabilizando Arquivo: "
        #define STR0016 "Contabilizando no Lote: "
        #define STR0017 "Arquivo Contabilizado: "
        #define STR0018 "Para essa conta ("
        #define STR0019 ")o Codigo de Centro de Custo e de Preenchimento Obrigatorio"
        #define STR0020 "Cancelado Pelo Usuario"
        #define STR0021 "Processando: "
    #endif
#endif

user function CSV2CTB()

    Local aArea as Array

    Local bProcess as Block

    Local cPerg as Character
    Local cDescri as Character

    Local dSvDataBase as Date

    Local lError as Logical

    Local oProcess as Object

    Private aRotina as Array

    Private Inclui as Logical

    Private cProcess as Character
    Private cCadastro as Character

    Private aCSVLine as Array

    if .not.(Type("cCancel")=="C")
        Private cCancel as Character
        cCancel:=STR0020
    endif

    aArea:=GetArea()
    bProcess:={|oProcess|CSV2CTB(@oProcess,@cPerg,@lError)}
    cPerg:="U_CSV2CTB"
    cDescri:=OemToAnsi(STR0001)
    dSvDataBase:=dDataBase

    aRotina:={;
                {"","",0,1},;
                {"","",0,2},;
                {"","",0,3},;
                {"","",0,4};
   }

   Inclui:=.T.

   cProcess:=ProcName()
   cCadastro:=OemtoAnsi(STR0002)

   aCSVLine:=Array(0)

   oProcess:=tNewProcess():New(cProcess,cCadastro,bProcess,cDescri,cPerg,NIL,NIL,NIL,NIL,.T.,.F.)

    if (lError)
        MsgAlert(STR0014,STR0000)
    endif

    dDataBase:=dSvDataBase

    RestArea(aArea)

return(NIL)

static function CSV2CTB(oProcess,cPerg,lError)

    Local oException as Object

    Pergunte(cPerg,.F.)

    oProcess:SaveLog(OemToAnsi(STR0003))

    TRYEXCEPTION

        if .not.(PgsExclusive())
           UserException(GetHelp("PGSEXC"))
        endif

        if (FindFunction("CTBSERIALI"))
            While !(CTBSerialI("CTBPROC","ON"))
            End While
        endif

        CSVToCTB(oProcess,@lError)

        if (FindFunction("CTBSERIALF"))
            CTBSerialF("CTBPROC","ON")
        endif

    CATCHEXCEPTION USING oException

        lError:=.T.
        oProcess:SaveLog("ERRO: "+OemToAnsi(oException:Description))

    ENDEXCEPTION

    PgsShared()

    oProcess:SaveLog(OemToAnsi(STR0004))

return(NIL)

static function CSVToCTB(oProcess,lError)

    Local cFile as Character
    Local cLote as Character
    Local cPadrao as Character
    Local cToken as Character

    Local cRecNo as Character
    Local cRecNos as Character
    Local cCSVLine as Character

    Local dSvDtBase as Date

    Local lHead as Logical
    Local lPadrao as Logical
    Local lAglut as Logical
    Local lDigita as Logical
    Local lQuebra as Logical

    Local nTotal as Numeric
    Local nValor as Numeric
    Local nHdlPrv as Numeric

    Local nRecNo as Numeric
    Local nRecNos  as Numeric

    Local oException as Object

    dSvDtBase:=dDataBase

    TRYEXCEPTION

        cFile:=AllTrim(MV_PAR03)
        cLote:=MV_PAR04
        cPadrao:=MV_PAR06
        cToken:=IF(MV_PAR07==1,",",IF(MV_PAR07==2,";","|"))

        lHead:=.F.
        lPadrao:=.F.
        lAglut:=(MV_PAR02==1)
        lDigita:=(MV_PAR01==1)
        lQuebra:=(MV_PAR05==1)

        if Empty(cFile)
            UserException(GetHelp("NOFLEIMPOR")+" "+OemToAnsi(STR0005+cFile+" "+STR0006))
        endif

        oProcess:SaveLog(STR0015+cLote)

        if Empty(cLote)
            UserException(GetHelp("NOCT210LOT")+" "+OemToAnsi(STR0007+cLote+STR0008))
        endif

        oProcess:SaveLog(STR0016+cLote)

        lPadrao:=VerPadrao(cPadrao)
        if .not.(lPadrao)
            UserException(GetHelp("NOLANCPADRAO")+" "+OemToAnsi(STR0009+cPadrao+STR0010))
        endif

        ft_fUse(cFile)

        nRecNos:=ft_fLastRec()

        if (Empty(nRecNos))
            UserException(OemToAnsi(STR0011+cFile+STR0012))
        endif

        oProcess:SetRegua1(nRecNos)
        oProcess:SetRegua2(nRecNos)
        cRecNos:=StrZero(nRecNos,10)

        while (.not.(ft_fEof()))

            //"Contabilizando. Aguarde..."
            oProcess:IncRegua1(STR0013)
            if (oProcess:lEnd)
                UserException(cCancel)
            endif

            //Atualiza aCSVLine com a Linha Corrente
            cCSVLine:=ft_fReadLn()
            aCSVLine:=StrTokArr(cCSVLine,cToken)

            if .not.(lHead)
                lHead:=.T.
                nHdlPrv:=HeadProva(cLote,cProcess,SubStr(cUsuario,7,6),@cFile)
            endif

            nTotal+=DetProva(nHdlPrv,cPadrao,cProcess,cLote)

            if (lQuebra)
                //Cada linha contabilizada sera um documento
                RodaProva(@nHdlPrv,@nTotal)
                cA100Incl(@cFile,@nHdlPrv,3,@cLote,@lDigita,@lAglut)
                lHead:=.F.
            endif

            //"Processando: "
            nRecNo++
            cRecNo:=StrZero(nRecNo,10)
            oProcess:IncRegua2(STR0021+"["+cRecNo+"/"+cRecNos+"]")
            if (oProcess:lEnd)
                UserException(cCancel)
            endif

            ft_fSkip()

        end while

        ft_fUse()

        if (lHead)
            RodaProva(@nHdlPrv,@nTotal)
            cA100Incl(@cFile,@nHdlPrv,3,@cLote,@lDigita,@lAglut)
        endif

        oProcess:SaveLog(STR0017+cFile)

    CATCHEXCEPTION USING oException

        ft_fUse()
        lError:=.T.
        oProcess:SaveLog("ERRO: "+OemToAnsi(oException:Description))

    ENDEXCEPTION

    dDataBase:=dSvDtBase

return(NIL)

static function GetHelp(cHelp)
return(StrTran(Ap5GetHelp(cHelp),CRLF," "))

static function ChkCSVLine(nAT)
    if (type("aCSVLine")=="A")
        return(Len(aCSVLine)>=nAT)
    endif
return(.F.)

static function GetCSVLine(nAT)
    if ChkCSVLine(nAT)
        return(aCSVLine[nAT])
    endif
return("")

static function __Dummy()
    if (.f.)
        GetCSVLine()
        __Dummy()
    endif
return(.f.)
