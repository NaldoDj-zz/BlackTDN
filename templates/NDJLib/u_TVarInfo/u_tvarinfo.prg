#include "totvs.ch"
#include "shell.ch"
#include "fileio.ch"

#DEFINE STACK_NAME          1
#DEFINE STACK_PARAMETER     2

#DEFINE STACK_ELEMENTS      2

#DEFINE CLS_NAME            1

Static __cClassName:="[TVarInfo][cClassName]"

Static __nClsIntSleep:=0
Static __nClsAddSleep:=0
Static __nClsNIntSleep:=0
Static __nClsVAddSleep:=0

//------------------------------------------------------------------------------------------------
   /*/
        Class:TVarInfo [Baseada na Ideia Original de Julio [AUTOMAN] Wittwer]
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:28/09/2011
        Descricao:Reproduz as Caracteristicas da Funcao VarInfo resolvendo a Limitacao do Tamanho da String
        Sintaxe:TVarInfo():New(uVarInfo,cVarName,nClsIntSleep,@nClsAddSleep)
   /*/
//------------------------------------------------------------------------------------------------
Class TVarInfo From LongClassName

    DATA aTVarInfo

    DATA cClassName

    DATA nAT
    DATA nSize

    DATA cCRLF
    DATA cSRVFile
    DATA cLocalFile
    DATA cLocalPath

    DATA lBof
    DATA lEof

    DATA lEcho

    DATA cDateFormat
    DATA lSetCentury

    DATA nfHandle

    Method New(uVarInfo,cVarName,nClsIntSleep,nClsAddSleep) CONSTRUCTOR
    Method FreeObj()/*DESTRUCTOR*/
    Method ClassName()

    Method Init(uVarInfo,cVarName,nClsIntSleep,nClsAddSleep)
    Method Reset(uVarInfo,cVarName,lEraseSrv,lEraseLocal)

    Method Echo(lHtml,lTableFormat)
    Method Show(nSWShow,lHtml,lTableFormat)

    Method Save(lHtml,lTableFormat)

    Method GoTo(n)
    Method GoTop()
    Method GoBottom()
    Method GoNext()

    Method Close(lEraseSrv,lEraseLocal)

End Class


//------------------------------------------------------------------------------------------------
   /*/
        Funcao:U_TVarInfoNew
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:28/09/2011
        Descricao:Reproduz as Caracteristicas da Funcao VarInfo resolvendo a Limitacao do Tamanho da String
        Sintaxe:U_TVarInfoNew(uVarInfo,cVarName)
   /*/
//------------------------------------------------------------------------------------------------
User Function TVarInfoNew(uVarInfo,cVarName,nClsIntSleep,nClsAddSleep)
Return(TVarInfo():New(@uVarInfo,@cVarName,@nClsIntSleep,@nClsAddSleep))

//------------------------------------------------------------------------------------------------
   /*/
        Method:New
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:28/09/2011
        Descricao:Constructor
        Sintaxe:TVarInfo():New(uVarInfo,cVarName,nClsIntSleep,nClsAddSleep)
   /*/
//------------------------------------------------------------------------------------------------
Method New(uVarInfo,cVarName,nClsIntSleep,nClsAddSleep) Class TVarInfo
    self:ClassName()
    self:Init(@uVarInfo,@cVarName,@nClsIntSleep,@nClsAddSleep)
Return(self)

//------------------------------------------------------------------------------------------------
   /*/
        Method:ClassName
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:28/09/2011
        Descricao:Retorna o nome da Classe
        Sintaxe:TVarInfo():New(uVarInfo,cVarName,nClsIntSleep,nClsAddSleep)
   /*/
//------------------------------------------------------------------------------------------------
Method ClassName() Class TVarInfo
    self:cClassName:="TVARINFO"
Return(self:cClassName)

/*/
    Method:Init
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:28/09/2011
    Descricao:Inicializa
/*/
Method Init(uVarInfo,cVarName,nClsIntSleep,nClsAddSleep) Class TVarInfo

    Local aStackA:=Array(0)
    Local aStackO:=Array(0)

    Local cVarType

    Local nStackA:=0
    Local nStackO:=0

    IF (cVarName==NIL)
        cVarType:=ValType(uVarInfo)
        DO CASE
        CASE (cVarType=="A")
            cVarName:="[VAR_ARRAY]"
        CASE (cVarType=="C")
            cVarName:="[VAR_STRING]"
        CASE (cVarType=="D")
            cVarName:="[VAR_DATE]"
        CASE (cVarType=="O")
            cVarName:="[VAR_OBJECT]"
        CASE (cVarType=="L")
            cVarName:="[VAR_BOOLEAN]"
        CASE (cVarType=="N")
            cVarName:="[VAR_NUMERIC]"
        CASE (cVarType=="U")
            cVarName:="[VAR_NOTSET]"
        OTHERWISE
            cVarName:="[VAR_"+cVarType+"]"
        ENDCASE
    EndIF

    self:ClassName()
    self:aTVarInfo:=Array(0)
    self:cSRVFile:=""
    self:cLocalFile:=""
    self:cLocalPath:=""
    self:nfHandle:=-1
    self:lSetCentury:=__SetCentury("ON")
    self:cDateFormat:=Set(4,"dd/mm/yyyy")

    DEFAULT self:cCRLF:=CRLF

    /*
        [TVARINFO]
        ClsIntSleep=5;Valor Inicial na Ocorrencia da Exception. Incremente em 5
        ClsAddSleep=1;Valor Inicial na Ocorrencia da Exception. Incremente em 1
    */
    DEFAULT nClsIntSleep:=Val(GetPvProfString("TVARINFO","ClsIntSleep","0",GetSrvIniName()))
    DEFAULT nClsAddSleep:=Val(GetPvProfString("TVARINFO","ClsAddSleep","0",GetSrvIniName()))

    __nClsIntSleep:=nClsIntSleep
    __nClsAddSleep:=nClsAddSleep
    __nClsNIntSleep:=Int(__nClsIntSleep/2)
    __nClsVAddSleep:=0

    TVarInfo(@self:aTVarInfo,@aStackA,@nStackA,@aStackO,@nStackO,@cVarName,@uVarInfo)

    nStackA:=0
    aSize(aStackA,nStackA)
    nStackO:=0
    aSize(aStackO,nStackO)

    self:nSize:=Len(self:aTVarInfo)

    IF (self:nSize>0)
        self:nAT:=1
        self:lBof:=.F.
        self:lEof:=.F.
    Else
        self:nAT:=0
        self:lBof:=.T.
        self:lEof:=.T.
    EndIF

    DEFAULT self:lEcho:=.F.

Return(self)

//------------------------------------------------------------------------------------------------
   /*/
        Method:ReSet
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:28/09/2011
        Descricao:ReSet
   /*/
//------------------------------------------------------------------------------------------------
Method ReSet(uVarInfo,cVarName,lEraseSrv,lEraseLocal) Class TVarInfo
    self:Close(@lEraseSrv,@lEraseLocal)
    self:Init(@uVarInfo,@cVarName)
Return(self)

//------------------------------------------------------------------------------------------------
   /*/
        Method:GoTo
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:28/09/2011
        Descricao:Posiciona no Registro n
   /*/
//------------------------------------------------------------------------------------------------
Method GoTo(n) Class TVarInfo
    DEFAULT n:=0
Return(self:nAT:=n)

//------------------------------------------------------------------------------------------------
   /*/
        Method:GoTop
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:28/09/2011
        Descricao:GoTop
   /*/
//------------------------------------------------------------------------------------------------
Method GoTop() Class TVarInfo
Return(self:nAT:=Min(1,self:nSize))

//------------------------------------------------------------------------------------------------
   /*/
        Method:GoBottom
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:28/09/2011
        Descricao:GoBottom
   /*/
//------------------------------------------------------------------------------------------------
Method GoBottom() Class TVarInfo
Return(self:nAT:=self:nSize)

//------------------------------------------------------------------------------------------------
   /*/
        Method:GoNext
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:28/09/2011
        Descricao:Tenta Obter o Proximo Registro
   /*/
//------------------------------------------------------------------------------------------------
Method GoNext() Class TVarInfo

    Local lGoNext:=.F.

    IF (self:nSize>0)

        ++self:nAT

        self:lBof:=(self:nAT<=0)
        self:lEof:=(self:nAT>self:nSize)

        lGoNext:=.NOT.(self:lBof.or.self:lEof)

        IF .NOT.(lGoNext)
            self:nAT:=1
            self:lBof:=.F.
            self:lEof:=.F.
        EndIF

    Else

        self:nAT:=0
        self:lBof:=.T.
        self:lEof:=.T.

    EndIF

Return(lGoNext)

//------------------------------------------------------------------------------------------------
   /*/
        Method:Echo
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:28/09/2011
        Descricao:Retorna a Linha Atual
   /*/
//------------------------------------------------------------------------------------------------
Method Echo(lHtml,lTableFormat) Class TVarInfo

    Local cEcho:=""

    DEFAULT lHtml:=.F.
    DEFAULT lTableFormat:=.F.

    IF (self:nAT>0.and.self:nAT<=self:nSize)
        IF (lHtml)
            IF (self:nAT==1)
                cEcho+="<html>"+self:cCRLF
                cEcho+="   <head>"+self:cCRLF
                cEcho+="   </head>"+self:cCRLF
                cEcho+="   <body>"+self:cCRLF
                IF (lTableFormat)
                    cEcho+="       <table border='0'>"+self:cCRLF
                    cEcho+="           <thead>"+self:cCRLF
                    cEcho+="               <tr>"+self:cCRLF
                    cEcho+="                   <th>"+self:cCRLF
                    cEcho+="                   </th>"+self:cCRLF
                    cEcho+="               </tr>"+self:cCRLF
                    cEcho+="           </thead>"+self:cCRLF
                    cEcho+="           <tfoot>"+self:cCRLF
                    cEcho+="           </tfoot>"+self:cCRLF
                    cEcho+="           <tbody>"+self:cCRLF
                Else
                    cEcho+="       <pre>"+self:cCRLF
                EndIF
            EndIF
            IF (lTableFormat)
                cEcho+="               <tr>"+self:cCRLF
                cEcho+="                   <td>"+self:cCRLF
                cEcho+="                       <pre>"+self:cCRLF
            EndIF
            cEcho+=self:aTVarInfo[self:nAT]+self:cCRLF
            IF (lTableFormat)
                cEcho+="                       </pre>"+self:cCRLF
                cEcho+="                   </td>"+self:cCRLF
                cEcho+="               </tr>"+self:cCRLF
            EndIF
            IF (self:nAT==self:nSize)
                IF (lTableFormat)
                    cEcho+="           </tbody>"+self:cCRLF
                    cEcho+="       </table>"+self:cCRLF
                Else
                    cEcho+="       </pre>"+self:cCRLF
                EndIF
                cEcho+="   </body>"+self:cCRLF
                cEcho+="</html>"+self:cCRLF
            EndIF
        Else
            cEcho+=self:aTVarInfo[self:nAT]
            cEcho+=self:cCRLF
        EndIF
    EndIF

    IF (self:lEcho)
        ConOut(cEcho)
    EndIF

Return(cEcho)

//------------------------------------------------------------------------------------------------
   /*/
        Method:Show
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:28/09/2011
        Descricao:Apresenta o Conteudo obtido pela VarInfo
   /*/
//------------------------------------------------------------------------------------------------
Method Show(nSWShow,lHtml,lTableFormat) Class TVarInfo

    Local lShow:=.F.

    IF (self:nfHandle<0)
        self:Save(@lHtml,@lTableFormat)
    EndIF

    IF (;
            (self:nfHandle>=0);
            .and.;
            File(self:cSRVFile);
       )

        self:cLocalPath:=GetTempPath()

        IF .NOT.(SubStr(self:cLocalPath,-1)=="\")
            self:cLocalPath+="\"
        EndIF

        self:cLocalFile:=(self:cLocalPath+self:cSRVFile)

        lShow:=__CopyFile(self:cSRVFile,self:cLocalFile)
        IF .NOT.(self:lEcho)
            IF (lShow)
                DEFAULT nSWShow:=SW_SHOWMAXIMIZED
                ShellExecute("Open",self:cLocalFile,"",self:cLocalPath,nSWShow)
            EndIF
        EndIF

    EndIF

Return(lShow)

//------------------------------------------------------------------------------------------------
   /*/
        Method:Save
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:28/09/2011
        Descricao:Salva o Conteudo Obtivo pela VarInfo
   /*/
//------------------------------------------------------------------------------------------------
Method Save(lHtml,lTableFormat) Class TVarInfo

    Local cExt
    Local cEcho

    Local lSave:=.F.

    DEFAULT lHtml:=.F.
    IF (lHtml)
        cExt:=".html"
    Else
        cExt:=".txt"
    EndIF

    self:cSRVFile:=(Lower(CriaTrab(NIL,.F.))+cExt)
    While File(self:cSRVFile)
        self:cSRVFile:=(Lower(CriaTrab(NIL,.F.))+cExt)
    End While

    self:nfHandle:=fCreate(self:cSRVFile,FC_NORMAL)
    IF ((fError()==0).and.File(self:cSRVFile))
        fClose(self:nfHandle)
        self:nfHandle:=fOpen(self:cSRVFile,FO_READWRITE)
        IF (fError()==0)
            cEcho:=self:Echo(@lHtml,@lTableFormat)
            fWrite(self:nfHandle,cEcho)
            While (self:GoNext())
                cEcho:=self:Echo(@lHtml,@lTableFormat)
                fWrite(self:nfHandle,cEcho)
            End While
            fClose(self:nfHandle)
            self:nfHandle:=fOpen(self:cSRVFile,FO_SHARED)
            lSave:=(fError()==0)
        EndIF
    EndIF

Return(lSave)

//------------------------------------------------------------------------------------------------
   /*/
        Method:Close
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:28/09/2011
        Descricao:Fecha e exclui os arquivos utilizados
   /*/
//------------------------------------------------------------------------------------------------
Method Close(lEraseSrv,lEraseLocal) Class TVarInfo

    DEFAULT lEraseSrv:=.T.
    DEFAULT lEraseLocal:=.T.

    IF (self:nfHandle>=0)
        fClose(self:nfHandle)
        self:nfHandle:=-1
    EndIF

    IF .NOT.(Empty(self:cSRVFile))
        IF (lEraseSrv)
            fErase(self:cSRVFile)
        EndIF
        self:cSRVFile:=""
    EndIF

    IF .NOT.(Empty(self:cLocalFile))
        IF (lEraseLocal)
            fErase(self:cLocalFile)
        EndIF
        self:cLocalFile:=""
    EndIF

    self:cLocalPath:=""

    aSize(self:aTVarInfo,0)
    self:nAT:=0

    self:lBof:=.T.
    self:lEof:=.T.

    self:cCRLF:=NIL

    Set(4,self:cDateFormat)

    IF .NOT.(self:lSetCentury)
        __SetCentury("OFF")
    EndIF

Return(self)

Method FreeObj(lEraseSrv,lEraseLocal) Class TVarInfo
    self:Close(@lEraseSrv,@lEraseLocal)
    self:=FreeObj(self)
Return(self)

/*/
    Funcao:TVarInfo
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:28/09/2011
    Descricao:Obtem o Conteudo de uma variavel passada por parametro
/*/
Static Function TVarInfo(aTVarInfo,aStackA,nStackA,aStackO,nStackO,cVarName,uVarInfo,nNivel,cClassName)

    Local cTab:=""
    Local cNStr:=""
    Local cLine:=""
    Local cVar:=""
    Local cVarType:=ValType(uVarInfo)

    Local lStack
    Local lClone
    Local lPointer

    Local nD
    Local nJ
    Local nVar

    Local nStack:=0

    Local uVar

    DEFAULT nNivel:=0

    BEGIN SEQUENCE

        IF (cVarType=="O")

            ++nNivel

            TRY EXCEPTION
                cClassName:=uVarInfo:ClassName()
            CATCH EXCEPTION
                cClassName:=GetClassName(uVarInfo)
            END EXCETION

            nStack:=aScanX(aStackO,{|aStk,nAT|aStackO[nAT][STACK_PARAMETER]==uVarInfo})
            lStack:=(nStack>0)
            lPointer:=lStack

            if !(lPointer)

                nStack:=aScanX(aStackO,{|aStk,nAT|compare(aStackO[nAT][STACK_PARAMETER],uVarInfo)})
                lStack:=(nStack>0)

                lClone:=lStack

                if (lClone)

                    cTab:=Space(nNivel*5)

                    cLine+=cTab
                    cLine+=cVarName
                    cLine+=" ->OBJECT ("
                    cLine+=cClassName
                    cLine+=") "
                    cLine+="[CLONE OF "
                    cLine+=aStackO[nStack][STACK_NAME]
                    cLine+="]"

                    aAdd(aTVarInfo,cLine)

                    BREAK

                EndIF

            endif

            IF (lPointer)

                cTab:=Space(nNivel*5)

                cLine+=cTab
                cLine+=cVarName
                cLine+=" ->OBJECT ("
                cLine+=cClassName
                cLine+=") "
                cLine+="[POINTER OF "
                cLine+=aStackO[nStack][STACK_NAME]
                cLine+="]"

                aAdd(aTVarInfo,cLine)

                BREAK

            EndIF

            /*
                Exception code:C0000005 ACCESS_VIOLATION
                Access Violation tInterFunctionCall on TVARINFO(U_TVARINFO.PRG)
                BEGIN Isto "minimiza" a ocorrencia da Exception
            */
                __nClsVAddSleep+=__nClsAddSleep
                IF (__cClassName==cClassName)
                    Sleep(__nClsIntSleep+__nClsVAddSleep)
                Else
                    __cClassName:=cClassName
                    Sleep(__nClsNIntSleep)
                EndIF
            /*
                END Isto "minimiza" a ocorrencia da Exception
                Exception code:C0000005 ACCESS_VIOLATION
                Access Violation tInterFunctionCall on TVARINFO(U_TVARINFO.PRG)
            */

            aAdd(aStackO,Array(STACK_ELEMENTS))

            nStack:=++nStackO
            aStackO[nStack][STACK_NAME]:=cVarName
            aStackO[nStack][STACK_PARAMETER]:=uVarInfo

            cTab:=Space(nNivel*5)

            cLine+=cTab
            cLine+=cVarName
            cLine+=" ->OBJECT ("
            cLine+=cClassName
            cLine+=") "

            aAdd(aTVarInfo,cLine)

            TVarInfo(@aTVarInfo,@aStackA,@nStackA,@aStackO,@nStackO,cVarName,ClassDataArray(uVarInfo,.T.),nNivel,@cClassName)

        ElseIF (cVarType=="A")

            cTab:=Space(nNivel*5)
            nJ:=Len(uVarInfo)
            cNStr:=Transform(nJ,RetPictVal(nJ))

            nStack:=aScanX(aStackA,{|aStk,nAT|aStackA[nAT][STACK_PARAMETER]==uVarInfo})
            lStack:=(nStack>0)

<<<<<<< HEAD
            IF (lStack)
=======
            lPointer:=lStack

            if !(lPointer)

                nStack:=aScanX(aStackA,{|aStk,nAT|compare(aStackA[nAT][STACK_PARAMETER],uVarInfo)})
                lStack:=(nStack>0)

                lClone:=lStack

            endif

            IF (lPointer)

                cLine+=cTab
                cLine+=cVarName
                cLine+=" ->ARRAY ("
                cLine+=cNStr
                cLine+=") "
                cLine+="[POINTER OF "
                cLine+=aStackA[nStack][STACK_NAME]
                cLine+="]"

            ElseIF (lClone)
>>>>>>> 5c8d1fd7a6b3c862c1d7b062f9075d735bb7affb

                cLine+=cTab
                cLine+=cVarName
                cLine+=" ->ARRAY ("
                cLine+=cNStr
                cLine+=") "
                cLine+="[CLONE OF "
                cLine+=aStackA[nStack][STACK_NAME]
                cLine+="]"

<<<<<<< HEAD
=======

>>>>>>> 5c8d1fd7a6b3c862c1d7b062f9075d735bb7affb
            Else

                aAdd(aStackA,Array(STACK_ELEMENTS))

                nStack:=++nStackA
                aStackA[nStack][STACK_NAME]:=cVarName
                aStackA[nStack][STACK_PARAMETER]:=uVarInfo

                cLine+=cTab
                cLine+=cVarName
                cLine+=" ->ARRAY ("
                cLine+=cNStr
                cLine+=") [...]"

            EndIF

            aAdd(aTVarInfo,cLine)

            ++nNivel

            For nD:=1 To nJ
                cNStr:=Transform(nD,RetPictVal(nD))
                uVar:=uVarInfo[nD]
                TVarInfo(@aTVarInfo,@aStackA,@nStackA,@aStackO,@nStackO,cVarName+"["+cNStr+"]",@uVar,nNivel,@cClassName)
                uVar:=NIL
            Next nD

        Else

            cVar:=AllToChar(uVarInfo,cVarType)

            cTab:=Space(nNivel*5)

            nVar:=Len(cVar)

            cLine+=cTab
            cLine+=cVarName
            cLine+=" ->"
            cLine+=cVarType
            cLine+=" ("
            cLine+=Transform(nVar,RetPictVal(nVar))
            cLine+=") "
            cLine+="["
            cLine+=cVar
            cLine+="]"

            aAdd(aTVarInfo,cLine)

        EndIF

    END SEQUENCE

Return(NIL)

/*/
    Funcao:AllToChar
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:28/09/2011
    Descricao:AllToChar
/*/
Static Function AllToChar(uVarInfo,cVarType,cPicture)

    Local cVar

    DO CASE
    CASE (cVarType=="N")
        IF Empty(cPicture)
            cPicture:=RetPictVal(uVarInfo,.T.)
        EndIF
        cVar:=Transform(uVarInfo,AllTrim(cPicture))
    CASE (cVarType=="C")
        DEFAULT cPicture:=""
        IF .NOT.(Empty(cPicture))
            cVar:=Transform(uVarInfo,AllTrim(cPicture))
        Else
            cVar:=uVarInfo
        EndIF
    CASE (cVarType=="L")
        cVar:=IF(uVarInfo,".T.",".F.")
    CASE (cVarType=="D")
        cVar:=DToC(uVarInfo)
    CASE (cVarType=="B")
        cVar:=GetCbSource(uVarInfo)
    CASE (cVarType=="O")
        cVar:="[OJBECT][...]"
    OTHERWISE
        cVar:=""
    ENDCASE

Return(cVar)

/*/
    Funcao:RetPictVal
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:28/09/2011
    Descricao:Retorna a Picture para Campo Numerico Conforme Valor
    Sitantxe:RetPictVal(nVal,lDecZero,nInt,nDec,lPictSepMil)
/*/
Static Function RetPictVal(nVal,lDecZero,nInt,nDec,lPictSepMil)

    Local cPict
    Local cPictSepMil

    Local uInt
    Local uDec

    IF (ValType(nVal)=="N")
        uInt:=Int(nVal)
        uDec:=(nVal -uInt)
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
                For uInt:=nInt To 1 Step -3
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

Return(cPict)

#include "tryexception.ch"
