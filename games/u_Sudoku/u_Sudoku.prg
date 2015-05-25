#include "totvs.ch"

#xtranslate NToS([<n,...>])=>LTrim(Str([<n>]))

#DEFINE SUDOKU_ELEM 02

#DEFINE SUDOKU_OBJ  01
#DEFINE SUDOKU_VAR  02

#IFNDEF SODUKO_NO_CHANGE

    Static lIniciante:=.F.
    Static lIntermediario:=.F.
    Static lAvancado:=.F.

#ENDIF
/*
    Funcao:u_Sudolu()
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:07/10/2005
    Uso:Jogo Sudoku

    * Copyright 2005-2015 marinaldo.jesus [http://www.blacktdn.com.br]
*/
User Function Sudoku()

    Local aSvKeys:=GetKeys()
    Local aSudokuGrps:=Array(9)
    Local aSudokuElem:=Array(9)

    Local aSudokuGetNum

    Local lNewSudoku
    Local bDialogInit

    Local oDlg
    Local oFont
    Local oFontNum

    CursorWait()

        BEGIN SEQUENCE
        
            #IFNDEF SODUKO_NO_CHANGE
        
                IF !(SudokuNivel())
                    Break
                EndIF
        
            #ENDIF
        
            aEval(aSudokuElem,{|uElem,nElem|aSudokuElem[nElem]:=aClone(Array(9,SUDOKU_ELEM))})
        
            DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD
            DEFINE FONT oFontNum NAME "Courier New" SIZE 18,30 BOLD
            DEFINE MSDIALOG oDlg TITLE OemToAnsi("Sudoku:: by Naldo Dj") From 0,0 TO 610,610 OF GetWndDefault() STYLE DS_MODALFRAME STATUS PIXEL
            
                oDlg:lEscClose:=.F.
            
                @ 015,005 GROUP aSudokuGrps[1] TO 100,100 OF oDlg PIXEL
                @ 015,102 GROUP aSudokuGrps[2] TO 100,200 OF oDlg PIXEL
                @ 015,202 GROUP aSudokuGrps[3] TO 100,300 OF oDlg PIXEL
            
                @ 100,005 GROUP aSudokuGrps[4] TO 200,100 OF oDlg PIXEL
                @ 100,102 GROUP aSudokuGrps[5] TO 200,200 OF oDlg PIXEL
                @ 100,202 GROUP aSudokuGrps[6] TO 200,300 OF oDlg PIXEL
            
                @ 200,005 GROUP aSudokuGrps[7] TO 300,100 OF oDlg PIXEL
                @ 200,102 GROUP aSudokuGrps[8] TO 300,200 OF oDlg PIXEL
                @ 200,202 GROUP aSudokuGrps[9] TO 300,300 OF oDlg PIXEL
            
                aEval(aSudokuGrps,{|uElem,nElem|aSudokuGrps[nElem]:oFont:=oFont})
            
                #IFNDEF SODUKO_NO_CHANGE
                    aSudokuGetNum:=BuildSudoku(oDlg,oFontNum,@aSudokuElem,lIniciante,lIntermediario,lAvancado)
                #ELSE
                    aSudokuGetNum:=BuildSudoku(oDlg,oFontNum,@aSudokuElem)
                #ENDIF    
            
                bDialogInit:={||;
                                        ExeWhile(;
                                                    NIL,;//Variavel de Retorno que sera incrementada pelo bloco
                                                    {||Sleep(5)},;//Bloco com a Expressao de Retorno
                                                    {||!(GlbLock())},;//Expressao ou Bloco para Condicao While
                                                    NIL,;//Expressao ou Bloco para a Condicao Skip/Loop
                                                    NIL,;//Expressao ou Bloco para Exit no While
                                                    .F.,;//Se deve Mostrar o Erro nos Testes das Expressoes
                                                    .F.; //Se devera Verificar Erro nas Expressoes passadas
                                                ),;
                                        PutGlbValue("bStartSudoku","1"),;
                                        PutGlbValue("cSudokuTime","00:00:00"),;
                                        GlbUnlock(),;
                                        SdkBtnBar(oDlg,@lNewSudoku,aSvKeys,@aSudokuElem,aSudokuGetNum),;
                                        StartJob("U_SudokuExec",GetEnvServer(),.F.,"SudokuTime",{Time(),1});
                }        

            ACTIVATE MSDIALOG oDlg CENTERED ON INIT Eval(bDialogInit)
            RestKeys(aSvKeys)

        END SEQUENCE

        While !(GlbLock())
            Sleep(5)
        End While
        PutGlbValue("bStartSudoku","0")
        GlbUnlock()

    CursorArrow()

Return(NewSudoku(lNewSudoku))

Static Function NewSudoku(lNewSudoku)

    BEGIN SEQUENCE

        DEFAULT lNewSudoku:=.F.
        
        IF !(lNewSudoku)

            While !(GlbLock())
                Sleep(5)
            End While

            PutGlbValue("bStartSudoku","0")
            ClearGlbValue("bStartSudoku")
            ClearGlbValue("cSudokuTime")
            GlbUnlock()
        
            Break

        EndIF

        U_Sudoku()

    END SEQUENCE

    Return(NIL)

    Static Function SdkBtnBar(;
                                    oDlg,;
                                    lNewSudoku,;
                                    aSvKeys,;
                                    aSudokuElem,;
                                    aSudokuGetNum;
    )

    Local bButtonNewG:={||IF(MsgYesNo("Deseja Iniciar Novo Jogo?","New Game"),(oDlg:End(),RestKeys(aSvKeys),lNewSudoku:=.T.),lNewSudoku:=.F.)}
    Local bButtonAllN:={||IF((!(lChkAllNum).and.(lChkAllNum:=MsgNoYes("Deseja Desistir do Jogo?","Aviso!"))),( AllSudoku(@oDlg,@aSudokuElem,aSudokuGetNum),Eval(bButtonChkG)),.F.)}
    Local bButtonParM:={||IF(SudokuNivel(.T.),Eval(bButtonNewG),NIL)}
    Local bButtonChkG:={||ChkSudoku(@oDlg,@aSudokuElem,aSudokuGetNum,lChkAllNum)}
    Local bButtonEndG:={||IF(MsgNoYes("Deseja Sair do Jogo?","Sair"),(;
                                                                        ExeWhile(;
                                                                            NIL,;//Variavel de Retorno que sera incrementada pelo bloco
                                                                            {||Sleep(5)},;//Bloco com a Expressao de Retorno
                                                                            {||!(GlbLock())},;//Expressao ou Bloco para Condicao While
                                                                            NIL,;//Expressao ou Bloco para a Condicao Skip/Loop
                                                                            NIL,;//Expressao ou Bloco para Exit no While
                                                                            .F.,;//Se deve Mostrar o Erro nos Testes das Expressoes
                                                                            .F.; //Se devera Verificar Erro nas Expressoes passadas
                                                                         ),;
                                                                         PutGlbValue("bStartSudoku","0"),;
                                                                         GlbUnlock(),;
                                                                         oDlg:End(),;
                                                                         RestKeys(aSvKeys);
                                                                       ),;
                                                                       .F.;
                            );
    }

    Local bButtonHelp:={||SudokuHelp()}
    Local cSpace:=Space(50)

    Local oButtonBar

    Local oButtonNewG
    Local oButtonAllN
    Local oButtonParM
    Local oButtonChkG
    Local oButtonEndG
    Local oButtonHelp

    Local oTimer
    Local oElapTime

    Local lChkAllNum:=.F.

    DEFINE BUTTONBAR oButtonBar    SIZE 025,025 3D TOP OF oDlg PIXEL

    DEFINE BUTTON oButtonNewG    RESOURCE "PMSCOLOR"    OF oButtonBar GROUP ACTION Eval(bButtonNewG)    TOOLTIP OemToAnsi("Novo Jogo...<F2>")
    oButtonNewG:cTitle:=OemToAnsi("Novo")
    SetKey(VK_F2,oButtonNewG:bAction)

    DEFINE BUTTON oButtonAllN    RESOURCE "DESTINOS"    OF oButtonBar GROUP ACTION Eval(bButtonAllN)    TOOLTIP OemToAnsi('Preencher numeros...<F3>')
    oButtonAllN:cTitle:=OemToAnsi("numeros")
    SetKey(VK_F3,oButtonAllN:bAction)

    DEFINE BUTTON oButtonParM    RESOURCE "BMPPARAM"    OF oButtonBar GROUP ACTION Eval(bButtonParM)    TOOLTIP OemToAnsi('Par?etros...<F4>')
    oButtonParM:cTitle:=OemToAnsi("Config.")
    SetKey(VK_F4,oButtonParM:bAction)  

    DEFINE BUTTON oButtonChkG    RESOURCE "OK"          OF oButtonBar GROUP ACTION Eval(bButtonChkG)    TOOLTIP OemToAnsi('Ok...<Ctrl-O>')
    oButtonChkG:cTitle:=OemToAnsi("OK")
    oDlg:bSet15:=oButtonChkG:bAction
    SetKey(15,oDlg:bSet15)

    DEFINE BUTTON oButtonEndG    RESOURCE "FINAL"       OF oButtonBar GROUP ACTION Eval(bButtonEndG)    TOOLTIP OemToAnsi('Sair...<Ctrl-X>')
    oButtonEndG:cTitle:=OemToAnsi("Sair")
    oDlg:bSet24:=oButtonEndG:bAction
    SetKey(24,oDlg:bSet24)

    DEFINE BUTTON oButtonHelp    RESOURCE "S4WB016N"    OF oButtonBar GROUP ACTION Eval(bButtonHelp)    TOOLTIP OemToAnsi('Ajuda...<F1>')
    oButtonHelp:cTitle:=OemToAnsi("Ajuda")
    SetKey(VK_F1,oButtonHelp:bAction)

    #IFNDEF SODUKO_NO_CHANGE

        @ 000,080 MSGET oElapTime VAR (cSpace+GetGlbValue("cSudokuTime"))    SIZE 200,010 OF oButtonBar PIXEL WHEN .F. CENTERED

        DEFINE TIMER oTimer INTERVAL (1) ACTION (oElapTime:Refresh()) OF oDlg
        ACTIVATE TIMER oTimer
        
    #ENDIF

    oButtonBar:bRClicked:={||AllwaysTrue()}

Return(NIL)

Static Function BuildSudoku(oDlg,oFont,aSudokuElem,lIniciante,lIntermediario,lAvancado)

    Local aSudokuGetNum:=SudokuNumArray()

    Local bGetSet:={||&("{|u|IF(PCount()==0,aSudokuElem["+NToS(nLoop)+","+NToS(nItem)+","+NToS(SUDOKU_VAR)+"],aSudokuElem["+NToS(nLoop)+","+NToS(nItem)+","+NToS(SUDOKU_VAR)+"]:=u)}")}
    Local bGetVar:={||"aSudokuElem["+NToS(nLoop)+","+NToS(nItem)+","+NToS(SUDOKU_VAR)+"]"}

    Local nRow:=20
    Local cSudokuGetNum

    Local lChange

    Local nCol

    Local nItem
    Local nIntes
    Local nLoop
    Local nLoops
    Local nCntRow
    Local nCntCol
    Local nColIndex

    #IFNDEF SODUKO_NO_CHANGE
        
        Local bChange

        Local nChange1
        Local nChange2
        Local nChange3
        Local nChange4
        Local nChange5
        Local nChange6
        Local nChange7
        Local nChange8
        Local nChange9

        Local nSudokuGetNum

        IF (lIniciante)
            bChange:={||(;
                                (nSudokuGetNum==nChange1);
                                .or.;
                                (nItem==nChange1);
                                .or.;
                                (nLoop==nChange1);
                        );
            }        
        ElseIF (lIntermediario)
            bChange:={||(;
                                (nSudokuGetNum==nChange1);
                                .or.;
                                (nSudokuGetNum==nChange2);
                                .or.;
                                (nSudokuGetNum==nChange3);
                                .or.;
                                (nItem==nChange1);
                                .or.;
                                (nItem==nChange2);
                                .or.;
                                (nItem==nChange3);
                                .or.;
                                (nLoop==nChange1);
                                .or.;
                                (nLoop==nChange2);
                                .or.;
                                (nLoop==nChange3);
                            );
            }        
        ElseIF (lAvancado)
            bChange:={||(;
                                (nSudokuGetNum==nChange1);
                                .or.;
                                (nSudokuGetNum==nChange2);
                                .or.;
                                (nSudokuGetNum==nChange3);
                                .or.;
                                (nSudokuGetNum==nChange4);
                                .or.;
                                (nSudokuGetNum==nChange5);
                                .or.;
                                (nSudokuGetNum==nChange6);
                                .or.;
                                (nSudokuGetNum==nChange7);
                                .or.;
                                (nSudokuGetNum==nChange8);
                                .or.;
                                (nSudokuGetNum==nChange9);
                                .or.;
                                (nItem==nChange1);
                                .or.;
                                (nItem==nChange2);
                                .or.;
                                (nItem==nChange3);
                                .or.;
                                (nItem==nChange4);
                                .or.;
                                (nItem==nChange5);
                                .or.;
                                (nItem==nChange6);
                                .or.;
                                (nItem==nChange7);
                                .or.;
                                (nItem==nChange8);
                                .or.;
                                (nItem==nChange9);
                                .or.;
                                (nLoop==nChange1);
                                .or.;
                                (nLoop==nChange2);
                                .or.;
                                (nLoop==nChange3);
                                .or.;
                                (nLoop==nChange4);
                                .or.;
                                (nLoop==nChange5);
                                .or.;
                                (nLoop==nChange6);
                                .or.;
                                (nLoop==nChange7);
                                .or.;
                                (nLoop==nChange8);
                                .or.;
                                (nLoop==nChange9);
            );
        }
        EndIF                    
        
    #ENDIF
        
    nLoops:=Len(aSudokuElem)
    nCntRow:=0
    For nLoop:=1 To nLoops
        nItens:=Len(aSudokuElem[nLoop])
        nCol:=15
        nCntCol:=0
        nColIndex:=0
        For nItem:=1 To nItens

            cSudokuGetNum:=aSudokuGetNum[nLoop][++nColIndex]

            #IFNDEF SODUKO_NO_CHANGE

                nSudokuGetNum:=Val(cSudokuGetNum)

                nChange1:=Randomize(1,10)
                nChange2:=Randomize(1,10)
                nChange3:=Randomize(1,10)

                nChange4:=Randomize(1,10)
                nChange5:=Randomize(1,10)
                nChange6:=Randomize(1,10)

                nChange7:=Randomize(1,10)
                nChange8:=Randomize(1,10)
                nChange9:=Randomize(1,10)

                IF (lChange:=Eval(bChange))

                    cSudokuGetNum:=" "

                EndIF
            
            #ELSE
            
                lChange:=.F.
            
            #ENDIF
            
            aSudokuElem[nLoop][nItem,SUDOKU_VAR]:=cSudokuGetNum
            aSudokuElem[nLoop][nItem,SUDOKU_OBJ]:=TGet():New(;
                                                                nRow,;//01:<nRow>
                                                                nCol,;//02:<nCol>
                                                                Eval(bGetSet),;//03:bSETGET(<uVar>)
                                                                oDlg,;//04:[<oWnd>]
                                                                22,;//05:<nWidth>
                                                                22,;//06:<nHeight>
                                                                "9",;//07:<cPict>
                                                                NIL,;//08:<{ValidFunc}>
                                                                IF(lChange,NIL,CLR_WHITE),;//09:<nClrFore>
                                                                IF(lChange,NIL,CLR_BLUE),;//10:<nClrBack>
                                                                oFont,;//11:<oFont>
                                                                .T.,;//12:<.design.>
                                                                NIL,;//13:<oCursor>
                                                                .T.,;//14:<.pixel.>
                                                                NIL,;//15:<cMsg>
                                                                .F.,;//16:<.update.>
                                                                &("{||"+AllToChar(lChange)+"}"),;//17:<{uWhen}>
                                                                .T.,;//18:<.lCenter.>
                                                                .F.,;//19:<.lRight.>
                                                                NIL,;//20:[\{|nKey, nFlags, Self|<uChange>\}]
                                                                !(lChange),;//21:<.readonly.>
                                                                .F.,;//22:<.pass.>
                                                                NIL,;//23:<cF3>
                                                                Eval(bGetVar),;//24:<(uVar)>
                                                                NIL,;//25:?
                                                                NIL,;//26:[<.lNoBorder.>]
                                                                NIL,;//27:[<nHelpId>]
                                                                NIL;//28:[<.lHasButton.>]
            )
            ++nCntCol
            IF (;
                    (nCntCol==3);
                    .or.;
                    (nCntCol==6);
            )    
                IF (nCntCol==3)
                    nCol+=40
                Else
                    nCol+=45
                EndIF    
            Else
                nCol+=28
            EndIF
        Next nItem
        ++nCntRow
        IF (;
                (nCntRow==3);
                .or.;
                (nCntRow==6);
            )    
            IF (nCntRow==3)
                nRow+=40
            Else
                nRow+=45
            EndIF
        Else
            nRow+=26
        EndIF    
    Next nLoop

Return(aSudokuGetNum)

Static Function SudokuNivel(lButtonParam)

    Local aSvKeys:=GetKeys()

    Local bSet15:={||RestKeys(aSvKeys,.T.),oDlg:End()}

    Local lContinue:=.T.

    Local oRadio
    Local oDlg
    Local oGroup
    Local oFont
    Local oCheckBox

    Static lNoModify

    Static nOpcSudoku:=1

    BEGIN SEQUENCE

        DEFAULT lButtonParam:=.F.

        IF (;
                !(lButtonParam);
                .and.;    
                !Empty(lNoModify);
        )
            Break
        EndIF

        DEFAULT lNoModify:=.T.

        DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
        DEFINE MSDIALOG oDlg FROM  094,001 TO 250,350 TITLE OemToAnsi("Sudoku:: by Naldo Dj") OF GetWndDefault() STYLE DS_MODALFRAME STATUS PIXEL
        
            @ 015,005   GROUP oGroup TO 075,172 LABEL OemToAnsi("Escolha o Nivel do Jogo") OF oDlg PIXEL
            oGroup:oFont:=oFont
            
            @ 025,010   RADIO oRadio VAR nOpcSudoku ITEMS   OemToAnsi("Iniciante"),;
                                                            OemToAnsi("Intermediario"),;
                                                            OemToAnsi("Avancado");
                        SIZE 115,010 OF oDlg PIXEL
        
            @ 060,010 CHECKBOX oCheckBox VAR lNoModify PROMPT OemToAnsi("Utilizar a opcao acima ate o final do Jogo.") SIZE 160,010 OF oDlg PIXEL

            oDlg:lEscClose:=.F.//Nao permite sair ao se pressionar a tecla ESC.
        
        ACTIVATE MSDIALOG oDlg CENTERED ON INIT SdkPrmBar(oDlg,aSvKeys,lButtonParam,@lContinue)
        RestKeys(aSvKeys,.T.)

        Do Case
            Case (nOpcSudoku==1)
                lIniciante:=.T.
                lIntermediario:=.F.
                lAvancado:=.F.
            Case (nOpcSudoku==2)
                lIniciante:=.F.
                lIntermediario:=.T.
                lAvancado:=.F.
            Case (nOpcSudoku==3)
                lIniciante:=.F.
                lIntermediario:=.F.
                lAvancado:=.T.
        End Case    

    END SEQUENCE
    
Return(lContinue)

Static Function SdkPrmBar(oDlg,aSvKeys,lButtonParam,lContinue)

    Local bButtonChkG:={||oDlg:End(),RestKeys(aSvKeys)}
    Local bButtonEndG:={||IF(((lButtonParam).or.MsgNoYes("Deseja Sair do Jogo?","Sair")),(oDlg:End(),RestKeys(aSvKeys),lContinue:=.F.),NIL)}
    Local bButtonHelp:={||SudokuHelp()}

    Local oButtonBar

    Local oButtonChkG
    Local oButtonEndG
    Local oButtonHelp

    Local lChkAllNum:=.F.

    DEFINE BUTTONBAR oButtonBar    SIZE 025,025 3D TOP OF oDlg

    DEFINE BUTTON oButtonChkG    RESOURCE "OK"          OF oButtonBar GROUP ACTION Eval(bButtonChkG)    TOOLTIP OemToAnsi('Ok...<Ctrl-O>')
    oButtonChkG:cTitle:=OemToAnsi("OK")
    oDlg:bSet15:=oButtonChkG:bAction
    SetKey(15,oDlg:bSet15)

    DEFINE BUTTON oButtonEndG    RESOURCE "FINAL"       OF oButtonBar GROUP ACTION Eval(bButtonEndG)    TOOLTIP OemToAnsi('Sair...<Ctrl-X>')
    oButtonEndG:cTitle:=OemToAnsi("Sair")
    oDlg:bSet24:=oButtonEndG:bAction
    SetKey(24,oDlg:bSet24)

    DEFINE BUTTON oButtonHelp   RESOURCE "S4WB016N"    OF oButtonBar GROUP ACTION Eval(bButtonHelp)    TOOLTIP OemToAnsi('Ajuda...<F1>')
    oButtonHelp:cTitle:=OemToAnsi("Ajuda")
    SetKey(VK_F1,oButtonHelp:bAction)

    oButtonBar:bRClicked:={||AllwaysTrue()}

Return(NIL)

Static Function SudokuNumArray()

    Local aSudokuIndex
    Local aSudokuGetNum

    Local nInitRow
    Local nInitCol
    Local nColIndex
    Local nFinishRow
    Local nFinishCol
    Local nSaveInitCol
    Local nSudokuIndex

    Static aSudokuModel
    Static nSudokuModel
    Static nStcInitRow
    Static nStcInitCol

    DEFAULT nStcInitRow:=Randomize(1,10)
    DEFAULT nStcInitCol:=Randomize(1,10)

    SudokuModGet(@aSudokuModel,@nSudokuModel)

    nInitRow:=nStcInitRow
    nInitCol:=nStcInitCol

    nInitCol:=Randomize(1,10)
    nInitRow:=Randomize(1,10)
    nSudokuIndex:=Randomize(1,10)

    IF !(StrZero(nInitCol,1)$"1/4/7")
        IF (nStcInitCol==4)
            nInitCol:=7
        ElseIF (nStcInitCol==7)
            nInitCol:=4
        Else
            nInitCol:=1
        EndIF
    EndIF

    nStcInitCol:=nInitCol
    nStcInitRow:=nInitRow
    nSaveInitCol:=nInitCol

    aSudokuIndex:=aSudokuModel[nSudokuIndex] 
    nFinishRow:=Len(aSudokuIndex)

    aSudokuGetNum:=Array(9,9)
    For nInitRow:=1 To nFinishRow
        nFinishCol:=Len(aSudokuIndex[nInitRow])
        nColIndex:=0
        For nInitCol:=nSaveInitCol To nFinishCol
            aSudokuGetNum[nInitRow,++nColIndex]:=aSudokuIndex[nInitRow,nInitCol]
        Next nInitCol
        IF (nSaveInitCol>1)
            nFinishCol:=(nSaveInitCol-1)
            For nInitCol:=1 To nFinishCol
                aSudokuGetNum[nInitRow,++nColIndex]:=aSudokuIndex[nInitRow,nInitCol]
            Next nInitCol
        EndIF
    Next nInitRow

Return(aSudokuGetNum)

Static Function SudokuModGet(aSudokuModel,nSudokuModel)

    DEFAULT aSudokuModel:={;
                                    {;
                                        {"1","2","3","4","5","6","7","8","9"},;
                                        {"4","5","6","7","8","9","1","2","3"},;
                                        {"7","8","9","1","2","3","4","5","6"},;
                                        {"2","1","4","3","6","5","8","9","7"},;
                                        {"3","6","5","8","9","7","2","1","4"},;
                                        {"8","9","7","2","1","4","3","6","5"},;
                                        {"5","3","1","6","4","2","9","7","8"},;
                                        {"6","4","2","9","7","8","5","3","1"},;
                                        {"9","7","8","5","3","1","6","4","2"};
                                    },;    
                                    {;
                                        {"2","1","3","4","5","6","7","8","9"},;
                                        {"4","5","6","7","8","9","1","2","3"},;
                                        {"7","8","9","1","2","3","4","5","6"},;
                                        {"1","2","4","3","6","5","8","9","7"},;
                                        {"3","6","5","8","9","7","2","1","4"},;
                                        {"8","9","7","2","1","4","3","6","5"},;
                                        {"5","3","1","6","4","2","9","7","8"},;
                                        {"6","4","2","9","7","8","5","3","1"},;
                                        {"9","7","8","5","3","1","6","4","2"};
                                    },;
                                    {;
                                        {"3","1","2","4","5","6","7","8","9"},;
                                        {"4","5","6","7","8","9","1","2","3"},;
                                        {"7","8","9","1","2","3","4","5","6"},;
                                        {"1","2","3","5","4","7","6","9","8"},;
                                        {"5","4","7","6","9","8","2","3","1"},;
                                        {"6","9","8","2","3","1","5","4","7"},;
                                        {"2","3","1","8","6","4","9","7","5"},;
                                        {"8","6","4","9","7","5","3","1","2"},;
                                        {"9","7","5","3","1","2","8","6","4"};
                                    },;
                                    {;
                                        {"4","1","2","3","5","6","7","8","9"},;
                                        {"3","5","6","7","8","9","1","2","4"},;
                                        {"7","8","9","1","2","4","3","5","6"},;
                                        {"1","2","3","4","6","5","8","9","7"},;
                                        {"5","4","7","8","9","1","2","6","3"},;
                                        {"6","9","8","2","3","7","4","1","5"},;
                                        {"2","3","5","6","4","8","9","7","1"},;
                                        {"8","6","1","9","7","3","5","4","2"},;
                                        {"9","7","4","5","1","2","6","3","8"};
                                    },;
                                    {;
                                        {"5","1","2","3","4","6","7","8","9"},;
                                        {"3","4","6","7","8","9","1","2","5"},;
                                        {"7","8","9","1","2","5","3","4","6"},;
                                        {"1","2","3","4","5","7","6","9","8"},;
                                        {"4","5","7","6","9","8","2","1","3"},;
                                        {"6","9","8","2","1","3","4","5","7"},;
                                        {"2","3","5","8","6","1","9","7","4"},;
                                        {"8","6","1","9","7","4","5","3","2"},;
                                        {"9","7","4","5","3","2","8","6","1"};
                                    },;
                                    {;
                                        {"6","1","2","3","4","5","7","8","9"},;
                                        {"3","4","5","7","8","9","1","2","6"},;
                                        {"7","8","9","1","2","6","3","4","5"},;
                                        {"1","2","3","4","5","7","6","9","8"},;
                                        {"4","5","6","8","9","1","2","3","7"},;
                                        {"8","9","7","2","6","3","4","5","1"},;
                                        {"2","3","1","5","7","8","9","6","4"},;
                                        {"5","6","4","9","1","2","8","7","3"},;
                                        {"9","7","8","6","3","4","5","1","2"};
                                    },;
                                    {;
                                        {"7","1","2","3","4","5","6","8","9"},;
                                        {"3","4","5","6","8","9","1","2","7"},;
                                        {"6","8","9","1","2","7","3","4","5"},;
                                        {"1","2","3","4","5","6","7","9","8"},;
                                        {"4","5","6","7","9","8","2","1","3"},;
                                        {"8","9","7","2","1","3","4","5","6"},;
                                        {"2","3","8","5","6","1","9","7","4"},;
                                        {"5","6","1","9","7","4","8","3","2"},;
                                        {"9","7","4","8","3","2","5","6","1"};
                                    },;
                                    {;
                                        {"8","1","2","3","4","5","6","7","9"},;
                                        {"3","4","5","6","7","9","1","2","8"},;
                                        {"6","7","9","1","2","8","3","4","5"},;
                                        {"1","2","3","4","5","6","8","9","7"},;
                                        {"4","5","6","8","9","7","2","1","3"},;
                                        {"7","9","8","2","1","3","4","5","6"},;
                                        {"2","3","7","5","6","1","9","8","4"},;
                                        {"5","6","1","9","8","4","7","3","2"},;
                                        {"9","8","4","7","3","2","5","6","1"};
                                    },;
                                    {;
                                        {"9","1","2","3","4","5","6","7","8"},;
                                        {"3","4","5","6","7","8","1","2","9"},;
                                        {"6","7","8","1","2","9","3","4","5"},;
                                        {"1","2","3","4","5","6","8","9","7"},;
                                        {"4","5","6","8","9","7","2","1","3"},;
                                        {"7","8","9","2","1","3","4","5","6"},;
                                        {"2","3","7","5","6","1","9","8","4"},;
                                        {"5","6","1","9","8","4","7","3","2"},;
                                        {"8","9","4","7","3","2","5","6","1"};
                                    },;
                                    {;
                                        {"9","5","1","3","7","8","4","6","2"},;
                                        {"8","4","3","2","6","9","5","7","1"},;
                                        {"7","6","2","4","5","1","3","8","9"},;
                                        {"6","2","7","1","4","5","9","3","8"},;
                                        {"4","3","8","9","2","6","1","5","7"},;
                                        {"5","1","9","8","3","7","2","4","6"},;
                                        {"3","8","4","6","9","2","7","1","5"},;
                                        {"2","7","6","5","1","4","8","9","3"},;
                                        {"1","9","5","7","8","3","6","2","4"};
                                    },;                                      
                                    {;
                                        {"8","4","3","2","6","9","5","7","1"},;
                                        {"7","6","2","4","5","1","3","8","9"},;
                                        {"9","5","1","3","7","8","4","6","2"},;
                                        {"1","9","5","7","8","3","6","2","4"},;
                                        {"2","7","6","5","1","4","8","9","3"},;
                                        {"3","8","4","6","9","2","7","1","5"},;
                                        {"6","2","7","1","4","5","9","3","8"},;
                                        {"4","3","8","9","2","6","1","5","7"},;
                                        {"5","1","9","8","3","7","2","4","6"};
                                    },;                                      
                                    {;
                                        {"5","1","9","8","3","7","2","4","6"},;
                                        {"4","3","8","9","2","6","1","5","7"},;
                                        {"6","2","7","1","4","5","9","3","8"},;
                                        {"9","5","1","3","7","8","4","6","2"},;
                                        {"7","6","2","4","5","1","3","8","9"},;
                                        {"8","4","3","2","6","9","5","7","1"},;
                                        {"3","8","4","6","9","2","7","1","5"},;
                                        {"2","7","6","5","1","4","8","9","3"},;
                                        {"1","9","5","7","8","3","6","2","4"};
                                    },;                                      
                                    {;
                                        {"4","3","8","9","2","6","1","5","7"},;
                                        {"6","2","7","1","4","5","9","3","8"},;
                                        {"5","1","9","8","3","7","2","4","6"},;
                                        {"8","4","3","2","6","9","5","7","1"},;
                                        {"9","5","1","3","7","8","4","6","2"},;
                                        {"7","6","2","4","5","1","3","8","9"},;
                                        {"2","7","6","5","1","4","8","9","3"},;
                                        {"1","9","5","7","8","3","6","2","4"},;
                                        {"3","8","4","6","9","2","7","1","5"};
                                    },;
                                    {;
                                        {"9","5","1","3","7","8","4","6","2"},;
                                        {"8","4","3","2","6","9","5","7","1"},;
                                        {"7","6","2","4","5","1","3","8","9"},;
                                        {"2","7","6","5","1","4","8","9","3"},;
                                        {"1","9","5","7","8","3","6","2","4"},;
                                        {"3","8","4","6","9","2","7","1","5"},;
                                        {"4","3","8","9","2","6","1","5","7"},;
                                        {"5","1","9","8","3","7","2","4","6"},;
                                        {"6","2","7","1","4","5","9","3","8"};
                                    },;
                                    {;
                                        {"4","3","8","9","2","6","1","5","7"},;
                                        {"5","1","9","8","3","7","2","4","6"},;
                                        {"6","2","7","1","4","5","9","3","8"},;
                                        {"3","8","4","6","9","2","7","1","5"},;
                                        {"2","7","6","5","1","4","8","9","3"},;
                                        {"1","9","5","7","8","3","6","2","4"},;
                                        {"7","6","2","4","5","1","3","8","9"},;
                                        {"8","4","3","2","6","9","5","7","1"},;
                                        {"9","5","1","3","7","8","4","6","2"};
                                    },;                                      
                                    {;
                                        {"9","5","1","3","7","8","4","6","2"},;
                                        {"7","6","2","4","5","1","3","8","9"},;
                                        {"8","4","3","2","6","9","5","7","1"},;
                                        {"3","8","4","6","9","2","7","1","5"},;
                                        {"2","7","6","5","1","4","8","9","3"},;
                                        {"1","9","5","7","8","3","6","2","4"},;
                                        {"6","2","7","1","4","5","9","3","8"},;
                                        {"4","3","8","9","2","6","1","5","7"},;
                                        {"5","1","9","8","3","7","2","4","6"};
                                    },;                                      
                                    {;
                                        {"8","4","3","2","6","9","5","7","1"},;
                                        {"9","5","1","3","7","8","4","6","2"},;
                                        {"7","6","2","4","5","1","3","8","9"},;
                                        {"4","3","8","9","2","6","1","5","7"},;
                                        {"6","2","7","1","4","5","9","3","8"},;
                                        {"5","1","9","8","3","7","2","4","6"},;
                                        {"3","8","4","6","9","2","7","1","5"},;
                                        {"2","7","6","5","1","4","8","9","3"},;
                                        {"1","9","5","7","8","3","6","2","4"};
                                    },;                                      
                                    {;
                                        {"1","2","3","4","5","6","7","8","9"},;
                                        {"4","5","6","7","8","9","1","2","3"},;
                                        {"7","8","9","1","2","3","4","5","6"},;
                                        {"9","1","2","3","4","5","6","7","8"},;
                                        {"6","7","8","9","1","2","3","4","5"},;
                                        {"3","4","5","6","7","8","9","1","2"},;
                                        {"8","9","1","2","3","4","5","6","7"},;
                                        {"5","6","7","8","9","1","2","3","4"},;
                                        {"2","3","4","5","6","7","8","9","1"};
                                    },;
                                    {;
                                        {"3","6","9","4","7","1","8","5","2"},;
                                        {"4","7","1","5","8","2","9","6","3"},;
                                        {"2","5","8","3","6","9","7","4","1"},;
                                        {"7","1","4","8","2","5","3","9","6"},;
                                        {"6","9","3","7","1","4","2","8","5"},;
                                        {"5","8","2","6","9","3","1","7","4"},;
                                        {"8","3","7","2","4","6","5","1","9"},;
                                        {"9","2","6","1","5","7","4","3","8"},;
                                        {"1","4","5","9","3","8","6","2","7"};
                                    },;    
                                    {;
                                        {"3","8","4","6","9","2","7","1","5"},;
                                        {"2","7","6","5","1","4","8","9","3"},;
                                        {"1","9","5","7","8","3","6","2","4"},;
                                        {"6","2","7","1","4","5","9","3","8"},;
                                        {"4","3","8","9","2","6","1","5","7"},;
                                        {"5","1","9","8","3","7","2","4","6"},;
                                        {"9","5","1","3","7","8","4","6","2"},;
                                        {"7","6","2","4","5","1","3","8","9"},;
                                        {"8","4","3","2","6","9","5","7","1"};
                                    };                                      
                            }

    DEFAULT nSudokuModel:=Len(aSudokuModel)

Return(NIL)

Static Function AllSudoku(oDlg,aSudokuElem,aSudokuGetNum)

    Local lChkAllNum:=!MsgNoYes("Preencher apenas os numeros Faltantes?","Preencher numeros")

    Local nLoop
    Local nLoops
    Local nChkNum
    Local nNumChk

    nLoops:=Len(aSudokuGetNum)
    For nLoop:=1 To nLoops
        nNumChk:=Len(aSudokuGetNum[nLoop])
        For nChkNum:=1 To nNumChk
            IF !(aSudokuElem[nLoop][nChkNum][1]:lReadOnly)
                IF (lChkAllNum)
                    IF !(aSudokuElem[nLoop][nChkNum][2]==aSudokuGetNum[nLoop][nChkNum])
                        aSudokuElem[nLoop][nChkNum][2]:=aSudokuGetNum[nLoop][nChkNum]
                    EndIF
                Else
                    IF Empty(aSudokuElem[nLoop][nChkNum][2])
                        aSudokuElem[nLoop][nChkNum][2]:=aSudokuGetNum[nLoop][nChkNum]
                    EndIF
                EndIF
            EndIF
        Next nChkNum
    Next nLoop

Return(oDlg:Refresh())

Static Function ChkSudoku(oDlg,aSudokuElem,aSudokuGetNum,lChkAllNum)

    Local aChkOk:={}

    Local cMsgInfo
    Local cTitle 

    Local nLoop
    Local nLoops
    Local nChkNum
    Local nNumChk

    nLoops:=Len(aSudokuGetNum)
    For nLoop:=1 To nLoops
        nNumChk:=Len(aSudokuGetNum[nLoop])
        For nChkNum:=1 To nNumChk
            IF !(aSudokuElem[nLoop][nChkNum][1]:lReadOnly)
                IF (aSudokuElem[nLoop][nChkNum][2]==aSudokuGetNum[nLoop][nChkNum])
                    aSudokuElem[nLoop][nChkNum][1]:lReadOnly:=.T.
                    aSudokuElem[nLoop][nChkNum][1]:nClrPane:=CLR_GREEN
                    aSudokuElem[nLoop][nChkNum][1]:nClrText:=CLR_WHITE
                    aAdd(aChkOk,{.T.,nLoop,nChkNum})
                Else
                    aSudokuElem[nLoop][nChkNum][1]:nClrPane:=CLR_RED
                    aSudokuElem[nLoop][nChkNum][1]:nClrText:=CLR_WHITE
                    aAdd(aChkOk,{.F.,nLoop,nChkNum})
                EndIF
            EndIF
        Next nChkNum
    Next nLoop

    BEGIN SEQUENCE

        IF !(lChkAllNum)
        
            IF ((nLoop:=aScan(aChkOk,{|aOk|!(aOk[1])}))>0)
                cMsgInfo:="Existem Informacoes inconsistentes!"
                cMsgInfo+=CRLF
                cMsgInfo+="Corrija os numeros dos quadrados pintados de vermelho!"
                cTitle:="Inconsistencia"
                Break
            EndIF

            cMsgInfo:="Parabens, voce conclui a partida com sucesso!" 
            cMsgInfo+=CRLF 
            cMsgInfo+=CRLF
            cMsgInfo+="Tempo: "+GetGlbValue("cSudokuTime")
            cTitle:="OK"

        Else
        
            cMsgInfo:="Que Pena. voce desistiu do Jogo!" 
            cMsgInfo+=CRLF 
            cMsgInfo+=CRLF
            cMsgInfo+="Tempo: "+GetGlbValue("cSudokuTime")
            cTitle:="Desistente"

        EndIF

        While !(GlbLock())
            Sleep(5)
        End While
        PutGlbValue("bStartSudoku","0")
        GlbUnlock()

    END SEQUENCE

    MsgInfo(OemToAnsi(cMsgInfo),OemToAnsi(cTitle))

Return(oDlg:Refresh())

Static Function SudokuTime(cTime,nCountTime)

    #IFNDEF SODUKO_NO_CHANGE

        Local bSudokuTime:={||SudokuTime()}

        RstTimeRemaining()

        While (GetGlbValue("bStartSudoku")=="1")
            IF FreeThreads("U_SUDOKU")
                Exit
            EndIF
            While !(GlbLock())
                Sleep(5)
            End While
            PutGlbValue("cSudokuTime",TimeRemaining(cTime,nCountTime)[1])
            GlbUnlock()
        End While

    #ENDIF    

Return(NIL)

Static Function SudokuHelp()
Return(ShellExecute("open","http://naldodjblogs.blogspot.com/2008/11/sudoku-tutorial.html","","",1))

User Function SudokuExec(cExecIn,aFormParam)
         
    Local uRet

    DEFAULT cExecIn:=""
    DEFAULT aFormParam:={}

    IF !Empty(cExecIn)
        cExecIn:=BldcExecInFun(cExecIn,aFormParam)
        uRet:=&(cExecIn)
    EndIF

Return(uRet)

Static Function FreeThreads(cThread)

    Local aUserInfoArray:=GetUserInfoArray()

    Local cEnvServer:=GetEnvServer()
    Local cComputerName:=GetComputerName()

    Local nThreads:=0

    aEval(aUserInfoArray,{|aThread|IF(;
                                                (aThread[2]==cComputerName);
                                                .and.;
                                                (aThread[5]==cThread);
                                                .and.;
                                                (aThread[6]==cEnvServer),;
                                                ++nThreads,;
                                                NIL;
                                      );
                        };
    )

    lFreeThreads:=(nThreads==0)

Return(lFreeThreads)
