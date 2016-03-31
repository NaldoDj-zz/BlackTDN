#include "totvs.ch"
#include "tryexception.ch"

#ifdef SPANISH
        #define STR0000 "AVISO!!!"
        #define STR0001 "Este Programa Irá efetuar a Contabilização CSV conforme parâmetros Selecionados"
        #define STR0002 "Contabilização CSV"
        #define STR0003 "Inicio da Contabilização"
        #define STR0004 "Final da Contabilização"
        #define STR0005 "Arquivo: "
        #define STR0006 "Não Encontrado"
        #define STR0007 "Lote Contábil ("
        #define STR0008 ")"
        #define STR0009 "Lançamento Padrão ("
        #define STR0010 ") Inválido"
        #define STR0011 "O arquivo Informado ("
        #define STR0012 ") Nãoo possui conteúdo para Contabilização"
        #define STR0013 "Contabilizando. Aguarde..."
        #define STR0014 "Ocorreram Erros Durante o Processo de Contabilizaçao. Retorne a Rotina para Visualizar o LOG de Processo"
        #define STR0015 "Contabilizando Arquivo: "
        #define STR0016 "Contabilizando no Lote: "
        #define STR0017 "Arquivo Contabilizado: "
        #define STR0018 "Para essa conta ("
        #define STR0019 ")o Código de Centro de Custo é de Preenchimento Obrigatório"
        #define STR0020 "Cancelado Pelo Usuário"
        #define STR0021 "Processando: "
#else
    #ifdef ENGLISH
        #define STR0000 "AVISO!!!"
        #define STR0001 "Este Programa Irá efetuar a Contabilização CSV conforme parâmetros Selecionados"
        #define STR0002 "Contabilização CSV"
        #define STR0003 "Inicio da Contabilização"
        #define STR0004 "Final da Contabilização"
        #define STR0005 "Arquivo: "
        #define STR0006 "Não Encontrado"
        #define STR0007 "Lote Contábil ("
        #define STR0008 ")"
        #define STR0009 "Lançamento Padrão ("
        #define STR0010 ") Inválido"
        #define STR0011 "O arquivo Informado ("
        #define STR0012 ") Nãoo possui conteúdo para Contabilização"
        #define STR0013 "Contabilizando. Aguarde..."
        #define STR0014 "Ocorreram Erros Durante o Processo de Contabilizaçao. Retorne a Rotina para Visualizar o LOG de Processo"
        #define STR0015 "Contabilizando Arquivo: "
        #define STR0016 "Contabilizando no Lote: "
        #define STR0017 "Arquivo Contabilizado: "
        #define STR0018 "Para essa conta ("
        #define STR0019 ")o Código de Centro de Custo é de Preenchimento Obrigatório"
        #define STR0020 "Cancelado Pelo Usuário"
        #define STR0021 "Processando: "
    #else
        #define STR0000 "AVISO!!!"
        #define STR0001 "Este Programa Irá efetuar a Contabilização CSV conforme parâmetros Selecionados"
        #define STR0002 "Contabilização CSV"
        #define STR0003 "Inicio da Contabilização"
        #define STR0004 "Final da Contabilização"
        #define STR0005 "Arquivo: "
        #define STR0006 "Não Encontrado"
        #define STR0007 "Lote Contábil ("
        #define STR0008 ")"
        #define STR0009 "Lançamento Padrão ("
        #define STR0010 ") Inválido"
        #define STR0011 "O arquivo Informado ("
        #define STR0012 ") Nãoo possui conteúdo para Contabilização"
        #define STR0013 "Contabilizando. Aguarde..."
        #define STR0014 "Ocorreram Erros Durante o Processo de Contabilizaçao. Retorne a Rotina para Visualizar o LOG de Processo"
        #define STR0015 "Contabilizando Arquivo: "
        #define STR0016 "Contabilizando no Lote: "
        #define STR0017 "Arquivo Contabilizado: "
        #define STR0018 "Para essa conta ("
        #define STR0019 ")o Código de Centro de Custo é de Preenchimento Obrigatório"
        #define STR0020 "Cancelado Pelo Usuário"
        #define STR0021 "Processando: "
    #endif
#endif

user function CSV2CTB()

    Local aArea:=GetArea()

    Local bProcess:={|oProcess|CSV2CTB(@oProcess,@cPerg,@lError)}

    Local cPerg:="U_CSV2CTB"
    Local cDescri:=OemToAnsi(STR0001)

    Local dSvDataBase:=dDataBase

    Local lError:=.F.

    Local oProcess

    Private aRotina:={;
                                {"","",0,1},;
                                {"","",0,2},;
                                {"","",0,3},;
                                {"","",0,4};
                             }

    Private Inclui:=.T.

    Private cProcess:=ProcName()
    Private cCadastro:=OemtoAnsi(STR0002)
    
    Private aCSVLine:=Array(0)

    if .not.(Type("cCancel")=="C")
        Private cCancel:=STR0020
    endif   
    
    oProcess:=tNewProcess():New(cProcess,cCadastro,bProcess,cDescri,cPerg,NIL,NIL,NIL,NIL,.T.,.F.)

    if (lError)
        MsgAlert(STR0014,STR0000)
    endif

    dDataBase:=dSvDataBase

    RestArea(aArea)

return(NIL)

static function CSV2CTB(oProcess,cPerg,lError)

    Local oException
    
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

    Local cFile:=AllTrim(MV_PAR03)
    Local cLote:=MV_PAR04
    Local cPadrao:=MV_PAR06
    Local cToken:=IF(MV_PAR07==1,",",IF(MV_PAR07==2,";","|"))
    
    Local cRecNo
    Local cRecNos
    Local cCSVLine

    Local dSvDtBase:=dDataBase

    Local lHead:=.F.
    Local lPadrao:=.F.
    Local lAglut:=(MV_PAR02==1)
    Local lDigita:=(MV_PAR01==1)
    Local lQuebra:=(MV_PAR05==1)

    Local nTotal
    Local nValor
    Local nHdlPrv

    Local nRecNos
    
    Local oException

    TRYEXCEPTION

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
            cRecNo:=StrZero(ft_fRecNo(),10)
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
