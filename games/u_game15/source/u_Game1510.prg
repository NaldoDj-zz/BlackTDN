#include "totvs.ch"

#define SHAPE_ID            1
#define SHAPE_TOOLTIP       2
#define SHAPE_TOP           3
#define SHAPE_LEFT          4
#define SHAPE_WIDTH         5
#define SHAPE_HEIGHT        6
#define SHAPE_FILE          7
#define SHAPE_ACTION        8
#define SHAPE_BTNINDEX      9
#define SHAPE_BTNNUMBER    10
#define SHAPE_PROPERTIES   11

#define SHAPE_ELEM         11

#DEFINE AT_G15_TIME         1
#DEFINE AT_G15_RESULT       2
#DEFINE AT_G15_NAME         3

#DEFINE AT_FIELDS           4
#DEFINE AT_R_E_C_N_O_       AT_FIELDS    //Deixar AT_R_E_C_N_O_ sempre como ultimo campo do aListBox

#define PROGRAM             "Game 15"
#define VERSION             "version 1.0"
#define COPYRIGHT           "2012-"+StrZero(Year(Date()),4)
#define AUTHOR              "Marinaldo de Jesus"
#define URL_COPYRIGHT       "http://www.blacktdn.com.br"
#define URL_BTDNGAME15      "http://goo.gl/guiaK"

#ifndef SYMBOL_UNUSED
    #define SYMBOL_UNUSED(symbol) (symbol:=(symbol))
#endif 

Static oDJLIB001
Static oDJLIB029
Static oDJLIB030

/*

    Funcao:Game15()
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:16/04/2012
    Uso:Jogo Game15 PT10
*/
Static Procedure Game15(oTHash,cTitle)

    Local bInit
    Local bValid

    Local cIcon
    Local cSession

    Local lExecute
    Local lSetDeleted

    Local oDlg

    Local oTPPanel

    Local oTRect
    Local ouTRect

    lSetDeleted:=Set(_SET_DELETED,.T.)

    BEGIN SEQUENCE

        lExecute:=(Upper(ProcName(1))=="U_GAME15") .or. (Upper(ProcName(2))=="U_GAME15")
        IF .NOT.(lExecute)
            MsgAlert("Invalid Function Call:"+ProcName(),"By By")
            BREAK
        EndIF

        cSession:="Game15_Shapes" 
        oTHash:AddNewSession(cSession)
        oTHash:AddNewProperty(cSession,"aShapes",Array(0))

        bInit:={||OpenTopTable(@oTHash)}
        bValid:={||.T.}

        oTRect:=TRect():New(0,0,365,305)

        cIcon:=oTHash:GetProperty("Game15_Files_ico","ico","game15.ico")
        DEFINE MSDIALOG oDlg TITLE OemToAnsi(cTitle) FROM oTRect:nTop,oTRect:nLeft TO oTRect:nBottom,oTRect:nRight OF GetWndDefault() ICON cIcon PIXEL STYLE WS_POPUP

            ouTRect:=uTRect():New(oTRect:nTop,oTRect:nLeft,oTRect:nBottom,oTRect:nRight)

            oTPPanel:=TPaintPanel():New(ouTRect:nTop,ouTRect:nLeft,ouTRect:nWidth,ouTRect:nHeight,oDlg,.F.)
            oTPPanel:Align:=CONTROL_ALIGN_ALLCLIENT

            LoadGame(NIL,NIL,@oTPPanel,@oTHash)

            oTPPanel:bRClicked:={|x,y|rClick(@x,@y,@oTPPanel,@oTHash,@cSession)}
            oTPPanel:blClicked:={|x,y|lClick(@x,@y,@oTPPanel,@oTHash,@cSession)}
            oTPPanel:blDBLClick:=oTPPanel:blClicked  

            oTRect:=FreeObj(oTRect)
            ouTRect:=FreeObj(ouTRect) 

        ACTIVATE DIALOG oDlg CENTERED ON INIT Eval(bInit) VALID Eval(bValid)

        oTHash:RemoveSession(cSession)

        bInit:=NIL
        bValid:=NIL


    END SEQUENCE

    Set(_SET_DELETED,lSetDeleted)

Return

/*
    Funcao:rClick
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:16/04/2012
    Uso:Acao do Botao Direito do Mouse
*/
Static Function rClick(x,y,oTPPanel,oTHash,cSession)
    SYMBOL_UNUSED(x)
    SYMBOL_UNUSED(y)
    SYMBOL_UNUSED(oTPPanel)
    SYMBOL_UNUSED(oTHash)
    SYMBOL_UNUSED(cSession)
Return(.T.)

/*
    Funcao:lClick
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:16/04/2012
    Uso:Acao do Botao Esquerdo do Mouse
*/
Static Function lClick(x,y,oTPPanel,oTHash,cSession)

    Local aShapes:=oTHash:GetPropertyValue(cSession,"aShapes")

    Local bAction

    Local nShape:=oTPPanel:ShapeAtu
    Local nATShape:=aScan(aShapes,{|aShape|(aShape[SHAPE_ID]==nShape)},nShape)

    Local lAction:=(nATShape>0)

    BEGIN SEQUENCE

        IF .NOT.(lAction)
            nATShape:=aScan(aShapes,{|aShape|(aShape[SHAPE_ID]==nShape)})
            lAction:=(nATShape>0)
        EndIF    

        IF .NOT.(lAction)
            BREAK
        EndIF

        bAction:=aShapes[nATShape][SHAPE_ACTION]
        lAction:=(ValType(bAction)=="B")

        IF .NOT.(lAction)
            BREAK
        EndIF

        Eval(bAction,@x,@y,@oTPPanel,@oTHash,@cSession)

    END SEQUENCE

Return(lAction)

/*
    Funcao:SwapButtons
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:16/04/2012
    Uso:Acao do Jogo
*/
Static Function SwapButtons(x,y,oTPPanel,oTHash)
    
    Local aMatch
    Local aShapes:=oTHash:GetPropertyValue("Game15_Shapes","aShapes")

    Local cMatch

    Local nShape:=oTPPanel:ShapeAtu
    Local nButtons:=Len(oTHash:GetAllProperties("Game15_Files_bmps_play"))
    Local nSqrtBtn:=Sqrt(nButtons)

    Local nD
    Local nJ

    Local nMin
    Local nMax
    Local nAbs

    Local nFree
    Local nIndex
    Local nPress

    Local nMatch
    Local nMatches

    Local lMatch:=.F.

    Local ouTRect

    SYMBOL_UNUSED(x)
    SYMBOL_UNUSED(y)

    BEGIN SEQUENCE

        nD:=aScan(aShapes,{|aShape|(aShape[SHAPE_BTNNUMBER]>0)})
        nJ:=(aScan(aShapes,{|aShape|(aShape[SHAPE_BTNNUMBER]==0)},nD+1)-nD)

        nFree:=aScan(aShapes,{|aShape|aShape[SHAPE_BTNNUMBER]==nButtons},nD,nJ)
        nPress:=aScan(aShapes,{|aShape|aShape[SHAPE_ID]==nShape},nShape,nJ)
        IF (nPress==0)
            nPress:=aScan(aShapes,{|aShape|aShape[SHAPE_ID]==nShape},nD,nJ)
        EndIF

        nMin:=Min(aShapes[nFree][SHAPE_BTNINDEX],aShapes[nPress][SHAPE_BTNINDEX])
        nMax:=Max(aShapes[nFree][SHAPE_BTNINDEX],aShapes[nPress][SHAPE_BTNINDEX])

        nAbs:=(nMax-nMin)
    
        IF .NOT.((nAbs==nSqrtBtn) .or. ((nAbs==1) .and. .NOT.((Getfyx(nMax,nSqrtBtn)%nSqrtBtn)==0)))
            BREAK
        EndIF

        ouTRect:=uTRect():New()

        ouTRect:nTop:=aShapes[nPress][SHAPE_TOP]
        ouTRect:nLeft:=aShapes[nPress][SHAPE_LEFT]
        nIndex:=aShapes[nPress][SHAPE_BTNINDEX]
        
        aShapes[nPress][SHAPE_TOP]:=aShapes[nFree][SHAPE_TOP]
        aShapes[nPress][SHAPE_LEFT]:=aShapes[nFree][SHAPE_LEFT]
        aShapes[nPress][SHAPE_BTNINDEX]:=aShapes[nFree][SHAPE_BTNINDEX]

        aShapes[nFree][SHAPE_TOP]:=ouTRect:nTop
        aShapes[nFree][SHAPE_LEFT]:=ouTRect:nLeft
        aShapes[nFree][SHAPE_BTNINDEX]:=nIndex

        ouTRect:=FreeObj(ouTRect)

        oTPPanel:SetPosition(aShapes[nPress][SHAPE_ID],aShapes[nPress][SHAPE_LEFT],aShapes[nPress][SHAPE_TOP])
        oTPPanel:SetPosition(aShapes[nFree][SHAPE_ID],aShapes[nFree][SHAPE_LEFT],aShapes[nFree][SHAPE_TOP])

        Tone(3000,1)

        aMatch:={;
                    "HL1AlgMatch",;
                    "HR1AlgMatch",;
                    "HL2AlgMatch",;
                    "HR2AlgMatch",;
                    "VL1AlgMatch",;
                    "VR1AlgMatch",;
                    "VL2AlgMatch",;
                    "VR2AlgMatch";
            }
        
        nMatches:=Len(aMatch)
        For nMatch:=1 To nMatches
            cMatch:=aMatch[nMatch]
            lMatch:=&cMatch.(@aShapes,@nSqrtBtn,@nButtons,@nD,@nJ)    
            IF (lMatch)                                                                        
                EXIT
            EndIF
        Next nMatch

          IF .NOT.(lMatch)
              BREAK
          EndIF

        SaveTopTable(@oTHash)

    END SEQUENCE

Return(lMatch)

/*
    Funcao:Getfyx
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:15/01/2013
    Uso:Retorna a Posicao do Eixo y de Acordo com o Eixo x
*/
Static Function Getfyx(x,y,nSub,nPlus)
    DEFAULT nSub:=1
    DEFAULT nPlus:=1
Return(((x*(y-nSub))+nPlus))

/*
    Funcao:HL1AlgMatch
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:18/04/2012
    Uso:Algoritmo de Validacao HL1 (Superior Direita->Inferior Esquerda)
*/
Static Function HL1AlgMatch(aShapes,nSqrtBtn,nButtons,nD,nJ)

    Local aMatchG:=Array(0)
    Local aMatchL:=Array(0)

    Local lMatch:=.F.

    Local nL
    Local nAT
    Local nCol
    Local nRow
    Local nIndex:=0
    Local nBtnIDX

    For nCol:=1 To nSqrtBtn
        For nRow:=nCol To nButtons Step nSqrtBtn
            nL:=nRow
            aAdd(aMatchL,nL)
            nAT:=aScan(aShapes,{|aShape|aShape[SHAPE_BTNNUMBER]==nL},nD,nJ)
            nBtnIDX:=aShapes[nAT][SHAPE_BTNINDEX]
            lMatch:=((++nIndex)==nBtnIDX)
            IF (lMatch)
                aAdd(aMatchG,nL)
            EndIF
        Next nRow
    Next nCol

    lMatch:=Compare(@aMatchG,@aMatchL)

    aSize(aMatchG,0)
    aSize(aMatchL,0)

    aMatchG:=NIL
    aMatchL:=NIL

Return(lMatch)

/*
    Funcao:HR1AlgMatch
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:18/04/2012
    Uso:Algoritmo de Validacao HR1 (Inferior Direita -> Superior Esquerda)
*/
Static Function HR1AlgMatch(aShapes,nSqrtBtn,nButtons,nD,nJ)

    Local aMatchG:=Array(0)
    Local aMatchR:=Array(0)

    Local lMatch:=.F.

    Local nR
    Local nAT
    Local nCol
    Local nRow
    Local nIndex:=0
    Local nBtnIDX

    For nCol:=1 To nSqrtBtn
        For nRow:=nCol To nButtons Step nSqrtBtn
            nR:=((nButtons-nRow)+1)
            aAdd(aMatchR,nR)
            nAT:=aScan(aShapes,{|aShape|aShape[SHAPE_BTNNUMBER]==nR},nD,nJ)
            nBtnIDX:=aShapes[nAT][SHAPE_BTNINDEX]
            lMatch:=((++nIndex)==nBtnIDX)
            IF (lMatch)
                aAdd(aMatchG,nR)
            EndIF
        Next nRow
    Next nCol

    lMatch:=Compare(@aMatchG,@aMatchR)

    aSize(aMatchG,0)
    aSize(aMatchR,0)

    aMatchG:=NIL
    aMatchR:=NIL

Return(lMatch)

/*
    Funcao:HL2AlgMatch
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:18/04/2012
    Uso:Algoritmo de Validacao HL2 (Inferior Esquerda -> Superior Direita)
*/
Static Function HL2AlgMatch(aShapes,nSqrtBtn,nButtons,nD,nJ)

    Local aMatchG:=Array(0)
    Local aMatchL:=Array(0)

    Local lMatch:=.F.

    Local nL
    Local nAT
    Local nCol
    Local nRow
    Local nIndex:=0
    Local nBtnIDX

    For nCol:=nSqrtBtn To 1 Step -(1)
        For nRow:=nCol To nButtons Step nSqrtBtn
            nL:=nRow
            aAdd(aMatchL,nL)
            nAT:=aScan(aShapes,{|aShape|aShape[SHAPE_BTNNUMBER]==nL},nD,nJ)
            nBtnIDX:=aShapes[nAT][SHAPE_BTNINDEX]
            lMatch:=((++nIndex)==nBtnIDX)
            IF (lMatch)
                aAdd(aMatchG,nL)
            EndIF
        Next nRow
    Next nCol

    lMatch:=Compare(@aMatchG,@aMatchL)

    aSize(aMatchG,0)
    aSize(aMatchL,0)

    aMatchG:=NIL
    aMatchL:=NIL

Return(lMatch)

/*
    Funcao:HR2AlgMatch
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:18/04/2012
    Uso:Algoritmo de Validacao HR2 (Superior Direita -> Inferior Esquerda)
*/
Static Function HR2AlgMatch(aShapes,nSqrtBtn,nButtons,nD,nJ)

    Local aMatchG:=Array(0)
    Local aMatchR:=Array(0)

    Local lMatch:=.F.

    Local nR
    Local nAT
    Local nCol
    Local nRow
    Local nIndex:=0
    Local nBtnIDX

    For nCol:=nSqrtBtn To 1 Step -(1)
        For nRow:=nCol To nButtons Step nSqrtBtn
            nR:=((nButtons-nRow)+1)
            aAdd(aMatchR,nR)
            nAT:=aScan(aShapes,{|aShape|aShape[SHAPE_BTNNUMBER]==nR},nD,nJ)
            nBtnIDX:=aShapes[nAT][SHAPE_BTNINDEX]
            lMatch:=((++nIndex)==nBtnIDX)
            IF (lMatch)
                aAdd(aMatchG,nR)
            EndIF
        Next nRow
    Next nCol

    lMatch:=Compare(@aMatchG,@aMatchR)

    aSize(aMatchG,0)
    aSize(aMatchR,0)

    aMatchG:=NIL
    aMatchR:=NIL

Return(lMatch)

/*
    Funcao:VL1AlgMatch
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:19/04/2012
    Uso:Algoritmo de Validacao VL1 (Superior Direita->Inferior Esquerda)
*/
Static Function VL1AlgMatch(aShapes,nSqrtBtn,nButtons,nD,nJ)

    Local aMatchG:=Array(nButtons)
    Local aMatchV:=Array(nButtons)

    Local lMatch:=.F.

    Local nAT
    Local nCol
    Local nBtnIDX

    SYMBOL_UNUSED(nSqrtBtn)

    For nCol:=1 To nButtons
        aMatchV[nCol]:=nCol
        nAT:=aScan(aShapes,{|aShape|aShape[SHAPE_BTNNUMBER]==nCol},nD,nJ)
        nBtnIDX:=aShapes[nAT][SHAPE_BTNINDEX]
        lMatch:=(nCol==nBtnIDX)
        IF (lMatch)
            aMatchG[nCol]:=nCol
        EndIF
    Next nCol

    lMatch:=Compare(@aMatchG,@aMatchV)

    aSize(aMatchG,0)
    aSize(aMatchV,0)

    aMatchG:=NIL
    aMatchV:=NIL

Return(lMatch)

/*
    Funcao:VR1AlgMatch
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:19/04/2012
    Uso:Algoritmo de Validacao VR1 (Inferior Direita -> Superior Esquerda)
*/
Static Function VR1AlgMatch(aShapes,nSqrtBtn,nButtons,nD,nJ)

    Local aMatchG:=Array(nButtons)
    Local aMatchV:=Array(nButtons)

    Local lMatch:=.F.

    Local nAT
    Local nCol
    Local nBtnIDX
    
    SYMBOL_UNUSED(nSqrtBtn)

    For nCol:=1 To nButtons
        aMatchV[nCol]:=((nButtons-nCol)+1)
        nAT:=aScan(aShapes,{|aShape|aShape[SHAPE_BTNNUMBER]==aMatchV[nCol]},nD,nJ)
        nBtnIDX:=aShapes[nAT][SHAPE_BTNINDEX]
        lMatch:=(nCol==nBtnIDX)
        IF (lMatch)
            aMatchG[nCol]:=aMatchV[nCol]
        EndIF
    Next nCol

    lMatch:=Compare(@aMatchG,@aMatchV)

    aSize(aMatchG,0)
    aSize(aMatchV,0)

    aMatchG:=NIL
    aMatchV:=NIL

Return(lMatch)

/*
    Funcao:VL2AlgMatch
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:19/04/2012
    Uso:Algoritmo de Validacao VL2 (Inferior Esquerda -> Superior Direita)
*/
Static Function VL2AlgMatch(aShapes,nSqrtBtn,nButtons,nD,nJ)

    Local aMatchG:=Array(nButtons)
    Local aMatchV:=Array(nButtons)

    Local lMatch:=.F.

    Local nAT
    Local nCol
    Local nRow
    Local nIndex:=0
    Local nBtnIDX
    
    For nCol:=nSqrtBtn To nButtons Step nSqrtBtn
        For nRow:=nCol To 1 Step -(1)
            aMatchV[++nIndex]:=nRow
            nAT:=aScan(aShapes,{|aShape|aShape[SHAPE_BTNNUMBER]==aMatchV[nIndex]},nD,nJ)
            nBtnIDX:=aShapes[nAT][SHAPE_BTNINDEX]
            lMatch:=(nIndex==nBtnIDX)
            IF (lMatch)
                aMatchG[nIndex]:=aMatchV[nIndex]
            EndIF
            IF ((nIndex%nSqrtBtn)==0)
                EXIT
            EndIF
        Next nRow
    Next nCol

    lMatch:=Compare(@aMatchG,@aMatchV)

    aSize(aMatchG,0)
    aSize(aMatchV,0)

    aMatchG:=NIL
    aMatchV:=NIL

Return(lMatch)

/*
    Funcao:VR2AlgMatch
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:19/04/2012
    Uso:Algoritmo de Validacao VR2 (Superior Direita -> Inferior Esquerda)
*/
Static Function VR2AlgMatch(aShapes,nSqrtBtn,nButtons,nD,nJ)

    Local aMatchG:=Array(nButtons)
    Local aMatchV:=Array(nButtons)

    Local lMatch:=.F.

    Local nAT
    Local nCol
    Local nRow
    Local nIndex:=0
    Local nBtnIDX
    
    For nCol:=nButtons To 1 Step -(nSqrtBtn)
        For nRow:=((nCol-nSqrtBtn)+1) To nButtons
            aMatchV[++nIndex]:=nRow
            nAT:=aScan(aShapes,{|aShape|aShape[SHAPE_BTNNUMBER]==aMatchV[nIndex]},nD,nJ)
            nBtnIDX:=aShapes[nAT][SHAPE_BTNINDEX]
            lMatch:=(nIndex==nBtnIDX)
            IF (lMatch)
                aMatchG[nIndex]:=aMatchV[nIndex]
            EndIF
            IF ((nIndex%nSqrtBtn)==0)
                EXIT
            EndIF
        Next nRow
    Next nCol

    lMatch:=Compare(@aMatchG,@aMatchV)

    aSize(aMatchG,0)
    aSize(aMatchV,0)

    aMatchG:=NIL
    aMatchV:=NIL

Return(lMatch)

/*
    Funcao:Finalize
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:16/04/2012
    Uso:Finalizar o Jogo
*/
Static Procedure Finalize(x,y,oTPPanel,oTHash)

    Local aShapes:=oTHash:GetPropertyValue("Game15_Shapes","aShapes")
    Local cG15Alias:=oTHash:GetPropertyValue("Game15_Table","G15_Alias")

    SYMBOL_UNUSED(x)
    SYMBOL_UNUSED(y)

    oTPPanel:ClearAll()
    aSize(aShapes,0)

    oTPPanel:oWnd:End()

    IF .NOT.(Empty(cG15Alias))
        IF (Select(cG15Alias)>0)
            (cG15Alias)->(dbCloseArea())
        EndIF
    EndIF

    oTHash:RemoveSession("Game15_Time")
    oTHash:RemoveSession("Game15_Table")
    oTHash:RemoveSession("Game15_Shapes")

Return

/*
    Funcao:MsgAbout
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:16/04/2012
    Uso:About
*/
Static Procedure MsgAbout(oTHash)

    Local bInit
    Local bValid

    Local cIcon
    Local cSession

    Local oDlg

    Local oTPPanel

    Local oTRect
    Local ouTRect

    BEGIN SEQUENCE

        cSession:="Game15_About"

        oTHash:AddNewSession(cSession)
        oTHash:AddNewProperty(cSession,"aShapes",Array(0))

        bInit:={||.T.}
        bValid:={||.T.}

        oTRect:=TRect():New(0,0,365,305)

        cIcon:=oTHash:GetProperty("Game15_Files_ico","ico","game15.ico")
        DEFINE MSDIALOG oDlg TITLE OemToAnsi(PROGRAM+" About") FROM oTRect:nTop,oTRect:nLeft TO oTRect:nBottom,oTRect:nRight OF GetWndDefault() ICON cIcon PIXEL STYLE WS_POPUP

            ouTRect:=uTRect():New(oTRect:nTop,oTRect:nLeft,oTRect:nBottom,oTRect:nRight)

            oTPPanel:=TPaintPanel():New(ouTRect:nTop,ouTRect:nLeft,ouTRect:nWidth,ouTRect:nHeight,oDlg,.F.)
            oTPPanel:Align:=CONTROL_ALIGN_ALLCLIENT

            LoadMsgAbout(NIL,NIL,@oTPPanel,@oTHash,@cSession)

            oTPPanel:bRClicked:={|x,y|rClick(@x,@y,@oTPPanel,@oTHash,@cSession)}
            oTPPanel:blClicked:={|x,y|lClick(@x,@y,@oTPPanel,@oTHash,@cSession)}
            oTPPanel:blDBLClick:=oTPPanel:blClicked  

            oTRect:=FreeObj(oTRect)
            ouTRect:=FreeObj(ouTRect)

        ACTIVATE DIALOG oDlg CENTERED ON INIT Eval(bInit) VALID Eval(bValid)   
        
        oTHash:RemoveSession(cSession)

    END SEQUENCE

Return

/*
    Funcao:LoadMsgAbout
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:16/04/2012
    Uso:Carregar informacoes da Top Table
*/
Static Procedure LoadMsgAbout(x,y,oTPPanel,oTHash,cSession)

    Local aShapes:=oTHash:GetPropertyValue(cSession,"aShapes")
    Local cProperties

    Local nID:=0

    Local nShape
    Local nShapes

    oTPPanel:ClearAll()
    aSize(aShapes,0)

    //"MainForm"
    aAdd(aShapes,Array(SHAPE_ELEM))

    aShapes[nID][SHAPE_ID]:=++nID
    aShapes[nID][SHAPE_TOOLTIP]:="About"
    aShapes[nID][SHAPE_TOP]:=0
    aShapes[nID][SHAPE_LEFT]:=0
    aShapes[nID][SHAPE_WIDTH]:=394
    aShapes[nID][SHAPE_HEIGHT]:=317
    aShapes[nID][SHAPE_FILE]:=oTHash:GetPropertyValue("Game15_Files_bmps_aux","mainform")
    aShapes[nID][SHAPE_ACTION]:={|x,y,oTPPanel,oTHash,cSession|.F.}
    aShapes[nID][SHAPE_BTNINDEX]:=0
    aShapes[nID][SHAPE_BTNNUMBER]:=0

    cProperties:=""

    AddProperty(@cProperties,"id=",aShapes[nID][SHAPE_ID])
    AddProperty(@cProperties,"type=",8)
    AddProperty(@cProperties,"left=",aShapes[nID][SHAPE_LEFT])
    AddProperty(@cProperties,"top=",aShapes[nID][SHAPE_TOP])
    AddProperty(@cProperties,"width=",aShapes[nID][SHAPE_WIDTH])
    AddProperty(@cProperties,"height=",aShapes[nID][SHAPE_HEIGHT])
    AddProperty(@cProperties,"tooltip=",aShapes[nID][SHAPE_TOOLTIP])
    AddProperty(@cProperties,"image-file=",aShapes[nID][SHAPE_FILE])
    AddProperty(@cProperties,"can-move=",0)
    AddProperty(@cProperties,"can-mark=",0)
    AddProperty(@cProperties,"is-container=",1)

    aShapes[nID][SHAPE_PROPERTIES]:=cProperties

    //PROGRAM+" "+VERSION
    aAdd(aShapes,Array(SHAPE_ELEM))
    
    aShapes[nID][SHAPE_ID]:=++nID
    aShapes[nID][SHAPE_TOOLTIP]:=PadC(PROGRAM+" "+VERSION,35)
    aShapes[nID][SHAPE_TOP]:=10
    aShapes[nID][SHAPE_LEFT]:=0
    aShapes[nID][SHAPE_WIDTH]:=300
    aShapes[nID][SHAPE_HEIGHT]:=29
    aShapes[nID][SHAPE_FILE]:=""
    aShapes[nID][SHAPE_ACTION]:={||.F.}
    aShapes[nID][SHAPE_BTNINDEX]:=0
    aShapes[nID][SHAPE_BTNNUMBER]:=0

    cProperties:=""

    AddProperty(@cProperties,"id=",aShapes[nID][SHAPE_ID])
    AddProperty(@cProperties,"type=",7)
    AddProperty(@cProperties,"top=",aShapes[nID][SHAPE_TOP])
    AddProperty(@cProperties,"left=",aShapes[nID][SHAPE_LEFT])
    AddProperty(@cProperties,"width=",aShapes[nID][SHAPE_WIDTH])
    AddProperty(@cProperties,"height=",aShapes[nID][SHAPE_HEIGHT])
    AddProperty(@cProperties,"pen-color=","#FFFFFF")
    AddProperty(@cProperties,"pen-width=","1")
    AddProperty(@cProperties,"font=","Arial,12,1,0,3")
    AddProperty(@cProperties,"text=",aShapes[nID][SHAPE_TOOLTIP])
    
    aShapes[nID][SHAPE_PROPERTIES]:=cProperties

    //"Close"
    aAdd(aShapes,Array(SHAPE_ELEM))
    
    aShapes[nID][SHAPE_ID]:=++nID
    aShapes[nID][SHAPE_TOOLTIP]:="Close"
    aShapes[nID][SHAPE_TOP]:=12
    aShapes[nID][SHAPE_LEFT]:=317-26
    aShapes[nID][SHAPE_WIDTH]:=14
    aShapes[nID][SHAPE_HEIGHT]:=14
    aShapes[nID][SHAPE_FILE]:=oTHash:GetPropertyValue("Game15_Files_bmps_aux","closebtn")
    aShapes[nID][SHAPE_ACTION]:={|x,y,oTPPanel,oTHash,cSession|oTPPanel:ClearAll(),oTPPanel:oWnd:End()}
    aShapes[nID][SHAPE_BTNINDEX]:=0
    aShapes[nID][SHAPE_BTNNUMBER]:=0

    cProperties:=""

    AddProperty(@cProperties,"id=",aShapes[nID][SHAPE_ID])
    AddProperty(@cProperties,"type=",8)
    AddProperty(@cProperties,"top=",aShapes[nID][SHAPE_TOP])
    AddProperty(@cProperties,"left=",aShapes[nID][SHAPE_LEFT])
    AddProperty(@cProperties,"width=",aShapes[nID][SHAPE_WIDTH])
    AddProperty(@cProperties,"height=",aShapes[nID][SHAPE_HEIGHT])
    AddProperty(@cProperties,"image-file=",aShapes[nID][SHAPE_FILE])
    AddProperty(@cProperties,"tooltip=",aShapes[nID][SHAPE_TOOLTIP])
    AddProperty(@cProperties,"can-move=",0)
    AddProperty(@cProperties,"can-mark=",1)
    AddProperty(@cProperties,"is-container=",0)
    
    aShapes[nID][SHAPE_PROPERTIES]:=cProperties

    //Copyright "+Chr(169)+" "+COPYRIGHT
    aAdd(aShapes,Array(SHAPE_ELEM))
    
    aShapes[nID][SHAPE_ID]:=++nID
    aShapes[nID][SHAPE_TOOLTIP]:=PadC("Copyright "+Chr(169)+" "+COPYRIGHT,40)
    aShapes[nID][SHAPE_TOP]:=50
    aShapes[nID][SHAPE_LEFT]:=0
    aShapes[nID][SHAPE_WIDTH]:=317
    aShapes[nID][SHAPE_HEIGHT]:=29
    aShapes[nID][SHAPE_FILE]:=""
    aShapes[nID][SHAPE_ACTION]:={||.F.}
    aShapes[nID][SHAPE_BTNINDEX]:=0
    aShapes[nID][SHAPE_BTNNUMBER]:=0

    cProperties:=""

    AddProperty(@cProperties,"id=",aShapes[nID][SHAPE_ID])
    AddProperty(@cProperties,"type=",7)
    AddProperty(@cProperties,"top=",aShapes[nID][SHAPE_TOP])
    AddProperty(@cProperties,"left=",aShapes[nID][SHAPE_LEFT])
    AddProperty(@cProperties,"width=",aShapes[nID][SHAPE_WIDTH])
    AddProperty(@cProperties,"height=",aShapes[nID][SHAPE_HEIGHT])
    AddProperty(@cProperties,"pen-color=","#FFFFFF")
    AddProperty(@cProperties,"pen-width=","1")
    AddProperty(@cProperties,"font=","Arial,10,1,0,3")
    AddProperty(@cProperties,"text=",aShapes[nID][SHAPE_TOOLTIP])
    
    aShapes[nID][SHAPE_PROPERTIES]:=cProperties

    //AUTHOR
    aAdd(aShapes,Array(SHAPE_ELEM))
    
    aShapes[nID][SHAPE_ID]:=++nID
    aShapes[nID][SHAPE_TOOLTIP]:=PadC(AUTHOR,40)
    aShapes[nID][SHAPE_TOP]:=80
    aShapes[nID][SHAPE_LEFT]:=0
    aShapes[nID][SHAPE_WIDTH]:=317
    aShapes[nID][SHAPE_HEIGHT]:=29
    aShapes[nID][SHAPE_FILE]:=""
    aShapes[nID][SHAPE_ACTION]:={||.F.}
    aShapes[nID][SHAPE_BTNINDEX]:=0
    aShapes[nID][SHAPE_BTNNUMBER]:=0

    cProperties:=""

    AddProperty(@cProperties,"id=",aShapes[nID][SHAPE_ID])
    AddProperty(@cProperties,"type=",7)
    AddProperty(@cProperties,"top=",aShapes[nID][SHAPE_TOP])
    AddProperty(@cProperties,"left=",aShapes[nID][SHAPE_LEFT])
    AddProperty(@cProperties,"width=",aShapes[nID][SHAPE_WIDTH])
    AddProperty(@cProperties,"height=",aShapes[nID][SHAPE_HEIGHT])
    AddProperty(@cProperties,"pen-color=","#FFFFFF")
    AddProperty(@cProperties,"pen-width=","1")
    AddProperty(@cProperties,"font=","Arial,10,1,0,3")
    AddProperty(@cProperties,"text=",aShapes[nID][SHAPE_TOOLTIP])
    
    aShapes[nID][SHAPE_PROPERTIES]:=cProperties

    //URL_BTDNGAME15
    aAdd(aShapes,Array(SHAPE_ELEM))

    aShapes[nID][SHAPE_ID]:=++nID
    aShapes[nID][SHAPE_TOOLTIP]:=PadC("BlackTDN::ADVPL Games ~ GAME 15",40)
    aShapes[nID][SHAPE_TOP]:=110
    aShapes[nID][SHAPE_LEFT]:=0
    aShapes[nID][SHAPE_WIDTH]:=317
    aShapes[nID][SHAPE_HEIGHT]:=29
    aShapes[nID][SHAPE_FILE]:=""
    aShapes[nID][SHAPE_ACTION]:={||ShellExecute("open",URL_BTDNGAME15,"","",1)}
    aShapes[nID][SHAPE_BTNINDEX]:=0
    aShapes[nID][SHAPE_BTNNUMBER]:=0

    cProperties:=""

    AddProperty(@cProperties,"id=",aShapes[nID][SHAPE_ID])
    AddProperty(@cProperties,"type=",7)
    AddProperty(@cProperties,"top=",aShapes[nID][SHAPE_TOP])
    AddProperty(@cProperties,"left=",aShapes[nID][SHAPE_LEFT])
    AddProperty(@cProperties,"width=",aShapes[nID][SHAPE_WIDTH])
    AddProperty(@cProperties,"height=",aShapes[nID][SHAPE_HEIGHT])
    AddProperty(@cProperties,"pen-color=","#FFFFFF")
    AddProperty(@cProperties,"pen-width=","1")
    AddProperty(@cProperties,"font=","Arial,10,1,0,3")
    AddProperty(@cProperties,"text=",aShapes[nID][SHAPE_TOOLTIP])
    AddProperty(@cProperties,"can-mark=",1)

    aShapes[nID][SHAPE_PROPERTIES]:=cProperties


    //URL_COPYRIGHT
    aAdd(aShapes,Array(SHAPE_ELEM))
    
    aShapes[nID][SHAPE_ID]:=++nID
    aShapes[nID][SHAPE_TOOLTIP]:=PadC(URL_COPYRIGHT,40)
    aShapes[nID][SHAPE_TOP]:=140
    aShapes[nID][SHAPE_LEFT]:=0
    aShapes[nID][SHAPE_WIDTH]:=317
    aShapes[nID][SHAPE_HEIGHT]:=29
    aShapes[nID][SHAPE_FILE]:=""
    aShapes[nID][SHAPE_ACTION]:={||ShellExecute("open",URL_COPYRIGHT,"","",1)}
    aShapes[nID][SHAPE_BTNINDEX]:=0
    aShapes[nID][SHAPE_BTNNUMBER]:=0

    cProperties:=""

    AddProperty(@cProperties,"id=",aShapes[nID][SHAPE_ID])
    AddProperty(@cProperties,"type=",7)
    AddProperty(@cProperties,"top=",aShapes[nID][SHAPE_TOP])
    AddProperty(@cProperties,"left=",aShapes[nID][SHAPE_LEFT])
    AddProperty(@cProperties,"width=",aShapes[nID][SHAPE_WIDTH])
    AddProperty(@cProperties,"height=",aShapes[nID][SHAPE_HEIGHT])
    AddProperty(@cProperties,"pen-color=","#FFFFFF")
    AddProperty(@cProperties,"pen-width=","1")
    AddProperty(@cProperties,"font=","Arial,10,1,0,3")
    AddProperty(@cProperties,"text=",aShapes[nID][SHAPE_TOOLTIP])
    AddProperty(@cProperties,"can-mark=",1)

    aShapes[nID][SHAPE_PROPERTIES]:=cProperties

    //This program is Freeware!
    aAdd(aShapes,Array(SHAPE_ELEM))
    
    aShapes[nID][SHAPE_ID]:=++nID
    aShapes[nID][SHAPE_TOOLTIP]:=PadC("This program is Freeware!",40)
    aShapes[nID][SHAPE_TOP]:=170
    aShapes[nID][SHAPE_LEFT]:=0
    aShapes[nID][SHAPE_WIDTH]:=317
    aShapes[nID][SHAPE_HEIGHT]:=29
    aShapes[nID][SHAPE_FILE]:=""
    aShapes[nID][SHAPE_ACTION]:={||.F.}
    aShapes[nID][SHAPE_BTNINDEX]:=0
    aShapes[nID][SHAPE_BTNNUMBER]:=0

    cProperties:=""

    AddProperty(@cProperties,"id=",aShapes[nID][SHAPE_ID])
    AddProperty(@cProperties,"type=",7)
    AddProperty(@cProperties,"top=",aShapes[nID][SHAPE_TOP])
    AddProperty(@cProperties,"left=",aShapes[nID][SHAPE_LEFT])
    AddProperty(@cProperties,"width=",aShapes[nID][SHAPE_WIDTH])
    AddProperty(@cProperties,"height=",aShapes[nID][SHAPE_HEIGHT])
    AddProperty(@cProperties,"pen-color=","#FFFFFF")
    AddProperty(@cProperties,"pen-width=","1")
    AddProperty(@cProperties,"font=","Arial,10,1,0,3")
    AddProperty(@cProperties,"text=",aShapes[nID][SHAPE_TOOLTIP])
    
    aShapes[nID][SHAPE_PROPERTIES]:=cProperties

    //Copying is allowed!"
    aAdd(aShapes,Array(SHAPE_ELEM))
    
    aShapes[nID][SHAPE_ID]:=++nID
    aShapes[nID][SHAPE_TOOLTIP]:=Padc("Copying is allowed!",40)
    aShapes[nID][SHAPE_TOP]:=200
    aShapes[nID][SHAPE_LEFT]:=0
    aShapes[nID][SHAPE_WIDTH]:=317
    aShapes[nID][SHAPE_HEIGHT]:=29
    aShapes[nID][SHAPE_FILE]:=""
    aShapes[nID][SHAPE_ACTION]:={||.F.}
    aShapes[nID][SHAPE_BTNINDEX]:=0
    aShapes[nID][SHAPE_BTNNUMBER]:=0

    cProperties:=""

    AddProperty(@cProperties,"id=",aShapes[nID][SHAPE_ID])
    AddProperty(@cProperties,"type=",7)
    AddProperty(@cProperties,"top=",aShapes[nID][SHAPE_TOP])
    AddProperty(@cProperties,"left=",aShapes[nID][SHAPE_LEFT])
    AddProperty(@cProperties,"width=",aShapes[nID][SHAPE_WIDTH])
    AddProperty(@cProperties,"height=",aShapes[nID][SHAPE_HEIGHT])
    AddProperty(@cProperties,"pen-color=","#FFFFFF")
    AddProperty(@cProperties,"pen-width=","1")
    AddProperty(@cProperties,"font=","Arial,10,1,0,3")
    AddProperty(@cProperties,"text=",aShapes[nID][SHAPE_TOOLTIP])
    
    aShapes[nID][SHAPE_PROPERTIES]:=cProperties 

    //"OK"
    aAdd(aShapes,Array(SHAPE_ELEM))
    
    aShapes[nID][SHAPE_ID]:=++nID
    aShapes[nID][SHAPE_TOOLTIP]:="OK"
    aShapes[nID][SHAPE_TOP]:=(394-32)
    aShapes[nID][SHAPE_LEFT]:=110
    aShapes[nID][SHAPE_WIDTH]:=96
    aShapes[nID][SHAPE_HEIGHT]:=24
    aShapes[nID][SHAPE_FILE]:=oTHash:GetPropertyValue("Game15_Files_buttons","ok")
    aShapes[nID][SHAPE_ACTION]:={|x,y,oTPPanel,oTHash,cSession|oTPPanel:ClearAll(),oTPPanel:oWnd:End()}
    aShapes[nID][SHAPE_BTNINDEX]:=0
    aShapes[nID][SHAPE_BTNNUMBER]:=0

    AddProperty(@cProperties,"id=",aShapes[nID][SHAPE_ID])
    AddProperty(@cProperties,"type=",8)
    AddProperty(@cProperties,"top=",aShapes[nID][SHAPE_TOP])
    AddProperty(@cProperties,"left=",aShapes[nID][SHAPE_LEFT])
    AddProperty(@cProperties,"width=",aShapes[nID][SHAPE_WIDTH])
    AddProperty(@cProperties,"height=",aShapes[nID][SHAPE_HEIGHT])
    AddProperty(@cProperties,"image-file=",aShapes[nID][SHAPE_FILE])
    AddProperty(@cProperties,"tooltip=",aShapes[nID][SHAPE_TOOLTIP])
    AddProperty(@cProperties,"can-move=",0)
    AddProperty(@cProperties,"can-mark=",1)
    AddProperty(@cProperties,"is-container=",0)    
    
    aShapes[nID][SHAPE_PROPERTIES]:=cProperties

    nShapes:=nID
    For nShape:=1 To nShapes
        cProperties:=aShapes[nShape][SHAPE_PROPERTIES]
        oTPPanel:AddShape(cProperties)
    Next nShape

Return

/*
    Funcao:LoadGame
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:16/04/2012
    Uso:(Re)Iniciar o Jogo
*/
Static Procedure LoadGame(x,y,oTPPanel,oTHash)

    Local aIndex:=Array(0)
    Local aShapes:=oTHash:GetPropertyValue("Game15_Shapes","aShapes")
    Local aButtons:=oTHash:GetAllProperties("Game15_Files_bmps_play")

    Local cProperties

    Local ouTRect:=uTRect():New(0,0,72,72)

    Local nCol
    Local nRow

    Local nCols
    Local nRows

    Local nID:=0
    Local nData:=0
    Local nIndex:=0

    Local nButtons
    Local nMaxRand
    
    Local nShape
    Local nShapes

    SYMBOL_UNUSED(x)
    SYMBOL_UNUSED(y)

    oTPPanel:ClearAll()
    aSize(aShapes,0)

    //"MainForm"
    aAdd(aShapes,Array(SHAPE_ELEM))
    
    aShapes[nID][SHAPE_ID]:=++nID
    aShapes[nID][SHAPE_TOOLTIP]:="GAME15"
    aShapes[nID][SHAPE_TOP]:=0
    aShapes[nID][SHAPE_LEFT]:=0
    aShapes[nID][SHAPE_WIDTH]:=394
    aShapes[nID][SHAPE_HEIGHT]:=317
    aShapes[nID][SHAPE_FILE]:=oTHash:GetPropertyValue("Game15_Files_bmps_aux","mainform")
    aShapes[nID][SHAPE_ACTION]:={|x,y,oTPPanel,oTHash,cSession|.F.}
    aShapes[nID][SHAPE_BTNINDEX]:=0
    aShapes[nID][SHAPE_BTNNUMBER]:=0

    cProperties:=""

    AddProperty(@cProperties,"id=",aShapes[nID][SHAPE_ID])
    AddProperty(@cProperties,"type=",8)
    AddProperty(@cProperties,"left=",aShapes[nID][SHAPE_LEFT])
    AddProperty(@cProperties,"top=",aShapes[nID][SHAPE_TOP])
    AddProperty(@cProperties,"width=",aShapes[nID][SHAPE_WIDTH])
    AddProperty(@cProperties,"height=",aShapes[nID][SHAPE_HEIGHT])
    AddProperty(@cProperties,"tooltip=",aShapes[nID][SHAPE_TOOLTIP])
    AddProperty(@cProperties,"image-file=",aShapes[nID][SHAPE_FILE])
    AddProperty(@cProperties,"can-move=",0)
    AddProperty(@cProperties,"can-mark=",0)
    AddProperty(@cProperties,"is-container=",1)

    aShapes[nID][SHAPE_PROPERTIES]:=cProperties

    //PROGRAM+" "+VERSION
    aAdd(aShapes,Array(SHAPE_ELEM))
    
    aShapes[nID][SHAPE_ID]:=++nID
    aShapes[nID][SHAPE_TOOLTIP]:=PadC(PROGRAM+" "+VERSION,35)
    aShapes[nID][SHAPE_TOP]:=10
    aShapes[nID][SHAPE_LEFT]:=0
    aShapes[nID][SHAPE_WIDTH]:=300
    aShapes[nID][SHAPE_HEIGHT]:=29
    aShapes[nID][SHAPE_FILE]:=""
    aShapes[nID][SHAPE_ACTION]:={||.F.}
    aShapes[nID][SHAPE_BTNINDEX]:=0
    aShapes[nID][SHAPE_BTNNUMBER]:=0

    cProperties:=""

    AddProperty(@cProperties,"id=",aShapes[nID][SHAPE_ID])
    AddProperty(@cProperties,"type=",7)
    AddProperty(@cProperties,"top=",aShapes[nID][SHAPE_TOP])
    AddProperty(@cProperties,"left=",aShapes[nID][SHAPE_LEFT])
    AddProperty(@cProperties,"width=",aShapes[nID][SHAPE_WIDTH])
    AddProperty(@cProperties,"height=",aShapes[nID][SHAPE_HEIGHT])
    AddProperty(@cProperties,"pen-color=","#FFFFFF")
    AddProperty(@cProperties,"pen-width=","1")
    AddProperty(@cProperties,"font=","Arial,12,1,0,3")
    AddProperty(@cProperties,"text=",aShapes[nID][SHAPE_TOOLTIP])
    
    aShapes[nID][SHAPE_PROPERTIES]:=cProperties

/* BEGIN TODO:Descobrir uma Forma de Minimizar o DIALOG

    //"Minimize"
    aAdd(aShapes,Array(SHAPE_ELEM))
    
    aShapes[nID][SHAPE_ID]:=++nID
    aShapes[nID][SHAPE_TOOLTIP]:="Minimize"
    aShapes[nID][SHAPE_TOP]:=12
    aShapes[nID][SHAPE_LEFT]:=317-42
    aShapes[nID][SHAPE_WIDTH]:=14
    aShapes[nID][SHAPE_HEIGHT]:=14
    aShapes[nID][SHAPE_FILE]:=oTHash:GetPropertyValue("Game15_Files_bmps_aux","minbtn")
    aShapes[nID][SHAPE_ACTION]:={|x,y,oTPPanel,oTHash,cSession|.F.}
    aShapes[nID][SHAPE_BTNINDEX]:=0
    aShapes[nID][SHAPE_BTNNUMBER]:=0

    cProperties:=""

    AddProperty(@cProperties,"id=",aShapes[nID][SHAPE_ID])
    AddProperty(@cProperties,"type=",8)
    AddProperty(@cProperties,"top=",aShapes[nID][SHAPE_TOP])
    AddProperty(@cProperties,"left=",aShapes[nID][SHAPE_LEFT])
    AddProperty(@cProperties,"width=",aShapes[nID][SHAPE_WIDTH])
    AddProperty(@cProperties,"height=",aShapes[nID][SHAPE_HEIGHT])
    AddProperty(@cProperties,"image-file=",aShapes[nID][SHAPE_FILE])
    AddProperty(@cProperties,"tooltip=",aShapes[nID][SHAPE_TOOLTIP])
    AddProperty(@cProperties,"can-move=",0)
    AddProperty(@cProperties,"can-mark=",1)
    AddProperty(@cProperties,"is-container=",0)
    
    aShapes[nID][SHAPE_PROPERTIES]:=cProperties

END TODO:Descobrir uma Forma de Minimizar o DIALOG*/

    //"Close"
    aAdd(aShapes,Array(SHAPE_ELEM))
    
    aShapes[nID][SHAPE_ID]:=++nID
    aShapes[nID][SHAPE_TOOLTIP]:="Close"
    aShapes[nID][SHAPE_TOP]:=12
    aShapes[nID][SHAPE_LEFT]:=317-26
    aShapes[nID][SHAPE_WIDTH]:=14
    aShapes[nID][SHAPE_HEIGHT]:=14
    aShapes[nID][SHAPE_FILE]:=oTHash:GetPropertyValue("Game15_Files_bmps_aux","closebtn")
    aShapes[nID][SHAPE_ACTION]:={|x,y,oTPPanel,oTHash,cSession|Finalize(@x,@y,@oTPPanel,@oTHash)}
    aShapes[nID][SHAPE_BTNINDEX]:=0
    aShapes[nID][SHAPE_BTNNUMBER]:=0

    cProperties:=""

    AddProperty(@cProperties,"id=",aShapes[nID][SHAPE_ID])
    AddProperty(@cProperties,"type=",8)
    AddProperty(@cProperties,"top=",aShapes[nID][SHAPE_TOP])
    AddProperty(@cProperties,"left=",aShapes[nID][SHAPE_LEFT])
    AddProperty(@cProperties,"width=",aShapes[nID][SHAPE_WIDTH])
    AddProperty(@cProperties,"height=",aShapes[nID][SHAPE_HEIGHT])
    AddProperty(@cProperties,"image-file=",aShapes[nID][SHAPE_FILE])
    AddProperty(@cProperties,"tooltip=",aShapes[nID][SHAPE_TOOLTIP])
    AddProperty(@cProperties,"can-move=",0)
    AddProperty(@cProperties,"can-mark=",1)
    AddProperty(@cProperties,"is-container=",0)
    
    aShapes[nID][SHAPE_PROPERTIES]:=cProperties

    //"Load a game"
    aAdd(aShapes,Array(SHAPE_ELEM))
    
    aShapes[nID][SHAPE_ID]:=++nID
    aShapes[nID][SHAPE_TOOLTIP]:="Load a game"
    aShapes[nID][SHAPE_TOP]:=36
    aShapes[nID][SHAPE_LEFT]:=14
    aShapes[nID][SHAPE_WIDTH]:=96
    aShapes[nID][SHAPE_HEIGHT]:=24
    aShapes[nID][SHAPE_FILE]:=oTHash:GetPropertyValue("Game15_Files_buttons","load")
    aShapes[nID][SHAPE_ACTION]:={|x,y,oTPPanel,oTHash,cSession|RestoreGame(@x,@y,@oTPPanel,@oTHash,@cSession)}
    aShapes[nID][SHAPE_BTNINDEX]:=0
    aShapes[nID][SHAPE_BTNNUMBER]:=0

    cProperties:=""

    AddProperty(@cProperties,"id=",aShapes[nID][SHAPE_ID])
    AddProperty(@cProperties,"type=",8)
    AddProperty(@cProperties,"top=",aShapes[nID][SHAPE_TOP])
    AddProperty(@cProperties,"left=",aShapes[nID][SHAPE_LEFT])
    AddProperty(@cProperties,"width=",aShapes[nID][SHAPE_WIDTH])
    AddProperty(@cProperties,"height=",aShapes[nID][SHAPE_HEIGHT])
    AddProperty(@cProperties,"image-file=",aShapes[nID][SHAPE_FILE])
    AddProperty(@cProperties,"tooltip=",aShapes[nID][SHAPE_TOOLTIP])
    AddProperty(@cProperties,"can-move=",0)
    AddProperty(@cProperties,"can-mark=",1)
    AddProperty(@cProperties,"is-container=",0)    
    
    aShapes[nID][SHAPE_PROPERTIES]:=cProperties

    //"Start of new game"
    aAdd(aShapes,Array(SHAPE_ELEM))
    
    aShapes[nID][SHAPE_ID]:=++nID
    aShapes[nID][SHAPE_TOOLTIP]:="Start of new game"
    aShapes[nID][SHAPE_TOP]:=36
    aShapes[nID][SHAPE_LEFT]:=110
    aShapes[nID][SHAPE_WIDTH]:=96
    aShapes[nID][SHAPE_HEIGHT]:=24
    aShapes[nID][SHAPE_FILE]:=oTHash:GetPropertyValue("Game15_Files_buttons","start")
    aShapes[nID][SHAPE_ACTION]:={|x,y,oTPPanel,oTHash,cSession|LoadGame(@x,@y,@oTPPanel,@oTHash)}
    aShapes[nID][SHAPE_BTNINDEX]:=0
    aShapes[nID][SHAPE_BTNNUMBER]:=0

    AddProperty(@cProperties,"id=",aShapes[nID][SHAPE_ID])
    AddProperty(@cProperties,"type=",8)
    AddProperty(@cProperties,"top=",aShapes[nID][SHAPE_TOP])
    AddProperty(@cProperties,"left=",aShapes[nID][SHAPE_LEFT])
    AddProperty(@cProperties,"width=",aShapes[nID][SHAPE_WIDTH])
    AddProperty(@cProperties,"height=",aShapes[nID][SHAPE_HEIGHT])
    AddProperty(@cProperties,"image-file=",aShapes[nID][SHAPE_FILE])
    AddProperty(@cProperties,"tooltip=",aShapes[nID][SHAPE_TOOLTIP])
    AddProperty(@cProperties,"can-move=",0)
    AddProperty(@cProperties,"can-mark=",1)
    AddProperty(@cProperties,"is-container=",0)    

    aShapes[nID][SHAPE_PROPERTIES]:=cProperties

    //"Save a game"
    aAdd(aShapes,Array(SHAPE_ELEM))
    
    aShapes[nID][SHAPE_ID]:=++nID
    aShapes[nID][SHAPE_TOOLTIP]:="Save a game"
    aShapes[nID][SHAPE_TOP]:=36
    aShapes[nID][SHAPE_LEFT]:=206
    aShapes[nID][SHAPE_WIDTH]:=96
    aShapes[nID][SHAPE_HEIGHT]:=24
    aShapes[nID][SHAPE_FILE]:=oTHash:GetPropertyValue("Game15_Files_buttons","save")
    aShapes[nID][SHAPE_ACTION]:={|x,y,oTPPanel,oTHash,cSession|SaveGame(@x,@y,@oTPPanel,@oTHash,@cSession)}
    aShapes[nID][SHAPE_BTNINDEX]:=0
    aShapes[nID][SHAPE_BTNNUMBER]:=0

    AddProperty(@cProperties,"id=",aShapes[nID][SHAPE_ID])
    AddProperty(@cProperties,"type=",8)
    AddProperty(@cProperties,"top=",aShapes[nID][SHAPE_TOP])
    AddProperty(@cProperties,"left=",aShapes[nID][SHAPE_LEFT])
    AddProperty(@cProperties,"width=",aShapes[nID][SHAPE_WIDTH])
    AddProperty(@cProperties,"height=",aShapes[nID][SHAPE_HEIGHT])
    AddProperty(@cProperties,"image-file=",aShapes[nID][SHAPE_FILE])
    AddProperty(@cProperties,"tooltip=",aShapes[nID][SHAPE_TOOLTIP])
    AddProperty(@cProperties,"can-move=",0)
    AddProperty(@cProperties,"can-mark=",1)
    AddProperty(@cProperties,"is-container=",0)        

    aShapes[nID][SHAPE_PROPERTIES]:=cProperties

    nButtons:=Len(aButtons)

    nRows:=Sqrt(nButtons)
    nCols:=nRows
    nMaxRand:=(nButtons+1)
    For nRow:=1 To nRows

        For nCol:=1 To nCols

            nIndex:=Randomize(1,nMaxRand)

            While (aScan(aIndex,nIndex)>0)
                IF (aScan(aIndex,1)==0)
                    nIndex:=1
                    EXIT
                Else
                    nIndex:=Randomize(1,nMaxRand)
                EndIF
            End While

            aAdd(aIndex,nIndex)  

            ouTRect:nTop:=(((nCol-1) * 72)+64)
            ouTRect:nLeft:=(((nRow-1) * 72)+15)

            aAdd(aShapes,Array(SHAPE_ELEM))

            aShapes[nID][SHAPE_ID]:=++nID
            aShapes[nID][SHAPE_TOOLTIP]:=aButtons[nIndex][1]
            aShapes[nID][SHAPE_TOP]:=ouTRect:nTop
            aShapes[nID][SHAPE_LEFT]:=ouTRect:nLeft
            aShapes[nID][SHAPE_WIDTH]:=ouTRect:nWidth
            aShapes[nID][SHAPE_HEIGHT]:=ouTRect:nHeight
            aShapes[nID][SHAPE_FILE]:=aButtons[nIndex][2]
            aShapes[nID][SHAPE_ACTION]:={|x,y,oTPPanel,oTHash,cSession|IF(SwapButtons(@x,@y,@oTPPanel,@oTHash),LoadGame(x,y,@oTPPanel,@oTHash),.F.)}
            aShapes[nID][SHAPE_BTNINDEX]:=++nData
            aShapes[nID][SHAPE_BTNNUMBER]:=Val(SubStr(aButtons[nIndex][1],2))

            cProperties:=""

            AddProperty(@cProperties,"id=",aShapes[nID][SHAPE_ID])
            AddProperty(@cProperties,"type=",8)
            AddProperty(@cProperties,"top=",aShapes[nID][SHAPE_TOP])
            AddProperty(@cProperties,"left=",aShapes[nID][SHAPE_LEFT])
            AddProperty(@cProperties,"width=",aShapes[nID][SHAPE_WIDTH])
            AddProperty(@cProperties,"height=",aShapes[nID][SHAPE_HEIGHT])
            AddProperty(@cProperties,"image-file=",aShapes[nID][SHAPE_FILE])
            AddProperty(@cProperties,"tooltip=","")
            AddProperty(@cProperties,"can-move=",0)
            AddProperty(@cProperties,"can-mark=",IF(AllTrim(Str(nButtons))$aButtons[nIndex][1],0,1))
            AddProperty(@cProperties,"is-container=",0)        

            aShapes[nID][SHAPE_PROPERTIES]:=cProperties

        Next nCols

    Next nRow

    //"About"
    aAdd(aShapes,Array(SHAPE_ELEM))
    
    aShapes[nID][SHAPE_ID]:=++nID
    aShapes[nID][SHAPE_TOOLTIP]:="About"
    aShapes[nID][SHAPE_TOP]:=(394-32)
    aShapes[nID][SHAPE_LEFT]:=14
    aShapes[nID][SHAPE_WIDTH]:=96
    aShapes[nID][SHAPE_HEIGHT]:=24
    aShapes[nID][SHAPE_FILE]:=oTHash:GetPropertyValue("Game15_Files_buttons","about")
    aShapes[nID][SHAPE_ACTION]:={|x,y,oTPPanel,oTHash,cSession|MsgAbout(@oTHash)}
    aShapes[nID][SHAPE_BTNINDEX]:=0
    aShapes[nID][SHAPE_BTNNUMBER]:=0

    AddProperty(@cProperties,"id=",aShapes[nID][SHAPE_ID])
    AddProperty(@cProperties,"type=",8)
    AddProperty(@cProperties,"top=",aShapes[nID][SHAPE_TOP])
    AddProperty(@cProperties,"left=",aShapes[nID][SHAPE_LEFT])
    AddProperty(@cProperties,"width=",aShapes[nID][SHAPE_WIDTH])
    AddProperty(@cProperties,"height=",aShapes[nID][SHAPE_HEIGHT])
    AddProperty(@cProperties,"image-file=",aShapes[nID][SHAPE_FILE])
    AddProperty(@cProperties,"tooltip=",aShapes[nID][SHAPE_TOOLTIP])
    AddProperty(@cProperties,"can-move=",0)
    AddProperty(@cProperties,"can-mark=",1)
    AddProperty(@cProperties,"is-container=",0)        
    
    aShapes[nID][SHAPE_PROPERTIES]:=cProperties

    //"Top Table"
    aAdd(aShapes,Array(SHAPE_ELEM))
    
    aShapes[nID][SHAPE_ID]:=++nID
    aShapes[nID][SHAPE_TOOLTIP]:="Top Table"
    aShapes[nID][SHAPE_TOP]:=(394-32)
    aShapes[nID][SHAPE_LEFT]:=110
    aShapes[nID][SHAPE_WIDTH]:=96
    aShapes[nID][SHAPE_HEIGHT]:=24
    aShapes[nID][SHAPE_FILE]:=oTHash:GetPropertyValue("Game15_Files_buttons","top10")
    aShapes[nID][SHAPE_ACTION]:={|x,y,oTPPanel,oTHash,cSession|ShowTopTable(@oTHash)}
    aShapes[nID][SHAPE_BTNINDEX]:=0
    aShapes[nID][SHAPE_BTNNUMBER]:=0

    AddProperty(@cProperties,"id=",aShapes[nID][SHAPE_ID])
    AddProperty(@cProperties,"type=",8)
    AddProperty(@cProperties,"top=",aShapes[nID][SHAPE_TOP])
    AddProperty(@cProperties,"left=",aShapes[nID][SHAPE_LEFT])
    AddProperty(@cProperties,"width=",aShapes[nID][SHAPE_WIDTH])
    AddProperty(@cProperties,"height=",aShapes[nID][SHAPE_HEIGHT])
    AddProperty(@cProperties,"image-file=",aShapes[nID][SHAPE_FILE])
    AddProperty(@cProperties,"tooltip=",aShapes[nID][SHAPE_TOOLTIP])
    AddProperty(@cProperties,"can-move=",0)
    AddProperty(@cProperties,"can-mark=",1)
    AddProperty(@cProperties,"is-container=",0)        
    
    aShapes[nID][SHAPE_PROPERTIES]:=cProperties

    //"EXIT"
    aAdd(aShapes,Array(SHAPE_ELEM))
    
    aShapes[nID][SHAPE_ID]:=++nID
    aShapes[nID][SHAPE_TOOLTIP]:="EXIT"
    aShapes[nID][SHAPE_TOP]:=(394-32)
    aShapes[nID][SHAPE_LEFT]:=206
    aShapes[nID][SHAPE_WIDTH]:=96
    aShapes[nID][SHAPE_HEIGHT]:=24
    aShapes[nID][SHAPE_FILE]:=oTHash:GetPropertyValue("Game15_Files_buttons","exit")
    aShapes[nID][SHAPE_ACTION]:={|x,y,oTPPanel,oTHash,cSession|Finalize(@x,@y,@oTPPanel,@oTHash)}
    aShapes[nID][SHAPE_BTNINDEX]:=0
    aShapes[nID][SHAPE_BTNNUMBER]:=0

    AddProperty(@cProperties,"id=",aShapes[nID][SHAPE_ID])
    AddProperty(@cProperties,"type=",8)
    AddProperty(@cProperties,"top=",aShapes[nID][SHAPE_TOP])
    AddProperty(@cProperties,"left=",aShapes[nID][SHAPE_LEFT])
    AddProperty(@cProperties,"width=",aShapes[nID][SHAPE_WIDTH])
    AddProperty(@cProperties,"height=",aShapes[nID][SHAPE_HEIGHT])
    AddProperty(@cProperties,"image-file=",aShapes[nID][SHAPE_FILE])
    AddProperty(@cProperties,"tooltip=",aShapes[nID][SHAPE_TOOLTIP])
    AddProperty(@cProperties,"can-move=",0)
    AddProperty(@cProperties,"can-mark=",1)
    AddProperty(@cProperties,"is-container=",0)        
    
    aShapes[nID][SHAPE_PROPERTIES]:=cProperties

    nShapes:=nID
    For nShape:=1 To nShapes
        cProperties:=aShapes[nShape][SHAPE_PROPERTIES]
        oTPPanel:AddShape(cProperties)
    Next nShape

    oTHash:AddNewSession("Game15_Time")
    oTHash:AddNewProperty("Game15_Time","cStartTime",Time())
    oTHash:AddNewProperty("Game15_Time","dStartDate",Date())

Return

/*
    Funcao:SaveGame
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:18/04/2012
    Uso:Salvar o Estado atual do Jogo
*/
Static Procedure SaveGame(x,y,oTPPanel,oTHash,cSession)

    Local aSaveG
    Local aShapes

    Local cDir
    Local cExt
    Local cFile
    Local cDriver

    Local cG5File
    Local cMGFile

    Local nD
    Local nJ
    Local ncGFile

    SYMBOL_UNUSED(x)
    SYMBOL_UNUSED(y)
    SYMBOL_UNUSED(oTPPanel)
        
    BEGIN SEQUENCE

        ncGFile:=nOr(GETF_LOCALFLOPPY,GETF_LOCALHARD,GETF_NETWORKDRIVE,GETF_SHAREAWARE)
        cMGFile:="G15FileSave (g15_*.sav)|g15_*.sav"
        cG5File:=cGetFile(cMGFile,"Save Game",NIL,GetTempPath(),.T.,ncGFile,.T.,.T.)

        IF Empty(cG5File)
            BREAK
        EndIF

        aSaveG:=Array(0)
        aShapes:=oTHash:GetPropertyValue(cSession,"aShapes")

        cG5File:=Lower(cG5File)

        SplitPath(cG5File,@cDriver,@cDir,@cFile,@cExt)
        cG5File:=cDriver
        cG5File+=cDir
        cG5File+=IF(SubStr(cFile,1,4)=="g15_",cFile,"g15_"+cFile)
        IF .NOT.(cExt==".sav")
            cExt:=".sav"
        EndIF
        cG5File+=cExt

        nD:=aScan(aShapes,{|aShape|(aShape[SHAPE_BTNNUMBER]>0)})
        nJ:=(aScan(aShapes,{|aShape|(aShape[SHAPE_BTNNUMBER]==0)},nD+1)-nD)

        aEval(aShapes,{|aShape|aAdd(aSaveG,aClone(aShape))},nD,nJ)

        SaveArray(@aSaveG,@cG5File)

    END SEQUENCE

Return

/*
    Funcao:RestoreGame
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:18/04/2012
    Uso:Restaurar o Estado anterior do Jogo
*/
Static Procedure RestoreGame(x,y,oTPPanel,oTHash,cSession)

    Local aRestG
    Local aShapes

    Local cG5File
    Local cMGFile

    Local nD
    Local nJ
    Local nAT
    Local nBTn
    Local nBTns
    Local ncGFile

    SYMBOL_UNUSED(x)
    SYMBOL_UNUSED(y)

    BEGIN SEQUENCE

        ncGFile:=nOr(GETF_LOCALFLOPPY,GETF_LOCALHARD,GETF_NETWORKDRIVE,GETF_SHAREAWARE)
        cMGFile:="G15FileSave (g15_*.sav)|g15_*.sav"
        cG5File:=cGetFile(cMGFile,"Restore Game",NIL,GetTempPath(),.F.,ncGFile,.T.,.T.)

        IF Empty(cG5File)
            BREAK
        EndIF

        aRestG:=RestArray(@cG5File)

        aShapes:=oTHash:GetPropertyValue(cSession,"aShapes")

        nD:=aScan(aShapes,{|aShape|(aShape[SHAPE_BTNNUMBER]>0)})
        nJ:=(aScan(aShapes,{|aShape|(aShape[SHAPE_BTNNUMBER]==0)},nD+1)-nD)

        IF .NOT.(Len(aRestG)==nJ)
            BREAK    
        EndIF

        nBTns:=Len(aRestG)
        For nBTn:=1 To nBTns
            IF .NOT.(ValType(aRestG[nBTn])=="A")
                BREAK
            EndIF
            IF .NOT.(Len(aRestG[nBTn])==SHAPE_ELEM)
                BREAK
            EndIF
            nAT:=aScan(aShapes,{|aShape|Compare(aShape[SHAPE_TOOLTIP],aRestG[nBTn][SHAPE_TOOLTIP])},nD,nJ)
            IF (nAT==0)
                BREAK
            EndIF
            IF .NOT.(ValType(aShapes[nAT][SHAPE_TOP])==ValType(aRestG[nBTn][SHAPE_TOP]))
                BREAK
            EndIF
            IF .NOT.(ValType(aShapes[nAT][SHAPE_LEFT])==ValType(aRestG[nBTn][SHAPE_LEFT]))
                BREAK
            EndIF
            IF .NOT.(ValType(aShapes[nAT][SHAPE_BTNINDEX])==ValType(aRestG[nBTn][SHAPE_BTNINDEX]))
                BREAK
            EndIF
        Next nBTn

        For nBTn:=1 To nBTns
            nAT:=aScan(aShapes,{|aShape|Compare(aShape[SHAPE_TOOLTIP],aRestG[nBTn][SHAPE_TOOLTIP])},nD,nJ)
            aShapes[nAT][SHAPE_TOP]:=aRestG[nBTn][SHAPE_TOP]
            aShapes[nAT][SHAPE_LEFT]:=aRestG[nBTn][SHAPE_LEFT]
            aShapes[nAT][SHAPE_BTNINDEX]:=aRestG[nBTn][SHAPE_BTNINDEX]
            oTPPanel:SetPosition(aShapes[nAT][SHAPE_ID],aShapes[nAT][SHAPE_LEFT],aShapes[nAT][SHAPE_TOP])
        Next nBTn

        oTHash:AddNewProperty("Game15_Time","cStartTime",Time())
        oTHash:AddNewProperty("Game15_Time","dStartDate",Date())

    END SEQUENCE

Return

/*
    Funcao:OpenTopTable
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:16/04/2012
    Uso:Carregar a Top Table
*/
Static Procedure OpenTopTable(oTHash)

    Local aFields:={{"G15_NAME","C",30,0},{"G15_RESULT","N",6,0},{"G15_TIME","C",8,0}}

    Local cRDD:="DBFCDXADS"
    Local cG15Path:="\g15\"
    Local cG15File:=cG15Path+"game15.dat"
    Local cG15Index:=cG15Path+"game15.cdx"
    Local cG15Alias:="GAME15"

    Local lShared:=.T.

    Local nAttempts

    BEGIN SEQUENCE

        nAttempts:=0
        While .NOT.(lIsDir(cG15Path))
            MakeDir(cG15Path)
            IF .NOT.(lIsDir(cG15Path))
                Sleep(300)
                IF (++nAttempts>10)
                    BREAK
                EndIF
            EndIF    
        End While

        nAttempts:=0
        While (Select(cG15Alias)>0)
            cG15Alias:=("GAME15"+StrZero(++nAttempts,4))
        End While

        IF .NOT.(File(cG15File))
            lShared:=.F.
            dbCreate(cG15File,aFields,cRDD)
            nAttempts:=0
            While (NetErr())
                Sleep(300)
                IF (++nAttempts>10)
                    BREAK
                EndIF
                dbCreate(cG15File,aFields,cRDD)
            End While 
        EndIF

        IF .NOT.(File(cG15Index))
            lShared:=.F.        
        EndIF

        dbUseArea(.T.,cRDD,cG15File,cG15Alias,lShared,.F.)

        nAttempts:=0
        While (NetErr())
            Sleep(300)
            IF (++nAttempts>10)
                BREAK
            EndIF
            dbUseArea(.T.,cRDD,cG15File,cG15Alias,lShared,.F.)
        End While 

        IF .NOT.(lShared)
            lShared:=.T.
            (cG15Alias)->(OrdCreate(cG15Index,"GAME15_01","G15_NAME",{||G15_NAME},.F.))
            (cG15Alias)->(OrdCreate(cG15Index,"GAME15_02","G15_TIME",{||G15_TIME},.F.))
            (cG15Alias)->(dbClearIndex())
            (cG15Alias)->(dbCloseArea())
        EndIF

        IF (Select(cG15Alias)==0)
            dbUseArea(.T.,cRDD,cG15File,cG15Alias,lShared,.F.)
        EndIF    

        nAttempts:=0
        While (NetErr())
            Sleep(300)
            IF (++nAttempts>10)
                BREAK
            EndIF
            dbUseArea(.T.,cRDD,cG15File,cG15Alias,lShared,.F.)
        End While 

        (cG15Alias)->(OrdListAdd(cG15Index,"GAME15_01"))
        (cG15Alias)->(dbSetNickName("GAME15_01","G15_NAME"))

        (cG15Alias)->(OrdListAdd(cG15Index,"GAME15_02"))
        (cG15Alias)->(dbSetNickName("GAME15_02","G15_TIME"))

        (cG15Alias)->(dbOrderNickName("G15_NAME"))

        oTHash:AddNewSession("Game15_Table")

        oTHash:AddNewProperty("Game15_Table","G15_Alias",cG15Alias)

    END SEQUENCE

Return              

/*
    Funcao:SaveTopTable
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:16/04/2012
    Uso:Salvar dados na Top Table
*/
Static Procedure SaveTopTable(oTHash)

    Local cG15Name
    Local cG15Alias
    Local cNickName
    Local cElapTime
    Local cLastTime
    Local cStartTime

    Local dStartDate

    Local lLock
    Local lFound
    Local lAddNew

    Local oDlg
    Local oBtn
    Local oFont

    BEGIN SEQUENCE

        cG15Alias:=oTHash:GetPropertyValue("Game15_Table","G15_Alias")

        IF (;
                Empty(cG15Alias);
                .or.;
                (Select(cG15Alias)==0);
        )
            BREAK
        EndIF

        cStartTime:=oTHash:GetPropertyValue("Game15_Time","cStartTime")
        dStartDate:=oTHash:GetPropertyValue("Game15_Time","dStartDate")
        cStartTime:=Time2NextDay(@cStartTime,@dStartDate)[1]
        cElapTime:=ElapTime(cStartTime,Time())
        
        cG15Name:=Space(Len((cG15Alias)->G15_NAME))

        DEFINE FONT oFont NAME "Arial" SIZE 0,-15 BOLD
        DEFINE MSDIALOG oDlg TITLE OemToAnsi("You Win! Elapsed Time:"+cElapTime+". Enter your name.") FROM 0,0 TO 040,405 OF GetWndDefault() PIXEL
            @ 05,02 GET oGet VAR cG15Name PICTURE "@!" OF oDlg SIZE 170,10 PIXEL FONT oFont 
            DEFINE SBUTTON oBtn FROM 05,175 TYPE 1 ACTION oDlg:End() OF oDlg ENABLE
        ACTIVATE DIALOG oDlg CENTERED

        IF Empty(cG15Name)
            cG15Name:="NONAME"
        EndIF

        BEGIN SEQUENCE

            cNickName:=(cG15Alias)->(IndexKey())
            
            (cG15Alias)->(dbOrderNickName("G15_NAME"))

            cG15Name:=Upper(AllTrim(cG15Name))
            lFound:=(cG15Alias)->(dbSeek(cG15Name,.F.))
            lAddNew:=.NOT.(lFound)
    
            IF (lAddNew)
                (cG15Alias)->(dbAppend(.T.))    
            EndIF
    
            lLock:=(cG15Alias)->(rLock())
    
            IF .NOT.(lLock)
                BREAK
            EndIF
    
            IF (lAddNew)
                (cG15Alias)->G15_NAME:=cG15Name
                (cG15Alias)->G15_RESULT:=1
                (cG15Alias)->G15_TIME:=cElapTime
            Else
                cLastTime:=(cG15Alias)->G15_TIME
                IF Empty(cLastTime)
                    cLastTime:=cElapTime
                EndIF
                cElapTime:=G15TimeCalc(@cLastTime,@cElapTime)    
                (cG15Alias)->G15_TIME:=cElapTime
                ++(cG15Alias)->G15_RESULT
            EndIF

            (cG15Alias)->(dbUnLock())

        END SEQUENCE
        
        (cG15Alias)->(dbOrderNickName(cNickName))
    
    END SEQUENCE

Return

/*
    Funcao:G15TimeCalc
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:16/04/2012
    Uso:Calcula o Desvio Padrao do Tempo de Jogo
*/
Static Function G15TimeCalc(cTime1,cTime2)
    Local aValores:={TimeToSecs(@cTime1),TimeToSecs(@cTime2)}
    Local lPolarizado:=.F.
    Local nDesvPad:=DesvPad(@aValores,@lPolarizado)
Return(SecsToTime(Round(nDesvPad,0)))

/*
    Funcao:ShowTopTable
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:16/04/2012
    Uso:Mostar informacoes da Top Table
*/
Static Procedure ShowTopTable(oTHash)

    Local aListBox
    
    Local bInit
    Local bValid

    Local cIcon
    Local cSession
    Local cG15Alias

    Local oDlg

    Local oTPPanel
    Local oListBox

    Local oTRect
    Local ouTRect

    BEGIN SEQUENCE

        cG15Alias:=oTHash:GetPropertyValue("Game15_Table","G15_Alias")

        IF (;
                Empty(cG15Alias);
                .or.;
                (Select(cG15Alias)==0);
        )
            BREAK
        EndIF

        cSession:="Game15_ShapesTop"
            
        oTHash:AddNewSession(cSession)
        oTHash:AddNewProperty(cSession,"aShapes",Array(0))

        bInit:={||.T.}
        bValid:={||.T.}

        oTRect:=TRect():New(0,0,365,305)

        aListBox:=Array(0)
        BuildLBoxArray(@cG15Alias,@aListBox)

        cIcon:=oTHash:GetProperty("Game15_Files_ico","ico","game15.ico")
        DEFINE MSDIALOG oDlg TITLE OemToAnsi("TOP Results") FROM oTRect:nTop,oTRect:nLeft TO oTRect:nBottom,oTRect:nRight OF GetWndDefault() ICON cIcon PIXEL STYLE WS_POPUP

            ouTRect:=uTRect():New(oTRect:nTop,oTRect:nLeft,oTRect:nBottom,oTRect:nRight)

            oTPPanel:=TPaintPanel():New(ouTRect:nTop,ouTRect:nLeft,ouTRect:nWidth,ouTRect:nHeight,oDlg,.F.)
            oTPPanel:Align:=CONTROL_ALIGN_ALLCLIENT

            @ oTRect:nTop+20,oTRect:nLeft+5 LISTBOX oListBox FIELDS HEADER "Time","Result","Name" SIZE oTRect:nRight/2.05,oTRect:nBottom/2.35 OF oTPPanel PIXEL COLSIZES 15,25,50 
            oListBox:SetArray(aListBox)
            oListBox:bLine:={||(cG15Alias)->(MsGoto(aListBox[oListBox:nAT][AT_R_E_C_N_O_])),;
                                    {;
                                        aListBox[oListBox:nAT][AT_G15_TIME],;
                                        aListBox[oListBox:nAT][AT_G15_RESULT],;
                                        aListBox[oListBox:nAT][AT_G15_NAME];
                           };
                        }            

            LoadTopTable(NIL,NIL,@oTPPanel,@oTHash,@cSession,@cG15Alias,@aListBox,@oListBox)

            oTPPanel:bRClicked:={|x,y|rClick(@x,@y,@oTPPanel,@oTHash,@cSession)}
            oTPPanel:blClicked:={|x,y|lClick(@x,@y,@oTPPanel,@oTHash,@cSession)}
            oTPPanel:blDBLClick:=oTPPanel:blClicked  

            oTRect:=FreeObj(oTRect)
            ouTRect:=FreeObj(ouTRect)

        ACTIVATE DIALOG oDlg CENTERED ON INIT Eval(bInit) VALID Eval(bValid)

        oTHash:RemoveSession(cSession)

    END SEQUENCE

Return      

/*
    Funcao:BuildLBoxArray
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:16/04/2012
    Uso:Carrega informacoes para o ListBox
*/
Static Procedure BuildLBoxArray(cG15Alias,aListBox)

    Local cNickName:=(cG15Alias)->(IndexKey())

    Local nListBox:=0

    Local lBuildOk
    
    (cG15Alias)->(dbOrderNickName("G15_TIME"))

    aSize(aListBox,0)

    (cG15Alias)->(dbGoTop())

    While (cG15Alias)->(.NOT.(Eof()))

        ++nListBox
        aAdd(aListBox,Array(AT_FIELDS))
        
        aListBox[nListBox][AT_G15_TIME ]:=(cG15Alias)->G15_TIME
        aListBox[nListBox][AT_G15_RESULT]:=(cG15Alias)->G15_RESULT
        aListBox[nListBox][AT_G15_NAME ]:=(cG15Alias)->G15_NAME
        aListBox[nListBox][AT_R_E_C_N_O_]:=(cG15Alias)->(Recno())

        (cG15Alias)->(dbSkip())

    End While

    lBuildOk:=(nListBox>0)
    
    IF .NOT.(lBuildOk)

        ++nListBox
        aAdd(aListBox,Array(AT_FIELDS))
        aListBox[nListBox][AT_G15_TIME ]:=Space(Len((cG15Alias)->G15_TIME))
        aListBox[nListBox][AT_G15_RESULT]:=Space(10)
        aListBox[nListBox][AT_G15_NAME ]:=Space(Len((cG15Alias)->G15_NAME))
        aListBox[nListBox][AT_R_E_C_N_O_]:=0

    EndIF

    (cG15Alias)->(dbOrderNickName(cNickName))

Return(lBuildOk)

/*
    Funcao:LoadTopTable
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:16/04/2012
    Uso:Carregar informacoes da Top Table
*/
Static Procedure LoadTopTable(x,y,oTPPanel,oTHash,cSession,cG15Alias,aListBox,oListBox)

    Local aShapes:=oTHash:GetPropertyValue(cSession,"aShapes")

    Local cProperties

    Local nID:=0

    Local nShape
    Local nShapes

    SYMBOL_UNUSED(x)
    SYMBOL_UNUSED(y)

    oTPPanel:ClearAll()
    aSize(aShapes,0)

    //"MainForm"
    aAdd(aShapes,Array(SHAPE_ELEM))

    aShapes[nID][SHAPE_ID]:=++nID
    aShapes[nID][SHAPE_TOOLTIP]:="Top Table"
    aShapes[nID][SHAPE_TOP]:=0
    aShapes[nID][SHAPE_LEFT]:=0
    aShapes[nID][SHAPE_WIDTH]:=394
    aShapes[nID][SHAPE_HEIGHT]:=317
    aShapes[nID][SHAPE_FILE]:=oTHash:GetPropertyValue("Game15_Files_bmps_aux","mainform")
    aShapes[nID][SHAPE_ACTION]:={|x,y,oTPPanel,oTHash,cSession|.F.}
    aShapes[nID][SHAPE_BTNINDEX]:=0
    aShapes[nID][SHAPE_BTNNUMBER]:=0

    cProperties:=""

    AddProperty(@cProperties,"id=",aShapes[nID][SHAPE_ID])
    AddProperty(@cProperties,"type=",8)
    AddProperty(@cProperties,"left=",aShapes[nID][SHAPE_LEFT])
    AddProperty(@cProperties,"top=",aShapes[nID][SHAPE_TOP])
    AddProperty(@cProperties,"width=",aShapes[nID][SHAPE_WIDTH])
    AddProperty(@cProperties,"height=",aShapes[nID][SHAPE_HEIGHT])
    AddProperty(@cProperties,"tooltip=",aShapes[nID][SHAPE_TOOLTIP])
    AddProperty(@cProperties,"image-file=",aShapes[nID][SHAPE_FILE])
    AddProperty(@cProperties,"can-move=",0)
    AddProperty(@cProperties,"can-mark=",0)
    AddProperty(@cProperties,"is-container=",1)

    aShapes[nID][SHAPE_PROPERTIES]:=cProperties

    //PROGRAM+" "+VERSION
    aAdd(aShapes,Array(SHAPE_ELEM))
    
    aShapes[nID][SHAPE_ID]:=++nID
    aShapes[nID][SHAPE_TOOLTIP]:=PadC(PROGRAM+" "+VERSION,35)
    aShapes[nID][SHAPE_TOP]:=10
    aShapes[nID][SHAPE_LEFT]:=0
    aShapes[nID][SHAPE_WIDTH]:=300
    aShapes[nID][SHAPE_HEIGHT]:=29
    aShapes[nID][SHAPE_FILE]:=""
    aShapes[nID][SHAPE_ACTION]:={||.F.}
    aShapes[nID][SHAPE_BTNINDEX]:=0
    aShapes[nID][SHAPE_BTNNUMBER]:=0

    cProperties:=""

    AddProperty(@cProperties,"id=",aShapes[nID][SHAPE_ID])
    AddProperty(@cProperties,"type=",7)
    AddProperty(@cProperties,"top=",aShapes[nID][SHAPE_TOP])
    AddProperty(@cProperties,"left=",aShapes[nID][SHAPE_LEFT])
    AddProperty(@cProperties,"width=",aShapes[nID][SHAPE_WIDTH])
    AddProperty(@cProperties,"height=",aShapes[nID][SHAPE_HEIGHT])
    AddProperty(@cProperties,"pen-color=","#FFFFFF")
    AddProperty(@cProperties,"pen-width=","1")
    AddProperty(@cProperties,"font=","Arial,12,1,0,3")
    AddProperty(@cProperties,"text=",aShapes[nID][SHAPE_TOOLTIP])
    
    aShapes[nID][SHAPE_PROPERTIES]:=cProperties

    //"Close"
    aAdd(aShapes,Array(SHAPE_ELEM))
    
    aShapes[nID][SHAPE_ID]:=++nID
    aShapes[nID][SHAPE_TOOLTIP]:="Close"
    aShapes[nID][SHAPE_TOP]:=12
    aShapes[nID][SHAPE_LEFT]:=317-26
    aShapes[nID][SHAPE_WIDTH]:=14
    aShapes[nID][SHAPE_HEIGHT]:=14
    aShapes[nID][SHAPE_FILE]:=oTHash:GetPropertyValue("Game15_Files_bmps_aux","closebtn")
    aShapes[nID][SHAPE_ACTION]:={|x,y,oTPPanel,oTHash,cSession|oTPPanel:ClearAll(),oTPPanel:oWnd:End()}
    aShapes[nID][SHAPE_BTNINDEX]:=0
    aShapes[nID][SHAPE_BTNNUMBER]:=0

    cProperties:=""

    AddProperty(@cProperties,"id=",aShapes[nID][SHAPE_ID])
    AddProperty(@cProperties,"type=",8)
    AddProperty(@cProperties,"top=",aShapes[nID][SHAPE_TOP])
    AddProperty(@cProperties,"left=",aShapes[nID][SHAPE_LEFT])
    AddProperty(@cProperties,"width=",aShapes[nID][SHAPE_WIDTH])
    AddProperty(@cProperties,"height=",aShapes[nID][SHAPE_HEIGHT])
    AddProperty(@cProperties,"image-file=",aShapes[nID][SHAPE_FILE])
    AddProperty(@cProperties,"tooltip=",aShapes[nID][SHAPE_TOOLTIP])
    AddProperty(@cProperties,"can-move=",0)
    AddProperty(@cProperties,"can-mark=",1)
    AddProperty(@cProperties,"is-container=",0)
    
    aShapes[nID][SHAPE_PROPERTIES]:=cProperties

    //"OK"
    aAdd(aShapes,Array(SHAPE_ELEM))
    
    aShapes[nID][SHAPE_ID]:=++nID
    aShapes[nID][SHAPE_TOOLTIP]:="OK"
    aShapes[nID][SHAPE_TOP]:=(394-032)
    aShapes[nID][SHAPE_LEFT]:=14
    aShapes[nID][SHAPE_WIDTH]:=96
    aShapes[nID][SHAPE_HEIGHT]:=24
    aShapes[nID][SHAPE_FILE]:=oTHash:GetPropertyValue("Game15_Files_buttons","ok")
    aShapes[nID][SHAPE_ACTION]:={|x,y,oTPPanel,oTHash,cSession|oTPPanel:ClearAll(),oTPPanel:oWnd:End()}
    aShapes[nID][SHAPE_BTNINDEX]:=0
    aShapes[nID][SHAPE_BTNNUMBER]:=0

    AddProperty(@cProperties,"id=",aShapes[nID][SHAPE_ID])
    AddProperty(@cProperties,"type=",8)
    AddProperty(@cProperties,"top=",aShapes[nID][SHAPE_TOP])
    AddProperty(@cProperties,"left=",aShapes[nID][SHAPE_LEFT])
    AddProperty(@cProperties,"width=",aShapes[nID][SHAPE_WIDTH])
    AddProperty(@cProperties,"height=",aShapes[nID][SHAPE_HEIGHT])
    AddProperty(@cProperties,"image-file=",aShapes[nID][SHAPE_FILE])
    AddProperty(@cProperties,"tooltip=",aShapes[nID][SHAPE_TOOLTIP])
    AddProperty(@cProperties,"can-move=",0)
    AddProperty(@cProperties,"can-mark=",1)
    AddProperty(@cProperties,"is-container=",0)        
    
    aShapes[nID][SHAPE_PROPERTIES]:=cProperties

    //"Clear Top Table"
    aAdd(aShapes,Array(SHAPE_ELEM))
    
    aShapes[nID][SHAPE_ID]:=++nID
    aShapes[nID][SHAPE_TOOLTIP]:="Clear Top Table"
    aShapes[nID][SHAPE_TOP]:=(394-032)
    aShapes[nID][SHAPE_LEFT]:=(317-110)
    aShapes[nID][SHAPE_WIDTH]:=96
    aShapes[nID][SHAPE_HEIGHT]:=24
    aShapes[nID][SHAPE_FILE]:=oTHash:GetPropertyValue("Game15_Files_buttons","clear")
    aShapes[nID][SHAPE_ACTION]:={|x,y,oTPPanel,oTHash,cSession|ClearTopTable(@x,@y,@oTPPanel,@oTHash,@cG15Alias),BuildLBoxArray(@cG15Alias,@aListBox),oListBox:Refresh()}
    aShapes[nID][SHAPE_BTNINDEX]:=0
    aShapes[nID][SHAPE_BTNNUMBER]:=0

    AddProperty(@cProperties,"id=",aShapes[nID][SHAPE_ID])
    AddProperty(@cProperties,"type=",8)
    AddProperty(@cProperties,"top=",aShapes[nID][SHAPE_TOP])
    AddProperty(@cProperties,"left=",aShapes[nID][SHAPE_LEFT])
    AddProperty(@cProperties,"width=",aShapes[nID][SHAPE_WIDTH])
    AddProperty(@cProperties,"height=",aShapes[nID][SHAPE_HEIGHT])
    AddProperty(@cProperties,"image-file=",aShapes[nID][SHAPE_FILE])
    AddProperty(@cProperties,"tooltip=",aShapes[nID][SHAPE_TOOLTIP])
    AddProperty(@cProperties,"can-move=",0)
    AddProperty(@cProperties,"can-mark=",1)
    AddProperty(@cProperties,"is-container=",0)        
    
    aShapes[nID][SHAPE_PROPERTIES]:=cProperties

    nShapes:=nID
    For nShape:=1 To nShapes
        cProperties:=aShapes[nShape][SHAPE_PROPERTIES]
        oTPPanel:AddShape(cProperties)
    Next nShape

Return

/*
    Funcao:ClearTopTable
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:16/04/2012
    Uso:Limpar Resultado da Top Table para usuario Corrente
*/
Static Procedure ClearTopTable(x,y,oTPPanel,oTHash,cG15Alias)

    Local cG15Name
    Local cNickName

    Local lLock
    Local lFound

    Local oDlg
    Local oBtn
    Local oFont

    BEGIN SEQUENCE

        IF (;
                Empty(cG15Alias);
                .or.;
                (Select(cG15Alias)==0);
        )
            BREAK
        EndIF

        SYMBOL_UNUSED(x)
        SYMBOL_UNUSED(y)

        cNickName:=(cG15Alias)->(IndexKey())
        
        (cG15Alias)->(dbOrderNickName("G15_NAME"))

        cG15Name:=Space(Len((cG15Alias)->G15_NAME))

        DEFINE FONT oFont NAME "Arial" SIZE 0,-15 BOLD
        DEFINE MSDIALOG oDlg TITLE OemToAnsi("Enter your name.") FROM 0,0 TO 040,405 OF GetWndDefault() PIXEL
            @ 05,02 GET oGet VAR cG15Name PICTURE "@!" OF oDlg SIZE 170,10 PIXEL FONT oFont 
            DEFINE SBUTTON oBtn FROM 05,175 TYPE 1 ACTION oDlg:End() OF oDlg ENABLE
        ACTIVATE DIALOG oDlg CENTERED

        IF Empty(cG15Name)
            cG15Name:="NONAME"
        EndIF

        BEGIN SEQUENCE

            cG15Name:=Upper(AllTrim(cG15Name))
            lFound:=(cG15Alias)->(dbSeek(cG15Name,.F.))
            IF .NOT.(lFound)
                BREAK
            EndIF
    
            lLock:=(cG15Alias)->(rLock())
    
            IF .NOT.(lLock)
                BREAK
            EndIF
    
            (cG15Alias)->(dbDelete())
    
            (cG15Alias)->(dbUnLock())

        END SEQUENCE
    
        (cG15Alias)->(dbOrderNickName(cNickName))

    END SEQUENCE

Return

/*
    Funcao:AddProperty
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:16/04/2012
    Uso:Adicionar as propriedades os Shapes
*/
Static Function AddProperty(cProperties,cProperty,uValue)
    cProperties+=cProperty
    cProperties+=cValToChar(uValue)
    cProperties+=";"
Return(cProperties)

/*
    Funcao:Compare
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:18/04/2012
    Uso:Compara o Conteudo de 2 Variaveis .T. se iguais,.F. se diferente
*/
Static Function Compare(x,y)
    DEFAULT oDJLIB029:=U_DJLIB029()
Return(oDJLIB029:Compare(@x,@y))

/*
    Funcao:SaveArray
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:18/04/2012
    Uso:Salva Array em Disco
*/
Static Function SaveArray(uArray,cFileName)
    DEFAULT oDJLIB029:=U_DJLIB029()
Return(oDJLIB029:SaveArray(@uArray,@cFileName))

/*
    Funcao:RestArray
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:18/04/2012
    Uso:Restaura Array do Disco
*/
Static Function RestArray(cFileName)
    DEFAULT oDJLIB029:=U_DJLIB029()
Return(oDJLIB029:RestArray(@cFileName))

/*
    Funcao:DesvPad
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:20/04/2012
    Uso:Calcula o Desvio Padrao em um Intervalo de Valores
*/
Static Function DesvPad(aValores,lPolarizado)
    DEFAULT oDJLIB001:=U_DJLIB001()
Return(oDJLIB001:DesvPad(@aValores,@lPolarizado))

/*
    Funcao:TimeToSecs
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:20/04/2012
    Uso:Transforma a string "HH:MM:SS" em nSegundos
*/
Static Function TimeToSecs(cTime)
    DEFAULT oDJLIB030:=U_DJLIB030()
Return(oDJLIB030:TimeToSecs(cTime))

/*
    Funcao:SecsToTime
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:20/04/2012
    Uso:Transforma nSegundos na string "HH:MM:SS"
*/
Static Function SecsToTime(nSecs)
    DEFAULT oDJLIB030:=U_DJLIB030()
Return(oDJLIB030:SecsToTime(@nSecs))

/*
    Funcao:Time2NextDay
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:20/04/2012
    Uso:Tratar Time e Date no padrao "00:00:00" para Time >="24:00:00"
*/
Static Function Time2NextDay(cTime,dDate)
    DEFAULT oDJLIB030:=U_DJLIB030()
Return(oDJLIB030:Time2NextDay(@cTime,@dDate))

/*
    Funcao:__Dummy
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:16/04/2012
    Uso:Dummy
*/
Static Function __Dummy(lRecursa)
    DEFAULT lRecursa:=.F.
    BEGIN SEQUENCE
        IF .NOT.(lRecursa)
            BREAK
        EndIF
        Game15()
        HL1AlgMatch()
        HL2AlgMatch()
        HR1AlgMatch()
        HR2AlgMatch()
        VL1AlgMatch()
        VL2AlgMatch()
        VR1AlgMatch()
        VR2AlgMatch()
        lRecursa:=__Dummy(.F.)
    END SEQUENCE
Return(lRecursa)
