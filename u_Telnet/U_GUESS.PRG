#INCLUDE "INKEY.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE OPC_GUESS        1

Static __cESC:=Chr(K_ESC)    //27
Static __lForceExit:=.F.

/*(
    Procedure:U_MAINGUESS
    Autor:Marinaldo de Jesus
    Data:15/11/2011
    Descricao:Exemplo de emulador TELNET
    Sintaxe:U_MAINGUES

    [TELNET]
    Enable=1
    Environment=ndj_01
    Main=U_MAINGUES
    NPARAMS=0
    ;port=24 ;//DEFAULT 23
    
)*/
Procedure U_MAINGUESS()

    Local nOpc:=Val(Read(0,0,"Iniciar o Jogo? 0-Nao; 1-Sim <enter>:"))

    DO CASE
    CASE (nOpc==OPC_GUESS)
        Guess()
    OTHERWISE
        IKillApp(.T.)
    ENDCASE

    /*(
       Guess a number
    
       Date:1999/04/22
    
       My first application (big word) written in Harbour
    
       Written by Eddie Runia <eddie@runia.com>
       www - http://harbour-project.org

       Placed in the public domain
   )*/
    Static Function Guess()
    
        Local cPick:=""
        Local cAttempts:=""
        
        Local nSeed:=Randomize(1,256)
        Local nPick:=0
        Local nAttempts:=0

        Local nflGuessed

        Local lContinue:=.T.
    
        Clear()

        Say(0,0,"Welcome to guess a number...." )
        Say(1,0,"You have to guess a number between 0 and 255 [ press <esc> <enter> to exit ]" )

        While !(IKillApp())
            While (lContinue)
                nSeed:=Randomize(1,256)
                nflGuessed:=0
                nAttempts:=0
                While (nflGuessed==0)
                    Clear(3,0,3)
                    nPick:=Val(Read(3,0,"Value <enter>:"))
                    IKillApp()
                    cPick:=AllTrim(Str(nPick,3,0))
                    cAttempts:=AllTrim(Str(++nAttempts,4,0))
                    DO CASE
                    CASE (nPick>255)
                        Clear(5,0)
                        Say(5,0,cPick+" More than 255")
                    CASE (nPick<0)
                        Clear(5,0)
                        Say(5,0,cPick+" Less than 0")
                    CASE (nPick>nSeed)
                        Clear(5,0)
                        Say(5,0,"Try lower:"+cPick)
                    CASE (nPick<nSeed)
                        Clear(5,0)
                        Say(5,0,"Try higher:"+cPick)
                    OTHERWISE
                        Say(5,0,"Congratulations, you've, AFTER "+cAttempts+" ATTEMPTS, guessed the number "+cPick)
                        Sleep(300)
                        nflGuessed:=1
                    ENDCASE
                End While
                Clear(7,0)
                lContinue:=(Upper(Read(7,0, "Continue Y/N <enter>:"))=="Y")
                Clear(5,0)
                IF !(lContinue)
                    IKillApp(.T.)
                EndIF    
           End While
        End While

    Return(.T.)

    /*(
        Function:Say
        Autor:Marinaldo de Jesus
        Data:15/11/2011
        Descricao:Direciona Saida para o Terminal TELNET
        Sintaxe:Say(nRow,nCol,cOut)
   )*/
    Static Function Say(nRow,nCol,cOut)
        DEFAULT cOut:=""
        SetPos(nRow,nCol)
    Return(_QQOut(@cOut))

    /*(
        Function:Clear
        Autor:Marinaldo de Jesus
        Data:15/11/2011
        Descricao:Limpa o Console do Terminal TELNET
        Sintaxe:Clear(nTop,nLeft,nBottom,nRight)
   )*/
    Static Function Clear(nTop,nLeft,nBottom,nRight)
        DEFAULT nTop:=0
        DEFAULT nLeft:=0
        DEFAULT nBottom:=300
        DEFAULT nRight:=80
    Return(Scrool(nTop,nLeft,nBottom,nRight))

    /*(
        Function:Scrool
        Autor:Marinaldo de Jesus
        Data:15/11/2011
        Descricao:Limpa o Console do Terminal TELNET
        Sintaxe:Scrool(nTop,nLeft,nBottom,nRight)
   )*/
    Static Function Scrool(nTop,nLeft,nBottom,nRight)
        Local nT
        Local cSPC:=Space(nRight-nLeft)
        For nT:=nTop To nBottom
            Say(nT,nLeft,cSPC)
        Next nT
    Return(SetPos(nTop,nLeft))

    /*(
        Function:_QQOut
        Autor:Marinaldo de Jesus
        Data:15/11/2011
        Descricao:Direciona Saida para o Terminal TELNET
        Sintaxe:_QQOut(cOut)
   )*/
    Static Function _QQOut(cOut)
        Local cVTFun:="_VTOUT"
    Return(&cVTFun.(cOut,))

    /*(
        Function:SetPos
        Autor:Marinaldo de Jesus
        Data:15/11/2011
        Descricao:Define o Posicionamento da Linha/Coluna para a Mensagem
        Sintaxe:SetPos(nRow,nCol)

        http://www.comptechdoc.org/os/linux/howlinuxworks/linux_hlvt100.html
        VT100 ESC sequences
   )*/
    Static Function SetPos(nRow,nCol)
        Local cR
        Local cC
        Local cSetPos
        DEFAULT nRow:=0
        DEFAULT nCol:=0
        cR:=Alltrim(Str(nRow,4,0))
        cC:=Alltrim(Str(nCol,4,0))
        cSetPos:=__cESC
        cSetPos+="["
        cSetPos+=cR
        cSetPos+=";"
        cSetPos+=cC
        cSetPos+="H"
    Return(_QQOut(cSetPos))

    /*(
        Function:Read
        Autor:Marinaldo de Jesus
        Data:15/11/2011
        Descricao:Le Byte a Byte o Conteudo Digitado no Terminal
        Sintaxe:Read(nRow,nCol,cOut)
   )*/
    Static Function Read(nRow,nCol,cOut)
        Local cVTFun:="_VTGETBYTE"
        Local cByte:=""
        Local cBuffer:=""
        Local lExit:=.F.
        Say(nRow,nCol,cOut+cBuffer)
        While !(lExit)
            cByte:=&cVTFun.(,)
            lExit:=(Asc(cByte)==K_ENTER)
            IF (cByte==__cESC)
                __lForceExit:=.T.
            EndIF    
            IF !(lExit)
                IF ChkAsc(cByte,.F.)
                    cBuffer+=cByte
                EndIF    
            EndIF
        End While
    Return(cBuffer)

    /*(
        Function:IKillApp
        Autor:Marinaldo de Jesus
        Data:15/11/2011
        Descricao:Verifica se deve finalizar a aplicacao
        Sintaxe:IKillApp(lKillApp)
   )*/
    Static Function IKillApp(lKillApp)
        Local cMsg:="bye bye. Exiting..."
        Local lKilled:=.F.
        DEFAULT lKillApp:=.F.
        IF (;
                (lKillApp);
                .or.;
                (__lForceExit);
           )    
            lKilled:=.T.
            lKillApp:=.T.
            Clear(0,0)
            IF (__lForceExit)
                cMsg:="<esc> "+cMsg
            EndIF
            Say(5,0,cMsg)            
            Sleep(800)
            KillApp(lKillApp)
        EndIF
    Return(lKilled)

Return
