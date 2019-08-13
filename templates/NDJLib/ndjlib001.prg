#include "totvs.ch"
#include "topconn.ch"
#include "tbiconn.ch"

Static __aReadVar:={}
Static __cMbrRstFilter
Static __cCRLF:=CRLF

Static oNDJLIB001
Static oNDJLIB029:=u_DJLIB029()

// --------------------------------------------------------------------------------------------------------
// Obtem o Caractere de PONTO E VIRGULA
#IFNDEF PONTO_E_VIRGULA
    #DEFINE PONTO_E_VIRGULA CHR(59)
#ENDIF

CLASS NDJLIB001

    DATA cClassName

    METHOD NEW() CONSTRUCTOR
    METHOD ClassName()

    METHOD IsCpoVar(cField)
    METHOD ForceReadVar(cField,uCnt,lTrigger,lCheckSX3)
    METHOD NDJMV2Mail(cGetMv,cToken)
    METHOD IsInGetDados(uField,aLocalHeader,aLocalCols,nLocalN)
    METHOD NDJFromTo(cFromAlias,cToAlias,aFromTo)
    METHOD dbPack(cAlias,lShowHelp,lQuitProgram,lChkFile,lMa280Flock,cRddName,cRetSqlName)
    METHOD dbZap(cAlias,lShowHelp,lQuitProgram,lChkFile,lMa280Flock,lPack,cRddName,cRetSqlName,lSX2)
    METHOD __dbDelete(cAlias,lPack,cRddName,cRetSqlName)
    METHOD RegToArray(cAlias,nRecno)
    METHOD PutIncHrs(cAlias,lForceTable)
    METHOD XALTHRS(cAlias,cField,cXAltHrs,lChkChange)
    METHOD SetStackVar()
    METHOD GetStackVar(cReadVar)
    METHOD ClsStackVar(cReadVar,lForce)
    METHOD __FieldPut(cAlias,uField,uCntPut,lForceTable)
    METHOD __FieldGet(cAlias,cField,lForceTable,lGdChkCpoVar)
    METHOD DlgMemoEdit(bAction,cTitle,lModify,aButtons,oMemoEdit,cMemoEdit,oFont,aAdvSize,bAValid)
    METHOD GetAlias4Fields(cAlias,aFields)
    METHOD SetMemVar(cVar,uSetValue,lSetOwnerPrvt,lForceSetOwner,lRetLastValue,lInitPad,cLado,lPublic,cStack)
    METHOD GetMemVar(cVar,lInitPad,cLado)
    METHOD IsMemVar(cVar)
    METHOD GetCallStack(nStart)
    METHOD QryMaxCod(cAlias,cField,cWhere,lDeleted,lForceWhere,lChkFilial)
    METHOD ClearQuery(cQuery)
    METHOD ChgFilial()
    METHOD GetSetMbFilter(cExprFilTop)
    METHOD RetPictVal(nVal,lDecZero,nInt,nDec,lPictSepMil)
    METHOD GetTopSource(cTopServer,nTopPort,cTopAlias,cTitle)
    METHOD TopGetInfo(cType)
    METHOD TopGetString(cEnvServer,cIniFile,cTopString)
    METHOD DirMake(cMakeDir,nTimes,nSleep)
    METHOD BrwLegenda(cTitulo,cMensagem,aLegend,bAction,cMsgAction)
    METHOD BrwGetSLeg(cAlias,bGetColors,bGetLegend,cResName,lArrColors)
    METHOD BrwFiltLeg(cAlias,aColors,aLegend,cTitle,cMsg,cMsgAction,cVarName)
    METHOD MbrRstFilter(cAlias,cVarName)
    METHOD NDJEvalF3(cF3,lShowHelp,cException)
    METHOD RunInSrv(cCommandLine,lWaitRun,cPath)
    METHOD MemoToaPrn(cMemo,nBytes,lUseCrLf)
    METHOD StrToArray(cString,cConcat,bAddParser)
    METHOD _StrTokArr(cStr,cToken)
    METHOD StrDelChr(cStrDelChr,aChrDelStr)
    METHOD _GetMvPar(cEmp,cFil,uMvPar,uDefault,lReset)
    METHOD _PutMvPar(cEmp,cFil,uMvPar,uMvCntPut)
    METHOD EvalPrg(bExec,cEmp,cFil,cModName,cFunName)
    METHOD DesvPad(aValores,lPolarizado)
    METHOD FileToArr(cFile)
    METHOD SXGSize(cGRPSXG,nSize,nDec,cPicture)
    METHOD X3Tipo(cField)
    METHOD X3Tamanho(cField)
    METHOD X3Decimal(cField)
    METHOD X3Picture(cField)
    METHOD FolderSetOption(nTarget,nSource,aObjFolder,aGdObjects,nActFolder,lVldFolder)
    METHOD GDToExcel(aHeader,aCols,cWorkSheet,cTable,lTotalize,lPicture)
    METHOD dbQuery(adbQuery,cQuery,cAlias,lChgQuery,aDBMSConn,aSetField)
    METHOD dbQueryClear(adbQuery)
    METHOD ProcRedefine(oProcess,oFont,nLeft,nWidth,nCTLFLeft,lODlgF,lODlgW)
    METHOD GDCheckKey(aCpo,nModelo,aNoEmpty,cMsgAviso,lShowAviso)
    METHOD pt_Default(xVar,xDefault)
    METHOD pt_Normalize(cVal,cField,cSide,cPDValue)
    METHOD xGetIKValue(cAlias,cIKValue,cToken)
    METHOD xGetOrder(cAlias,cIKValue)
    METHOD GetToken(cTokenStr)
    METHOD X3VldFields(aFields,aData,bX3ErrorVld,lVldEmpty,lInitPad)

ENDCLASS

User Function DJLIB001()
    DEFAULT oNDJLIB001:=NDJLIB001():New()
RETURN(oNDJLIB001)

METHOD NEW() CLASS NDJLIB001
    self:ClassName()
RETURN(self)

METHOD ClassName() CLASS NDJLIB001
    self:cClassName:="NDJLIB001"
RETURN(self:cClassName)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:IsCpoVar
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:20/11/2010
        Descricao:Verificar se a Variavel de Memoria Ativa corresponde ao campo passado por parametro
        Sintaxe:StaticCall(NDJLIB001,IsCpoVar,cField)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD IsCpoVar(cField) CLASS NDJLIB001
RETURN(IsCpoVar(@cField))
STATIC FUNCTION IsCpoVar(cField)

    Local cVar

    IF (.NOT.(Type("__READVAR")=="C"))
        Private __READVAR:=""
    EndIF

    cVar:=Upper(AllTrim(ReadVar()))
    IF ("M->"$cVar)
        cVar:=SubStr(cVar,4)
    EndIF

    DEFAULT cField:=""
    cField:=Upper(AllTrim(cField))

RETURN((cVar==cField))

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:ForceReadVar
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:20/11/2010
        Descricao:Forca a Validacao de um Determinado Campo
        Sintaxe:StaticCall(NDJLIB001,ForceReadVar,cField,uCnt,lTrigger,lCheckSX3)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD ForceReadVar(cField,uCnt,lTrigger,lCheckSX3) CLASS NDJLIB001
RETURN(ForceReadVar(@cField,@uCnt,@lTrigger,@lCheckSX3))
STATIC FUNCTION ForceReadVar(cField,uCnt,lTrigger,lCheckSX3)

    Local aArea:=GetArea()
    Local cReadVar

    Local lInGetD:=.F.
    Local lReadVar:=(Type("__ReadVar")=="C")
    Local lFieldOk:=.T.

    Local nTrigger
    Local nTriggerN

    IF (lReadVar)
        cReadVar:=__ReadVar
    Else
        Private __ReadVar
    EndIF

    BEGIN SEQUENCE

        IF Empty(cField)
            BREAK
        EndIF

        cField:=Upper(AllTrim(cField))

        IF ("M->"$cField)
            cField:=StrTran(cField,"M->","")
        EndIF

        __ReadVar:=("M->"+cField)

        lInGetD:=IsInGetDados(cField)
        IF (lInGetD)
            DEFAULT uCnt:=GdFieldGet(cField)
        ElseIF IsMemVar(cField)
            DEFAULT uCnt:=GetMemVar(cField)
        EndIF

        &(__ReadVar):=uCnt

        dbSelectArea("SX3")

        DEFAULT lTrigger:=.T.
        IF ((lTrigger).and.ExistTrigger(cField))
            IF (lInGetD)
                nTrigger:=2
                nTriggerN:=n
            Else
                nTrigger:=1
            EndIF
            RunTrigger(nTrigger,nTriggerN,NIL,NIL,cField)
        EndIF

        DEFAULT lCheckSX3:=.T.
        IF (lCheckSX3)
            lFieldOk:=CheckSX3(cField,&(ReadVar()))
        EndIF

    END SEQUENCE

    IF (lReadVar)
        __ReadVar:=cReadVar
    EndIF

    RestArea(aArea)

RETURN(lFieldOk)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:NDJMV2Mail
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:14/07/2010
        Descricao:Retorna Array com Lista de e-mail de Usuarios de Parametros
        Sintaxe:StaticCall(NDJLIB001,NDJMV2Mail,cGetMv,cToken)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD NDJMV2Mail(cGetMv,cToken) CLASS NDJLIB001
RETURN(NDJMV2Mail(@cGetMv,@cToken))
STATIC FUNCTION NDJMV2Mail(cGetMv,cToken)

    Local aListMail:={}

    DEFAULT cGetMv:=""
    DEFAULT cToken:=NDJ_TOKEN_MAILD

    aListMail:=StrTokArr2(Alltrim(GetNewPar(cGetMv,"")),cToken)

    aEval(aListMail,{|cMail,nElem|aListMail[nElem]:=StaticCall(NDJLIB014,WF4Mail,cMail)})

RETURN(aListMail)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:IsInGetDados
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:21/11/2010
        Descricao:Verifica se Esta executando a partir da GetDados
        Sintaxe:StaticCall(NDJLIB001,IsInGetDados,...)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD IsInGetDados(uField,aLocalHeader,aLocalCols,nLocalN) CLASS NDJLIB001
RETURN(IsInGetDados(@uField,@aLocalHeader,@aLocalCols,@nLocalN))
STATIC FUNCTION IsInGetDados(uField,aLocalHeader,aLocalCols,nLocalN)

    Local aFields

    Local cField

    Local lLocalCols:=(ValType(aLocalCols)=="A")
    Local lLocalHeader:=(ValType(aLocalHeader)=="A")
    Local lIsInGetDados:=.F.

    Local nField
    Local nFields
    Local nFieldPos

    BEGIN SEQUENCE

        lIsInGetDados:=lLocalHeader
        IF (lIsInGetDados)
            Private aHeader:=aLocalHeader
        Else
            lIsInGetDados:=(Type("aHeader")=="A")
            IF (.NOT.(lIsInGetDados))
                BREAK
            EndIF
        EndIF
        lIsInGetDados:=(Len(aHeader)>0)
        IF (.NOT.(lIsInGetDados))
            BREAK
        EndIF

        IF (lLocalCols )
            Private aCols:=aLocalCols
            lIsInGetDados:=.T.
        Else
            lIsInGetDados:=(Type("aCols")=="A")
            IF (.NOT.(lIsInGetDados))
                BREAK
            EndIF
        EndIF
        lIsInGetDados:=(Len(aCols)>0)
        IF (.NOT.(lIsInGetDados))
            BREAK
        EndIF

        IF (.NOT.(lLocalCols))
            lIsInGetDados:=(Type("N")=="N")
            IF (.NOT.(lIsInGetDados))
                BREAK
            EndIF
        ElseIF (ValType(nLocalN)=="N")
            Private n:=nLocalN
        EndIF

        lIsInGetDados:=((Type("N")=="N").and.(n>=1).and.(n<=Len(aCols)))
        IF (.NOT.(lIsInGetDados))
            BREAK
        EndIF

        lIsInGetDados:=(Len(aCols[1])>=Len(aHeader))
        IF (.NOT.(lIsInGetDados))
            BREAK
        EndIF

        IF (ValType(uField)=="A")
            aFields:=uField
        Else
            aFields:={uField}
        EndIF

        lIsInGetDados:=(ValType(aFields)=="A")
        IF (.NOT.(lIsInGetDados))
            BREAK
        EndIF

        nFields:=Len(aFields)
        For nField:=1 To nFields
            cField:=aFields[nField]
            nFieldPos:=GdFieldPos(cField)
            lIsInGetDados:=((nFieldPos>0).and.(Len(aCols[n])>=nFieldPos))
            IF (.NOT.(lIsInGetDados))
                BREAK
            EndIF
        Next nField

    END SEQUENCE

RETURN(lIsInGetDados)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:NDJFromTo
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:21/11/2010
        Descricao:De para NDJ
        Sintaxe:StaticCall(NDJLIB001,NDJFromTo,...)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD NDJFromTo(cFromAlias,cToAlias,aFromTo) CLASS NDJLIB001
RETURN(NDJFromTo(@cFromAlias,@cToAlias,@aFromTo))
STATIC FUNCTION NDJFromTo(cFromAlias,cToAlias,aFromTo)

    Local aArea:=GetArea()

    Local cKeyAlias:=(cFromAlias+"|"+cToAlias)

    Local lIsLocked:=IsLocked(cToAlias)
    Local lLock:=.F.
    Local lChangeKey:=.F.

    Local nField:=0
    Local nFields:=0
    Local nFieldPut:=0
    Local nFieldGet:=0
    Local nPosAlias:=0

    Local uCntGetPut:=NIL

    Static __aFromTo:={}
    Static __cLastKey:="__cLastKey__"

    BEGIN SEQUENCE

        lChangeKey:=.NOT.(__cLastKey==cEmpAnt)
        IF (.NOT.(lChangeKey))
            nPosAlias:=aScan(__aFromTo,{|aFromTo|(aFromTo[1]==cKeyAlias)})
        EndIF

        IF (;
                Empty(__aFromTo);
                .or.;
                (lChangeKey);
                .or.;
                (.NOT.(nPosAlias>0));
           )

            IF (lChangeKey)
                __cLastKey:=cEmpAnt
                aSize(__aFromTo,0)
            EndIF

            aAdd(__aFromTo,{cKeyAlias,{}})
            nPosAlias:=Len(__aFromTo)

            nFields:=Len(aFromTo)
            For nField:=1 To nFields
                nFieldGet:=(cFromAlias)->(FieldPos(aFromTo[nField][1]))
                nFieldPut:=(cToAlias)->(FieldPos(aFromTo[nField][2]))
                aAdd(__aFromTo[nPosAlias][2],{nFieldGet,nFieldPut})
            Next nField

        EndIF

        IF (.NOT.(lIsLocked))
            lLock:=(cToAlias)->(RecLock(cToAlias,.F.))
        Else
            lLock:=lIsLocked
        EndIF

        IF (lLock)
            aFields:=__aFromTo[nPosAlias][2]
            nFields:=Len(aFields)
            For nField:=1 To nFields
                nFieldGet:=aFields[nField][1]
                IF ((nFieldGet>0))
                    uCntGetPut:=(cFromAlias)->(FieldGet(nFieldGet))
                    nFieldPut:=aFields[nField][2]
                    IF (nFieldPut>0)
                        (cToAlias)->(FieldPut(nFieldPut,uCntGetPut))
                    EndIF
                EndIF
            Next nField
            IF (.NOT.(lIsLocked))
                (cToAlias)->(MsUnLock())
            EndIF
        EndIF

    END SEQUENCE

    RestArea(aArea)

RETURN(NIL)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:dbPack
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:27/11/2010
        Descricao:Pack dos Registros
        Sintaxe:StaticCall(NDJLIB001,dbPack,<cAlias>,...)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD dbPack(cAlias,lShowHelp,lQuitProgram,lChkFile,lMa280Flock,cRddName,cRetSqlName) CLASS NDJLIB001
RETURN(dbPack(@cAlias,@lShowHelp,@lQuitProgram,@lChkFile,@lMa280Flock,@cRddName,@cRetSqlName))
STATIC FUNCTION dbPack(cAlias,lShowHelp,lQuitProgram,lChkFile,lMa280Flock,cRddName,cRetSqlName)
    DEFAULT cAlias:=Alias()
    DEFAULT lShowHelp:=.F.
    DEFAULT lQuitProgram:=.F.
    DEFAULT lChkFile:=.F.
    DEFAULT lMa280Flock:=.F.
    DEFAULT cRddName:=(cAlias)->(RddName())
RETURN(dbZap(@cAlias,@lShowHelp,@lQuitProgram,@lChkFile,@lMa280Flock,.T.,@cRddName,@cRetSqlName))

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:dbZap
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:27/11/2010
        Descricao:Deletar todos os Registros de uma Determinada Tabela
        Sintaxe:StaticCall(NDJLIB001,dbZap,<cAlias>,...)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD dbZap(cAlias,lShowHelp,lQuitProgram,lChkFile,lMa280Flock,lPack,cRddName,cRetSqlName,lSX2) CLASS NDJLIB001
RETURN(dbZap(@cAlias,@lShowHelp,@lQuitProgram,@lChkFile,@lMa280Flock,@lPack,@cRddName,@cRetSqlName,@lSX2))
STATIC FUNCTION dbZap(cAlias,lShowHelp,lQuitProgram,lChkFile,lMa280Flock,lPack,cRddName,cRetSqlName,lSX2)

    Local aArea:=GetArea()
    Local aAreaSX2:={}
    Local lLocked:=.F.

    DEFAULT cAlias:=Alias()
    DEFAULT lShowHelp:=.F.
    DEFAULT lQuitProgram:=.F.
    DEFAULT lChkFile:=.F.
    DEFAULT lMa280Flock:=.F.
    DEFAULT lPack:=.F.
    DEFAULT cRddName:=(cAlias)->(RddName())
    DEFAULT lSX2:=.T.

    IF (lSX2)
        IF (lSX2:=(Select("SX2")>0))
            aAreaSX2:=SX2->(GetArea())
            lSX2:=SX2->(MsSeek(cAlias))
        EndIF
    EndIF

    IF (lMa280Flock)
        (cAlias)->(dbCloseArea())
    EndIF

    IF (lLocked:=IF(lMa280Flock,(cAlias)->(Ma280Flock(cAlias,lShowHelp,lQuitProgram)),.T.))
        IF (lSX2)
            (cAlias)->(RetIndex(cAlias))
        EndIF
        __dbDelete(@cAlias,@lPack,@cRddName,@cRetSqlName)
        IF (lSX2)
            IF SX2->(RecLock("SX2",.F.,.T.))
                SX2->X2_DELET:=0
                SX2->(MsUnlock())
            EndIF
        EndIF
    EndIF

    IF (lLocked)
        IF (lMa280Flock)
            (cAlias)->(dbCloseArea())
        EndIF
        IF (;
                (lSX2);
                .and.;
                (lChkFile);
           )
            ChkFile(cAlias,.F.)
        EndIF
    EndIF

    IF (lSX2)
        RestArea(aAreaSX2)
    EndIF

    RestArea(aArea)

RETURN(NIL)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:__dbDelete
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:08/11/2005
        Descricao:Deletar todos os Registros de uma Determinada Tabela
        Sintaxe:StaticCall(NDJLIB001,__dbDelete,<cAlias>,...)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD __dbDelete(cAlias,lPack,cRddName,cRetSqlName) CLASS NDJLIB001
RETURN(__dbDelete(@cAlias,@lPack,@cRddName,@cRetSqlName))
STATIC FUNCTION __dbDelete(cAlias,lPack,cRddName,cRetSqlName)
    Local cQuery
    Local cNextAlias

    Local nMinRecno
    Local nMaxRecno

    Local oException

    TRYEXCEPTION

        DEFAULT cAlias:=Alias()
        DEFAULT lPack:=.F.
        DEFAULT cRddName:=(cAlias)->(RddName())

        IF (.NOT.(cRddName=="TOPCONN"))

            IF (lPack)
                (cAlias)->(__dbPack())
            Else
                (cAlias)->(__dbZap())
            EndIF

            BREAK

        EndIF

        IF (TCSrvType()=="AS/400")

            IF (lPack)
                (cAlias)->(__dbPack())
            Else
                (cAlias)->(__dbZap())
            EndIF

            BREAK

        EndIF

        DEFAULT cRetSqlName:=InitSqlName(cAlias)

        IF Empty(cRetSqlName)
            BREAK
        EndIF

        cQuery:="SELECT"+__cCRLF
        cQuery+="    MIN(R_E_C_N_O_)MINRECNO,"+__cCRLF
        cQuery+="    MAX(R_E_C_N_O_)MAXRECNO"+__cCRLF
        cQuery+="FROM"+__cCRLF
        cQuery+="    "+cRetSqlName+__cCRLF

        cNextAlias:=GetNextAlias()

        TCQUERY (cQuery)ALIAS (cNextAlias)NEW

        TcSetField(cNextAlias,"MINRECNO","N",18,0)
        TcSetField(cNextAlias,"MAXRECNO","N",18,0)

        nMinRecno:=(cNextAlias)->MINRECNO
        nMaxRecno:=(cNextAlias)->MAXRECNO

        (cNextAlias)->(dbCloseArea())

        dbSelectArea(cAlias)

        While (nMinRecno<=nMaxRecno)
            cQuery:="DELETE FROM"+__cCRLF
            cQuery+="    "+cRetSqlName+__cCRLF
            cQuery+="WHERE"+__cCRLF
            cQuery+="    "+cRetSqlName+".R_E_C_N_O_>="+AllTrim(Str(nMinRecno,18,0))+__cCRLF
            cQuery+="AND"+__cCRLF
            cQuery+="    "+cRetSqlName+".R_E_C_N_O_<="+AllTrim(Str(nMinRecno+=1024,18,0))+__cCRLF
            IF (lPack)
                cQuery+="AND"+__cCRLF
                cQuery+="    "+cRetSqlName+".D_E_L_E_T_ ='*'"+__cCRLF
            EndIF
            TCSqlExec(cQuery)
            (cAlias)->(dbGoTop())
        End While

    CATCHEXCEPTION USING oException

        ConOut(CaptureError())

    ENDEXCEPTION

RETURN(NIL)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:RegToArray
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:07/12/2010
        Descricao:Carregar Valores de um Determinado Registro em Memoria
        Sintaxe:StaticCall(NDJLIB001,RegToArray,cAlias,nRecno)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD RegToArray(cAlias,nRecno) CLASS NDJLIB001
RETURN(RegToArray(@cAlias,@nRecno))
STATIC FUNCTION RegToArray(cAlias,nRecno)

    Local aValues:={}
    Local adbStruct

    Local nField
    Local nFields

    DEFAULT cAlias:=Alias()
    DEFAULT nRecno:=(cAlias)->(Recno())

    adbStruct:=(cAlias)->(dbStruct())

    (cAlias)->(MsGoto(nRecno))

    nFields:=Len(adbStruct)
    aValues:=Array(nFields)

    For nField:=1 To nFields
        aValues[nField]:=(cAlias)->(FieldGet(nField))
    Next nField

RETURN(aValues )

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:PutIncHrs
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:08/12/2010
        Descricao:Gravar o Campo IncHrs
        Sintaxe:StaticCall(NDJLIB001,PutIncHrs,cAlias)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD PutIncHrs(cAlias,lForceTable) CLASS NDJLIB001
RETURN(PutIncHrs(@cAlias,@lForceTable))
STATIC FUNCTION PutIncHrs(cAlias,lForceTable)

    Local cTime:=Time()
    Local cFldIniHrs
    Local cPrefixCpo

    Local oException

    TRYEXCEPTION

        IF Empty(cAlias)
            BREAK
        EndIF

        cPrefixCpo:=(PrefixoCpo(cAlias)+"_")
        cFldIniHrs:=(cPrefixCpo+"XINCHRS")

        __FieldPut(cAlias,cFldIniHrs,cTime,lForceTable)

    CATCHEXCEPTION USING oException

        IF (ValType(oException)=="O")
            ConOut(oException:Description,oException:ErrorStack)
        EndIF

    ENDEXCEPTION

RETURN(cTime)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:XALTHRS
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:10/11/2010
        Descricao:Gravar a Data da Alteracao da Informacao
        Sintaxe:StaticCall(NDJLIB001,XALTHRS)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD XALTHRS(cAlias,cField,cXAltHrs,lChkChange) CLASS NDJLIB001
RETURN(XALTHRS(@cAlias,@cField,@cXAltHrs,@lChkChange))
STATIC FUNCTION XALTHRS(cAlias,cField,cXAltHrs,lChkChange)

    Local cReadVar

    Local lMemVar
    Local lGetDados

    Local nFieldPos

    Local uReadVar
    Local uCntVar

    Local oException

    TRYEXCEPTION

        IF IsInCallStack("MSExecAuto")
            BREAK
        EndIF

        cReadVar:=ReadVar()

        IF Empty(cReadVar)
            BREAK
        EndIF

        DEFAULT cField:=SubStr(cReadVar,4)
        DEFAULT lChkChange:=.T.

        IF Empty(cField)
            BREAK
        EndIF

        DEFAULT cAlias:=AliasCpo(cField)

        IF (.NOT.(cAlias==PosAlias("SX2",cAlias,NIL,"X2_CHAVE",1,.F.)))
            BREAK
        EndIF

        nFieldPos:=(cAlias)->(FieldPos(cField))
        IF (.NOT.(nFieldPos>0))
            BREAK
        EndIF

        IF (lChkChange)

            TRYEXCEPTION
                uReadVar:=&(ReadVar())
            CATCHEXCEPTION
                uReadVar:=NIL
            ENDEXCEPTION

            uCntVar:=GetStackVar(@cReadVar)

        EndIF

        DEFAULT cXAltHrs:=(PrefixoCpo(cAlias)+"_XALTHRS")
        IF ((cAlias)->(nFieldPos:=FieldPos(cXAltHrs))==0)
            cXAltHrs:=(PrefixoCpo(cAlias)+"_XALTHR")
            IF ((cAlias)->(nFieldPos:=FieldPos(cXAltHrs))==0)
                cXAltHrs:=(PrefixoCpo(cAlias)+"_XALHRS")
            EndIF
        EndIF

        IF (;
                .NOT.(lChkChange);
                .or.;
                .NOT.oNDJLIB029:Compare(@uCntVar,@uReadVar);
           )
            lMemVar:=IsMemVar(cXAltHrs)
            lGetDados:=IsInGetDados(cXAltHrs)
            IF ((lMemVar).and.(lGetDados))
                SetMemVar(cXAltHrs,Time())
                GdFieldPut(cXAltHrs,Time())
            ElseIF (lGetDados)
                GdFieldPut(cXAltHrs,Time())
            ElseIF (lMemVar)
                SetMemVar(cXAltHrs,Time())
            ElseIF ((cAlias)->(nFieldPos:=FieldPos(cXAltHrs))>0)
                IF ((cAlias)->(.NOT.(Eof()).and.RecLock(cAlias,.F.)))
                    (cAlias)->(FieldPut(nFieldPos,Time()))
                    (cAlias)->(MsUnLock())
                EndIF
            EndIF
        EndIF

    CATCHEXCEPTION USING oException

        IF (ValType(oException)=="O")
            ContOut(oException:Description,oException:ErrorStack)
        EndIF

    ENDEXCEPTION

RETURN(.T.)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:SetStackVar
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:10/11/2010
        Descricao:Armazena Valores na Pilha
        Sintaxe:StaticCall(NDJLIB001,SetStackVar)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD SetStackVar() CLASS NDJLIB001
RETURN(SetStackVar())
STATIC FUNCTION SetStackVar()

    Local cReadVar:=ReadVar()

    Local nReadVar:=0

    nReadVar:=aScan(__aReadVar,{|aElem|aElem[1]==cReadVar})
    IF (.NOT.(nReadVar>0))
        aAdd(__aReadVar,Array(2))
        nReadVar:=Len(__aReadVar)
        __aReadVar[nReadVar][1]:=cReadVar
    EndIF

    TRYEXCEPTION
        __aReadVar[nReadVar][2]:=&(cReadVar)
    CATCHEXCEPTION
        __aReadVar[nReadVar][2]:=NIL
    ENDEXCEPTION

RETURN(.T.)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:GetStackVar
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:10/11/2010
        Descricao:Obtem valor da Pilha
        Sintaxe:StaticCall(NDJLIB001,GetStackVar)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD GetStackVar(cReadVar) CLASS NDJLIB001
RETURN(GetStackVar(@cReadVar))
STATIC FUNCTION GetStackVar(cReadVar)

    Local nReadVar

    Local uLastVal

    DEFAULT cReadVar:=ReadVar()

    nReadVar:=aScan(__aReadVar,{|aElem|aElem[1]==cReadVar})
    IF (nReadVar>0)
        uLastVal:=__aReadVar[nReadVar][2]
    EndIF

RETURN(uLastVal)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:ClsStackVar
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:10/11/2010
        Descricao:Limpa a Pilha
        Sintaxe:StaticCall(NDJLIB001,ClsStackVar)
        Uso:X3_VLDUSER
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD ClsStackVar(cReadVar,lForce) CLASS NDJLIB001
RETURN(ClsStackVar(@cReadVar,@lForce))
STATIC FUNCTION ClsStackVar(cReadVar,lForce)

    Local nReadVar

    DEFAULT cReadVar:=ReadVar()
    DEFAULT lForce:=.T.

    IF (lForce)
        aSize(__aReadVar,0)
    Else
        nReadVar:=aScan(__aReadVar,{|aElem|aElem[1]==cReadVar})
        IF (nReadVar>0)
            aDel(__aReadVar,nReadVar)
            aSize(__aReadVar,(Len(__aReadVar)-1))
        EndIF
    EndIF

RETURN(NIL)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:__FieldPut
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:08/12/2010
        Descricao:Gravar Conteudo em Determinado Campo de Uma Tabela
        Sintaxe:StaticCall(NDJLIB001,__FieldPut,cAlias,uField,uCntPut,lForceTable)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD __FieldPut(cAlias,uField,uCntPut,lForceTable) CLASS NDJLIB001
RETURN(__FieldPut(@cAlias,@uField,@uCntPut,@lForceTable))
STATIC FUNCTION __FieldPut(cAlias,uField,uCntPut,lForceTable)

    Local cField

    Local lLock
    Local lFieldN:=(ValType(uField)=="N")
    Local lIsLocked

    Local nFieldPos

    Local oException

    TRYEXCEPTION

        IF Empty(cAlias)
            BREAK
        EndIF

        DEFAULT lForceTable:=.F.

        lForceTable:=(lForceTable.or.lFieldN)

        IF (.NOT.(lFieldN))
            cField:=uField
        EndIF

        IF (.NOT.(lForceTable))

            IF IsInGetDados(cField)
                GdFieldPut(cField,uCntPut)
                BREAK
            EndIF

            IF IsMemVar(cField)
                SetMemVar(cField,uCntPut)
                BREAK
            EndIF

        EndIF

        IF (lFieldN)
            nFieldPos:=uField
        Else
            nFieldPos:=(cAlias)->(FieldPos(cField))
        EndIF

        IF (.NOT.(nFieldPos>0))
            BREAK
        EndIF

        lLock:=(lIsLocked:=(cAlias)->(IsLocked(cAlias,Recno())))

        IF (.NOT.(lLock).and.(cAlias)->(Eof().or.Bof()))
            BREAK
        EndIF

        IF (.NOT.(lLock))
            lLock:=(cAlias)->(RecLock(cAlias,.F.))
            IF (.NOT.(lLock))
                BREAK
            EndIF
        EndIF

        (cAlias)->(FieldPut(nFieldPos,uCntPut))
        IF (.NOT.(lIsLocked))
            (cAlias)->(MsUnLock())
        EndIF

    CATCHEXCEPTION USING oException

        IF (ValType(oException)=="O")
            ConOut(oException:Description,oException:ErrorStack)
        EndIF

    ENDEXCEPTION

RETURN(uCntPut)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:__FieldGet
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:08/12/2010
        Descricao:Obter o Conteudo a partir de Determinado Campo uma Tabela
        Sintaxe:StaticCall(NDJLIB001,__FieldGet,cAlias,cField,lForceTable,lGdChkCpoVar)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD __FieldGet(cAlias,cField,lForceTable,lGdChkCpoVar) CLASS NDJLIB001
RETURN(__FieldGet(@cAlias,@cField,@lForceTable,@lGdChkCpoVar))
STATIC FUNCTION __FieldGet(cAlias,cField,lForceTable,lGdChkCpoVar)

    Local nFieldPos

    Local oException

    Local uCntGet

    TRYEXCEPTION

        IF Empty(cAlias)
            BREAK
        EndIF

        DEFAULT lForceTable:=.F.

        IF (.NOT.(lForceTable))

            IF IsInGetDados(cField)
                DEFAULT lGdChkCpoVar:=.T.
                IF (lGdChkCpoVar)
                    IF (.NOT.(IsCpoVar(cField)))
                        uCntGet:=GdFieldGet(cField)
                        BREAK
                    EndIF
                Else
                    uCntGet:=GdFieldGet(cField)
                    BREAK
                EndIF
            EndIF

            IF IsMemVar(cField)
                uCntGet:=GetMemVar(cField)
                BREAK
            EndIF

        EndIF

        nFieldPos:=(cAlias)->(FieldPos(cField))
        IF (.NOT.(nFieldPos>0))
            BREAK
        EndIF

        uCntGet:=(cAlias)->(FieldGet(nFieldPos))

    CATCHEXCEPTION USING oException

        IF (ValType(oException)=="O")
            ConOut(oException:Description,oException:ErrorStack)
        EndIF

    ENDEXCEPTION

RETURN(uCntGet)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:DlgMemoEdit
        Autor:Marinaldo de Jesus
        Data:11/12/2010
        Descricao:Dialog com Campo Memo para uso diverso
        Sintaxe:StaticCall(NDJLIB001,DlgMemoEdit,...)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD DlgMemoEdit(;
                                bAction,;//01 ->Acao a ser executada se tudo Ok
                                cTitle,;//02 ->Array com Botoes para Opcao de Edicao dos Campos Memo
                                lModify,;//03 ->Se podera modificar o Conteudo do campo Memo
                                aButtons,;//04 ->Array com Botoes para Opcao de Edicao dos Campos Memo
                                oMemoEdit,;//05 ->Objeto MemoEdit
                                cMemoEdit,;//06 ->Conteudo do Campo Memo
                                oFont,;//07 ->Objeto Font
                                aAdvSize,;//08 ->Coordenadas do Dialogo
                                bAValid;//09 ->Pre-Validar para execucao de bAction
                  )  CLASS NDJLIB001
RETURN(DlgMemoEdit(;
                    @bAction,;//01 ->Acao a ser executada se tudo Ok
                    @cTitle,;//02 ->Array com Botoes para Opcao de Edicao dos Campos Memo
                    @lModify,;//03 ->Se podera modificar o Conteudo do campo Memo
                    @aButtons,;//04 ->Array com Botoes para Opcao de Edicao dos Campos Memo
                    @oMemoEdit,;//05 ->Objeto MemoEdit
                    @cMemoEdit,;//06 ->Conteudo do Campo Memo
                    @oFont,;//07 ->Objeto Font
                    @aAdvSize,;//08 ->Coordenadas do Dialogo
                    @bAValid;//09 ->Pre-Validar para execucao de bAction
                  );
)
STATIC FUNCTION DlgMemoEdit(;
                                bAction,;//01 ->Acao a ser executada se tudo Ok
                                cTitle,;//02 ->Array com Botoes para Opcao de Edicao dos Campos Memo
                                lModify,;//03 ->Se podera modificar o Conteudo do campo Memo
                                aButtons,;//04 ->Array com Botoes para Opcao de Edicao dos Campos Memo
                                oMemoEdit,;//05 ->Objeto MemoEdit
                                cMemoEdit,;//06 ->Conteudo do Campo Memo
                                oFont,;//07 ->Objeto Font
                                aAdvSize,;//08 ->Coordenadas do Dialogo
                                bAValid;//09 ->Pre-Validar para execucao de bAction
                           )
Local aSvKeys
Local aInfoAdvSize
Local aObjSize
Local aObjCoords

Local bSet15
Local bSet24

Local cTitCompl
Local cSvMemoEdit

Local lConfOk

Local nColDesMem

Local oDlg

Begin Sequence

    DEFAULT lModify:=.T.

    cSvMemoEdit:=cMemoEdit

    DEFAULT aAdvSize:=MsAdvSize(.T.,.T.)
    aInfoAdvSize:={aAdvSize[1],aAdvSize[2],aAdvSize[3],aAdvSize[4],0,0}
    aObjCoords:={{0,0,.T.,.T.}}
    aObjSize:=MsObjSize(aInfoAdvSize,aObjCoords)

    aSvKeys:=GetKeys()

    bSet15:={||GetKeys(),lConfOk:=.T.,oDlg:End()}
    bSet24:={||GetKeys(),lConfOk:=.F.,oDlg:End()}

    IF (.NOT.(ValType(oFont)=="O"))
        DEFINE FONT oFont NAME "Arial" SIZE 0,-11
    EndIF
    IF (.NOT.(Type("cCadastro")=="C"))
        Private cCadastro:=""
    EndIF

    DEFAULT cTitle:=""
    IF (.NOT.Empty(cCadastro))
        cTitCompl:=cCadastro
        IF (.NOT.Empty(cTitle))
            cTitCompl+="-"
            cTitCompl+=cTitle
        EndIF
    Else
        cTitCompl:=cTitle
    EndIF

    DEFINE MSDIALOG oDlg TITLE OemToAnsi(cTitCompl) From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF GetWndDefault() STYLE DS_MODALFRAME STATUS PIXEL

        @ aObjSize[1][1],aObjSize[1][2] GET oMemoEdit VAR cMemoEdit MEMO OF oDlg SIZE (aObjSize[1][4]-aObjSize[1][2]),((aObjSize[1][3]-aObjSize[1][1])) FONT oFont PIXEL WHEN (.T.) DESIGN UPDATE

        oMemoEdit:lReadOnly:=.NOT.(lModify)
        oMemoEdit:EnableVScroll(.T.)
        oMemoEdit:EnableHScroll(.T.)

        oDlg:lEscClose:=.F. //Nao permite sair ao se pressionar a tecla ESC.

    ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(@oDlg,@bSet15,@bSet24,NIL,@aButtons) CENTERED
    RestKeys(aSvKeys,.T.)

    IF (lModify)
        IF (lConfOk) //<CTRL-O>
            DEFAULT bAValid:={||.T.}
             IF Eval(bAValid)
                DEFAULT bAction:={||.T.}
                Eval(bAction)
            EndIF
        ElseIF (.NOT.(lConfOk)) //<CTRL-X>
            IF (.NOT.(cSvMemoEdit==cMemoEdit))
                IF (.NOT.(MsgNoYes(OemToAnsi("Abandonar as Alteracoes?"),cTitCompl)))
                    DlgMemoEdit(;
                                    @bAction,;//01 ->Acao a ser executada se tudo Ok
                                    @cTitle,;//02 ->Array com Botoes para Opcao de Edicao dos Campos Memo
                                    @lModify,;//03 ->Se podera modificar o Conteudo do campo Memo
                                    @aButtons,;//04 ->Array com Botoes para Opcao de Edicao dos Campos Memo
                                    @oMemoEdit,;//05 ->Objeto MemoEdit
                                    @cMemoEdit,;//06 ->Conteudo do Campo Memo
                                    @oFont,;//07 ->Objeto Font
                                    @aAdvSize,;//08 ->Coordenadas do Dialogo
                                    @bAValid;//09 ->Pre-Validar para execucao de bAction
                               )
                EndIF
            EndIF
        EndIF
    EndIF

End Sequence

RETURN(cMemoEdit)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:GetAlias4Fields
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:14/12/2010
        Uso:Obtem o Alias a partir dos campos Fornecidos como Parametros
        Sintaxe:StaticCall(NDJLIB001,GetAlias4Fields,cAlias,aFields)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD GetAlias4Fields(cAlias,aFields) CLASS NDJLIB001
RETURN(GetAlias4Fields(@cAlias,@aFields))
STATIC FUNCTION GetAlias4Fields(cAlias,aFields)

    Local aAlias:={}

    Local lFoundAlias:=.F.

    Local nTo:=1
    Local nStep:=-1
    Local nArea:=0
    Local nAreas:=Val(GetPvProfString(GetEnvServer(),"MaxWorkAreas","1000",GetADV97()))

    Local nField
    Local nFields:=Len(aFields)
    Local nFieldPos
    Local nIsAlias:=0

    Local oException

    DEFAULT cAlias:=""

    TRYEXCEPTION

        IF (.NOT.(Empty(cAlias)))
            nArea:=Select(cAlias)
            IF (nArea>0)
                nAreas:=nArea
                nTo:=nArea
                nStep:=1
            EndIF
        EndIF

        For nArea:=nAreas To nTo Step nStep
            TRYEXCEPTION
                cAlias:=Alias(nArea)
            ENDEXCEPTION
            IF Empty(cAlias)
                Loop
            EndIF
            For nField:=1 To nFields
                nFieldPos:=(cAlias)->(FieldPos(aFields[nField]))
                IF (nFieldPos< 0)
                    nFieldPos+=1
                EndIF
                IF (nFieldPos>0)
                    ++nIsAlias
                    IF (aScan(aAlias,{|nTree|(nTree==nArea)})==0)
                        aAdd(aAlias,nArea)
                    EndIF
                EndIF
            Next nField
            IF (Len(aAlias)>0)
                Exit
            EndIF
        Next nArea

        lFoundAlias:=(nIsAlias>0)
        IF (lFoundAlias)
            cAlias:=Alias(aAlias[Len(aAlias)])
        Else
            cAlias:=""
        EndIF

    CATCHEXCEPTION USING oException

        cAlias:=""
        lFoundAlias:=.F.

        IF (ValType(oException)=="O")
            ConOut(oException:Description,oException:ErrorStack)
        EndIF

    ENDEXCEPTION

RETURN(lFoundAlias)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:SetMemVar
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:26/12/2010
        Uso:Setar Variavel de Memoria
        Sintaxe:StaticCall(NDJLIB001,SetMemVar,cVar,uSetValue,lSetOwnerPrvt,lForceSetOwner,lRetLastValue,lInitPad,cLado,lPublic,cStack)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD SetMemVar(cVar,uSetValue,lSetOwnerPrvt,lForceSetOwner,lRetLastValue,lInitPad,cLado,lPublic,cStack) CLASS NDJLIB001
RETURN(SetMemVar(@cVar,@uSetValue,@lSetOwnerPrvt,@lForceSetOwner,@lRetLastValue,@lInitPad,@cLado,@lPublic,@cStack))
STATIC FUNCTION SetMemVar(cVar,uSetValue,lSetOwnerPrvt,lForceSetOwner,lRetLastValue,lInitPad,cLado,lPublic,cStack)

    Local cVarAux

    Local uRetValue

    Local oException

    DEFAULT cVar:="__Undefined__"
    DEFAULT lSetOwnerPrvt:=.F.
    DEFAULT lRetLastValue:=.F.
    DEFAULT lForceSetOwner:=.F.
    DEFAULT lPublic:=.F.

    TRYEXCEPTION

        cVar:=Upper(AllTrim(cVar))
        IF (.NOT.("M->"==SubStr(cVar,1,3)))
            cVarAux:=cVar
            cVar:=("M->"+cVar)
        Else
            cVarAux:=SubStr(cVar,4)
        EndIF

        IF (.NOT.(cVar==Upper("__Undefined__")))
            IF (.NOT.(GetSx3Cache(cVarAux,"X3_CAMPO")==NIL))
                DEFAULT uSetValue:=GetValType(GetSx3Cache(@cVarAux,"X3_TIPO"),GetSx3Cache(@cVarAux,"X3_TAMANHO"))
            EndIF
        EndIF

        IF (lRetLastValue)
            uRetValue:=GetMemVar(@cVarAux,@lInitPad,@cLado)
            DEFAULT uRetValue:=uSetValue
        Else
            uRetValue:=uSetValue
        EndIF

        IF (.NOT.(IsMemVar(@cVar)).or.(lForceSetOwner))
            IF (lSetOwnerPrvt)
                IF (lPublic)
                    StaticCall(NDJLIB038,SetPublic,@cVarAux,@uSetValue,NIL,NIL,@lForceSetOwner,NIL,@cStack)
                Else
                    IF (.NOT.(Empty(cStack)))
                        _SetNamedPrvt(cVarAux,@uSetValue,@cStack)
                    Else
                        _SetOwnerPrvt(@cVarAux,@uSetValue)
                    EndIF
                EndIF
            EndIF
        Else
            &(cVar):=uSetValue
        EndIF

        if (FindFunction("FWFldPut"))
            FWFldPut(cVar,uSetValue)
        endif
        
    CATCHEXCEPTION USING oException

        uSetValue:=NIL

    ENDEXCEPTION

RETURN(uRetValue)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:GetMemVar
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:26/12/2010
        Uso:Obter Variavel de Memoria
        Sintaxe:StaticCall(NDJLIB001,GetMemVar,cVar,lInitPad,cLado)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD GetMemVar(cVar,lInitPad,cLado) CLASS NDJLIB001
RETURN(GetMemVar(@cVar,@lInitPad,@cLado))
STATIC FUNCTION GetMemVar(cVar,lInitPad,cLado)

    Local cVarAux
    Local uRetValue

    Local oException

    TRYEXCEPTION

        DEFAULT cVar:="__Undefined__"
        DEFAULT lInitPad:=.F.

        cVar:=Upper(AllTrim(cVar))
        IF (.NOT.("M->"==SubStr(cVar,1,3)))
            cVar:=("M->"+cVar)
        EndIF

        IF (IsMemVar(@cVar))
            uRetValue:=&(cVar)
            if (empty(uRetValue))
                if (FindFunction("FWFldGet"))
                    uRetValue:=FWFldGet(cVar)
                endif
            endif
        Else
            IF (.NOT.(cVar==Upper("__Undefined__")))
                cVarAux:=SubStr(cVar,4)
                if (FindFunction("FWFldGet"))
                    uRetValue:=FWFldGet(cVarAux)
                endif
                IF (empty(uRetValue).and.(.NOT.(GetSx3Cache(@cVarAux,"X3_CAMPO")==NIL)))
                    uRetValue:=CriaVar(@cVarAux,@lInitPad,@cLado,.F.)
                EndIF
            EndIF
        EndIF

    CATCHEXCEPTION USING oException

        uRetValue:=NIL

    ENDEXCEPTION

RETURN(uRetValue)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:IsMemVar
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:26/12/2010
        Uso:Verificar Variavel de Memoria
        Sintaxe:StaticCall(NDJLIB001,IsMemVar,cVar)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD IsMemVar(cVar) CLASS NDJLIB001
RETURN(IsMemVar(@cVar))
STATIC FUNCTION IsMemVar(cVar)

    Local cType
    Local cTypeVar
    Local lIsMemVar

    TRYEXCEPTION

        DEFAULT cVar:="__Undefined__"

        cVar:=Upper(AllTrim(cVar))
        IF (.NOT.("M->"==SubStr(cVar,1,3)))
            cVar:=("M->"+cVar)
        EndIF

        cType:=Type(cVar)
        cTypeVar:=GetSx3Cache(SubStr(cVar,4),"X3_TIPO")
        IF ((cTypeVar=="M").and.(cType=="C"))
            cTypeVar:="C"
        EndIF
        lIsMemVar:=IF(cTypeVar<>NIL,(cType==cTypeVar),(cType<>"U"))

    CATCHEXCEPTION USING oException

        lIsMemVar:=.F.

    ENDEXCEPTION

RETURN(lIsMemVar)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:GetCallStack
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:18/11/2010
        Descricao:Retorna Array Com Pilha de Chamadas
        Sintaxe:1)GetCallStack(<nStartt>)
                2)StaticCall(NDJLIB001,GetCallStack,<nStartt>)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD GetCallStack(nStart) CLASS NDJLIB001
RETURN(GetCallStack(@nStart))
STATIC FUNCTION GetCallStack(nStart)

    Local aCallStack:={}

    Local cCallStack:=""

    Local nCallStack

    DEFAULT nStart:=0

    nCallStack:=nStart
    While (cCallStack:=ProcName(++nCallStack),.NOT.(Empty(cCallStack)))
        aAdd(aCallStack,cCallStack)
    End While

RETURN(aCallStack)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:QryMaxCod
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:31/01/2011
        Descricao:Retorna o Ultimo Numero Conforme Parametros de Entrada
        Sintaxe:StaticCall(NDJLIB001,QryMaxCod,cAlias,cField,cWhere,lDeleted,lForceWhere,lChkFilial)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD QryMaxCod(cAlias,cField,cWhere,lDeleted,lForceWhere,lChkFilial) CLASS NDJLIB001
RETURN(QryMaxCod(@cAlias,@cField,@cWhere,@lDeleted,@lForceWhere,@lChkFilial))
STATIC FUNCTION QryMaxCod(cAlias,cField,cWhere,lDeleted,lForceWhere,lChkFilial)

    Local aArea:=GetArea()

    Local cQuery:=""
    Local cNextAlias
    Local cPrefixoCpo

    Local cMaxCod

    DEFAULT lDeleted:=.T.
    DEFAULT lForceWhere:=.F.

    cQuery:="SELECT "
    cQuery+="MAX("+cField+")MAXCOD "
    cQuery+="FROM "
    cQuery+=RetSqlName(cAlias)+" "+cAlias+" "
     IF (.NOT.(lForceWhere))
        DEFAULT lChkFilial:=.T.
        IF (lChkFilial)
            cPrefixoCpo:=PrefixoCpo(cAlias)
        EndIF
        cQuery+="WHERE "
        IF (lChkFilial)
            cQuery+=cAlias+"."+cPrefixoCpo+"_FILIAL='"+xFilial(cAlias)+"'"
        EndIF
        IF (lDeleted)
            IF (lChkFilial)
                cQuery+=" AND "
            EndIF
            cQuery+=cAlias+".D_E_L_E_T_<>'*'"
        EndIF
        IF (.NOT.(Empty(cWhere)))
            cQuery+=" AND "
            cQuery+=cWhere
        EndIF
    Else
        IF (.NOT.(Empty(cWhere)))
            cQuery+=cWhere
        EndIF
    EndIF

    cNextAlias:=GetNextAlias()

    TCQUERY (cQuery)ALIAS (cNextAlias)NEW

    cMaxCod:=(cNextAlias)->(MAXCOD)

    (cNextAlias)->(dbCloseArea())

    RestArea(aArea)

RETURN(cMaxCod)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:ClearQuery
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:31/01/2011
        Descricao:Limpar Tab,espacos e CRLF em uma expressao de Query
        Sintaxe:StaticCall(NDJLIB001,ClearQuery,cQuery)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD ClearQuery(cQuery) CLASS NDJLIB001
RETURN(ClearQuery(@cQuery))
STATIC FUNCTION ClearQuery(cQuery)


    Local cTab:="    "
    Local c1Spc:=Space(1)
    Local c2Spc:=Space(2)

    While (__cCRLF$cQuery)
        cQuery:=StrTran(cQuery,__cCRLF,c1Spc)
    End While
    While (cTab$cQuery)
        cQuery:=StrTran(cQuery,cTab,c1Spc)
    End While
    While (c2Spc$cQuery)
        cQuery:=StrTran(cQuery,c2Spc,c1Spc)
    End While

RETURN(cQuery )

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:ChgFilial
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:31/01/2011
        Descricao:Atualizar Campo _FILIAL quando Modo de Acesso Compartilhado
        Sintaxe:StaticCall(NDJLIB001,ChgFilial)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD ChgFilial() CLASS NDJLIB001
RETURN(ChgFilial())
STATIC FUNCTION ChgFilial()

    Local aCallStack:=GetCallStack()

    Local cAlias:=""
    Local cQuery:=""
    Local cTable:=""
    Local cFieldFil:=""
    Local cProcName:=ProcName()

    Local lTopConn:=.F.
    Local lCompart:=.F.

    Local nProcName:=0

    BEGIN SEQUENCE

        nProcName:=aScan(aCallStack,{|cStack|(cStack==cProcName)},++nProcName)

        IF (aScan(aCallStack,{|cStack|(cStack==cProcName)},++nProcName)==0)

            Processa({||ChgFilial()},"Atualizando Filial...")
            BREAK

        EndIF

        SX2->(dbClearFilter())
        SX2->(dbGotop())

        ProcRegua(0)

        While SX2->(.NOT.(Eof()))

            cAlias:=SX2->X2_CHAVE
            lCompart:=(SX2->X2_MODO=="C")

            IncProc(cAlias)

            TRYEXCEPTION

                IF (.NOT.(lCompart))
                    BREAK
                EndIF

                IF (.NOT.(ChkFile(cAlias)))
                    BREAK
                EndIF

                IF (Select(cAlias)==0)
                    BREAK
                EndIF

                lTopConn:=((cAlias)->(RddName())=="TOPCONN")

                IF (.NOT.(lTopConn))
                    BREAK
                EndIF

                (cAlias)->(dbCloseArea())

                cFieldFil:=(PrefixoCpo(cAlias)+"_FILIAL")

                IF ((cAlias)->(FieldPos(cFieldFil))==0)
                    BREAK
                EndIF

                cTable:=AllTrim(SX2->X2_ARQUIVO)

                cQuery:="UPDATE"+__cCRLF
                cQuery+="        "+cTable+__cCRLF
                cQuery+="SET"+__cCRLF
                cQuery+="        "+cFieldFil+"='  '"+__cCRLF
                cQuery+="WHERE"+__cCRLF
                cQuery+="        "+cFieldFil+"<>'  '"+__cCRLF

                cQuery:=ClearQuery(cQuery)

                TcSqlExec(cQuery)

            ENDEXCEPTION

            SX2->(dbSkip())

        End While

    END SEQUENCE

RETURN(NIL)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Function:GetSetMbFilter
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:27/01/2011
        Descricao:GetSet do Filtro da mBrowse
        Sintaxe:StaticCall(NDJLIB001,GetSetMbFilter,cExprFilTop)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD GetSetMbFilter(cExprFilTop) CLASS NDJLIB001
RETURN(GetSetMbFilter(@cExprFilTop))
STATIC FUNCTION GetSetMbFilter(cExprFilTop)

    Local bError:={||&(cError)}

    Local cError:="(__cSvTopFilter:='',__cTopRealFilter:='',__cFiltroPadrao:='')"
    Local cLastFilter

    Static _cStkLstFilter

    cLastFilter:=_cStkLstFilter
    _cStkLstFilter:=cExprFilTop

    TRYEXCEPTION USING bError
        VerSenha(.T.)//Forco o erro. Primeiro parametro de VerSenha espera um valor Numerico.
    ENDEXCEPTION

RETURN(cLastFilter)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:RetPictVal
        Autor:Marinaldo de Jesus
        Data:17/03/2011
        Descricao:Retorna a Picture para Campo Numerico Conforme Valor
        Sintaxe:StaticCall(NDJLIB001,RetPictVal,nVal,lDecZero,nInt,nDec,lPictSepMil)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD RetPictVal(nVal,lDecZero,nInt,nDec,lPictSepMil) CLASS NDJLIB001
RETURN(RetPictVal(@nVal,@lDecZero,@nInt,@nDec,@lPictSepMil))
STATIC FUNCTION RetPictVal(nVal,lDecZero,nInt,nDec,lPictSepMil)

    Local cPict
    Local cPictSepMil

    Local uInt
    Local uDec

    IF (ValType(nVal)=="N")
        uInt:=Int(nVal)
        uDec:=(nVal-uInt)
        DEFAULT lDecZero:=.F.
        IF (;
                (uDec==0);
                .and.;
                .NOT.(lDecZero);
        )
            uDec:=NIL
        EndIF
        IF (uDec<>NIL)
            uDec:=AllTrim(Str(uDec))
            uDec:=SubStr(uDec,At(".",uDec)+1)
            uDec:=Len(uDec)
        EndIF
        uInt:=Len(AllTrim(Str(uInt)))
        nInt:=uInt
        cPict:=Replicate("9",uInt)
        DEFAULT lPictSepMil:=.F.
        IF (lPictSepMil)
            IF (nInt>3)
                cPictSepMil:=cPict
                cPict:=""
                For uInt:=nInt To 1 Step-3
                    cPict:=(","+SubStr(cPictSepMil,-3,uInt)+cPict)
                Next uInt
            EndIF
        EndIF
        IF (uDec<>NIL)
            cPict+="."
            cPict+=Replicate("9",uDec)
            nDec:=uDec
        EndIF
    EndIF

RETURN(cPict)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:GetTopSource
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:28/03/2011
        Descricao:Obtem Conexao ao Top
        Sintaxe:<Vide Parametros Formais>
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD GetTopSource(cTopServer,nTopPort,cTopAlias,cTitle) CLASS NDJLIB001
RETURN(GetTopSource(@cTopServer,@nTopPort,@cTopAlias,@cTitle))
STATIC FUNCTION GetTopSource(cTopServer,nTopPort,cTopAlias,cTitle)

    Local aKeys:=GetKeys()
    Local aAdvSize:={}
    Local aInfoAdvSize:={}
    Local aObjSize:={}
    Local aObjCoords:={}

    Local bSet15:=NIL
    Local bSet24:=NIL
    Local bDialogInit:=NIL

    Local lOk:=.F.

    Local oDlg:=NIL
    Local oFont:=NIL
    Local oPanel:=NIL
    Local oGroup:=NIL
    Local oFontBig:=NIL
    Local oTopPort:=NIL
    Local oTopAlias:=NIL
    Local oTopServer:=NIL

    DEFAULT cTopAlias:=Space(50)
    DEFAULT cTopServer:=Space(16)
    DEFAULT nTopPort:=7890

    aAdvSize:=MsAdvSize(.T.,.T.,20)

    aAdvSize[3]-=127    //Ajusta a Largura do Objeto
    aAdvSize[4]-=050    //Ajusta a Altura do Objeto
    aAdvSize[5]-=255    //Ajusta a Largura do Dialogo
    aAdvSize[6]-=050    //Ajusta a Altura do Dialogo
    aAdvSize[7]+=010    //Ajusta a Altura do Dialogo

    aInfoAdvSize:={aAdvSize[1],aAdvSize[2],aAdvSize[3],aAdvSize[4],0,0}
    aAdd(aObjCoords,{000,000,.T.,.T.})
    aObjSize:=MsObjSize(aInfoAdvSize,aObjCoords)

    bSet15:={||lOk:=.T.,oDlg:End()}
    bSet24:={||lOk:=.F.,oDlg:End()}

    bDialogInit:={||EnchoiceBar(oDlg,bSet15,bSet24,NIL,NIL)}

    DEFAULT cTitle:="Conexo de Origem dos Dados"

    DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
    DEFINE MSDIALOG oDlg TITLE OemToAnsi(cTitle) From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF oMainWnd PIXEL

        @ 000,000 MSPANEL oPanel OF oDlg
        oPanel:Align:=CONTROL_ALIGN_ALLCLIENT

        @ aObjSize[1,1],aObjSize[1,2] GROUP oGroup TO aObjSize[1,3],aObjSize[1,4] LABEL OemToAnsi("Informe a Conexao") OF oDlg PIXEL
        oGroup:oFont:=oFont

        @ (aObjSize[1,1])+20,(aObjSize[1,2]+05) SAY "TopServer:" PIXEL
        @ (aObjSize[1,1])+15,(aObjSize[1,2]+35) MSGET oTopServer VAR cTopServer SIZE 150,10 OF oDlg PIXEL FONT oFont VALID (.NOT.(Empty(cTopServer)))
        @ (aObjSize[1,1])+40,(aObjSize[1,2]+05) SAY "TopAlias:"  PIXEL
        @ (aObjSize[1,1])+35,(aObjSize[1,2]+35) MSGET oTopAlias  VAR cTopAlias  SIZE 150,10 OF oDlg PIXEL FONT oFont VALID (.NOT.(Empty(cTopAlias)))
        @ (aObjSize[1,1])+60,(aObjSize[1,2]+05) SAY "TopPort:"   PIXEL
        @ (aObjSize[1,1])+55,(aObjSize[1,2]+35) MSGET oTopPort   VAR nTopPort   SIZE 150,10 OF oDlg PIXEL FONT oFont VALID (.NOT.(Empty(nTopPort)))

    ACTIVATE MSDIALOG oDlg CENTERED ON INIT Eval(bDialogInit)

    cTopServer:=AllTrim(cTopServer)
    cTopAlias:=AllTrim(cTopAlias)
    nTopPort:=nTopPort

    RestKeys(aKeys,.T.)

RETURN(lOk)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:TopGetInfo
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:28/03/2011
        Descricao:Retorna Informacoes do INI sobre o TopConnect
        Sintaxe:<Vide Parametros Formais>
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD TopGetInfo(cType) CLASS NDJLIB001
RETURN(TopGetInfo(@cType))
STATIC FUNCTION TopGetInfo(cType)

    Local cIniFile:=GetAdv97()
    Local cEnvServer:=GetEnvServer()

    Local uTopGetInfo

    Begin Sequence

        IF (Upper(AllTrim(cType))=="SERVER")
            uTopGetInfo:=TopGetString(@cEnvServer,@cIniFile,"Server")
            Break
        EndIF

        IF (Upper(AllTrim(cType))=="PORT")
            uTopGetInfo:=Val(TopGetString(@cEnvServer,@cIniFile,"Port"))
            Break
        EndIF

        IF (Upper(AllTrim(cType))=="ALIAS")
            uTopGetInfo:=TopGetString(@cEnvServer,@cIniFile,"DataBase")
            uTopGetInfo+="/"
            uTopGetInfo+=TopGetString(@cEnvServer,@cIniFile,"Alias")
            Break
        EndIF

    End Sequence

RETURN(uTopGetInfo)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:TopGetString
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:28/03/2011
        Descricao:Retorna Informacoes do INI sobre o TopConnect
        Sintaxe:<Vide Parametros Formais>
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD TopGetString(cEnvServer,cIniFile,cTopString) CLASS NDJLIB001
RETURN(TopGetString(@cEnvServer,@cIniFile,@cTopString))
STATIC FUNCTION TopGetString(cEnvServer,cIniFile,cTopString)

    Local cTopGetString:=GetPvProfString(cEnvServer,"Top"+cTopString,"",cIniFile)

    IF Empty(cTopGetString)
        cTopGetString:=GetPvProfString("TopConnect",cTopString,"",cIniFile)
    EndIF

RETURN(cTopGetString)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:DirMake
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:28/03/2011
        Descricao:Cria um Diretorio
        Sintaxe:<Vide Parametros Formais>
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD DirMake(cMakeDir,nTimes,nSleep) CLASS NDJLIB001
RETURN(DirMake(@cMakeDir,@nTimes,@nSleep))
STATIC FUNCTION DirMake(cMakeDir,nTimes,nSleep)

    Local lMakeOk
    Local nMakeOk

    IF (.NOT.(lMakeOk:=lIsDir(cMakeDir)))
        MakeDir(cMakeDir)
        nMakeOk:=0
        DEFAULT nTimes:=3
        DEFAULT nSleep:=100
        While (;
                .NOT.(lMakeOk:=lIsDir(cMakeDir));
                .and.;
                (++nMakeOk<=nTimes);
        )
            Sleep(nSleep)
            MakeDir(cMakeDir)
        End While
    EndIF

RETURN(lMakeOk)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:BrwLegenda
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:28/03/2011
        Descricao:Legenda de Cores
        Sintaxe:StaticCall(NDJLIB001,BrwLegenda,cTitulo,cMensagem,aLegend,bAction,cMsgAction)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD BrwLegenda(cTitulo,cMensagem,aLegend,bAction,cMsgAction) CLASS NDJLIB001
RETURN(BrwLegenda(@cTitulo,@cMensagem,@aLegend,@bAction,@cMsgAction))
STATIC FUNCTION BrwLegenda(cTitulo,cMensagem,aLegend,bAction,cMsgAction)

    Local aListBox

    Local nItem
    Local nItens

    Local oDlg
    Local oFont
    Local oPanel
    Local oListBox

    BEGIN SEQUENCE

        DEFAULT aLegend:={}
        nItens:=Len(aLegend)

        IF (nItens==0)
            BREAK
        EndIF

        DEFAULT cTitulo:="BrwLegenda"
        DEFAULT cMensagem:=""
        DEFAULT bAction:={|cResName|.NOT.(Empty(cResName))}
        DEFAULT cMsgAction:=""

        aListBox:=Array(nItens,2)
        For nItem:=1 To nItens
            aListBox[nItem][1]:=LoadBitmap(GetResources(),aLegend[nItem][1])
            aListBox[nItem][2]:=aLegend[nItem][2]
        Next nItem

        DEFINE MSDIALOG oDlg FROM 0,0 TO 345,410 TITLE OemToAnsi(cTitulo) OF GetWndDefault()PIXEL

            @ 000,000 MSPANEL oPanel OF oDlg
            oPanel:Align:=CONTROL_ALIGN_ALLCLIENT

            DEFINE FONT oFont NAME "Arial" SIZE 0,-13 BOLD

            @ 03,05 SAY OemToAnsi(cMensagem)OF oDlg PIXEL SIZE 200,010 FONT oFont
            @ 11,05 TO 012,200 LABEL "" OF oDlg PIXEL

            @ 15,05 LISTBOX oListBox FIELDS HEADER " ","Status" SIZE 200,150 OF oDlg PIXEL

            oListBox:SetArray(aListBox)
            oListBox:bLDblClick:={||Eval(bAction,aLegend[oListBox:nAt][1]),oDlg:End()}
            oListBox:bLine:={||{aListBox[oListBox:nAt][01],aListBox[oListBox:nAt][02]}}
            oListBox:cToolTip:=OemToAnsi(cMsgAction)
            oListBox:Refresh()

        ACTIVATE MSDIALOG oDlg CENTERED

    END SEQUENCE

RETURN(NIL)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:BrwGetSLeg
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:20/04/2011
        Descricao:Retornar o Status  conforme Array de Cores da mBrowse
        Sintaxe:StaticCall(NDJLIB001,BrwGetSLeg,cAlias,bGetColors,bGetLegend,cResName,lArrColors)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD BrwGetSLeg(cAlias,bGetColors,bGetLegend,cResName,lArrColors) CLASS NDJLIB001
RETURN(BrwGetSLeg(cAlias,bGetColors,bGetLegend,cResName,lArrColors))
STATIC FUNCTION BrwGetSLeg(cAlias,bGetColors,bGetLegend,cResName,lArrColors)

    Local cBmpColor:=""
    Local cEvalGetCL:=""

    Local lFilter:=(ValType(cResName)=="C")
    Local lEvalGetCL:=.T.

    Local nLoop
    Local nLoops

    Local uC1Ret

    Static __aBrwGetC
    Static __aBrwGetL

    Static __cEvGetCL

    Private __aColors_:={}
    Private __aLegend_:={}

    cEvalGetCL:=(cAlias+GetCbSource(bGetColors)+GetCbSource(bGetLegend))

    lEvalGetCL:=((__aBrwGetC==NIL).or.(__aBrwGetL==NIL).or..NOT.(cEvalGetCL==__cEvGetCL))
    __cEvGetCL:=cEvalGetCL

    IF (lEvalGetCL)
        TRYEXCEPTION
            Eval(bGetColors)    //Obtem __aColors_
        ENDEXCEPTION
        TRYEXCEPTION
            Eval(bGetLegend)    //Obtem __aLegend_
        ENDEXCEPTION
        __aBrwGetC:=__aColors_
        __aBrwGetL:=__aLegend_
    Else
        __aColors_:=__aBrwGetC
        __aLegend_:=__aBrwGetL
    EndIF

    BEGIN SEQUENCE

        DEFAULT lArrColors:=.F.
        IF (lArrColors)
            uC1Ret:={__aColors_,__aLegend_}
            BREAK
        EndIF

        TRYEXCEPTION
            IF (lFilter)
                cResName:=Upper(AllTrim(cResName))
            EndIF
            DEFAULT cAlias:=Alias()
            nLoops:=Len(__aColors_)
            For nLoop:=1 To nLoops
                IF (lFilter)
                    cBmpColor:=Upper(AllTrim(__aColors_[nLoop][2]))
                    nPosBmp:=aScan(__aLegend_,{|aBmpLeg|Upper(AllTrim(aBmpLeg[1]))==cBmpColor})
                    IF (.NOT.(nPosBmp==0))
                        uC1Ret:=__aColors_[nLoop][1] //Obtem a Condicao de Filtro
                    EndIF
                Else
                    IF (cAlias)->(&(__aColors_[nLoop][1]))  //Analisa a Condicao
                        cBmpColor:=Upper(AllTrim(__aColors_[nLoop][2]))
                        nPosBmp:=aScan(__aLegend_,{|aBmpLeg|Upper(AllTrim(aBmpLeg[1]))==cBmpColor})
                        IF (.NOT.(nPosBmp==0))
                            uC1Ret:=OemToAnsi(__aLegend_[nPosBmp][2])  //Obtem a Descricao
                        EndIF
                        Exit
                    EndIF
                EndIF
            Next nLoop
            DEFAULT uC1Ret:=""
        CATCHEXCEPTION
            uC1Ret:=""
        ENDEXCEPTION

    END SEQUENCE

RETURN(uC1Ret)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:BrwFiltLeg
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:20/04/2011
        Descricao:Filtra o Browse de acordo com a Opcao da Legenda da mBrowse
        Sintaxe:StaticCall(NDJLIB001,BrwFiltLeg,cAlias,aColors,aLegend,cTitle,cMsg,cMsgAction,cVarName)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD BrwFiltLeg(cAlias,aColors,aLegend,cTitle,cMsg,cMsgAction,cVarName) CLASS NDJLIB001
RETURN(BrwFiltLeg(@cAlias,@aColors,@aLegend,@cTitle,@cMsg,@cMsgAction,@cVarName))
STATIC FUNCTION BrwFiltLeg(cAlias,aColors,aLegend,cTitle,cMsg,cMsgAction,cVarName)

    Local aIndex

    Local bAction:={|cResName|cBmpName:=cResName}

    Local cBmpName
    Local cExpFilter
    Local cSvExprFilTop

    Local nBmpPos

    cTitle:=OemToAnsi(cTitle)
    cMsg:=OemToAnsi(cMsg)
    cMsgAction:=OemToAnsi(cMsgAction)

    BrwLegenda(@cTitle,@cMsg,@aLegend,@bAction,@cMsgAction)

    nBmpPos:=aScan(aColors,{|aBmp|Upper(AllTrim(aBmp[2]))==cBmpName})
    IF (nBmpPos>0)
        cExpFilter:=aColors[nBmpPos][1]
    Else
        cExpFilter:=""
    EndIF

    cSvExprFilTop:=GetSetMbFilter("")
    __cMbrRstFilter:=cSvExprFilTop
    IF (Type(cVarName)=="C")
        &(cVarName):=cSvExprFilTop
    EndIF

    SetMBTopFilter(cAlias,"" )

    aIndex:={}
    bFiltraBrw:={||FilBrowse(@cAlias,@aIndex,@cExpFilter)}
    Eval(bFiltraBrw)

    oObjBrow:=GetObjBrow()
    oObjBrow:ResetLen()
    oObjBrow:GoTop()
    oObjBrow:Refresh()

RETURN(cSvExprFilTop)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:MbrRstFilter
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:20/04/2011
        Descricao:Restaura o Filtro de Browse
        Sintaxe:StaticCall(NDJLIB001,MbrRstFilter,cAlias,cVarName)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD MbrRstFilter(cAlias,cVarName) CLASS NDJLIB001
RETURN(MbrRstFilter(@cAlias,@cVarName))
STATIC FUNCTION MbrRstFilter(cAlias,cVarName)
    Local oObjBrow
    Local cMbrRstFilter
    IF ((ValType(cVarName)=="C"))
        cMbrRstFilter:=&(cVarName)
    Else
        cMbrRstFilter:=&(__cMbrRstFilter)
    EndIF
    SetMBTopFilter(cAlias,"" )
    GetSetMbFilter(cMbrRstFilter)
    SetMBTopFilter(cAlias,cMbrRstFilter,.F.)
    oObjBrow:=GetObjBrow()
    oObjBrow:ResetLen()
    oObjBrow:GoTop()
    oObjBrow:Refresh()
RETURN(NIL)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:NDJEvalF3
        Data:20/12/2010
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Descricao:Retorna a Consulta Padrao e Atualiza Resultados
        Sintaxe:StaticCall(NDJLIB001,NDJEvalF3,cF3)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD NDJEvalF3(cF3,lShowHelp,cException) CLASS NDJLIB001
RETURN(NDJEvalF3(@cF3,@lShowHelp,@cException))
STATIC FUNCTION NDJEvalF3(cF3,lShowHelp,cException)

    Local lConpad1:=.F.

    Local oException

    TRYEXCEPTION

        DEFAULT lShowHelp:=.T.

        lConpad1:=ConPad1(NIL,NIL,NIL,cF3)

        IF (.NOT.(lConpad1))
            cException:="Nenhuma informacao Selecionada"
            IF (.NOT.(lShowHelp))
                BREAK
            EndIF
            UserException(cException)
        EndIF

        IF (.NOT.(Type("aCpoRet")=="A"))
            cException:="Problemas no Retorno da Consulta Padra"+__cCRLF+__cCRLF+"Entre em contato com o Administrador do Sistema."
            IF (.NOT.(lShowHelp))
                BREAK
            EndIF
            UserException(cException)
        EndIF

        //Atualiza os Campos de acordo com o Retorno da Consulta Padrao
        aEval(aCpoRet,{|cEval|&(cEval)})

    CATCHEXCEPTION USING oException

        IF (ValType(oException)=="O")
            cException:=oException:Description
            IF (lShowHelp)
                Help("",1,ProcName(),NIL,OemToAnsi(cException),1,0)
            EndIF
            ConOut(CaptureError())
        EndIF

    ENDEXCEPTION

RETURN(lConpad1)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:RunInSrv
        Data:28/04/2011
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Descricao:Executa uma Aplicacao no Servidor
        Sintaxe:StaticCall(NDJLIB001,RunInSrv,cCommandLine,lWaitRun,cPath)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD RunInSrv(cCommandLine,lWaitRun,cPath) CLASS NDJLIB001
RETURN(RunInSrv(@cCommandLine,@lWaitRun,@cPath))
STATIC FUNCTION RunInSrv(cCommandLine,lWaitRun,cPath)
RETURN(WaitRunSrv(@cCommandLine,@lWaitRun,@cPath))

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:MemoToaPrn
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:06/09/2011
        Descricao:Preparar o Texto do Tipo Memo para impressao
        Sintaxe:StaticCall(NDJLIB001,MemoToaPrn,cMemo,nBytes,lUseCrLf)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD MemoToaPrn(cMemo,nBytes,lUseCrLf) CLASS NDJLIB001
RETURN(MemoToaPrn(@cMemo,@nBytes,@lUseCrLf))
STATIC FUNCTION MemoToaPrn(cMemo,nBytes,lUseCrLf)

    Local aMemoToPrn:={}
    Local aMemoAux

    Local cChr10
    Local cSpace2
    Local cNewMemo
    Local cMemoAux

    Local nChr10_1
    Local nChr10_2

    Local nMemo
    Local nMemos

    Begin Sequence

        IF Empty(cMemo)
            Break
        EndIF

        DEFAULT lUseCrLf:=.F.
        IF (lUseCrLf)

            aMemoToPrn:=StrToArray(cMemo,__cCRLF)

            Break

        EndIF

        DEFAULT nBytes:=80
        IF (Len(cMemo)<=nBytes)
            aMemoToPrn:={cMemo}
            Break
        EndIF

        cChr10:=Chr(10)
        cSpace2:=Space(02)
        nChr10_1:=0
        nChr10_2:=0

        cNewMemo:=cMemo

        While (cSpace2$cNewMemo)
            cNewMemo:=StrTran(cNewMemo,cSpace2,"")
        End While

        nChr10_1:=At(cChr10,cNewMemo)
        nChr10_2:=At(cChr10,SubStr(cNewMemo,nChr10_1+1))

        IF ((nChr10_1>0).and.(nChr10_2>0))
            While (nChr10_2==(nChr10_1+1).or.(nChr10_2==nChr10_1))
                cNewMemo:=SubStr(cNewMemo,nChr10_2+1)
                IF ((nChr10_1:=At(cChr10,cNewMemo))==0)
                    Exit
                EndIF
                IF ((nChr10_2:=At(cChr10,SubStr(cNewMemo,nChr10_1+1)))==0)
                    Exit
                EndIF
            End While
        EndIF

        While ((nChr10_1:=At(cChr10,cNewMemo))==1)
            cNewMemo:=SubStr(cNewMemo,2)
        End While

        aMemoAux:=StrToArray(cNewMemo,__cCRLF)

        nMemos:=Len(aMemoAux)
        cNewMemo:=""
        For nMemo:=1 To nMemos
            cNewMemo+=aMemoAux[nMemo]
            cNewMemo+=" "
        Next nMemo
        aMemoAux:=NIL

        nMemos:=Len(cNewMemo)
        For nMemo:=1 To nMemos Step nBytes
            cMemoAux:=SubStr(cNewMemo,nMemo,nBytes)
            aAdd(aMemoToPrn,cMemoAux)
        Next nMemo

    End Sequence

RETURN(aMemoToPrn)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:StrToArray
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:06/09/2011
        Descricao:Retornar Array com o Parser de Uma String Concatenada
        Sintaxe:StaticCall(NDJLIB001,StrToArray,cString,cConcat,bAddParser)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD StrToArray(cString,cConcat,bAddParser) CLASS NDJLIB001
RETURN(StrToArray(@cString,@cConcat,@bAddParser))
STATIC FUNCTION StrToArray(cString,cConcat,bAddParser)

    Local aStrTokArr:={}

    Local cStr

    Local nATToken
    Local nRealSize

    DEFAULT cToken:="+"
    DEFAULT bEvalToken:={||.T.}

    if (at(cToken,cString)>0)
        nRealSize:=len(cToken)
        while ((nATToken:=at(cToken,cString))>0)
            if (nATToken>1)
                cStr:=allTrim(subStr(cString,1,(nATToken-1)))
            Else
                cStr:=""
            endif
            cString:=subStr(cString,(nATToken+nRealSize))
            if eval(bEvalToken,@cStr)
                aAdd(aStrTokArr,cStr)
            endif
        end while
        if (len(cString)>0)
            cStr:=cString
            if eval(bEvalToken,@cStr)
                aAdd(aStrTokArr,cStr)
            endif
        endif
    Else
        cStr:=cString
        if eval(bEvalToken,@cStr)
            aAdd(aStrTokArr,cStr)
        endif
    endif

RETURN(aStrTokArr)

//--------------------------------------------------------------------------------------------------------------
    /*
        Funcao:_StrTokArr
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Funcao:_StrTokArr
        Autor:Marinaldo de Jesus (TOTALIT:http://www.totalitsolutions.com.br)
        Data:06/03/2015
    */
//--------------------------------------------------------------------------------------------------------------
METHOD _StrTokArr(cStr,cToken) CLASS NDJLIB001
RETURN(_StrTokArr(@cStr,@cToken))
STATIC FUNCTION _StrTokArr(cStr,cToken)
    Local cDToken
    DEFAULT cStr:=""
    DEFAULT cToken:=";"
    cDToken:=(cToken+cToken)
    While (cDToken$cStr)
        cStr:=StrTran(cStr,cDToken,cToken+" "+cToken)
    End While
RETURN(StrTokArr2(cStr,cToken))

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:StrDelChr
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:08/11/2005
        Descricao:Excluir o Conteudo de uma String conforme aChrDelStr
        Sintaxe:<Vide Parametros Formais>
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD StrDelChr(cStrDelChr,aChrDelStr) CLASS NDJLIB001
RETURN(StrDelChr(@cStrDelChr,@aChrDelStr))
STATIC FUNCTION StrDelChr(cStrDelChr,aChrDelStr)

    Local nChar
    Local nChars

    nChars:=Len(aChrDelStr)
    For nChar:=1 To nChars
        cStrDelChr:=StrTran(cStrDelChr,aChrDelStr[nChar],"")
    Next nChar

RETURN(cStrDelChr)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:_GetMvPar
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:23/09/2011
        Descricao:Obtem o Parametro de Acordo com a Empresa de Referencia
        Sintaxe:StaticCall(NDJFGEN,_GetMvPar,cEmp,cFil,uMvPar,uDefault,lReset)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD _GetMvPar(cEmp,cFil,uMvPar,uDefault,lReset) CLASS NDJLIB001
RETURN(_GetMvPar(@cEmp,@cFil,@uMvPar,@uDefault,@lReset))
STATIC FUNCTION _GetMvPar(cEmp,cFil,uMvPar,uDefault,lReset)
    Local uMvRet
    DEFAULT cEmp:=cEmpAnt
    DEFAULT cFil:=cFilAnt
    IF (cEmp==cEmpAnt)
        uMvRet:=U_GetMvPar(@cEmp,@cFil,@uMvPar,@uDefault,.F.,lReset,.F.)
    Else
        uMvRet:=StartJob("U_GetMvPar",GetEnvServer(),.T.,cEmp,cFil,uMvPar,uDefault,.T.,lReset,.F.)
    EndIF
RETURN(uMvRet)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:_PutMvPar
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:23/09/2011
        Descricao:Salva o Conteudo do Parametro de Acordo com a Empresa de Referencia
        Sintaxe:StaticCall(NDJFGEN,_PutMvPar,cEmp,cFil,uMvPar,uMvCntPut)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD _PutMvPar(cEmp,cFil,uMvPar,uMvCntPut) CLASS NDJLIB001
RETURN(_PutMvPar(@cEmp,@cFil,@uMvPar,@uMvCntPut))
STATIC FUNCTION _PutMvPar(cEmp,cFil,uMvPar,uMvCntPut)
    Local uMvRet
    DEFAULT cEmp:=cEmpAnt
    DEFAULT cFil:=cFilAnt
    IF (cEmp==cEmpAnt)
        uMvRet:=U_PutMvPar(@cEmp,@cFil,@uMvPar,@uMvCntPut,.F.)
    Else
        uMvRet:=StartJob("U_PutMvPar",GetEnvServer(),.T.,@cEmp,@cFil,@uMvPar,@uMvCntPut,.T.)
    EndIF
RETURN(uMvRet)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:U_GetMvPar
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:23/09/2011
        Descricao:Obtem o Parametro de Acordo com a Empresa de Referencia
        Sintaxe:U_GetMvPar(cEmp,cFil,uMvPar,uDefault,lRpcSet,lReset,lHelp)
    /*/
//--------------------------------------------------------------------------------------------------------------
User Function GetMvPar(cEmp,cFil,uMvPar,uDefault,lRpcSet,lReset,lHelp)

    Local bGetMv:={|cMvPar,uByDef|SuperGetMv(@cMvPar,@lHelp,@uByDef,@cFil)}

    Local cMvType:=ValType(uMvPar)

    Local lSetCentury

    Local nMV
    Local nMVs

    Local uMvRet

    BEGIN SEQUENCE

        IF (.NOT.(;
                    (IsInCallStack("_GetMvPar"));
                    .or.;
                    (IsInCallStack("U_GetMvPar").and.Empty(ProcName(1)));
                 );
        )
            //Nao Permito a Chamada Direta
            BREAK
        EndIF

        DEFAULT lRpcSet:=.F.
        IF (lRpcSet)
            RpcSetType(3)
            RpcSetEnv(cEmp,cFil)
            SetsDefault()
        EndIF

        lSetCentury:=__SetCentury("ON")

        DEFAULT lReset:=.F.
        IF (lReset)
            SuperGetMv()
        EndIF

        DEFAULT lHelp:=.F.

        IF (cMvType=="C")
            uMvRet:=Eval(bGetMv,uMvPar)
        ElseIF (cMvType=="A")
            nMvs:=Len(uMvPar)
            uMvRet:=Array(nMvs)
            For nMV:=1 To nMvs
                uMvRet[nMV]:=Eval(bGetMv,uMvPar[nMV],uDefault[nMV])
            Next nMV
        EndIF

        IF (.NOT.(lSetCentury))
            __SetCentury("OFF")
        EndIF

    END SEQUENCE

RETURN(uMvRet)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:U_PutMvPar
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:23/09/2011
        Descricao:Grava o Conteudo Parametro de Acordo com a Empresa de Referencia
        Sintaxe:U_PutMvPar(cEmp,cFil,uMvPar,uMvCntPut,lRpcSet)
    /*/
//--------------------------------------------------------------------------------------------------------------
User Function PutMvPar(cEmp,cFil,uMvPar,uMvCntPut,lRpcSet)

    Local bPutMV:={|cMvPar,uMvPut|PutMv(@cMvPar,@uMvPut)}

    Local cMvType:=ValType(uMvPar)

    Local lSetCentury

    Local nMV
    Local nMVs

    Local uMvRet

    BEGIN SEQUENCE

        IF (.NOT.(;
                    (IsInCallStack("_PutMvPar"));
                    .or.;
                    (IsInCallStack("U_PutMvPar").and.Empty(ProcName(1)));
                 );
        )
            //Nao Permito a Chamada Direta
            BREAK
        EndIF

        DEFAULT lRpcSet:=.F.

        IF (lRpcSet)
            RpcSetType(3)
            RpcSetEnv(cEmp,cFil)
            SetsDefault()
        EndIF

        lSetCentury:=__SetCentury("ON")

        IF (cMvType=="C")
            Eval(bPutMV,uMvPar,uMvCntPut)
        ElseIF (cMvType=="A")
            nMvs:=Len(uMvPar)
            For nMV:=1 To nMvs
                Eval(bPutMV,uMvPar[nMV],uMvCntPut[nMV])
            Next nMV
        EndIF

         uMvRet:=_GetMvPar(@cEmp,@cFil,@uMvPar,@uMvCntPut,.T.)

        IF (.NOT.(lSetCentury))
            __SetCentury("OFF")
        EndIF

    END SEQUENCE

RETURN(uMvRet)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:EvalPrg
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:23/09/2011
        Descricao:Executa um Programa Diretamente
        Sintaxe:StaticCall(NDJLIB001,EvalPrg,bExec,cEmp,cFil,cModulo,cFunName)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD EvalPrg(bExec,cEmp,cFil,cModName,cFunName) CLASS NDJLIB001
RETURN(EvalPrg(@bExec,@cEmp,@cFil,@cModName,@cFunName))
STATIC FUNCTION EvalPrg(bExec,cEmp,cFil,cModName,cFunName)

    Local bWindowInit:={||Eval(bExec)}

    Local cModulo

    Local lPrepEnv:=(IsBlind().or.(Select("SM0")==0))

    Local nModulo

    Local uRet

    BEGIN SEQUENCE

        IF (lPrepEnv)
            RpcSetType(3)
            DEFAULT cModName:="SIGAESP"
            nModulo:=aScan(RetModName(.T.),{|aModulo|Upper(AllTrim(aModulo[2]))==cModName})
            IF (nModulo>0)
                cModulo:=StrTran(cModName,"SIGA","")
            Else
                cModName:="SIGAESP"
                cModulo:="ESP"
            EndIF
            PREPARE ENVIRONMENT EMPRESA(cEmp) FILIAL (cFil) MODULO cModulo
            InitPublic()
            SetsDefault()
            DEFAULT cFunName:=FunName()
            SetFunName(cFunName)
            SetModulo(cModName,cModulo)
            lMsFinalAuto:=.F.
            lMsHelpAuto:=.F.
            __cInternet:=NIL
            HelpInDark(.F.)
            StaticCall(NDJLIB010,PutInternal,ProcName())
        EndIF

            IF (Type("oMainWnd")=="O")
                uRet:=Eval(bExec)
                BREAK
            EndIF

            bWindowInit:={||StaticCall(NDJLIB010,PutInternal,cFunName),uRet:=Eval(bExec)}
            DEFINE WINDOW oMainWnd FROM 0,0 TO 0,0 TITLE OemToAnsi(cFunName)
            ACTIVATE WINDOW oMainWnd MAXIMIZED ON INIT (Eval(bWindowInit),oMainWnd:End())

        IF (lPrepEnv)
            RESET ENVIRONMENT
        EndIF

    END SEQUENCE

RETURN(uRet)

//--------------------------------------------------------------------------------------------------------------
    /*
        Funcao:DesvPad
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:16/04/2012
        Uso:Calcula o Desvio Padrao
    */
//--------------------------------------------------------------------------------------------------------------
METHOD DesvPad(aValores,lPolarizado) CLASS NDJLIB001
RETURN(DesvPad(@aValores,@lPolarizado))
STATIC FUNCTION DesvPad(aValores,lPolarizado)

    Local nSoma:=0
    Local nMedia:=0

    Local nLoop
    Local nLoops

    nLoops:=Len(aValores)
    For nLoop:=1 To nLoops
        cType:=ValType(aValores[nLoop])
        IF (cType=="L")
            aValores[nLoop]:=IF(aValores[nLoop],1,0)
        ElseIF (cType=="D")
            aValores[nLoop]:=Val(Dtos(aValores[nLoop]))
        ElseIF (cType=="C")
            aValores[nLoop]:=Val(aValores[nLoop])
        ElseIF (cType<>"N")
            aValores[nLoop]:=0
        EndIF
        nSoma+=aValores[nLoop]
    Next nLoop

    nMedia:=(nSoma/nLoops)
    nSoma:=0

    For nLoop:=1 To nLoops
        aValores[nLoop]:=Abs(aValores[nLoop]-nMedia)
        aValores[nLoop]*=aValores[nLoop]
        nSoma+=aValores[nLoop]
    Next nLoop

    DEFAULT lPolarizado:=.F.
    nMedia:=(nSoma/(nLoops-IF(lPolarizado,0,1)))
    nDesvPad:=Sqrt(nMedia)

RETURN(nDesvPad)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:FileToArr
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:08/11/2005
        Descricao:Retorna Array com as informacoes de um arquivo Texto
        Sintaxe:<Vide Parametros Formais>
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD FileToArr(cFile) CLASS NDJLIB001
RETURN(FileToArr(@cFile))
STATIC FUNCTION FileToArr(cFile)

    Local aFile:={}

    Local cLine

    Local uUsed

    Begin Sequence

        IF (.NOT.(File(cFile)))
            Break
        EndIF

        uUsed:=fT_fUse(cFile)
        IF (;
                ((ValType(uUsed)=="N").and.(uUsed< 0));
                .or.;
                ((ValType(uUsed)=="L").and..NOT.(uUsed));
        )
            Break
        EndIF

        fT_fGotop()
        While (.NOT.(fT_fEof()))
            cLine:=fT_fReadLn()
            aAdd(aFile,cLine)
            fT_fSkip()
        End While
        fT_fUse()

    End Sequence

RETURN(aFile)

//--------------------------------------------------------------------------------------------------------------
    /*
        Funcao:PutSX1
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br) [http://www.blacktdn.com.br]
        Data:02/07/2012
        Descricao:Adiciona e/ou Remove Perguntas utilizadas no Programa
        Uso:Generico
        Obs.:
    */
//--------------------------------------------------------------------------------------------------------------
Static Procedure PutSX1(cPerg,aPerg)

    Local cKeySeek

    Local lFound
    Local lAddNew

    Local nBL
    Local nEL:=Len(aPerg)

    Local nAT
    Local nField
    Local nFields
    Local nAtField

    Local __nGrupo:=1
    Local __nOrdem:=2
    Local __nField:=3

    Local uCNT

    SX1->(dbSetOrder(1))//X1_GRUPO+X1_ORDEM

    cPerg:=Padr(cPerg,Len(SX1->X1_GRUPO))

    SX1->(dbGoTop())
    SX1->(dbSeek(cPerg,.F.))

    While SX1->(.NOT.Eof().and.X1_GRUPO==cPerg)
        nAT:=SX1->(aScan(aPerg,{|x|((x[__nGrupo]==X1_GRUPO).and.(x[__nOrdem]==X1_ORDEM))}))
        lFound:=(nAT>0)
        IF (.NOT.(lFound))
            IF SX1->(RecLock("SX1",.F.))
                SX1->(dbDelete())
                SX1->(MsUnLock())
            EndIF
        EndIF
        SX1->(dbSkip())
    End While

    For nBL:=1 To nEL
        cKeySeek:=aPerg[nBL][__nGrupo]
        cKeySeek+=aPerg[nBL][__nOrdem]
        lFound:=SX1->(dbSeek(cKeySeek,.T.))
        lAddNew:=.NOT.(lFound)
        IF SX1->(RecLock("SX1",lAddNew))
            nFields:=Len(aPerg[nBL][__nField])
            For nField:=1 To nFields
                nAtField:=aPerg[nBL][__nField][nField][4]
                lChange:=(aPerg[nBL][__nField][nField][3].and.(nAtField>0))
                IF (lChange)
                    uCNT:=aPerg[nBL][__nField][nField][2]
                    SX1->(FieldPut(nAtField,uCNT))
                EndIF
            Next nField
            SX1->(MsUnLock())
        EndIF
    Next nBL

RETURN

//--------------------------------------------------------------------------------------------------------------
    /*
        Funcao:AddPerg
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br) [http://www.blacktdn.com.br]
        Data:02/07/2012
        Descricao:Adiciona Informacoes do compo
        Uso:Generico
        Obs.:
    */
//--------------------------------------------------------------------------------------------------------------
Static Procedure AddPerg(aPerg,cGrupo,cOrdem,cField,uCNT)

    Local bEval

    Local nAT
    Local nATField

    Local __nGrupo:=1
    Local __nOrdem:=2
    Local __nField:=3

    Static aX1Fields
    Static __cX1Fields

    IF (.NOT.(Type("cEmpAnt")=="C"))
        Private cEmpAnt:=""
    EndIF

    IF ((aX1Fields==NIL).or..NOT.(__cX1Fields==cEmpAnt))
        __cX1Fields:=cEmpAnt
        aX1Fields:={;
                                    {"X1_GRUPO",NIL,.T.,0},;
                                    {"X1_ORDEM",NIL,.T.,0},;
                                    {"X1_PERGUNT",NIL,.T.,0},;
                                    {"X1_PERSPA",NIL,.T.,0},;
                                    {"X1_PERENG",NIL,.T.,0},;
                                    {"X1_VARIAVL",NIL,.T.,0},;
                                    {"X1_TIPO",NIL,.T.,0},;
                                    {"X1_TAMANHO",NIL,.T.,0},;
                                    {"X1_DECIMAL",NIL,.T.,0},;
                                    {"X1_PRESEL",NIL,.F.,0},;
                                    {"X1_GSC",NIL,.T.,0},;
                                    {"X1_VALID",NIL,.T.,0},;
                                    {"X1_VAR01",NIL,.T.,0},;
                                    {"X1_DEF01",NIL,.T.,0},;
                                    {"X1_DEFSPA1",NIL,.T.,0},;
                                    {"X1_DEFENG1",NIL,.T.,0},;
                                    {"X1_CNT01",NIL,.F.,0},;
                                    {"X1_VAR02",NIL,.T.,0},;
                                    {"X1_DEF02",NIL,.T.,0},;
                                    {"X1_DEFSPA2",NIL,.T.,0},;
                                    {"X1_DEFENG2",NIL,.T.,0},;
                                    {"X1_CNT02",NIL,.F.,0},;
                                    {"X1_VAR03",NIL,.T.,0},;
                                    {"X1_DEF03",NIL,.T.,0},;
                                    {"X1_DEFSPA3",NIL,.T.,0},;
                                    {"X1_DEFENG3",NIL,.T.,0},;
                                    {"X1_CNT03",NIL,.F.,0},;
                                    {"X1_VAR04",NIL,.T.,0},;
                                    {"X1_DEF04",NIL,.T.,0},;
                                    {"X1_DEFSPA4",NIL,.T.,0},;
                                    {"X1_DEFENG4",NIL,.T.,0},;
                                    {"X1_CNT04",NIL,.F.,0},;
                                    {"X1_VAR05",NIL,.T.,0},;
                                    {"X1_DEF05",NIL,.T.,0},;
                                    {"X1_DEFSPA5",NIL,.T.,0},;
                                    {"X1_DEFENG5",NIL,.T.,0},;
                                    {"X1_CNT05",NIL,.F.,0},;
                                    {"X1_F3",NIL,.T.,0},;
                                    {"X1_PYME",NIL,.T.,0},;
                                    {"X1_GRPSXG",NIL,.T.,0},;
                                    {"X1_HELP",NIL,.T.,0},;
                                    {"X1_PICTURE",NIL,.T.,0},;
                                    {"X1_IDFIL",NIL,.T.,0};
        }

        bEval:={|x,y|;
                        nATField:=FieldPos(aX1Fields[y][1]),;
                        aX1Fields[y][2]:=GetValType(ValType(FieldGet(nATField))),;
                        aX1Fields[y][4]:=nATField,;
        }
        SX1->(aEval(aX1Fields,bEval))
    EndIF

    nAT:=aScan(aPerg,{|x|((x[1]==cGrupo).and.(x[2]==cOrdem))})

    IF (nAT==0)
        aAdd(aPerg,{cGrupo,cOrdem,aClone(aX1Fields)})
        nAT:=Len(aPerg)
    EndIF

    cField:=Upper(AllTrim(cField))
    nATField:=aScan(aPerg[nAT][3],{|e|(e[1]==cField)})

    IF (nATField>0)

        aPerg[nAT][__nField][nATField][2]:=uCNT

        nATField:=aScan(aPerg[nAT][3],{|e|(e[1]=="X1_GRUPO")})
        IF (nATField>0)
            aPerg[nAT][__nField][nATField][2]:=cGrupo
        EndIF

        nATField:=aScan(aPerg[nAT][3],{|e|(e[1]=="X1_ORDEM")})
        IF (nATField>0)
            aPerg[nAT][__nField][nATField][2]:=cOrdem
        EndIF

    EndIF

RETURN

//--------------------------------------------------------------------------------------------------------------
    /*
        Funcao:SXGSize
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br) [http://www.blacktdn.com.br]
        Data:02/07/2012
        Descricao:Obtem informacaos do Grupo em SXG (Size e Picture)
        Uso:Generico
        Obs.:
    */
//--------------------------------------------------------------------------------------------------------------
METHOD SXGSize(cGRPSXG,nSize,nDec,cPicture) CLASS NDJLIB001
RETURN(SXGSize(@cGRPSXG,@nSize,@nDec,@cPicture))
STATIC FUNCTION SXGSize(cGRPSXG,nSize,nDec,cPicture)

    Local cSXGPict

    Local nSXGDec
    Local nSXGSize

    DEFAULT nSize:=0
    DEFAULT nDec:=0
    DEFAULT cPicture:=""

    IF (.NOT.Empty(cGRPSXG))

        SXG->(dbSetOrder(1))//XG_GRUPO

        lFound:=SXG->(MsSeek(cGRPSXG,.F.))

        IF (lFound)
            nSXGSize:=SXG->XG_SIZE
            cSXGPict:=SXG->XG_PICTURE
        Else
            cSXGPict:=cPicture
            nSXGSize:=nSize
        EndIF

        nSXGDec:=nDec

    Else

        nSXGSize:=nSize
        nSXGDec:=nDec
        cSXGPict:=cPicture

    EndIF

RETURN({nSXGSize,nSXGDec,cSXGPict})

//--------------------------------------------------------------------------------------------------------------
    /*
        Funca:X3Tipo
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br) [http://www.blacktdn.com.br]
        Data:02/07/2012
        Descricao:Obtem informacaos do Campo X3_TIPO
        Uso:Generico
        Obs.:
    */
//--------------------------------------------------------------------------------------------------------------
METHOD X3Tipo(cField) CLASS NDJLIB001
RETURN(X3Tipo(@cField))
STATIC FUNCTION X3Tipo(cField)
RETURN(GetSx3Cache(cField,"X3_TIPO"))


//--------------------------------------------------------------------------------------------------------------
    /*
        Funcao:X3Tamanho
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br) [http://www.blacktdn.com.br]
        Data:02/07/2012
        Descricao:Obtem informacaos do Campo X3_TAMANHO
        Uso:Generico
        Obs.:
    */
//--------------------------------------------------------------------------------------------------------------
METHOD X3Tamanho(cField) CLASS NDJLIB001
RETURN(X3Tamanho(@cField))
STATIC FUNCTION X3Tamanho(cField)
RETURN(GetSx3Cache(cField,"X3_TAMANHO"))

//--------------------------------------------------------------------------------------------------------------
    /*
        Funcao:X3Decimal
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br) [http://www.blacktdn.com.br]
        Data:02/07/2012
        Descricao:Obtem informacaos do Campo X3_DECIMAL
        Uso:Generico
        Obs.:
    */
//--------------------------------------------------------------------------------------------------------------
METHOD X3Decimal(cField) CLASS NDJLIB001
RETURN(X3Decimal(@cField))
STATIC FUNCTION X3Decimal(cField)
RETURN(GetSx3Cache(cField,"X3_DECIMAL"))

//--------------------------------------------------------------------------------------------------------------
    /*
        Funcao:X3Picture
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br) [http://www.blacktdn.com.br]
        Data:02/07/2012
        DescricaoObtem informacaos do Campo X3_PICTURE
        Uso:Generico
        Obs.:
    */
//--------------------------------------------------------------------------------------------------------------
METHOD X3Picture(cField) CLASS NDJLIB001
RETURN(X3Picture(@cField))
STATIC FUNCTION X3Picture(cField)
RETURN(GetSx3Cache(cField,"X3_PICTURE"))

//--------------------------------------------------------------------------------------------------------------
    /*/
        Function:FolderSetOption
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:24/04/2013
        Descricao:Valida a Mudança de Folder
        Sintaxe:FolderSetOption(nTarget,nSource,aObjFolder,aGdObjects,nActFolder,lVldFolder)
                        nTarget     01 ->Folder Para o Qual se Vai
                        nSource     02 ->Folder de Onde se Vem
                        aObjFolder  03 ->Objetos do Folder
                        aGdObjects  04 ->Verifica se o Objeto eh uma GetDados
                        nActFolder  05 ->Folder Ativo
                        lVldFolder  06 ->Verifica se Deve Efetuar a Validacao do Folder quando nTarget nLastFoder forem iguais
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD FolderSetOption(nTarget,nSource,aObjFolder,aGdObjects,nActFolder,lVldFolder) CLASS NDJLIB001
RETURN(FolderSetOption(@nTarget,@nSource,@aObjFolder,@aGdObjects,@nActFolder,@lVldFolder))
STATIC FUNCTION FolderSetOption(nTarget,nSource,aObjFolder,aGdObjects,nActFolder,lVldFolder)

    Local lSetOption:=.T.
    Local lObjisGd:=.F.

    Local nSetOption:=0

    Local aClassData

    Local lIsObject
    Local lIsBlock

    Local nFolder
    Local nFolders
    Local nObj
    Local nObjs
    Local nPosClassName

    DEFAULT lVldFolder:=.T.
    lVldFolder:=IF(.NOT.(lVldFolder),(nTarget<>nSource),lVldFolder)

    nFolders:=Len(aObjFolder)
    IF (lVldFolder)
        For nFolder:=nSource To nSource
            nObjs:=Len(aObjFolder[nFolder])
            For nObj:=1 To nObjs
                IF (lIsObject:=(ValType(aObjFolder[nFolder][nObj][01])=="O"))
                    IF (lIsBlock:=(ValType(aObjFolder[nFolder][nObj][02])=="B"))
                        IF (.NOT.(lSetOption:=Eval(aObjFolder[nFolder][nObj][02])))//Valid
                            Exit
                        EndIF
                    EndIF
                EndIF
            Next nObj
            IF (.NOT.(lSetOption))
                nSetOption:=nFolder
                Exit
            EndIF
        Next nFolder
    EndIF

    aGdObjects:={}
    For nFolder:=1 To nFolders
        aAdd(aGdObjects,{})
        nObjs:=Len(aObjFolder[nFolder])
        For nObj:=1 To nObjs
            lObjisGd:=.F.
            IF (lIsObject:=(ValType(aObjFolder[nFolder][nObj][01])=="O"))
                aClassData:=ClassDataArr(aObjFolder[nFolder][nObj][01],.T.)
                IF ((nPosClassName:=aScan(aClassData,{|eData|(Upper(AllTrim(eData[1]))=="CCLASSNAME")}))>0)
                    lObjisGd:=(aClassData[nPosClassName][2]$"MSNEWGETDADOS/MSGETDADOS")
                EndIF
                aObjFolder[nFolder][nObj][01]:Hide()
            EndIF
            aAdd(aGdObjects[Len(aGdObjects)],lObjisGd)
        Next nObj
    Next nFolder

    IF (.NOT.(lSetOption))
        For nFolder:=nSetOption To nSetOption
            nObjs:=Len(aObjFolder[nFolder])
            For nObj:=1 To nObjs
                IF (lIsObject:=(ValType(aObjFolder[nFolder][nObj][01])=="O"))
                    aObjFolder[nFolder,nObj,01]:Show()
                    IF (lIsBlock:=(ValType(aObjFolder[nFolder][nObj][03])=="B"))
                        Eval(aObjFolder[nFolder][nObj][03])  //Init
                    EndIF
                EndIF
            Next nObj
        Next nFolder
    Else
        For nFolder:=nTarget To nTarget
            nObjs:=Len(aObjFolder[nFolder])
            For nObj:=1 To nObjs
                IF (lIsObject:=(ValType(aObjFolder[nFolder][nObj][01])=="O"))
                    aObjFolder[nFolder,nObj,01]:Show()
                    IF (lIsBlock:=(ValType(aObjFolder[nFolder][nObj][03])=="B"))
                        Eval(aObjFolder[nFolder][nObj][03])  //Init
                    EndIF
                EndIF
            Next nObj
        Next nFolder
        For nFolder:=nSource To nSource
            nObjs:=Len(aObjFolder[nFolder])
            For nObj:=1 To nObjs
                IF (Len(aObjFolder[nFolder][nObj])>=4)
                    IF (lIsBlock:=(ValType(aObjFolder[nFolder,nObj,04])=="B"))
                        Eval(aObjFolder[nFolder][nObj][04])  //Exit
                    EndIF
                EndIF
            Next nObj
        Next nFolder
    EndIF

    IF (nSetOption==0)
        IF (lSetOption)
            nSetOption:=nTarget
        Else
            nSetOption:=nSource
        EndIF
    EndIF
    nActFolder:=nSetOption

RETURN(lSetOption)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:GDToExcel
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:01/06/2013
        Descricao:Mostrar os Dados no Excel
        Sintaxe:StaticCall(NDJLIB001,GDToExcel,aHeader,aCols,cWorkSheet,cTable,lTotalize,lPicture)
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD GDToExcel(aHeader,aCols,cWorkSheet,cTable,lTotalize,lPicture) CLASS NDJLIB001
RETURN(GDToExcel(@aHeader,@aCols,@cWorkSheet,@cTable,@lTotalize,@lPicture))
STATIC FUNCTION GDToExcel(aHeader,aCols,cWorkSheet,cTable,lTotalize,lPicture)

    Local oFWMSExcel:=FWMSExcel():New()

    Local oMsExcel

    Local aCells

    Local cType
    Local cColumn

    Local cFile
    Local cFileTMP

    Local cPicture

    Local lTotal

    Local nRow
    Local nRows
    Local nField
    Local nFields

    Local nAlign
    Local nFormat

    Local uCell

    DEFAULT cWorkSheet:="GETDADOS"
    DEFAULT cTable:=cWorkSheet
    DEFAULT lTotalize:=.T.
    DEFAULT lPicture:=.F.

    BEGIN SEQUENCE

        oFWMSExcel:AddworkSheet(cWorkSheet)
        oFWMSExcel:AddTable(cWorkSheet,cTable)

        nFields:=Len(aHeader)
        For nField:=1 To nFields
            cType:=aHeader[nField][__AHEADER_TYPE__]
            nAlign:=IF(cType=="C",1,IF(cType=="N",3,2))
            nFormat:=IF(cType=="D",4,IF(cType=="N",2,1))
            cColumn:=aHeader[nField][__AHEADER_TITLE__]
            lTotal:=(lTotalize.and.cType=="N")
            oFWMSExcel:AddColumn(@cWorkSheet,@cTable,@cColumn,@nAlign,@nFormat,@lTotal)
        Next nField

        aCells:=Array(nFields)

        nRows:=Len(aCols)
        For nRow:=1 To nRows
            For nField:=1 To nFields
                uCell:=aCols[nRow][nField]
                IF (lPicture)
                    cPicture:=aHeader[nField][__AHEADER_PICTURE__]
                    IF (.NOT.(Empty(cPicture)))
                        uCell:=Transform(uCell,cPicture)
                    EndIF
                EndIF
                aCells[nField]:=uCell
            Next nField
            oFWMSExcel:AddRow(@cWorkSheet,@cTable,aClone(aCells))
        Next nRow

        oFWMSExcel:Activate()

        cFile:=(CriaTrab(NIL,.F.)+".xml")

        While File(cFile)
            cFile:=(CriaTrab(NIL,.F.)+".xml")
        End While

        oFWMSExcel:GetXMLFile(cFile)
        oFWMSExcel:DeActivate()

        IF (.NOT.(File(cFile)))
            cFile:=""
            BREAK
        EndIF

        cFileTMP:=(GetTempPath()+cFile)
        IF (.NOT.(__CopyFile(cFile,cFileTMP)))
            fErase(cFile)
            cFile:=""
            BREAK
        EndIF

        fErase(cFile)

        cFile:=cFileTMP

        IF (.NOT.(File(cFile)))
            cFile:=""
            BREAK
        EndIF

        IF (.NOT.(ApOleClient("MsExcel")))
            BREAK
        EndIF

        oMsExcel:=MsExcel():New()
        oMsExcel:WorkBooks:Open(cFile)
        oMsExcel:SetVisible(.T.)
        oMsExcel:=oMsExcel:Destroy()

    END SEQUENCE

    oFWMSExcel:=FreeObj(oFWMSExcel)

RETURN(cFile)

//--------------------------------------------------------------------------------------------------------------
    /*
        Funcao:dbQuery()
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:07/12/2013
        Descricao:Providenciar um Alias Valido para Abertura da View
        Sintaxe:StaticCall(NDJLIB001,dbQuery,xTAFdbQuery(adbQuery,cQuery,cAlias,lChgQuery,aDBMSConn,aSetField)
    */
//--------------------------------------------------------------------------------------------------------------
METHOD dbQuery(adbQuery,cQuery,cAlias,lChgQuery,aDBMSConn,aSetField) CLASS NDJLIB001
RETURN(dbQuery(@adbQuery,@cQuery,@cAlias,@lChgQuery,@aDBMSConn,@aSetField))
STATIC FUNCTION dbQuery(adbQuery,cQuery,cAlias,lChgQuery,aDBMSConn,aSetField)

    Local cNewAlias

    Local cFWDBKey
    Local lFWDBKey

    Local ldbQuery:=.F.

    Local nAliasAT

    Local lNewFWDB
    Local lFWDBACCESS:=.NOT.(Empty(aDBMSConn))

    Local oFWDBAccess

    DEFAULT adbQuery:=Array(0)
    DEFAULT cAlias:=GetNextAlias()

    nAliasAT:=aScan(adbQuery,{|e|(e[1]==cAlias)})
    IF nAliasAT==0
        aAdd(adbQuery,{cAlias,.F.,NIL,NIL})
        nAliasAT:=Len(adbQuery)
    EndIF

    DEFAULT lChgQuery:=.F.
    IF lChgQuery
        cQuery:=ChangeQuery(cQuery)
    EndIF

    IF lFWDBACCESS
        lNewFWDB:=.T.
        IF adbQuery[nAliasAT][2]
            IF (ValType(adbQuery[nAliasAT][3])=="O")
                IF (.NOT.(oNDJLIB029:Compare(adbQuery[nAliasAT][4],aDBMSConn)))
                    cAlias:=GetNextAlias()
                    aAdd(adbQuery,{cAlias,.F.,NIL,NIL})
                    nAliasAT:=Len(adbQuery)
                Else
                    lNewFWDB:=.F.
                    oFWDBAccess:=adbQuery[nAliasAT][3]
                EndIF
            Else
                adbQuery[nAliasAT][2]:=.F.
            EndIF
        EndIF
        IF Select(cAlias)>0
            (cAlias)->(dbCloseArea())
        EndIF
        IF lNewFWDB
            cFWDBKey:="@!!@"
            lFWDBKey:=.NOT.(SubStr(cFWDBKey,1,1)$aDBMSConn[1])
            oFWDBAccess:=FWDBAccess():New(IF(lFWDBKey,cFWDBKey,"")+aDBMSConn[1],aDBMSConn[2],aDBMSConn[3])
            oFWDBAccess:SetConsoleError(.T.)
        EndIF
        IF oFWDBAccess:HasConnection().or.oFWDBAccess:OpenConnection()
            cNewAlias:=oFWDBAccess:NewAlias(cQuery,cAlias,aSetField)
            IF (.NOT.(oFWDBAccess:HasError()))
                cAlias:=cNewAlias
                adbQuery[nAliasAT][1]:=cAlias
                IF (lNewFWDB)
                    adbQuery[nAliasAT][2]:=.T.
                    adbQuery[nAliasAT][3]:=oFWDBAccess
                    adbQuery[nAliasAT][4]:=aDBMSConn
                EndIF
            EndIF
        EndIF
    Else
        IF Select(cAlias)>0
            (cAlias)->(dbCloseArea())
        EndIF
        TCQUERY (cQuery) ALIAS (cAlias) NEW
        IF (.NOT.(aSetField==NIL))
            aEval(aSetField,{|e|TCSetField(cAlias,e[DBS_NAME],e[DBS_TYPE],e[DBS_LEN],e[DBS_DEC])})
        EndIF
    EndIF

    ldbQuery:=(Select(cAlias)>0.and..NOT.((cAlias)->(Eof())))

RETURN(ldbQuery)

//--------------------------------------------------------------------------------------------------------------
    /*
        Funcao:dbQueryClear()
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:07/12/2013
        Descricao:Limpar o Cache da dbQuery
        Sintaxe:StaticCall(NDJLIB001,dbQueryClear,adbQuery)
    */
//--------------------------------------------------------------------------------------------------------------
METHOD dbQueryClear(adbQuery) CLASS NDJLIB001
RETURN(dbQueryClear(@adbQuery))
STATIC FUNCTION dbQueryClear(adbQuery)
    Local cAlias
    Local nAlias
    Local nAliases
    IF (ValType(adbQuery)=="A")
        nAliases:=Len(adbQuery)
        For nAlias:=1 To nAliases
            cAlias:=adbQuery[nAlias][1]
            IF (Select(cAlias)>0)
                (cAlias)->(dbCloseArea())
            EndIF
            IF (adbQuery[nAlias][2])
                IF (ValType(adbQuery[nAlias][3])=="O")
                    IF (adbQuery[nAlias][3]:HasConnection())
                        adbQuery[nAlias][3]:CloseConnection()
                    EndIF
                    adbQuery[nAlias][3]:=FreeObj(adbQuery[nAlias][3])
                EndIF
            EndIF
        Next nAlias
        aSize(adbQuery,0)
    EndIF
RETURN(.T.)

//--------------------------------------------------------------------------------------------------------------
    /*
        Funcao:ProcRedefine()
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:07/12/2013
        Descricao:Redefine Dialog da tNewProcess ou MsNewProcess
        Sintaxe:StaticCall(NDJLIB001,ProcRedefine,oProcess,oFont,nLeft,nWidth,nCTLFLeft,lODlgF,lODlgW))
    */
//--------------------------------------------------------------------------------------------------------------
METHOD ProcRedefine(oProcess,oFont,nLeft,nWidth,nCTLFLeft,lODlgF,lODlgW) CLASS NDJLIB001
RETURN(ProcRedefine(@oProcess,@oFont,@nLeft,@nWidth,@nCTLFLeft,@lODlgF,@lODlgW))
STATIC FUNCTION ProcRedefine(oProcess,oFont,nLeft,nWidth,nCTLFLeft,lODlgF,lODlgW)
    Local aClassData
    Local laMeter
    Local nObj
    Local nMeter
    Local nMeters
    Local lProcRedefine:=.F.
    IF (ValType(oProcess)=="O")
        DEFAULT oFont:=TFont():New("Lucida Console",NIL,12,NIL,.T.)
        aClassData:=ClassDataArr(oProcess,.T.)
        laMeter:=(aScan(aClassData,{|e|e[1]=="AMETER"})>0)
        IF (laMeter)
            DEFAULT oFont:=TFont():New("Lucida Console",NIL,12,NIL,.T.)
            DEFAULT nLeft:=35
            DEFAULT nWidth:=35
            nMeters:=Len(oProcess:aMeter)
            For nMeter:=1 To nMeters
                For nObj:=1 To 2
                    oProcess:aMeter[nMeter][nObj]:oFont:=oFont
                    oProcess:aMeter[nMeter][nObj]:nWidth+=nWidth
                    oProcess:aMeter[nMeter][nObj]:nLeft-=nLeft
                Next nObj
            Next nMeter
        Else
            DEFAULT oFont:=TFont():New("Lucida Console",NIL,18,NIL,.T.)
            DEFAULT lODlgF:=.T.
            DEFAULT lODlgW:=.F.
            DEFAULT nLeft:=100
            DEFAULT nWidth:=200
            DEFAULT nCTLFLeft:=IF(lODlgW,nWidth,nWidth/2)
            IF (lODlgF)
                oProcess:oDlg:oFont:=oFont
            EndIF
            IF (lODlgW)
                oProcess:oDlg:nWidth+=nWidth
                oProcess:oDlg:nLeft-=(nWidth/2)
            EndIF
            oProcess:oMsg1:oFont:=oFont
            oProcess:oMsg2:oFont:=oFont
            oProcess:oMsg1:nLeft-=nLeft
            oProcess:oMsg1:nWidth+=nWidth
            oProcess:oMsg2:nLeft-=nLeft
            oProcess:oMsg2:nWidth+=nWidth
            oProcess:oMeter1:nWidth+=nWidth
            oProcess:oMeter1:nLeft-=nLeft
            oProcess:oMeter2:nWidth+=nWidth
            oProcess:oMeter2:nLeft-=nLeft
            IF (ValType(oProcess:oDlg:oCTLFocus)=="O")
                oProcess:oDlg:oCTLFocus:nLeft+=nCTLFLeft
            EndIF
            oProcess:oDlg:Refresh(.T.)
        EndIF
        lProcRedefine:=.T.
    EndIF
RETURN(lProcRedefine)

//--------------------------------------------------------------------------------------------------------------
    /*
        Funcao:GDCheckKey()
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:07/12/2013
        Descricao:Valida a Linha da GetDados (Baseada na Original da TOTVS)
        Sintaxe:StaticCall(NDJLIB001,GDCheckKey,aCpo,nModelo,aNoEmpty,cMsgAviso,lShowAviso))
    */
//--------------------------------------------------------------------------------------------------------------
METHOD GDCheckKey(aCpo,nModelo,aNoEmpty,cMsgAviso,lShowAviso) CLASS NDJLIB001
RETURN(GDCheckKey(@aCpo,@nModelo,@aNoEmpty,@cMsgAviso,@lShowAviso))
STATIC FUNCTION GDCheckKey(aCpo,nModelo,aNoEmpty,cMsgAviso,lShowAviso)

    Local aAux:={}
    Local aLinhas:={}
    Local aEmptys:={}
    Local aChkNoEmpty:={}

    Local cCRLF:=__cCRLF
    Local cEmptyString:=""

    Local lRet:=.T.
    Local lDuplic:=.F.
    Local lEmpty:=.F.
    Local lChkRow:=.T.
    Local lInAddLine:=IsInCallStack("ADDLINE")
    Local lGDDeleted:=.F.
    Local lChkDeleted:=.T.

    Local nLoop:=0
    Local nLoops:=Len(aCols)
    Local nLoop2:=0
    Local nPosAtu:=0
    Local nDuplic:=0
    Local nPosCampo:=0
    Local nGDDeleted:=GDFieldPos("GDDELETED")

    Local nAux
    Local nChkNoEmpty

    DEFAULT nModelo:=1
    DEFAULT aNoEmpty:={}
    DEFAULT lShowAviso:=.T.

    lGDDeleted:=(nGDDeleted>0)

    //----------------------------------------------------------------------------
        //Monta o array auxiliar com os campos a serem validados
    //----------------------------------------------------------------------------
    For nLoop:=1 To Len(aCpo)
        IF ((nPosCampo:=GDFieldPos(aCpo[nLoop]))==0)
            Loop
        EndIF
        aAdd(aAux,{aCpo[nLoop],nPosCampo,.F.})
    Next nLoop

    //----------------------------------------------------------------------------
        //Obtem o Total de Campos a serem Validados
    //----------------------------------------------------------------------------
    nAux:=Len(aAux)

    //----------------------------------------------------------------------------
        //Monta o array auxiliar com os campos a serem validados
    //----------------------------------------------------------------------------
    For nLoop:=1 To Len(aNoEmpty)
        IF ((nPosCampo:=GDFieldPos(aNoEmpty[nLoop]))==0)
            Loop
        EndIF
        aAdd(aChkNoEmpty,{aNoEmpty[nLoop],nPosCampo,.F.})
    Next nLoop

    //----------------------------------------------------------------------------
        //Obtem o Total de Campos a serem Validados
    //----------------------------------------------------------------------------
    nChkNoEmpty:=Len(aChkNoEmpty)

    //----------------------------------------------------------------------------
        //Ordena por posicao no acols
    //----------------------------------------------------------------------------
    aSort(aAux,NIL,NIL,{|x,y|y[2]>x[2]})
    aSort(aChkNoEmpty,NIL,NIL,{|x,y|y[2]>x[2]})

    //----------------------------------------------------------------------------
        //Percorre o acols para verificar as linhas duplicadas
    //----------------------------------------------------------------------------
    For nLoop:=1 To nLoops

        //----------------------------------------------------------------------------
            //Apenas para Linhas nao Deletadas
        //----------------------------------------------------------------------------
        lChkRow:=IF(lInAddLine,nLoop<nLoops,.T.)
        lChkDeleted:=(lGDDeleted.and.(Len(aCols[nLoop])>=nGDDeleted).and.(ValType(aCols[nLoop][nGDDeleted])=="L"))
        IF (lChkRow.and.IF(lChkDeleted,.NOT.(GDDeleted(nLoop)),.T.))

            //----------------------------------------------------------------------------
                //Considera a Validacao apenas quando a Linha nao for a Linha Atual
            //----------------------------------------------------------------------------
            IF (.NOT.((n==nLoop)))
                nDuplic:=0
                For nLoop2:=1 To nAux
                    //----------------------------------------------------------------------------
                        //Marca no array caso o campo esteja duplicado
                    //----------------------------------------------------------------------------
                    nPosAtu:=aAux[nLoop2][2]
                    aAux[nLoop2][3]:=(aCols[nLoop][nPosAtu]==aCols[n][nPosAtu])
                    //----------------------------------------------------------------------------
                        //Acumula Campos Duplicados
                    //----------------------------------------------------------------------------
                    IF (aAux[nLoop2][3])
                        ++nDuplic
                    EndIF
                Next nLoop2
                //----------------------------------------------------------------------------
                    //Se Todos os Elementos Estiverem Duplicados
                //----------------------------------------------------------------------------
                lDuplic:=(nDuplic==nAux)
            EndIF

            For nLoop2:=1 To nChkNoEmpty
               //----------------------------------------------------------------------------
                    //Marca no array caso o campo esteja Vazio
                //----------------------------------------------------------------------------
                nPosAtu:=aChkNoEmpty[nLoop2][2]
                aChkNoEmpty[nLoop2][3]:=Empty(aCols[nLoop][nPosAtu])
            Next nLoop2

            //----------------------------------------------------------------------------
                //Pesquisa algum campo que esteja vazio
            //----------------------------------------------------------------------------
            lEmpty:=.NOT.(Empty(aScan(aChkNoEmpty,{|x|x[3]})))

            IF ((lDuplic).or.(lEmpty))

                lRet:=.F.
                IF nModelo==4
                    IF (lDuplic)
                        aAdd(aLinhas,nLoop)
                    EndIF
                    IF (lEmpty)
                        aAdd(aEmptys,nLoop)
                    EndIF
                Else
                    Exit
                EndIF

            EndIF

            //----------------------------------------------------------------------------
                //Marca todos os campos como nao duplicados novamente
            //----------------------------------------------------------------------------
            IF (lDuplic)
                aEval(aAux,{|x|x[3]:=.F.})
            EndIF

            //----------------------------------------------------------------------------
                //Marca todos os campos como nao vazios novamente
            //----------------------------------------------------------------------------
            IF (lEmpty)
                aEval(aChkNoEmpty,{|x|x[3]:=.F.})
            EndIF

        EndIF

    Next nLoop

    IF (.NOT.(lRet).and.nModelo<>1)

        //----------------------------------------------------------------------------
            //Monta a mensagem conforme o modelo
        //----------------------------------------------------------------------------

        IF (lDuplic:=.NOT.(Empty(aLinhas)))
            cString:="A linha atual possui uma chave duplicada no browse."
        EndIF

        IF (lEmpty:=.NOT.(Empty(aEmptys)))
            cEmptyString:="A linha atual possui campo de Preenchimento Obrigatөo."
        EndIF

        IF nModelo==3.or.nModelo==4

            IF (lDuplic)

                cString+=cCRLF+"Campo(s):"

                For nLoop:=1 To nAux
                    cString+=aHeader[aAux[nLoop][2],1]+","
                Next nLoop

                cString:=Left(cString,Len(cString)-2)+"."

            EndIF

            IF (lEmpty)

                cEmptyString+=cCRLF+"Campo(s):"

                For nLoop:=1 To nChkNoEmpty
                    cEmptyString+=aHeader[aChkNoEmpty[nLoop][2],1]+","
                Next nLoop

                cEmptyString:=Left(cEmptyString,Len(cEmptyString)-2)+"."

            EndIF

            IF nModelo==4

                IF (lDuplic)

                    cString+=cCRLF+"Linha(s):"

                    For nLoop:=1 To Len(aLinhas)
                        cString+=AllTrim(Str(aLinhas[nLoop]))+","
                    Next nLoop

                    cString:=Left(cString,Len(cString)-2)+"."

                EndIF

                IF (lEmpty)

                    cEmptyString+=cCRLF+"Linha(s):"

                    For nLoop:=1 To Len(aEmptys)
                        cEmptyString+=AllTrim(Str(aEmptys[nLoop]))+","
                    Next nLoop

                    cEmptyString:=Left(cEmptyString,Len(cEmptyString)-2)+"."

                EndIF

            EndIF

        EndIF

        //----------------------------------------------------------------------------
            //Exibe a mensagem
        //----------------------------------------------------------------------------
        IF ((lDuplic).and.(lEmpty))
            cMsgAviso:=cString
            cMsgAviso+=cCRLF
            cMsgAviso+=cCRLF
            cMsgAviso+=cEmptyString
        ElseIF (lDuplic)
            cMsgAviso:=cString
        ElseIF (lEmpty)
            cMsgAviso:=cEmptyString
        EndIF
        IF (lShowAviso)
            Aviso("Atencao!",OemToAnsi(cMsgAviso),{"&"+"Ok"},2)
        EndIF

    EndIF

RETURN(lRet)

//-----------------------------------------------------------------------------------------------------
    /*
        Programa:NDJLIB001.prg
        Function:pt_Default
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:24/03/2015
    */
//-----------------------------------------------------------------------------------------------------
METHOD pt_Default(xVar,xDefault) CLASS NDJLIB001
RETURN(pt_Default(@xVar,@xDefault))
STATIC FUNCTION pt_Default(xVar,xDefault)
    DEFAULT xDefault:=NIL
RETURN(IF(Empty(xVar),xDefault,xVar))

//-----------------------------------------------------------------------------------------------------
    /*
        Programa:NDJLIB001.prg
        Function:pt_Normalize
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:24/03/2015
    */
//-----------------------------------------------------------------------------------------------------
METHOD pt_Normalize(cVal,cField,cSide,cPDValue) CLASS NDJLIB001
RETURN(pt_Normalize(@cVal,@cField,@cSide,@cPDValue))
STATIC FUNCTION pt_Normalize(cVal,cField,cSide,cPDValue)
    Local cNRet
    Local cPadF:="PAD"
    Local nTamP:=GetSx3Cache(cField,"X3_TAMANHO")
    DEFAULT cSide:="R"
    DEFAULT cPDValue:=" "
    cPadF+=cSide
    TRY EXCEPTION
        cNRet:=&cPadF.(@cVal,@nTamP,@cPDValue)
    CATCH EXCEPTION
        cNRet:=cVal
    END EXCEPTION
RETURN(cNRet)

//-----------------------------------------------------------------------------------------------------
/*
    Programa:NDJLIB001.prg
    Function:xGetIKValue
    Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
    Data:16/03/2015
*/
//-----------------------------------------------------------------------------------------------------
METHOD xGetIKValue(cAlias,cIKValue,cToken) CLASS NDJLIB001
RETURN(xGetIKValue(@cAlias,@cIKValue,@cToken))
STATIC FUNCTION xGetIKValue(cAlias,cIKValue,cToken)
    Local aKFields
    Local cValue
    Local cField
    Local xValue
    Local cFType
    Local nField
    TRY EXCEPTION
        xValue:=(cAlias)->(&cIKValue)
    CATCH EXCEPTION
        TRY EXCEPTION
            DEFAULT cToken:="+"
            cValue:=""
            aKFields:=_StrTokArr(@cIKValue,@cToken)
            nKFields:=Len(aKFields)
            For nField:=1 To nKFields
                cField:=aKFields[nField]
                xValue:=(cAlias)->(&cField)
                cFType:=ValType(xValue)
                DO CASE
                CASE (cFType=="D")
                    xValue:=DtoS(xValue)
                OTHERWISE
                    xValue:=cValToChar(xValue)
                END CASE
                cValue+=xValue
            Next nField
            xValue:=cValue
        CATCH EXCEPTION
            xValue:=NIL
        END EXCEPTION
    END EXCEPTION
RETURN(xValue)

//-----------------------------------------------------------------------------------------------------
    /*
        Programa:NDJLIB001.prg
        Function:xGetOrder
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:16/03/2015
    */
//-----------------------------------------------------------------------------------------------------
METHOD xGetOrder(cAlias,cIKValue) CLASS NDJLIB001
RETURN(xGetOrder(@cAlias,@cIKValue))
STATIC FUNCTION xGetOrder(cAlias,cIKValue)
    Local nOrder
    //-----------------------------------------------------------------------------------------------------
    //Obtem a Chave Unica para a Tabela em Questao
    DEFAULT cIKValue:=GetSx2Unico(@cAlias)
    //-----------------------------------------------------------------------------------------------------
    //Verifica se Existe INDEX Correspondente...
    nOrder:=RetOrder(@cAlias,@cIKValue,.T.)
    //-----------------------------------------------------------------------------------------------------
    //...Se nao encontrou....
    IF (nOrder==0)
        //-----------------------------------------------------------------------------------------------------
        //...Transforma X2_UNICO em uma Expressao Valida
        cIKValue:=X2Unique2Index(@cAlias)
        //-----------------------------------------------------------------------------------------------------
        //Verifica se Existe INDEX Correspondente...
        nOrder:=RetOrder(@cAlias,@cIKValue,.T.)
        //-----------------------------------------------------------------------------------------------------
        //...Se nao encontrou....
        IF (nOrder==0)
            //-----------------------------------------------------------------------------------------------------
            //...Assume a Ordem 1
            nOrder:=1
            (cAlias)->(dbSetOrder(nOrder))
            //-----------------------------------------------------------------------------------------------------
            //...Considera a chave como a Expressao de Indice Corrente
            cIKValue:=(cAlias)->(IndexKey())
        EndIF
    EndIF
RETURN(nOrder)

//-----------------------------------------------------------------------------------------------------
    /*
        Programa:NDJLIB001.prg
        Function:xGetOrder
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:16/03/2015
    */
//-----------------------------------------------------------------------------------------------------
METHOD GetToken(cTokenStr) CLASS NDJLIB001
RETURN(GetToken(@cTokenStr))
Static Function GetToken(cTokenStr)
    Local aTokens:={"!","@","#","$","%","&","*","(",")","-","_","+","=","`","´","{","}","[","]","^","~","|","<",",",">",".",":",";","?","\","/",PONTO_E_VIRGULA}
    Local cToken
    Local nToken
    Local nTokens
    DEFAULT cTokenStr:=""
    nTokens:=Len(aTokens)
    For nToken:=1 To nTokens
        IF (aTokens[nToken]$cTokenStr)
            cToken:=aTokens[nToken]
            Exit
        EndIF
    Next nToken
    DEFAULT cToken:=""
RETURN(cToken)

//-----------------------------------------------------------------------------------------------------
    /*
        Programa:NDJLIB001.prg
        Function:xGetOrder
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:16/03/2015
    */
//-----------------------------------------------------------------------------------------------------
METHOD X3VldFields(aFields,aData,bX3ErrorVld,lVldEmpty,lInitPad) CLASS NDJLIB001
    Parameter aFields       AS ARRAY
    Parameter aData         AS ARRAY
    Parameter bX3ErrorVld   AS BLOCK
    Parameter lVldEmpty     AS LOGICAL
    Parameter lInitPad      AS LOGICAL
RETURN(X3VldFields(@aFields,@aData,@bX3ErrorVld,@lVldEmpty,@lInitPad))
Static Function X3VldFields(aFields AS ARRAY,aData AS ARRAY,bX3ErrorVld AS BLOCK,lVldEmpty AS LOGICAL,lInitPad AS LOGICAL)

    local aValid            AS ARRAY

    local bError            AS BLOCK
    local bErrorBlock       AS BLOCK

    local cField            AS CHARACTER
    local cMemVar           AS CHARACTER
    local cX3Valid          AS CHARACTER
    local cX3VldUser        AS CHARACTER
    local cX3Relacao        AS CHARACTER
    local cValidField       AS CHARACTER

    local lX3Valid          AS LOGICAL
    local lX3Obrigat        AS LOGICAL
    local lX3Relacao        AS LOGICAL
    local lHelpInDark       AS LOGICAL
    local lX3ErrorVld       AS LOGICAL

    local lSetOwnerPrvt     AS LOGICAL
    local lForceSetOwner    AS LOGICAL

    local nField            AS INTEGER
    local nFields           AS INTEGER

    local xValue

    DEFAULT lVldEmpty:=.T.
    DEFAULT lX3Relacao:=.F.
    DEFAULT lX3ErrorVld:=(ValType(bX3ErrorVld)=="B")

    nFields:=Len(aFields)

    for nField:=1 to nFields
        cField:=aFields[nField]
        cMemVar:=("M->"+cField)
        lSetOwnerPrvt:=.not.(IsMemVar(@cMemVar))
        lForceSetOwner:=(lInitPad:=(lSetOwnerPrvt))
        xValue:=aData[nField]
        SetMemVar(@cMemVar,@xValue,@lSetOwnerPrvt,@lForceSetOwner,NIL,@lInitPad)
    next nField

    aValid:=Array(nFields)
    aFill(aValid,.T.)

    bError:={|e|BREAK(e)}
    bErrorBlock:=ErrorBlock(bError)
    lHelpInDark:=HelpInDark(.T.)

    lInitPad:=.F.
    lSetOwnerPrvt:=.F.
    lForceSetOwner:=.F.

    for nField:=1 to nFields
        cField:=aFields[nField]
        cMemVar:=("M->"+cField)
        __ReadVar:=cMemVar
        if (lInitPad)
            cX3Relacao:=Alltrim(GetSx3Cache(cField,"X3_RELACAO"))
            lX3Relacao:=(.not.(Empty(cX3Relacao)).and.Empty(GetMemVar(@cMemVar)))
        endif
        if ((lInitPad).and.(lX3Relacao))
            lX3Relacao:=.F.
            begin sequence
                xValue:=&(cX3Relacao)
                lX3Relacao:=.T.
            end sequence
            if (lX3Relacao)
                aData[nField]:=xValue
                SetMemVar(@cMemVar,@xValue,@lSetOwnerPrvt,@lForceSetOwner,NIL,@lInitPad)
            endif
        endif
        lX3Obrigat:=X3Obrigat(cField)
        if (.not.(lX3Obrigat))
            if (.not.(lVldEmpty))
                if Empty(GetMemVar(@cMemVar))
                    loop
                endif
            endif
        endif
        cX3Valid:=AllTrim(GetSx3Cache(cField,"X3_VALID"))
        cX3VldUser:=Alltrim(GetSx3Cache(cField,"X3_VLDUSER"))
        cValidField:="AllWaysTrue()"
        if Empty(cX3Valid)
            if (.not.(Empty(cX3VldUser)))
                cValidField:=cX3VldUser
            endif
        else
            if Empty(cX3VldUser)
                cValidField:=cX3Valid
            else
                cValidField:=(cX3VldUser+".and."+cX3Valid)
            endif
        endif
        lX3Valid:=.T.
        begin sequence
            lX3Valid:=&(cValidField)
        end sequence
        DEFAULT lX3Valid:=.F.
        if (.not.(ValType(lX3Valid)=="L"))
            lX3Valid:=.F.
        endif
        aValid[nField]:=lX3Valid
        if ((lX3ErrorVld).and.(.not.(lX3Valid)))
            Eval(@bX3ErrorVld,@aFields,@aData,@lX3Valid,@cField,@aData[nField],@cValidField,@lX3Obrigat)
        endif
    next nField

    lX3Valid:=(aScan(aValid,.F.)==0)

    ErrorBlock(bErrorBlock)
    HelpInDark(@lHelpInDark)

Return(lX3Valid)

#include "tryexception.ch"
