#INCLUDE "totvs.ch"

#DEFINE ANIMATE_DELAY    5
#DEFINE ANIMATE_SLEEP    100

Static __aStonesJump

Static __cLastWave
Static __cWAVLastTime

Static __aTTimer
Static __lStopTimers

/*

    Funcao:SapuReca()
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:23/03/2012
    Uso:Jogo SapuReca PT10

    Baseado no Original de Eleusmario Mariano Rabelo o Criador da Linguagem Interpretada "Logic Basic" :http://www.logicbasic.net/
    Ref.:http://pt.wikipedia.org/wiki/Logic_Basic

*/
Static Procedure SapuReca(oTHash,cTitle)
    
    Local aShapes

    Local bInit
    Local bValid
    Local bErrorBlock

    Local cKey
    Local cIcon
    Local cBGWAV

    Local cGIF_Frog
    Local cGIF_Freg
    Local cGIF_HFreg
    Local cGIF_flyAlone
    Local cDlgBackGround

    Local lExecute

    Local oDlg
    Local oDlgBackGround

    Local oGIF_Frog
    Local oGIF_Freg
    Local oGIF_HFreg
    Local oGIF_flyAlone

    Local oTPPanel

    Local oTimerWAV
    Local oTimerFrog
    Local oTimerFreg
    Local oTimerflyAlone

    Local nGIF_Frog
    Local nGIF_Freg
    Local nGIF_flyAlone

    Local nShapeM1Top
    Local nShapeM1Left
    Local nShapeM1Image
    Local nShapeM1Width
    Local nShapeM1Height
    
    Local oTRect
    Local ouTRect
    
    Local oMediaPlayer

    BEGIN SEQUENCE

        lExecute:=(Upper(ProcName(1))=="U_SAPURECA").or.(Upper(ProcName(2))=="U_SAPURECA")
        IF .NOT.(lExecute)
            MsgAlert("Invalid Function Call:"+ProcName(),"By By")
            BREAK
        EndIF

        StonesJump()
        DEFAULT __aTTimer:=Array(5)
        aFill(__aTTimer,.F.)

        __lStopTimers:=.F.

        bInit:={||__lStopTimers:=.F.,TActivate(@oTHash)}
        bValid:={||__lStopTimers:=.T.,Finalize(@aShapes,@oTHash)}

        nGIF_Frog:=Randomize(1,1501)
        nGIF_Freg:=Randomize(1,1501)
        nGIF_flyAlone:=Randomize(1,1501)

        nShapeM1Top:=oTHash:GetPropertyValue("SapuReca_Index","MOVE1_TOP")     
        nShapeM1Left:=oTHash:GetPropertyValue("SapuReca_Index","MOVE1_LEFT")
        nShapeM1Image:=oTHash:GetPropertyValue("SapuReca_Index","MOVE1_IMAGE")
        nShapeM1Width:=oTHash:GetPropertyValue("SapuReca_Index","MOVE1_WIDTH")
        nShapeM1Height:=oTHash:GetPropertyValue("SapuReca_Index","MOVE1_HEIGHT")
    
        oTRect:=TRect():New(0,0,497,635)

        cIcon:=oTHash:GetPropertyValue("SapuReca_Files","JOGO_ICO")
        DEFINE MSDIALOG oDlg TITLE OemToAnsi(cTitle) FROM oTRect:nTop,oTRect:nLeft TO oTRect:nBottom,oTRect:nRight OF GetWndDefault() PIXEL ICON cIcon

            ouTRect:=uTRect():New(0,0,0,0)
    
            //"SapuReca"
            cKey:=OemToAnsi("SapuReca")
            ouTRect:nTop:=oTRect:nTop
            ouTRect:nLeft:=oTRect:nLeft
            ouTRect:nWidth:=oTRect:nBottom
            ouTRect:nHeight:=oTRect:nRight
            cDlgBackGround:=oTHash:GetPropertyValue("SapuReca_Files","JOGO_BACKGROUND")
    
            @ ouTRect:nTop,ouTRect:nLeft BITMAP oDlgBackGround FILE cDlgBackGround OF oDlg SIZE ouTRect:nWidth,ouTRect:nHeight NOBORDER WHEN .F. PIXEL
            oDlgBackGround:cToolTip:=cKey
    
            ouTRect:nTop:=oTRect:nTop
            ouTRect:nLeft:=oTRect:nLeft
            ouTRect:nWidth:=oTRect:nBottom
            ouTRect:nHeight:=oTRect:nRight
            
            oTRect:=FreeObj(oTRect)
    
            oTPPanel:=TPaintPanel():New(ouTRect:nTop,ouTRect:nLeft,ouTRect:nWidth,ouTRect:nHeight,oDlg,.F.)
            oTPPanel:Align:=CONTROL_ALIGN_ALLCLIENT
    
            aShapes:=AddShapes(@oTPPanel,@oTHash)
    
            oTHash:AddNewSession("TBITMAP")
    
            //"flyAlone"
            cKey:=OemToAnsi("flyAlone")
            ouTRect:nTop:=aShapes[oTHash:GetProperty("SHAPES",cKey)][nShapeM1Top]
            ouTRect:nLeft:=aShapes[oTHash:GetProperty("SHAPES",cKey)][nShapeM1Left]
            ouTRect:nWidth:=aShapes[oTHash:GetProperty("SHAPES",cKey)][nShapeM1Width]
            ouTRect:nHeight:=aShapes[oTHash:GetProperty("SHAPES",cKey)][nShapeM1Height]
            cGIF_flyAlone:=aShapes[oTHash:GetProperty("SHAPES",cKey)][nShapeM1Image]
    
            @ ouTRect:nTop,ouTRect:nLeft BITMAP oGIF_flyAlone FILE cGIF_flyAlone OF oTPPanel SIZE ouTRect:nWidth,ouTRect:nHeight NOBORDER WHEN .F. PIXEL
            oTHash:AddNewProperty("TBITMAP","oGIF_flyAlone",oGIF_flyAlone)
            oGIF_flyAlone:cToolTip:=cKey
    
            //"Frog"
            cKey:=OemToAnsi("Frog")
            ouTRect:nTop:=aShapes[oTHash:GetProperty("SHAPES",cKey)][nShapeM1Top]
            ouTRect:nLeft:=aShapes[oTHash:GetProperty("SHAPES",cKey)][nShapeM1Left]
            ouTRect:nWidth:=aShapes[oTHash:GetProperty("SHAPES",cKey)][nShapeM1Width]
            ouTRect:nHeight:=aShapes[oTHash:GetProperty("SHAPES",cKey)][nShapeM1Height]
            cGIF_Frog:=aShapes[oTHash:GetProperty("SHAPES",cKey)][nShapeM1Image]
    
            @ ouTRect:nTop,ouTRect:nLeft BITMAP oGIF_Frog FILE cGIF_Frog OF oTPPanel SIZE ouTRect:nWidth,ouTRect:nHeight NOBORDER WHEN .F. PIXEL
            oTHash:AddNewProperty("TBITMAP","oGIF_Frog",oGIF_Frog)
            oGIF_Frog:cToolTip:=cKey
    
            //"Freg"
            cKey:=OemToAnsi("Freg")
            ouTRect:nTop:=aShapes[oTHash:GetProperty("SHAPES",cKey)][nShapeM1Top]
            ouTRect:nLeft:=aShapes[oTHash:GetProperty("SHAPES",cKey)][nShapeM1Left]
            ouTRect:nWidth:=aShapes[oTHash:GetProperty("SHAPES",cKey)][nShapeM1Width]
            ouTRect:nHeight:=aShapes[oTHash:GetProperty("SHAPES",cKey)][nShapeM1Height]
            cGIF_Freg:=aShapes[oTHash:GetProperty("SHAPES",cKey)][nShapeM1Image]
    
            @ ouTRect:nTop,ouTRect:nLeft BITMAP oGIF_Freg FILE cGIF_Freg OF oTPPanel SIZE ouTRect:nWidth,ouTRect:nHeight NOBORDER WHEN .F. PIXEL
            oTHash:AddNewProperty("TBITMAP","oGIF_Freg",oGIF_Freg)
            oGIF_Freg:cToolTip:=cKey
    
            //"Hide Freg"
            cGIF_HFreg:=aShapes[oTHash:GetProperty("SHAPES",cKey)][nShapeM1Image]
    
            @ ouTRect:nTop,ouTRect:nLeft BITMAP oGIF_HFreg FILE cGIF_HFreg OF oTPPanel SIZE ouTRect:nWidth,ouTRect:nHeight NOBORDER WHEN .F. PIXEL
            oTHash:AddNewProperty("TBITMAP","oGIF_HFreg",oGIF_HFreg)
            oGIF_HFreg:cToolTip:=cKey
            oGIF_HFreg:Hide()
            
            ouTRect:=FreeObj(ouTRect)
    
            //BGWAV
            cBGWAV:=oTHash:GetPropertyValue("SapuReca_Waves","SOM_BACKGROUND")
    
            oTHash:AddNewSession("TTIMER")

            DEFINE TIMER oTimerWAV OF oDlg INTERVAL 1 ACTION Eval(oTimerWAV:bAction)
            oTimerWAV:bAction:={||TPlayWAV(1,@cBGWAV,@oTHash)}
            oTHash:AddNewProperty("TTIMER","oTimerWAV",@oTimerWAV)
            
            DEFINE TIMER oTimerFrog OF oDlg INTERVAL 1 ACTION Eval(oTimerFrog:bAction)
            oTimerFrog:bAction:={||TPlayGIF(2,@nGIF_Frog,oGIF_Frog:cToolTip,@oGIF_Frog,@aShapes,@oTHash)}
            oTHash:AddNewProperty("TTIMER","oTimerFrog",@oTimerFrog)
            
            DEFINE TIMER oTimerFreg OF oDlg INTERVAL 1 ACTION Eval(oTimerFreg:bAction)
            oTimerFreg:bAction:={||TPlayGIF(3,@nGIF_Freg,oGIF_Freg:cToolTip,@oGIF_HFreg,@aShapes,@oTHash,.T.)}
            oTHash:AddNewProperty("TTIMER","oTimerFreg",@oTimerFreg)
            
            DEFINE TIMER oTimerflyAlone OF oDlg INTERVAL 1 ACTION Eval(oTimerflyAlone:bAction)
            oTimerflyAlone:bAction:={||TPlayGIF(4,@nGIF_flyAlone,oGIF_flyAlone:cToolTip,@oGIF_flyAlone,@aShapes,@oTHash)}
            oTHash:AddNewProperty("TTIMER","oTimerflyAlone",@oTimerflyAlone)

            IF (GetBuild()>"7.00.120420A-20120726")
                bErrorBlock:=ErrorBlock({|e|BREAK(e)})
                BEGIN SEQUENCE
                    oMediaPlayer:=TMediaPlayer():New(0,0,0,0,oDlg,"",50,.F.)
                    oTHash:AddNewSession("MEDIA_PLAYER")
                    oTHash:AddNewProperty("MEDIA_PLAYER","oMediaPlayer",@oMediaPlayer)
                END SEQUENCE
                ErrorBlock(bErrorBlock)    
            EndIF    

            oTPPanel:bRClicked:={|x,y|rClick(@x,@y,@oTPPanel,@aShapes,@oTHash)}
            oTPPanel:blClicked:={|x,y|lClick(@x,@y,@oTPPanel,@aShapes,@oTHash)}
            oTPPanel:blDBLClick:=oTPPanel:blClicked  
    
        ACTIVATE DIALOG oDlg CENTERED ON INIT Eval(bInit) VALID Eval(bValid)
    
        bInit:=NIL
        bValid:=NIL
    
        RemoveFiles(@aShapes,@oTHash)
        aSize(aShapes,0)
        aShapes:=NIL

    END SEQUENCE

Return

/*
    Funcao:StonesJump
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:26/03/2012
    Uso:Define as Posicoes para Salto
*/
Static Procedure StonesJump()

    DEFAULT __aStonesJump:=Array(7)

    __aStonesJump[1]:=3
    __aStonesJump[2]:=2
    __aStonesJump[3]:=1
    __aStonesJump[4]:=0
    __aStonesJump[5]:=6
    __aStonesJump[6]:=5
    __aStonesJump[7]:=4

Return

/*
    Funcao:SetFinalize
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:31/03/2012
    Uso:Seta a Finalizacao
*/
Static Function SetFinalize(oTHash,lFinalize)
    DEFAULT lFinalize:=.T.
    IF (__lStopTimers)
        lFinalize:=.T.
    EndIF
    oTHash:SetPropertyValue("FINALIZE","Finalize",lFinalize)
Return(lFinalize)

/*
    Funcao:GetFinalize
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:31/03/2012
    Uso:Verifica se em processo de Finalizacao
*/
Static Function GetFinalize(oTHash)
    IF (__lStopTimers)
        SetFinalize(@oTHash,.T.)
    EndIF
Return(__lStopTimers.or.oTHash:GetProperty("FINALIZE","Finalize"))

/*
    Funcao:Finalize
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:23/03/2012
    Uso:Acao do Botao Direito do Mouse
*/
Static Function Finalize(aShapes,oTHash)

    Local lRet:=.T.

    BEGIN SEQUENCE

        Stop_Wave(@oTHash,.T.)

        __lStopTimers:=.T.

        SetFinalize(@oTHash,.T.)

        IF ((aScan(__aTTimer,{|lPlay|lPlay}))>0)
            ConOut("Sapurece diz:[Impossível Finalizar. Tente Novamente!]")
            MsgAlert("Impossível Finalizar. Tente Novamente!","Sapurece diz")
            lRet:=.F.
            BREAK
        End While

        TDeactivate(@oTHash,.T.)
    
        MsgInfo("Sapurece diz:Coach... Coach...!","By By")
    
        oTHash:RemoveSession("TBITMAP")
        oTHash:RemoveSession("SHAPES")

    END SEQUENCE

Return(lRet)

/*
    Funcao:TActivate
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:23/03/2012
    Uso:Reativacao dos Timers
*/
Static Procedure TActivate(oTHash)

    Local aAllTimer:=oTHash:GetAllProperties("TTIMER")
    
    Local nTimer
    Local nTimers:=Len(aAllTimer)

    For nTimer:=1 TO nTimers
        aAllTimer[nTimer][2]:Activate()
    Next nTimer

Return

/*
    Funcao:TDeactivate
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:23/03/2012
    Uso:Desativacao dos Timers
*/
Static Procedure TDeactivate(oTHash,lRemove)

    Local aAllTimer:=oTHash:GetAllProperties("TTIMER")

    Local nTimer
    Local nTimers:=Len(aAllTimer)

    For nTimer:=1 TO nTimers
        aAllTimer[nTimer][2]:DeActivate()
        aAllTimer[nTimer][2]:End()
    Next nTimer

    DEFAULT lRemove:=.F.
    IF (lRemove)
        aSize(aAllTimer,0)
        oTHash:RemoveSession("TTIMER")
    EndIF

    aAllTimer:=NIL

Return

/*
    Funcao:rClick
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:23/03/2012
    Uso:Acao do Botao Direito do Mouse
*/
Static Function rClick(x,y,oTPPanel,oTHash)
Return(.T.)

/*
    Funcao:lClick
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:23/03/2012
    Uso:Acao do Botao Esquerdo do Mouse
*/
Static Function lClick(x,y,oTPPanel,aShapes,oTHash)

    Local bAction
    
    Local nShape:=oTPPanel:ShapeAtu
    Local nATShape:=aScan(aShapes,{|aShape|(aShape[oTHash:GetPropertyValue("SapuReca_Index","ID")]==nShape).and.(aShape[oTHash:GetPropertyValue("SapuReca_Index","MARK")]==1)})

    Local lAction:=(nATShape>0)

    IF (lAction)

        bAction:=aShapes[nShape][oTHash:GetPropertyValue("SapuReca_Index","BACTION")]
        Eval(bAction,@x,@y,@oTPPanel,@aShapes,@oTHash)

    EndIF

Return(.T.)

/*
    Funcao:JumpFrog
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:23/03/2012
    Uso:Acao
*/
Static Procedure JumpFrog(x,y,oTPPanel,aShapes,oTHash)

    Local bFinalG

    Local cObjGIF
    Local cToolTip

    Local cFrame
    Local cFSession
    Local cPlayWave
    Local cDirection 

    Local lJump
    Local lJump_1
    Local lJump_2
    Local lClicked
    Local lFinalize

    Local nJump
    Local nShape
    Local nIndex
    Local nATPos
    Local nATJump

    Local n4AShape
    Local n4PShape

    Local n4Diff
    
    Local ouTRect_1
    Local ouTRect_2
    Local oObjGIF

    BEGIN SEQUENCE 

        lFinalize:=GetFinalize(@oTHash)
        IF (lFinalize)
            BREAK
        EndIF

        bFinalG:={||(__aStonesJump[4]==0.and.(__aStonesJump[1]+__aStonesJump[2]+__aStonesJump[3])==15)}
    
        IF (Eval(bFinalG))
            BREAK
        EndIF

        lJump:=.F.
        lJump_1:=.F.
        lJump_2:=.F.
        lClicked:=.F.

        nShape:=oTPPanel:ShapeAtu
        ouTRect_1:=uTRect():New(0,0,0,0)

        ouTRect_1:nTop:=aShapes[nShape][oTHash:GetPropertyValue("SapuReca_Index","TOP")]
        ouTRect_1:nLeft:=aShapes[nShape][oTHash:GetPropertyValue("SapuReca_Index","LEFT")]
        ouTRect_1:nWidth:=aShapes[nShape][oTHash:GetPropertyValue("SapuReca_Index","WIDTH")]
        ouTRect_1:nHeight:=aShapes[nShape][oTHash:GetPropertyValue("SapuReca_Index","HEIGHT")]

        n4AShape:=Sqrt(ouTRect_1:nTop+ouTRect_1:nLeft+ouTRect_1:nWidth+ouTRect_1:nHeight)
        n4PShape:=Sqrt(x+y+ouTRect_1:nWidth+ouTRect_1:nHeight)

        n4Diff:=Abs(n4AShape - n4PShape)

        cDirection:=aShapes[nShape][oTHash:GetPropertyValue("SapuReca_Index","DIRECTION")]
        IF (cDirection=="R")
            lClicked:=(n4Diff>=1.and.n4Diff<=2)
        ElseIF (cDirection=="L")
            lClicked:=(n4Diff>=.4.and.n4Diff<=2)        
        EndIF
    
        IF .NOT.(lClicked)
            BREAK
        EndIF

        lFinalize:=GetFinalize(@oTHash)
        IF (lFinalize)
            BREAK
        EndIF

        oTPPanel:SetVisible(@oTHash:GetProperty("SHAPES",OemToAnsi("Instruções")),.F.)
        oTPPanel:SetVisible(@oTHash:GetProperty("SHAPES",OemToAnsi("Reiniciar")),.T.)

        cToolTip:=aShapes[nShape][oTHash:GetPropertyValue("SapuReca_Index","TOOLTIP")]
        cImageFile:=aShapes[nShape][oTHash:GetPropertyValue("SapuReca_Index","IMAGE")]
        
        cPlayWave:=Play_Wave(1,oTHash:GetPropertyValue("SapuReca_Waves","SOM_SAPU_RECA"),@oTHash)

        ConOut("SapuReca diz:["+cToolTip+"][Coach...]["+AllTrim(Str(n4Diff))+"]")

        BEGIN SEQUENCE

            nIndex:=aShapes[nShape][oTHash:GetPropertyValue("SapuReca_Index","INDEX")]
            nATPos:=aScan(__aStonesJump,nIndex)
            nATJump:=nATPos
            
            IF (cDirection=="R")
                IF (__aStonesJump[nATPos]==nIndex)
                    IF (++nATJump<=7)
                           lJump:=(__aStonesJump[nATJump]==0)
                           IF .NOT.(lJump)
                               IF (++nATJump<=7)
                                   lJump:=(__aStonesJump[nATJump]==0)
                                   lJump_2:=lJump
                               EndIF    
                           Else
                               lJump_1:=lJump
                           EndIF
                       EndIF    
                EndIF
            ElseIF (cDirection=="L")
                IF (__aStonesJump[nATPos]==nIndex)
                    IF (--nATJump>=1)
                        lJump:=(__aStonesJump[nATJump]==0)
                        IF .NOT.(lJump)
                            IF (--nATJump>=1)
                                lJump:=(__aStonesJump[nATJump]==0)
                                lJump_2:=lJump
                            EndIF    
                        Else
                            lJump_1:=lJump
                        EndIF
                    EndIF    
                EndIF
            EndIF

            IF .NOT.(lJump)
                MsgInfo("SapuReca "+cToolTip+" Coach...!",OemToAnsi("Atenção"))
                BREAK
            EndIF

            __aStonesJump[nATPos]:=0
            __aStonesJump[nATJump]:=nIndex

            IF (lJump_1)
    
                cFrame:="MOVE1_FRAME"
                cFSession:="MOVE1_IMAGE"
                
                cObjGIF:=aShapes[nShape][oTHash:GetPropertyValue("SapuReca_Index","MOVE1_IMAGE")]

                nJump:=aShapes[nShape][oTHash:GetPropertyValue("SapuReca_Index","MOVE1_JUMP")]
    
                ouTRect_1:nTop:=aShapes[nShape][oTHash:GetPropertyValue("SapuReca_Index","MOVE1_TOP")]
                ouTRect_1:nLeft:=aShapes[nShape][oTHash:GetPropertyValue("SapuReca_Index","MOVE1_LEFT")]
                ouTRect_1:nWidth:=aShapes[nShape][oTHash:GetPropertyValue("SapuReca_Index","MOVE1_WIDTH")]
                ouTRect_1:nHeight:=aShapes[nShape][oTHash:GetPropertyValue("SapuReca_Index","MOVE1_HEIGHT")]
                
            ElseIF (lJump_2)
    
                cFrame:="MOVE2_FRAME"
                cFSession:="MOVE2_IMAGE"
                
                cObjGIF:=aShapes[nShape][oTHash:GetPropertyValue("SapuReca_Index","MOVE2_IMAGE")]

                nJump:=aShapes[nShape][oTHash:GetPropertyValue("SapuReca_Index","MOVE2_JUMP")]
    
                ouTRect_1:nTop:=aShapes[nShape][oTHash:GetPropertyValue("SapuReca_Index","MOVE2_TOP")]
                ouTRect_1:nLeft:=aShapes[nShape][oTHash:GetPropertyValue("SapuReca_Index","MOVE2_LEFT")]
                ouTRect_1:nWidth:=aShapes[nShape][oTHash:GetPropertyValue("SapuReca_Index","MOVE2_WIDTH")]
                ouTRect_1:nHeight:=aShapes[nShape][oTHash:GetPropertyValue("SapuReca_Index","MOVE2_HEIGHT")]

            EndIF    

            aShapes[nShape][oTHash:GetPropertyValue("SapuReca_Index","MOVE1_LEFT")]+=(nJump/2)
            aShapes[nShape][oTHash:GetPropertyValue("SapuReca_Index","MOVE2_LEFT")]+=(nJump/2)

            oTPPanel:SetVisible(nShape,.F.)

            ouTRect_2:=uTRect():New(ouTRect_1:nTop,ouTRect_1:nLeft,ouTRect_1:nWidth,ouTRect_1:nHeight)
    
            @ ouTRect_2:nTop,ouTRect_2:nLeft BITMAP oObjGIF FILE cObjGIF OF oTPPanel SIZE ouTRect_2:nWidth,ouTRect_2:nHeight NOBORDER WHEN .F. PIXEL
            oObjGIF:cToolTip:=cToolTip
            
            ouTRect_2:=FreeObj(ouTRect_2)

            PlayFrog(5,@cToolTip,@oObjGIF,@aShapes,@oTHash,@cFrame,@cFSession)

            oObjGIF:Hide()
            oObjGIF:=oObjGIF:Free()

            ouTRect_1:nTop:=aShapes[nShape][oTHash:GetPropertyValue("SapuReca_Index","TOP")]
            ouTRect_1:nLeft:=aShapes[nShape][oTHash:GetPropertyValue("SapuReca_Index","LEFT")]
    
            ouTRect_1:nLeft+=nJump
            aShapes[nShape][oTHash:GetPropertyValue("SapuReca_Index","LEFT")]:=ouTRect_1:nLeft

            oTPPanel:SetPosition(nShape,ouTRect_1:nLeft,ouTRect_1:nTop)
            oTPPanel:SetVisible(nShape,.T.)
            
            ouTRect_1:=FreeObj(ouTRect_1)

        END SEQUENCE

        Stop_Wave(@oTHash,.F.)

        IF (Eval(bFinalG))
            cPlayWave:=oTHash:GetProperty("SapuReca_Waves","SOM_APLAUSOS","aplausos.wav")
            ConOut("Sapurece diz:[Aplausos... clap! clap! clap!]")
            Play_Wave(1,@cPlayWave,@oTHash)
            SetFinalize(@oTHash,.T.)
            ConOut("Sapurece diz:[Parabens! Voce Venceu o Jogo!]")
            oTPPanel:SetVisible(oTHash:GetProperty("SHAPES",OemToAnsi("Parabéns")),.T.)
        Else
            Play_Wave(1,@cPlayWave,@oTHash)
        EndIF

    END SEQUENCE

Return

/*
    Funcao:Restart
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:23/03/2012
    Uso:Reinicia o Jogo
*/
Static Procedure Restart(x,y,oTPPanel,aShapes,oTHash)

    Local cBGWAV
    
    Local lGIF

    BEGIN SEQUENCE

        IF (__lStopTimers)
            ConOut("Sapurece diz:[Impossível Reiniciar. Jogo em Processo de Finalizacao]")
            MsgAlert("Impossível Reiniciar. Jogo em Processo de Finalização","Sapurece diz")
            BREAK
        EndIF

        IF ((aScan(__aTTimer,{|lPlay|lPlay}))>0)
            SetFinalize(@oTHash,.T.)
            ConOut("Sapurece diz:[Impossível Reiniciar. Tente Novamente!]")
            MsgAlert("Impossível Reiniciar. Tente Novamente!","Sapurece diz")
            BREAK
        EndIF

        cBGWAV:=oTHash:GetPropertyValue("SapuReca_Waves","SOM_BACKGROUND")
    
        lGIF:=oTHash:ExistSession("TBITMAP")

        SetFinalize(@oTHash,.T.)
    
        Stop_Wave(@oTHash,.F.)
    
        StonesJump()
    
        TDeactivate(@oTHash,.F.)
    
        oTPPanel:Hide()
    
        IF (lGIF)
            oTHash:GetPropertyValue("TBITMAP","oGIF_Frog"):Hide()
            oTHash:GetPropertyValue("TBITMAP","oGIF_Freg"):Hide()
            oTHash:GetPropertyValue("TBITMAP","oGIF_HFreg"):Hide()
            oTHash:GetPropertyValue("TBITMAP","oGIF_flyAlone"):Hide()
        EndIF
    
        oTPPanel:ClearAll()
    
        RemoveFiles(@aShapes,@oTHash)
        aSize(aShapes,0)
    
        aShapes:=AddShapes(@oTPPanel,@oTHash)
        
        oTPPanel:Show()
    
        IF (lGIF)
            oTHash:GetPropertyValue("TBITMAP","oGIF_Frog"):Show()
            oTHash:GetPropertyValue("TBITMAP","oGIF_Freg"):Show()
            oTHash:GetPropertyValue("TBITMAP","oGIF_flyAlone"):Show()
        EndIF    
    
        SetFinalize(@oTHash,.F.)
    
        TPlayWAV(1,@cBGWAV,@oTHash)
    
        TActivate(@oTHash)

    END SEQUENCE

Return

/*
    Funcao:AddProperty
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:23/03/2012
    Uso:Adicionar as propriedades os Shapes
*/
Static Function AddProperty(cProperties,cProperty,uValue)
    cProperties+=cProperty
    cProperties+=cValToChar(uValue)
    cProperties+=";"
Return(cProperties)

/*
    Funcao:Play_Wave
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:23/03/2012
    Uso:Play Wave
*/
Static Function Play_Wave(nTTimer,cWavFile,oTHash)
    Local cDir
    Local cExt
    Local cFile
    Local cDriver
    Local lPlay_Wave:=.NOT.(GetFinalize(@oTHash))
    Local oMediaPlayer
    IF (lPlay_Wave)
        __aTTimer[nTTimer]:=.T.
        oMediaPlayer:=oTHash:GetPropertyValue("MEDIA_PLAYER","oMediaPlayer")
        IF (ValType(oMediaPlayer)=="O")
            oMediaPlayer:Openfile(cWavFile)
            oMediaPlayer:Play()
        Else    
            SplitPath(cWavFile,@cDriver,@cDir,@cFile,@cExt)
            //TODO:Resolver. Quem esta me executando? wmplayer.exe?
            ShellExecute("Open",cWavFile,"",cDriver+cDir,0)
        EndIF    
        DEFAULT __cLastWave:=cWavFile
        cFile:=__cLastWave
        IF .NOT.(cFile==cWavFile)
            __cLastWave:=cWavFile
        EndIF
        __aTTimer[nTTimer]:=.F.
    EndIF
Return(cFile)

/*
    Funcao:Stop_Wave
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:23/03/2012
    Uso:Stop Play_Wave
*/
Static Function Stop_Wave(oTHash,lLastWaveClear)
    Local cWinExec:="TASKKILL /F /IM wmplayer.exe"
    Local bErrorBlock       
    Local lSleep:=.T.
    Local oMediaPlayer:=oTHash:GetPropertyValue("MEDIA_PLAYER","oMediaPlayer")
    IF (ValType(oMediaPlayer)=="O")
        bErrorBlock:=ErrorBlock({|e|BREAK(e)})
        BEGIN SEQUENCE
            oMediaPlayer:Stop()
            lSleep:=.F.
        RECOVER
            //TODO:Resolver. Nem Todo Mundo usa wmplayer.exe
            WinExec(cWinExec)
        END SEQUENCE
        ErrorBlock(bErrorBlock)    
    Else
        //TODO:Resolver. Nem Todo Mundo usa wmplayer.exe
        WinExec(cWinExec)
    EndIF    
    DEFAULT lLastWaveClear:=.F.
    IF (lLastWaveClear)
        __cLastWave:=NIL
        __cWAVLastTime:=NIL
    EndIF
Return(IF(lSleep,Sleep(500),NIL))

/*
    Funcao:GIFFrames
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:23/03/2012
    Uso:Obtem os Frames dos GIFs Animados
*/
Static Function GIFFrames(cGIFFile,oTHash)

    Local oTGIFHash:=THash():New()

    Local aPictInfo
    Local aPictures
    Local aImageInfo

    Local cMsg
    Local cDir
    Local cExt
    Local cFile
    Local cDriver
    
    Local cTempPath:=oTHash:Getproperty("SapuReca_Path","TEMP_PATH")

    SplitPath(cGIFFile,@cDriver,@cDir,@cFile,@cExt)

    IF .NOT.(lIsDir(cTempPath))
        MakeDir(cTempPath)
    EndIF

    IF .NOT.(StaticCall(H_GIF89,LoadGIF,@cGIFFile,@aPictInfo,@aPictures,@aImageInfo,@cTempPath))
        cMsg:=("Unable to Load "+cGIFFile)
        ConOut("["+cMsg+"]")
        MsgAlert(cMsg,"By By")
        __Quit()
    EndIF

    oTGIFHash:AddNewSession(cGIFFile)
    oTGIFHash:AddNewProperty(cGIFFile,"aPictInfo",aPictInfo)
    oTGIFHash:AddNewProperty(cGIFFile,"aPictures",aPictures)
    oTGIFHash:AddNewProperty(cGIFFile,"aImageInfo",aImageInfo)

Return(oTGIFHash)

/*/
    Funcao:RemoveFiles
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:23/03/2012
    Uso:Exclui os arquivos Temporarios
/*/
Static Procedure RemoveFiles(aShapes,oTHash)

    Local aPictures
    Local cSession

    Local nShape
    Local nShapes:=Len(aShapes)
    
    Local nImage_1:=oTHash:GetPropertyValue("SapuReca_Index","MOVE1_IMAGE")
    Local nImage_2:=oTHash:GetPropertyValue("SapuReca_Index","MOVE2_IMAGE")

    Local nFrame_1:=oTHash:GetPropertyValue("SapuReca_Index","MOVE1_FRAME")
    Local nFrame_2:=oTHash:GetPropertyValue("SapuReca_Index","MOVE2_FRAME")

    Local oShapeHash

    For nShape:=1 To nShapes
        cSession:=aShapes[nShape][nImage_1]
        IF .NOT.(Empty(cSession))
            oShapeHash:=aShapes[nShape][nFrame_1]
            IF (ValType(oShapeHash)=="O".and.oShapeHash:ClassName()=="THASH")
                aPictures:=oShapeHash:GetPropertyValue(cSession,"aPictures",{})
                aEval(aPictures,{|f|IF(File(f),fErase(f),NIL)})    
            EndIF    
        EndIF    
        cSession:=aShapes[nShape][nImage_2]
        IF .NOT.(Empty(cSession))
            oShapeHash:=aShapes[nShape][nFrame_2]
            IF (ValType(oShapeHash)=="O".and.oShapeHash:ClassName()=="THASH")
                aPictures:=oShapeHash:GetPropertyValue(cSession,"aPictures",{})
                aEval(aPictures,{|f|IF(File(f),fErase(f),NIL)})
            EndIF
        EndIF
    Next nShape
    
    For nShape:=1 To nShapes
        cSession:=aShapes[nShape][nImage_1]
        IF .NOT.(Empty(cSession))
            oShapeHash:=aShapes[nShape][nFrame_1]
            IF (ValType(oShapeHash)=="O".and.oShapeHash:ClassName()=="THASH")
                oShapeHash:=FreeObj(oShapeHash)
            EndIF
            oTHash:RemoveSession(@cSession)
        EndIF
        cSession:=aShapes[nShape][nImage_2]
        IF .NOT.(Empty(cSession))
            oShapeHash:=aShapes[nShape][nFrame_2]
            IF (ValType(oShapeHash)=="O".and.oShapeHash:ClassName()=="THASH")
                oShapeHash:=FreeObj(oShapeHash)
            EndIF
            oTHash:RemoveSession(@cSession)
        EndIF
    Next nShape

Return

/*
    Funcao:TPlayWAV
    Autor:Marinaldo de Jesus
    Data:22/03/2012
    Descricao:Acao do Timer para musica de Fundo
*/
Static Function TPlayWAV(nTimer,cWaveFile,oTHash)
    Local cTime:=Time()
    Local cTimeD:="00:00:00"
    Local lPlay:=(__cWAVLastTime==NIL.or.((cTimeD:=ElapTime(__cWAVLastTime,cTime))>"00:00:10"))
    IF (lPlay).and..NOT.(GetFinalize(@oTHash))
        __cWAVLastTime:=cTime
        lPlay:=Play_Wave(@nTimer,@cWaveFile,@oTHash)
    EndIF    
Return(lPlay)

/*
    Funcao:TPlayGIF
    Autor:Marinaldo de Jesus
    Data:22/03/2012
    Descricao:Acao do Timer para animacao dos GIFS
*/
Static Function TPlayGIF(nTimer,nAnimeCGIF,cShape,oGIF,aShapes,oTHash,lHide)
    Local lPlay:=.NOT.(GetFinalize(@oTHash))  
    BEGIN SEQUENCE
        IF .NOT.(lPlay)
            BREAK
        EndIF
        lPlay:=((aScan(__aTTimer,{|lPlay|lPlay}))==0)
        IF .NOT.(lPlay)
            BREAK
        EndIF
        lPlay:=((++nAnimeCGIF%15)==0)
        IF .NOT.(lPlay)
            BREAK
        EndIF
        lPlay:=PlayGIFC(@nTimer,@cShape,@oGIF,@aShapes,@oTHash,@lHide)
    END SEQUENCE
    IF (nAnimeCGIF>1500)
        nAnimeCGIF:=Randomize(1,1501)
    EndIF    
Return(lPlay)

/*
    Funcao:PlayFrog
    Autor:Marinaldo de Jesus
    Data:22/03/2012
    Descricao:Animacao dos GIFs SapuRecas
*/
Static Function PlayFrog(nTimer,cShape,oObjGIF,aShapes,oTHash,cFrame,cFSession)
Return(PlayGIF(@nTimer,@cShape,@oObjGIF,@aShapes,@oTHash,.F.,@cFrame,@cFSession))

/*
    Funcao:PlayGIFC
    Autor:Marinaldo de Jesus
    Data:22/03/2012
    Descricao:Animacao dos GIFs dos Coadjuvantes
*/
Static Function PlayGIFC(nTimer,cShape,oObjGIF,aShapes,oTHash,lHide)
    Local cFrame:="MOVE1_FRAME"
    Local cFSession:="MOVE1_IMAGE"
Return(PlayGIF(@nTimer,@cShape,@oObjGIF,@aShapes,@oTHash,@lHide,@cFrame,@cFSession))

/*
    Funcao:PlayGIF
    Autor:Marinaldo de Jesus
    Data:22/03/2012
    Descricao:Animacao dos GIFs
*/
Static Function PlayGIF(nTimer,cShape,oObjGIF,aShapes,oTHash,lHide,cFrame,cFSession)

    Local aPictures
    Local aImageInfo

    Local cSession
    Local cBMPFile

    Local lFinalize
    Local lNoExit

    Local nFrame:=0
    Local nFrameExit        
    Local nTotalFrames
    Local nCurrentFrame
    
    Local oTGIFHash

    __aTTimer[nTimer]:=.T.

    BEGIN SEQUENCE

        lFinalize:=GetFinalize(@oTHash)

        IF (lFinalize)
            BREAK
        EndIF

        cBMPFile:=oObjGIF:cBMPFile

        lNoExit:=.T.

        oTGIFHash:=aShapes[oTHash:GetProperty("SHAPES",cShape)][oTHash:GetPropertyValue("SapuReca_Index",cFrame)]
        cSession:=aShapes[oTHash:GetProperty("SHAPES",cShape)][oTHash:GetPropertyValue("SapuReca_Index",cFSession)]

        aPictures:=oTGIFHash:GetProperty(cSession,"aPictures")
        aImageInfo:=oTGIFHash:GetProperty(cSession,"aImageInfo")
        nCurrentFrame:=aShapes[oTHash:GetProperty("SHAPES",cShape)][oTHash:GetPropertyValue("SapuReca_Index","CURRENT_FRAME")]
        nFrameExit:=aShapes[oTHash:GetProperty("SHAPES",cShape)][oTHash:GetPropertyValue("SapuReca_Index","FRAME_EXIT")]
        nInterval:=StaticCall(H_GIF89,GetFrameDelay,aImageInfo[nCurrentFrame],ANIMATE_DELAY)
        nTotalFrames:=Len(aPictures)
        nFrameExit:=(nTotalFrames/nFrameExit)
    
        DEFAULT lHide:=.F.
    
        While (lNoExit)

            lFinalize:=GetFinalize(@oTHash)
            IF (lFinalize)
                lNoExit:=.F.
                BREAK
            EndIF

            IF (lHide)
                oObjGIF:Show()
            EndIF

            IF (nCurrentFrame>nTotalFrames)
                nCurrentFrame:=1
                lNoExit:=.F.
            Else
                lFinalize:=GetFinalize(@oTHash)
                IF (lFinalize)
                    lNoExit:=.F.
                    BREAK
                EndIF
                ConOut("Play GIF :"+"["+StrZero(nTimer,1)+"]"+"["+cShape+"]"+"[Frame]["+StrZero(nCurrentFrame,4)+"]")
                oObjGIF:cBMPFile:=aPictures[nCurrentFrame]
                ++nCurrentFrame 
                IF (++nFrame>nFrameExit)
                    Exit
                EndIF
            ENDIF
    
            IF (lHide)
                lFinalize:=GetFinalize(@oTHash)
                IF (lFinalize)
                    lNoExit:=.F.
                    BREAK
                EndIF
                oObjGIF:Hide()
            EndIF
        
            Sleep(ANIMATE_SLEEP)
    
        End While

        lFinalize:=GetFinalize(@oTHash)
        IF (lFinalize)
            lNoExit:=.F.
            BREAK
        EndIF

        IF (nCurrentFrame>nTotalFrames)
            nCurrentFrame:=1    
        EndIF
        
        aShapes[oTHash:GetProperty("SHAPES",cShape)][oTHash:GetPropertyValue("SapuReca_Index","CURRENT_FRAME")]:=nCurrentFrame
        
        oObjGIF:cBMPFile:=aPictures[nCurrentFrame]

        IF (lHide)
            lFinalize:=GetFinalize(@oTHash)
            IF (lFinalize)
                lNoExit:=.F.
                BREAK
            EndIF
            oObjGIF:Hide()
        EndIF

        Sleep(nInterval/ANIMATE_SLEEP)

    END SEQUENCE

    __aTTimer[nTimer]:=.F.

Return(.T.)

/*
    Funcao:AddShapes
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:23/03/2012
    Uso:Montar os Shapes
*/
Static Function AddShapes(oTPPanel,oTHash)

    Local cKey
    Local cProperties

    Local aShapes:=Array(0)

    Local lVisible

    Local nShape
    Local nShapes:=0

    Local nID:=oTHash:GetPropertyValue("SapuReca_Index","ID")
    Local nType:=oTHash:GetPropertyValue("SapuReca_Index","TYPE")
    Local nLeft:=oTHash:GetPropertyValue("SapuReca_Index","LEFT")
    Local nTop:=oTHash:GetPropertyValue("SapuReca_Index","TOP")
    Local nWidth:=oTHash:GetPropertyValue("SapuReca_Index","WIDTH")
    Local nHeight:=oTHash:GetPropertyValue("SapuReca_Index","HEIGHT")
    Local nImage:=oTHash:GetPropertyValue("SapuReca_Index","IMAGE")
    Local nToolTip:=oTHash:GetPropertyValue("SapuReca_Index","TOOLTIP")
    Local nMove:=oTHash:GetPropertyValue("SapuReca_Index","MOVE")
    Local nDeform:=oTHash:GetPropertyValue("SapuReca_Index","DEFORM")
    Local nMark:=oTHash:GetPropertyValue("SapuReca_Index","MARK")
    Local nContainer:=oTHash:GetPropertyValue("SapuReca_Index","CONTAINER")
    Local nVisible:=oTHash:GetPropertyValue("SapuReca_Index","VISIBLE")
    Local nbAction:=oTHash:GetPropertyValue("SapuReca_Index","BACTION")
    Local nDirection:=oTHash:GetPropertyValue("SapuReca_Index","DIRECTION")
    Local nMove1Top:=oTHash:GetPropertyValue("SapuReca_Index","MOVE1_TOP")
    Local nMove1Left:=oTHash:GetPropertyValue("SapuReca_Index","MOVE1_LEFT")
    Local nMove1Width:=oTHash:GetPropertyValue("SapuReca_Index","MOVE1_WIDTH")
    Local nMove1Height:=oTHash:GetPropertyValue("SapuReca_Index","MOVE1_HEIGHT")
    Local nMove2Top:=oTHash:GetPropertyValue("SapuReca_Index","MOVE2_TOP")
    Local nMove2Left:=oTHash:GetPropertyValue("SapuReca_Index","MOVE2_LEFT")
    Local nMove2Width:=oTHash:GetPropertyValue("SapuReca_Index","MOVE2_WIDTH")
    Local nMove2Height:=oTHash:GetPropertyValue("SapuReca_Index","MOVE2_HEIGHT")
    Local nMoveImg1:=oTHash:GetPropertyValue("SapuReca_Index","MOVE1_IMAGE")
    Local nMoveImg2:=oTHash:GetPropertyValue("SapuReca_Index","MOVE2_IMAGE")
    Local nMoveImgF1:=oTHash:GetPropertyValue("SapuReca_Index","MOVE1_FRAME")
    Local nMoveImgF2:=oTHash:GetPropertyValue("SapuReca_Index","MOVE2_FRAME")
    Local nMove1Jump:=oTHash:GetPropertyValue("SapuReca_Index","MOVE1_JUMP")
    Local nMove2Jump:=oTHash:GetPropertyValue("SapuReca_Index","MOVE2_JUMP")
    Local nString:=oTHash:GetPropertyValue("SapuReca_Index","STRING")
    Local nSElements:=oTHash:GetPropertyValue("SapuReca_Index","ELEMENTS")
    Local nIndex:=oTHash:GetPropertyValue("SapuReca_Index","INDEX")
    Local nCFrame:=oTHash:GetPropertyValue("SapuReca_Index","CURRENT_FRAME")
    Local nEFrame:=oTHash:GetPropertyValue("SapuReca_Index","FRAME_EXIT")

    oTHash:AddNewSession("SHAPES")
    
    //Container ::OemToAnsi("Container")
    ++nShapes
    cProperties:=""
    aAdd(aShapes,Array(nSElements))
    cKey:=OemToAnsi("Container")
    oTHash:AddNewProperty("SHAPES",cKey,nShapes)

    aShapes[nShapes][nID]:=nShapes
    aShapes[nShapes][nType]:=1
    aShapes[nShapes][nLeft]:=0
    aShapes[nShapes][nTop]:=0
    aShapes[nShapes][nWidth]:=497
    aShapes[nShapes][nHeight]:=635
    aShapes[nShapes][nImage]:=""
    aShapes[nShapes][nToolTip]:=cKey
    aShapes[nShapes][nMove]:=0 
    aShapes[nShapes][nDeform]:=0
    aShapes[nShapes][nMark]:=0
    aShapes[nShapes][nContainer]:=1
    aShapes[nShapes][nVisible]:=.T.
    aShapes[nShapes][nbAction]:={|x,y,oTPPanel,aShapes,oTHash|.F.}
    aShapes[nShapes][nDirection]:="C"
    aShapes[nShapes][nMove1Top]:=0
    aShapes[nShapes][nMove1Left]:=0
    aShapes[nShapes][nMove1Width]:=497
    aShapes[nShapes][nMove1Height]:=635
    aShapes[nShapes][nMove2Top]:=0
    aShapes[nShapes][nMove2Left]:=0
    aShapes[nShapes][nMove2Width]:=497
    aShapes[nShapes][nMove2Height]:=635
    aShapes[nShapes][nMoveImg1]:=""
    aShapes[nShapes][nMoveImg2]:=""
    aShapes[nShapes][nMove1Jump]:=0
    aShapes[nShapes][nMove2Jump]:=0
    aShapes[nShapes][nIndex]:=-1
    aShapes[nShapes][nCFrame]:=1
    aShapes[nShapes][nEFrame]:=1

    AddProperty(@cProperties,"id=",aShapes[nShapes][nID])
    AddProperty(@cProperties,"type=",aShapes[nShapes][nType])
    AddProperty(@cProperties,"left=",aShapes[nShapes][nLeft])
    AddProperty(@cProperties,"top=",aShapes[nShapes][nTop])
    AddProperty(@cProperties,"width=",aShapes[nShapes][nWidth])
    AddProperty(@cProperties,"height=",aShapes[nShapes][nHeight])
    AddProperty(@cProperties,"gradient=","1,0,0,0,0,0.0,#FFFFFF")
    AddProperty(@cProperties,"pen-width=","0")
    AddProperty(@cProperties,"pen-color=","#FFFFFF")
    AddProperty(@cProperties,"can-move=",aShapes[nShapes][nMove])    
    AddProperty(@cProperties,"can-mark=",aShapes[nShapes][nMark])
    AddProperty(@cProperties,"is-container=",aShapes[nShapes][nContainer])

    aShapes[nShapes][nString]:=cProperties

    //ContainerBG ::OemToAnsi("SapuReca")
    ++nShapes
    cProperties:=""
    aAdd(aShapes,Array(nSElements))
    cKey:=OemToAnsi("SapuReca")
    oTHash:AddNewProperty("SHAPES",cKey,nShapes)

    aShapes[nShapes][nID]:=nShapes
    aShapes[nShapes][nType]:=8
    aShapes[nShapes][nLeft]:=0
    aShapes[nShapes][nTop]:=0
    aShapes[nShapes][nWidth]:=497
    aShapes[nShapes][nHeight]:=635
    aShapes[nShapes][nImage]:=oTHash:GetPropertyValue("SapuReca_Files","JOGO_BACKGROUND")
    aShapes[nShapes][nToolTip]:=cKey
    aShapes[nShapes][nMove]:=0 
    aShapes[nShapes][nDeform]:=0
    aShapes[nShapes][nMark]:=0
    aShapes[nShapes][nContainer]:=1
    aShapes[nShapes][nVisible]:=.T.
    aShapes[nShapes][nbAction]:={|x,y,oTPPanel,aShapes,oTHash|.F.}
    aShapes[nShapes][nDirection]:="C"
    aShapes[nShapes][nMove1Top]:=0
    aShapes[nShapes][nMove1Left]:=0
    aShapes[nShapes][nMove1Width]:=497
    aShapes[nShapes][nMove1Height]:=635
    aShapes[nShapes][nMove2Top]:=0
    aShapes[nShapes][nMove2Left]:=0
    aShapes[nShapes][nMove2Width]:=497
    aShapes[nShapes][nMove2Height]:=635
    aShapes[nShapes][nMoveImg1]:=oTHash:GetPropertyValue("SapuReca_Files","JOGO_BACKGROUND")
    aShapes[nShapes][nMoveImg2]:=oTHash:GetPropertyValue("SapuReca_Files","JOGO_BACKGROUND")
    aShapes[nShapes][nMove1Jump]:=0
    aShapes[nShapes][nMove2Jump]:=0
    aShapes[nShapes][nIndex]:=-1
    aShapes[nShapes][nCFrame]:=1
    aShapes[nShapes][nEFrame]:=1

    AddProperty(@cProperties,"id=",aShapes[nShapes][nID])
    AddProperty(@cProperties,"type=",aShapes[nShapes][nType])
    AddProperty(@cProperties,"left=",aShapes[nShapes][nLeft])
    AddProperty(@cProperties,"top=",aShapes[nShapes][nTop])
    AddProperty(@cProperties,"width=",aShapes[nShapes][nWidth])
    AddProperty(@cProperties,"image-file=",aShapes[nShapes][nImage])
    AddProperty(@cProperties,"tooltip=",aShapes[nShapes][nToolTip])
    AddProperty(@cProperties,"height=",aShapes[nShapes][nHeight])
    AddProperty(@cProperties,"can-move=",aShapes[nShapes][nMove])    
    AddProperty(@cProperties,"can-mark=",aShapes[nShapes][nMark])
    AddProperty(@cProperties,"is-container=",aShapes[nShapes][nContainer])

    aShapes[nShapes][nString]:=cProperties

    //Instrucoes ::OemToAnsi("Instruções")
    ++nShapes
    cProperties:=""
    aAdd(aShapes,Array(nSElements))
    cKey:=OemToAnsi("Instruções")
    oTHash:AddNewProperty("SHAPES",cKey,nShapes)

    aShapes[nShapes][nID]:=nShapes
    aShapes[nShapes][nType]:=8
    aShapes[nShapes][nLeft]:=180
    aShapes[nShapes][nTop]:=100
    aShapes[nShapes][nWidth]:=293
    aShapes[nShapes][nHeight]:=078
    aShapes[nShapes][nImage]:=oTHash:GetPropertyValue("SapuReca_Files","JOGO_INSTRUCOES")
    aShapes[nShapes][nToolTip]:=cKey
    aShapes[nShapes][nMove]:=0 
    aShapes[nShapes][nDeform]:=0
    aShapes[nShapes][nMark]:=0
    aShapes[nShapes][nContainer]:=0
    aShapes[nShapes][nVisible]:=.T.
    aShapes[nShapes][nbAction]:={|x,y,oTPPanel,aShapes,oTHash|.F.}
    aShapes[nShapes][nDirection]:="C"
    aShapes[nShapes][nMove1Top]:=100
    aShapes[nShapes][nMove1Left]:=180
    aShapes[nShapes][nMove1Width]:=293
    aShapes[nShapes][nMove1Height]:=078
    aShapes[nShapes][nMove2Top]:=100
    aShapes[nShapes][nMove2Left]:=180
    aShapes[nShapes][nMove2Width]:=293
    aShapes[nShapes][nMove2Height]:=078
    aShapes[nShapes][nMoveImg1]:=oTHash:GetPropertyValue("SapuReca_Files","JOGO_INSTRUCOES")
    aShapes[nShapes][nMoveImg2]:=oTHash:GetPropertyValue("SapuReca_Files","JOGO_INSTRUCOES")
    aShapes[nShapes][nMove1Jump]:=0
    aShapes[nShapes][nMove2Jump]:=0
    aShapes[nShapes][nIndex]:=-1
    aShapes[nShapes][nCFrame]:=1
    aShapes[nShapes][nEFrame]:=1

    AddProperty(@cProperties,"id=",aShapes[nShapes][nID])
    AddProperty(@cProperties,"type=",aShapes[nShapes][nType])
    AddProperty(@cProperties,"left=",aShapes[nShapes][nLeft])
    AddProperty(@cProperties,"top=",aShapes[nShapes][nTop])
    AddProperty(@cProperties,"width=",aShapes[nShapes][nWidth])
    AddProperty(@cProperties,"image-file=",aShapes[nShapes][nImage])
    AddProperty(@cProperties,"tooltip=",aShapes[nShapes][nToolTip])
    AddProperty(@cProperties,"height=",aShapes[nShapes][nHeight])
    AddProperty(@cProperties,"can-move=",aShapes[nShapes][nMove])    
    AddProperty(@cProperties,"can-mark=",aShapes[nShapes][nMark])
    AddProperty(@cProperties,"is-container=",aShapes[nShapes][nContainer])

    aShapes[nShapes][nString]:=cProperties

    //Parabens ::OemToAnsi("Parabéns")
    ++nShapes
    cProperties:=""
    aAdd(aShapes,Array(nSElements))
    cKey:=OemToAnsi("Parabéns")
    oTHash:AddNewProperty("SHAPES",cKey,nShapes)

    aShapes[nShapes][nID]:=nShapes
    aShapes[nShapes][nType]:=8
    aShapes[nShapes][nLeft]:=180
    aShapes[nShapes][nTop]:=100
    aShapes[nShapes][nWidth]:=283
    aShapes[nShapes][nHeight]:=072
    aShapes[nShapes][nImage]:=oTHash:GetPropertyValue("SapuReca_Files","JOGO_PARABENS")
    aShapes[nShapes][nToolTip]:=cKey
    aShapes[nShapes][nMove]:=0 
    aShapes[nShapes][nDeform]:=0
    aShapes[nShapes][nMark]:=0
    aShapes[nShapes][nContainer]:=0
    aShapes[nShapes][nVisible]:=.F.
    aShapes[nShapes][nbAction]:={|x,y,oTPPanel,aShapes,oTHash|.F.}
    aShapes[nShapes][nDirection]:="C"
    aShapes[nShapes][nMove1Top]:=100
    aShapes[nShapes][nMove1Left]:=180
    aShapes[nShapes][nMove1Width]:=283
    aShapes[nShapes][nMove1Height]:=072
    aShapes[nShapes][nMove2Top]:=100
    aShapes[nShapes][nMove2Left]:=180
    aShapes[nShapes][nMove2Width]:=283
    aShapes[nShapes][nMove2Height]:=072
    aShapes[nShapes][nMoveImg1]:=oTHash:GetPropertyValue("SapuReca_Files","JOGO_PARABENS")
    aShapes[nShapes][nMoveImg2]:=oTHash:GetPropertyValue("SapuReca_Files","JOGO_PARABENS")
    aShapes[nShapes][nMove1Jump]:=0
    aShapes[nShapes][nMove2Jump]:=0
    aShapes[nShapes][nIndex]:=-1
    aShapes[nShapes][nCFrame]:=1
    aShapes[nShapes][nEFrame]:=1

    AddProperty(@cProperties,"id=",aShapes[nShapes][nID])
    AddProperty(@cProperties,"type=",aShapes[nShapes][nType])
    AddProperty(@cProperties,"left=",aShapes[nShapes][nLeft])
    AddProperty(@cProperties,"top=",aShapes[nShapes][nTop])
    AddProperty(@cProperties,"width=",aShapes[nShapes][nWidth])
    AddProperty(@cProperties,"image-file=",aShapes[nShapes][nImage])
    AddProperty(@cProperties,"tooltip=",aShapes[nShapes][nToolTip])
    AddProperty(@cProperties,"height=",aShapes[nShapes][nHeight])
    AddProperty(@cProperties,"can-move=",aShapes[nShapes][nMove])    
    AddProperty(@cProperties,"can-mark=",aShapes[nShapes][nMark])
    AddProperty(@cProperties,"is-container=",aShapes[nShapes][nContainer])

    aShapes[nShapes][nString]:=cProperties

    //Sapos (1) ::OemToAnsi("Grobe")
    ++nShapes
    cProperties:=""
    aAdd(aShapes,Array(nSElements))
    cKey:=OemToAnsi("Grobe")
    oTHash:AddNewProperty("SHAPES",cKey,nShapes)

    aShapes[nShapes][nID]:=nShapes
    aShapes[nShapes][nType]:=8
    aShapes[nShapes][nLeft]:=015
    aShapes[nShapes][nTop]:=315
    aShapes[nShapes][nWidth]:=083
    aShapes[nShapes][nHeight]:=072
    aShapes[nShapes][nImage]:=oTHash:GetPropertyValue("SapuReca_Files","SAPU_FRAME_START")
    aShapes[nShapes][nToolTip]:=cKey
    aShapes[nShapes][nMove]:=0 
    aShapes[nShapes][nDeform]:=0
    aShapes[nShapes][nMark]:=1
    aShapes[nShapes][nContainer]:=0
    aShapes[nShapes][nVisible]:=.T.
    aShapes[nShapes][nbAction]:={|x,y,oTPPanel,aShapes,oTHash|JumpFrog(@x,@y,@oTPPanel,@aShapes,@oTHash)}
    aShapes[nShapes][nDirection]:="R"
    aShapes[nShapes][nMove1Top]:=146.5
    aShapes[nShapes][nMove1Left]:=008
    aShapes[nShapes][nMove1Width]:=190
    aShapes[nShapes][nMove1Height]:=100
    aShapes[nShapes][nMove2Top]:=126.5
    aShapes[nShapes][nMove2Left]:=007.8
    aShapes[nShapes][nMove2Width]:=270
    aShapes[nShapes][nMove2Height]:=150
    aShapes[nShapes][nMoveImg1]:=oTHash:GetPropertyValue("SapuReca_Files","SAPU_JUMP_1")
    aShapes[nShapes][nMoveImgF1]:=GIFFrames(aShapes[nShapes][nMoveImg1],@oTHash)
    aShapes[nShapes][nMoveImg2]:=oTHash:GetPropertyValue("SapuReca_Files","SAPU_JUMP_2")
    aShapes[nShapes][nMoveImgF2]:=GIFFrames(aShapes[nShapes][nMoveImg2],@oTHash)
    aShapes[nShapes][nMove1Jump]:=88
    aShapes[nShapes][nMove2Jump]:=176
    aShapes[nShapes][nIndex]:=3
    aShapes[nShapes][nCFrame]:=1
    aShapes[nShapes][nEFrame]:=1

    AddProperty(@cProperties,"id=",aShapes[nShapes][nID])
    AddProperty(@cProperties,"type=",aShapes[nShapes][nType])
    AddProperty(@cProperties,"left=",aShapes[nShapes][nLeft])
    AddProperty(@cProperties,"top=",aShapes[nShapes][nTop])
    AddProperty(@cProperties,"width=",aShapes[nShapes][nWidth])
    AddProperty(@cProperties,"image-file=",aShapes[nShapes][nImage])
    AddProperty(@cProperties,"tooltip=",aShapes[nShapes][nToolTip])
    AddProperty(@cProperties,"height=",aShapes[nShapes][nHeight])
    AddProperty(@cProperties,"can-move=",aShapes[nShapes][nMove])    
    AddProperty(@cProperties,"can-mark=",aShapes[nShapes][nMark])
    AddProperty(@cProperties,"is-container=",aShapes[nShapes][nContainer])

    aShapes[nShapes][nString]:=cProperties

    //Sapos (2) ::OemToAnsi("Grube")
    ++nShapes
    cProperties:=""
    aAdd(aShapes,Array(nSElements))
    cKey:=OemToAnsi("Grube")
    oTHash:AddNewProperty("SHAPES",cKey,nShapes)

    aShapes[nShapes][nID]:=nShapes
    aShapes[nShapes][nType]:=8
    aShapes[nShapes][nLeft]:=103
    aShapes[nShapes][nTop]:=315
    aShapes[nShapes][nWidth]:=083
    aShapes[nShapes][nHeight]:=072
    aShapes[nShapes][nImage]:=oTHash:GetPropertyValue("SapuReca_Files","SAPU_FRAME_START")
    aShapes[nShapes][nToolTip]:=cKey
    aShapes[nShapes][nMove]:=0 
    aShapes[nShapes][nDeform]:=0
    aShapes[nShapes][nMark]:=1
    aShapes[nShapes][nContainer]:=0
    aShapes[nShapes][nVisible]:=.T.
    aShapes[nShapes][nbAction]:={|x,y,oTPPanel,aShapes,oTHash|JumpFrog(@x,@y,@oTPPanel,@aShapes,@oTHash)}
    aShapes[nShapes][nDirection]:="R"
    aShapes[nShapes][nMove1Top]:=146.5
    aShapes[nShapes][nMove1Left]:=008+45
    aShapes[nShapes][nMove1Width]:=190
    aShapes[nShapes][nMove1Height]:=100
    aShapes[nShapes][nMove2Top]:=126.5
    aShapes[nShapes][nMove2Left]:=007.8+45
    aShapes[nShapes][nMove2Width]:=270
    aShapes[nShapes][nMove2Height]:=150
    aShapes[nShapes][nMoveImg1]:=oTHash:GetPropertyValue("SapuReca_Files","SAPU_JUMP_1")
    aShapes[nShapes][nMoveImgF1]:=GIFFrames(aShapes[nShapes][nMoveImg1],@oTHash)
    aShapes[nShapes][nMoveImg2]:=oTHash:GetPropertyValue("SapuReca_Files","SAPU_JUMP_2")
    aShapes[nShapes][nMoveImgF2]:=GIFFrames(aShapes[nShapes][nMoveImg2],@oTHash)
    aShapes[nShapes][nMove1Jump]:=88
    aShapes[nShapes][nMove2Jump]:=176
    aShapes[nShapes][nIndex]:=2
    aShapes[nShapes][nCFrame]:=1
    aShapes[nShapes][nEFrame]:=1

    AddProperty(@cProperties,"id=",aShapes[nShapes][nID])
    AddProperty(@cProperties,"type=",aShapes[nShapes][nType])
    AddProperty(@cProperties,"left=",aShapes[nShapes][nLeft])
    AddProperty(@cProperties,"top=",aShapes[nShapes][nTop])
    AddProperty(@cProperties,"width=",aShapes[nShapes][nWidth])
    AddProperty(@cProperties,"image-file=",aShapes[nShapes][nImage])
    AddProperty(@cProperties,"tooltip=",aShapes[nShapes][nToolTip])
    AddProperty(@cProperties,"height=",aShapes[nShapes][nHeight])
    AddProperty(@cProperties,"can-move=",aShapes[nShapes][nMove])    
    AddProperty(@cProperties,"can-mark=",aShapes[nShapes][nMark])
    AddProperty(@cProperties,"is-container=",aShapes[nShapes][nContainer])

    aShapes[nShapes][nString]:=cProperties
    
    //Sapos (3) ::OemToAnsi("Grebe")
    ++nShapes
    cProperties:=""
    aAdd(aShapes,Array(nSElements))
    cKey:=OemToAnsi("Grebe")
    oTHash:AddNewProperty("SHAPES",cKey,nShapes)

    aShapes[nShapes][nID]:=nShapes
    aShapes[nShapes][nType]:=8
    aShapes[nShapes][nLeft]:=191
    aShapes[nShapes][nTop]:=315
    aShapes[nShapes][nWidth]:=083
    aShapes[nShapes][nHeight]:=072
    aShapes[nShapes][nImage]:=oTHash:GetPropertyValue("SapuReca_Files","SAPU_FRAME_START")
    aShapes[nShapes][nToolTip]:=cKey
    aShapes[nShapes][nMove]:=0 
    aShapes[nShapes][nDeform]:=0
    aShapes[nShapes][nMark]:=1
    aShapes[nShapes][nContainer]:=0
    aShapes[nShapes][nVisible]:=.T.
    aShapes[nShapes][nbAction]:={|x,y,oTPPanel,aShapes,oTHash|JumpFrog(@x,@y,@oTPPanel,@aShapes,@oTHash)}
    aShapes[nShapes][nDirection]:="R"
    aShapes[nShapes][nMove1Top]:=146.5
    aShapes[nShapes][nMove1Left]:=008+(45*2)
    aShapes[nShapes][nMove1Width]:=190
    aShapes[nShapes][nMove1Height]:=100
    aShapes[nShapes][nMove2Top]:=126.5
    aShapes[nShapes][nMove2Left]:=007.8+(45*2)
    aShapes[nShapes][nMove2Width]:=270
    aShapes[nShapes][nMove2Height]:=150
    aShapes[nShapes][nMoveImg1]:=oTHash:GetPropertyValue("SapuReca_Files","SAPU_JUMP_1")
    aShapes[nShapes][nMoveImgF1]:=GIFFrames(aShapes[nShapes][nMoveImg1],@oTHash)
    aShapes[nShapes][nMoveImg2]:=oTHash:GetPropertyValue("SapuReca_Files","SAPU_JUMP_2")
    aShapes[nShapes][nMoveImgF2]:=GIFFrames(aShapes[nShapes][nMoveImg2],@oTHash)
    aShapes[nShapes][nMove1Jump]:=88
    aShapes[nShapes][nMove2Jump]:=176
    aShapes[nShapes][nIndex]:=1
    aShapes[nShapes][nCFrame]:=1
    aShapes[nShapes][nEFrame]:=1

    AddProperty(@cProperties,"id=",aShapes[nShapes][nID])
    AddProperty(@cProperties,"type=",aShapes[nShapes][nType])
    AddProperty(@cProperties,"left=",aShapes[nShapes][nLeft])
    AddProperty(@cProperties,"top=",aShapes[nShapes][nTop])
    AddProperty(@cProperties,"width=",aShapes[nShapes][nWidth])
    AddProperty(@cProperties,"image-file=",aShapes[nShapes][nImage])
    AddProperty(@cProperties,"tooltip=",aShapes[nShapes][nToolTip])
    AddProperty(@cProperties,"height=",aShapes[nShapes][nHeight])
    AddProperty(@cProperties,"can-move=",aShapes[nShapes][nMove])    
    AddProperty(@cProperties,"can-mark=",aShapes[nShapes][nMark])
    AddProperty(@cProperties,"is-container=",aShapes[nShapes][nContainer])

    aShapes[nShapes][nString]:=cProperties

    //Pererecas (1) ::OemToAnsi("Frida")
    ++nShapes
    cProperties:=""
    aAdd(aShapes,Array(nSElements))
    cKey:=OemToAnsi("Frida")
    oTHash:AddNewProperty("SHAPES",cKey,nShapes)

    aShapes[nShapes][nID]:=nShapes
    aShapes[nShapes][nType]:=8
    aShapes[nShapes][nLeft]:=361
    aShapes[nShapes][nTop]:=315
    aShapes[nShapes][nWidth]:=085
    aShapes[nShapes][nHeight]:=079
    aShapes[nShapes][nImage]:=oTHash:GetPropertyValue("SapuReca_Files","RECA_FRAME_START")
    aShapes[nShapes][nToolTip]:=cKey
    aShapes[nShapes][nMove]:=0 
    aShapes[nShapes][nDeform]:=0
    aShapes[nShapes][nMark]:=1
    aShapes[nShapes][nContainer]:=0
    aShapes[nShapes][nVisible]:=.T.
    aShapes[nShapes][nbAction]:={|x,y,oTPPanel,aShapes,oTHash|JumpFrog(@x,@y,@oTPPanel,@aShapes,@oTHash)}
    aShapes[nShapes][nDirection]:="L"
    aShapes[nShapes][nMove1Top]:=152.6
    aShapes[nShapes][nMove1Left]:=221-(45*2)
    aShapes[nShapes][nMove1Width]:=180
    aShapes[nShapes][nMove1Height]:=090
    aShapes[nShapes][nMove2Top]:=122.6
    aShapes[nShapes][nMove2Left]:=178-(45*2)
    aShapes[nShapes][nMove2Width]:=265
    aShapes[nShapes][nMove2Height]:=150
    aShapes[nShapes][nMoveImg1]:=oTHash:GetPropertyValue("SapuReca_Files","RECA_JUMP_1")
    aShapes[nShapes][nMoveImgF1]:=GIFFrames(aShapes[nShapes][nMoveImg1],@oTHash)
    aShapes[nShapes][nMoveImg2]:=oTHash:GetPropertyValue("SapuReca_Files","RECA_JUMP_2")
    aShapes[nShapes][nMoveImgF2]:=GIFFrames(aShapes[nShapes][nMoveImg2],@oTHash)
    aShapes[nShapes][nMove1Jump]:=-88
    aShapes[nShapes][nMove2Jump]:=-176
    aShapes[nShapes][nIndex]:=6
    aShapes[nShapes][nCFrame]:=1
    aShapes[nShapes][nEFrame]:=1

    AddProperty(@cProperties,"id=",aShapes[nShapes][nID])
    AddProperty(@cProperties,"type=",aShapes[nShapes][nType])
    AddProperty(@cProperties,"left=",aShapes[nShapes][nLeft])
    AddProperty(@cProperties,"top=",aShapes[nShapes][nTop])
    AddProperty(@cProperties,"width=",aShapes[nShapes][nWidth])
    AddProperty(@cProperties,"image-file=",aShapes[nShapes][nImage])
    AddProperty(@cProperties,"tooltip=",aShapes[nShapes][nToolTip])
    AddProperty(@cProperties,"height=",aShapes[nShapes][nHeight])
    AddProperty(@cProperties,"can-move=",aShapes[nShapes][nMove])    
    AddProperty(@cProperties,"can-mark=",aShapes[nShapes][nMark])
    AddProperty(@cProperties,"is-container=",aShapes[nShapes][nContainer])

    aShapes[nShapes][nString]:=cProperties

    //Pererecas (2) ::OemToAnsi("Froda")
    ++nShapes
    cProperties:=""
    aAdd(aShapes,Array(nSElements))
    cKey:=OemToAnsi("Froda")
    oTHash:AddNewProperty("SHAPES",cKey,nShapes)

    aShapes[nShapes][nID]:=nShapes
    aShapes[nShapes][nType]:=8
    aShapes[nShapes][nLeft]:=449
    aShapes[nShapes][nTop]:=315
    aShapes[nShapes][nWidth]:=085
    aShapes[nShapes][nHeight]:=079
    aShapes[nShapes][nImage]:=oTHash:GetPropertyValue("SapuReca_Files","RECA_FRAME_START")
    aShapes[nShapes][nToolTip]:=cKey
    aShapes[nShapes][nMove]:=0 
    aShapes[nShapes][nDeform]:=0
    aShapes[nShapes][nMark]:=1
    aShapes[nShapes][nContainer]:=0
    aShapes[nShapes][nVisible]:=.T.
    aShapes[nShapes][nbAction]:={|x,y,oTPPanel,aShapes,oTHash|JumpFrog(@x,@y,@oTPPanel,@aShapes,@oTHash)}
    aShapes[nShapes][nDirection]:="L"
    aShapes[nShapes][nMove1Top]:=152.6
    aShapes[nShapes][nMove1Left]:=220.5-45
    aShapes[nShapes][nMove1Width]:=180
    aShapes[nShapes][nMove1Height]:=090
    aShapes[nShapes][nMove2Top]:=122.6
    aShapes[nShapes][nMove2Left]:=178-45
    aShapes[nShapes][nMove2Width]:=265
    aShapes[nShapes][nMove2Height]:=150
    aShapes[nShapes][nMoveImg1]:=oTHash:GetPropertyValue("SapuReca_Files","RECA_JUMP_1")
    aShapes[nShapes][nMoveImgF1]:=GIFFrames(aShapes[nShapes][nMoveImg1],@oTHash)
    aShapes[nShapes][nMoveImg2]:=oTHash:GetPropertyValue("SapuReca_Files","RECA_JUMP_2")
    aShapes[nShapes][nMoveImgF2]:=GIFFrames(aShapes[nShapes][nMoveImg2],@oTHash)
    aShapes[nShapes][nMove1Jump]:=-88
    aShapes[nShapes][nMove2Jump]:=-176
    aShapes[nShapes][nIndex]:=5
    aShapes[nShapes][nCFrame]:=1
    aShapes[nShapes][nEFrame]:=1

    AddProperty(@cProperties,"id=",aShapes[nShapes][nID])
    AddProperty(@cProperties,"type=",aShapes[nShapes][nType])
    AddProperty(@cProperties,"left=",aShapes[nShapes][nLeft])
    AddProperty(@cProperties,"top=",aShapes[nShapes][nTop])
    AddProperty(@cProperties,"width=",aShapes[nShapes][nWidth])
    AddProperty(@cProperties,"image-file=",aShapes[nShapes][nImage])
    AddProperty(@cProperties,"tooltip=",aShapes[nShapes][nToolTip])
    AddProperty(@cProperties,"height=",aShapes[nShapes][nHeight])
    AddProperty(@cProperties,"can-move=",aShapes[nShapes][nMove])    
    AddProperty(@cProperties,"can-mark=",aShapes[nShapes][nMark])
    AddProperty(@cProperties,"is-container=",aShapes[nShapes][nContainer])

    aShapes[nShapes][nString]:=cProperties

    //Pererecas (3) ::OemToAnsi("Fruda")
    ++nShapes
    cProperties:=""
    aAdd(aShapes,Array(nSElements))
    cKey:=OemToAnsi("Fruda")
    oTHash:AddNewProperty("SHAPES",cKey,nShapes)

    aShapes[nShapes][nID]:=nShapes
    aShapes[nShapes][nType]:=8
    aShapes[nShapes][nLeft]:=537
    aShapes[nShapes][nTop]:=315
    aShapes[nShapes][nWidth]:=085
    aShapes[nShapes][nHeight]:=079
    aShapes[nShapes][nImage]:=oTHash:GetPropertyValue("SapuReca_Files","RECA_FRAME_START")
    aShapes[nShapes][nToolTip]:=cKey
    aShapes[nShapes][nMove]:=0 
    aShapes[nShapes][nDeform]:=0
    aShapes[nShapes][nMark]:=1
    aShapes[nShapes][nContainer]:=0
    aShapes[nShapes][nVisible]:=.T.
    aShapes[nShapes][nbAction]:={|x,y,oTPPanel,aShapes,oTHash|JumpFrog(@x,@y,@oTPPanel,@aShapes,@oTHash)}
    aShapes[nShapes][nDirection]:="L"
    aShapes[nShapes][nMove1Top]:=152.6
    aShapes[nShapes][nMove1Left]:=221
    aShapes[nShapes][nMove1Width]:=180
    aShapes[nShapes][nMove1Height]:=090
    aShapes[nShapes][nMove2Top]:=122.6
    aShapes[nShapes][nMove2Left]:=178
    aShapes[nShapes][nMove2Width]:=265
    aShapes[nShapes][nMove2Height]:=150
    aShapes[nShapes][nMoveImg1]:=oTHash:GetPropertyValue("SapuReca_Files","RECA_JUMP_1")
    aShapes[nShapes][nMoveImgF1]:=GIFFrames(aShapes[nShapes][nMoveImg1],@oTHash)
    aShapes[nShapes][nMoveImg2]:=oTHash:GetPropertyValue("SapuReca_Files","RECA_JUMP_2")
    aShapes[nShapes][nMoveImgF2]:=GIFFrames(aShapes[nShapes][nMoveImg2],@oTHash)
    aShapes[nShapes][nMove1Jump]:=-88
    aShapes[nShapes][nMove2Jump]:=-176
    aShapes[nShapes][nIndex]:=4
    aShapes[nShapes][nCFrame]:=1
    aShapes[nShapes][nEFrame]:=1

    AddProperty(@cProperties,"id=",aShapes[nShapes][nID])
    AddProperty(@cProperties,"type=",aShapes[nShapes][nType])
    AddProperty(@cProperties,"left=",aShapes[nShapes][nLeft])
    AddProperty(@cProperties,"top=",aShapes[nShapes][nTop])
    AddProperty(@cProperties,"width=",aShapes[nShapes][nWidth])
    AddProperty(@cProperties,"image-file=",aShapes[nShapes][nImage])
    AddProperty(@cProperties,"tooltip=",aShapes[nShapes][nToolTip])
    AddProperty(@cProperties,"height=",aShapes[nShapes][nHeight])
    AddProperty(@cProperties,"can-move=",aShapes[nShapes][nMove])    
    AddProperty(@cProperties,"can-mark=",aShapes[nShapes][nMark])
    AddProperty(@cProperties,"is-container=",aShapes[nShapes][nContainer])

    aShapes[nShapes][nString]:=cProperties

    //Coadjuvantes (1) ::OemToAnsi("Frog")
    ++nShapes
    cProperties:=""
    aAdd(aShapes,Array(nSElements))
    cKey:=OemToAnsi("Frog")
    oTHash:AddNewProperty("SHAPES",cKey,nShapes)

    aShapes[nShapes][nID]:=nShapes
    aShapes[nShapes][nType]:=8
    aShapes[nShapes][nLeft]:=065
    aShapes[nShapes][nTop]:=405
    aShapes[nShapes][nWidth]:=085
    aShapes[nShapes][nHeight]:=083
    aShapes[nShapes][nImage]:=oTHash:GetPropertyValue("SapuReca_Files","SAPO_DANCANTE")
    aShapes[nShapes][nToolTip]:=cKey
    aShapes[nShapes][nMove]:=0 
    aShapes[nShapes][nDeform]:=0
    aShapes[nShapes][nMark]:=0
    aShapes[nShapes][nContainer]:=0
    aShapes[nShapes][nVisible]:=.F.
    aShapes[nShapes][nbAction]:={|x,y,oTPPanel,aShapes,oTHash|.F.}
    aShapes[nShapes][nDirection]:="C"
    aShapes[nShapes][nMove1Top]:=205
    aShapes[nShapes][nMove1Left]:=030
    aShapes[nShapes][nMove1Width]:=085
    aShapes[nShapes][nMove1Height]:=083
    aShapes[nShapes][nMove2Top]:=205
    aShapes[nShapes][nMove2Left]:=030
    aShapes[nShapes][nMove2Width]:=085
    aShapes[nShapes][nMove2Height]:=083
    aShapes[nShapes][nMoveImg1]:=oTHash:GetPropertyValue("SapuReca_Files","SAPO_DANCANTE")
    aShapes[nShapes][nMoveImgF1]:=GIFFrames(aShapes[nShapes][nMoveImg1],@oTHash)
    aShapes[nShapes][nMoveImg2]:=oTHash:GetPropertyValue("SapuReca_Files","SAPO_DANCANTE")
    aShapes[nShapes][nMove1Jump]:=0
    aShapes[nShapes][nMove2Jump]:=0
    aShapes[nShapes][nIndex]:=-1
    aShapes[nShapes][nCFrame]:=1
    aShapes[nShapes][nEFrame]:=1

    AddProperty(@cProperties,"id=",aShapes[nShapes][nID])
    AddProperty(@cProperties,"type=",aShapes[nShapes][nType])
    AddProperty(@cProperties,"left=",aShapes[nShapes][nLeft])
    AddProperty(@cProperties,"top=",aShapes[nShapes][nTop])
    AddProperty(@cProperties,"width=",aShapes[nShapes][nWidth])
    AddProperty(@cProperties,"image-file=",aShapes[nShapes][nImage])
    AddProperty(@cProperties,"tooltip=",aShapes[nShapes][nToolTip])
    AddProperty(@cProperties,"height=",aShapes[nShapes][nHeight])
    AddProperty(@cProperties,"can-move=",aShapes[nShapes][nMove])    
    AddProperty(@cProperties,"can-mark=",aShapes[nShapes][nMark])
    AddProperty(@cProperties,"is-container=",aShapes[nShapes][nContainer])

    aShapes[nShapes][nString]:=cProperties
    
    //Coadjuvantes (2) ::OemToAnsi("Freg")
    ++nShapes
    cProperties:=""
    aAdd(aShapes,Array(nSElements))
    cKey:=OemToAnsi("Freg")
    oTHash:AddNewProperty("SHAPES",cKey,nShapes)

    aShapes[nShapes][nID]:=nShapes
    aShapes[nShapes][nType]:=8
    aShapes[nShapes][nLeft]:=420
    aShapes[nShapes][nTop]:=405
    aShapes[nShapes][nWidth]:=120
    aShapes[nShapes][nHeight]:=072
    aShapes[nShapes][nImage]:=oTHash:GetPropertyValue("SapuReca_Files","SAPO_INSETO")
    aShapes[nShapes][nToolTip]:=cKey
    aShapes[nShapes][nMove]:=0 
    aShapes[nShapes][nDeform]:=0
    aShapes[nShapes][nMark]:=0
    aShapes[nShapes][nContainer]:=0
    aShapes[nShapes][nVisible]:=.F.
    aShapes[nShapes][nbAction]:={|x,y,oTPPanel,aShapes,oTHash|.F.}
    aShapes[nShapes][nDirection]:="C"
    aShapes[nShapes][nMove1Top]:=202
    aShapes[nShapes][nMove1Left]:=211
    aShapes[nShapes][nMove1Width]:=120
    aShapes[nShapes][nMove1Height]:=072
    aShapes[nShapes][nMove2Top]:=202
    aShapes[nShapes][nMove2Left]:=211
    aShapes[nShapes][nMove2Width]:=120
    aShapes[nShapes][nMove2Height]:=072
    aShapes[nShapes][nMoveImg1]:=oTHash:GetPropertyValue("SapuReca_Files","SAPO_INSETO")
    aShapes[nShapes][nMoveImgF1]:=GIFFrames(aShapes[nShapes][nMoveImg1],@oTHash)
    aShapes[nShapes][nMoveImg2]:=oTHash:GetPropertyValue("SapuReca_Files","SAPO_INSETO")
    aShapes[nShapes][nMove1Jump]:=0
    aShapes[nShapes][nMove2Jump]:=0
    aShapes[nShapes][nIndex]:=-1
    aShapes[nShapes][nCFrame]:=1
    aShapes[nShapes][nEFrame]:=1

    AddProperty(@cProperties,"id=",aShapes[nShapes][nID])
    AddProperty(@cProperties,"type=",aShapes[nShapes][nType])
    AddProperty(@cProperties,"left=",aShapes[nShapes][nLeft])
    AddProperty(@cProperties,"top=",aShapes[nShapes][nTop])
    AddProperty(@cProperties,"width=",aShapes[nShapes][nWidth])
    AddProperty(@cProperties,"image-file=",aShapes[nShapes][nImage])
    AddProperty(@cProperties,"tooltip=",aShapes[nShapes][nToolTip])
    AddProperty(@cProperties,"height=",aShapes[nShapes][nHeight])
    AddProperty(@cProperties,"can-move=",aShapes[nShapes][nMove])    
    AddProperty(@cProperties,"can-mark=",aShapes[nShapes][nMark])
    AddProperty(@cProperties,"is-container=",aShapes[nShapes][nContainer])

    aShapes[nShapes][nString]:=cProperties

    //Coadjuvantes (3) ::OemToAnsi("flyAlone")
    ++nShapes
    cProperties:=""
    aAdd(aShapes,Array(nSElements))
    cKey:=OemToAnsi("flyAlone")
    oTHash:AddNewProperty("SHAPES",cKey,nShapes)

    aShapes[nShapes][nID]:=nShapes
    aShapes[nShapes][nType]:=8
    aShapes[nShapes][nLeft]:=010
    aShapes[nShapes][nTop]:=010
    aShapes[nShapes][nWidth]:=340
    aShapes[nShapes][nHeight]:=088
    aShapes[nShapes][nImage]:=oTHash:GetPropertyValue("SapuReca_Files","PASSARO_VOANDO")
    aShapes[nShapes][nToolTip]:=cKey
    aShapes[nShapes][nMove]:=0 
    aShapes[nShapes][nDeform]:=0
    aShapes[nShapes][nMark]:=0
    aShapes[nShapes][nContainer]:=0
    aShapes[nShapes][nVisible]:=.F.
    aShapes[nShapes][nbAction]:={|x,y,oTPPanel,aShapes,oTHash|.F.}
    aShapes[nShapes][nDirection]:="C"
    aShapes[nShapes][nMove1Top]:=010
    aShapes[nShapes][nMove1Left]:=010
    aShapes[nShapes][nMove1Width]:=340
    aShapes[nShapes][nMove1Height]:=088
    aShapes[nShapes][nMove2Top]:=010
    aShapes[nShapes][nMove2Left]:=010
    aShapes[nShapes][nMove2Width]:=340
    aShapes[nShapes][nMove2Height]:=088
    aShapes[nShapes][nMoveImg1]:=oTHash:GetPropertyValue("SapuReca_Files","PASSARO_VOANDO")
    aShapes[nShapes][nMoveImgF1]:=GIFFrames(aShapes[nShapes][nMoveImg1],@oTHash)
    aShapes[nShapes][nMoveImg2]:=oTHash:GetPropertyValue("SapuReca_Files","PASSARO_VOANDO")
    aShapes[nShapes][nMove1Jump]:=0
    aShapes[nShapes][nMove2Jump]:=0
    aShapes[nShapes][nIndex]:=-1
    aShapes[nShapes][nCFrame]:=1
    aShapes[nShapes][nEFrame]:=4

    AddProperty(@cProperties,"id=",aShapes[nShapes][nID])
    AddProperty(@cProperties,"type=",aShapes[nShapes][nType])
    AddProperty(@cProperties,"left=",aShapes[nShapes][nLeft])
    AddProperty(@cProperties,"top=",aShapes[nShapes][nTop])
    AddProperty(@cProperties,"width=",aShapes[nShapes][nWidth])
    AddProperty(@cProperties,"image-file=",aShapes[nShapes][nImage])
    AddProperty(@cProperties,"tooltip=",aShapes[nShapes][nToolTip])
    AddProperty(@cProperties,"height=",aShapes[nShapes][nHeight])
    AddProperty(@cProperties,"can-move=",aShapes[nShapes][nMove])    
    AddProperty(@cProperties,"can-mark=",aShapes[nShapes][nMark])
    AddProperty(@cProperties,"is-container=",aShapes[nShapes][nContainer])

    aShapes[nShapes][nString]:=cProperties
    //Reiniciar ::OemToAnsi("Reiniciar")
    ++nShapes
    cProperties:=""
    aAdd(aShapes,Array(nSElements))
    cKey:=OemToAnsi("Reiniciar")
    oTHash:AddNewProperty("SHAPES",cKey,nShapes)

    aShapes[nShapes][nID]:=nShapes
    aShapes[nShapes][nType]:=8
    aShapes[nShapes][nLeft]:=205
    aShapes[nShapes][nTop]:=473
    aShapes[nShapes][nWidth]:=230
    aShapes[nShapes][nHeight]:=023
    aShapes[nShapes][nImage]:=oTHash:GetPropertyValue("SapuReca_Files","JOGO_REINICIAR")
    aShapes[nShapes][nToolTip]:=cKey
    aShapes[nShapes][nMove]:=0 
    aShapes[nShapes][nDeform]:=0
    aShapes[nShapes][nMark]:=1
    aShapes[nShapes][nContainer]:=0
    aShapes[nShapes][nVisible]:=.F.
    aShapes[nShapes][nbAction]:={|x,y,oTPPanel,aShapes,oTHash|Restart(@x,@y,@oTPPanel,@aShapes,@oTHash)}
    aShapes[nShapes][nDirection]:="C"
    aShapes[nShapes][nMove1Top]:=472
    aShapes[nShapes][nMove1Left]:=191
    aShapes[nShapes][nMove1Width]:=230
    aShapes[nShapes][nMove1Height]:=023
    aShapes[nShapes][nMove2Top]:=472
    aShapes[nShapes][nMove2Left]:=191
    aShapes[nShapes][nMove2Width]:=230
    aShapes[nShapes][nMove2Height]:=023
    aShapes[nShapes][nMoveImg1]:=oTHash:GetPropertyValue("SapuReca_Files","JOGO_REINICIAR")
    aShapes[nShapes][nMoveImg2]:=oTHash:GetPropertyValue("SapuReca_Files","JOGO_REINICIAR")
    aShapes[nShapes][nMove1Jump]:=0
    aShapes[nShapes][nMove2Jump]:=0
    aShapes[nShapes][nIndex]:=-1
    aShapes[nShapes][nCFrame]:=1
    aShapes[nShapes][nEFrame]:=1

    AddProperty(@cProperties,"id=",aShapes[nShapes][nID])
    AddProperty(@cProperties,"type=",aShapes[nShapes][nType])
    AddProperty(@cProperties,"left=",aShapes[nShapes][nLeft])
    AddProperty(@cProperties,"top=",aShapes[nShapes][nTop])
    AddProperty(@cProperties,"width=",aShapes[nShapes][nWidth])
    AddProperty(@cProperties,"image-file=",aShapes[nShapes][nImage])
    AddProperty(@cProperties,"tooltip=",aShapes[nShapes][nToolTip])
    AddProperty(@cProperties,"height=",aShapes[nShapes][nHeight])
    AddProperty(@cProperties,"can-move=",aShapes[nShapes][nMove])    
    AddProperty(@cProperties,"can-mark=",aShapes[nShapes][nMark])
    AddProperty(@cProperties,"is-container=",aShapes[nShapes][nContainer])

    aShapes[nShapes][nString]:=cProperties

    For nShape:=1 To nShapes
        cProperties:=aShapes[nShape][nString]
        oTPPanel:AddShape(cProperties)
        lVisible:=aShapes[nShape][nVisible]
        IF .NOT.(lVisible)
            oTPPanel:SetVisible(nShape,lVisible)
        EndIF
    Next nShape

Return(aShapes)

/*
    Funcao:__Dummy
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:23/03/2012
    Uso:Dummy
*/
Static Function __Dummy(lRecursa)
    DEFAULT lRecursa:=.F.
    BEGIN SEQUENCE
        IF .NOT.(lRecursa)
            BREAK
        EndIF
        SapuReca()
        lRecursa:=__Dummy(.F.)
    END SEQUENCE
Return(lRecursa)