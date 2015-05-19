#include "totvs.ch"
#xtranslate NToS([<n,...>])=>LTrim(Str([<n>]))
//------------------------------------------------------------------------------------------------
    /*/
        Class:ArrayUtils
        Autor:Marinaldo de Jesus
        Data:09/04/2015
    /*/
//------------------------------------------------------------------------------------------------
CLASS ArrayUtils
    DATA cATDiff
    DATA nError
    DATA nZipMod
    DATA cZipPwd
    METHOD NEW() CONSTRUCTOR
    METHOD FreeObj() /*DESTRUCTOR*/
    METHOD ClassName()
    METHOD Compare(uCompare1,uCompare2)
    METHOD SaveArray(uArray,cFileName)
    METHOD RestArray(cFileName)
    METHOD Load4Str(cFileName)
    METHOD SetZipMod(nZipMod,cZipPwd)
    METHOD SetZipPdw(cZipPwd)
ENDCLASS

User Function ArrayUtils()
Return(ArrayUtils():New())

METHOD NEW() CLASS ArrayUtils
    self:nError:=0
    self:cATDiff:=""
    self:nZipMod:=-1
    self:cZipPwd:=""
RETURN(self)

METHOD FreeObj() CLASS ArrayUtils
    self:=FreeObj(self)
RETURN(self)

METHOD ClassName() CLASS ArrayUtils
Return("ARRAYUTILS")

METHOD Compare(uCompare1,uCompare2) CLASS ArrayUtils
    Local lCompare
    self:cATDiff:=""
    lCompare:=Compare(@uCompare1,@uCompare2,@self:cATDiff)
RETURN(lCompare)

METHOD SaveArray(uArray,cFileName) CLASS ArrayUtils
    Local aFZip
    Local cfZip
    Local cbZip
    Local cfExt
    Local cfPath
    Local cfName
    Local cfDrive
    Local cbUnZip
    Local lSaveArray
    Local nbZip
    Local nbUnZip
    self:nError:=0
    lSaveArray:=SaveArray(@uArray,@cFileName,@self:nError)
    IF ((lSaveArray).and.(self:nZipMod>=0))
        SplitPath(cFileName,@cfDrive,@cfPath,@cfName,@cfExt)
        cfZip:=StrTran(cFileName,cfExt,IF((self:nZipMod==0),".cmp",IF((self:nZipMod==2),".zip",".mzp")))
        cfPath:=(cfDrive+cfPath)
        IF (self:nZipMod==2)
            aFZip:={cFileName}
            IF .NOT.(Empty(self:cZipPwd))
                self:nError:=FZip(@cfZip,@aFZip,@cfPath,@self:cZipPwd)
            Else
                self:nError:=FZip(@cfZip,@aFZip,@cfPath)
            EndIF
            lSaveArray:=(self:nError==0)
        ElseIF (self:nZipMod==1)
            IF .NOT.(Empty(self:cZipPwd))
                lSaveArray:=(cfZip$MsCompress(@cFileName,@cfZip,@self:cZipPwd))
            Else
                lSaveArray:=(cfZip$MsCompress(@cFileName,@cfZip))
            EndIF            
            IF .NOT.(lSaveArray)
                self:nError:=-1
            EndIF
        Else  
            cbUnZip:=self:Load4Str(cFileName)
            nbUnZip:=Len(cbUnZip)
            cbZip:=""
            nbZip:=0
            lSaveArray:=Compress(@cbZip,@nbZip,cbUnZip,nbUnZip)
            IF (lSaveArray)
                IF .NOT.(MemoWrite(cfZip,cbZip))
                    self:nError:=fError()
                EndIF    
            Else
                self:nError:=-1
            EndIF
        EndIF
        IF (lSaveArray)
            cFileName:=cfZip
        EndIF
    EndIF
RETURN(lSaveArray)

METHOD RestArray(cFileName) CLASS ArrayUtils
    Local aRestArray
    Local cfZip
    Local cbZip
    Local cfExt
    Local cfPath
    Local cfName
    Local cfDrive
    Local cbUnZip
    Local nbZip
    Local nbUnZip
    self:nError:=0
    IF (self:nZipMod>=0)
        SplitPath(cFileName,@cfDrive,@cfPath,@cfName,@cfExt)
        IF Empty(cfPath)
            cfPath:=IF(IsSrvUnix(),"/","\")
        EndIF
        cfPath:=(cfDrive+cfPath)
        IF (self:nZipMod==2)
            IF .NOT.(Empty(self:cZipPwd))
                self:nError:=FUnZip(@cFileName,@cfPath,@self:cZipPwd)
            Else
                self:nError:=FUnZip(@cFileName,@cfPath)
            EndIF
        ElseIF (self:nZipMod==1)
            IF .NOT.(Empty(self:cZipPwd))
                IF .NOT.(MsDecomp(@cFileName,@cfPath,@self:cZipPwd))
                    self:nError:=-1
                EndIF
            Else
                IF .NOT.(MsDecomp(@cFileName,@cfPath))
                    self:nError:=-1
                EndIF
            EndIF    
        Else
            cbZip:=self:Load4Str(cFileName)
            nbZip:=Len(cbZip)
            cbUZip:=""
            nbUZip:=0
            IF .NOT.(Uncompress(@cbUZip,@nbUZip,cbZip,nbZip))
                self:nError:=-1
            EndIF
            cbZip:=NIL
        EndIF
        IF (self:nError==0)
            cfZip:=cFileName
            cFileName:=StrTran(cFileName,cfExt,".arr")
            IF (self:nZipMod==0)
                IF .NOT.(MemoWrite(cFileName,cbUZip))
                    self:nError:=fError()
                EndIF
                cbUZip:=NIL
            EndIF
            aRestArray:=RestArray(@cFileName,@self:nError)
            fErase(cfZip)
        Else
            aRestArray:=Array(0)
        EndIF
    Else
        aRestArray:=RestArray(@cFileName,@self:nError)
    EndIF
RETURN(aRestArray)

METHOD Load4Str(cFileName) CLASS ArrayUtils
RETURN(MemoRead(cFileName))

METHOD SetZipMod(nZipMod,cZipPwd) CLASS ArrayUtils
    DEFAULT nZipMod:=self:nZipMod
    IF (nZipMod>2)
        nZipMod:=2
    EndIF
    IF ((nZipMod>1).and.(.NOT.(GetBuild()>"7.00.131227")))
        nZipMod:=1
    EndIF
    self:nZipMod:=nZipMod
    IF (self:nZipMod>0)
        self:SetZipPdw(@cZipPwd)
    EndIF
RETURN(self:nZipMod)

METHOD SetZipPdw(cZipPwd) CLASS ArrayUtils
    DEFAULT cZipPwd:=self:cZipPwd
    self:cZipPwd:=cZipPwd
RETURN(self:cZipPwd)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:ArrayCompare
        Autor:Marinaldo de Jesus
        Data:04/08/2004
        Descricao:Efetua a Comparacao de Arrays
        Retorno:lCompare<=>False se Houver Diferca,True se Nao Houver
    /*/
//------------------------------------------------------------------------------------------------
Static Function ArrayCompare(aArray1,aArray2,cATDiff)

    Local cType1:=ValType(aArray1)
    Local cType2:=ValType(aArray2)
    
    Local lCompare
    Local nArray
    Local nArray1Size
    Local nArray2Size
    Local nHalfToBeg
    Local nHalfToEnd
    
    BEGIN SEQUENCE
    
        IF .NOT.(lCompare:=(cType1==cType2))
            BREAK
        EndIF
    
        IF (cType1=="O")
            lCompare:=Compare(aArray1,aArray2,@cATDiff)
            BREAK
        EndIF
    
        IF .NOT.(lCompare:=(cType1=="A"))
            BREAK
        EndIF
                
        IF .NOT.(lCompare:=((nArray1Size:=Len(aArray1))==(nArray2Size:=Len(aArray2))))
            cATDiff+=(NToS(Min(nArray1Size,nArray2Size)+1)+"|")
            BREAK
        EndIF
                
        nHalfToBeg:=(IF(((nArray1Size%2)>0),((nArray1Size+1)),nArray1Size)/2)
        nHalfToEnd:=Min(nArray1Size,(nHalfToBeg+1))
        For nArray:=1 To nArray1Size
            IF (nArray<=nHalfToBeg)
                IF .NOT.(lCompare:=Compare(aArray1[nArray],aArray2[nArray]))
                    cATDiff+=(NToS(nArray)+"|")
                    BREAK
                EndIF
            Else
                BREAK
            EndIF
            IF (nHalfToBeg>nArray)
                IF .NOT.(lCompare:=Compare(aArray1[nHalfToBeg],aArray2[nHalfToBeg]))
                    cATDiff+=(NToS(nHalfToBeg)+"|")
                    BREAK
                EndIF
                --nHalfToBeg
            EndIF
            IF (nHalfToEnd<nArray1Size)
                IF .NOT.(lCompare:=Compare(aArray1[nHalfToEnd],aArray2[nHalfToEnd]))
                    cATDiff+=(NToS(nHalfToEnd)+"|")
                    BREAK
                EndIF
                ++nHalfToEnd
            EndIF
            IF (nArray1Size>=nHalfToEnd)
                IF .NOT.(lCompare:=Compare(aArray1[nArray1Size],aArray2[nArray1Size]))
                    cATDiff+=(NToS(nArray1Size)+"|")
                    BREAK
                EndIF
                --nArray1Size
            EndIF
        Next nArray
    
    END SEQUENCE

Return(lCompare)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:Compare
        Autor:Marinaldo de Jesus
        Data:08/10/2002
        Descricao:Compara o Conteudo de 2 Variaveis
        Retorno:lCompare<=>False se Houver Diferenca,True se Nao Houver
    /*/
//------------------------------------------------------------------------------------------------
Static Function Compare(uCompare1,uCompare2,cATDiff)

    Local cType1:=ValType(uCompare1)
    Local cType2:=ValType(uCompare2)

    Local lCompare

    IF (lCompare:=(cType1==cType2))
        IF (cType1=="A")
            lCompare:=ArrayCompare(uCompare1,uCompare2,@cATDiff)
        ElseIF (cType1=="O")
            lCompare:=ArrayCompare(ClassDataArr(uCompare1),ClassDataArr(uCompare2),@cATDiff)
        ElseIF (cType1=="B")
            lCompare:=(GetCBSource(uCompare1)==GetCBSource(uCompare2))
        Else
            lCompare:=(uCompare1==uCompare2)
        EndIF
    EndIF
    
Return(lCompare)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:SaveArray
        Autor:Marinaldo de Jesus
        Data:18/02/2005
        Descricao:Salva Array em Disco    
    /*/
//------------------------------------------------------------------------------------------------
Static Function SaveArray(uArray,cFileName,nErr)

    Local cValTypeuArray:=ValType(uArray)
    Local lSaveArray:=.F.
    
    Local aArray
    Local nfHandle
    
    BEGIN SEQUENCE
    
        IF .NOT.(cValTypeuArray$"A/O")
            BREAK
        EndIF
    
        IF (cValTypeuArray=="O")
            aArray:=ClassDataArr(uArray)
        Else
            aArray:=uArray
        EndIF
    
        lSaveArray:=FileCreate(cFileName,@nfHandle,@nErr)
        IF .NOT.(lSaveArray)
            BREAK
        EndIF
    
        SaveArr(nfHandle,aArray)
        fClose(nfHandle)
    
    END SEQUENCE    

Return(lSaveArray)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:SaveArr
        Autor:Marinaldo de Jesus
        Data:18/02/2005
        Descricao:Salva Array em Disco
        Uso:SaveArray
    /*/
//------------------------------------------------------------------------------------------------
Static Function SaveArr(nfHandle,aArray)

    Local cElemType
    
    Local uCntSave
    
    Local nLoop
    Local nLoops
        
    nLoops:=Len(aArray)
    uCntSave:=("A"+StrZero(nLoops,10))
    fWrite(nfHandle,uCntSave)
    For nLoop:=1 To nLoops
        cElemType:=ValType(aArray[nLoop])
        IF (cElemType$"A/O")
            IF (cElemType=="A")
                SaveArr(nfHandle,aArray[nLoop])
            Else
                SaveArr(nfHandle,ClassDataArr(aArray[nLoop]))
            EndIF
        Else
            IF (cElemType=="B")
                uCntSave:=GetCBSource(aArray[nLoop])
            ElseIF (cElemType=="C")
                uCntSave:=aArray[nLoop]
            ElseIF (cElemType=="D")
                uCntSave:=Dtos(aArray[nLoop])
            ElseIF (cElemType=="L")
                uCntSave:=IF(aArray[nLoop],".T.",".F.")
            ElseIF (cElemType=="N")
                uCntSave:=Transform(aArray[nLoop],RetPictVal(aArray[nLoop]))
            EndIF
            uCntSave:=(cElemType+StrZero(Len(uCntSave),5)+uCntSave)
            fWrite(nfHandle,uCntSave)
        EndIF
    Next nLoop

Return(NIL)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:RestArray
        Autor:Marinaldo de Jesus
        Data:18/02/2005
        Descricao:Restaura Array do Disco
        Retorno:aArray
    /*/
//------------------------------------------------------------------------------------------------
Static Function RestArray(cFileName,nErr)

    Local aRestArray:=Array(0)
    
    Local nfHandle
    
    BEGIN SEQUENCE
    
        IF .NOT.(File(cFileName))
            BREAK
        EndIF
        
        nfHandle:=fOpen(cFileName)
    
        IF (nfHandle<=0)
            nErr:=fError()
            BREAK
        EndIF
    
        fReadStr(nfHandle,1)
        aRestArray:=RestArr(@nfHandle)
        fClose(nfHandle)
    
    END SEQUENCE

Return(aRestArray)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:RestArr
        Autor:Marinaldo de Jesus
        Data:18/02/2005
        Descricao:Restaura Array do Disco
        Uso:RestArray
    /*/
//------------------------------------------------------------------------------------------------
Static Function RestArr(nfHandle)

    Local aArray
    Local cElemType
    Local cElemSize
    
    Local nLoop
    Local nLoops
    
    Local uCnt
    
    nLoop:=0
    nLoops:=Val(fReadStr(nfHandle,10))
    aArray:=Array(nLoops)
    
    While ((++nLoop)<=nLoops)
    
        cElemType:=fReadStr(nfHandle,1)
        IF (cElemType$"A/O")
            aArray[nLoop]:=RestArr(nfHandle)
        Else
            cElemSize:=fReadStr(nfHandle,5)
            uCnt:=fReadStr(nfHandle,Val(cElemSize))
            IF (cElemType$"B/L")
                aArray[nLoop]:=&(uCnt)
            ElseIF (cElemType=="C")
                aArray[nLoop]:=uCnt
            ElseIF (cElemType=="D")
                aArray[nLoop]:=StoD(AllTrim(uCnt))
            ElseIF (cElemType=="N")
                aArray[nLoop]:=Val(AllTrim(uCnt))
            EndIF
        EndIF
    
    End While
    
Return(aArray)
