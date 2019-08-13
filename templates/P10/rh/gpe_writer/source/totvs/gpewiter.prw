#include "shell.ch"
#include "fileio.ch"
#include "dbStruct.ch"
#include "RWMAKE.CH"
#include "PRCONST.CH"
#include "PROTHEUS.CH"
#include "GPEWRITER.CH"

#define GPE_WRITER_VERSION "2019.03.20"

/*
    Programa:GpeWriter
    Autor:R.H
    Data:05/07/2000
    Descricao:Impressao de Documentos tipo OpenOffice Writer
    Sintaxe:Chamada padrao para programas em "RdMake".
    Uso:Generico
    Obs.:
-------------------------------------------------------------------------
            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.
-------------------------------------------------------------------------
Programador        |Data      |Motivo Alteracao
-------------------------------------------------------------------------
                   |DD/MM/YYYY|
-------------------------------------------------------------------------*/
procedure u_GpeWriter()

    local aArea     as array
    local aAreaSRA  as array
    local aAreaSRB  as array
    
    local cDir      as character
    local cError    as character
    
    local nAttempts as numeric

    aArea:=getArea()
    aAreaSRA:=SRA->(getArea())
    aAreaSRB:=SRB->(getArea())

    begin sequence
        cDir:="\gpe_writer\"
        nAttempts:=0
        While !(lIsDir(cDir))
            if (++nAttempts>10)
                cError:="Diretorio "+cDir+" Nao Encontrado"
                ApMsgAlert(cError,"A T E N C A O !!!")
                break
            endif
            Sleep(100)
            MakeDir(cDir)
        end While
        GpeWriter(cDir)
    end sequence
    
    restArea(aAreaSRB)
    restArea(aAreaSRA)
    restArea(aArea)

    return

/*
    Programa:GpeWriter
    Funcao:GpeWriter()
    Autor:R.H.
    Data:05/07/2000
    Descricao:Impressao de Documentos tipo OpenOffice Writer
    Sintaxe:Chamada padrao para programas em "RdMake".
    Uso:Generico
    Obs.:
-------------------------------------------------------------------------
            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.
-------------------------------------------------------------------------
Programador        |Data      |Motivo Alteracao
-------------------------------------------------------------------------
                   |DD/MM/YYYY|
-------------------------------------------------------------------------*/
static procedure GpeWriter(cDir)

    local aAdvSize      as array
    local aObjSize      as array
    local aGDCoord      as array
    local aObjCoords    as array
    local aInfoAdvSize  as array

    local bPrint        as block
    
    local cWriteChgVer  as character
    local cWriteAtuVer  as character
    local lWriteChgVer  as character

    local oDlg          as object
    local oFont         as object
 
    private cCadastro   as character
    cCadastro:=STR0001
    
    private cPerg       as character 
    cPerg:=Padr("GPEWRITER",10/*Len(SX1->X1_GRUPO)*/)
    
    private aInfo       as array
    
    private aDepenIR    as array
    aDepenIR:=array(0)
    
    private aDepenSF    as array
    aDepenSF:=array(0)
    
    private aPerSRF     as array
    aPerSRF:=array(0)
    
    private nDepen      as numeric
    nDepen:=0    
    
    private lDepSf      as logical
    lDepSf:=Iif(SRA->(FieldPos("RA_DEPSF"))>0,.T.,.F.)
    
    private lDepende    as logical
    private nDepende    as numeric
    
    ChkProFile(.F.)
    
    cWriteChgVer:=cDir+"gpe_witer.ver"
    cWriteAtuVer:=GPE_WRITER_VERSION
    lWriteChgVer:=!(MemoRead(cWriteChgVer)==cWriteAtuVer)
    if (lWriteChgVer)
        ValidPerg(@cPerg)
        MemoWrite(cWriteChgVer,cWriteAtuVer)
    endif
    
    aInfo:=array(0)
    fInfo(@aInfo,xFilial("SRA"))
    
    aAdvSize:=MsAdvSize()
    aAdvSize[5]:=(aAdvSize[5]/100)*60// Horizontal
    aAdvSize[6]:=(aAdvSize[6]/100)*40// Vertical
    aInfoAdvSize:={aAdvSize[1],aAdvSize[2],aAdvSize[3],aAdvSize[4],0,0}
    aObjCoords:=array(0)
    aAdd(aObjCoords,{000,000,.T.,.T.})
    aObjSize:=MsObjSize(aInfoAdvSize,aObjCoords)
    aGDCoord:={(aObjSize[1,1]+3),(aObjSize[1,2]+5),(((aObjSize[1,3])/100)*20),(((aObjSize[1,4])/100)*59)}// 1,3 Vertical /1,4 Horizontal
    
    oFont:=TFont():New("Arial",nil,14,nil,.T.)
    DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0001) From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF getWndDefault() PIXEL
        //-------------------------------------------------------------
        @ aGDCoord[1]+00,aGDCoord[2]+00 TO aGDCoord[3],aGDCoord[4] PIXEL
        //-------------------------------------------------------------
        @ aGDCoord[1]+10,aGDCoord[2]+10 SAY OemToAnsi(STR0002) PIXEL
        @ aGDCoord[1]+20,aGDCoord[2]+10 SAY OemToAnsi(STR0003) PIXEL
        //-------------------------------------------------------------
        @ (((aObjSize[1,3])/100)*25),(aGDCoord[4]/2)-196 BMPBUTTON TYPE 5 ACTION (Pergunte(cPerg,.T.),SetDepende())
        @ (((aObjSize[1,3])/100)*25),(aGDCoord[4]/2)-166 BMPBUTTON TYPE 2 ACTION oDlg:end()
        //-------------------------------------------------------------
        @ (((aObjSize[1,3])/100)*25),(aGDCoord[4]/2)+031 BUTTON OemToAnsi(STR0004) SIZE 55,12 ACTION (Pergunte(cPerg,.F.),SetDepende(),fVarW_Imp()) OF oDlg PIXEL FONT oFont
        @ (((aObjSize[1,3])/100)*25),(aGDCoord[4]/2)+088 BUTTON OemToAnsi(STR0242) SIZE 55,12 ACTION MsAguarde({||Pergunte(cPerg,.F.),SetDepende(),GPE2Writer(.T.,@aInfo)},"Exportando Variaveis") OF oDlg PIXEL FONT oFont
        bPrint:={|lEnd|Pergunte(cPerg,.F.),SetDepende(),fWord_Imp(lEnd,oDlg)}
        @ (((aObjSize[1,3])/100)*25),(aGDCoord[4]/2)+145 BUTTON OemToAnsi(STR0005) SIZE 55,12 ACTION Processa(bPrint,cCadastro,nil,.T.) OF oDlg PIXEL FONT oFont
        //-------------------------------------------------------------
    ACTIVATE MSDIALOG oDlg CENTERED
    
    return
    
/*
    Programa:GpeWriter
    Funcao:fWord_Imp()
    Autor:R.H.
    Data:05/07/2000
    Descricao:Impressao de Documentos tipo OpenOffice Writer
    Sintaxe:Chamada padrao para programas em "RdMake".
    Uso:Generico
    Obs.:
-------------------------------------------------------------------------
            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.
-------------------------------------------------------------------------
Programador        |Data      |Motivo Alteracao
-------------------------------------------------------------------------
                   |DD/MM/YYYY|
-------------------------------------------------------------------------*/
static function fWord_Imp(lEnd,oDlg)

    local aLog:=Array(0)
    local aSaveExt:={".odt",".ott",".dot",".doc",".pdf",".htm",".html",".rtf"}

    local cMsg:=""
    local cCRLF:=CRLF
    local cError
    local cExclui:=""
    local aCpos_Word:={}
    local nX:=0
    local cAcessaSRA:=&(" {|| "+ChkRH("GPEWRITER","SRA","2")+"} ")

#ifDEF TOP
    local cStr
    local nStr
    local nStrT
    local CINDEXKEY
    local aStrSRA
#endif
    local cFilDe:=&("MV_PAR01")
    local cFilAte:=&("MV_PAR02")
    local cCCDe:=&("MV_PAR03")
    local cCCAte:=&("MV_PAR04")
    local cMatDe:=&("MV_PAR05")
    local cMatAte:=&("MV_PAR06")
    local cNomeDe:=&("MV_PAR07")
    local cNomeAte:=&("MV_PAR08")
    local cTnoDe:=&("MV_PAR09")
    local cTnoAte:=&("MV_PAR10")
    local cFunDe:=&("MV_PAR11")
    local cFunAte:=&("MV_PAR12")
    local cSindDe:=&("MV_PAR13")
    local cSindAte:=&("MV_PAR14")
    local dAdmiDe:=&("MV_PAR15")
    local cAdmiDe:=Dtos(dAdmiDe)
    local dAdmiAte:=&("MV_PAR16")
    local cAdmiAte:=Dtos(dAdmiAte)
    local cSituacao:=&("MV_PAR17")
    local cCategoria:=&("MV_PAR18")
    local nCopias:=Max(&("MV_PAR23"),1)
    local nOrdem:=&("MV_PAR24")
    local cArqWord:=AllTrim(&("MV_PAR25"))
    local lImpress:=(&("MV_PAR28")==1)
    local cSaveExt:=Lower(AllTrim(&("MV_PAR29")))
    local lPreview:=(&("MV_PAR31")==2)

    local cAux:=""
    local cPath:=GETTEMPPATH()
    local cArqSaida:=""
    local nAT:=0

    local lServer
    local lPrinter
    local cSession
    local cPrinter
    local cOrientation
    
    local cSRAAlias
    local nSRARecNo
    
    local cArqNtx

    local lRet:=.F.
    local lError:=.F.

    BEGIN SEQUENCE

        //?-Checa o SO do Remote (1=Windows,2=Linux)
        if GetRemoteType()==2
            lError:=.T.
            cError:=OemToAnsi(STR0167)
            ApMsgAlert(cError,OemToAnsi(STR0168))    //?-"Integracao Word funciona somente com Windows !!!")###"Atencao !"
            aAdd(aLog,cError)
            BREAK
        endif

        if (lImpress)

            lPrinter:=PrinterSetup()
            if !(lPrinter)
                lError:=.T.
                cError:="Impressao Cancelada.Para imprimir confirme a Configuracao da Impressora"
                ApMsgAlert(cError,"A T E N C A O !!!")
                aAdd(aLog,cError)
                BREAK
            endif

            cSession:=GetPrinterSession()
            lServer:=(GetProfString(cSession,"local","SERVER",.T.)=="SERVER")

            While (lServer)
                ApMsgAlert("Impressao disponivel apenas no Client.Reconfigure a Impressora","A T E N C A O !!!")
                lPrinter:=PrinterSetup()
                if !(lPrinter)
                    lError:=.T.
                    cError:="Impressao Cancelada.Para imprimir confirme a Configuracao da Impressora"
                    ApMsgAlert(cError,"A T E N C A O !!!")
                    aAdd(aLog,cError)
                    BREAK
                endif
                lServer:=(GetProfString(cSession,"local","SERVER",.T.)=="SERVER")
            end While

            lPrinter:=IsPrinterOk()
            if !(lPrinter)
                lError:=.T.
                cError:="Problemas na Configuracao da Impressora"
                ApMsgAlert(cError,"A T E N C A O !!!")
                aAdd(aLog,cError)
                BREAK
            endif

            cPrinter:=GetProfString(cSession,"DEFAULT","",.T.)
            if Empty(cPrinter)
                lError:=.T.
                cError:="Problemas na Configuracao da Impressora"
                ApMsgAlert(cError,"A T E N C A O !!!")
                aAdd(aLog,cError)
                BREAK
            endif
            cOrientation:=Upper(AllTrim(GetProfString(cSession,"ORIENTATION","",.T.)))

        else

            cPrinter:=""
            cOrientation:=""

            if (;
                    Empty(cSaveExt);
                    .or.;
                    !("." $ cSaveExt);
                    .or.;
                    (aScan(aSaveExt,cSaveExt)==0);
            )
                lError:=.T.
                cError:="Extensao Invalida.Os Tipos de Extensoes validos sao:"+cCRLF
                aAdd(aLog,cError)
                aEval(aSaveExt,{|e| cError+=(e+cCRLF),aAdd(aLog,e)})
                ApMsgAlert(cError,"A T E N C A O !!!")
                BREAK
            endif

        endif

        nDepen:=if(!lDepende,4,nDepende)

        if substr(cArqWord,2,1)<>":"
            cAux:=cArqWord
            nAT:=1
            for nX:=1 to len(cArqWord)
                cAux:=substr(cAux,if(nX==1,nAt,nAt+1),len(cAux))
                nAt:=at("\",cAux)
                if nAt==0
                    exit
                endif
            next nX
            CpyS2T(cArqWord,cPath,.T.)
            cArqWord:=cPath+cAux
        endif

        SRA->(dbSetOrder(nOrdem))
        SRA->(dbGotop())

        cExclui+="{|| "
        cExclui+="(RA_FILIAL<'"+cFilDe+"'.or.RA_FILIAL>'"+cFilAte+"').or."
        cExclui+="(RA_MAT<'"+cMatDe+"'.or.RA_MAT>'"+cMatAte+"').or."
        cExclui+="(RA_CC<'"+cCCDe+"'.or.RA_CC>'"+cCCAte+"').or."
        cExclui+="(RA_NOME<'"+cNomeDe+"'.or.RA_NOME>'"+cNomeAte+"').or."
        cExclui+="(RA_TNOTRAB<'"+cTnoDe+"'.or.RA_TNOTRAB>'"+cTnoAte+"').or."
        cExclui+="(RA_CODFUNC<'"+cFunDe+"'.or.RA_CODFUNC>'"+cFunAte+"').or."
        cExclui+="(RA_SINDICA<'"+cSindDe+"'.or.RA_SINDICA>'"+cSindAte+"').or."
        cExclui+="(DtoS(RA_ADMISSA)<'"+cAdmiDe+"'.or.DtoS(RA_ADMISSA)>'"+cAdmiAte+"').or."
        cExclui+="!(RA_SITFOLH$'"+cSituacao+"').or.!(RA_CATFUNC$'"+cCategoria+"')"
        cExclui+="} "

        #ifNDEF TOP
            
            cSRAAlias:="SRA"

            if nOrdem==1                                   //Matricula
                SRA->(dbSeek(cFilDe+cMatDe,.T.))
                cInicio:='{|| RA_FILIAL+RA_MAT}'
                cFim:=cFilAte+cMatAte
            elseif nOrdem==2                            //Centro de Custo
                SRA->(dbSeek(cFilDe+cCCDe+cMatDe,.T.))
                cInicio:='{|| RA_FILIAL+RA_CC+RA_MAT}'
                cFim:=cFilAte+cCcAte+cMatAte
            elseif nOrdem==3                            //Nome
                SRA->(dbSeek(cFilDe+cNomeDe+cMatDe,.T.))
                cInicio:='{|| RA_FILIAL+RA_NOME+RA_MAT}'
                cFim:=cFilAte+cNomeAte+cMatAte
            elseif nOrdem==4                            //Turno
                SRA->(dbSeek(cFilDe+cTnoDe,.T.))
                cInicio:='{|| RA_FILIAL+RA_TNOTRAB} '
                cFim:=cFilAte+cCcAte+cNomeAte
            elseif nOrdem==5                            //Admissao
                cIndCond:="RA_FILIAL+DTOS(RA_ADMISSA)"
                cArqNtx:=CriaTrab(nil,.F.)
                SRA->(IndRegua("SRA",cArqNtx,cIndCond,,,STR0162))        //"Selecionando Registros..."
                SRA->(dbSeek(cFilDe+DTOS(dAdmiDe),.T.))
                cInicio:='{|| RA_FILIAL+DTOS(RA_ADMISSA)}'
                cFim:=cFilAte+DTOS(dAdmiAte)
            endif

        #else

            aStrSRA:=SRA->(dbStruct())

            cStr:=cSituacao
            nStr:=0
            nStrT:=Len(cStr)
            cSituacao:=""
            While (++nStr<=nStrT)
                cSituacao+="'"+SubStr(cStr,nStr,1)+"'"
                if.NOT.(nStr==nStrT)
                    cSituacao+=","
                endif
            end While
            cSituacao:="%("+cSituacao+")%"

            cStr:=cCategoria
            nStr:=0
            nStrT:=Len(cStr)
            cCategoria:=""
            While (++nStr<=nStrT)
                cCategoria+="'"+SubStr(cStr,nStr,1)+"'"
                if.NOT.(nStr==nStrT)
                    cCategoria+=","
                endif
            end While
            cCategoria:="%("+cCategoria+")%"

            if nOrdem==1//Matricula
                CINDEXKEY:="SRA.RA_FILIAL,SRA.RA_MAT"
            elseif nOrdem==2 //Centro de Custo
                CINDEXKEY:="SRA.RA_FILIAL,SRA.RA_CC,SRA.RA_MAT"
            elseif nOrdem==3//Nome
                CINDEXKEY:="SRA.RA_FILIAL,SRA.RA_NOME,SRA.RA_MAT"
            elseif nOrdem==4//Turno
                CINDEXKEY:="SRA.RA_FILIAL,SRA.RA_TNOTRAB"
            elseif nOrdem==5//Admissao
                CINDEXKEY:="SRA.RA_FILIAL,SRA.RA_ADMISSA"
            endif
            
            CINDEXKEY:=("%"+CINDEXKEY+"%")

            cSRAAlias:=getnextAlias()
            
            BEGINSQL ALIAS cSRAAlias
                SELECT
                    SRA.R_E_C_N_O_ SRARECNO
                FROM %table:SRA% SRA
                WHERE SRA.%notDel%
                  AND SRA.RA_FILIAL=SRA.RA_FILIAL
                  AND SRA.RA_FILIAL  BETWEEN %exp:cFilDe%  AND %exp:cFilAte%
                  AND SRA.RA_CC      BETWEEN %exp:cCCDe%   AND %exp:cCCAte%
                  AND SRA.RA_MAT     BETWEEN %exp:cMatDe%  AND %exp:cMatAte%
                  AND SRA.RA_NOME    BETWEEN %exp:cNomeDe% AND %exp:cNomeAte%
                  AND SRA.RA_TNOTRAB BETWEEN %exp:cTnoDe%  AND %exp:cTnoAte%
                  AND SRA.RA_CODFUNC BETWEEN %exp:cFunDe%  AND %exp:cFunAte%
                  AND SRA.RA_SINDICA BETWEEN %exp:cSindDe% AND %exp:cSindAte%
                  AND SRA.RA_ADMISSA BETWEEN %exp:cAdmiDe% AND %exp:cAdmiAte%
                  AND SRA.RA_SITFOLH IN %exp:cSituacao%
                  AND SRA.RA_CATFUNC IN %exp:cCategoria%
                ORDER BY %exp:CINDEXKEY%
            endSQL
            
            aEval(aStrSRA,{|f|if(f[DBS_TYPE]$"DLN",TCSetField(cSRAAlias,f[DBS_NAME],f[DBS_TYPE],f[DBS_LEN],f[DBS_DEC]),nil)})
            aSize(aStrSRA,0)
            aStrSRA:=nil

            if (nOrdem==5)//Admissao
                cIndCond:="RA_FILIAL+DTOS(RA_ADMISSA)"
                cArqNtx:=CriaTrab(nil,.F.)
                SRA->(IndRegua("SRA",cArqNtx,cIndCond,,,STR0162))//"Selecionando Registros..."
            endif

        #endif

        ProcRegua(0)

        cFilialAnt:=Space(Len(xFilial("SRA")))

#ifNDEF TOP
        While (cSRAAlias)->(!eof().and.Eval(&(cInicio))<=cFim)
#else
        While (cSRAAlias)->(!eof())
            nSRARecNo:=(cSRAAlias)->SRARECNO
            SRA->(dbGoTo(nSRARecNo))
#endif
            IncProc()
            if (lEnd)
                aAdd(aLog,"Cancelado pelo Usuario")
                BREAK
            endif

            #ifNDEF TOP
                if SRA->(Eval(&(cExclui)))
                   (cSRAAlias)->(dbSkip())
                   Loop
                endif
            #endif

            if !(SRA->RA_FILIAL$fValidFil().and.Eval(cAcessaSRA))
                (cSRAAlias)->(dbSkip())
                Loop
            endif
            
            if SRA->RA_FILIAL # cFilialAnt
                if !fInfo(@aInfo,SRA->RA_FILIAL)
                    lError:=.T.
                    aAdd(aLog,"Nao foi possivel Carregar informacoes da Empresa")
                    BREAK
                endif
                cFilialAnt:=SRA->RA_FILIAL
            endif

            //Busca Periodo Aquisitivo
            fPesqSRF()

            cArqSaida:=SRA->RA_FILIAL
            cArqSaida+="_"
            cArqSaida+=SRA->RA_MAT
            cArqSaida+="_"
            cArqSaida+=StrTran(AllTrim(SRA->RA_NOME)," ","_")
            cArqSaida+=cSaveExt

            cError:=""
            if !(GPE2Writer(.F.,@aInfo,@cArqWord,@lImpress,@cArqSaida,@nCopias,@cPrinter,@cOrientation,@cError,@cCRLF,@lPreview))
                lError:=.T.
                aAdd(aLog,"Ocorreram Problemas na Impressao dos dados do funcionario:")
                aAdd(aLog,"Filial:"+SRA->RA_FILIAL)
                aAdd(aLog,"Matricula:"+SRA->RA_MAT)
                aAdd(aLog,"Nome:"+SRA->RA_NOME)
                if Empty(cError)
                    cError:="UNDEFINED"
                endif
                aAdd(aLog,"Erro:"+cError)
                aAdd(aLog,"")
            else
                if (lImpress)
                    aAdd(aLog,"Impressao OK:")
                else
                    aAdd(aLog,"Arquivo Salvo com Sucesso:")
                endif
                aAdd(aLog,"Filial:"+SRA->RA_FILIAL)
                aAdd(aLog,"Matricula:"+SRA->RA_MAT)
                aAdd(aLog,"Nome:"+SRA->RA_NOME)
                if.not.(lImpress)
                    aAdd(aLog,"Arquivo:"+cArqSaida)
                endif
                aAdd(aLog,"")
            endif

            (cSRAAlias)->(dbSkip())

        end While

        lRet:=.T.

    end Sequence

    if Len(cAux)>0
        fErase(cArqWord)
    endif

#ifDEF TOP
    (cSRAAlias)->(dbCloseArea())
#endif

    dbSelectArea("SRA")

    //--APAGA OS INDICES TEMPORARIOS--//
    if (nOrdem==5)
        RetIndex("SRA")
        if File(cArqNtx+OrdBagExt())
            fErase(cArqNtx+OrdBagExt())
        endif
        if File(cArqNtx+IndexExt())
            fErase(cArqNtx+IndexExt())
        endif
    endif

    if !Empty(aLog)
        fMakeLog({aLog},{"Log de Ocorrencias na Integracao com o OpenOffice Writer"},cPerg,.T.,nil,cCadastro,nil,nil,nil,.F.)
        aSize(aLog,0)
    endif

    if.NOT.(lError)
        if (lImpress)
            cMsg:="Impressao Finalizada.Deseja Imprimir novos Documentos?"
        else
            cMsg:="Salvamento Finalizado.Deseja Salvar novos Documentos?"
        endif
        if.NOT.(MsgYesNo(cMsg))
            oDlg:end()
        endif
    endif

    return(lRet)

/*
    Programa:GpeWriter
    Funcao:U_WriteFOpen()
    Autor:R.H.
    Data:05/07/2000
    Descricao:Selecionar o Arquivo Modelo
    Sintaxe:Chamada padrao para programas em "RdMake".
    Uso:Generico
    Obs.:

-------------------------------------------------------------------------
            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.
-------------------------------------------------------------------------
Programador        |Data      |Motivo Alteracao
-------------------------------------------------------------------------
                   |DD/MM/YYYY|
-------------------------------------------------------------------------*/
function u_WriteFOpen() as logical

    local aArea         as array
    
    local cTipo         as character
    local cPath         as character
    local cfGetFile     as character
    local cNewPathArq   as character

    local lRet          as logical
    local lAchou        as logical
    
    aArea:=getArea()
    cTipo:=STR0006//"*.DOT,*.DOC,*.ODT,*.OTT|*.DOT|*.DOC|*.ODT|*.OTT"
    
    cPath:=(CurDrive()+"\gpe_writer")
    cfGetFile:="cGetFile"
    cNewPathArq:=AllTrim(&cfGetFile.(cTipo,STR0007,3,cPath,.F.,GETF_localHARD,.T.,.T.))
    
    DEFAULT lAchou:=.F.
    
    begin sequence
    
        if !Empty(cNewPathArq)
            if (Len(cNewPathArq)>75)
                ApMsgAlert(STR0187,STR0168) //"O endereco completo do local onde esta o arquivo do Word excedeu o limite de 75 caracteres!"
                lRet:=.F.
                break
            else
                //"[DOT][DOC][ODT][OTT]"
                if Upper(Subst(AllTrim(cNewPathArq),-3)) $ Upper(AllTrim(STR0008))
                    ApMsgAlert(cNewPathArq,STR0009)
                else
                    ApMsgAlert(STR0011,STR0168)
                    lRet:=.F.
                    break
                endif
            endif
        else
            ApMsgAlert(STR0007,STR0012)
            lRet:=.F.
            break
        endif
        
        /*
        dbSelectArea("SX1")
        if lAchou:=(SX1->(dbSeek(cPerg+"25",.T.)))
            if SX1->(RecLock("SX1",.F.,.T.))
                SX1->X1_CNT01:=Space(Len(SX1->X1_CNT01))
                &("MV_PAR25"):=cNewPathArq
                SX1->(MsUnLock())
            endif
        endif
        */
        
        &("MV_PAR25"):=cNewPathArq
    
        lRet:=.T.
 
    end sequence
    
    restArea(aArea)
    
    return(lRet)

/*
    Programa:GpeWriter
    Funcao:fVarW_Imp()
    Autor:R.H.
    Data:05/07/2000
    Descricao:Impressao das Variaveis disponiveis para uso
    Sintaxe:Chamada padrao para programas em "RdMake".
    Uso:Generico
    Obs.:
-------------------------------------------------------------------------
            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.
-------------------------------------------------------------------------
Programador        |Data      |Motivo Alteracao
-------------------------------------------------------------------------
                   |DD/MM/YYYY|
-------------------------------------------------------------------------*/
static function fVarW_Imp() as character

    local aOrd      as array

    local WnRel     as character
    local cString   as character
    local cDesc1    as character
    local cDesc2    as character
    local cDesc3    as character
    
    private NOMEPROG    as character
    NOMEPROG:='GPEWRITER'
    private AT_PRG      as character
    AT_PRG:=NOMEPROG
    private aReturn     as array
    aReturn:={STR0147,1,STR0148,2,2,1,'',1}
    private wCabec0     as numeric
    wCabec0:=1
    private wCabec1     as character
    wCabec1:=STR0149
    private wCabec2     as character
    wCabec2:=""
    private wCabec3     as character
    wCabec3:=""
    private nTamanho    as character
    nTamanho:="G"
    private lEnd        as logical
    lEnd:=.F.
    private Titulo      as character
    Titulo:=cDesc1
    private Li          as numeric
    Li:=0
    private ContFl      as numeric
    ContFl:=1
    private nLastKey    as numeric
    nLastKey:=0
    
    if (type("nDepen")=="N")
        &("nDepen"):=0
    endif
    
    begin sequence

        cString:='SRA'
        aOrd:={STR0142,STR0143}
        cDesc1:=STR0144
        cDesc2:=STR0145
        cDesc3:=STR0146
    
        WnRel:="WRITER_VAR"
        WnRel:=SetPrint(cString,Wnrel,"",Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho,,.F.)
        
        if (nLastKey==27)
            break
        endif
        
        SetDefault(aReturn,cString)
        
        if (nLastKey==27)
            break
        endif
        
        RptStatus({|lEnd|fImpVar()},Titulo)

    end sequence
        
    DEFAULT WnRel:=""
    return(WnRel)

/*
    Programa:GpeWriter
    Funcao:fImpVar()
    Autor:R.H.
    Data:05/07/2000
    Descricao:Impressao das Variaveis disponiveis para uso
    Sintaxe:Chamada padrao para programas em "RdMake".
    Uso:Generico
    Obs.:
-------------------------------------------------------------------------
            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.
-------------------------------------------------------------------------
Programador        |Data      |Motivo Alteracao
-------------------------------------------------------------------------
                   |DD/MM/YYYY|
-------------------------------------------------------------------------*/
static procedure fImpVar()

    local aCpos_Word    as array
    
    local bSort         as block
    
    local cDetalhe      as character
    local cCpo_Word     as character
    
    local nX            as numeric
    local nXs           as numeric
    local nOrdem        as numeric
    
    nOrdem:=&("aReturn")[8]
    
    aCpos_Word:=fCpos_Word()
    
    if (nOrdem==1)
        bSort:={|x,y| x[1]<y[1]}
    else
        bSort:={|x,y| x[4]<y[4]}
    endif
    
    aSort(@aCpos_Word,nil,nil,@bSort)
    
    nXs:=Len(aCpos_Word)
    
    SetRegua(nXs)
    
    for nX:=1 To nXs
    
            IncRegua()
    
            if (lEnd)
               @ Prow()+1,0 PSAY &("cCancel")
               exit
            endif
    
            /*
            Mascara do Relatorio
                    10        20        30        40        50        60        70        80
            12345678901234567890123456789012345678901234567890123456789012345678901234567890
            Variaveis                      Descricao
            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*/
    
            cCpo_Word:=AllTrim(aCpos_Word[nX][1])
            cDetalhe:=if(Len(cCpo_Word)<30,cCpo_Word+(Space(30-Len(cCpo_Word))),cCpo_Word)
            cDetalhe+=AllTrim(aCpos_Word[nX][4])
    
            Impr(cDetalhe)
    
    next nX
    
    if (&("aReturn")[5]==1)
       SET PRINTER TO
       dbCommit()
       OurSpool(WnRel)
    endif
    
    MS_FLUSH()
    
    return

/*
    Programa:GpeWriter
    Funcao:fDepIR()
    Autor:R.H.
    Data:05/07/2000
    Descricao:Carrega Dependentes de Imp.de Renda
    Sintaxe:Chamada padrao para programas em "RdMake".
    Uso:Generico
    Obs.:
-------------------------------------------------------------------------
            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.
-------------------------------------------------------------------------
Programador        |Data      |Motivo Alteracao
-------------------------------------------------------------------------
                   |DD/MM/YYYY|
-------------------------------------------------------------------------*/
static function fDepIR() as array
    
    local cGrauPar      as character
    
    local cSpcNOME      as character
    local cSpcDTNASC    as character
    local cSpcGRAUPAR   as character
    
    local cSRAKey       as character
    
    local dDataRef      as date
    
    local nX            as numeric
    local nDepenIR      as numeric
    local nDiffYear     as numeric
    local nSpacePar     as numeric
    
    dDataRef:=&("dDataBase")
    
    // Consiste os dependentes  de I.R.
    nDepenIR:=0
    aSize(&("aDepenIR"),nDepenIR)
    nSpacePar:=X3Tamanho("RB_GRAUPAR")
    cSRAKey:=SRA->RA_FILIAL
    cSRAKey+=SRA->RA_MAT
    while SRB->(!eof().and.((SRB->RB_FILIAL+SRB->RB_MAT)==cSRAKey))
        nDiffYear:=DateDiffYear(dDataRef,SRB->RB_DTNASC)
        if  ((SRB->RB_TIPIR=='1')).or.;
            ((SRB->RB_TIPIR=='2').and.(nDiffYear<=21)).or.;
            ((SRB->RB_TIPIR=='3').and.(nDiffYear<=24))
            //Nome do Depend.,Dta Nascimento,Grau de parentesco
            aAdd(&("aDepenIR"),array(3))
            nDepenIR++
            &("aDepenIR")[nDepenIR][1]:=SRB->RB_NOME
            &("aDepenIR")[nDepenIR][2]:=SRB->RB_DTNASC
            if (SRB->RB_GRAUPAR=="C")
                cGrauPar:="Conjuge"
            elseif (SRB->RB_GRAUPAR=="F")
                cGrauPar:="Filho"
            else
                cGrauPar:="Outros"
            endif
            &("aDepenIR")[nDepenIR][3]:=PadR(cGrauPar,nSpacePar)
        endif
        SRB->(dbSkip())
    end while

    cSpcNOME:=Space(X3Tamanho("RB_NOME"))
    cSpcDTNASC:=Space(X3Tamanho("RB_DTNASC"))
    cSpcGRAUPAR:=Space(nSpacePar)
 
    nDepenIR:=Len(&("aDepenIR"))
    if (nDepenIR<10)
        nDepenIR:=(10-nDepenIR)
        for nX:=1 to nDepenIR
            aAdd(&("aDepenIR"),{cSpcNOME,cSpcDTNASC,cSpcGRAUPAR})
        next nX
    endif
    
    return(&("aDepenIR"))
    
/*
    Programa:GpeWriter
    Funcao:fDepSF()
    Autor:R.H.
    Data:05/07/2000
    Descricao:Carrega Dependentes de Salario Familia
    Sintaxe:Chamada padrao para programas em "RdMake".
    Uso:Generico
    Obs.:
-------------------------------------------------------------------------
            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.
-------------------------------------------------------------------------
Programador        |Data      |Motivo Alteracao
-------------------------------------------------------------------------
                   |DD/MM/YYYY|
-------------------------------------------------------------------------*/
static function fDepSF() as array
 
    local cGrauPar      as character
    
    local cSpcNOME      as character
    local cSpcDTNASC    as character
    local cSpcGRAUPAR   as character
    local cSpcLOCNASC   as character
    local cSpcCARTORI   as character
    local cSpcNREGCAR   as character
    local cSpcNUMLIVR   as character
    local cSpcNUMFOLH   as character
    local cSpcDTENTRA   as character
    local cSpcDTBAIXA   as character
    
    local cSRAKey       as character
    
    local dDataRef      as date
    
    local nX            as numeric
    local nDepenSF      as numeric
    local nDiffYear     as numeric
    local nSpacePar     as numeric
    
    dDataRef:=&("dDataBase")
    
    // Consiste os dependentes  de Sal.Fam.
    nDepenSF:=0
    aSize(&("aDepenSF"),nDepenSF)
    nSpacePar:=X3Tamanho("RB_GRAUPAR")
    cSRAKey:=SRA->RA_FILIAL
    cSRAKey+=SRA->RA_MAT
    while SRB->(!eof().and.((SRB->RB_FILIAL+SRB->RB_MAT)==cSRAKey))
        nDiffYear:=DateDiffYear(dDataRef,SRB->RB_DTNASC)
        if  ((SRB->RB_TIPSF=='1')).or.;
            ((SRB->RB_TIPSF=='2').and.(nDiffYear<=14))
            //Nome do Depend.,Dta Nascimento,Grau de parentesco
            aAdd(aDepenSF,array(10))
            nDepenSF++
            &("aDepenSF")[nDepenSF][1]:=SRB->RB_NOME
            &("aDepenSF")[nDepenSF][2]:=SRB->RB_DTNASC
            if (SRB->RB_GRAUPAR=="C")
                cGrauPar:="Conjuge"
            elseif (SRB->RB_GRAUPAR=="F")
                cGrauPar:="Filho"
            else
                cGrauPar:="Outros"
            endif
            &("aDepenSF")[nDepenSF][3]:=PadR(cGrauPar,nSpacePar)
            &("aDepenSF")[nDepenSF][4]:=SRB->RB_LOCNASC
            &("aDepenSF")[nDepenSF][5]:=SRB->RB_CARTORI
            &("aDepenSF")[nDepenSF][6]:=SRB->RB_NREGCAR
            &("aDepenSF")[nDepenSF][7]:=SRB->RB_NUMLIVR
            &("aDepenSF")[nDepenSF][8]:=SRB->RB_NUMFOLH
            &("aDepenSF")[nDepenSF][9]:=SRB->RB_DTENTRA
            &("aDepenSF")[nDepenSF][10]:=SRB->RB_DTBAIXA
        endif
        SRB->(dbSkip())
    end while

    cSpcNOME:=Space(X3Tamanho("RB_NOME"))
    cSpcDTNASC:=Space(X3Tamanho("RB_DTNASC"))
    cSpcGRAUPAR:=Space(nSpacePar)
    cSpcLOCNASC:=Space(X3Tamanho("RB_LOCNASC"))
    cSpcCARTORI:=Space(X3Tamanho("RB_CARTORI"))
    cSpcNREGCAR:=Space(X3Tamanho("RB_NREGCAR"))
    cSpcNUMLIVR:=Space(X3Tamanho("RB_NUMLIVR"))
    cSpcNUMFOLH:=Space(X3Tamanho("RB_NUMFOLH"))
    cSpcDTENTRA:=Space(X3Tamanho("RB_DTENTRA"))
    cSpcDTBAIXA:=Space(X3Tamanho("RB_DTBAIXA"))
 
    nDepenSF:=Len(&("aDepenSF"))
    if (nDepenSF<10)
        nDepenSF:=(10-nDepenSF)
        for nX:=1 to nDepenSF
            aAdd(&("aDepenSF"),{cSpcNOME,cSpcDTNASC,cSpcGRAUPAR,cSpcLOCNASC,cSpcCARTORI,cSpcNREGCAR,cSpcNUMLIVR,cSpcNUMFOLH,cSpcDTENTRA,cSpcDTBAIXA})
        next nX
    endif
    
    return(&("aDepenSF"))
    
/*
    Programa:GpeWriter
    Funcao:fPesqSRF()
    Autor:R.H.
    Data:05/07/2000
    Descricao:Carrega Periodo Aquisitivo SRF
    Sintaxe:Chamada padrao para programas em "RdMake".
    Uso:Generico
    Obs.:
-------------------------------------------------------------------------
            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.
-------------------------------------------------------------------------
Programador        |Data      |Motivo Alteracao
-------------------------------------------------------------------------
                   |DD/MM/YYYY|
-------------------------------------------------------------------------*/
static function fPesqSRF() as array
    
    local aArea         as array
    
    local cAliasSRF     as character
    
    local nRecNoSRF     as numeric
    
    aArea:=getArea()
    
    cAliasSRF:=getNextAlias()
    beginsql alias cAliasSRF
        SELECT SRF.R_E_C_N_O_ SRFRECNO
          FROM %table:SRF% SRF
         WHERE SRF.%notDel% 
           AND SRF.RF_FILIAL=%exp:SRA->RA_FILIAL%
           AND SRF.RF_MAT=%exp:SRA->RA_MAT%
           AND SRF.RF_STATUS='1'
      ORDER BY SRF.RF_FILIAL
              ,SRF.RF_MAT
              ,SRF.RF_DATABAS
    endsql
    
    // Rotina de Busca Periodo Aquisitivo SRF
    aSize(&("aPerSRF"),0)
    While (cAliasSRF)->(!eof())
        nRecNoSRF:=(cAliasSRF)->SRFRECNO
        SRF->(dbGoTo(nRecNoSRF))
        //Data Inicial Periodo de Ferias,Data Final Periodo de Ferias
        aAdd(&("aPerSRF"),{SRF->RF_DATABAS,SRF->RF_DATAFIM})
       (cAliasSRF)->(dbSkip())
    end while
    
    (cAliasSRF)->(dbCloseArea())
    dbSelectArea("SRF")
    
    restArea(aArea)

    return(&("aPerSRF"))
    
/*
    Programa:GpeWriter
    Funcao:fTarProf()
    Autor:R.H.
    Data:05/07/2000
    Descricao:Carrega Informacoes dos lancamentos de tarefas p/ professor
    Sintaxe:Chamada padrao para programas em "RdMake".
    Uso:Generico
    Obs.:
-------------------------------------------------------------------------
            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.
-------------------------------------------------------------------------
Programador        |Data      |Motivo Alteracao
-------------------------------------------------------------------------
                   |DD/MM/YYYY|
-------------------------------------------------------------------------*/
static function  fTarProf(dDtRef)
    local nI:=0
    local nP:=0
    local nCont:=0
    local nQtTar:=2
    local aArea:=GetArea()
    local aCpos:=Array(nQtTar,0)
    local aRet:=Array(nQtTar,0)
    local bTar:={||.T.}
    
    DEFAULT dDtRef:=SRA->RA_ADMISSA
    
        for nI:=1 To nQtTar
            aAdd(aCpos[nI],{"RO_DESTAR",})
            aAdd(aCpos[nI],{"RO_QTDSEM",})
            aAdd(aCpos[nI],{"RO_QUANT",})
            aAdd(aCpos[nI],{"RO_VALOR",})
            aAdd(aCpos[nI],{"RO_VALTOT",})
        next
    
        // Professores mensalistas so considerar tarefas fixas
        if SRA->RA_CATFUNC=="I"
            bTar:={|| SRO->RO_TIPO=="1"}
        endif
    
        dbSelectArea("SRO")
        if SRO->(dbSeek(SRA->(RA_FILIAL+RA_MAT)))
            While SRO->(!eof().and.SRA->(RA_FILIAL+RA_MAT)==SRO->(SRO->RO_FILIAL+SRO->RO_MAT).and.nCont<nQtTar)
                if MesAno(SRO->RO_DATA)==MesAno(dDtRef).and.Eval(bTar) // Filtra data de referencia e tarefas fixas
                    if cPaisLoc=="BRA"
                        if SRO->RO_TPALT=="001".and.SRO->RO_QUANT>0         // Considera apenas salario Inicial e despreza se for h.e./falta
                            nCont++
                            for nP:=1 To Len(aCpos[1])
                                if aCpos[nCont][nP][1]=="RO_DESTAR"
                                    aCpos[nCont][nP][2]:=fDescTarefa(SRO->RO_CODTAR)
                                else
                                    aCpos[nCont][nP][2]:=SRO->(&(aCpos[nCont][nP][1]))
                                endif
                            next
                        endif
                    endif
                endif
                dbSkip()
            end while
        endif
    
        for nI:=1 To nQtTar
            aEval(aCpos[nI],{|x| aAdd(aRet[nI],x[2])})
        next
    
        RestArea(aArea)
    
    return(aRet)
    
/*
    Programa:GpeWriter
    Funcao:fCpos_Word()
    Autor:R.H.
    Data:05/07/2000
    Descricao:Retorna Array com as Variaveis Disponiveis para Impressao
    Sintaxe:Chamada padrao para programas em "RdMake".
    Uso:Generico
    Obs.:aExp[x,1]-Variavel Para utilizacao no Word (Tam Max.30)
                  aExp[x,2]-Conteudo do Campo                (Tam Max.49)
                  aExp[x,3]-Campo para Pesquisa da Picture no X3 ou Picture
                  aExp[x,4]-Descricao da Variaval

-------------------------------------------------------------------------
            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.
-------------------------------------------------------------------------
Programador        |Data      |Motivo Alteracao
-------------------------------------------------------------------------
                   |DD/MM/YYYY|
-------------------------------------------------------------------------*/
static function fCpos_Word()
    
    local aExp:={}
    local aRet:={}
    local cTexto_01:=AllTrim(&("MV_PAR19"))
    local cTexto_02:=AllTrim(&("MV_PAR20"))
    local cTexto_03:=AllTrim(&("MV_PAR21"))
    local cTexto_04:=AllTrim(&("MV_PAR22"))
    local cApoderado:=""
    local cRamoAtiv:=""
    local cEstCiv:="" //Estado Civil para DCN/DMN-PIS
    local cTipCertd:="" //Tipo de Certidao Civil para DCN/DMN-PIS
    local cGrauInstr:="" //Grau de Instrucao conforme DCN/DMN-PIS
    local cTipNIS:=""
    
    local cDESMTSS:=""
    local cDESCCSS:=""
    local cDESINS:=""
    local cDESCAN:=""
    local cDESCIC:=""
    local cDESJOR:=""
    local cDESFON:=""
    
    local cCodMunLP:=""
    local cCodReqFun:=""
    local cCodAtiv:=""
    
    local lSeekDep
    
    if lDepende
        lSeekDep:=IsInCallStack("fWord_Imp")
        if (lSeekDep)
            SRB->(dbSeek(SRA->RA_FILIAL+SRA->RA_MAT,.F.))
        else
            SRB->(dbGoBottom())
            SRB->(dbSkip())
        endif
        if (nDepende==1) //Salario Familia
            fDepSF()
        elseif (nDepende==2) //Imposto de Renda
            fDepIR()
        elseif (nDepende==3) // Todos os Tipos de Dependente (Salario Familia e Imposto de Renda
            fDepIR()
            if (lSeekDep)
                SRB->(dbSeek(SRA->RA_FILIAL+SRA->RA_MAT,.F.))
            endif
            fDepSF()
        endif
    endif
    
    if cPaisLoc=="BRA"
        cTipNIS:=&("MV_PAR30")  //Pergunte exclusivo do Brasil // Tipo PIS-DCN/DMN
    endif

    if cPaisLoc=="ARG"
        if fPHist82(xFilial(),"99","01")
            cApoderado:=SubStr(SRX->RX_TXT,1,30)
        endif
        if fPHist82(xFilial(),"99","02")
            cRamoAtiv:=SubStr(SRX->RX_TXT,1,50)
        endif
    endif

    aAdd(aExp,{'GPE_FILIAL',SRA->RA_FILIAL,"SRA->RA_FILIAL",STR0013})
    aAdd(aExp,{'GPE_MATRICULA',SRA->RA_MAT,"SRA->RA_MAT",STR0014})
    aAdd(aExp,{'GPE_CENTRO_CUSTO',SRA->RA_CC,"SRA->RA_CC",STR0015})
    aAdd(aExp,{'GPE_DESC_CCUSTO',fDesc("CTT",SRA->RA_CC,"CTT_DESC01"),"@!",STR0016})
    aAdd(aExp,{'GPE_NOME',SRA->RA_NOME,"SRA->RA_NOME",STR0017})
    aAdd(aExp,{'GPE_NOMECMP',SRA->RA_NOMECMP,"@!",STR0017})
    aAdd(aExp,{'GPE_CPF',SRA->RA_CIC,"SRA->RA_CIC",STR0018})
    aAdd(aExp,{'GPE_PIS',SRA->RA_PIS,"SRA->RA_PIS",STR0019})
    aAdd(aExp,{'GPE_RG',SRA->RA_RG,"SRA->RA_RG",STR0020})
    aAdd(aExp,{'GPE_RG_ORG',SRA->RA_RGORG,"@!",STR0152})
    aAdd(aExp,{'GPE_RG_ORGUF',SRA->RA_RGUF,"@!",STR0241})
    aAdd(aExp,{'GPE_CTPS',SRA->RA_NUMCP,"SRA->RA_NUMCP",STR0021})
    aAdd(aExp,{'GPE_SERIE_CTPS',SRA->RA_SERCP,"SRA->RA_SERCP",STR0022})
    aAdd(aExp,{'GPE_UF_CTPS',SRA->RA_UFCP,"SRA->RA_UFCP",STR0023})
    aAdd(aExp,{'GPE_CNH',SRA->RA_HABILIT,"SRA->RA_HABILIT",STR0024})
    aAdd(aExp,{'GPE_RESERVISTA',SRA->RA_RESERVI,"SRA->RA_RESERVI",STR0025})
    aAdd(aExp,{'GPE_TIT_ELEITOR',SRA->RA_TITULOE,"SRA->RA_TITULOE",STR0026})
    aAdd(aExp,{'GPE_ZONA_SECAO',SRA->RA_ZONASEC,"SRA->RA_ZONASEC",STR0027})
    aAdd(aExp,{'GPE_endERECO',SRA->RA_endEREC,"SRA->RA_endEREC",STR0028})
    aAdd(aExp,{'GPE_COMP_endER',SRA->RA_COMPLEM,"SRA->RA_COMPLEM",STR0029})

    if cPaisLoc=="PER"
        aAdd(aExp,{'GPE_BAIRRO',RetContUbigeo("SRA->RA_CEP","RA_BAIRRO"),"@!",STR0030})
        aAdd(aExp,{'GPE_MUNICIPIO',RetContUbigeo("SRA->RA_CEP","RA_MUNICIP"),"@!",STR0031})
        aAdd(aExp,{'GPE_DESC_ESTADO',RetContUbigeo("SRA->RA_CEP","RA_DEPARTA"),"@!",STR0033})
    else
        aAdd(aExp,{'GPE_BAIRRO',SRA->RA_BAIRRO,"SRA->RA_BAIRRO",STR0030})
        aAdd(aExp,{'GPE_MUNICIPIO',SRA->RA_MUNICIP,"SRA->RA_MUNICIP",STR0031})
    endif

    if cPaisLoc<>"PER"
        aAdd(aExp,{'GPE_ESTADO',SRA->RA_ESTADO,"SRA->RA_ESTADO",STR0032})
        aAdd(aExp,{'GPE_DESC_ESTADO',fDesc("SX5","12"+SRA->RA_ESTADO,"X5_DESCRI"),"@!",STR0033})
    endif

    aAdd(aExp,{'GPE_CEP',SRA->RA_CEP,"SRA->RA_CEP",STR0034})
    aAdd(aExp,{'GPE_TELEFONE',SRA->RA_TELEFON,"SRA->RA_TELEFON",STR0035})
    aAdd(aExp,{'GPE_NOME_PAI',SRA->RA_PAI,"SRA->RA_PAI",STR0036})
    aAdd(aExp,{'GPE_NOME_MAE',SRA->RA_MAE,"SRA->RA_MAE",STR0037})
    aAdd(aExp,{'GPE_COD_SEXO',SRA->RA_SEXO,"SRA->RA_SEXO",STR0038})
  //    aAdd(aExp,{'GPE_DESC_SEXO',SRA->(if(RA_SEXO="M","Masculino","Feminino")),"@!",STR0039})

    if cPaisLoc<>"ARG"
        aAdd(aExp,{'GPE_EST_CIVIL',SRA->RA_ESTCIVI,"SRA->RA_ESTCIVI",STR0040})
    else
        aAdd(aExp,{'GPE_EST_CIVIL',fDesc("SX5","33"+SRA->RA_ESTCIVI,"X5DESCRI()"),"SRA->RA_ESTCIVI",STR0040})
    endif

    aAdd(aExp,{'GPE_COD_NATURALIDADE',if(SRA->RA_NATURAL # " ",SRA->RA_NATURAL," "),"SRA->RA_NATURAL",STR0041})
    aAdd(aExp,{'GPE_DESC_NATURALIDADE',fDesc("SX5","12"+SRA->RA_NATURAL,"X5_DESCRI"),"@!",STR0042})
    aAdd(aExp,{'GPE_COD_NACIONALIDADE',SRA->RA_NACIONA,"SRA->RA_NACIONA",STR0043})
    aAdd(aExp,{'GPE_DESC_NACIONALIDADE',fDesc("SX5","34"+SRA->RA_NACIONA,"X5_DESCRI"),"@!",STR0044})

    if cPaisLoc<>"EQU"
        aAdd(aExp,{'GPE_ANO_CHEGADA',SRA->RA_ANOCHEG,"SRA->RA_ANOCHEG",STR0045})
    endif

    aAdd(aExp,{'GPE_DEP_IR',SRA->RA_DEPIR,"SRA->RA_DEPIR",STR0046})

    if lDepSf
        aAdd(aExp,{'GPE_DEP_SAL_FAM',SRA->RA_DEPSF,"SRA->RA_DEPSF",STR0047})
    endif

    aAdd(aExp,{'GPE_DATA_NASC',SRA->RA_NASC,"SRA->RA_NASC",STR0048})
    aAdd(aExp,{'GPE_DATA_ADMISSAO',SRA->RA_ADMISSA,"SRA->RA_ADMISSA",STR0049})
    aAdd(aExp,{'GPE_DIA_ADMISSAO',StrZero(Day(SRA->RA_ADMISSA),2),"@!",STR0050})
    aAdd(aExp,{'GPE_MES_ADMISSAO',StrZero(Month(SRA->RA_ADMISSA),2),"@!",STR0051})
    aAdd(aExp,{'GPE_ANO_ADMISSAO',StrZero(Year(SRA->RA_ADMISSA),4),"@!",STR0052})
    aAdd(aExp,{'GPE_DT_OP_FGTS',SRA->RA_OPCAO,"SRA->RA_OPCAO",STR0053})
    aAdd(aExp,{'GPE_DATA_DEMISSAO',SRA->RA_DEMISSA,"SRA->RA_DEMISSA",STR0054})

    if cPaisLoc<>"EQU"
        aAdd(aExp,{'GPE_DATA_EXPERIENCIA',SRA->RA_VCTOEXP,"SRA->RA_VCTOEXP",STR0055})
        aAdd(aExp,{'GPE_DIA_EXPERIENCIA',StrZero(Day(SRA->RA_VCTOEXP),2),"@!",STR0056})
        aAdd(aExp,{'GPE_MES_EXPERIENCIA',StrZero(Month(SRA->RA_VCTOEXP),2),"@!",STR0057})
        aAdd(aExp,{'GPE_ANO_EXPERIENCIA',StrZero(Year(SRA->RA_VCTOEXP),4),"@!",STR0058})
        aAdd(aExp,{'GPE_DIAS_EXPERIENCIA',StrZero(SRA->(RA_VCTOEXP-RA_ADMISSA)+1,03),"@!",STR0059})
        aAdd(aExp,{'GPE_DATA_EXPERIENCIA2',SRA->RA_VCTEXP2,"SRA->RA_VCTEXP2",STR0245})
        aAdd(aExp,{'GPE_DIA_EXPERIENCIA2',StrZero(Day(SRA->RA_VCTEXP2),2),"@!",STR0246})
        aAdd(aExp,{'GPE_MES_EXPERIENCIA2',StrZero(Month(SRA->RA_VCTEXP2),2),"@!",STR0247})
        aAdd(aExp,{'GPE_ANO_EXPERIENCIA2',StrZero(Year(SRA->RA_VCTEXP2),4),"@!",STR0248})
        aAdd(aExp,{'GPE_DIAS_EXPERIENCIA2',StrZero(SRA->(RA_VCTEXP2-RA_ADMISSA)+1,03),"@!",STR0249})
        aAdd(aExp,{'GPE_DATA_EX_MEDIC',SRA->RA_EXAMEDI,"SRA->RA_EXAMEDI",STR0060})
    endif

    aAdd(aExp,{'GPE_BCO_AG_DEP_SAL',SRA->RA_BCDEPSA,"SRA->RA_BCDEPSA",STR0061})
    aAdd(aExp,{'GPE_DESC_BCO_SAL',fDesc("SA6",SRA->RA_BCDEPSA,"A6_NOME"),"@!",STR0062})
    aAdd(aExp,{'GPE_DESC_AGE_SAL',fDesc("SA6",SRA->RA_BCDEPSA,"A6_NOMEAGE"),"@!",STR0063})
    aAdd(aExp,{'GPE_CTA_DEP_SAL',SRA->RA_CTDEPSA,"SRA->RA_CTDEPSA",STR0064})
    aAdd(aExp,{'GPE_BCO_AG_FGTS',SRA->RA_BCDPFGT,"SRA->RA_BCDPFGT",STR0065})
    aAdd(aExp,{'GPE_DESC_BCO_FGTS',fDesc("SA6",SRA->RA_BCDPFGT,"A6_NOME"),"@!",STR0066})
    aAdd(aExp,{'GPE_DESC_AGE_FGTS',fDesc("SA6",SRA->RA_BCDPFGT,"A6_NOMEAGE"),"@!",STR0067})
    aAdd(aExp,{'GPE_CTA_Dep_FGTS',SRA->RA_CTDPFGT,"SRA->RA_CTDPFGT",STR0068})
    aAdd(aExp,{'GPE_SIT_FOLHA',SRA->RA_SITFOLH,"SRA->RA_SITFOLH",STR0069})
    aAdd(aExp,{'GPE_DESC_SIT_FOLHA',fDesc("SX5","30"+SRA->RA_SITFOLH,"X5_DESCRI"),"@!",STR0070})
    aAdd(aExp,{'GPE_HRS_MENSAIS',SRA->RA_HRSMES,"SRA->RA_HRSMES",STR0071})
    aAdd(aExp,{'GPE_HRS_SEMANAIS',SRA->RA_HRSEMAN,"SRA->RA_HRSEMAN",STR0072})
    aAdd(aExp,{'GPE_CHAPA',SRA->RA_CHAPA,"SRA->RA_CHAPA",STR0073})
    aAdd(aExp,{'GPE_TURNO_TRAB',SRA->RA_TNOTRAB,"SRA->RA_TNOTRAB",STR0074})
    aAdd(aExp,{'GPE_DESC_TURNO',fDesc('SR6',SRA->RA_TNOTRAB,'R6_DESC',,SRA->RA_FILIAL),"@!",STR0075})
    aAdd(aExp,{'GPE_COD_FUNCAO',SRA->RA_CODFUNC,"SRA->RA_CODFUNC",STR0076})
    aAdd(aExp,{'GPE_DESC_FUNCAO',fDesc('SRJ',SRA->RA_CODfUNC,'RJ_DESC',,SRA->RA_FILIAL),"@!",STR0077})
    aAdd(aExp,{'GPE_CBO',fCodCBO(SRA->RA_FILIAL,SRA->RA_CODFUNC,dDataBase),"@!",STR0078})
    aAdd(aExp,{'GPE_CONT_SINDIC',SRA->RA_PGCTSIN,"SRA->RA_PGCTSIN",STR0079})
    aAdd(aExp,{'GPE_COD_SINDICATO',SRA->RA_SINDICA,"SRA->RA_SINDICA",STR0080})
    aAdd(aExp,{'GPE_DESC_SINDICATPO',AllTrim(fDesc("RCE",SRA->RA_SINDICA,"RCE_DESCRI",40)),"@!",STR0081})
    aAdd(aExp,{'GPE_COD_ASS_MEDICA',SRA->RA_ASMEDIC,"SRA->RA_ASMEDIC",STR0082})
    aAdd(aExp,{'GPE_DEP_ASS_MEDICA',SRA->RA_DPASSME,"SRA->RA_DPASSME",STR0083})
    aAdd(aExp,{'GPE_ADIC_TEMP_SERVIC',SRA->RA_ADTPOSE,"SRA->RA_ADTPOSE",STR0084})
    aAdd(aExp,{'GPE_COD_CESTA_BASICA',SRA->RA_CESTAB,"SRA->RA_CESTAB",STR0085})
    aAdd(aExp,{'GPE_COD_VALE_REF',SRA->RA_VALEREF,"SRA->RA_VALEREF",STR0086})

    if cPaisLoc $ ("ANG/ARG/BOL/BRA/CHI/COL/EQU/MEX/PER")
        aAdd(aExp,{'GPE_COD_SEG_VIDA',SRA->RA_SEGUROV,"SRA->RA_SEGUROV",STR0087})
    endif

    aAdd(aExp,{'GPE_%ADIANTAM',SRA->RA_PERCADT,"SRA->RA_PERCADT",STR0089})
    aAdd(aExp,{'GPE_CATEG_FUNC',SRA->RA_CATFUNC,"SRA->RA_CATFUNC",STR0090})
    aAdd(aExp,{'GPE_DESC_CATEG_FUNC',fDesc("SX5","28"+SRA->RA_CATFUNC,"X5_DESCRI"),"@!",STR0091})
    aAdd(aExp,{'GPE_POR_MES_HORA',SRA->(if(RA_CATFUNC$"H","P/Hora",if(RA_CATFUNC$"J","P/Aula","P/Mes"))),"@!",STR0092})
    aAdd(aExp,{'GPE_TIPO_PAGTO',SRA->RA_TIPOPGT,"SRA->RA_TIPOPGT",STR0093})
    aAdd(aExp,{'GPE_DESC_TIPO_PAGTO',fDesc("SX5","40"+SRA->RA_TIPOPGT,"X5_DESCRI"),"@!",STR0094})
    aAdd(aExp,{'GPE_SALARIO',SRA->RA_SALARIO,"SRA->RA_SALARIO",STR0095})

    if cPaisLoc<>"EQU"
        aAdd(aExp,{'GPE_SAL_BAS_DISS',SRA->RA_ANTEAUM,"SRA->RA_ANTEAUM",STR0096})
    endif

    aAdd(aExp,{'GPE_HRS_PERICULO',SRA->RA_PERICUL,"SRA->RA_PERICUL",STR0099})
    aAdd(aExp,{'GPE_HRS_INS_MINIMA',SRA->RA_INSMIN,"SRA->RA_INSMIN",STR0100})
    aAdd(aExp,{'GPE_HRS_INS_MEDIA',SRA->RA_INSMED,"@!",STR0101})
    aAdd(aExp,{'GPE_HRS_INS_MAXIMA',SRA->RA_INSMAX,"SRA->RA_INSMAX",STR0102})
    aAdd(aExp,{'GPE_TIPO_ADMISSAO',SRA->RA_TIPOADM,"SRA->RA_TIPOADM",STR0103})
    aAdd(aExp,{'GPE_DESC_TP_ADMISSAO',fDesc("SX5","38"+SRA->RA_TIPOADM,"X5_DESCRI"),"@!",STR0104})
    aAdd(aExp,{'GPE_COD_AFA_FGTS',SRA->RA_AFASFGT,"SRA->RA_AFASFGT",STR0105})
    aAdd(aExp,{'GPE_DESC_AFA_FGTS',fDesc("SX5","30"+SRA->RA_AFASFGT,"X5_DESCRI"),"@!",STR0106})

    if cPaisLoc<>"PER"
        aAdd(aExp,{'GPE_VIN_EMP_RAIS',SRA->RA_VIEMRAI,"SRA->RA_VIEMRAI",STR0107})
        aAdd(aExp,{'GPE_DESC_VIN_EMP_RAIS',fDesc("SX5","25"+SRA->RA_VIEMRAI,"X5_DESCRI"),"@!",STR0108})
    endif

    aAdd(aExp,{'GPE_COD_INST_RAIS',SRA->RA_GRINRAI,"SRA->RA_GRINRAI",STR0109})
    aAdd(aExp,{'GPE_DESC_GRAU_INST',fDesc("SX5","26"+SRA->RA_GRINRAI,"X5_DESCRI"),"@!",STR0110})
    aAdd(aExp,{'GPE_COD_RESC_RAIS',SRA->RA_RESCRAI,"SRA->RA_RESCRAI",STR0111})
    aAdd(aExp,{'GPE_CRACHA',SRA->RA_CRACHA,"SRA->RA_CRACHA",STR0112})
    aAdd(aExp,{'GPE_REGRA_APONTA',SRA->RA_REGRA,"SRA->RA_REGRA",STR0113})
    aAdd(aExp,{'GPE_NO_REGISTRO',SRA->RA_REGISTR,"SRA->RA_REGISTR",STR0115})
    aAdd(aExp,{'GPE_NO_FICHA',SRA->RA_FICHA,"SRA->RA_FICHA",STR0116})
    aAdd(aExp,{'GPE_TP_CONT_TRAB',SRA->RA_TPCONTR,"SRA->RA_TPCONTR",STR0117})
    aAdd(aExp,{'GPE_DESC_TP_CONT_TRAB',SRA->(if(RA_TPCONTR="1","Indeterminado","Determinado")),"@!",STR0118})
    aAdd(aExp,{'GPE_APELIDO',SRA->RA_APELIDO,"SRA->RA_APELIDO",STR0119})
    aAdd(aExp,{'GPE_E-MAIL',SRA->RA_EMAIL,"SRA->RA_EMAIL",STR0120})
    aAdd(aExp,{'GPE_TEXTO_01',cTexto_01,"@!",STR0121})
    aAdd(aExp,{'GPE_TEXTO_02',cTexto_02,"@!",STR0122})
    aAdd(aExp,{'GPE_TEXTO_03',cTexto_03,"@!",STR0123})
    aAdd(aExp,{'GPE_TEXTO_04',cTexto_04,"@!",STR0124})
    aAdd(aExp,{'GPE_EXTENSO_SAL',Extenso(SRA->RA_SALARIO,.F.,1),"@!",STR0125})
    aAdd(aExp,{'GPE_DDATABASE',dDataBase,"",STR0126})
    aAdd(aExp,{'GPE_DIA_DDATABASE',StrZero(Day(dDataBase),2),"@!",STR0127})
    aAdd(aExp,{'GPE_MES_DDATABASE',MesExtenso(dDataBase),"@!",STR0128})
    aAdd(aExp,{'GPE_ANO_DDATABASE',StrZero(Year(dDataBase),4),"@!",STR0129})
    aAdd(aExp,{'GPE_NOME_EMPRESA',aInfo[03],"@!",STR0130})
    aAdd(aExp,{'GPE_end_EMPRESA',aInfo[04],"@!",STR0131})
    aAdd(aExp,{'GPE_CID_EMPRESA',aInfo[05],"@!",STR0132})
    aAdd(aExp,{'GPE_CEP_EMPRESA',aInfo[07],"!@R #####-###",STR0034})
    aAdd(aExp,{'GPE_EST_EMPRESA',aInfo[06],"@!",STR0032})
    aAdd(aExp,{'GPE_CGC_EMPRESA',aInfo[08],"@R ##.###.###/####-##",STR0134})
    aAdd(aExp,{'GPE_INSC_EMPRESA',aInfo[09],"@!",STR0135})
    aAdd(aExp,{'GPE_TEL_EMPRESA',aInfo[10],"@!",STR0136})
    aAdd(aExp,{'GPE_FAX_EMPRESA',if(aInfo[11]#nil,aInfo[11],"        "),"@!",STR0136})
    aAdd(aExp,{'GPE_BAI_EMPRESA',aInfo[13],"@!",STR0137})
    aAdd(aExp,{'GPE_DESC_RESC_RAIS',fDesc("SX5","31"+SRA->RA_RESCRAI,"X5_DESCRI"),"@!",STR0138})
    aAdd(aExp,{'GPE_DIA_DEMISSAO',StrZero(Day(SRA->RA_DEMISSA),2),"@!",STR0139})
    aAdd(aExp,{'GPE_MES_DEMISSAO',StrZero(Month(SRA->RA_DEMISSA),2),"@!",STR0140})
    aAdd(aExp,{'GPE_ANO_DEMISSAO',StrZero(Year(SRA->RA_DEMISSA),4),"@!",STR0141})

    if cPaisLoc=="BRA"
        aAdd(aExp,{'GPE_MES_ADEXT',MesExtenso(Month(SRA->RA_ADMISSA)),"@!",STR0155})
        aAdd(aExp,{'GPE_RG_EMISSAO',SRA->RA_DTRGEXP,"SRA->RA_DTRGEXP",STR0242})
        aAdd(aExp,{'GPE_CTPS_EMISSAO',SRA->RA_DTCPEXP,"SRA->RA_DTCPEXP",STR0243})
        aAdd(aExp,{'GPE_FECREI',SRA->RA_FECREI,"SRA->RA_FECREI",STR0178})
        aAdd(aExp,{'GPE_HRDIA',SRA->RA_HRSDIA,"SRA->RA_HRSDIA",STR0218})
    endif

    aAdd(aExp,{'GPE_FUNC_COR',if(SRA->RA_RACACOR=="1","Ind?ena",(if(SRA->RA_RACACOR=="2","Branca",(if(SRA->RA_RACACOR=="4","Negra",(if(SRA->RA_RACACOR=="6","Amarela",(if(SRA->RA_RACACOR=="8","Parda","N? informado"))))))))),"@!",STR0244})

    //Periodo Aquisitivo de Ferias
   aAdd(aExp,{'GPE_DIA_INIFERIAS',if(Len(&("aPerSRF"))>0,Day2Str(Day(aPerSRF[1,1])),Space(02)),"@!",STR0188})
   aAdd(aExp,{'GPE_MES_INIFERIAS',if(Len(&("aPerSRF"))>0,MesExtenso(aPerSRF[1,1]),Space(12)),"@!",STR0189})
   aAdd(aExp,{'GPE_ANO_INIFERIAS',if(Len(&("aPerSRF"))>0,Year2Str(Year(aPerSRF[1,1])),Space(04)),"@!",STR0190})
   aAdd(aExp,{'GPE_DIA_FIMFERIAS',if(Len(&("aPerSRF"))>0,Day2Str(Day(aPerSRF[1,2])),Space(02)),"@!",STR0191})
   aAdd(aExp,{'GPE_MES_FIMFERIAS',if(Len(&("aPerSRF"))>0,MesExtenso(aPerSRF[1,2]),Space(12)),"@!",STR0192})
   aAdd(aExp,{'GPE_ANO_FIMFERIAS',if(Len(&("aPerSRF"))>0,Year2Str(Year(aPerSRF[1,2])),Space(04)),"@!",STR0193})

    // Salario Familia
    aAdd(aExp,{'GPE_CFILHO01',if(nDepen==1.or.nDepen==3,aDepenSF[1,1],Space(70)),"@!",STR0150})
    aAdd(aExp,{'GPE_DTFL01',if(nDepen==1.or.nDepen==3,aDepenSF[1,2],Space(08)),"",STR0151})
    aAdd(aExp,{'GPE_CFILHO02',if(nDepen==1.or.nDepen==3,aDepenSF[2,1],Space(70)),"@!",STR0150})
    aAdd(aExp,{'GPE_DTFL02',if(nDepen==1.or.nDepen==3,aDepenSF[2,2],Space(08)),"",STR0151})
    aAdd(aExp,{'GPE_CFILHO03',if(nDepen==1.or.nDepen==3,aDepenSF[3,1],Space(70)),"@!",STR0150})
    aAdd(aExp,{'GPE_DTFL03',if(nDepen==1.or.nDepen==3,aDepenSF[3,2],Space(08)),"",STR0151})
    aAdd(aExp,{'GPE_CFILHO04',if(nDepen==1.or.nDepen==3,aDepenSF[4,1],Space(70)),"@!",STR0150})
    aAdd(aExp,{'GPE_DTFL04',if(nDepen==1.or.nDepen==3,aDepenSF[4,2],Space(08)),"",STR0151})
    aAdd(aExp,{'GPE_CFILHO05',if(nDepen==1.or.nDepen==3,aDepenSF[5,1],Space(70)),"@!",STR0150})
    aAdd(aExp,{'GPE_DTFL05',if(nDepen==1.or.nDepen==3,aDepenSF[5,2],Space(08)),"",STR0151})
    aAdd(aExp,{'GPE_CFILHO06',if(nDepen==1.or.nDepen==3,aDepenSF[6,1],Space(70)),"@!",STR0150})
    aAdd(aExp,{'GPE_DTFL06',if(nDepen==1.or.nDepen==3,aDepenSF[6,2],Space(08)),"",STR0151})
    aAdd(aExp,{'GPE_CFILHO07',if(nDepen==1.or.nDepen==3,aDepenSF[7,1],Space(70)),"@!",STR0150})
    aAdd(aExp,{'GPE_DTFL07',if(nDepen==1.or.nDepen==3,aDepenSF[7,2],Space(08)),"",STR0151})
    aAdd(aExp,{'GPE_CFILHO08',if(nDepen==1.or.nDepen==3,aDepenSF[8,1],Space(70)),"@!",STR0150})
    aAdd(aExp,{'GPE_DTFL08',if(nDepen==1.or.nDepen==3,aDepenSF[8,2],Space(08)),"",STR0151})
    aAdd(aExp,{'GPE_CFILHO09',if(nDepen==1.or.nDepen==3,aDepenSF[9,1],Space(70)),"@!",STR0150})
    aAdd(aExp,{'GPE_DTFL09',if(nDepen==1.or.nDepen==3,aDepenSF[9,2],Space(08)),"",STR0151})
    aAdd(aExp,{'GPE_CFILHO10',if(nDepen==1.or.nDepen==3,aDepenSF[10,1],Space(70)),"@!",STR0150})
    aAdd(aExp,{'GPE_DESC_ESTEMP',Alltrim(fDesc("SX5","12"+aInfo[06],"X5_DESCRI")),"@!",STR0134})
    aAdd(aExp,{'GPE_cGrau01',if(nDepen==1.or.nDepen==3,aDepenSF[1,3],Space(10)),"@!",STR0153})
    aAdd(aExp,{'GPE_cGrau02',if(nDepen==1.or.nDepen==3,aDepenSF[2,3],Space(10)),"@!",STR0153})
    aAdd(aExp,{'GPE_cGrau03',if(nDepen==1.or.nDepen==3,aDepenSF[3,3],Space(10)),"@!",STR0153})
    aAdd(aExp,{'GPE_cGrau04',if(nDepen==1.or.nDepen==3,aDepenSF[4,3],Space(10)),"@!",STR0153})
    aAdd(aExp,{'GPE_cGrau05',if(nDepen==1.or.nDepen==3,aDepenSF[5,3],Space(10)),"@!",STR0153})
    aAdd(aExp,{'GPE_cGrau06',if(nDepen==1.or.nDepen==3,aDepenSF[6,3],Space(10)),"@!",STR0153})
    aAdd(aExp,{'GPE_cGrau07',if(nDepen==1.or.nDepen==3,aDepenSF[7,3],Space(10)),"@!",STR0153})
    aAdd(aExp,{'GPE_cGrau08',if(nDepen==1.or.nDepen==3,aDepenSF[8,3],Space(10)),"@!",STR0153})
    aAdd(aExp,{'GPE_cGrau09',if(nDepen==1.or.nDepen==3,aDepenSF[9,3],Space(10)),"@!",STR0153})
    aAdd(aExp,{'GPE_cGrau10',if(nDepen==1.or.nDepen==3,aDepenSF[10,3],Space(10)),"@!",STR0153})
    aAdd(aExp,{'GPE_local01',if(nDepen==1.or.nDepen==3,aDepenSF[1,4],Space(10)),"@!",STR0164})
    aAdd(aExp,{'GPE_CARTORIO01',if(nDepen==1.or.nDepen==3,aDepenSF[1,5],Space(10)),"@!",STR0156})
    aAdd(aExp,{'GPE_NREGISTRO01',if(nDepen==1.or.nDepen==3,aDepenSF[1,6],Space(10)),"@!",STR0165})
    aAdd(aExp,{'GPE_NLIVRO01',if(nDepen==1.or.nDepen==3,aDepenSF[1,7],Space(10)),"@!",STR0158})
    aAdd(aExp,{'GPE_NFOLHA01',if(nDepen==1.or.nDepen==3,aDepenSF[1,8],Space(10)),"@!",STR0159})
    aAdd(aExp,{'GPE_DT_ENTREGA01',if(nDepen==1.or.nDepen==3,aDepenSF[1,9],Space(10)),"@!",STR0160})
    aAdd(aExp,{'GPE_DT_BAIXA01',if(nDepen==1.or.nDepen==3,aDepenSF[1,10],Space(10)),"@!",STR0161})
    aAdd(aExp,{'GPE_local02',if(nDepen==1.or.nDepen==3,aDepenSF[2,4],Space(10)),"@!",STR0164})
    aAdd(aExp,{'GPE_CARTORIO02',if(nDepen==1.or.nDepen==3,aDepenSF[2,5],Space(10)),"@!",STR0156})
    aAdd(aExp,{'GPE_NREGISTRO02',if(nDepen==1.or.nDepen==3,aDepenSF[2,6],Space(10)),"@!",STR0165})
    aAdd(aExp,{'GPE_NLIVRO02',if(nDepen==1.or.nDepen==3,aDepenSF[2,7],Space(10)),"@!",STR0158})
    aAdd(aExp,{'GPE_NFOLHA02',if(nDepen==1.or.nDepen==3,aDepenSF[2,8],Space(10)),"@!",STR0159})
    aAdd(aExp,{'GPE_DT_ENTREGA02',if(nDepen==1.or.nDepen==3,aDepenSF[2,9],Space(10)),"@!",STR0160})
    aAdd(aExp,{'GPE_DT_BAIXA02',if(nDepen==1.or.nDepen==3,aDepenSF[2,10],Space(10)),"@!",STR0161})
    aAdd(aExp,{'GPE_local03',if(nDepen==1.or.nDepen==3,aDepenSF[3,4],Space(10)),"@!",STR0164})
    aAdd(aExp,{'GPE_CARTORIO03',if(nDepen==1.or.nDepen==3,aDepenSF[3,5],Space(10)),"@!",STR0156})
    aAdd(aExp,{'GPE_NREGISTRO03',if(nDepen==1.or.nDepen==3,aDepenSF[3,6],Space(10)),"@!",STR0165})
    aAdd(aExp,{'GPE_NLIVRO03',if(nDepen==1.or.nDepen==3,aDepenSF[3,7],Space(10)),"@!",STR0158})
    aAdd(aExp,{'GPE_NFOLHA03',if(nDepen==1.or.nDepen==3,aDepenSF[3,8],Space(10)),"@!",STR0159})
    aAdd(aExp,{'GPE_DT_ENTREGA03',if(nDepen==1.or.nDepen==3,aDepenSF[3,9],Space(10)),"@!",STR0160})
    aAdd(aExp,{'GPE_DT_BAIXA03',if(nDepen==1.or.nDepen==3,aDepenSF[3,10],Space(10)),"@!",STR0161})
    aAdd(aExp,{'GPE_local04',if(nDepen==1.or.nDepen==3,aDepenSF[4,4],Space(10)),"@!",STR0164})
    aAdd(aExp,{'GPE_CARTORIO04',if(nDepen==1.or.nDepen==3,aDepenSF[4,5],Space(10)),"@!",STR0156})
    aAdd(aExp,{'GPE_NREGISTRO04',if(nDepen==1.or.nDepen==3,aDepenSF[4,06],Space(10)),"@!",STR0165})
    aAdd(aExp,{'GPE_NLIVRO04',if(nDepen==1.or.nDepen==3,aDepenSF[4,7],Space(10)),"@!",STR0158})
    aAdd(aExp,{'GPE_NFOLHA04',if(nDepen==1.or.nDepen==3,aDepenSF[4,8],Space(10)),"@!",STR0159})
    aAdd(aExp,{'GPE_DT_ENTREGA04',if(nDepen==1.or.nDepen==3,aDepenSF[4,9],Space(10)),"@!",STR0160})
    aAdd(aExp,{'GPE_DT_BAIXA04',if(nDepen==1.or.nDepen==3,aDepenSF[4,10],Space(10)),"@!",STR0161})
    aAdd(aExp,{'GPE_local05',if(nDepen==1.or.nDepen==3,aDepenSF[5,4],Space(10)),"@!",STR0164})
    aAdd(aExp,{'GPE_CARTORIO05',if(nDepen==1.or.nDepen==3,aDepenSF[5,5],Space(10)),"@!",STR0156})
    aAdd(aExp,{'GPE_NREGISTRO05',if(nDepen==1.or.nDepen==3,aDepenSF[5,6],Space(10)),"@!",STR0165})
    aAdd(aExp,{'GPE_NLIVRO05',if(nDepen==1.or.nDepen==3,aDepenSF[5,7],Space(10)),"@!",STR0158})
    aAdd(aExp,{'GPE_NFOLHA05',if(nDepen==1.or.nDepen==3,aDepenSF[5,8],Space(10)),"@!",STR0159})
    aAdd(aExp,{'GPE_DT_ENTREGA05',if(nDepen==1.or.nDepen==3,aDepenSF[5,9],Space(10)),"@!",STR0160})
    aAdd(aExp,{'GPE_DT_BAIXA05',if(nDepen==1.or.nDepen==3,aDepenSF[5,10],Space(10)),"@!",STR0161})
    aAdd(aExp,{'GPE_local06',if(nDepen==1.or.nDepen==3,aDepenSF[6,4],Space(10)),"@!",STR0164})
    aAdd(aExp,{'GPE_CARTORIO06',if(nDepen==1.or.nDepen==3,aDepenSF[6,5],Space(10)),"@!",STR0156})
    aAdd(aExp,{'GPE_NREGISTRO06',if(nDepen==1.or.nDepen==3,aDepenSF[6,6],Space(10)),"@!",STR0165})
    aAdd(aExp,{'GPE_NLIVRO06',if(nDepen==1.or.nDepen==3,aDepenSF[6,7],Space(10)),"@!",STR0158})
    aAdd(aExp,{'GPE_NFOLHA06',if(nDepen==1.or.nDepen==3,aDepenSF[6,8],Space(10)),"@!",STR0159})
    aAdd(aExp,{'GPE_DT_ENTREGA06',if(nDepen==1.or.nDepen==3,aDepenSF[6,9],Space(10)),"@!",STR0160})
    aAdd(aExp,{'GPE_DT_BAIXA06',if(nDepen==1.or.nDepen==3,aDepenSF[6,10],Space(10)),"@!",STR0161})
    aAdd(aExp,{'GPE_local07',if(nDepen==1.or.nDepen==3,aDepenSF[7,4],Space(10)),"@!",STR0164})
    aAdd(aExp,{'GPE_CARTORIO07',if(nDepen==1.or.nDepen==3,aDepenSF[7,5],Space(10)),"@!",STR0156})
    aAdd(aExp,{'GPE_NREGISTRO07',if(nDepen==1.or.nDepen==3,aDepenSF[7,6],Space(10)),"@!",STR0165})
    aAdd(aExp,{'GPE_NLIVRO07',if(nDepen==1.or.nDepen==3,aDepenSF[7,7],Space(10)),"@!",STR0158})
    aAdd(aExp,{'GPE_NFOLHA07',if(nDepen==1.or.nDepen==3,aDepenSF[7,8],Space(10)),"@!",STR0159})
    aAdd(aExp,{'GPE_DT_ENTREGA07',if(nDepen==1.or.nDepen==3,aDepenSF[7,9],Space(10)),"@!",STR0160})
    aAdd(aExp,{'GPE_DT_BAIXA07',if(nDepen==1.or.nDepen==3,aDepenSF[7,10],Space(10)),"@!",STR0161})
    aAdd(aExp,{'GPE_local08',if(nDepen==1.or.nDepen==3,aDepenSF[8,4],Space(10)),"@!",STR0164})
    aAdd(aExp,{'GPE_CARTORIO08',if(nDepen==1.or.nDepen==3,aDepenSF[8,5],Space(10)),"@!",STR0156})
    aAdd(aExp,{'GPE_NREGISTRO08',if(nDepen==1.or.nDepen==3,aDepenSF[8,6],Space(10)),"@!",STR0165})
    aAdd(aExp,{'GPE_NLIVRO08',if(nDepen==1.or.nDepen==3,aDepenSF[8,7],Space(10)),"@!",STR0158})
    aAdd(aExp,{'GPE_NFOLHA08',if(nDepen==1.or.nDepen==3,aDepenSF[8,8],Space(10)),"@!",STR0159})
    aAdd(aExp,{'GPE_DT_ENTREGA08',if(nDepen==1.or.nDepen==3,aDepenSF[8,9],Space(10)),"@!",STR0160})
    aAdd(aExp,{'GPE_DT_BAIXA08',if(nDepen==1.or.nDepen==3,aDepenSF[8,10],Space(10)),"@!",STR0161})
    aAdd(aExp,{'GPE_local09',if(nDepen==1.or.nDepen==3,aDepenSF[9,4],Space(10)),"@!",STR0164})
    aAdd(aExp,{'GPE_CARTORIO09',if(nDepen==1.or.nDepen==3,aDepenSF[9,5],Space(10)),"@!",STR0156})
    aAdd(aExp,{'GPE_NREGISTRO09',if(nDepen==1.or.nDepen==3,aDepenSF[9,6],Space(10)),"@!",STR0165})
    aAdd(aExp,{'GPE_NLIVRO09',if(nDepen==1.or.nDepen==3,aDepenSF[9,7],Space(10)),"@!",STR0158})
    aAdd(aExp,{'GPE_NFOLHA09',if(nDepen==1.or.nDepen==3,aDepenSF[9,8],Space(10)),"@!",STR0159})
    aAdd(aExp,{'GPE_DT_ENTREGA09',if(nDepen==1.or.nDepen==3,aDepenSF[9,9],Space(10)),"@!",STR0160})
    aAdd(aExp,{'GPE_DT_BAIXA09',if(nDepen==1.or.nDepen==3,aDepenSF[9,10],Space(10)),"@!",STR0161})
    aAdd(aExp,{'GPE_local10',if(nDepen==1.or.nDepen==3,aDepenSF[10,4],Space(10)),"@!",STR0164})
    aAdd(aExp,{'GPE_CARTORIO10',if(nDepen==1.or.nDepen==3,aDepenSF[10,5],Space(10)),"@!",STR0156})
    aAdd(aExp,{'GPE_NREGISTRO10',if(nDepen==1.or.nDepen==3,aDepenSF[10,6],Space(10)),"@!",STR0165})
    aAdd(aExp,{'GPE_NLIVRO10',if(nDepen==1.or.nDepen==3,aDepenSF[10,7],Space(10)),"@!",STR0158})
    aAdd(aExp,{'GPE_NFOLHA10',if(nDepen==1.or.nDepen==3,aDepenSF[10,8],Space(10)),"@!",STR0159})
    aAdd(aExp,{'GPE_DT_ENTREGA10',if(nDepen==1.or.nDepen==3,aDepenSF[10,9],Space(10)),"@!",STR0160})
    aAdd(aExp,{'GPE_DT_BAIXA10',if(nDepen==1.or.nDepen==3,aDepenSF[10,10],Space(10)),"@!",STR0161})
    // Imposto de Renda
    aAdd(aExp,{'GPE_CDEPE01',if(nDepen==2.or.nDepen==3,aDepenIR[1,1],Space(70)),"@!",STR0154 })
    aAdd(aExp,{'GPE_cGrDp01',if(nDepen==2.or.nDepen==3,aDepenIR[1,3],Space(10)),"@!",STR0153})
    aAdd(aExp,{'GPE_DTFLIR01',if(nDepen==2.or.nDepen==3,aDepenIR[1,2],Space(08)),"",STR0163})
    aAdd(aExp,{'GPE_CDEPE02',if(nDepen==2.or.nDepen==3,aDepenIR[2,1],Space(70)),"@!",STR0154})
    aAdd(aExp,{'GPE_cGrDp02',if(nDepen==2.or.nDepen==3,aDepenIR[2,3],Space(10)),"@!",STR0153})
    aAdd(aExp,{'GPE_DTFLIR02',if(nDepen==2.or.nDepen==3,aDepenIR[2,2],Space(08)),"",STR0163})
    aAdd(aExp,{'GPE_CDEPE03',if(nDepen==2.or.nDepen==3,aDepenIR[3,1],Space(70)),"@!",STR0154})
    aAdd(aExp,{'GPE_cGrDp03',if(nDepen==2.or.nDepen==3,aDepenIR[3,3],Space(10)),"@!",STR0153})
    aAdd(aExp,{'GPE_DTFLIR03',if(nDepen==2.or.nDepen==3,aDepenIR[3,2],Space(08)),"",STR0163})
    aAdd(aExp,{'GPE_CDEPE04',if(nDepen==2.or.nDepen==3,aDepenIR[4,1],Space(70)),"@!",STR0154})
    aAdd(aExp,{'GPE_cGrDp04',if(nDepen==2.or.nDepen==3,aDepenIR[4,3],Space(10)),"@!",STR0153})
    aAdd(aExp,{'GPE_DTFLIR04',if(nDepen==2.or.nDepen==3,aDepenIR[4,2],Space(08)),"",STR0163})
    aAdd(aExp,{'GPE_CDEPE05',if(nDepen==2.or.nDepen==3,aDepenIR[5,1],Space(70)),"@!",STR0154})
    aAdd(aExp,{'GPE_cGrDp05',if(nDepen==2.or.nDepen==3,aDepenIR[5,3],Space(10)),"@!",STR0153})
    aAdd(aExp,{'GPE_DTFLIR05',if(nDepen==2.or.nDepen==3,aDepenIR[5,2],Space(08)),"",STR0163})
    aAdd(aExp,{'GPE_CDEPE06',if(nDepen==2.or.nDepen==3,aDepenIR[6,1],Space(70)),"@!",STR0154})
    aAdd(aExp,{'GPE_cGrDp06',if(nDepen==2.or.nDepen==3,aDepenIR[6,3],Space(10)),"@!",STR0153})
    aAdd(aExp,{'GPE_DTFLIR06',if(nDepen==2.or.nDepen==3,aDepenIR[6,2],Space(08)),"",STR0163})
    aAdd(aExp,{'GPE_CDEPE07',if(nDepen==2.or.nDepen==3,aDepenIR[7,1],Space(70)),"@!",STR0154})
    aAdd(aExp,{'GPE_cGrDp07',if(nDepen==2.or.nDepen==3,aDepenIR[7,3],Space(10)),"@!",STR0153})
    aAdd(aExp,{'GPE_DTFLIR07',if(nDepen==2.or.nDepen==3,aDepenIR[7,2],Space(08)),"",STR0163})
    aAdd(aExp,{'GPE_CDEPE08',if(nDepen==2.or.nDepen==3,aDepenIR[8,1],Space(70)),"@!",STR0154})
    aAdd(aExp,{'GPE_cGrDp08',if(nDepen==2.or.nDepen==3,aDepenIR[8,3],Space(10)),"@!",STR0153})
    aAdd(aExp,{'GPE_DTFLIR08',if(nDepen==2.or.nDepen==3,aDepenIR[8,2],Space(08)),"",STR0163})
    aAdd(aExp,{'GPE_CDEPE09',if(nDepen==2.or.nDepen==3,aDepenIR[9,1],Space(70)),"@!",STR0154})
    aAdd(aExp,{'GPE_cGrDp09',if(nDepen==2.or.nDepen==3,aDepenIR[9,3],Space(10)),"@!",STR0153})
    aAdd(aExp,{'GPE_DTFLIR09',if(nDepen==2.or.nDepen==3,aDepenIR[9,2],Space(08)),"",STR0163})
    aAdd(aExp,{'GPE_CDEPE10',if(nDepen==2.or.nDepen==3,aDepenIR[10,1],Space(70)),"@!",STR0154})
    aAdd(aExp,{'GPE_cGrDp10',if(nDepen==2.or.nDepen==3,aDepenIR[10,3],Space(10)),"@!",STR0153})
    aAdd(aExp,{'GPE_DTFLIR10',if(nDepen==2.or.nDepen==3,aDepenIR[10,2],Space(08)),"",STR0163})

    if cPaisLoc=="ARG"
        aAdd(aExp,{'GPE_MES_ADEXT',MesExtenso(Month(SRA->RA_ADMISSA)),"@!",STR0155})
        aAdd(aExp,{'GPE_APODERADO',cApoderado,"@!",STR0156})
        aAdd(aExp,{'GPE_ATIVIDADE',cRamoAtiv,"@!",STR0157})
    endif

    aAdd(aExp,{'GPE_MUNICNASC',if(SRA->(FieldPos("RA_MUNNASC")) # 0,SRA->RA_MUNNASC,space(20)),"@!",STR0166})
    aAdd(aExp,{'GPE_PROCES',SRA->RA_PROCES,"SRA->RA_PROCES",STR0173})    //Codigo do Processo
    aAdd(aExp,{'GPE_DEPTO',SRA->RA_DEPTO,"SRA->RA_DEPTO",STR0181})    //Codigo do Departamento

    if SRA->(FieldPos("RA_POSTO")) # 0
        aAdd(aExp,{'GPE_POSTO',SRA->RA_POSTO,"SRA->RA_POSTO",STR0182})    //Codigo do Posto
    endif

    if cPaisLoc=="MEX"

        cCodMunLP:=POSICIONE("RGC",1,XFILIAL("RGC")+SRA->RA_KEYLOC,"RGC_MUNIC")
        cCodReqFun:=POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_DESCREQ")

        aAdd(aExp,{'GPE_PRINOME',SRA->RA_PRINOME,"SRA->RA_PRINOME",STR0169})     //Primeiro Nome
        aAdd(aExp,{'GPE_SECNOME',SRA->RA_SECNOME,"SRA->RA_SECNOME",STR0170})     //Segundo Nome
        aAdd(aExp,{'GPE_PRISOBR',SRA->RA_PRISOBR,"SRA->RA_PRISOBR",STR0171})     //Primeiro Sobrenome
        aAdd(aExp,{'GPE_SECSOBR',SRA->RA_SECSOBR,"SRA->RA_SECSOBR",STR0172})     //Segundo Sobrenome
        aAdd(aExp,{'GPE_KEYLOC',SRA->RA_KEYLOC,"SRA->RA_KEYLOC",STR0174})     //Codigo local de Pagamento
        aAdd(aExp,{'GPE_TSIMSS',SRA->RA_TSIMSS,"SRA->RA_TSIMSS",STR0175})     //Tipo de Salario IMSS
        aAdd(aExp,{'GPE_TEIMSS',SRA->RA_TEIMSS,"SRA->RA_TEIMSS",STR0176})     //Tipo de Empregado IMSS
        aAdd(aExp,{'GPE_TJRNDA',SRA->RA_TJRNDA,"SRA->RA_TJRNDA",STR0177})     //Tipo de Jornada IMSS
        aAdd(aExp,{'GPE_FECREI',SRA->RA_FECREI,"SRA->RA_FECREI",STR0178})     //Data de Readmissao
        aAdd(aExp,{'GPE_DTBIMSS',SRA->RA_DTBIMSS,"SRA->RA_DTBIMSS",STR0179})     //Data de Baixa IMSS
        aAdd(aExp,{'GPE_CODRPAT',SRA->RA_CODRPAT,"SRA->RA_CODRPAT",STR0180})     //Codigo do Registro Patronal
        aAdd(aExp,{'GPE_CURP',SRA->RA_CURP,"SRA->RA_CURP",STR0183})     //CURP
        aAdd(aExp,{'GPE_TIPINF',SRA->RA_TIPINF,"SRA->RA_TIPINF",STR0184})     //Tipo de Infonavit
        aAdd(aExp,{'GPE_VALINF',SRA->RA_VALINF,"SRA->RA_VALINF",STR0185})     //Valor do Infonavit
        aAdd(aExp,{'GPE_NUMINF',SRA->RA_NUMINF,"SRA->RA_NUMINF",STR0186})     //Nro.de Credito Infonavit
        aAdd(aExp,{'GPE_IDADE',cValToChar(Year(DDATABASE)-Year(SRA->RA_NASC)),"!@",STR0335})     //Idade
        aAdd(aExp,{'GPE_REQFUNC',MSMM(cCodReqFun,80),"!@",STR0334})        //Requisitos da Funcao
        aAdd(aExp,{'GPE_DESCMUNIC',POSICIONE("VAM",1,XFILIAL("VAM")+SRA->RA_MUNICIP,"VAM_DESCID"),"!@",STR0031})     //Descricao do Municipio

        //Campos da localidade de Pagamento
        aAdd(aExp,{'GPE_DESCLP',POSICIONE("RGC",1,XFILIAL("RGC")+SRA->RA_KEYLOC,"RGC_DESLOC"),"RGC->RGC_DESLOC",STR0216})        //Descricao do local de Pagamento
        aAdd(aExp,{'GPE_endERECOLP',POSICIONE("RGC",1,XFILIAL("RGC")+SRA->RA_KEYLOC,"RGC_endER"),"RGC->RGC_endER",STR0328})        //endereco da localidade de Pagamento
        aAdd(aExp,{'GPE_BAIRROLP',POSICIONE("RGC",1,XFILIAL("RGC")+SRA->RA_KEYLOC,"RGC_BAIRRO"),"RGC->RGC_BAIRRO",STR0329})        //Bairro da localidade de Pagamento
        aAdd(aExp,{'GPE_CIDADELP',POSICIONE("RGC",1,XFILIAL("RGC")+SRA->RA_KEYLOC,"RGC_CIDADE"),"RGC->RGC_CIDADE",STR0330})        //Cidade da localidade de Pagamento
        aAdd(aExp,{'GPE_ESTADOLP',POSICIONE("RGC",1,XFILIAL("RGC")+SRA->RA_KEYLOC,"RGC_ESTADO"),"RGC->RGC_ESTADO",STR0331})        //Estado da localidade de Pagamento
        aAdd(aExp,{'GPE_CEPLP',POSICIONE("RGC",1,XFILIAL("RGC")+SRA->RA_KEYLOC,"RGC_CODPOS"),"RGC->RGC_CODPOS",STR0333})        //CEP da localidade de Pagamento
        aAdd(aExp,{'GPE_DESCMUNICLP',POSICIONE("VAM",1,XFILIAL("VAM")+cCodMunLP,"VAM_DESCID"),"!@",STR0332})        //Municipio da localidade de Pagamento

    endif

    if  cPaisLoc $ "COS/DOM"
        aAdd(aExp,{'GPE_DISTEMP',POSICIONE("CC2",1,XFILIAL("CC2")+SRA->RA_ESTADO+SRA->RA_MUNICIP,"CC2_MUN"),"CC2->CC2_MUN",STR0220})//"Descripci? del distrito"
    endif

    if cPaisLoc=="COS"

        cDESMTSS:=getQuery(" SELECT SUBSTRING(RCC_CONTEU,5,40) CONTEU FROM "+InitSqlName("RCC") +" WHERE RCC_CODIGO='S006' AND SUBSTRING(RCC_CONTEU,1,4)='"+POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_CODMTSS")+"'")
        cDESCCSS:=getQuery(" SELECT SUBSTRING(RCC_CONTEU,5,80) CONTEU FROM "+InitSqlName("RCC") +" WHERE RCC_CODIGO='S007' AND SUBSTRING(RCC_CONTEU,1,4)='"+POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_CODCCSS")+"'")
        cDESINS:=getQuery (" SELECT SUBSTRING(RCC_CONTEU,6,80) CONTEU FROM "+InitSqlName("RCC") +" WHERE RCC_CODIGO='S008' AND SUBSTRING(RCC_CONTEU,1,5)='"+POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_CODINS")+"'")
        cDESCAN:=getQuery (" SELECT SUBSTRING(RCC_CONTEU,6,40) CONTEU FROM "+InitSqlName("RCC") +" WHERE RCC_CODIGO='S013' AND SUBSTRING(RCC_CONTEU,1,5)='"+SRA->RA_MUNICIP+"'")
        cDESCIC:=getQuery (" SELECT SUBSTRING(RCC_CONTEU,5,40) CONTEU FROM "+InitSqlName("RCC") +" WHERE RCC_CODIGO='S014' AND SUBSTRING(RCC_CONTEU,1,4)='"+SRA->RA_TPCIC+"'")
        cDESJOR:=getQuery (" SELECT SUBSTRING(RCC_CONTEU,5,100) CONTEU FROM "+InitSqlName("RCC") +" WHERE RCC_CODIGO='S021' AND SUBSTRING(RCC_CONTEU,1,2)='"+SRA->RA_TJRNDA+"'")
        cDESFON:=getQuery (" SELECT SUBSTRING(RCC_CONTEU,5,40)  CONTEU FROM "+InitSqlName("RCC") +" WHERE RCC_CODIGO='S004' AND SUBSTRING(RCC_CONTEU,1,4)='"+SRA->RA_FONSOL+"'")

        aAdd(aExp,{'GPE_CODRPAT',SRA->RA_CODRPAT,"SRA->RA_CODRPAT",STR0180})//Codigo do Registro Patronal
        aAdd(aExp,{'GPE_NRPAT',POSICIONE("RCO",1,XFILIAL("RCO")+SRA->RA_CODRPAT,"RCO_NREPAT"),"RCO->RCO_NREPAT",STR0207})//Codigo do Registro Patronal
        aAdd(aExp,{'GPE_POLRT',POSICIONE("RCO",1,XFILIAL("RCO")+SRA->RA_CODRPAT,"RCO_POLRT"),"RCO->RCO_POLRT",STR0208})//"N?ero de P?iza para MTSS"
        aAdd(aExp,{'GPE_SUCCSS',POSICIONE("RCO",1,XFILIAL("RCO")+SRA->RA_CODRPAT,"RCO_SUCCSS"),"RCO->RCO_SUCCSS",STR0209})//"N?ero de Sucursal del CCSS"
        aAdd(aExp,{'GPE_CODMTSS',POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_CODMTSS"),"SRJ->RJ_CODMTSS",STR0210})//"C?igo Ocupaci? MTSS"
        aAdd(aExp,{'GPE_CODCCSS',POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_CODCCSS"),"SRJ->RJ_CODCCSS",STR0211})//"C?igo Ocupaci? CCSS"
        aAdd(aExp,{'GPE_CODCINS',POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_CODINS"),"SRJ->RJ_CODINS",STR0212})//"C?igo Ocupaci? INS"
        aAdd(aExp,{'GPE_DESMTSS',cDESMTSS,"!@             ",STR0213})//"Descripci? de c?igo Ocupaci? MTSS"
        aAdd(aExp,{'GPE_DESCCSS',cDESCCSS,"!@            ",STR0214})//"Descripci? de c?igo Ocupaci? CCSS"
        aAdd(aExp,{'GPE_DESINS',cDESINS,"!@            ",STR0215})//"Descripci? de c?igo Ocupaci? INS"
        aAdd(aExp,{'GPE_KEYLOC',SRA->RA_KEYLOC,"SRA->RA_KEYLOC",STR0174})//Codigo local de Pagamento
        aAdd(aExp,{'GPE_DESLOC',POSICIONE("RGC",1,XFILIAL("RGC")+SRA->RA_KEYLOC,"RGC_DESLOC"),"RGC->RGC_DESLOC",STR0216})//"Descripcion localidad de Pago"
        aAdd(aExp,{'GPE_TNOTRAB',SRA->RA_TNOTRAB,"SRA->RA_TNOTRAB",STR0217})//"Turno Trabajado"
        aAdd(aExp,{'GPE_HRDIA',POSICIONE("SR6",1,XFILIAL("SR6")+SRA->RA_TNOTRAB,"R6_HRDIA"),"SR6->R6_HRDIA",STR0218})//"Horas por Dia"
        aAdd(aExp,{'GPE_BAIRROEMP',SRA->RA_BAIRRO,"SRA->RA_BAIRRO",STR0219})//"Distrito donde vive el trabajador"
        aAdd(aExp,{'GPE_PRINOME',SRA->RA_PRINOME,"SRA->RA_PRINOME",STR0169})//Primeiro Nome
        aAdd(aExp,{'GPE_SECNOME',SRA->RA_SECNOME,"SRA->RA_SECNOME",STR0170})//Segundo Nome
        aAdd(aExp,{'GPE_PRISOBR',SRA->RA_PRISOBR,"SRA->RA_PRISOBR",STR0171})//Primeiro Sobrenome
        aAdd(aExp,{'GPE_SECSOBR',SRA->RA_SECSOBR,"SRA->RA_SECSOBR",STR0172})//Segundo Sobrenome
        aAdd(aExp,{'GPE_CANTEMP',SRA->RA_MUNICIP,"SRA->RA_MUNICIP",STR0221})//"Cant? donde vive el Trabajador"
        aAdd(aExp,{'GPE_DESCCANEMP',cDESCAN,"!@             ",STR0222})//"Descripci? del cant? donde vive el Trabjador"
        aAdd(aExp,{'GPE_PROVEMP',SRA->RA_ESTADO,"SRA->RA_ESTADO",STR0223})//"Provincia donde vive el Trabjador"
        aAdd(aExp,{'GPE_TIPOFIN',SRA->RA_TIPOFIN,"SRA->RA_TIPOFIN",STR0225})//"Tipo de Baja de Acuerdo a la Empresa"
        aAdd(aExp,{'GPE_IDENEMP',cDESCIC,"SRA->RA_CIC",STR0226})//"Tipo n?ero de identificaci?"
        aAdd(aExp,{'GPE_SEGSOC',SRA->RA_RG,"SRA->RA_RG",STR0227})//"N?ero de Seguridad Social"
        aAdd(aExp,{'GPE_DESTIPJOR',cDESJOR,"!@            ",STR0228})//"Descripci? Jornada"
        aAdd(aExp,{'GPE_FECAUM',SRA->RA_FECAUM,"SRA->RA_FECAUM",STR0229})//"Fecha de Modificaci? de Salario"
        aAdd(aExp,{'GPE_DOMICIL',SRA->RA_DOMICIL,"SRA->RA_DOMICIL",STR0230})//"Extranjero viviendo en el Pais(1=Si; 2=No"
        aAdd(aExp,{'GPE_MOEDAPG',SRA->RA_MOEDAPG,"SRA->RA_MOEDAPG",STR0231})//Tipo de Moneda para el salario en contrato (1=local,2=D?ares)
        aAdd(aExp,{'GPE_FONSOL',SRA->RA_FONSOL,"SRA->RA_FONSOL",STR0232})//"Asociaci? Solidarista"

        aAdd(aExp,{'GPE_DESFONSOL',cDESFON,"!@            ",STR0233})//"Descripci? Asociaci? Solidarista"
        aAdd(aExp,{'GPE_TPCCSS',SRA->RA_TPCCSS,"SRA->RA_TPCCSS",STR0234})//"Clase Seguro"
        aAdd(aExp,{'GPE_NSEGURO',SRA->RA_NSEGURO,"SRA->RA_NSEGURO",STR0235})//"N?ero Asegurado"
        aAdd(aExp,{'GPE_GROSSUP',SRA->RA_GROSSUP,"SRA->RA_GROSSUP",STR0236})//"Tipo de Gross Up de Salario"
        aAdd(aExp,{'GPE_ANTEAUM',SRA->RA_ANTEAUM,"SRA->RA_ANTEAUM",STR0237})//"Salario Anterior"

    endif

    if cPaisLoc=="ANG"
        aAdd(aExp,{'GPE_BIDENT',SRA->RA_BIDENT,"SRA->RA_BIDENT",STR0195}) // Nr.Bilhete Identidade
        aAdd(aExp,{'GPE_BIEMISS',SRA->RA_BIEMISS,"SRA->RA_BIEMISS",STR0196})    // Data de Emissao do Bilhete Identidade
        aAdd(aExp,{'GPE_ESTADO',Alltrim(fDescRCC("S001",SRA->RA_ESTADO,1,2,3,30)),"SRA->RA_ESTADO",STR0032}) // Descricao do Distrito
    endif

    aAdd(aExp,{'GPE_DESC_EST_CIV',fDesc("SX5","33"+SRA->RA_ESTCIVI,"X5DESCRI()"),"SRA->RA_ESTCIVI",STR0194}) //Descricao do Estado Civil

    if SRA->RA_CATFUNC $ "I*J"

        aRet:=fTarProf()

        //Inclusao de variaveis contendo as tarefas fixas e aditamentos fixos dos professores
        aAdd(aExp,{'GPE_DESC_TAR_01',aRet[1,1],"@!",STR0197}) // "Descricao da primeira tarefa"
        aAdd(aExp,{'GPE_AULS_TAR_01',aRet[1,2],"SRO->RO_QTDSEM",STR0198}) // "Aulas por semana da primeira tarefa"
        aAdd(aExp,{'GPE_QTD_TAR_01',aRet[1,3],"SRO->RO_QUANT",STR0199}) // "Quantidade da primeira tarefa"
        aAdd(aExp,{'GPE_VUNI_TAR_01',aRet[1,4],"SRO->RO_VALOR",STR0200}) // "Valor unitario da primeira tarefa"
        aAdd(aExp,{'GPE_VTOT_TAR_01',aRet[1,5],"SRO->RO_VALTOT",STR0201}) // "Valor total da primeira tarefa"

        aAdd(aExp,{'GPE_DESC_TAR_02',aRet[2,1],"@!",STR0202}) // "Descricao da segunda tarefa"
        aAdd(aExp,{'GPE_AULS_TAR_02',aRet[2,2],"SRO->RO_QTDSEM",STR0203}) // "Aulas por semana da segunda tarefa"
        aAdd(aExp,{'GPE_QTD_TAR_02',aRet[2,3],"SRO->RO_QUANT",STR0204}) // "Quantidade da segunda tarefa"
        aAdd(aExp,{'GPE_VUNI_TAR_02',aRet[2,4],"SRO->RO_VALOR",STR0205}) // "Valor unit?io da segunda tarefa"
        aAdd(aExp,{'GPE_VTOT_TAR_02',aRet[2,5],"SRO->RO_VALTOT",STR0206}) // "Valor total da segunda tarefa"

    endif

    if cPaisLoc=="BRA"
        //Variaveis criadas para utilizacao no DCN/DMN Documento de Cadastro/Manutencao do NIS-PIS

        cEstCiv:=SRA->RA_ESTCIVI                      //Adequacao do estado civil conforme o leiaute do DCN/DMN-PIS
        Do Case
            Case cEstCiv$"C|M"
                cEstCiv:="CASADO(A)"
            Case cEstCiv$"D"
                cEstCiv:="DIVORCIADO(A)
            Case cEstCiv$"Q"
                cEstCiv:="SEPARADO(A)
            Case cEstCiv$"S"
                cEstCiv:="SOLTEIRO(A)
            Case cEstCiv$"V"
                cEstCiv:="VIUVO(A)
        endCase

        cTipCertd:=SRA->RA_TIPCERT                 //Adequacao da descricao do certificado civil conforme o leiaute do DCN/DMN-PIS
        Do Case
            Case cTipCertd=="1"
                cTipCertd:=OemToAnsi(STR0317)
            Case cTipCertd=="2"
                cTipCertd:=OemToAnsi(STR0318)
            Case cTipCertd=="3"
                cTipCertd:=OemToAnsi(STR0317)
            Case cTipCertd=="4"
                cTipCertd:=OemToAnsi(STR0320)
        endCase

        cGrauInstr:=SRA->RA_GRINRAI
        Do Case                                        //Adequacao da descricao do grau de instrucao conforme o leiaute do DCN/DMN-PIS
            Case cGrauInstr=="10"
                cGrauInstr:=OemToAnsi(STR0295)
            Case cGrauInstr=="20"
                cGrauInstr:=OemToAnsi(STR0296)
            Case cGrauInstr=="25"
                cGrauInstr:=OemToAnsi(STR0297)
            Case cGrauInstr=="30"
                cGrauInstr:=OemToAnsi(STR0298)
            Case cGrauInstr=="35"
                cGrauInstr:=OemToAnsi(STR0299)
            Case cGrauInstr=="40"
                cGrauInstr:=OemToAnsi(STR0300)
            Case cGrauInstr=="45"
                cGrauInstr:=OemToAnsi(STR0301)
            Case cGrauInstr=="50"
                cGrauInstr:=OemToAnsi(STR0302)
            Case cGrauInstr=="55"
                cGrauInstr:=OemToAnsi(STR0303)
            Case cGrauInstr=="65"
                cGrauInstr:=OemToAnsi(STR0304)
            Case cGrauInstr=="75"
                cGrauInstr:=OemToAnsi(STR0305)
            Case cGrauInstr=="85"
                cGrauInstr:=OemToAnsi(STR0306)
            Case cGrauInstr=="95"
                cGrauInstr:=OemToAnsi(STR0307)
        endCase

        aAdd(aExp,{'GPE_NACION_BRASILEIRA',SRA->(if(RA_BRNASEX$"1","",(if(RA_NACIONA$"10","x","")))),"SRA->RA_BRNASEX",STR0250}) // "Marca 'x' se Nacionalidade Brasileira"
        aAdd(aExp,{'GPE_NACION_ESTRANGEIRA',SRA->(if(RA_BRNASEX$"1","",(if(RA_NACIONA$"10","",(if(RA_NACIONA$"20","","x")))))),"SRA->RA_BRNASEX",STR0251}) // "Marca 'x' se Nacionalidade Extrangeira"
        aAdd(aExp,{'GPE_NACION_BRA_NATURA',SRA->(if(RA_BRNASEX$"1","",(if(RA_NACIONA$"10","",(if(RA_NACIONA$"20","x","")))))),"SRA->RA_BRNASEX",STR0252}) // "Marca 'x' se Nacionalidade Brasileira Naturalizada"
        aAdd(aExp,{'GPE_NACION_BRA_NASC_EXTE',SRA->(if(RA_BRNASEX$"1","x","")),"SRA->RA_BRNASEX",STR0253}) // "Marca 'x' se Nacionalidade Brasileiro Nascido no Exterior"
        aAdd(aExp,{'GPE_EST_CIVIL_DCN',cEstCiv,"SRA->RA_ESTCIVI",STR0254}) // "Estado civil de acordo com o NIS/PIS"
        aAdd(aExp,{'GPE_NOME_PAI_DCN',SRA->(if(Empty (SRA->RA_PAI),"IGNORADO",SRA->RA_PAI)),"SRA->RA_PAI",STR0255}) // "Nome do Pai,informa IGNORADO caso esteja em branco"
        aAdd(aExp,{'GPE_NOME_MAE_DCN',SRA->(if(Empty (SRA->RA_MAE),"IGNORADA",SRA->RA_MAE)),"SRA->RA_MAE",STR0256}) // "Nome da Mae,informa IGNORADO caso esteja em branco"
        aAdd(aExp,{'GPE_COMPLEM_RG',SRA->RA_COMPLRG,"SRA->RA_COMPLRG",STR0257}) // "Complemento do RG"
        aAdd(aExp,{'GPE_TIP_CERTID',cTipCertd,"SRA->RA_TIPCERT",STR0258}) // "Tipo de Certidao Civil"
        aAdd(aExp,{'GPE_EMIS_CERTID',SRA->RA_EMICERT,"SRA->RA_EMICERT",STR0259}) // "Data de Emissao da Certidao Civil"
        aAdd(aExp,{'GPE_MAT_CERTID',SRA->RA_MATCERT,"SRA->RA_MATCERT",STR0260}) // "Termo/Matricula da Certidao Civil"
        aAdd(aExp,{'GPE_LIVRO_CERT',SRA->RA_LIVCERT,"SRA->RA_LIVCERT",STR0261}) // "Livro da Certidao Civil"
        aAdd(aExp,{'GPE_FOLHA_CERT',SRA->RA_FOLCERT,"SRA->RA_FOLCERT",STR0262}) // "Folha da Certidao Civil"
        aAdd(aExp,{'GPE_CART_CERTID',SRA->RA_CARCERT,"SRA->RA_CARCERT",STR0263}) // "Cartorio da Certidao Civil"
        aAdd(aExp,{'GPE_UF_CERTIDAO',SRA->RA_UFCERT,"SRA->RA_UFCERT",STR0264}) // "UF da Certidao Civil"
        aAdd(aExp,{'GPE_MUN_CERTIDAO',fDesc("CC2",SRA->RA_UFCERT+SRA->RA_CDMUCER,"CC2_MUN"),"SRA->RA_MUNCERT",STR0265}) // "Municipio da Certidao Civil"
        aAdd(aExp,{'GPE_NUM_PASSAPOR',SRA->RA_NUMEPAS,"SRA->RA_NUMEPAS",STR0266}) // "Numero do Passaporte"
        aAdd(aExp,{'GPE_EMIS_PASSAPOR',SRA->RA_EMISPAS,"SRA->RA_EMISPAS",STR0267}) // "Orgao Emissor do Passaporte"
        aAdd(aExp,{'GPE_UF_PASSAPORTE',SRA->RA_UFPAS,"SRA->RA_UFPAS",STR0268}) // "UF do Passaporte"
        aAdd(aExp,{'GPE_DT_EMIS_PAS',SRA->RA_DEMIPAS,"SRA->RA_DEMIPAS",STR0269}) // "Data Emissao Passaporte"
        aAdd(aExp,{'GPE_DT_VALID_PAS',SRA->RA_DVALPAS,"SRA->RA_DVALPAS",STR0270}) // "Data Validade Passaporte"
        aAdd(aExp,{'GPE_PAIS_PASSAPOR',fDesc("CCH",SRA->RA_CODPAIS,"CCH_PAIS"),"SRA->RA_PAISPAS",STR0271}) // "Pais de Emissao Passaporte"
        aAdd(aExp,{'GPE_NUM_NATURALIZ',SRA->RA_NUMNATU,"SRA->RA_NUMNATU",STR0272}) // "Numero de Naturalizacao"
        aAdd(aExp,{'GPE_DATA_NATURALIZ',SRA->RA_DATNATU,"SRA->RA_DATNATU",STR0273}) // "Data de Naturalizacao"
        aAdd(aExp,{'GPE_NUMERO_RIC',SRA->RA_NUMRIC,"SRA->RA_NUMRIC",STR0274}) // "Numero do RIC"
        aAdd(aExp,{'GPE_EMISSAO_RIC',SRA->RA_EMISRIC,"SRA->RA_EMISRIC",STR0275}) // "Orgao Emissor do RIC"
        aAdd(aExp,{'GPE_UF_RIC',SRA->RA_UFRIC,"SRA->RA_UFRIC",STR0276}) // "UF do RIC"
        aAdd(aExp,{'GPE_MUNICIPIO_RIC',fDesc("CC2",SRA->RA_UFRIC+SRA->RA_CDMURIC,"CC2_MUN"),"SRA->RA_MUNIRIC",STR0277}) // "Municipio do RIC"
        aAdd(aExp,{'GPE_DATA_EXP_RIC',SRA->RA_DEXPRIC,"SRA->RA_DEXPRIC",STR0278}) // "Data de Expedicao do RIC"
        aAdd(aExp,{'GPE_TIPO_endERECO_COM',SRA->(if(RA_TIPendE$"1","x","")),"SRA->RA_TIPendE",STR0279}) // "Marca 'x' se endereco for Comercial"
        aAdd(aExp,{'GPE_TIPO_endERECO_RES',SRA->(if(RA_TIPendE$"2","x","")),"SRA->RA_TIPendE",STR0280}) // "Marca 'x' se endereco for Residencial"
        aAdd(aExp,{'GPE_NUM_endERECO',SRA->RA_NUMendE,"SRA->RA_NUMendE",STR0281}) // "Numero do endereco"
        aAdd(aExp,{'GPE_CAIXA_POSTAL',SRA->RA_CPOSTAL,"SRA->RA_CPOSTAL",STR0282}) // "Caixa Postal"
        aAdd(aExp,{'GPE_CEP_CAIXA_POSTAL',SRA->RA_CEPCXPO,"SRA->RA_CEPCXPO",STR0283}) // "CEP da Caixa Postal"
        aAdd(aExp,{'GPE_DDD_TELEFONE',SRA->RA_DDDFONE,"SRA->RA_DDDFONE",STR0284}) // "DDD do Telefone"
        aAdd(aExp,{'GPE_DDD_CELULAR',SRA->RA_DDDCELU,"SRA->RA_DDDCELU",STR0285}) // "DDD do Celular"
        aAdd(aExp,{'GPE_NUM_CELULAR',SRA->RA_NUMCELU,"SRA->RA_NUMCELU",STR0286}) // "Numero do Celular"
        aAdd(aExp,{'GPE_EMPRESA_TIPO_CNPJ',if(aInfo[15]==2,"x",""),"@!",STR0287}) // "Marca 'x' se Empresa por CNPJ"
        aAdd(aExp,{'GPE_EMPRESA_TIPO_CEI',if(aInfo[15]==1,"x",""),"@!",STR0288}) // "Marca 'x' se Empresa por CEI"
        aAdd(aExp,{'GPE_DATA_CHEGADA',SRA->RA_DATCHEG,"SRA->RA_DATCHEG",STR0289}) // "Data de Expedicao do RIC"
        aAdd(aExp,{'GPE_SECAO',SRA->RA_SECAO,"SRA->RA_SECAO",STR0290}) // "Secao Eleitoral"
        aAdd(aExp,{'GPE_INST_DCN',cGrauInstr,"@!",STR0291}) // "Grau de Instrucao conforme NIS/PIS"
        aAdd(aExp,{'GPE_PAIS_ORIGEM_PIS',SRA->(if(RA_NACIONA<>"10".or.RA_BRNASEX=="1",fDesc("CCH",SRA->RA_CPAISOR,"CCH_PAIS"),"")),"SRA->RA_PAISORI",STR0292}) // "Pais de Origem para o DCN/DMN"
        aAdd(aExp,{'GPE_COD_UF_NASCTO_PIS',SRA->(if(RA_NACIONA=="10".and.RA_BRNASEX<>"1",SRA->RA_NATURAL,"")),"SRA->RA_NATURAL",STR0308}) // "Estado de Nascimento NIS/PIS"
        aAdd(aExp,{'GPE_MUNICIPIO_NASCTO_PIS',SRA->(if(RA_NACIONA=="10".and.RA_BRNASEX<>"1",SRA->RA_MUNNASC,"")),"SRA->RA_MUNNASC",STR0309}) // "Municipio de Nascimento NIS/PIS"
        aAdd(aExp,{'GPE_TIPO_MANUT_NIS_ALTER',if(cTipNIS=="1","x",""),"@!",STR0310})    // "Marca 'x' para tipo de DMN-Alteracao"
        aAdd(aExp,{'GPE_TIPO_MANUT_NIS_CADAS',if(cTipNIS=="2","x",""),"@!",STR0311})    // "Marca 'x' para tipo de DMN-Cadastro Retroativo"
        aAdd(aExp,{'GPE_TIPO_MANUT_NIS_CANCE',if(cTipNIS=="3","x",""),"@!",STR0312})    // "Marca 'x' para tipo de DMN-Cancelamento"
        aAdd(aExp,{'GPE_TIPO_MANUT_NIS_REATI',if(cTipNIS=="4","x",""),"@!",STR0313})    // "Marca 'x' para tipo de DMN-Reativacao"
        aAdd(aExp,{'GPE_TIPO_MANUT_NIS_RETRO',if(cTipNIS=="5","x",""),"@!",STR0314})    // "Marca 'x' para tipo de DMN-Retroacao Cadastral"
        aAdd(aExp,{'GPE_COD_SEXO_MASCULINO',SRA->(if(RA_SEXO=="M","x","")),"SRA->RA_SEXO",STR0315})    // "Marca 'x' se sexo for Masculino"
        aAdd(aExp,{'GPE_COD_SEXO_FEMININO',SRA->(if(RA_SEXO=="F","x","")),"SRA->RA_SEXO",STR0316})    // "Marca 'x' se sexo for Feminino"
        aAdd(aExp,{'GPE_COD_SERVENTIA',SRA->RA_SERVENT,"SRA->RA_SERVENT",STR0336})    // Codigo da Serventia
        aAdd(aExp,{'GPE_COD_ACERVO',SRA->RA_CODACER,"SRA->RA_CODACER",STR0337})    // Codigo do Acervo
        aAdd(aExp,{'GPE_REG_CIVIL',SRA->RA_REGCIVI,"SRA->RA_REGCIVI",STR0338})    // Registro Civil
        aAdd(aExp,{'GPE_TIPO_LIVRO',SRA->RA_TPLIVRO,"SRA->RA_TPLIVRO",STR0339})    // Tipo do Livro Reg.

        cCodAtiv:=POSICIONE("SQ3",1,XFILIAL("SQ3")+SRA->RA_CARGO,"Q3_DESCDET")
        dbSelectArea("SQ3")
        aAdd(aExp,{'GPE_CARGO_ATIVIDADE',MSMM(cCodAtiv,80),"@!",STR0390})    // "Descri豫o da atividade da fun豫o"

    endif

    return(aExp)
    
/*
    Programa:GpeWriter
    Funcao:GetQuery
    Autor:R.H.
    Data:05/07/2000
    Descricao:Retorna Informacoes da Definicao de Tabelas
    Sintaxe:Chamada padrao para programas em "RdMake".
    Uso:Generico
    Obs.:

-------------------------------------------------------------------------
            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.
-------------------------------------------------------------------------
Programador        |Data      |Motivo Alteracao
-------------------------------------------------------------------------
                   |DD/MM/YYYY|
-------------------------------------------------------------------------*/
static function GetQuery(cQuery)
    local cDes:=""
    local cAliasTmp:=CriaTrab(nil,.F.)
    
        cQuery:=ChangeQuery(cQuery)
        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.)
        (cAliasTmp)->(dbgotop())
        if(cAliasTmp)->(!eof())
            cDes:=(cAliasTmp)->CONTEU
        endif
    
        (cAliasTmp)->(dbCloseArea())
    
    return(cDes)
    
/*
    Programa:GpeWriter
    Funcao:OpTpPisF
    Autor:R.H.
    Data:05/07/2000
    Descricao:Retorna Informacoes da Definicao de Tabelas
    Sintaxe:Chamada padrao para programas em "RdMake".
    Uso:Generico
    Obs.:

-------------------------------------------------------------------------
            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.
-------------------------------------------------------------------------
Programador        |Data      |Motivo Alteracao
-------------------------------------------------------------------------
                   |DD/MM/YYYY|
-------------------------------------------------------------------------*/
User function OpTpPisF()
    
    local cTitulo:=""
    
    local MVPARDEF:=""
    local MVRET
    local MVPAR
    
    local lRet:=.T.
    
    private aInc:={}
    
    if Alltrim(ReadVar())="MV_PAR30"

        MVPAR:=&(Alltrim(ReadVar()))// Carrega Nome da Variavel do Get em Questao
        MVRET:=Alltrim(ReadVar())// Iguala Nome da Variavel ao Nome variavel de Retorno
        aInc:={STR0322,STR0323,STR0324,STR0325,STR0326,STR0327}//"Nenhum";"Alteracao";"Cadastro Retroativo";"Cancelamento";
                                                               //"Reativacao";"Retroacao Cadastral"
        MVPARDEF:="012345"
        cTitulo:=STR0321// "Informe o Tipo de Alteracao do NIS-PIS"

        f_Opcoes(@MVPAR,cTitulo,aInc,MVPARDEF,12,49,.T.)// Chama funcao f_Opcoes

        &MVRET:=MVPAR// Devolve Resultado

    endif

    return(.T.)
    
/*
    Programa:GpeWriter
    Funcao:ChkProfile()
    Autor:R.H.
    Data:05/07/2000
    Descricao:Avalia o conteudo ja existente no profile e o altera se necessario
    Sintaxe:Chamada padrao para programas em "RdMake".
    Uso:Generico
    Obs.:

-------------------------------------------------------------------------
            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.
-------------------------------------------------------------------------
Programador        |Data      |Motivo Alteracao
-------------------------------------------------------------------------
                   |DD/MM/YYYY|
-------------------------------------------------------------------------*/
static function ChkProfile(lCheck)
    local cAlias:="ProfAlias"
    local cCampo
    BEGIN SEQUENCE
        if !(lCheck)
            BREAK
        endif
        OpenProfile()
        if.NOT.((cAlias)->(DbSeek(SM0->M0_CODIGO+Padl(&("CUSERNAME"),13)+cPerg)))
            BREAK
        endif
        cCampo:=SubStr(AllTrim((cAlias)->P_DEFS),487,75)
        cCampo:=Upper(cCampo)
        if (".DOT" $ cCampo.or.".ODT" $ cCampo.or.".DOC" $ cCampo.or.".OTT" $ cCampo)
            BREAK
        endif
        if (cAlias)->(RecLock(cAlias,.F.))
            (cAlias)->P_DEFS:=""
            (cAlias)->(MsUnLock())
        endif
    end SEQUENCE
    return(nil)

/*
    Programa:GpeWriter
    Funcao:GPE2Writer
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:02/07/2012
    Descricao:Permitir a Impressao de Documentos Funcionais do totvs/protheus no OpenOffice Writer
    Sintaxe:Chamada padrao para programas em "RdMake".
    Uso:Generico
    Obs.:

-------------------------------------------------------------------------
            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.
-------------------------------------------------------------------------
Programador        |Data      |Motivo Alteracao
-------------------------------------------------------------------------
                   |DD/MM/YYYY|
-------------------------------------------------------------------------*/
static function GPE2Writer(lExport,aInfo,cArqWord,lImpress,cArqSaida,nCopias,cPrinter,cOrientation,cError,cCRLF,lPreview)

    local aFields

    local cCmd
    local cDir:=(CurDrive()+"\gpe_writer\")
    local cField
    local cFError:=(cDir+"gpe_writer_error.log")
    local cDirSave:=(cDir+"save\")
    local cPicture
    local caFields3
    local cfSemaphore:=(cDir+"oOOWriter.lck")
    local cFWParameters:=(cDir+"gpe_wparameters.csv")

    local lOK:=.F.

    local n
    local nWait:=if((lImpress:=(ValType(lImpress)=="L".and.lImpress)),1,1)
    local nFile:=-1
    local nField
    local nFields
    local nAttempts
    local nSleep:=if(lImpress,.5,.5)

    DEFAULT lExport:=.T.
    DEFAULT cCRLF:=CRLF
    DEFAULT lPreview:=.F.

    BEGIN SEQUENCE

        nAttempts:=0
        While !(lIsDir(cDir))
            if (++nAttempts>10)
                cError:="Diretorio "+cDir+" Nao Encontrado"
                ApMsgAlert(cError,"A T E N C A O !!!")
                BREAK
            endif
            Sleep(100)
            MakeDir(cDir)
        end While

        if !(lImpress)
            nAttempts:=0
            While !(lIsDir(cDirSave))
                if (++nAttempts>10)
                    cError:="Diretorio "+cDirSave+" para salvamento dos arquivos Nao Encontrado"
                    ApMsgAlert(cError,"A T E N C A O !!!")
                    BREAK
                endif
                Sleep(100)
                MakeDir(cDirSave)
            end While
            if.NOT.(lExport)
                cArqSaida:=(cDirSave+cArqSaida)
            endif
      endif

       nFile:=fCreate(cFWParameters)
       nAttempts:=0
       While (nFile==-1)
           if (++nAttempts>10)
               exit
           endif
           Sleep(100)
           nFile:=fCreate(cFWParameters)
       end While

       if (nFile==-1)
           cError:="Impossivel Exportar arquivo com Dados para Impressao"
           ApMsgAlert(cError,"A T E N C A O !!!")
           BREAK
       endif

       aFields:=fCpos_Word()
       nFields:=Len(aFields)
       for n:=1 To 2
           for nField:=1 To nFields
               if (n==1)
                   fWrite(nFile,AllTrim(aFields[nField][1]))
               else
                   if (SubStr(AllTrim(aFields[nField][3]),4,2)=="->")
                       caFields3:=AllTrim(aFields[nField][3])
                       cPicture:=X3Picture(SubStr(caFields3,AT(">",caFields3)+1))
                   else
                       cPicture:=aFields[ nField ][3]
                   endif
                   cField:=Transform(aFields[ nField ][2],cPicture)
                   fWrite(nFile,cField)
               endif
               if (nField<nFields)
                   fWrite(nFile,"|")
               elseif (nField==nFields)
                   fWrite(nFile,cCRLF)
               endif
           next nField
       next n

       fClose(nFile)
       nFile:=fOpen(cFWParameters,FO_READ)

       if (lExport)
           ApMsgAlert(cFWParameters+" Exportado com Sucesso","Aviso")
           lOK:=.T.
           BREAK
       endif

       nAttempts:=0
       While File(cfSemaphore)
           if (++nAttempts>=100)
               BREAK
           endif
           Sleep(100)
           fErase(cfSemaphore)
       end While

       if !(lImpress)
           cPrinter:="file:///"
           cPrinter+=StrTran(cArqSaida,"\","/")
           cOrientation:="P"
       endif

       cCmd:=CurDrive()+"\gpe_writer\gpe_writer.exe"
       cCmd+=" "
       cCmd+='"'+cArqWord+'"'
       cCmd+=" "
       cCmd+=cValToChar(lImpress)
       cCmd+=" "
       cCmd+=cValToChar(nCopias)
       cCmd+=" "
       cCmd+=cValToChar(nWait)
       cCmd+=" "
       cCmd+=cValToChar(nSleep)
       cCmd+=" "
       cCmd+='"'+cPrinter+'"'
       cCmd+=" "
       cCmd+=cOrientation
       cCmd+=" "
       cCmd+='"'+cArqSaida+'"'
       cCmd+=" "
       cCmd+=cValToChar(lPreview)

       WaitRun(cCmd,SW_HIDE)

       lOK:=.not.(File(cFError).or.File(cfSemaphore))

       if.not.(lOK)
           if File(cFError)
               cError:=MemoRead(cFError)
               fErase(cFError)
           else
               cError:="Operacao nao completada.Erro Indefinido:"+cfSemaphore
               fErase(cfSemaphore)
           endif
       endif

       fClose(nFile)
       nFile:=-1
       if File(cFWParameters)
           fErase(cFWParameters)
       endif

    end SEQUENCE

    if !(nFile==-1)
        fClose(nFile)
    endif

    if !(lExport)
        if File(cFWParameters)
            fErase(cFWParameters)
        endif
    endif

    return(lOK)

/*
    Programa:GpeWriter
    Funcao:ValidPerg
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:02/07/2012
    Descricao:Verifica as Perguntas a serem utilizadas no Programa
    Sintaxe:Chamada padrao para programas em "RdMake".
    Uso:Generico
    Obs.:

-------------------------------------------------------------------------
            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.
-------------------------------------------------------------------------
Programador        |Data      |Motivo Alteracao
-------------------------------------------------------------------------
                   |DD/MM/YYYY|
-------------------------------------------------------------------------*/
static function ValidPerg(cPerg)
/*

    local aPerg
    local aGRPSXG

    local cOrdem
    local cGRPSXG

    local cX1Tipo
    local cPicSXG

    local nTamSXG
    local nDecSXG

    aPerg:=Array(0)
    cPerg:=Padr(cPerg,Len(SX1->X1_GRUPO))
    cOrdem:=Replicate("0",Len(SX1->X1_ORDEM))
    cGRPSXG:=""  
    
    nTamSXG:=0
    nDecSXG:=0
  
    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,X3Tamanho("RA_FILIAL"),X3Decimal("RA_FILIAL"),X3Picture("RA_FILIAL"))
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:=GetSx3Cache("RA_FILIAL","X3_TIPO")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Filial De ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿De Sucursal ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","From Branch ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CH1")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR01")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","XM0")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHFILDE.")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,X3Tamanho("RA_FILIAL"),X3Decimal("RA_FILIAL"),X3Picture("RA_FILIAL"))
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:=GetSx3Cache("RA_FILIAL","X3_TIPO")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Filial Ate ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿A Sucursal ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","To Branch ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CH2")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","naovazio")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR02")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","ZZ")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","XM0")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHFILAT.")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:="004"
    aGRPSXG:=SXGSize(cGRPSXG,X3Tamanho("RA_CC"),X3Decimal("RA_CC"),X3Picture("RA_CC"))
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:=GetSx3Cache("RA_CC","X3_TIPO")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Centro de Custo De ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿De Centro de Costo ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","From Cost Center ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CH3")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR03")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","CTT")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHCCDE.")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:="004"
    aGRPSXG:=SXGSize(cGRPSXG,X3Tamanho("RA_CC"),X3Decimal("RA_CC"),X3Picture("RA_CC"))
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:=GetSx3Cache("RA_CC","X3_TIPO")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Centro de Custo Ate ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿A Centro de Costo ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","To Cost Center ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CH4")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","naovazio")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR04")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","ZZZZZZZZZ")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","CTT")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHCCAT.")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,X3Tamanho("RA_MAT"),X3Decimal("RA_MAT"),X3Picture("RA_MAT"))
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:=GetSx3Cache("RA_MAT","X3_TIPO")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Matricula De ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿De Matricula ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","From Registration ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CH5")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR05")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","SRA")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHMATD.")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,X3Tamanho("RA_MAT"),X3Decimal("RA_MAT"),X3Picture("RA_MAT"))
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:=GetSx3Cache("RA_MAT","X3_TIPO")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Matricula Ate ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿A Matricula ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","To Registration ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CH6")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","naovazio")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR06")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","ZZZZZZ")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","SRA")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHMATA.")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,X3Tamanho("RA_NOME"),X3Decimal("RA_NOME"),X3Picture("RA_NOME"))
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:=GetSx3Cache("RA_NOME","X3_TIPO")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Nome De ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿De Nombre ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","From Name ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CH7")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR07")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHNOMED.")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,X3Tamanho("RA_NOME"),X3Decimal("RA_NOME"),X3Picture("RA_NOME"))
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:=GetSx3Cache("RA_NOME","X3_TIPO")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Nome Ate ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿A Nombre ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","To Name ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CH8")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","naovazio")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR08")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHNOMEA.")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,X3Tamanho("RA_TNOTRAB"),X3Decimal("RA_TNOTRAB"),X3Picture("RA_TNOTRAB"))
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:=GetSx3Cache("RA_TNOTRAB","X3_TIPO")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Turno De ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿De Turno ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","From Shift ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CH9")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR09")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","SR6")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHTURDE.")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,X3Tamanho("RA_TNOTRAB"),X3Decimal("RA_TNOTRAB"),X3Picture("RA_TNOTRAB"))
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:=GetSx3Cache("RA_TNOTRAB","X3_TIPO")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Turno Ate ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿A Turno ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","To Shift ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHa")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","naovazio")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR10")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","ZZZ")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","SR6")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHTURAT.")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,X3Tamanho("RA_CODFUNC"),X3Decimal("RA_CODFUNC"),X3Picture("RA_CODFUNC"))
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:=GetSx3Cache("RA_CODFUNC","X3_TIPO")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Funcao De ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿De Funcion ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","From Position ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHb")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR11")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","SRJ")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHFUNCD.")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,X3Tamanho("RA_CODFUNC"),X3Decimal("RA_CODFUNC"),X3Picture("RA_CODFUNC"))
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:=GetSx3Cache("RA_CODFUNC","X3_TIPO")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Funcao Ate ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿A Funcion ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","To Position ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHc")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","naovazio")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR12")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","ZZZZZ")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","SRJ")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHFUNCA.")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,X3Tamanho("RA_SINDICA"),X3Decimal("RA_SINDICA"),X3Picture("RA_SINDICA"))
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:=GetSx3Cache("RA_SINDICA","X3_TIPO")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Sindicato De ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿De Sindicato ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","From Union ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHd")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR13")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","RCE")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHSINDID.")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,X3Tamanho("RA_SINDICA"),X3Decimal("RA_SINDICA"),X3Picture("RA_SINDICA"))
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:=GetSx3Cache("RA_SINDICA","X3_TIPO")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Sindicato Ate ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿A Sindicato ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","To Union ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHe")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","naovazio")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR14")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","ZZ")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","RCE")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHSINDIA.")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,X3Tamanho("RA_ADMISSA"),X3Decimal("RA_ADMISSA"),X3Picture("RA_ADMISSA"))
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:=GetSx3Cache("RA_ADMISSA","X3_TIPO")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Admissao De ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿De Admision ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","From Adimission ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHf")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR15")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","15/12/1970")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,X3Tamanho("RA_ADMISSA"),X3Decimal("RA_ADMISSA"),X3Picture("RA_ADMISSA"))
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:=GetSx3Cache("RA_ADMISSA","X3_TIPO")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Admissao Ate ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿A Admision ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","To Admission ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHg")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","naovazio")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR16")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","15/12/2999")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,5,0,"")
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:="C"
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Situacoes  a Impr.?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿Situaciones a Impr ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","Status to Print ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHh")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","fSituacao")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR17")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01"," ADFT")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHSITUA.")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,15,0,"")
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:="C"
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Categorias a Impr.?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿Categorias a Impr.?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","Categories to Print ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHi")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","fCategoria")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR18")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","ACDEGHMPST")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHCATEG.")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,40,0,"")
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:="C"
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Texto Livre 01 ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿Texto Libre 01 ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","Free Text 01 ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHj")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR19")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","<Texto Livre 01>")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,40,0,"")
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:="C"
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Texto Livre 02 ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿Texto Libre 02 ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","Free Text 02 ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHk")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR20")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","<Texto Livre 02>")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,40,0,"")
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:="C"
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Texto Livre 03 ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿Texto Libre 03 ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","Free Text 03 ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHl")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR21")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","<Texto Livre 03>")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,40,0,"")
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:="C"
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Texto Livre 04 ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿Texto Libre 04 ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","Free Text 04 ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHm")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR22")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","<Texto Livre 04>")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,3,0,"")
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:="N"
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Nro.Copias ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿Numero Copias ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","CopyNumber ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHn")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","naovazio")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR23")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","1")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,1,0,"")
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:="N"
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Ordem de Impressao ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿Orden de Impresion ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","Printing Order ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHo")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PRESEL",1)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","C")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR24")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF01","Matricula")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA1","Matricula")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG1","Registration")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF02","Centro de Custo")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA2","Centro de Costo")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG2","Cost Center")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF03","Nome")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA3","Nombre")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG3","Name")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF04","Turno")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA4","Turno")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG4","Shift")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF05","Admissao")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA5","Admision")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG5","Admission")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,75,0,"")
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:="C"
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Arquivo do Writer?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿Archivo del Writer?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","Writer File ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHp")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","U_WriteFOpen()")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR25")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","1")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,1,0,"")
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:="N"
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Verific.Dependente ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿Verific.Dependiente ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","Check Dependant ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHQ")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PRESEL",1)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","C")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR26")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF01","Sim")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA1","Si")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG1","Yes")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF02","Nao")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA2","No")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG2","No")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,1,0,"")
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:="N"
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Tipo de Dependente ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿Tipo de Dependiente ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","Dependent Type ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHR")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PRESEL",3)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","C")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR27")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF01","Dep.Sal.Familia")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA1","Dep.Sal.Familia")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG1","Fam.Allow.Dep.")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF02","Dep.Imp.Renda")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA2","Dep.Imp.Renta")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG2","Income Dep.")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF02","Ambos")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA2","Ambos")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG2","Both")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,1,0,"")
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:="N"
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Impressao ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿Impresion ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","Printing ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHS")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PRESEL",1)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","C")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR28")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF01","Impressora")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA1","Impresora")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG1","Printer")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF02","Arquivo")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA2","Arquivo")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG2","Arquivo")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,5,0,"")
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:="C"
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Extensao do arquivo ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿Extension de archivo ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","File Extension ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHT")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR29")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,1,0,"")
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:="C"
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Tipo PIS-DCN/DMN ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿Tipo PIS-DCN/DMN ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","Tipo PIS-DCN/DMN ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHU")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PRESEL",1)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","U_OpTpPisF()")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR30")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF01","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA1","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG1","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF02","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA2","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG2","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)


    cOrdem:=__Soma1(cOrdem)
    cGRPSXG:=""
    aGRPSXG:=SXGSize(cGRPSXG,1,0,"")
    nTamSXG:=aGRPSXG[1]
    nDecSXG:=aGRPSXG[2]
    cPicSXG:=aGRPSXG[3]
    cX1Tipo:="N"
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Preview ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA","¿Preview ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG","Preview ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHV")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PRESEL",1)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","C")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR31")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF01","Nao")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA1","Nao")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG1","Nao")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF02","Sim")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA2","Sim")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG2","Sim")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)
*/
    WriteSX1(@cPerg,@aPerg)

    return(Pergunte(cPerg,.F.))

/*
    Programa:GpeWriter
    Funcao:WriteSX1
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:02/07/2012
    Descricao:Adiciona e/ou Remove Perguntas utilizadas no Programa
    Sintaxe:Chamada padrao para programas em "RdMake".
    Uso:Generico
    Obs.:

-------------------------------------------------------------------------
            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.
-------------------------------------------------------------------------
Programador        |Data      |Motivo Alteracao
-------------------------------------------------------------------------
                   |DD/MM/YYYY|
-------------------------------------------------------------------------*/
static Procedure WriteSX1(cPerg,aPerg)
/*
    local cKeySeek

    local lFound
    local lAddNew

    local nBL
    local nEL

    local nAT
    local nField
    local nFields
    local nAtField

    local __nGrupo
    local __nOrdem
    local __nField

    local uCNT

    nEL:=Len(aPerg)

    __nGrupo:=1
    __nOrdem:=2
    __nField:=3

    SX1->(dbSetOrder(1)) //X1_GRUPO+X1_ORDEM

    cPerg:=Padr(cPerg,Len(SX1->X1_GRUPO))

    SX1->(dbGoTop())
    SX1->(dbSeek(cPerg,.F.))

    While SX1->(!eof().and.X1_GRUPO==cPerg)
        nAT:=SX1->(aScan(aPerg,{|x|((x[__nGrupo]==X1_GRUPO).and.(x[__nOrdem]==X1_ORDEM))}))
        lFound:=(nAT>0)
        if !(lFound)
            if SX1->(RecLock("SX1",.F.))
                SX1->(dbDelete())
                SX1->(MsUnLock())
            endif
        endif
        SX1->(dbSkip())
    end While

    for nBL:=1 To nEL
        cKeySeek:=aPerg[nBL][__nGrupo]
        cKeySeek+=aPerg[nBL][__nOrdem]
        lFound:=SX1->(dbSeek(cKeySeek,.T.))
        lAddNew:=!(lFound)
        if SX1->(RecLock("SX1",lAddNew))
            nFields:=Len(aPerg[nBL][__nField])
            for nField:=1 To nFields
                nAtField:=aPerg[nBL][__nField][nField][4]
                lChange:=(aPerg[nBL][__nField][nField][3].and.(nAtField>0))
                if (lChange)
                    uCNT:=aPerg[nBL][__nField][nField][2]
                    SX1->(FieldPut(nAtField,uCNT))
                endif
            next nField
            SX1->(MsUnLock())
        endif
    next nBL
*/
    return

/*
    Programa:GpeWriter
    Funcao:AddPerg
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:02/07/2012
    Descricao:Adiciona Informacoes do compo
    Sintaxe:Chamada padrao para programas em "RdMake".
    Uso:Generico
    Obs.:

-------------------------------------------------------------------------
            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.
-------------------------------------------------------------------------
Programador        |Data      |Motivo Alteracao
-------------------------------------------------------------------------
                   |DD/MM/YYYY|
-------------------------------------------------------------------------*/
static Procedure AddPerg(aPerg,cGrupo,cOrdem,cField,uCNT)
    
    local bDummy
/*
    local bEval

    local nAT
    local nATField

    local __nGrupo
    local __nOrdem
    local __nField

    static aX1Fields
    static __cX1Fields

    __nGrupo:=1
    __nOrdem:=2
    __nField:=3


*/
    bDummy:={||AddPerg(@aPerg,@cGrupo,@cOrdem,@cField,@uCNT)}
/*

    if !(Type("cEmpAnt")=="C")
        private cEmpAnt:=""
    endif

    if ((aX1Fields==nil).or.!(__cX1Fields==cEmpAnt))
        __cX1Fields:=cEmpAnt
        aX1Fields:={;
                                    {"X1_GRUPO",nil,.T.,0},;
                                    {"X1_ORDEM",nil,.T.,0},;
                                    {"X1_PERGUNT",nil,.T.,0},;
                                    {"X1_PERSPA",nil,.T.,0},;
                                    {"X1_PERENG",nil,.T.,0},;
                                    {"X1_VARIAVL",nil,.T.,0},;
                                    {"X1_TIPO",nil,.T.,0},;
                                    {"X1_TAMANHO",nil,.T.,0},;
                                    {"X1_DECIMAL",nil,.T.,0},;
                                    {"X1_PRESEL",nil,.F.,0},;
                                    {"X1_GSC",nil,.T.,0},;
                                    {"X1_VALID",nil,.T.,0},;
                                    {"X1_VAR01",nil,.T.,0},;
                                    {"X1_DEF01",nil,.T.,0},;
                                    {"X1_DEFSPA1",nil,.T.,0},;
                                    {"X1_DEFENG1",nil,.T.,0},;
                                    {"X1_CNT01",nil,.F.,0},;
                                    {"X1_VAR02",nil,.T.,0},;
                                    {"X1_DEF02",nil,.T.,0},;
                                    {"X1_DEFSPA2",nil,.T.,0},;
                                    {"X1_DEFENG2",nil,.T.,0},;
                                    {"X1_CNT02",nil,.F.,0},;
                                    {"X1_VAR03",nil,.T.,0},;
                                    {"X1_DEF03",nil,.T.,0},;
                                    {"X1_DEFSPA3",nil,.T.,0},;
                                    {"X1_DEFENG3",nil,.T.,0},;
                                    {"X1_CNT03",nil,.F.,0},;
                                    {"X1_VAR04",nil,.T.,0},;
                                    {"X1_DEF04",nil,.T.,0},;
                                    {"X1_DEFSPA4",nil,.T.,0},;
                                    {"X1_DEFENG4",nil,.T.,0},;
                                    {"X1_CNT04",nil,.F.,0},;
                                    {"X1_VAR05",nil,.T.,0},;
                                    {"X1_DEF05",nil,.T.,0},;
                                    {"X1_DEFSPA5",nil,.T.,0},;
                                    {"X1_DEFENG5",nil,.T.,0},;
                                    {"X1_CNT05",nil,.F.,0},;
                                    {"X1_F3",nil,.T.,0},;
                                    {"X1_PYME",nil,.T.,0},;
                                    {"X1_GRPSXG",nil,.T.,0},;
                                    {"X1_HELP",nil,.T.,0},;
                                    {"X1_PICTURE",nil,.T.,0},;
                                    {"X1_IDFIL",nil,.T.,0};
                      }

            bEval:={|x,y|;
                                    nATField:=FieldPos(aX1Fields[y][1]),;
                                    aX1Fields[y][2]:=GetValType(ValType(FieldGet(nATField))),;
                                    aX1Fields[y][4]:=nATField,;
               }

            SX1->(aEval(aX1Fields,bEval))

        endif

        nAT:=aScan(aPerg,{|x|((x[1]==cGrupo).and.(x[2]==cOrdem))})

        if (nAT==0)
            aAdd(aPerg,{cGrupo,cOrdem,aClone(aX1Fields)})
            nAT:=Len(aPerg)
        endif

        cField:=Upper(AllTrim(cField))
        nATField:=aScan(aPerg[nAT][3],{|e| (e[1]==cField)})

        if (nATField>0)

            aPerg[nAT][__nField][nATField][2]:=uCNT

            nATField:=aScan(aPerg[nAT][3],{|e| (e[1]=="X1_GRUPO")})
            if (nATField>0)
                aPerg[nAT][__nField][nATField][2]:=cGrupo
            endif

            nATField:=aScan(aPerg[nAT][3],{|e| (e[1]=="X1_ORDEM")})
            if (nATField>0)
                aPerg[nAT][__nField][nATField][2]:=cOrdem
            endif

        endif
*/
    return

/*
    Programa:GpeWriter
    Funcao:SXGSize
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:02/07/2012
    Descricao:Obtem Informacoes do Grupo em SXG (Size e Picture)
    Sintaxe:Chamada padrao para programas em "RdMake".
    Uso:Generico
    Obs.:

-------------------------------------------------------------------------
            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.
-------------------------------------------------------------------------
Programador        |Data      |Motivo Alteracao
-------------------------------------------------------------------------
                   |DD/MM/YYYY|
-------------------------------------------------------------------------*/
static function SXGSize(cGRPSXG,nSize,nDec,cPicture)

    local bDummy
    
    local cSXGPict

    local nSXGDec
    local nSXGSize

    DEFAULT nSize:=0
    DEFAULT nDec:=0
    DEFAULT cPicture:=""
    
    bDummy:={||SXGSize(@cGRPSXG,@nSize,@nDec,@cPicture)}
    
/*
    if !Empty(cGRPSXG)

        SXG->(dbSetOrder(1)) //XG_GRUPO

        lFound:=SXG->(MsSeek(cGRPSXG,.F.))

        if (lFound)
            nSXGSize:=SXG->XG_SIZE
            cSXGPict:=SXG->XG_PICTURE
        else
            cSXGPict:=cPicture
            nSXGSize:=nSize
        endif

        nSXGDec:=nDec

    else

        nSXGSize:=nSize
        nSXGDec:=nDec
        cSXGPict:=cPicture

    endif
*/
    return({nSXGSize,nSXGDec,cSXGPict})

/*
    Programa:GpeWriter
    Funcao:X3Tamanho()
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:02/07/2012
    Descricao:Obtem o Tamanho do campo
    Sintaxe:Chamada padrao para programas em "RdMake".
    Uso:Generico
    Obs.:

-------------------------------------------------------------------------
            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.
-------------------------------------------------------------------------
Programador        |Data      |Motivo Alteracao
-------------------------------------------------------------------------
                   |DD/MM/YYYY|
-------------------------------------------------------------------------*/
static function X3Tamanho(cField)
    local bDummy
    local nTamanho
    bDummy:={||X3Tamanho(cField)}
    nTamanho:=GetSx3Cache(@cField,"X3_TAMANHO")
    DEFAULT nTamanho:=0
    return(nTamanho)

/*
    Programa:GpeWriter
    Funcao:X3Decimal()
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:02/07/2012
    Descricao:Obtem a Decimal do campo
    Sintaxe:Chamada padrao para programas em "RdMake".
    Uso:Generico
    Obs.:

-------------------------------------------------------------------------
            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.
-------------------------------------------------------------------------
Programador        |Data      |Motivo Alteracao
-------------------------------------------------------------------------
                   |DD/MM/YYYY|
-------------------------------------------------------------------------*/
static function X3Decimal(cField)
    local bDummy
    local nDecimal
    bDummy:={||X3Decimal(@cField)}
    nDecimal:=GetSx3Cache(@cField,"X3_DECIMAL")
    DEFAULT nDecimal:=0
    return(nDecimal)

/*
    Programa:GpeWriter
    Funcao:X3Picture
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:02/07/2012
    Descricao:Obtem a Picture do Campo
    Sintaxe:Chamada padrao para programas em "RdMake".
    Uso:Generico
    Obs.:

-------------------------------------------------------------------------
            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.
-------------------------------------------------------------------------
Programador        |Data      |Motivo Alteracao
-------------------------------------------------------------------------
                   |DD/MM/YYYY|
-------------------------------------------------------------------------*/
static function X3Picture(cField)
    local bDummy
    local cPicture
    bDummy:={||X3Picture(cField)}
    cPicture:=GetSx3Cache(@cField,"X3_PICTURE")
    DEFAULT cPicture:=""
    cPicture:=AllTrim(cPicture)
    return(cPicture)

/*
    Programa:GpeWriter
    Funcao:CurDrive()
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:02/07/2012
    Descricao:Retorna o Driver Drive para gravacao dos arquivos
    Sintaxe:Chamada padrao para programas em "RdMake".
    Uso:Generico
    Obs.:

-------------------------------------------------------------------------
            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.
-------------------------------------------------------------------------
Programador        |Data      |Motivo Alteracao
-------------------------------------------------------------------------
                   |DD/MM/YYYY|
-------------------------------------------------------------------------*/
static function CurDrive()
    local cDriver
    local cTempPath
    cTempPath:=GetTempPath(.T.)
    SplitPath(cTempPath,@cDriver)
    return(cDriver)
    
/*
    Programa:GpeWriter
    Funcao:SetDepende()
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:02/07/2012
    Descricao:Seta as variaveis para impressao de dependentes
    Sintaxe:Chamada padrao para programas em "RdMake".
    Uso:Generico
    Obs.:

-------------------------------------------------------------------------
            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.
-------------------------------------------------------------------------
Programador        |Data      |Motivo Alteracao
-------------------------------------------------------------------------
                   |DD/MM/YYYY|
-------------------------------------------------------------------------*/
static Procedure SetDepende()
    lDepende:=(&("MV_PAR26")==1)
    nDepende:=&("MV_PAR27")
    return
