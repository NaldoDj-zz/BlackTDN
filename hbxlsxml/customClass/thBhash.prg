#ifdef TOTVS
    #include "totvs.ch"
#else
    #include "protheus.ch"
#endif    
#include "msobject.ch"
#include "thbhash.ch"

/*/
    CLASS:THBHASH
    Autor:Marinaldo de Jesus
    Data:04/12/2011
    Descricao:Simular Hash no Protheus
    Sintaxe:THBHASH():New() -> Objeto do Tipo THBHASH
/*/
CLASS THBHASH FROM THASH 

    DATA aTHashID
    DATA nTHashSize

    DATA cClassName

    METHOD NEW() CONSTRUCTOR

    METHOD ClassName()

    METHOD hAdd(uCol,uKey,uValue)
    METHOD hAddEx(uRow,uCol,uKey,uValue)

    METHOD hPos(uRow,uCol,uKey,nATRow,lID)
    METHOD hATRow(uRow,lID)
    METHOD hATCol(uRow,uCol,uKey,nATRow,lID)
    METHOD hGetKey(uRow,uCol,uKey,lAtRow,lGetValue,lID)
    METHOD hGetValue(uRow,uCol,uKey,lAtRow,lID)
    METHOD hHashIDObjCol(uRow,lID)

    METHOD hIDPos(uRow,uCol,uKey,nATRow)
    METHOD hIDATRow(uRow)
    METHOD hIDATCol(uRow,uCol,uKey,nATRow)
    METHOD hIDGetKey(uRow,uCol,uKey,lAtRow,lGetValue)
    METHOD hIDGetValue(uRow,uCol,uKey,lAtRow)
    METHOD hIDHashIDObjCol(uRow)

ENDCLASS

USER FUNCTION THBHASH()
RETURN(THBHASH():New())

/*/
    METHOD:New
    Autor:Marinaldo de Jesus
    Data:04/12/2011
    Descricao:CONSTRUCTOR
    Sintaxe:THBHASH():New() -> Self
/*/
METHOD New() CLASS THBHASH

    Self:cClassName:="THBHASH"
    Self:aTHashID:=Array(0)

    Self:nTHashSize:=0

RETURN(Self)

/*/
    METHOD:ClassName
    Autor:Marinaldo de Jesus
    Data:04/12/2011
    Descricao:Retornar o Nome da Classe
    Sintaxe:THBHASH():ClassName() -> cClassName
/*/
METHOD ClassName() CLASS THBHASH
RETURN(Self:cClassName)

/*/
    METHOD:hPos
    Autor:Marinaldo de Jesus
    Data:04/12/2011
    Descricao:hPos
    Sintaxe:THBHASH():hPos(uRow,uCol,uKey,nATRow,lID) -> nAT
/*/
METHOD hPos(uRow,uCol,uKey,nATRow,lID) CLASS THBHASH
RETURN(Self:hATCol(@uRow,@uCol,@uKey,@nATRow,@lID))

/*/
    METHOD:hIDPos
    Autor:Marinaldo de Jesus
    Data:04/12/2011
    Descricao:hIDPos
    Sintaxe:THBHASH():hIDPos(uRow,uCol,uKey,nATRow) -> nAT
/*/
METHOD hIDPos(uRow,uCol,uKey,nATRow) CLASS THBHASH
RETURN(Self:hPos(@uRow,@uCol,@uKey,@nATRow,.T.))

/*/
    METHOD:hATRow
    Autor:Marinaldo de Jesus
    Data:04/12/2011
    Descricao:hATRow
    Sintaxe:THBHASH():hATRow(uRow,lID) -> nAT
/*/
METHOD hATRow(uRow,lID) CLASS THBHASH
    DEFAULT uRow:=1
    DEFAULT lID:=.F.
RETURN(aScan(Self:aTHashID,{ |aID| Compare(uRow,aID[IF(lID,HASH_ID,HASH_ID_KEY)]) }))

/*/
    METHOD:hATRowID
    Autor:Marinaldo de Jesus
    Data:04/12/2011
    Descricao:hIDATRow
    Sintaxe:THBHASH():hIDATRow(uRow) -> nAT
/*/
METHOD hIDATRow(uRow) CLASS THBHASH
RETURN(Self:hATRow(uRow,.T.))

/*/
    METHOD:hATCol
    Autor:Marinaldo de Jesus
    Data:04/12/2011
    Descricao:hATCol
    Sintaxe:THBHASH():hATCol(uRow,uCol,uKey,nATRow,lID) -> nAT
/*/
METHOD hATCol(uRow,uCol,uKey,nATRow,lID) CLASS THBHASH
    Local nAT:=0
    DEFAULT nATRow:=Self:hATRow(@uRow,@lID)
    IF (nATRow>0)
        DEFAULT uCol:=uKey
        DEFAULT lID:=.F.
        nAT:=aScan(Self:aTHashID[nATRow][HASH_ID_OBJCOL],{ |aID| Compare(uCol,aID[IF(lID,HASH_ID,HASH_ID_KEY)]) })
    EndIF
RETURN(nAT)

/*/
    METHOD:hIDATCol
    Autor:Marinaldo de Jesus
    Data:04/12/2011
    Descricao:hATColID
    Sintaxe:THBHASH():hIDATCol(uRow,uCol,uKey,nATRow) -> nAT
/*/
METHOD hIDATCol(uRow,uCol,uKey,nATRow) CLASS THBHASH
RETURN(Self:hATCol(@uRow,@uCol,@uKey,@nATRow,.T.))

/*/
    METHOD:Add
    Autor:Marinaldo de Jesus
    Data:04/12/2011
    Descricao:hAdd
    Sintaxe:THBHASH():hAdd(uCol,uKey,uValue) -> lSuccess
/*/
METHOD hAdd(uCol,uKey,uValue) CLASS THBHASH
RETURN(Self:hAddEx(NIL,@uCol,@uKey,@uValue))

/*/
    METHOD:hAddEx
    Autor:Marinaldo de Jesus
    Data:04/12/2011
    Descricao:hAddEx
    Sintaxe:THBHASH():hAddEx(uRow,uCol,uKey,uValue) -> lSuccess
/*/
METHOD hAddEx(uRow,uCol,uKey,uValue) CLASS THBHASH

    Local aKeyCol
    
    Local lSuccess:=.F.

    Local nATRow
    Local nATCol

    DEFAULT uRow:=1
    nATRow:=Self:hATRow(uRow)

    IF (nATRow ==0)

        nATRow:=++Self:nTHashSize
        aAdd(Self:aTHashID,Array(HASH_ID_ELEMENTS))

        Self:aTHashID[nATRow][HASH_ID]:=nATRow
        Self:aTHashID[nATRow][HASH_ID_KEY]:=uRow
        Self:aTHashID[nATRow][HASH_ID_OBJROW]:=THash():New()
        Self:aTHashID[nATRow][HASH_ID_OBJCOL]:=Array(0)

    EndIF
                                                        
    lSession:=Self:aTHashID[nATRow][HASH_ID_OBJROW]:AddNewSession(uRow)

    IF (lSession)

        DEFAULT uCol:=uKey
                                            
        nATCol:=Self:hATCol(@uRow,@uCol,@uKey,@nATRow)
        IF (nATCol ==0)
            aAdd(Self:aTHashID[nATRow][HASH_ID_OBJCOL],Array(HASH_ID_ELEMENTS))
            nATCol:=Len(Self:aTHashID[nATRow][HASH_ID_OBJCOL])
            Self:aTHashID[nATRow][HASH_ID_OBJCOL][nATCol][HASH_ID_OBJCOL]:=THash():New()
        EndIF

        Self:aTHashID[nATRow][HASH_ID_OBJCOL][nATCol][HASH_ID]:=nATCol
        Self:aTHashID[nATRow][HASH_ID_OBJCOL][nATCol][HASH_ID_KEY]:=uCol
        Self:aTHashID[nATRow][HASH_ID_OBJCOL][nATCol][HASH_ID_OBJROW]:=uRow
        IF (Self:aTHashID[nATRow][HASH_ID_OBJCOL][nATCol][HASH_ID_OBJCOL]:AddNewSession(uCol))
            IF (Self:aTHashID[nATRow][HASH_ID_OBJCOL][nATCol][HASH_ID_OBJCOL]:AddNewProperty(uCol,uKey,uValue))
                aKeyCol:=Array(HASH_KEY_ELEMENTS)
                aKeyCol[HASH_KEY_POS]:=uCol
                aKeyCol[HASH_KEY_INDEX]:=uKey
                lSuccess:=Self:aTHashID[nATRow][HASH_ID_OBJROW]:AddNewProperty(uRow,aKeyCol,uKey)
            EndIF
        EndIF

    EndIF

RETURN(lSuccess)

/*/
    METHOD:hGetKey
    Autor:Marinaldo de Jesus
    Data:04/12/2011
    Descricao:hGetKey
    Sintaxe:THBHASH():hGetKey(uRow,uCol,uKey,lAtRow,lGetValue,lID) -> uValue
/*/
METHOD hGetKey(uRow,uCol,uKey,lAtRow,lGetValue,lID) CLASS THBHASH

    Local nATRow
    Local nATCol
    Local uValue

    DEFAULT lGetValue:=.F.
    DEFAULT lAtRow:=!(uRow ==NIL)
    DEFAULT lID:=.F.

    IF (lID)
        nATRow:=Self:hATRow(@uRow,@lID)
        IF (nATRow>0)
            IF (lAtRow)
                uValue:=Self:aTHashID[nATRow][HASH_ID_KEY]
            Else
                nATCol:=Self:hATCol(@uRow,@uCol,@uKey,@nATRow,@lID)
                IF (nATCol>0)
                    uValue:=Self:aTHashID[nATRow][HASH_ID_OBJCOL][nATCol][HASH_ID_KEY]
                EndIF
            EndIF
        EndIF        
    ElseIF (Self:hPos(@uRow,@uCol,@uKey,@nATRow,@lID)>0)
        IF (lAtRow)
            IF (nATRow>0)
                IF (lGetValue)
                    uValue:=Self:aTHashID[nATRow][HASH_ID_OBJROW]:GetPropertyValue(uRow,uCol)
                Else
                    uValue:=Self:aTHashID[nATRow][HASH_ID_OBJROW]:GetKeyProperty(uRow,uCol)
                EndIF
            EndIF
        Else
            nATCol:=Self:hATCol(@uRow,@uCol,@uKey,@nATRow,@lID)
            DEFAULT uKey:=uCol
            IF (nATCol>0)
                IF (lGetValue)
                    uValue:=Self:aTHashID[nATRow][HASH_ID_OBJCOL][nATCol][HASH_ID_OBJCOL]:GetPropertyValue(uCol,uKey)
                Else
                    uValue:=Self:aTHashID[nATRow][HASH_ID_OBJCOL][nATCol][HASH_ID_OBJCOL]:GetKeyProperty(uCol,uKey)    
                EndIF    
            EndIF
        EndIF
    EndIF

Return(uValue)

/*/
    METHOD:hIDGetKey
    Autor:Marinaldo de Jesus
    Data:04/12/2011
    Descricao:hGetKey
    Sintaxe:THBHASH():hIDGetKey(uRow,uCol,uKey,lAtRow,lGetValue) -> uValue
/*/
METHOD hIDGetKey(uRow,uCol,uKey,lAtRow,lGetValue,lID) CLASS THBHASH
Return(Self:hGetKey(@uRow,@uCol,@uKey,@lAtRow,@lGetValue,.T.))

/*/
    METHOD:hGetValue
    Autor:Marinaldo de Jesus
    Data:04/12/2011
    Descricao:hGetValue
    Sintaxe:THBHASH():hGetValue(uRow,uCol,uKey,lAtRow) -> uValue
/*/
METHOD hGetValue(uRow,uCol,uKey,lAtRow,lID) CLASS THBHASH
Return(Self:hGetKey(@uRow,@uCol,@uKey,@lAtRow,.T.,@lID))

/*/
    METHOD:hIDGetValue
    Autor:Marinaldo de Jesus
    Data:04/12/2011
    Descricao:hGetValue
    Sintaxe:THBHASH():hGetValue(uRow,uCol,uKey,lAtRow) -> uValue
/*/
METHOD hIDGetValue(uRow,uCol,uKey,lAtRow,lID) CLASS THBHASH
Return(Self:hGetValue(@uRow,@uCol,@uKey,@lAtRow,.T.))

/*/
    METHOD:hHashIDObjCol
    Autor:Marinaldo de Jesus
    Data:04/12/2011
    Descricao:hHashIDObjCol
    Sintaxe:THBHASH():hHashIDObjCol(uRow,lID) -> aProperties
/*/
METHOD hHashIDObjCol(uRow,lID) CLASS THBHASH

    Local ahIdObjCol:={}

    Local nATRow:=Self:hATRow(@uRow,@lID)

    IF (nATRow>0)
        ahIdObjCol:=Self:aTHashID[nATRow][HASH_ID_OBJCOL]
    EndIF

Return(ahIdObjCol)

/*/
    METHOD:hHashIDObjColID
    Autor:Marinaldo de Jesus
    Data:04/12/2011
    Descricao:hHashIDObjCol
    Sintaxe:THBHASH():hHashIDObjCol(uRow) -> ahIdObjCol
/*/
METHOD hIDHashIDObjCol(uRow,lID) CLASS THBHASH
Return(Self:hHashIDObjCol(@uRow,.T.))
