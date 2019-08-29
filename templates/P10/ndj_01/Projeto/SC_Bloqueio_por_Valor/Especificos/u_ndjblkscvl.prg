#INCLUDE "NDJ.CH"

#DEFINE FIELD_POS_PRECO              1
#DEFINE FIELD_POS_QUANTIDADE         2

#DEFINE FIELD_POS_FIELDS             2

#DEFINE FIELD_GET_ORCAMENTO          1
#DEFINE FIELD_GET_ORIGEM_RECURSO     2
#DEFINE FIELD_GET_TIPO_DESPESA       3
#DEFINE FIELD_GET_SEQ_PEDIDO         4
#DEFINE FIELD_GET_NUM_SC             5
#DEFINE FIELD_GET_ITEM_SC            6
#DEFINE FIELD_GET_ITEM_GRD           7
#DEFINE FIELD_GET_PROJETO            8
#DEFINE FIELD_GET_REVISAO            9
#DEFINE FIELD_GET_TAREFA            10
#DEFINE FIELD_GET_ORIGEM_DE_RECURSO 11

#DEFINE FIELD_GET_FIELDS            11

#DEFINE GD_FIELDS_OPTION1            1
#DEFINE GD_FIELDS_OPTION2            2

#DEFINE GD_FIELDS_OPTIONS            2

Static __cCRLF:=CRLF

Static __cStkFrmTot:="__cStkFrmTot"
Static __nStkFrmTot:=0

Static __aSZ0TTS:={}
Static __nSZ0TTS:=0

Static __nLocks:=0

Static __aSZ0LNK:={;
                               {;
                                       "SC1",;
                                       "Z0_PROJETO+Z0_REVISAO+Z0_TAREFA+Z0_NUM+Z0_ITEM+Z0_ITEMGRD+Z0_ORCAME+Z0_XCODOR+Z0_XCODSBM",;
                                       "C1_FILIAL+C1_XPROJET+C1_XREVISA+C1_XTAREFA+C1_NUM+C1_ITEM+C1_ITEMGRD+C1_CODORCA+C1_XCODOR+C1_XCODSBM",;
                                       "C1_XTOTAL",;
                                       "C1_Z0LINKD";
                               },;
                               {;
                                       "SC7",;
                                       "Z0_PROJETO+Z0_REVISAO+Z0_TAREFA+Z0_NUM+Z0_ITEM+Z0_SEQUEN+Z0_ITEMGRD+Z0_ORCAME+Z0_XCODOR+Z0_XCODSBM",;
                                       "C7_FILIAL+C7_XPROJET+C7_XREVIS+C7_XTAREFA+C7_NUMSC+C7_ITEMSC+C7_SEQUEN+C7_ITEMGRD+C7_CODORCA+C7_XCODOR+C7_XCODSBM",;
                                       "C7_TOTAL",;
                                       "C7_Z0LINKD";
                            },;
                               {;
                                       "CNB",;
                                       "Z0_PROJETO+Z0_REVISAO+Z0_TAREFA+Z0_NUM+Z0_ITEM+Z0_SEQUEN+Z0_ITEMGRD+Z0_ORCAME+Z0_XCODOR+Z0_XCODSBM",;
                                       "CNB_FILIAL+CNB_XPROJE+CNB_XREVIS+CNB_XTAREF+CNB_XNUMSC+CNB_XITMSC+CNB_XSEQPC+CNB_ITEGRD+CNB_XCODCA+CNB_XCODOR+CNB_XCODSB",;
                                       "CNB_VLTOT",;
                                       "CNB_Z0LINK";
                            },;    
                               {;
                                       "CNE",;
                                       "Z0_PROJETO+Z0_REVISAO+Z0_TAREFA+Z0_NUM+Z0_ITEM+Z0_SEQUEN+Z0_ITEMGRD+Z0_ORCAME+Z0_XCODOR+Z0_XCODSBM",;
                                       "CNE_FILIAL+CNE_XPROJE+CNE_XREVIS+CNE_XTAREF+CNE_XNUMSC+CNE_XITMSC+CNE_XSEQPC+CNE_ITEGRD+CNE_XCODCA+CNE_XCODOR+CNE_XCODSB",;
                                       "CNE_VLTOT",;
                                       "CNE_Z0LINK";
                            },;
                               {;
                                       "SD1",;
                                       "Z0_PROJETO+Z0_REVISAO+Z0_TAREFA+Z0_NUM+Z0_ITEM+Z0_SEQUEN+Z0_ITEMGRD+Z0_ORCAME+Z0_XCODOR+Z0_XCODSBM",;
                                       "D1_FILIAL+D1_XPROJET+D1_XREVIS+D1_XTAREFA+D1_XNUMSC+D1_XITEMSC+D1_XSEQUEN+D1_ITEMGRD+D1_CODORCA+D1_XCODOR+D1_XCODSBM",;
                                       "D1_TOTAL",;
                                       "D1_Z0LINKD";
                            };
                       }

/*/
    Funcao:RpcBlkSC
    Autor:Marinaldo de Jesus
    Data:11/01/2011
    Uso:Chamada Via RPC da Verificacao do "Link" de Bloqueios por Valor
    Sintaxe: 1 - RpcBlkSC({ cEmp,cFil })    //Chamada Direta
             2 - RpcBlkSC(cEmp,cFil)        //Chamada Via Agendamento
/*/
User Function RpcBlkSC(aParameters)

    Local cEmp
    Local cFil
    Local lIsBlind:=(IsBlind() .or. (Select("SM0")==0))

    Local oException

    TRYEXCEPTION

        IF !Empty(aParameters)
            IF (Len(aParameters)>1)
                cEmp:=aParameters[1]
            EndIF
            IF (Len(aParameters)>2)
                cFil:=aParameters[2]
            EndIF
        EndIF
    
        DEFAULT cEmp:="01"
        DEFAULT cFil:="01"
        
        IF (lIsBlind)
            PREPARE ENVIRONMENT EMPRESA (cEmp)FILIAL (cFil)
        EndIF
            SZ0ChkLink(.T.)
            BEGIN SEQUENCE
                IF !(ChkFile("SZ0"))
                    BREAK
                EndIF
                IF !(ChkFile("SC1"))
                    BREAK
                EndIF
                IF !(ChkFile("SC7"))
                    BREAK
                EndIF
                SZ0LinkChk(.T.)
            END SEQUENCE
        IF (lIsBlind)
            RESET ENVIRONMENT
        EndIF    

    CATCHEXCEPTION USING oException

        IF (ValType(oException)=="O")
            ConOut(CaptureError())
        EndIF

    ENDEXCEPTION

Return(NIL)

/*/
    Funcao:SZ0LinkChk()
    Data:17/08/2011
    Autor:Marinaldo de Jesus
    Descricao:Verificar e Atualizar os Links da Tabela SZ0
    Sintace:StaticCall(U_NDJBLKSCVL,SZ0LinkChk,lChkSD1SZ0)
/*/
Static Function SZ0LinkChk(lChkSD1SZ0)

    Local aFromTo
    Local aCNARecnos

    Local cQuery
    Local cAlias

    Local cCronog
    Local cContra
    Local cRevisao

    Local cSC1Table
    Local cSC7Table
    Local cSD1Table
    Local cSZ0Table

    Local CN9Table
    Local CNATable
    Local CNBTable
    Local CNFTable

    Local cSC1Filial
    Local cSC7Filial
    Local cSD1Filial    
    Local cSZ0Filial

    Local cCN9Filial
    Local cCNAFilial
    Local cCNBFilial
    Local cCNFFilial

    Local cYFDay
    Local cYLDay
    Local cCNFCompete

    Local nRecno
    Local nRecnos
    
    Local nCNBOrder

    Local lLock

    BEGIN SEQUENCE

        IF !(SZ0ChkLink())
            BREAK
        EndIF

        cYFDay:=Dtos(FirstYDate(dDataBase))
        cYLDay:=Dtos(LastYDate(dDataBase))

        aFromTo:={}
        cAlias:=GetNextAlias()

        cSC1Table:=RetSqlName("SC1")
        cSC7Table:=RetSqlName("SC7")
        cSD1Table:=RetSqlName("SD1")
        cSZ0Table:=RetSqlName("SZ0")

        cSC1Filial:=xFilial("SC1")
        cSC7Filial:=xFilial("SC7")
        cSD1Filial:=xFilial("SD1")
        cSZ0Filial:=xFilial("SZ0")

        StaticCall(NDJLIB004,SetPublic,"__nSZ0Recno",0,"N",0,.T.,.F.)

        //Verifica se existem informacoes na SC7 que nao Foram Empenhadas
        cQuery:="SELECT"+__cCRLF
        cQuery+="    SC7.R_E_C_N_O_ C7RECNO"+__cCRLF
        cQuery+="FROM"+__cCRLF
        cQuery+="    "+cSC7Table+" SC7 "+__cCRLF
        cQuery+="WHERE"+__cCRLF
        cQuery+="    SC7.C7_FILIAL ='"+cSC7Filial+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC7.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC7.C7_DATPRF >='"+cYFDay+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC7.C7_DATPRF <='"+cYLDay+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    NOT EXISTS"+__cCRLF
        cQuery+="    ("+__cCRLF
        cQuery+="        SELECT"+__cCRLF
        cQuery+="            1"+__cCRLF
        cQuery+="        FROM "+__cCRLF
        cQuery+="            "+cSZ0Table+" SZ0 "+__cCRLF
        cQuery+="        WHERE"+__cCRLF
        cQuery+="        ("+__cCRLF
        cQuery+="            SZ0.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_FILIAL ='"+cSZ0Filial+"'"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ALIAS ='SC7'"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XFILIAL =SC7.C7_FILIAL"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_PROJETO =SC7.C7_XPROJET"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_REVISAO =SC7.C7_XREVIS"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_TAREFA =SC7.C7_XTAREFA"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_NUM =SC7.C7_NUMSC"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ITEM =SC7.C7_ITEMSC"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_SEQUEN =SC7.C7_SEQUEN"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ITEMGRD =SC7.C7_ITEMGRD"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ORCAME =SC7.C7_CODORCA"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XCODOR =SC7.C7_XCODOR"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XCODSBM =SC7.C7_XCODSBM"+__cCRLF
        cQuery+="  )"+__cCRLF
        cQuery+=")"+__cCRLF

        TCQUERY (cQuery)ALIAS (cAlias)NEW
    
        TcSetField(cAlias,"C7RECNO","N",18,0)
    
        IF (cAlias)->(!Eof() .and. !Bof())
    
            PutToFrom(@aFromTo,"Z0_PROJETO","C7_XPROJET")
            PutToFrom(@aFromTo,"Z0_REVISAO","C7_XREVIS")          
            PutToFrom(@aFromTo,"Z0_TAREFA","C7_XTAREFA")
            PutToFrom(@aFromTo,"Z0_ORCAME","C7_CODORCA")
            PutToFrom(@aFromTo,"Z0_XCODOR","C7_XCODOR")
            PutToFrom(@aFromTo,"Z0_XFILIAL","C7_FILIAL")
            PutToFrom(@aFromTo,"Z0_NUM"  ,"C7_NUMSC")
            PutToFrom(@aFromTo,"Z0_ITEM"  ,"C7_ITEMSC")
            PutToFrom(@aFromTo,"Z0_ITEMGRD","C7_ITEMGRD")
            PutToFrom(@aFromTo,"Z0_SEQUEN","C7_SEQUEN")
            PutToFrom(@aFromTo,"Z0_XCODSBM","C7_XCODSBM")

            While (cAlias)->(!Eof())
    
                SC7->(dbGoto((cAlias)->C7RECNO))
    
                IF SC7->(!Eof() .and. !Bof())
                    
                    IF SZ0->(RecLock("SZ0",.T.))
                
                        nRecno:=SZ0->(Recno())
                        StaticCall(NDJLIB001,SetMemVar,"__nSZ0Recno",@nRecno)
                        lLock:=(lUseKeySZ0("SC7",@nRecno,.F.).and. StaticCall(NDJLIB003,LockSoft,"SZ0"))
                
                        TRYEXCEPTION
                            
                            StaticCall(NDJLIB001,__FieldPut,"SZ0","Z0_FILIAL",cSZ0Filial,.T.)
                            StaticCall(NDJLIB001,__FieldPut,"SZ0","Z0_ALIAS"  ,"SC7"   ,.T.)
                            
                            StaticCall(NDJLIB001,NDJFromTo,"SC7","SZ0",@aFromTo)
                            
                            SZ0->(MsUnLock())
    
                            lLock:=(lUseKeySZ0("SC7",@nRecno,.F.).and. StaticCall(NDJLIB003,LockSoft,"SZ0"))
                            lLock:=(lLock .and. RecLock("SZ0",.F.))
    
                            C7PrecoVld(NIL,.F.,NIL)
    
                            SZ0->(MsUnLock())
    
                            StaticCall(NDJLIB001,__FieldPut,"SZ0","Z0_LASTVAL",SZ0->Z0_VALOR  ,.T.)
                            StaticCall(NDJLIB001,__FieldPut,"SZ0","Z0_LINKED",.T.           ,.T.)
    
                            StaticCall(NDJLIB001,__FieldPut,"SC7","C7_Z0LINKD",.T.           ,.T.)
    
                        CATCHEXCEPTION
                        
                            SZ0->(MsGoto(nRecno))
                            IF SZ0->((!Eof() .and. !Bof()))
                                IF SZ0->(RecLock("SZ0",.F.))
                                    SZ0->(dbDelete())
                                EndIF    
                            EndIF
    
                        ENDEXCEPTION
                        
                        SZ0->(MsUnLock())
    
                        StaticCall(NDJLIB001,SetMemVar,"__nSZ0Recno",0)
    
                        ChkMaxLock()

                    EndIF
    
                EndIF
    
                (cAlias)->(dbSkip())
    
            End While
    
            aFromTo:={}
    
        EndIF

        (cAlias)->(dbCloseArea())
    
        //Verifica se existem informacoes na SC1 que nao Foram Empenhadas
        cQuery:="SELECT"+__cCRLF
        cQuery+="    SC1.R_E_C_N_O_ C1RECNO"+__cCRLF
        cQuery+="FROM"+__cCRLF
        cQuery+="    "+cSC1Table+" SC1 "+__cCRLF
        cQuery+="WHERE"+__cCRLF
        cQuery+="    SC1.C1_FILIAL =' '"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC1.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC1.C1_DATPRF >='"+cYFDay+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC1.C1_DATPRF <='"+cYLDay+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    ("+__cCRLF
        cQuery+="        SC1.C1_MSBLQL ='2'"+__cCRLF
        cQuery+="        OR"+__cCRLF
        cQuery+="        SC1.C1_MSBLQL =' '"+__cCRLF
        cQuery+=")"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC1.C1_APROV <>'R'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    NOT EXISTS"+__cCRLF
        cQuery+="    ("+__cCRLF
        cQuery+="        SELECT"+__cCRLF
        cQuery+="            1"+__cCRLF
        cQuery+="        FROM "+__cCRLF
        cQuery+="            "+cSZ0Table+" SZ0 "+__cCRLF
        cQuery+="        WHERE"+__cCRLF
        cQuery+="        ("+__cCRLF
        cQuery+="            SZ0.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_FILIAL ='"+cSC1Filial+"'"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ALIAS ='SC1'"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XFILIAL =SC1.C1_FILIAL"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_PROJETO =SC1.C1_XPROJET"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_REVISAO =SC1.C1_XREVISA"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_TAREFA =SC1.C1_XTAREFA"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_NUM =SC1.C1_NUM"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ITEM =SC1.C1_ITEM"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ITEMGRD =SC1.C1_ITEMGRD"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ORCAME =SC1.C1_CODORCA"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XCODOR =SC1.C1_XCODOR"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XCODSBM =SC1.C1_XCODSBM"+__cCRLF
        cQuery+="  )"+__cCRLF
        cQuery+=")"+__cCRLF
    
        TCQUERY (cQuery)ALIAS (cAlias)NEW
    
        TcSetField(cAlias,"C1RECNO","N",18,0)
    
        IF (cAlias)->(!Eof() .and. !Bof())

            PutToFrom(@aFromTo,"Z0_PROJETO","C1_XPROJET")
            PutToFrom(@aFromTo,"Z0_REVISAO","C1_XREVISA")           
            PutToFrom(@aFromTo,"Z0_TAREFA","C1_XTAREFA")
            PutToFrom(@aFromTo,"Z0_ORCAME","C1_CODORCA")
            PutToFrom(@aFromTo,"Z0_XCODOR","C1_XCODOR")
            PutToFrom(@aFromTo,"Z0_XFILIAL","C1_FILIAL")
            PutToFrom(@aFromTo,"Z0_NUM"  ,"C1_NUM"  )
            PutToFrom(@aFromTo,"Z0_ITEM"  ,"C1_ITEM")
            PutToFrom(@aFromTo,"Z0_ITEMGRD","C1_ITEMGRD")
            PutToFrom(@aFromTo,"Z0_XCODSBM","C1_XCODSBM")

            While (cAlias)->(!Eof())
    
                SC1->(dbGoto((cAlias)->C1RECNO))
    
                IF SC1->(!Eof() .and. !Bof())
    
                    IF SZ0->(RecLock("SZ0",.T.))
                
                        nRecno:=SZ0->(Recno())  
                        StaticCall(NDJLIB001,SetMemVar,"__nSZ0Recno",@nRecno)
                        lLock:=(lUseKeySZ0("SC1",@nRecno,.F.).and. StaticCall(NDJLIB003,LockSoft,"SZ0"))
                
                        TRYEXCEPTION
                            
                            StaticCall(NDJLIB001,__FieldPut,"SZ0","Z0_FILIAL",cSZ0Filial,.T.)
                            StaticCall(NDJLIB001,__FieldPut,"SZ0","Z0_ALIAS"  ,"SC1"   ,.T.)
    
                            StaticCall(NDJLIB001,NDJFromTo,"SC1","SZ0",@aFromTo)
    
                            SZ0->(MsUnLock())
    
                            lLock:=(lUseKeySZ0("SC1",@nRecno,.F.).and. StaticCall(NDJLIB003,LockSoft,"SZ0"))
                            lLock:=(lLock .and. RecLock("SZ0",.F.))
    
                            C1XPrecoVld(NIL,.F.,.F.)
    
                            StaticCall(NDJLIB001,__FieldPut,"SZ0","Z0_LASTVAL",SZ0->Z0_VALOR  ,.T.)
                            StaticCall(NDJLIB001,__FieldPut,"SZ0","Z0_LINKED",.T.           ,.T.)
    
                            SZ0->(MsUnLock())
    
                        CATCHEXCEPTION
    
                            SZ0->(MsGoto(nRecno))
                            IF SZ0->((!Eof() .and. !Bof()))
                                IF SZ0->(RecLock("SZ0",.F.))
                                    SZ0->(dbDelete())
                                EndIF    
                            EndIF    
    
                        ENDEXCEPTION
    
                        SZ0->(MsUnLock())
                        
                        StaticCall(NDJLIB001,SetMemVar,"__nSZ0Recno",0)
    
                        ChkMaxLock()
                    
                    EndIF
    
                EndIF
    
                (cAlias)->(dbSkip())
    
            End While
    
            aFromTo:={}
    
        EndIF

        (cAlias)->(dbCloseArea())

        //Verifica se existem informacoes na SD1 que nao Foram Empenhadas
        cQuery:="SELECT"+__cCRLF
        cQuery+="    SD1.R_E_C_N_O_ D1RECNO"+__cCRLF
        cQuery+="FROM"+__cCRLF
        cQuery+="    "+cSD1Table+" SD1 "+__cCRLF
        cQuery+="WHERE"+__cCRLF
        cQuery+="    SD1.D1_FILIAL ='"+cSD1Filial+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SD1.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SD1.D1_EMISSAO >='"+cYFDay+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SD1.D1_EMISSAO <='"+cYLDay+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    NOT EXISTS"+__cCRLF
        cQuery+="    ("+__cCRLF
        cQuery+="        SELECT"+__cCRLF
        cQuery+="            1"+__cCRLF
        cQuery+="        FROM "+__cCRLF
        cQuery+="            "+cSZ0Table+" SZ0 "+__cCRLF
        cQuery+="        WHERE"+__cCRLF
        cQuery+="        ("+__cCRLF
        cQuery+="            SZ0.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_FILIAL ='"+cSZ0Filial+"'"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ALIAS ='SC7'"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XFILIAL =SD1.D1_FILIAL"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_PROJETO =SD1.D1_XPROJET"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_REVISAO =SD1.D1_XREVIS"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_TAREFA =SD1.D1_XTAREFA"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_NUM =SD1.D1_XNUMSC"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ITEM =SD1.D1_XITEMSC"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_SEQUEN =SD1.D1_XSEQUEN"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ITEMGRD =SD1.D1_ITEMGRD"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ORCAME =SD1.D1_CODORCA"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XCODOR =SD1.D1_XCODOR"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XCODSBM =SD1.D1_XCODSBM"+__cCRLF
        cQuery+="  )"+__cCRLF
        cQuery+=")"+__cCRLF

        TCQUERY (cQuery)ALIAS (cAlias)NEW

        TcSetField(cAlias,"D1RECNO","N",18,0)

        While (cAlias)->(!Eof())
            SD1->(dbGoto((cAlias)->D1RECNO))
            IF SD1->(!Eof() .and. !Bof())
                D1VUnitVld(NIL,.F.,.F.)
                ChkMaxLock()
            EndIF    
            (cAlias)->(dbSkip())
        End While

        (cAlias)->(dbCloseArea())

        //Verifica se existem informacoes na SZ0 que nao correspondam a Item da SC1,SC7 e SD1
        cQuery:="SELECT"+__cCRLF
        cQuery+="    SZ0.R_E_C_N_O_ Z0RECNO "+__cCRLF
        cQuery+="FROM"+__cCRLF
        cQuery+="    "+cSZ0Table+" SZ0 "+__cCRLF
        cQuery+="WHERE"+__cCRLF
        cQuery+="    SZ0.Z0_FILIAL ='"+cSZ0Filial+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SZ0.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    NOT EXISTS"+__cCRLF
        cQuery+="    ("+__cCRLF
        cQuery+="        SELECT"+__cCRLF
        cQuery+="        1"+__cCRLF
        cQuery+="        FROM "+__cCRLF
        cQuery+="            "+cSC1Table+" SC1 "+__cCRLF
        cQuery+="        WHERE"+__cCRLF
        cQuery+="        ("+__cCRLF
        cQuery+="            SC1.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SC1.C1_FILIAL ='"+cSC1Filial+"'"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ALIAS ='SC1'"+__cCRLF    
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XFILIAL =SC1.C1_FILIAL"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_PROJETO =SC1.C1_XPROJET"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_REVISAO =SC1.C1_XREVISA"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_TAREFA =SC1.C1_XTAREFA"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_NUM =SC1.C1_NUM"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ITEM =SC1.C1_ITEM"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ITEMGRD =SC1.C1_ITEMGRD"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ORCAME =SC1.C1_CODORCA"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XCODOR =SC1.C1_XCODOR"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XCODSBM =SC1.C1_XCODSBM"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            ("+__cCRLF
        cQuery+="                SC1.C1_MSBLQL ='2'"+__cCRLF
        cQuery+="                OR"+__cCRLF
        cQuery+="                SC1.C1_MSBLQL =' '"+__cCRLF
        cQuery+="      )"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SC1.C1_APROV <>'R'"+__cCRLF
        cQuery+="  )"+__cCRLF
        cQuery+=")"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    NOT EXISTS"+__cCRLF
        cQuery+="    ("+__cCRLF
        cQuery+="        SELECT"+__cCRLF
        cQuery+="        1"+__cCRLF
        cQuery+="        FROM "+__cCRLF
        cQuery+="            "+cSC7Table+" SC7 "+__cCRLF
        cQuery+="        WHERE"+__cCRLF
        cQuery+="        ("+__cCRLF
        cQuery+="            SC7.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SC7.C7_FILIAL ='"+cSC7Filial+"'"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ALIAS ='SC7'"+__cCRLF    
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XFILIAL =SC7.C7_FILIAL"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_PROJETO =SC7.C7_XPROJET"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_REVISAO =SC7.C7_XREVIS"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_TAREFA =SC7.C7_XTAREFA"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_NUM =SC7.C7_NUMSC"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ITEM =SC7.C7_ITEMSC"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_SEQUEN =SC7.C7_SEQUEN"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ITEMGRD =SC7.C7_ITEMGRD"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ORCAME =SC7.C7_CODORCA"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XCODOR =SC7.C7_XCODOR"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XCODSBM =SC7.C7_XCODSBM"+__cCRLF
        cQuery+="  )"+__cCRLF
        cQuery+=")"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    NOT EXISTS"+__cCRLF
        cQuery+="    ("+__cCRLF
        cQuery+="        SELECT"+__cCRLF
        cQuery+="            1"+__cCRLF
        cQuery+="        FROM "+__cCRLF
        cQuery+="            "+cSD1Table+" SD1 "+__cCRLF
        cQuery+="        WHERE"+__cCRLF
        cQuery+="        ("+__cCRLF
        cQuery+="            SZ0.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_FILIAL ='"+cSZ0Filial+"'"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ALIAS ='SC7'"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XFILIAL =SD1.D1_FILIAL"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_PROJETO =SD1.D1_XPROJET"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_REVISAO =SD1.D1_XREVIS"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_TAREFA =SD1.D1_XTAREFA"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_NUM =SD1.D1_XNUMSC"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ITEM =SD1.D1_XITEMSC"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_SEQUEN =SD1.D1_XSEQUEN"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ITEMGRD =SD1.D1_ITEMGRD"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ORCAME =SD1.D1_CODORCA"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XCODOR =SD1.D1_XCODOR"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XCODSBM =SD1.D1_XCODSBM"+__cCRLF
        cQuery+="  )"+__cCRLF
        cQuery+=")"+__cCRLF

        TCQUERY (cQuery)ALIAS (cAlias)NEW
    
        TcSetField(cAlias,"Z0RECNO","N",18,0)
    
        While (cAlias)->(!Eof())
    
            SZ0->(dbGoto((cAlias)->Z0RECNO))
    
            IF SZ0->(!Eof() .and. !Bof())
                lLock:=(lUseKeySZ0(SZ0->Z0_ALIAS,@nRecno,.F.).and. StaticCall(NDJLIB003,LockSoft,"SZ0"))
                IF (lLock)
                    IF SZ0->(RecLock("SZ0",.F.))
                        SZ0->(dbDelete())
                        SZ0->(MsUnLock())
                    EndIF
                    ChkMaxLock()
                EndIF
                SZ0->(lUseKeySZ0(Z0_ALIAS,@nRecno,.T.))
            EndIF

            (cAlias)->(dbSkip())
    
        End While

        (cAlias)->(dbCloseArea())

        //Verifica o Link de Empenho com a SC1
        cQuery:="SELECT"+__cCRLF
        cQuery+="    SC1.R_E_C_N_O_ C1RECNO "+__cCRLF
        cQuery+="FROM"+__cCRLF
        cQuery+="    "+cSC1Table+" SC1 "+__cCRLF
        cQuery+="WHERE"+__cCRLF
        cQuery+="    SC1.C1_FILIAL ='"+cSC1Filial+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC1.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC1.C1_Z0LINKD ='F'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC1.C1_DATPRF >='"+cYFDay+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC1.C1_DATPRF <='"+cYLDay+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    ("+__cCRLF
        cQuery+="        SC1.C1_MSBLQL ='2'"+__cCRLF
        cQuery+="        OR"+__cCRLF
        cQuery+="        SC1.C1_MSBLQL =' '"+__cCRLF
        cQuery+=")"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC1.C1_APROV <>'R'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    EXISTS"+__cCRLF
        cQuery+="    ("+__cCRLF
        cQuery+="        SELECT"+__cCRLF
        cQuery+="            1"+__cCRLF
        cQuery+="        FROM "+__cCRLF
        cQuery+="            "+cSZ0Table+" SZ0 "+__cCRLF
        cQuery+="        WHERE"+__cCRLF
        cQuery+="        ("+__cCRLF
        cQuery+="            SZ0.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_FILIAL ='"+cSZ0Filial+"'"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ALIAS ='SC1'"+__cCRLF    
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XFILIAL =SC1.C1_FILIAL"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_PROJETO =SC1.C1_XPROJET"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_REVISAO =SC1.C1_XREVISA"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_TAREFA =SC1.C1_XTAREFA"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_NUM =SC1.C1_NUM"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ITEM =SC1.C1_ITEM"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ITEMGRD =SC1.C1_ITEMGRD"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ORCAME =SC1.C1_CODORCA"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XCODOR =SC1.C1_XCODOR"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XCODSBM =SC1.C1_XCODSBM"+__cCRLF
        cQuery+="  )"+__cCRLF
        cQuery+=")"+__cCRLF

        TCQUERY (cQuery)ALIAS (cAlias)NEW
    
        TcSetField(cAlias,"C1RECNO","N",18,0)
    
        While (cAlias)->(!Eof())
    
            SC1->(dbGoto((cAlias)->C1RECNO))
    
            IF SC1->(!Eof() .and. !Bof())
                lLock:=StaticCall(NDJLIB003,LockSoft,"SC1")
                IF (lLock)
                    IF SC1->(RecLock("SC1",.F.))
                        SC1->C1_Z0LINKD:=.T.
                        SC1->(MsUnLock())
                    EndIF
                    ChkMaxLock()
                EndIF
            EndIF

            (cAlias)->(dbSkip())
        
        End While
    
        (cAlias)->(dbCloseArea())

        //Verifica o Link (perdido) de Empenho com a SC1
        cQuery:="SELECT"+__cCRLF
        cQuery+="    SC1.R_E_C_N_O_ C1RECNO "+__cCRLF
        cQuery+="FROM"+__cCRLF
        cQuery+="    "+cSC1Table+" SC1 "+__cCRLF
        cQuery+="WHERE"+__cCRLF
        cQuery+="    SC1.C1_FILIAL ='"+cSC1Filial+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC1.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC1.C1_Z0LINKD ='T'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC1.C1_DATPRF >='"+cYFDay+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC1.C1_DATPRF <='"+cYLDay+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    ("+__cCRLF
        cQuery+="        SC1.C1_MSBLQL ='2'"+__cCRLF
        cQuery+="        OR"+__cCRLF
        cQuery+="        SC1.C1_MSBLQL =' '"+__cCRLF
        cQuery+=")"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC1.C1_APROV <>'R'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    NOT EXISTS"+__cCRLF
        cQuery+="    ("+__cCRLF
        cQuery+="        SELECT"+__cCRLF
        cQuery+="            1"+__cCRLF
        cQuery+="        FROM "+__cCRLF
        cQuery+="            "+cSZ0Table+" SZ0 "+__cCRLF
        cQuery+="        WHERE"+__cCRLF
        cQuery+="        ("+__cCRLF
        cQuery+="            SZ0.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_FILIAL ='"+cSZ0Filial+"'"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ALIAS ='SC1'"+__cCRLF    
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XFILIAL =SC1.C1_FILIAL"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_PROJETO =SC1.C1_XPROJET"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_REVISAO =SC1.C1_XREVISA"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_TAREFA =SC1.C1_XTAREFA"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_NUM =SC1.C1_NUM"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ITEM =SC1.C1_ITEM"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ITEMGRD =SC1.C1_ITEMGRD"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ORCAME =SC1.C1_CODORCA"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XCODOR =SC1.C1_XCODOR"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XCODSBM =SC1.C1_XCODSBM"+__cCRLF
        cQuery+="  )"+__cCRLF
        cQuery+=")"+__cCRLF

        TCQUERY (cQuery)ALIAS (cAlias)NEW
    
        TcSetField(cAlias,"C1RECNO","N",18,0)
    
        While (cAlias)->(!Eof())
    
            SC1->(dbGoto((cAlias)->C1RECNO))
    
            IF SC1->(!Eof() .and. !Bof())
                lLock:=StaticCall(NDJLIB003,LockSoft,"SC1")
                IF (lLock)
                    IF SC1->(RecLock("SC1",.F.))
                        SC1->C1_Z0LINKD:=.F.
                        SC1->(MsUnLock())
                    EndIF
                    ChkMaxLock()
                EndIF
            EndIF
        
            (cAlias)->(dbSkip())
        
        End While
    
        (cAlias)->(dbCloseArea())

        //Verifica o Link de Empenho com a SC7
        cQuery:="SELECT"+__cCRLF
        cQuery+="    SC7.R_E_C_N_O_ C7RECNO "+__cCRLF
        cQuery+="FROM"+__cCRLF
        cQuery+="    "+cSC7Table+" SC7 "+__cCRLF
        cQuery+="WHERE"+__cCRLF
        cQuery+="    SC7.C7_FILIAL ='"+cSC7Filial+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC7.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC7.C7_Z0LINKD ='F'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC7.C7_DATPRF >='"+cYFDay+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC7.C7_DATPRF <='"+cYLDay+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    EXISTS"+__cCRLF
        cQuery+="    ("+__cCRLF
        cQuery+="        SELECT"+__cCRLF
        cQuery+="            1"+__cCRLF
        cQuery+="        FROM "+__cCRLF
        cQuery+="            "+cSZ0Table+" SZ0 "+__cCRLF
        cQuery+="        WHERE"+__cCRLF
        cQuery+="        ("+__cCRLF
        cQuery+="            SZ0.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_FILIAL ='"+cSZ0Filial+"'"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ALIAS ='SC7'"+__cCRLF    
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XFILIAL =SC7.C7_FILIAL"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_PROJETO =SC7.C7_XPROJET"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_REVISAO =SC7.C7_XREVIS"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_TAREFA =SC7.C7_XTAREFA"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_NUM =SC7.C7_NUMSC"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ITEM =SC7.C7_ITEMSC"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_SEQUEN =SC7.C7_SEQUEN"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ITEMGRD =SC7.C7_ITEMGRD"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ORCAME =SC7.C7_CODORCA"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XCODOR =SC7.C7_XCODOR"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XCODSBM =SC7.C7_XCODSBM"+__cCRLF
        cQuery+="  )"+__cCRLF
        cQuery+=")"+__cCRLF

        TCQUERY (cQuery)ALIAS (cAlias)NEW
    
        TcSetField(cAlias,"C7RECNO","N",18,0)
    
        While (cAlias)->(!Eof())
    
            SC7->(dbGoto((cAlias)->C7RECNO))
    
            IF SC7->(!Eof() .and. !Bof())
                lLock:=StaticCall(NDJLIB003,LockSoft,"SC7")
                IF (lLock)
                    IF SC7->(RecLock("SC7",.F.))
                        SC7->C7_Z0LINKD:=.T.
                        SC7->(MsUnLock())
                    EndIF
                    ChkMaxLock()
                EndIF
            EndIF
            
            (cAlias)->(dbSkip())
        
        End While

        (cAlias)->(dbCloseArea())
        
        //Verifica o Link (perdido)de Empenho com a SC7
        cQuery:="SELECT"+__cCRLF
        cQuery+="    SC7.R_E_C_N_O_ C7RECNO "+__cCRLF
        cQuery+="FROM"+__cCRLF
        cQuery+="    "+cSC7Table+" SC7 "+__cCRLF
        cQuery+="WHERE"+__cCRLF
        cQuery+="    SC7.C7_FILIAL ='"+cSC7Filial+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC7.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC7.C7_Z0LINKD ='T'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC7.C7_DATPRF >='"+cYFDay+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC7.C7_DATPRF <='"+cYLDay+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    NOT EXISTS"+__cCRLF
        cQuery+="    ("+__cCRLF
        cQuery+="        SELECT"+__cCRLF
        cQuery+="            1"+__cCRLF
        cQuery+="        FROM "+__cCRLF
        cQuery+="            "+cSZ0Table+" SZ0 "+__cCRLF
        cQuery+="        WHERE"+__cCRLF
        cQuery+="        ("+__cCRLF
        cQuery+="            SZ0.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_FILIAL ='"+cSZ0Filial+"'"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ALIAS ='SC7'"+__cCRLF    
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XFILIAL =SC7.C7_FILIAL"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_PROJETO =SC7.C7_XPROJET"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_REVISAO =SC7.C7_XREVIS"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_TAREFA =SC7.C7_XTAREFA"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_NUM =SC7.C7_NUMSC"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ITEM =SC7.C7_ITEMSC"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_SEQUEN =SC7.C7_SEQUEN"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ITEMGRD =SC7.C7_ITEMGRD"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ORCAME =SC7.C7_CODORCA"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XCODOR =SC7.C7_XCODOR"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XCODSBM =SC7.C7_XCODSBM"+__cCRLF
        cQuery+="  )"+__cCRLF
        cQuery+=")"+__cCRLF

        TCQUERY (cQuery)ALIAS (cAlias)NEW
    
        TcSetField(cAlias,"C7RECNO","N",18,0)
    
        While (cAlias)->(!Eof())
    
            SC7->(dbGoto((cAlias)->C7RECNO))
    
            IF SC7->(!Eof() .and. !Bof())
                lLock:=StaticCall(NDJLIB003,LockSoft,"SC7")
                IF (lLock)
                    IF SC7->(RecLock("SC7",.F.))
                        SC7->C7_Z0LINKD:=.F.
                        SC7->(MsUnLock())
                    EndIF
                    ChkMaxLock()
                EndIF
            EndIF
        
            (cAlias)->(dbSkip())
        
        End While

        (cAlias)->(dbCloseArea())

        //Verifica a Quem Pertence o Link da SZ0
        cQuery:="SELECT"+__cCRLF
        cQuery+="    SC7.R_E_C_N_O_ C7RECNO "+__cCRLF
        cQuery+="FROM"+__cCRLF
        cQuery+="    "+cSC7Table+" SC7 "+__cCRLF
        cQuery+="WHERE"+__cCRLF
        cQuery+="    SC7.C7_FILIAL ='"+cSC7Filial+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC7.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC7.C7_DATPRF >='"+cYFDay+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    SC7.C7_DATPRF <='"+cYLDay+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    EXISTS"+__cCRLF
        cQuery+="    ("+__cCRLF
        cQuery+="        SELECT"+__cCRLF
        cQuery+="            1"+__cCRLF
        cQuery+="        FROM "+__cCRLF
        cQuery+="            "+cSZ0Table+" SZ0 "+__cCRLF
        cQuery+="        WHERE"+__cCRLF
        cQuery+="        ("+__cCRLF
        cQuery+="            SZ0.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_FILIAL ='"+cSZ0Filial+"'"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ALIAS ='SC7'"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XFILIAL =SC7.C7_FILIAL"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_PROJETO =SC7.C7_XPROJET"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_REVISAO =SC7.C7_XREVIS"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_TAREFA =SC7.C7_XTAREFA"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_NUM =SC7.C7_NUMSC"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ITEM =SC7.C7_ITEMSC"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_SEQUEN =SC7.C7_SEQUEN"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ITEMGRD =SC7.C7_ITEMGRD"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_ORCAME =SC7.C7_CODORCA"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XCODOR =SC7.C7_XCODOR"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            SZ0.Z0_XCODSBM =SC7.C7_XCODSBM"+__cCRLF
        cQuery+="  )"+__cCRLF
        cQuery+=")"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    EXISTS"+__cCRLF
        cQuery+="    ("+__cCRLF
        cQuery+="        SELECT"+__cCRLF
        cQuery+="            1"+__cCRLF
        cQuery+="        FROM "+__cCRLF
        cQuery+="            "+cSZ0Table+" SZ0,"+__cCRLF
        cQuery+="            "+cSC1Table+" SC1 "+__cCRLF
        cQuery+="        WHERE"+__cCRLF
        cQuery+="        ("+__cCRLF
        cQuery+="            ("+__cCRLF
        cQuery+="                SZ0.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="                AND"+__cCRLF
        cQuery+="                SZ0.Z0_LINKED ='T'"+__cCRLF
        cQuery+="                AND    "+__cCRLF
        cQuery+="                SZ0.Z0_FILIAL ='"+cSZ0Filial+"'"+__cCRLF
        cQuery+="                AND"+__cCRLF
        cQuery+="                SZ0.Z0_ALIAS ='SC1'"+__cCRLF
        cQuery+="                AND"+__cCRLF
        cQuery+="                SC1.C1_FILIAL ='"+cSC1Filial+"'"+__cCRLF
        cQuery+="                AND"+__cCRLF
        cQuery+="                SZ0.Z0_XFILIAL =SC1.C1_FILIAL"+__cCRLF
        cQuery+="                AND"+__cCRLF
        cQuery+="                SZ0.Z0_PROJETO =SC1.C1_XPROJET"+__cCRLF
        cQuery+="                AND"+__cCRLF
        cQuery+="                SZ0.Z0_REVISAO =SC1.C1_XREVISA"+__cCRLF
        cQuery+="                AND"+__cCRLF
        cQuery+="                SZ0.Z0_TAREFA =SC1.C1_XTAREFA"+__cCRLF
        cQuery+="                AND"+__cCRLF
        cQuery+="                SZ0.Z0_NUM =SC1.C1_NUM"+__cCRLF
        cQuery+="                AND"+__cCRLF
        cQuery+="                SZ0.Z0_ITEM =SC1.C1_ITEM"+__cCRLF
        cQuery+="                AND"+__cCRLF
        cQuery+="                SZ0.Z0_ITEMGRD =SC1.C1_ITEMGRD"+__cCRLF
        cQuery+="                AND"+__cCRLF
        cQuery+="                SZ0.Z0_ORCAME =SC1.C1_CODORCA"+__cCRLF
        cQuery+="                AND"+__cCRLF
        cQuery+="                SZ0.Z0_XCODOR =SC1.C1_XCODOR"+__cCRLF
        cQuery+="                AND"+__cCRLF
        cQuery+="                SZ0.Z0_XCODSBM =SC1.C1_XCODSBM"+__cCRLF
        cQuery+="      )"+__cCRLF
        cQuery+="            AND"+__cCRLF
        cQuery+="            ("+__cCRLF
        cQuery+="                SC1.C1_XPROJET =SC7.C7_XPROJET"+__cCRLF
        cQuery+="                AND"+__cCRLF
        cQuery+="                SC1.C1_XREVISA =SC7.C7_XREVIS"+__cCRLF
        cQuery+="                AND"+__cCRLF
        cQuery+="                SC1.C1_XTAREFA =SC7.C7_XTAREFA"+__cCRLF
        cQuery+="                AND"+__cCRLF
        cQuery+="                SC1.C1_NUM =SC7.C7_NUMSC"+__cCRLF
        cQuery+="                AND"+__cCRLF
        cQuery+="                SC1.C1_ITEM =SC7.C7_ITEMSC"+__cCRLF
        cQuery+="                AND"+__cCRLF
        cQuery+="                SC1.C1_ITEMGRD =SC7.C7_ITEMGRD"+__cCRLF
        cQuery+="                AND"+__cCRLF
        cQuery+="                SC1.C1_CODORCA =SC7.C7_CODORCA"+__cCRLF
        cQuery+="                AND"+__cCRLF
        cQuery+="                SC1.C1_XCODOR =SC7.C7_XCODOR"+__cCRLF
        cQuery+="                AND"+__cCRLF
        cQuery+="                SC1.C1_XCODSBM =SC7.C7_XCODSBM"+__cCRLF
        cQuery+="      )"+__cCRLF
        cQuery+="  )"+__cCRLF
        cQuery+=")"+__cCRLF

        TCQUERY (cQuery)ALIAS (cAlias)NEW
    
        TcSetField(cAlias,"C7RECNO","N",18,0)
    
        While (cAlias)->(!Eof())

            SC7->(dbGoto((cAlias)->C7RECNO))

            IF SC7->(!Eof() .and. !Bof())
                lLock:=StaticCall(NDJLIB003,LockSoft,"SC7")
                IF (lLock)
                    AliasSZ0Lnk("SC7")
                    ChkMaxLock()
                EndIF
            EndIF

            (cAlias)->(dbSkip())

        End While

        (cAlias)->(dbCloseArea())

        //Verifica Empenho de Acordo com Cronograma de Contratos
        CN9Table:=RetSqlName("CN9")
        CNATable:=RetSqlName("CNA")
        CNBTable:=RetSqlName("CNB")
        CNFTable:=RetSqlName("CNF")

        cCN9Filial:=xFilial("CN9")
        cCNAFilial:=xFilial("CNA")
        cCNBFilial:=xFilial("CNB")
        cCNFFilial:=xFilial("CNF")

        cCNFCompete:=Year2Str(dDataBase)

        cQuery:="SELECT"+__cCRLF
        cQuery+="    CN9.CN9_NUMERO,"+__cCRLF
        cQuery+="    CN9.CN9_REVISA,"+__cCRLF
        cQuery+="    CNA.CNA_NUMERO,"+__cCRLF
        cQuery+="    CNA.CNA_CRONOG"+__cCRLF
        cQuery+="FROM"+__cCRLF
        cQuery+="    "+CN9Table+" CN9,"+__cCRLF
        cQuery+="    "+CNATable+" CNA,"+__cCRLF
        cQuery+="    "+CNBTable+" CNB,"+__cCRLF
        cQuery+="    "+CNFTable+" CNF  "+__cCRLF
        cQuery+="WHERE"+__cCRLF
        cQuery+="    CN9.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNA.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNB.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNF.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CN9.CN9_FILIAL ='"+cCN9Filial+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNA.CNA_FILIAL ='"+cCNAFilial+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNB.CNB_FILIAL ='"+cCNBFilial+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNF.CNF_FILIAL ='"+cCNFFilial+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CN9.CN9_DTINIC <='"+cYFDay+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CN9.CN9_DTFIM >='"+cYLDay+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CN9.CN9_SITUAC ='05'"+__cCRLF
        cQuery+="    AND    "+__cCRLF
        cQuery+="    CNA.CNA_CONTRA =CN9.CN9_NUMERO"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNB.CNB_CONTRA =CN9.CN9_NUMERO"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNF.CNF_CONTRA =CN9.CN9_NUMERO"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNA.CNA_REVISA =CN9.CN9_REVISA"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNB.CNB_REVISA =CN9.CN9_REVISA"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNF.CNF_REVISA =CN9.CN9_REVISA"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNA.CNA_CRONOG <>'"+Space(GetSx3Cache("CNA_CRONOG","X3_TAMANHO"))+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNF.CNF_NUMERO =CNA.CNA_CRONOG"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNB.CNB_NUMERO =CNA.CNA_NUMERO"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    Substring(CNF.CNF_COMPET,4,4)='"+cCNFCompete+"'"+__cCRLF
        cQuery+="GROUP BY"+__cCRLF
        cQuery+="    CN9.CN9_NUMERO,"+__cCRLF
        cQuery+="    CN9.CN9_REVISA,"+__cCRLF
        cQuery+="    CNA.CNA_NUMERO,"+__cCRLF
        cQuery+="    CNA.CNA_CRONOG"+__cCRLF

        TCQUERY (cQuery)ALIAS (cAlias)NEW

        While (cAlias)->(!Eof())

            cContra:=(cAlias)->CN9_NUMERO
            cRevisao:=(cAlias)->CN9_REVISA
            cCronog:=(cAlias)->CNA_CRONOG

            SZ0->(CNFToSZ0(3,@cCN9Filial,@cContra,@cRevisao,@cCronog))

            ChkMaxLock()

            (cAlias)->(dbSkip())

        End While

        (cAlias)->(dbCloseArea())
        
        //Verifica o Empenho de Acordo com a Planilha para Contratos sem Cronograma
        cQuery:="SELECT"+__cCRLF
        cQuery+="    CN9.CN9_NUMERO,"+__cCRLF
        cQuery+="    CN9.CN9_REVISA,"+__cCRLF
        cQuery+="    CNA.R_E_C_N_O_ AS CNARECNO"+__cCRLF
        cQuery+="FROM"+__cCRLF
        cQuery+="    CN9010 CN9,"+__cCRLF
        cQuery+="    CNA010 CNA,"+__cCRLF
        cQuery+="    CNB010 CNB "+__cCRLF
        cQuery+="WHERE"+__cCRLF
        cQuery+="    CN9.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNA.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNB.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CN9.CN9_FILIAL ='"+cCN9Filial+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNA.CNA_FILIAL ='"+cCNAFilial+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNB.CNB_FILIAL ='"+cCNBFilial+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CN9.CN9_DTINIC <='"+cYFDay+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CN9.CN9_DTFIM >='"+cYLDay+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CN9.CN9_SITUAC ='05'"+__cCRLF
        cQuery+="    AND    "+__cCRLF
        cQuery+="    CNA.CNA_CONTRA =CN9.CN9_NUMERO"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNB.CNB_CONTRA =CN9.CN9_NUMERO"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNA.CNA_REVISA =CN9.CN9_REVISA"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNB.CNB_REVISA =CN9.CN9_REVISA"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNA.CNA_CRONOG ='"+Space(GetSx3Cache("CNA_CRONOG","X3_TAMANHO"))+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNB.CNB_NUMERO =CNA.CNA_NUMERO"+__cCRLF
        cQuery+="GROUP BY"+__cCRLF
        cQuery+="    CN9.CN9_NUMERO,"+__cCRLF
        cQuery+="    CN9.CN9_REVISA,"+__cCRLF
        cQuery+="    CNA.R_E_C_N_O_"+__cCRLF

        TCQUERY (cQuery)ALIAS (cAlias)NEW

        aCNARecnos:={}
        
        While (cAlias)->(!Eof())
            (cAlias)->(aAdd(aCNARecnos,CNARECNO))
            (cAlias)->(dbSkip())
        End While

        (cAlias)->(dbCloseArea())

        nRecnos:=Len(aCNARecnos)

        IF (nRecnos >0)
            nCNBOrder:=RetOrder("CNB","CNB_FILIAL+CNB_CONTRA+CNB_REVISA+CNB_NUMERO+CNB_ITEM")
            CNA->(CNAToSZ0(@aCNARecnos,@nRecnos,@nCNBOrder,@cCNBFilial))
            ChkMaxLock()
        EndIF

        //Verifica os Links com a SD1
        DEFAULT lChkSD1SZ0:=.F.
        IF (lChkSD1SZ0)
            SD1SZ0Lnk()
        EndIF    

    END SEQUENCE

    ChkMaxLock()

    StaticCall(NDJLIB003,AliasUnLock)
    __nLocks:=0

    dbSelectArea("SZ0")

Return(NIL)

/*/
    Funcao:SD1SZ0Lnk()
    Data:23/08/2011
    Autor:Marinaldo de Jesus
    Descricao:Verificar e Atualizar os Links da Tabela SD1 com SZ0
    Sintace:StaticCall(U_NDJBLKSCVL,SD1SZ0Lnk)
/*/
Static Function SD1SZ0Lnk(lClearQuery)

    Local aArea:=GetArea()

    Local cYFDay:=Dtos(FirstYDate(dDataBase))
    Local cYLDay:=Dtos(LastYDate(dDataBase))

    Local cAlias:=GetNextAlias()

    Local cQuery

    Local cSD1Table:=RetSqlName("SD1")
    Local cSZ0Table:=RetSqlName("SZ0")

    Local cSC7Filial:=xFilial("SC7")
    Local cSD1Filial:=xFilial("SD1")
    Local cSZ0Filial:=xFilial("SZ0")

    Local nMinRecno:=0
    Local nMaxRecno:=0

    cQuery:="SELECT"+__cCRLF 
    cQuery+="    MIN(R_E_C_N_O_) MINRECNO,"+__cCRLF 
    cQuery+="    MAX(R_E_C_N_O_) MAXRECNO"+__cCRLF 
    cQuery+="FROM"+__cCRLF 
    cQuery+="    "+cSD1Table+" SD1 "+__cCRLF 
    cQuery+="WHERE"+__cCRLF 
    cQuery+="    SD1.D_E_L_E_T_ =' '"+__cCRLF 
    cQuery+="AND"+__cCRLF 
    cQuery+="    SD1.D1_FILIAL ='"+cSD1Filial+"'"+__cCRLF 
    cQuery+="AND"+__cCRLF 
    cQuery+="    SD1.D1_EMISSAO >='"+cYFDay+"'"+__cCRLF 
    cQuery+="AND"+__cCRLF 
    cQuery+="    SD1.D1_EMISSAO <='"+cYLDay+"'"+__cCRLF 

    TCQUERY (cQuery)ALIAS (cAlias)NEW

    TcSetField(cAlias,"MINRECNO","N",18,0)
    TcSetField(cAlias,"MAXRECNO","N",18,0)

    nMinRecno:=(cAlias)->MINRECNO
    nMaxRecno:=(cAlias)->MAXRECNO

    (cAlias)->(dbCloseArea())

    dbSelectArea("SD1")

    While (nMinRecno <=nMaxRecno)

        cQuery:="UPDATE"+__cCRLF 
        cQuery+="        "+cSD1Table+" "+__cCRLF 
        cQuery+="SET"+__cCRLF 
        cQuery+="        "+cSD1Table+".D1_Z0LINKD =("+__cCRLF 
        cQuery+="                                            CASE "+__cCRLF 
        cQuery+="                                            ("+__cCRLF 
        cQuery+="                                                SELECT"+__cCRLF 
        cQuery+="                                                1"+__cCRLF 
        cQuery+="                                                FROM"+__cCRLF 
        cQuery+="                                                "+cSZ0Table+" SZ0 "+__cCRLF 
        cQuery+="                                                WHERE"+__cCRLF 
        cQuery+="                                                    SZ0.R_E_C_N_O_ ="+cSZ0Table+".R_E_C_N_O_"+__cCRLF 
        cQuery+="                                      )"+__cCRLF 
        cQuery+="                                            WHEN"+__cCRLF 
        cQuery+="                                                1 "+__cCRLF 
        cQuery+="                                            THEN "+__cCRLF 
        cQuery+="                                                'T' "+__cCRLF 
        cQuery+="                                            ELSE"+__cCRLF 
        cQuery+="                                                'F' "+__cCRLF 
        cQuery+="                                            END"+__cCRLF 
        cQuery+="                                  )"+__cCRLF 
        cQuery+="FROM"+__cCRLF 
        cQuery+="        "+cSZ0Table+" "+cSZ0Table+__cCRLF 
        cQuery+="WHERE"+__cCRLF 
        cQuery+="("+__cCRLF 
        cQuery+="        ("+__cCRLF 
        cQuery+="            "+cSD1Table+".R_E_C_N_O_ >="+Str(nMinRecno,18,0)+__cCRLF
        cQuery+="        AND"+__cCRLF 
        cQuery+="            "+cSD1Table+".R_E_C_N_O_ <="+Str (nMinRecno+=1024,18,0)+__cCRLF
        cQuery+="        AND"+__cCRLF 
        cQuery+="            "+cSD1Table+".D_E_L_E_T_ =' '"+__cCRLF 
        cQuery+="        AND"+__cCRLF 
        cQuery+="            "+cSD1Table+".D1_FILIAL ='"+cSD1Filial+"'"+__cCRLF
        cQuery+="        AND"+__cCRLF 
        cQuery+="            "+cSD1Table+".D1_EMISSAO >='"+cYFDay+"'"+__cCRLF
        cQuery+="        AND"+__cCRLF 
        cQuery+="            "+cSD1Table+".D1_EMISSAO <='"+cYLDay+"'"+__cCRLF 
        cQuery+="  )"+__cCRLF 
        cQuery+="        AND"+__cCRLF 
        cQuery+="        ("+__cCRLF 
        cQuery+="            "+cSZ0Table+".D_E_L_E_T_ =' '"+__cCRLF 
        cQuery+="        AND"+__cCRLF 
        cQuery+="            "+cSZ0Table+".Z0_FILIAL ='"+cSZ0Filial+"'"+__cCRLF 
        cQuery+="        AND"+__cCRLF 
        cQuery+="            "+cSZ0Table+".Z0_ALIAS ='SC7'"+__cCRLF 
        cQuery+="        AND"+__cCRLF 
        cQuery+="            "+cSZ0Table+".Z0_XFILIAL ='"+cSC7Filial+"'"+__cCRLF 
        cQuery+="        AND"+__cCRLF 
        cQuery+="            "+cSZ0Table+".Z0_PROJETO ="+cSD1Table+".D1_XPROJET"+__cCRLF 
        cQuery+="        AND"+__cCRLF 
        cQuery+="            "+cSZ0Table+".Z0_REVISAO ="+cSD1Table+".D1_XREVIS"+__cCRLF 
        cQuery+="        AND"+__cCRLF 
        cQuery+="            "+cSZ0Table+".Z0_TAREFA ="+cSD1Table+".D1_XTAREFA"+__cCRLF 
        cQuery+="        AND"+__cCRLF 
        cQuery+="            "+cSZ0Table+".Z0_NUM ="+cSD1Table+".D1_XNUMSC"+__cCRLF 
        cQuery+="        AND"+__cCRLF 
        cQuery+="            "+cSZ0Table+".Z0_ITEM ="+cSD1Table+".D1_XITEMSC"+__cCRLF 
        cQuery+="        AND"+__cCRLF 
        cQuery+="            "+cSZ0Table+".Z0_SEQUEN ="+cSD1Table+".D1_XSEQUEN"+__cCRLF 
        cQuery+="        AND"+__cCRLF 
        cQuery+="            "+cSZ0Table+".Z0_ITEMGRD ="+cSD1Table+".D1_ITEMGRD"+__cCRLF 
        cQuery+="        AND"+__cCRLF 
        cQuery+="            "+cSZ0Table+".Z0_ORCAME ="+cSD1Table+".D1_CODORCA"+__cCRLF 
        cQuery+="        AND"+__cCRLF 
        cQuery+="            "+cSZ0Table+".Z0_XCODOR ="+cSD1Table+".D1_XCODOR"+__cCRLF 
        cQuery+="        AND"+__cCRLF 
        cQuery+="            "+cSZ0Table+".Z0_XCODSBM ="+cSD1Table+".D1_XCODSBM"+__cCRLF 
        cQuery+="        AND"+__cCRLF 
        cQuery+="            "+cSZ0Table+".Z0_LINKED ='T'"+__cCRLF 
        cQuery+="  )"+__cCRLF 
        cQuery+=")"+__cCRLF

        DEFAULT lClearQuery:=.F.
        IF (lClearQuery)
            cQuery:=StaticCall(NDJLIB001,ClearQuery,cQuery)
        EndIF    

        TcSqlExec(cQuery)

        SD1->(dbGoTop())

    End While

    RestArea(aArea)

Return(NIL)

/*/
    Funcao: PutToFrom
    Autor:Marinaldo de Jesus
    Data:17/08/2011
    Descricao:Prepara os Dados para a NDJFromTo
/*/
Static Function PutToFrom(aFromTo,cTo,cFrom)
    aAdd(aFromTo,{ cFrom,cTo })
Return(NIL)

/*/
    Funcao: AliasSZ0Lnk()
    Autor:Marinaldo de Jesus
    Data:27/11/2010
    Descricao:Verificar o Link entre os Registros das Tabelas SC1/SC7 e SZ0
    Sintaxe:StaticCall(U_NDJBLKSCVL,AliasSZ0Lnk,cAlias,lDelete)
/*/
Static Function AliasSZ0Lnk(cAlias,lDelete)

    Local aArea:=GetArea()
    Local aAreaSC1:=SC1->(GetArea())
    Local aAreaSC7:=SC7->(GetArea())
    Local aAreaSZ0:=SZ0->(GetArea())

    Local dYFDay
    Local dYLDay

    Local lFound
    Local lLinked:=.F.
    Local lSZ0Lock
    Local lAliasLock
    Local lSetDeleted

    Local cSC1Filial
    Local cSC7Filial
    Local cSZ0Filial:=xFilial("SZ0")
    Local cSZ0KeySeek:=cSZ0Filial
    
    Local cSZ0NewAlias
    
    Local nRecno
    Local nSZ0Order

    DEFAULT lDelete:=.F.
    IF (lDelete)
        lSetDeleted:=Set(_SET_DELETED,.F.)
    EndIF    

    BEGIN SEQUENCE

        nSZ0Order:=RetOrder("SZ0","Z0_FILIAL+Z0_ALIAS+Z0_XFILIAL+Z0_PROJETO+Z0_REVISAO+Z0_TAREFA+Z0_NUM+Z0_ITEM+Z0_ITEMGRD+Z0_ORCAME+Z0_XCODOR+Z0_XCODSBM+Z0_SEQUEN")
        SZ0->(dbSetOrder(nSZ0Order))

        DO CASE
        CASE (cAlias =="SC1")
            cSC1Filial:=xFilial("SC1")   
            cSZ0KeySeek:=cSZ0Filial                                                //Z0_FILIAL
            cSZ0KeySeek+="SC1"                                                    //Z0_ALIAS
            cSZ0KeySeek+=cSC1Filial                                                //Z0_XFILIAL
            cSZ0KeySeek+=SC1->C1_XPROJET                                            //Z0_PROJETO
            cSZ0KeySeek+=SC1->C1_XREVISA                                             //Z0_REVISAO
            cSZ0KeySeek+=SC1->C1_XTAREFA                                            //Z0_TAREFA
            cSZ0KeySeek+=SC1->C1_NUM                                                //Z0_NUM
            cSZ0KeySeek+=SC1->C1_ITEM                                                //Z0_ITEM
            cSZ0KeySeek+=SC1->C1_ITEMGRD                                            //Z0_ITEMGRD
            cSZ0KeySeek+=SC1->C1_CODORCA                                            //Z0_ORCAME
            cSZ0KeySeek+=SC1->C1_XCODOR                                            //Z0_XCODOR
            cSZ0KeySeek+=SC1->C1_XCODSBM                                            //Z0_XCODSBM
            cSZ0KeySeek+=Space(GetSx3Cache("Z0_SEQUEN","X3_TAMANHO"))        //Z0_SEQUEN
        CASE (cAlias =="SC7")
            cSC7Filial:=xFilial("SC7")   
            cSZ0KeySeek:=cSZ0Filial                                                //Z0_FILIAL
            cSZ0KeySeek+="SC7"                                                    //Z0_ALIAS
            cSZ0KeySeek+=cSC7Filial                                                //Z0_XFILIAL
            cSZ0KeySeek+=SC7->C7_XPROJET                                            //Z0_PROJETO
            cSZ0KeySeek+=SC7->C7_XREVIS                                             //Z0_REVISAO
            cSZ0KeySeek+=SC7->C7_XTAREFA                                            //Z0_TAREFA
            cSZ0KeySeek+=SC7->C7_NUMSC                                            //Z0_NUM
            cSZ0KeySeek+=SC7->C7_ITEMSC                                            //Z0_ITEM
            cSZ0KeySeek+=SC7->C7_ITEMGRD                                            //Z0_ITEMGRD
            cSZ0KeySeek+=SC7->C7_CODORCA                                            //Z0_ORCAME
            cSZ0KeySeek+=SC7->C7_XCODOR                                            //Z0_XCODOR
            cSZ0KeySeek+=SC7->C7_XCODSBM                                             //Z0_XCODSBM
            cSZ0KeySeek+=SC7->C7_SEQUEN                                            //Z0_SEQUEN
        OTHERWISE
            BREAK
        END CASE

        lFound:=SZ0->(dbSeek(cSZ0KeySeek,.F.))
        IF !(lFound)
            BREAK
        EndIF

        dYFDay:=FirstYDate(dDataBase)
        dYLDay:=LastYDate(dDataBase)

        nRecno:=SZ0->(Recno())

        lSZ0Lock:=SZ0->(lUseKeySZ0(@cAlias,@nRecno,.F.))
        lSZ0Lock:=StaticCall(NDJLIB003,LockSoft,"SZ0")
        lSZ0Lock:=(lSZ0Lock .and. SZ0->(RecLock("SZ0",.F.)))
        lAliasLock:=StaticCall(NDJLIB003,LockSoft,cAlias)
        lAliasLock:=(lAliasLock .and. (cAlias)->(RecLock(cAlias,.F.)))

        IF !(lSZ0Lock)
            BREAK
        EndIF

        IF (lDelete)
            SZ0->Z0_LINKED:=lLinked
            SZ0->(dbDelete())
            IF (lAliasLock)
                IF (cAlias =="SC1")
                    SC1->C1_Z0LINKD:=lLinked
                ElseIF (cAlias =="SC7")
                    SC7->C7_Z0LINKD:=lLinked
                EndIF
            EndIF
        Else
            IF (cAlias =="SC1")
                lLinked:=SC1->((C1_DATPRF >=dYFDay).and. (C1_DATPRF <=dYLDay))
                IF (lLinked)
                    cSZ0NewAlias:=GetNextAlias()
                    IF (ChkFile("SZ0",.F.,cSZ0NewAlias))
                        (cSZ0NewAlias)->(dbSetOrder(nSZ0Order))
                        DEFAULT cSC7Filial:=xFilial("SC7")   
                        cSZ0KeySeek:=cSZ0Filial                                                //Z0_FILIAL
                        cSZ0KeySeek+="SC7"                                                    //Z0_ALIAS
                        cSZ0KeySeek+=cSC7Filial                                                //Z0_XFILIAL
                        cSZ0KeySeek+=SC1->C1_XPROJET                                            //Z0_PROJETO
                        cSZ0KeySeek+=SC1->C1_XREVISA                                             //Z0_REVISAO
                        cSZ0KeySeek+=SC1->C1_XTAREFA                                            //Z0_TAREFA
                        cSZ0KeySeek+=SC1->C1_NUM                                                //Z0_NUM
                        cSZ0KeySeek+=SC1->C1_ITEM                                                //Z0_ITEM
                        cSZ0KeySeek+=SC1->C1_ITEMGRD                                            //Z0_ITEMGRD
                        cSZ0KeySeek+=SC1->C1_CODORCA                                            //Z0_ORCAME
                        cSZ0KeySeek+=SC1->C1_XCODOR                                            //Z0_XCODOR
                        cSZ0KeySeek+=SC1->C1_XCODSBM                                            //Z0_XCODSBM
                        lLinked:=(cSZ0NewAlias)->(!dbSeek(cSZ0KeySeek,.F.))
                        (cSZ0NewAlias)->(dbCloseArea())
                        dbSelectArea("SZ0")
                    EndIF
                EndIF
            ElseIF (cAlias =="SC7")
                lLinked:=SC7->((C7_DATPRF >=dYFDay).and. (C7_DATPRF <=dYLDay))
                IF (lLinked)
                    cSZ0NewAlias:=GetNextAlias()
                    IF (ChkFile("SZ0",.F.,cSZ0NewAlias))
                        (cSZ0NewAlias)->(dbSetOrder(nSZ0Order))
                        DEFAULT cSC1Filial:=xFilial("SC1")   
                        cSZ0KeySeek:=cSZ0Filial                                                //Z0_FILIAL
                        cSZ0KeySeek+="SC1"                                                    //Z0_ALIAS
                        cSZ0KeySeek+=cSC1Filial                                                //Z0_XFILIAL
                        cSZ0KeySeek+=SC7->C7_XPROJET                                            //Z0_PROJETO
                        cSZ0KeySeek+=SC7->C7_XREVIS                                             //Z0_REVISAO
                        cSZ0KeySeek+=SC7->C7_XTAREFA                                            //Z0_TAREFA
                        cSZ0KeySeek+=SC7->C7_NUMSC                                            //Z0_NUM
                        cSZ0KeySeek+=SC7->C7_ITEMSC                                            //Z0_ITEM
                        cSZ0KeySeek+=SC7->C7_ITEMGRD                                            //Z0_ITEMGRD
                        cSZ0KeySeek+=SC7->C7_CODORCA                                            //Z0_ORCAME
                        cSZ0KeySeek+=SC7->C7_XCODOR                                            //Z0_XCODOR
                        cSZ0KeySeek+=SC7->C7_XCODSBM                                             //Z0_XCODSBM
                        IF (cSZ0NewAlias)->(dbSeek(cSZ0KeySeek,.F.))
                            lSZ0Lock:=(cSZ0NewAlias)->(lUseKeySZ0("SC1",Recno(),.F.))
                            lSZ0Lock:=StaticCall(NDJLIB003,LockSoft,"SZ0")
                            lSZ0Lock:=(lSZ0Lock .and. (cSZ0NewAlias)->(RecLock(cSZ0NewAlias,.F.)))
                            IF (lSZ0Lock)
                                (cSZ0NewAlias)->Z0_LINKED:=.F.
                                (cSZ0NewAlias)->(MsUnLock())
                            EndIF
                        EndIF
                        (cSZ0NewAlias)->(dbCloseArea())
                        dbSelectArea("SZ0")
                    EndIF
                EndIF
            EndIF    
            SZ0->Z0_LINKED:=lLinked
            IF (lAliasLock)
                IF (cAlias =="SC1")
                    SC1->C1_Z0LINKD:=lLinked
                ElseIF (cAlias =="SC7")
                    SC7->C7_Z0LINKD:=lLinked
                EndIF
            EndIF
        EndIF

        IF (lAliasLock)
            (cAlias)->(MsUnLock())
        EndIF

        SZ0->(MsUnLock())

        SZ0->(lUseKeySZ0(@cAlias,@nRecno,.T.))

    END SEQUENCE

    IF (lDelete)
        Set(_SET_DELETED,lSetDeleted)
    EndIF    

    RestArea(aAreaSC1)
    RestArea(aAreaSC7)
    RestArea(aAreaSZ0)
    RestArea(aArea)

Return(NIL)

/*/
    Funcao:NDJOrcSaldo
    Autor:Marinaldo de Jesus
    Data:09/11/2010
    Descricao:Retornar o Saldo do Orcamento de Acordo com Parametros
/*/
Static Function NDJOrcSaldo(cFil,cOrcamento,cOrigemRec,cCodSBM,nTpRet)

    Local nSaldo:=0

    DEFAULT cFil:=cFilAnt

    BEGIN SEQUENCE

        IF (;
                Empty(cOrcamento);
                .or.;
                Empty(cOrigemRec);
  )
            BREAK    
        EndIF

        DEFAULT nTpRet:=NDJ_BLK_GET_SALDO

        DO CASE
            CASE (nTpRet ==NDJ_BLK_GET_SALDO)
                nSaldo:=NDJSCGetVal(@cFil,@cOrcamento,@cOrigemRec,@cCodSBM)
                nSaldo    -=NDJSCGetRes(@cFil,@cOrcamento,@cOrigemRec,@cCodSBM)
                nSaldo    -=NDJPDGetRes(@cFil,@cOrcamento,@cOrigemRec,@cCodSBM)
                BREAK
            CASE (nTpRet ==NDJ_BLK_GET_ORCAMENTO)
                nSaldo:=NDJSCGetVal(@cFil,@cOrcamento,@cOrigemRec,@cCodSBM)
                BREAK
            CASE (nTpRet ==NDJ_BLK_GET_EMPENHADO)
                nSaldo:=NDJSCGetRes(@cFil,@cOrcamento,@cOrigemRec,@cCodSBM)
                BREAK
        END CASE    

    END SEQUENCE

Return(nSaldo)

/*/
    Funcao:NDJSCGetVal
    Autor:Marinaldo de Jesus
    Data:09/11/2010
    Descricao:Retornar a Soma dos Valores de Acordo com o Orcamento
/*/
Static Function NDJSCGetVal(cFil,cOrcamento,cOrigemRec,cCodSBM)

    Local aArea:=GetArea()

    Local cQuery
    Local cAlias:=GetNextAlias()

    Local cAFBFilial
    Local cAF4Filial
    Local cSBMFilial
    
    Local lEmpenho

    Local nValor:=0
    
    BEGIN SEQUENCE

        DEFAULT cFil:=cFilAnt
        DEFAULT cOrcamento:=Space(GetSx3Cache("AFB_XORCAM","X3_TAMANHO"))
        DEFAULT cOrigemRec:=Space(GetSx3Cache("AFB_XCODOR","X3_TAMANHO"))
        DEFAULT cCodSBM:=Space(GetSx3Cache("AFB_TIPOD","X3_TAMANHO"))
        cAFBFilial:=xFilial("AFB",cFil)
        cAF4Filial:=xFilial("AF4",cFil)
        cSBMFilial:=xFilial("SBM",cFil)

        cQuery:="SELECT "+__cCRLF
        cQuery+="    SUM(AF4_VALOR) AF4_VALOR "+__cCRLF
        cQuery+="FROM "+__cCRLF
        cQuery+="    "+RetSqlName("AFB")+" AFB,"+__cCRLF
        cQuery+="    "+RetSqlName("AF4")+" AF4,"+__cCRLF
        cQuery+="    "+RetSqlName("SBM")+" SBM "+__cCRLF
        cQuery+="WHERE "+__cCRLF
        cQuery+="    AFB.D_E_L_E_T_<>'*' "+__cCRLF
        cQuery+="AND "+__cCRLF
        cQuery+="    AF4.D_E_L_E_T_<>'*' "+__cCRLF
        cQuery+="AND "+__cCRLF
        cQuery+="    SBM.D_E_L_E_T_<>'*' "+__cCRLF
        cQuery+="AND "+__cCRLF
        cQuery+="    AFB.AFB_FILIAL='"+cAFBFilial+"' "+__cCRLF
        cQuery+="AND "+__cCRLF
        cQuery+="    AF4.AF4_FILIAL='"+cAF4Filial+"' "+__cCRLF
        cQuery+="AND "+__cCRLF
        cQuery+="    SBM.BM_FILIAL='"+cSBMFilial+"' "+__cCRLF
        cQuery+="AND "+__cCRLF
        cQuery+="    AFB.AFB_XORCAM='"+cOrcamento+"' "+__cCRLF
        cQuery+="AND "+__cCRLF
        cQuery+="    AFB.AFB_XCODOR='"+cOrigemRec+"' "+__cCRLF
        cQuery+="AND "+__cCRLF
        cQuery+="    AF4.AF4_ORCAME=AFB.AFB_XORCAM "+__cCRLF
        cQuery+="AND "+__cCRLF
        cQuery+="    AF4.AF4_XCODOR=AFB.AFB_XCODOR "+__cCRLF
        cQuery+="AND "+__cCRLF
        cQuery+="    AFB.AFB_TIPOD=SBM.BM_GRUPO "+__cCRLF
        lEmpenho:=PosAlias("SBM",@cCodSBM,cSBMFilial,"BM_XEMPVAL",RetOrder("SBM","BM_FILIAL+BM_GRUPO"),.F.)
        IF (lEmpenho)
            cQuery+="AND "+__cCRLF
            cQuery+="    AFB.AFB_TIPOD='"+cCodSBM+"' "+__cCRLF
            cQuery+="AND "+__cCRLF
            cQuery+="    SBM.BM_XEMPVAL='T' "+__cCRLF
        Else
            cQuery+="AND "+__cCRLF
            cQuery+="    SBM.BM_XEMPVAL='F' "+__cCRLF
        EndIF

        TCQUERY (cQuery)ALIAS (cAlias)NEW
    
        IF (cAlias)->(!Eof() .and. !Bof())
            nValor:=(cAlias)->(AF4_VALOR)
        EndIF
    
        (cAlias)->(dbCloseArea())
        
    END SEQUENCE

    RestArea(@aArea)
    
Return(nValor)

/*/
    Funcao:NDJSCGetRes
    Autor:Marinaldo de Jesus
    Data:09/11/2010
    Descricao:Retornar a Soma dos Valores Reservados
/*/
Static Function NDJSCGetRes(cFil,cOrcamento,cOrigemRec,cCodSBM)
    Local cAlias:="SC1"
Return(NDJGetRes(@cFil,@cAlias,@cOrcamento,@cOrigemRec,@cCodSBM))

/*/
    Funcao:NDJPDGetRes
    Autor:Marinaldo de Jesus
    Data:09/11/2010
    Descricao:Retornar a Soma dos Valores Reservados
/*/
Static Function NDJPDGetRes(cFil,cOrcamento,cOrigemRec,cCodSBM)
    Local cAlias:="SC7"
Return(NDJGetRes(@cFil,@cAlias,@cOrcamento,@cOrigemRec,@cCodSBM))

Static Function NDJGetRes(cFil,cZ0Alias,cOrcamento,cOrigemRec,cCodSBM)

    Local aArea:=GetArea()
    
    Local cQuery
    Local cAlias:=GetNextAlias()

    Local cxFilial
    Local cSZ0Filial
    
    Local lEmpenho

    Local nValor:=0

    BEGIN SEQUENCE

        DEFAULT cFil:=cFilAnt
        DEFAULT cOrcamento:=Space(GetSx3Cache("Z0_ORCAME","X3_TAMANHO"))
        DEFAULT cOrigemRec:=Space(GetSx3Cache("Z0_XCODOR","X3_TAMANHO"))
        DEFAULT cCodSBM:=Space(GetSx3Cache("Z0_XCODSBM","X3_TAMANHO"))
        cxFilial:=xFilial(cZ0Alias,cFil)
        cSZ0Filial:=xFilial("SZ0",cFil)
        cSBMFilial:=xFilial("SBM",cFil)

        cQuery:="SELECT "+__cCRLF
        cQuery+="    SUM(SZ0.Z0_VALOR) Z0_VALOR "+__cCRLF
        cQuery+="FROM "+__cCRLF
        cQuery+="    "+RetSqlName("SZ0")+" SZ0 "+__cCRLF
        cQuery+="WHERE "+__cCRLF
        cQuery+="    SZ0.D_E_L_E_T_<>'*' "+__cCRLF
        cQuery+="AND "+__cCRLF
        cQuery+="    SZ0.Z0_FILIAL='"+cSZ0Filial+"' "+__cCRLF
        cQuery+="AND "+__cCRLF
        cQuery+="    SZ0.Z0_XFILIAL='"+cxFilial+"' "+__cCRLF
        cQuery+="AND "+__cCRLF
        cQuery+="    SZ0.Z0_ALIAS='"+cZ0Alias+"' "+__cCRLF
        cQuery+="AND "+__cCRLF
        cQuery+="    SZ0.Z0_ORCAME='"+cOrcamento+"' "+__cCRLF
        cQuery+="AND "+__cCRLF
        cQuery+="    SZ0.Z0_XCODOR='"+cOrigemRec+"' "+__cCRLF
        lEmpenho:=PosAlias("SBM",@cCodSBM,cSBMFilial,"BM_XEMPVAL",RetOrder("SBM","BM_FILIAL+BM_GRUPO"),.F.)
        IF (lEmpenho)
            cQuery+="AND "+__cCRLF
            cQuery+="    SZ0.Z0_XCODSBM='"+cCodSBM+"' "+__cCRLF
            cQuery+="AND "+__cCRLF
            cQuery+="    SZ0.Z0_EMPENHO='T' "+__cCRLF
        Else
            cQuery+="AND "+__cCRLF
            cQuery+="    SZ0.Z0_EMPENHO='F' "+__cCRLF    
        EndIF
        cQuery+="AND "+__cCRLF
        cQuery+="    SZ0.Z0_LINKED='T' "+__cCRLF

        TCQUERY (cQuery)ALIAS (cAlias)NEW

        IF (cAlias)->(!Eof() .and. !Bof())
            nValor:=(cAlias)->(Z0_VALOR)
        EndIF
    
        (cAlias)->(dbCloseArea())

    END SEQUENCE
            
    RestArea(@aArea)

Return(nValor)

/*/
    Funcao:PutSZ0Val
    Autor:Marinaldo de Jesus
    Data:27/11/2010
    Descricao:Gravar ou Excluir informacoes na Tabela SZ0
/*/
Static Function PutSZ0Val(cFil,cProjeto,cRevisao,cTarefa,cOrcamento,cOrigemRec,cAlias,cAliasFil,cNumSC,cItemSC,cSeq,cItemGrd,cCodSBM,nValor,lDelete,lGetLastVal)

    Local aArea:=GetArea()
    Local aAreaSZ0:=SZ0->(GetArea())
    
    Local cAliasTTS
    Local cSZ0Filial
    Local cSZ0KeySeek

    Local lLock
    Local lFound:=.F.
    Local lAddNew

    Local nRecno
    Local nTTS
    Local nSZ0Valor
    Local nSZ0Order

    DEFAULT cFil:=cFilAnt
    DEFAULT cProjeto:=Space(GetSx3Cache("Z0_PROJETO","X3_TAMANHO"))
    DEFAULT cRevisao:=Space(GetSx3Cache("Z0_REVISA","X3_TAMANHO"))
    DEFAULT cTarefa:=Space(GetSx3Cache("Z0_TAREFA","X3_TAMANHO"))
    DEFAULT cOrcamento:=Space(GetSx3Cache("Z0_ORCAME","X3_TAMANHO"))
    DEFAULT cOrigemRec:=Space(GetSx3Cache("Z0_XCODOR","X3_TAMANHO"))
    DEFAULT cAlias:=Space(GetSx3Cache("Z0_ALIAS","X3_TAMANHO"))
    DEFAULT cAliasFil:=Space(GetSx3Cache("Z0_XFILIAL","X3_TAMANHO"))
    DEFAULT cNumSC:=Space(GetSx3Cache("Z0_NUM","X3_TAMANHO"))
    DEFAULT cItemSC:=Space(GetSx3Cache("Z0_ITEM","X3_TAMANHO"))
    DEFAULT cSeq:=Space(GetSx3Cache("Z0_SEQUEN","X3_TAMANHO"))
    DEFAULT cItemGrd:=Space(GetSx3Cache("Z0_ITEMGRD","X3_TAMANHO"))
    DEFAULT cCodSBM:=Space(GetSx3Cache("Z0_XCODSBM","X3_TAMANHO"))
    DEFAULT nValor:=0
    DEFAULT lDelete:=.F.
    DEFAULT lGetLastVal:=.F.

    BEGIN SEQUENCE

        cSZ0Filial:=xFilial("SZ0",cFil)

        nRecno:=StaticCall(NDJLIB001,GetMemVar,"__nSZ0Recno")
        nSZ0Valor:=nValor

        IF (;
                (ValType(nRecno)=="N");
                .and.;
                (nRecno >0);
       )

            SZ0->(MsGoto(@nRecno))

            lFound:=SZ0->(!Eof() .and. !Bof())

        EndIF

        IF !(lFound)

            cSZ0KeySeek:=cSZ0Filial    //Z0_FILIAL
            cSZ0KeySeek+=cAlias        //Z0_ALIAS
            cSZ0KeySeek+=cAliasFil    //Z0_XFILIAL
            cSZ0KeySeek+=cProjeto        //Z0_PROJETO
            cSZ0KeySeek+=cRevisao        //Z0_REVISAO
            cSZ0KeySeek+=cTarefa        //Z0_TAREFA
            cSZ0KeySeek+=cNumSC        //Z0_NUM
            cSZ0KeySeek+=cItemSC        //Z0_ITEM
            cSZ0KeySeek+=cItemGrd        //Z0_ITEMGRD
            cSZ0KeySeek+=cOrcamento    //Z0_ORCAME
            cSZ0KeySeek+=cOrigemRec    //Z0_XCODOR
            cSZ0KeySeek+=cCodSBM        //Z0_XCODSBM
            cSZ0KeySeek+=cSeq            //Z0_SEQUEN

            nSZ0Order:=RetOrder("SZ0","Z0_FILIAL+Z0_ALIAS+Z0_XFILIAL+Z0_PROJETO+Z0_REVISAO+Z0_TAREFA+Z0_NUM+Z0_ITEM+Z0_ITEMGRD+Z0_ORCAME+Z0_XCODOR+Z0_XCODSBM+Z0_SEQUEN")
    
            SZ0->(dbSetOrder(nSZ0Order))
            lFound:=SZ0->(MsSeek(cSZ0KeySeek,.F.))

        EndIF
            
        IF (;
                !(lFound);
                .and.;
                (;
                    (lDelete);
                    .or.;
                    (lGetLastVal);
           );    
  )
            IF (lGetLastVal)
                nSZ0Valor:=0
            EndIF
            BREAK
        EndIF

        lAddNew:=!(lFound)
        lLock:=SZ0->(RecLock("SZ0",lAddNew))

        IF !(lLock)
            BREAK
        EndIF

        nRecno:=SZ0->(Recno())

        nTTS:=aScan(__aSZ0TTS,{ |aTTS| (aTTS[ 1 ] ==nRecno)})
        IF (nTTS ==0)
            cAliasTTS:=StaticCall(NDJLIB001,GetMemVar,"__cSZ0TTSAlias")
            aAdd(__aSZ0TTS,{ nRecno,cAliasTTS,nSZ0Valor })
++__nSZ0TTS
            nTTS:=__nSZ0TTS
        EndIF

        SZ0->(lUseKeySZ0(@cAlias,@nRecno,.F.))

        BEGIN SEQUENCE

            IF (;
                    (lFound);
                    .and.;
                    (lDelete);
          )
                SZ0->(dbDelete())   
                SZ0->(lUseKeySZ0(@cAlias,@nRecno,.T.))
                BREAK
            EndIF

            IF (lFound)
                IF (lGetLastVal)
                    nSZ0Valor:=SZ0->Z0_VALOR
                Else
                    IF !(nSZ0Valor ==SZ0->Z0_VALOR)
                        SZ0->Z0_VALOR:=nSZ0Valor
                        SZ0->Z0_TTS:=.F.
                        __aSZ0TTS[ nTTS ][ 3 ]:=nSZ0Valor
                    EndIF
                EndIF    
                BREAK
            EndIF

            SZ0->Z0_FILIAL:=cSZ0Filial
            SZ0->Z0_PROJETO:=cProjeto
            SZ0->Z0_REVISAO:=cRevisao
            SZ0->Z0_TAREFA:=cTarefa
            SZ0->Z0_ORCAME:=cOrcamento
            SZ0->Z0_XCODOR:=cOrigemRec
            SZ0->Z0_ALIAS:=cAlias
            SZ0->Z0_XFILIAL:=cAliasFil
            SZ0->Z0_NUM:=cNumSC
            SZ0->Z0_ITEM:=cItemSC
            SZ0->Z0_SEQUEN:=cSeq
            SZ0->Z0_ITEMGRD:=cItemGrd
            SZ0->Z0_XCODSBM:=cCodSBM
            SZ0->Z0_VALOR:=nSZ0Valor
            SZ0->Z0_LASTVAL:=nSZ0Valor
            SZ0->Z0_EMPENHO:=PosAlias("SBM",@cCodSBM,xFilial("SBM"),"BM_XEMPVAL",RetOrder("SBM","BM_FILIAL+BM_GRUPO"),.F.)
            SZ0->Z0_LINKED:=.T.
            SZ0->Z0_TTS:=.F.

        END SEQUENCE

        SZ0->(MsUnLock())

        StaticCall(NDJLIB003,LockSoft,"SZ0")

        SZ0ChkLink(.T.)

    END SEQUENCE

    RestArea(aAreaSZ0)
    RestArea(aArea)

Return(nSZ0Valor)

/*/
    Funcao:SZ0TTSCommit
    Autor:Marinaldo de Jesus
    Data:27/11/2010
    Descricao:Efetiva o Commit da SZ0
    Sintaxe:StaticCall(U_NDJBLKSCVL,SZ0TTSCommit)
/*/
Static Function SZ0TTSCommit()

    Local cAlias
    Local cXFilial
    Local cKeySeek
    Local cIndexKey
    Local cFieldTot
    Local cFieldLnk

    Local nValor
    Local nATLnk
    Local nRecno
    Local nOrder

    Local nSZ0Valor
    Local nSZ0LastVal

    While (__nSZ0TTS >0)
        nRecno:=__aSZ0TTS[ __nSZ0TTS ][ 1 ]
        cAlias:=__aSZ0TTS[ __nSZ0TTS ][ 2 ]
        nATLnk:=aScan(__aSZ0LNK,{ |aLnk| aLnk[ 1 ] ==cAlias })
        SZ0->(dbGoto(nRecno))
        IF (;
                SZ0->(!Eof() .and. !Bof());
                .and.;
                (nATLnk >0);
      )
            cXFilial:=xFilial(cAlias)
            cKeySeek:=cXFilial
            cKeySeek+=SZ0->(&(__aSZ0LNK[ nATLnk ][ 2 ]))
            cIndexKey:=__aSZ0LNK[ nATLnk ][ 3 ]
            cFieldTot:=__aSZ0LNK[ nATLnk ][ 4 ]
            cFieldLnk:=__aSZ0LNK[ nATLnk ][ 5 ]
            While !(;
                        lUseKeySZ0(@cAlias,@nRecno,.F.);
                        .and.;
                        StaticCall(NDJLIB003,LockSoft,"SZ0");
              )
                Sleep(100)
            End While
            nOrder:=RetOrder(cAlias,cIndexKey)
            (cAlias)->(dbSetOrder(nOrder))
            IF (cAlias)->(dbSeek(cKeySeek,.F.))
                nValor:=StaticCall(NDJLIB001,__FieldGet,cAlias,cFieldTot,.T.)
                nSZ0Valor:=SZ0->Z0_VALOR
                nSZ0LastVal:=SZ0->Z0_LASTVAL
                IF !(__aSZ0TTS[ __nSZ0TTS ][ 3 ] ==nSZ0Valor)
                    __aSZ0TTS[ __nSZ0TTS ][ 3 ]:=nSZ0Valor
                EndIF
                IF !(nValor ==__aSZ0TTS[ __nSZ0TTS ][ 3 ])
                    StaticCall(NDJLIB001,__FieldPut,"SZ0","Z0_VALOR",nValor,.T.)
                EndIF
                IF !(nSZ0LastVal ==nValor)
                    StaticCall(NDJLIB001,__FieldPut,"SZ0","Z0_LASTVAL",nValor,.T.)
                EndIF
                StaticCall(NDJLIB001,__FieldPut,cAlias,cFieldLnk,.T.,.T.)
            Else
                StaticCall(NDJLIB001,__FieldPut,"SZ0","Z0_LINKED",.F.,.T.)
                IF SZ0->(RecLock("SZ0",.F.))
                    SZ0->(dbDelete())
                    SZ0->(MsUnLock())
                EndIF
            EndIF
            StaticCall(NDJLIB001,__FieldPut,"SZ0","Z0_TTS",.T.,.T.)
            lUseKeySZ0(@cAlias,@nRecno,.T.)
        EndIF
        aDel(__aSZ0TTS,__nSZ0TTS)
        aSize(__aSZ0TTS,--__nSZ0TTS)
    End While

Return(NIL)

/*/
    Function:SZ0ChkLink()
    Autor:Marinaldo de Jesus
    Data:24/01/2011
    Descricao:Verificar os Links de Orcamento na SZ0
    Sintaxe:StaticCall(U_NDJBLKSCVL,SZ0ChkLink,lCheck)
/*/
Static Function SZ0ChkLink(lCheck)

    Local lSZ0ChkLnk
    
    Static lStkSZ0Lnk

    DEFAULT lCheck:=.F.
    DEFAULT lStkSZ0Lnk:=.F.

    lSZ0ChkLnk:=lStkSZ0Lnk
    lStkSZ0Lnk:=lCheck

Return(lSZ0ChkLnk)

/*/
    Funcao:lUseKeySZ0
    Autor:Marinaldo de Jesus
    Data:27/11/2010
    Descricao:Obter/Liberar a Reserva dos Links do SC1 com a SZ0
    Sintaxe:StaticCall(U_NDJBLKSCVL,lUseKeySZ0,cAlias,nRecno,lFreeMyIUse)
/*/
Static Function lUseKeySZ0(cAlias,nRecno,lFreeMyIUse)

    Local cMyIUse:=""
    Local lMyIUse:=.T.

    BEGIN SEQUENCE

        DEFAULT cAlias:=Alias()
        DEFAULT nRecno:=(Alias)->(Recno())

        cMyIUse:=(cEmpAnt+cAlias+"_SZ0"+(AllTrim(StrZero(nRecno))))

        DEFAULT lFreeMyIUse:=.F.
        IF (lFreeMyIUse)
            StaticCall(NDJLIB003,ReleaseCode,cMyIUse)
            BREAK
        EndIF
        lMyIUse:=StaticCall(NDJLIB003,UseCode,cMyIUse)
        IF !(lMyIUse)
            BREAK
        EndIF

    END SEQUENCE

Return(lMyIUse)

/*/
    Funcao:QtdAndVlrVld
    Autor:Marinaldo de Jesus
    Data:01/12/2010
    Descricao:Validar a Quantidade e o Valor Digitado
    Uso:X3_VLDUSER do campo _QUANT e _VALOR(PRECO) na SC,PC,e NFE
    Sintaxe:StaticCall(U_NDJBLKSCVL,QtdAndVlrVld)
/*/
Static Function QtdAndVlrVld(cFil,cAlias,aGdFields,aFldsPos,aFldsGet,cFieldQtd,nQtd,cFieldVal,nVal,cHelpField,lShowHelp,cMsgHelp,cFieldCntL,cFieldCntD)

    Local cHelp:=cHelpField

    Local dFieldCntD
    Local dLastYDate

    Local lFieldCntL

    Local nTpRet:=0
    Local nTotal:=0
    Local nBalance:=0
    Local nLastVal:=0
    Local nbdgAmount:=0
    Local nCommitted:=0
    Local nAvailable:=0
    Local nCNTMonths:=0

    Local lChkCNT:=(!(cFieldCntL ==NIL).and. !(cFieldCntD ==NIL))
    Local lReturnOk:=.T.

    BEGIN SEQUENCE

        DEFAULT nQtd:=StaticCall(NDJLIB001,__FieldGet,cAlias,cFieldQtd,.F.)

        IF !(lReturnOk:=(nQtd >0))
            cHelp:="NaoVazio"
            cMsgHelp:="O Campo:"
            cMsgHelp+=__cCRLF
            cMsgHelp+=GetCache("SX3",cHelpField,NIL,"X3Titulo()",2,.F.)
            cMsgHelp+=" "
            cMsgHelp+=cHelpField
            cMsgHelp+=__cCRLF
            cMsgHelp+="deve ser preenchido."
            Break
        EndIF

        nCNTMonths:=nQtd

        DEFAULT nVal:=StaticCall(NDJLIB001,__FieldGet,cAlias,cFieldVal,.F.)

        IF(lChkCNT)

            lFieldCntL:=StaticCall(NDJLIB001,__FieldGet,cAlias,cFieldCntL,.F.)

            IF (lFieldCntL)

                dFieldCntD:=StaticCall(NDJLIB001,__FieldGet,cAlias,cFieldCntD,.F.)

                dLastYDate:=LastYDate(@dFieldCntD)
                nCNTMonths:=DateDiffMonth(@dLastYDate,@dFieldCntD)

  ++nCNTMonths

            EndIF
            
        EndIF

        DO CASE
        CASE (nQtd >=nCNTMonths)
            nTotal:=(nCNTMonths * nVal)
        CASE (nQtd <=nCNTMonths)
            nTotal:=(nQtd * nVal)
        ENDCASE

        IF !(nTotal >0)
            BREAK
        EndIF

        nTpRet:=NDJ_BLK_GET_SALDO
        lReturnOk:=FldChkBlk(@cFil,@cAlias,@aGdFields,@aFldsPos,@aFldsGet,@nTotal,@nBalance,@nTpRet)

        IF !(lReturnOk)

            nTpRet:=NDJ_BLK_GET_ORCAMENTO
            FldChkBlk(@cFil,@cAlias,@aGdFields,@aFldsPos,@aFldsGet,@0,@nbdgAmount,@nTpRet)
            
            nTpRet:=NDJ_BLK_GET_EMPENHADO
            FldChkBlk(@cFil,@cAlias,@aGdFields,@aFldsPos,@aFldsGet,@0,@nCommitted,@nTpRet)

            nTpRet:=NDJ_BLK_GET_LASTVAL
            FldChkBlk(@cFil,@cAlias,@aGdFields,@aFldsPos,@aFldsGet,@0,@nLastVal,@nTpRet)

            nTotal:=(nQtd * nVal)
            nCommitted  -=nLastVal

            nAvailable:=(nbdgAmount - nCommitted)
            nAvailable:=Max(0,nAvailable)

            cHelp:="SALDO_INSUFICIENTE"
            cMsgHelp:="Saldo Insuficiente:"+Transform(nBalance,"@E 999,999,999,999.99")
            cMsgHelp+=__cCRLF
            cMsgHelp+="Tentando Empenhar:"+Transform(nTotal,"@E 999,999,999,999.99")
            cMsgHelp+=__cCRLF
            cMsgHelp+=__cCRLF
            cMsgHelp+="Esse item não será considerado."
            cMsgHelp+=__cCRLF
            cMsgHelp+=__cCRLF
            cMsgHelp+=Padr("Orçado:",12)+Transform(nbdgAmount,"@E 999,999,999,999.99")
            cMsgHelp+=__cCRLF
            cMsgHelp+=Padr("Empenhado:",10)+Transform(nCommitted,"@E 999,999,999,999.99")
            cMsgHelp+=__cCRLF
            cMsgHelp+=Padr("Disponível:",12)+Transform(nAvailable,"@E 999,999,999,999.99")
            cMsgHelp+=__cCRLF

            BREAK

        EndIF    

    END SEQUENCE

    DEFAULT lShowHelp:=.T.
    IF (;
            !(lReturnOk);
            .and.;
            (lShowHelp);
            .and.;
            !(Empty(cMsgHelp));
)
        Help("",1,OemToAnsi(cHelp),NIL,OemToAnsi(cMsgHelp),1,0)
    EndIF

Return(lReturnOk)

/*/
    Funcao:NDJChkVal
    Autor:Marinaldo de Jesus
    Data:01/12/2010
    Descricao:Verificar o Saldo Disponivel
/*/
Static Function NDJChkVal(cFil,cAlias,aHeader,aCols,lGdFields,nTotal,nSaldo,nTpRet,aFldsPos,aFldsGet)

    Local bPutSZ0:={ |lDelete,lGetLastVal| PutSZ0Val(@cFil,@cProjeto,@cRevisao,@cTarefa,@cCodOrcamento,@cXCodOrigem,cAlias,@cxFilial,@cNumSC,@cItemSC,@cSeq,@cItemGrd,@cCodSBM,@nTotal,@lDelete,@lGetLastVal)}

    Local cxFilial:=xFilial(cAlias,cFil)

    Local cSeq
    Local cNumSC
    Local cItemSC
    Local cItemGrd
    Local cCodSBM
    Local cOrigemRec
    Local cXCodOrigem
    Local cCodOrcamento

    Local cRevisao
    Local cTarefa
    Local cProjeto

    Local cAliasTTS

    Local lOk:=.T.
    Local lDeleted:=.F.

    Local nLastVal:=0
    Local nValDiff:=0
    Local nFieldPos

    Local nATVal
    Local nATQtd

    BEGIN SEQUENCE

        IF StaticCall(NDJLIB001,IsInGetDados,aFldsPos)
            nATVal:=GdFieldPos(aFldsPos[FIELD_POS_PRECO],@aHeader)           //Preco
            nATQtd:=GdFieldPos(aFldsPos[FIELD_POS_QUANTIDADE],@aHeader)       //Quantidade
        Else
            nATVal:=(cAlias)->(FieldPos(aFldsPos[FIELD_POS_PRECO]))            //Preco
            nATQtd:=(cAlias)->(FieldPos(aFldsPos[FIELD_POS_QUANTIDADE]))    //Quantidade
        EndIF

        IF !(nATQtd >0)
            BREAK
        EndIF

        IF !(nATVal >0)
            BREAK
        EndIF

        cProjeto:=StaticCall(NDJLIB001,__FieldGet,cAlias,aFldsGet[FIELD_GET_PROJETO],.F.)
        cRevisao:=StaticCall(NDJLIB001,__FieldGet,cAlias,aFldsGet[FIELD_GET_REVISAO],.F.)
        cTarefa:=StaticCall(NDJLIB001,__FieldGet,cAlias,aFldsGet[FIELD_GET_TAREFA],.F.)

        cCodOrcamento:=StaticCall(NDJLIB001,__FieldGet,cAlias,aFldsGet[FIELD_GET_ORCAMENTO],.F.)
        cXCodOrigem:=StaticCall(NDJLIB001,__FieldGet,cAlias,aFldsGet[FIELD_GET_ORIGEM_RECURSO],.F.)
        cCodSBM:=StaticCall(NDJLIB001,__FieldGet,cAlias,aFldsGet[FIELD_GET_TIPO_DESPESA],.F.)

        cSeq:=StaticCall(NDJLIB001,__FieldGet,cAlias,aFldsGet[FIELD_GET_SEQ_PEDIDO],.F.)
        DEFAULT cSeq:=Space(GetSx3Cache(aFldsGet[FIELD_GET_SEQ_PEDIDO],"X3_TAMANHO"))

        IF (;
                (Type("cA110Num")=="C");
                .and.;
                !Empty(cA110Num);
      )
            cNumSC:=cA110Num
        Else
            cNumSC:=StaticCall(NDJLIB001,__FieldGet,cAlias,aFldsGet[FIELD_GET_NUM_SC],.F.)
        EndIF    

        cItemSC:=StaticCall(NDJLIB001,__FieldGet,cAlias,aFldsGet[FIELD_GET_ITEM_SC],.F.)
        cItemGrd:=StaticCall(NDJLIB001,__FieldGet,cAlias,aFldsGet[FIELD_GET_ITEM_GRD],.F.)

        DEFAULT nTpRet:=NDJ_BLK_GET_SALDO
        DO CASE
            
            CASE (nTpRet ==NDJ_BLK_GET_SALDO)

                IF (lGdFields)
                    lDeleted:=GdDeleted()
                Else
                    lDeleted:=(cAlias)->(Deleted())
                EndIF
                IF (lDeleted)
                    Eval(bPutSZ0,@lDeleted)
                    nTotal:=0
                    BREAK
                EndIF

                nLastVal:=Eval(bPutSZ0,.F.,.T.)
                   nSaldo:=NDJOrcSaldo(@cFil,@cCodOrcamento,@cXCodOrigem,@cCodSBM,@nTpRet)
                   nSaldo+=nLastVal
                   nSaldo        -=nTotal

                lOk:=(nSaldo >=0)

                IF !(lOk)
                    cAliasTTS:=StaticCall(NDJLIB001,GetMemVar,"__cSZ0TTSAlias")
                    IF (;
                            !(GetNewPar("NDJ_BLK"+cAliasTTS,.T.));
                            .or.;
                            NDJIniNoBlk(@cProjeto);
                  )
                        lOk:=.T.
                    EndIF
                EndIF

                IF (;
                        !(lOk);
                        .or.;
                        !(nTotal >0);
          )
                    BREAK
                EndIF

                   Eval(bPutSZ0,.F.)

                   BREAK
               
               CASE ((nTpRet ==NDJ_BLK_GET_ORCAMENTO).or. (nTpRet ==NDJ_BLK_GET_EMPENHADO))

                nSaldo:=NDJOrcSaldo(@cFil,@cCodOrcamento,@cXCodOrigem,@cCodSBM,@nTpRet)
                
                BREAK

            CASE (nTpRet ==NDJ_BLK_GET_LASTVAL)

                nSaldo:=Eval(bPutSZ0,.F.,.T.)

           END CASE
    
    END SEQUENCE

Return(lOk)

/*/
    Funcao:FldChkBlk
    Autor:Marinaldo de Jesus
    Data:01/12/2010
    Descricao:Validar o Bloqueio por Orcamento
    Uso:Funcoes de Validacao dos campos C1_QUANT e C1_XPRECO
/*/
Static Function FldChkBlk(cFil,cAlias,aGdFields,aFldsPos,aFldsGet,nTotal,nSaldo,nTpRet)

    Local aFieldsGD
    Local lFldChkBlk:=.T.
    Local lGdFields

    BEGIN SEQUENCE

        aFieldsGD:=aClone(aGdFields[GD_FIELDS_OPTION1])
        lGdFields:=StaticCall(NDJLIB001,IsInGetDados,@aFieldsGD)
        IF .NOT.(lGdFields)
            aFieldsGD:=aGdFields[GD_FIELDS_OPTION2]
            lGdFields:=StaticCall(NDJLIB001,IsInGetDados,@aFieldsGD)
        EndIF

        IF .NOT.(lGdFields)
            IF .NOT.(Type("aHeader")=="A")
                Private aHeader:={}
            EndIF    
            IF .NOT.(Type("aCols")=="A")
                Private aCols:={}
            EndIF    
        EndIF

        DEFAULT    cFil:=xFilial(cAlias,cFilAnt)
        DEFAULT nTpRet:=NDJ_BLK_GET_SALDO
        lFldChkBlk:=NDJChkVal(@cFil,@cAlias,@aHeader,@aCols,@lGdFields,@nTotal,@nSaldo,@nTpRet,@aFldsPos,@aFldsGet)
        IF .NOT.(lFldChkBlk)
            BREAK
        EndIF

    END SEQUENCE

Return(lFldChkBlk)

/*/
    Funcao:SC1GetInfo
    Autor:Marinaldo de Jesus
    Data:01/12/2010
    Descricao:Retorna Informacoes de Campos da SC1
/*/
Static Function SC1GetInfo(aGdFields,aFldsPos,aFldsGet)

    aFldsPos:=Array(FIELD_POS_FIELDS)
    aFldsPos[ FIELD_POS_PRECO                ]:="C1_XPRECO"
    aFldsPos[ FIELD_POS_QUANTIDADE            ]:="C1_QUANT"

    aFldsGet:=Array(FIELD_GET_FIELDS)
    aFldsGet[ FIELD_GET_ORCAMENTO            ]:="C1_CODORCA"
    aFldsGet[ FIELD_GET_ORIGEM_RECURSO        ]:="C1_XCODOR"
    aFldsGet[ FIELD_GET_TIPO_DESPESA        ]:="C1_XCODSBM"
    aFldsGet[ FIELD_GET_SEQ_PEDIDO            ]:="C7_SEQUEN"
    aFldsGet[ FIELD_GET_NUM_SC                ]:="C1_NUM"
    aFldsGet[ FIELD_GET_ITEM_SC                ]:="C1_ITEM"
    aFldsGet[ FIELD_GET_ITEM_GRD            ]:="C1_ITEMGRD"
    aFldsGet[ FIELD_GET_PROJETO                ]:="C1_XPROJET"
    aFldsGet[ FIELD_GET_REVISAO                ]:="C1_XREVISA"
    aFldsGet[ FIELD_GET_TAREFA                ]:="C1_XTAREFA"
    aFldsGet[ FIELD_GET_ORIGEM_DE_RECURSO    ]:="C1_XCODOR"

    aGdFields:=Array(GD_FIELDS_OPTIONS)
    aGdFields[ GD_FIELDS_OPTION1            ]:={ "C1_QUANT","C1_XPRECO","C1_CODORCA","C1_XCODOR","C1_XCODSBM","C1_NUM","C1_ITEM","C1_ITEMGRD","C1_XPROJET","C1_XREVISA","C1_XTAREFA" }
    aGdFields[ GD_FIELDS_OPTION2            ]:={ "C1_QUANT","C1_XPRECO","C1_CODORCA","C1_XCODOR","C1_XCODSBM","C1_ITEM","C1_ITEMGRD","C1_XPROJET","C1_XREVISA","C1_XTAREFA" }

Return(NIL)

/*/
    Funcao:C1QuantVld
    Autor:Marinaldo de Jesus
    Data:09/11/2010
    Descricao:Validar se a quantidade Pode ser Alterada
    Uso:X3_VLDUSER do campo C1_QUANT
    Sintaxe:StaticCall(U_NDJBLKSCVL,C1QuantVld,nC1Quant,lShowHelp,cMsgHelp)
/*/
Static Function C1QuantVld(nC1Quant,lShowHelp,cMsgHelp)

    Local aFldsPos
    Local aFldsGet
    Local aGdFields

    Local cFil:=xFilial("SC1",cFilAnt)
    Local cAlias:="SC1"
    Local cFieldQtd:="C1_QUANT"
    Local cFieldVal:="C1_XPRECO"
    Local cHelpField:=cFieldQtd
    Local cFieldCntL:="C1_XREFCNT"
    Local cFieldCntD:="C1_XDTPPAG"

    Local nQtd:=nC1Quant
    Local nVal

    SC1GetInfo(@aGdFields,@aFldsPos,@aFldsGet)

    StaticCall(NDJLIB004,SetPublic,"__cSZ0TTSAlias","SC1","C",3,.T.)

Return(QtdAndVlrVld(@cFil,@cAlias,@aGdFields,@aFldsPos,@aFldsGet,@cFieldQtd,@nQtd,@cFieldVal,@nVal,@cHelpField,@lShowHelp,@cMsgHelp,@cFieldCntL,@cFieldCntD))

/*/
    Funcao:C1XPrecoVld
    Autor:Marinaldo de Jesus
    Data:09/11/2010
    Descricao:Validar o Preço a ser digitado
    Uso:X3_VLDUSER do campo C1_XPRECO
    Sintaxe:StaticCall(U_NDJBLKSCVL,C1XPrecoVld,nC1XPreco,lShowHelp,cMsgHelp)
/*/
Static Function C1XPrecoVld(nC1XPreco,lShowHelp,cMsgHelp)

    Local aFldsPos
    Local aFldsGet
    Local aGdFields

    Local cFil:=xFilial("SC1",cFilAnt)
    Local cAlias:="SC1"
    Local cFieldQtd:="C1_QUANT"
    Local cFieldVal:="C1_XPRECO"
    Local cHelpField:=cFieldVal
    Local cFieldCntL:="C1_XREFCNT"
    Local cFieldCntD:="C1_XDTPPAG"

    Local nQtd        
    Local nVal:=nC1XPreco

    SC1GetInfo(@aGdFields,@aFldsPos,@aFldsGet)

    StaticCall(NDJLIB004,SetPublic,"__cSZ0TTSAlias","SC1","C",3,.T.)

Return(QtdAndVlrVld(@cFil,@cAlias,@aGdFields,@aFldsPos,@aFldsGet,@cFieldQtd,@nQtd,@cFieldVal,@nVal,@cHelpField,@lShowHelp,@cMsgHelp,@cFieldCntL,@cFieldCntD))

/*/
    Funcao:SC7GetInfo
    Autor:Marinaldo de Jesus
    Data:01/12/2010
    Descricao:Retorna Informacoes de Campos da SC7
/*/
Static Function SC7GetInfo(aGdFields,aFldsPos,aFldsGet)

    aFldsPos:=Array(FIELD_POS_FIELDS)
    aFldsPos[ FIELD_POS_PRECO                ]:="C7_PRECO"
    aFldsPos[ FIELD_POS_QUANTIDADE            ]:="C7_QUANT"

    aFldsGet:=Array(FIELD_GET_FIELDS)
    aFldsGet[ FIELD_GET_ORCAMENTO            ]:="C7_CODORCA"
    aFldsGet[ FIELD_GET_ORIGEM_RECURSO        ]:="C7_XCODOR"
    aFldsGet[ FIELD_GET_TIPO_DESPESA        ]:="C7_XCODSBM"
    aFldsGet[ FIELD_GET_SEQ_PEDIDO            ]:="C7_SEQUEN"
    aFldsGet[ FIELD_GET_NUM_SC                ]:="C7_NUMSC"
    aFldsGet[ FIELD_GET_ITEM_SC                ]:="C7_ITEMSC"
    aFldsGet[ FIELD_GET_ITEM_GRD            ]:="C7_ITEMGRD"
    aFldsGet[ FIELD_GET_PROJETO                ]:="C7_XPROJET"
    aFldsGet[ FIELD_GET_REVISAO                ]:="C7_XREVIS"
    aFldsGet[ FIELD_GET_TAREFA                ]:="C7_XTAREFA"
    aFldsGet[ FIELD_GET_ORIGEM_DE_RECURSO    ]:="C7_XCODOR"

    aGdFields:=Array(GD_FIELDS_OPTIONS)

    aGdFields[ GD_FIELDS_OPTION1            ]:={ "C7_QUANT","C7_PRECO","C7_CODORCA","C7_XCODOR","C7_XCODSBM","C7_NUMSC","C7_ITEMSC","C7_SEQUEN","C7_ITEMGRD","C7_XPROJET","C7_XREVIS","C7_XTAREFA" }
    aGdFields[ GD_FIELDS_OPTION2            ]:={ "C7_QUANT","C7_PRECO","C7_CODORCA","C7_XCODOR","C7_XCODSBM","C7_ITEMSC","C7_SEQUEN","C7_ITEMGRD","C7_XPROJET","C7_XREVIS","C7_XTAREFA" }

Return(NIL)

/*/
    Funcao:C7QuantVld
    Autor:Marinaldo de Jesus
    Data:09/11/2010
    Descricao:Validar se a quantidade Pode ser Alterada
    Uso:X3_VLDUSER do campo C7_QUANT
    Sintaxe:StaticCall(U_NDJBLKSCVL,C7QuantVld,nC7Quant,lShowHelp,cMsgHelp)
/*/
Static Function C7QuantVld(nC7Quant,lShowHelp,cMsgHelp)

    Local aFldsPos
    Local aFldsGet
    Local aGdFields

    Local cFil:=xFilial("SC7",cFilAnt)
    Local cAlias:="SC7"
    Local cFieldQtd:="C7_QUANT"
    Local cFieldVal:="C7_PRECO"
    Local cHelpField:=cFieldQtd
    Local cFieldCntL:="C7_XREFCNT"
    Local cFieldCntD:="C7_XDTPPAG"

    Local nQtd:=nC7Quant
    Local nVal

    SC7GetInfo(@aGdFields,@aFldsPos,@aFldsGet)

    StaticCall(NDJLIB004,SetPublic,"__cSZ0TTSAlias","SC7","C",3,.T.)

Return(QtdAndVlrVld(@cFil,@cAlias,@aGdFields,@aFldsPos,@aFldsGet,@cFieldQtd,@nQtd,@cFieldVal,@nVal,@cHelpField,@lShowHelp,@cMsgHelp,@cFieldCntL,@cFieldCntD))

/*/
    Funcao:C7PrecoVld
    Autor:Marinaldo de Jesus
    Data:09/11/2010
    Descricao:Validar o Preço a ser digitado
    Uso:X3_VLDUSER do campo C7_PRECO
    Sintaxe:StaticCall(U_NDJBLKSCVL,C7PrecoVld,nC7Preco,lShowHelp,cMsgHelp)
/*/
Static Function C7PrecoVld(nC7Preco,lShowHelp,cMsgHelp)

    Local aFldsPos
    Local aFldsGet
    Local aGdFields

    Local cFil:=xFilial("SC7",cFilAnt)
    Local cAlias:="SC7"
    Local cFieldQtd:="C7_QUANT"
    Local cFieldVal:="C7_PRECO"
    Local cHelpField:=cFieldVal
    Local cFieldCntL:="C7_XREFCNT"
    Local cFieldCntD:="C7_XDTPPAG"

    Local nQtd
    Local nVal:=nC7Preco

    SC7GetInfo(@aGdFields,@aFldsPos,@aFldsGet)

    StaticCall(NDJLIB004,SetPublic,"__cSZ0TTSAlias","SC7","C",3,.T.)

Return(QtdAndVlrVld(@cFil,@cAlias,@aGdFields,@aFldsPos,@aFldsGet,@cFieldQtd,@nQtd,@cFieldVal,@nVal,@cHelpField,@lShowHelp,@cMsgHelp,@cFieldCntL,@cFieldCntD))

/*/
    Funcao:D1QuantVld
    Autor:Marinaldo de Jesus
    Data:09/11/2010
    Descricao:Validar se a quantidade Pode ser Alterada
    Uso:X3_VLDUSER do campo D1_QUANT
    Sintaxe:StaticCall(U_NDJBLKSCVL,D1QuantVld)
/*/
Static Function D1QuantVld(nD1Quant,lShowHelp,cMsgHelp)

    Local aSD1ToSC7:={;
                                { "D1_QUANT","D1_VUNIT","D1_CODORCA","D1_XCODOR","D1_XCODSBM","D1_XNUMSC","D1_XITEMSC","D1_XSEQUEN","D1_ITEMGRD","D1_XPROJET","D1_XREVIS","D1_XTAREFA" },;
                                { "C7_QUANT","C7_PRECO","C7_CODORCA","C7_XCODOR","C7_XCODSBM","C7_NUMSC","C7_ITEMSC","C7_SEQUEN","C7_ITEMGRD","C7_XPROJET","C7_XREVIS","C7_XTAREFA" };
                            }

    Local aFldsPos
    Local aFldsGet
    Local aGdFields

    Local cFil:=xFilial("SC7",cFilAnt)
    Local cAlias:="SC7"
    Local cFieldQtd:="C7_QUANT"
    Local cFieldVal:="C7_PRECO"
    Local cHelpField:=cFieldQtd
    Local cFieldCntL:=NIL
    Local cFieldCntD:=NIL

    Local nQtd:=nD1Quant
    Local nVal

    Local nField        
    Local nFields:=Len(aSD1ToSC7[ 1 ])

    Local uPTVal

    SC7GetInfo(@aGdFields,@aFldsPos,@aFldsGet)

    For nField:=1 To nFields
        uPTVal:=StaticCall(NDJLIB001,__FieldGet,"SD1",aSD1ToSC7[ 1 ][ nField ],.F.)
        StaticCall(NDJLIB001,SetMemVar,aSD1ToSC7[ 2 ][ nField ],uPTVal,.T.,.T.,.F.,.F.,NIL,.F.)   
    Next nField

    StaticCall(NDJLIB004,SetPublic,"__cSZ0TTSAlias","SD1","C",3,.T.)

Return(QtdAndVlrVld(@cFil,@cAlias,@aGdFields,@aFldsPos,@aFldsGet,@cFieldQtd,@nQtd,@cFieldVal,@nVal,@cHelpField,@lShowHelp,@cMsgHelp,@cFieldCntL,@cFieldCntD))

/*/
    Funcao:D1VUnitVld
    Autor:Marinaldo de Jesus
    Data:09/11/2010
    Descricao:Validar o Preço a ser digitado
    Uso:X3_VLDUSER do campo D1_VUNIT
    Sintaxe:StaticCall(U_NDJBLKSCVL,D1VUnitVld)
/*/
Static Function D1VUnitVld(nD1VUnit,lShowHelp,cMsgHelp)

    Local aSD1ToSC7:={;
                                { "D1_QUANT","D1_VUNIT","D1_CODORCA","D1_XCODOR","D1_XCODSBM","D1_XNUMSC","D1_XITEMSC","D1_XSEQUEN","D1_ITEMGRD","D1_XPROJET","D1_XREVIS","D1_XTAREFA" },;
                                { "C7_QUANT","C7_PRECO","C7_CODORCA","C7_XCODOR","C7_XCODSBM","C7_NUMSC","C7_ITEMSC","C7_SEQUEN","C7_ITEMGRD","C7_XPROJET","C7_XREVIS","C7_XTAREFA" };
                            }

    Local aFldsPos
    Local aFldsGet
    Local aGdFields

    Local cFil:=xFilial("SC7",cFilAnt)
    Local cAlias:="SC7"
    Local cFieldQtd:="C7_QUANT"
    Local cFieldVal:="C7_PRECO"
    Local cHelpField:=cFieldQtd
    Local cFieldCntL:=NIL
    Local cFieldCntD:=NIL

    Local nQtd
    Local nVal:=nD1VUnit

    Local nField        
    Local nFields:=Len(aSD1ToSC7[ 1 ])

    Local uPTVal

    SC7GetInfo(@aGdFields,@aFldsPos,@aFldsGet)

    For nField:=1 To nFields
        uPTVal:=StaticCall(NDJLIB001,__FieldGet,"SD1",aSD1ToSC7[ 1 ][ nField ],.F.)
        StaticCall(NDJLIB001,SetMemVar,aSD1ToSC7[ 2 ][ nField ],uPTVal,.T.,.T.,.F.,.F.,NIL,.F.)   
    Next nField

    StaticCall(NDJLIB004,SetPublic,"__cSZ0TTSAlias","SD1","C",3,.T.)

Return(QtdAndVlrVld(@cFil,@cAlias,@aGdFields,@aFldsPos,@aFldsGet,@cFieldQtd,@nQtd,@cFieldVal,@nVal,@cHelpField,@lShowHelp,@cMsgHelp,@cFieldCntL,@cFieldCntD))

/*/
    Funcao:CNBQuantVld
    Autor:Marinaldo de Jesus
    Data:22/08/2011
    Descricao:Validar se a quantidade Pode ser Alterada
    Uso:X3_VLDUSER do campo CNB_QUANT
    Sintaxe:StaticCall(U_NDJBLKSCVL,CNBQuantVld)
/*/
Static Function CNBQuantVld(nCNBQuant,lShowHelp,cMsgHelp)

    Local aCNBToSC7:={;
                                { "CNB_QUANT","CNB_VLUNIT","CNB_XCODCA","CNB_XCODOR","CNB_XCODSB","CNB_XNUMSC","CNB_XITMSC","CNB_XSEQPC","CNB_ITEGRD","CNB_XPROJE","CNB_XREVIS","CNB_XTAREF" },;
                                { "C7_QUANT","C7_PRECO","C7_CODORCA","C7_XCODOR","C7_XCODSBM","C7_NUMSC","C7_ITEMSC","C7_SEQUEN","C7_ITEMGRD","C7_XPROJET","C7_XREVIS","C7_XTAREFA" };
                            }

    Local aFldsPos
    Local aFldsGet
    Local aGdFields

    Local cFil:=xFilial("SC7",cFilAnt)
    Local cAlias:="SC7"
    Local cFieldQtd:="C7_QUANT"
    Local cFieldVal:="C7_PRECO"
    Local cHelpField:=cFieldQtd
    Local cFieldCntL:=NIL
    Local cFieldCntD:=NIL

    Local nQtd:=nCNBQuant
    Local nVal

    Local nField        
    Local nFields:=Len(aCNBToSC7[ 1 ])

    Local uPTVal

    SC7GetInfo(@aGdFields,@aFldsPos,@aFldsGet)

    For nField:=1 To nFields
        uPTVal:=StaticCall(NDJLIB001,__FieldGet,"CNB",aCNBToSC7[ 1 ][ nField ],.F.)
        StaticCall(NDJLIB001,SetMemVar,aCNBToSC7[ 2 ][ nField ],uPTVal,.T.,.T.,.F.,.F.,NIL,.F.)   
    Next nField

    StaticCall(NDJLIB004,SetPublic,"__cSZ0TTSAlias","CNB","C",3,.T.)

Return(QtdAndVlrVld(@cFil,@cAlias,@aGdFields,@aFldsPos,@aFldsGet,@cFieldQtd,@nQtd,@cFieldVal,@nVal,@cHelpField,@lShowHelp,@cMsgHelp,@cFieldCntL,@cFieldCntD))

/*/
    Funcao:CNBVlUnitVld
    Autor:Marinaldo de Jesus
    Data:22/08/2011
    Descricao:Validar se o Valor Pode ser Alterado
    Uso:X3_VLDUSER do campo CNB_VLUNIT
    Sintaxe:StaticCall(U_NDJBLKSCVL,CNBVlUnitVld)
/*/
Static Function CNBVlUnitVld(nCNBVlUnit,lShowHelp,cMsgHelp)

    Local aCNBToSC7:={;
                                { "CNB_QUANT","CNB_VLUNIT","CNB_XCODCA","CNB_XCODOR","CNB_XCODSB","CNB_XNUMSC","CNB_XITMSC","CNB_XSEQPC","CNB_ITEGRD","CNB_XPROJE","CNB_XREVIS","CNB_XTAREF" },;
                                { "C7_QUANT","C7_PRECO","C7_CODORCA","C7_XCODOR","C7_XCODSBM","C7_NUMSC","C7_ITEMSC","C7_SEQUEN","C7_ITEMGRD","C7_XPROJET","C7_XREVIS","C7_XTAREFA" };
                            }
    Local aFldsPos
    Local aFldsGet
    Local aGdFields

    Local cFil:=xFilial("SC7",cFilAnt)
    Local cAlias:="SC7"
    Local cFieldQtd:="C7_QUANT"
    Local cFieldVal:="C7_PRECO"
    Local cHelpField:=cFieldVal
    Local cFieldCntL:=NIL
    Local cFieldCntD:=NIL

    Local nQtd            
    Local nVal:=nCNBVlUnit

    Local nField
    Local nFields:=Len(aCNBToSC7[ 1 ])

    Local uPTVal

    SC7GetInfo(@aGdFields,@aFldsPos,@aFldsGet)

    For nField:=1 To nFields
        uPTVal:=StaticCall(NDJLIB001,__FieldGet,"CNB",aCNBToSC7[ 1 ][ nField ],.F.)
        StaticCall(NDJLIB001,SetMemVar,aCNBToSC7[ 2 ][ nField ],uPTVal,.T.,.T.,.F.,.F.,NIL,.F.)
    Next nField

    StaticCall(NDJLIB004,SetPublic,"__cSZ0TTSAlias","CNB","C",3,.T.)

Return(QtdAndVlrVld(@cFil,@cAlias,@aGdFields,@aFldsPos,@aFldsGet,@cFieldQtd,@nQtd,@cFieldVal,@nVal,@cHelpField,@lShowHelp,@cMsgHelp,@cFieldCntL,@cFieldCntD))

/*/
    Funcao:CNEQuantVld
    Autor:Marinaldo de Jesus
    Data:09/11/2010
    Descricao:Validar se a quantidade Pode ser Alterada
    Uso:X3_VLDUSER do campo CNE_QUANT
    Sintaxe:StaticCall(U_NDJBLKSCVL,CNEQuantVld)
/*/
Static Function CNEQuantVld(nCNEQuant,lShowHelp,cMsgHelp)

    Local aCNEToSC7:={;
                                { "CNE_QUANT","CNE_VLUNIT","CNE_XCODCA","CNE_XCODOR","CNE_XCODSB","CNE_XNUMSC","CNE_XITMSC","CNE_XSEQPC","CNE_ITEGRD","CNE_XPROJE","CNE_XREVIS","CNE_XTAREF" },;
                                { "C7_QUANT","C7_PRECO","C7_CODORCA","C7_XCODOR","C7_XCODSBM","C7_NUMSC","C7_ITEMSC","C7_SEQUEN","C7_ITEMGRD","C7_XPROJET","C7_XREVIS","C7_XTAREFA" };
                            }

    Local aFldsPos
    Local aFldsGet
    Local aGdFields

    Local cFil:=xFilial("SC7",cFilAnt)
    Local cAlias:="SC7"
    Local cFieldQtd:="C7_QUANT"
    Local cFieldVal:="C7_PRECO"
    Local cHelpField:=cFieldQtd
    Local cFieldCntL:=NIL
    Local cFieldCntD:=NIL

    Local nQtd:=nCNEQuant
    Local nVal

    Local nField        
    Local nFields:=Len(aCNEToSC7[ 1 ])

    Local uPTVal

    SC7GetInfo(@aGdFields,@aFldsPos,@aFldsGet)

    For nField:=1 To nFields
        uPTVal:=StaticCall(NDJLIB001,__FieldGet,"CNE",aCNEToSC7[ 1 ][ nField ],.F.)
        StaticCall(NDJLIB001,SetMemVar,aCNEToSC7[ 2 ][ nField ],uPTVal,.T.,.T.,.F.,.F.,NIL,.F.)   
    Next nField

    StaticCall(NDJLIB004,SetPublic,"__cSZ0TTSAlias","CNE","C",3,.T.)

Return(QtdAndVlrVld(@cFil,@cAlias,@aGdFields,@aFldsPos,@aFldsGet,@cFieldQtd,@nQtd,@cFieldVal,@nVal,@cHelpField,@lShowHelp,@cMsgHelp,@cFieldCntL,@cFieldCntD))

/*/
    Funcao:CNEVlUnitVld
    Autor:Marinaldo de Jesus
    Data:09/11/2010
    Descricao:Validar se o Valor Pode ser Alterado
    Uso:X3_VLDUSER do campo CNE_VLUNIT
    Sintaxe:StaticCall(U_NDJBLKSCVL,CNEVlUnitVld)
/*/
Static Function CNEVlUnitVld(nCNEVlUnit,lShowHelp,cMsgHelp)

    Local aCNEToSC7:={;
                                { "CNE_QUANT","CNE_VLUNIT","CNE_XCODCA","CNE_XCODOR","CNE_XCODSB","CNE_XNUMSC","CNE_XITMSC","CNE_XSEQPC","CNE_ITEGRD","CNE_XPROJE","CNE_XREVIS","CNE_XTAREF" },;
                                { "C7_QUANT","C7_PRECO","C7_CODORCA","C7_XCODOR","C7_XCODSBM","C7_NUMSC","C7_ITEMSC","C7_SEQUEN","C7_ITEMGRD","C7_XPROJET","C7_XREVIS","C7_XTAREFA" };
                            }
    Local aFldsPos
    Local aFldsGet
    Local aGdFields

    Local cFil:=xFilial("SC7",cFilAnt)
    Local cAlias:="SC7"
    Local cFieldQtd:="C7_QUANT"
    Local cFieldVal:="C7_PRECO"
    Local cHelpField:=cFieldVal
    Local cFieldCntL:=NIL
    Local cFieldCntD:=NIL

    Local nQtd            
    Local nVal:=nCNEVlUnit

    Local nField
    Local nFields:=Len(aCNEToSC7[ 1 ])

    Local uPTVal

    SC7GetInfo(@aGdFields,@aFldsPos,@aFldsGet)

    For nField:=1 To nFields
        uPTVal:=StaticCall(NDJLIB001,__FieldGet,"CNE",aCNEToSC7[ 1 ][ nField ],.F.)
        StaticCall(NDJLIB001,SetMemVar,aCNEToSC7[ 2 ][ nField ],uPTVal,.T.,.T.,.F.,.F.,NIL,.F.)
    Next nField

    StaticCall(NDJLIB004,SetPublic,"__cSZ0TTSAlias","CNE","C",3,.T.)

Return(QtdAndVlrVld(@cFil,@cAlias,@aGdFields,@aFldsPos,@aFldsGet,@cFieldQtd,@nQtd,@cFieldVal,@nVal,@cHelpField,@lShowHelp,@cMsgHelp,@cFieldCntL,@cFieldCntD))

/*/
    Funcao: CNFToSZ0
    Autor:Marinaldo de Jesus
    Data:22/12/2010
    Descricao:Atualizar os Valores Empenhados de Acordo com o Cronograma Financeiro
    Sintaxe:StaticCall(U_NDJBLKSCVL,CNFToSZ0,nOpc,cCN9Filial,cContra,cRevisao,cCronog)
/*/
Static Function CNFToSZ0(nOpc,cCN9Filial,cContra,cRevisao,cCronog)

    Local aArea:=GetArea()

    Local cQuery

    Local cCNAFilial
    Local cCNBFilial
    Local cCNFFilial

    Local cNextAlias

    Local cCNAKeySeek

    Local cCNFCompete
    
    Local lCronograma

    BEGIN SEQUENCE

        cCNAFilial:=xFilial("CNA")
        
        cCNAKeySeek:=cCNAFilial
        cCNAKeySeek+=cContra
        cCNAKeySeek+=cRevisao
        cCNAKeySeek+=cCronog

        lCronograma:=CNA->(dbSeek(cCNAKeySeek,.F.).and. !Empty(CNA_CRONOG))

        IF !(lCronograma)
            BREAK
        EndIF

        cCNBFilial:=xFilial("CNB")
        cCNFFilial:=xFilial("CNF")
        cNextAlias:=GetNextAlias()

        cCNFCompete:=Year2Str(dDataBase)

        cQuery:="SELECT"+__cCRLF
        cQuery+="    CN9.CN9_NUMERO,"+__cCRLF
        cQuery+="    CN9.CN9_REVISA,"+__cCRLF
        cQuery+="    CNA.CNA_NUMERO,"+__cCRLF
        cQuery+="    CNA.CNA_CRONOG,"+__cCRLF
        cQuery+="    CNB.R_E_C_N_O_ AS CNBRECNO,"+__cCRLF
        cQuery+="    Substring(CNF.CNF_COMPET,4,4)AS CNF_COMPET,"+__cCRLF
        cQuery+="    COUNT(1) AS CNB_QUANT,"+__cCRLF
        cQuery+="    AVG(CNF.CNF_VLPREV) AS CNB_VLUNIT,"+__cCRLF
        cQuery+="    SUM(CNF.CNF_VLPREV) AS CNF_VLPREV"+__cCRLF
        cQuery+="FROM"+__cCRLF
        cQuery+="    "+RetSqlName("CN9")+" CN9,"+__cCRLF
        cQuery+="    "+RetSqlName("CNA")+" CNA,"+__cCRLF
        cQuery+="    "+RetSqlName("CNB")+" CNB,"+__cCRLF
        cQuery+="    "+RetSqlName("CNF")+" CNF  "+__cCRLF
        cQuery+="WHERE"+__cCRLF
        cQuery+="    CN9.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNA.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNB.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNF.D_E_L_E_T_ =' '"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CN9.CN9_FILIAL ='"+cCN9Filial+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNA.CNA_FILIAL ='"+cCNAFilial+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNB.CNB_FILIAL ='"+cCNBFilial+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNF.CNF_FILIAL ='"+cCNFFilial+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CN9.CN9_NUMERO ='"+cContra+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNA.CNA_CONTRA ='"+cContra+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNB.CNB_CONTRA ='"+cContra+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNF.CNF_CONTRA ='"+cContra+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CN9.CN9_REVISA ='"+cRevisao+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNA.CNA_REVISA ='"+cRevisao+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNB.CNB_REVISA ='"+cRevisao+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNF.CNF_REVISA ='"+cRevisao+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNA.CNA_CRONOG ='"+cCronog+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNF.CNF_NUMERO ='"+cCronog+"'"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    CNB.CNB_NUMERO =CNA.CNA_NUMERO"+__cCRLF
        cQuery+="    AND"+__cCRLF
        cQuery+="    Substring(CNF.CNF_COMPET,4,4)='"+cCNFCompete+"'"+__cCRLF
        cQuery+="GROUP BY"+__cCRLF
        cQuery+="    CN9.CN9_NUMERO,"+__cCRLF
        cQuery+="    CN9.CN9_REVISA,"+__cCRLF
        cQuery+="    CNA.CNA_NUMERO,"+__cCRLF
        cQuery+="    CNA.CNA_CRONOG,"+__cCRLF
        cQuery+="    CNB.R_E_C_N_O_,"+__cCRLF
        cQuery+="    Substring(CNF.CNF_COMPET,4,4)"+__cCRLF
    
        TCQUERY (cQuery)ALIAS (cNextAlias)NEW
    
          TcSetField(cNextAlias,"CNBRECNO","N",18,0)
          TcSetField(cNextAlias,"CNF_VLPREV","N",GetSx3Cache("CNA_VLTOT","X3_TAMANHO"),GetSx3Cache("CNA_VLTOT","X3_DECIMAL"))
        TcSetField(cNextAlias,"CNB_QUANT","N",GetSx3Cache("CNB_QUANT","X3_TAMANHO"),GetSx3Cache("CNB_QUANT","X3_DECIMAL"))
        TcSetField(cNextAlias,"CNB_VLUNIT","N",GetSx3Cache("CNB_VLUNIT","X3_TAMANHO"),GetSx3Cache("CNB_VLUNIT","X3_DECIMAL"))

        While (cNextAlias)->(!Eof())

            CNB->(dbGoto((cNextAlias)->CNBRECNO))
            IF CNB->(!Eof() .and. !Bof())

                //Seta a Quantidade a ser Considerada no CNB
                StaticCall(NDJLIB001,SetMemVar,"CNB_QUANT",(cNextAlias)->CNB_QUANT,.T.,.F.)

                //Seta o Valor Unitario a ser Considerado no CNB
                StaticCall(NDJLIB001,SetMemVar,"CNB_VLUNIT",(cNextAlias)->CNB_VLUNIT,.T.,.F.)

                //Utiliza CNBQuantVld para Atualizar o Valor do Empenho
                CNBQuantVld(NIL,.F.)
                
                //Forca o Commit das Alteracoes de Empenho
                SZ0TTSCommit()

            EndIF

            (cNextAlias)->(dbSkip())

        End While

        (cNextAlias)->(dbCloseArea())

    END SEQUENCE

    RestArea(aArea)

Return(NIL)

/*/
    Funcao: CNAToSZ0
    Autor:Marinaldo de Jesus
    Data:22/12/2010
    Descricao:Atualizar os Valores Empenhados de Acordo com a Planilha de Contrato
    Sintaxe:StaticCall(U_NDJBLKSCVL,CNAToSZ0,aCNARecnos,nRecnos,nCNBOrder,cCNBFilial)
/*/
Static Function CNAToSZ0(aCNARecnos,nRecnos,nCNBOrder,cCNBFilial)

    Local cYearBase:=Year2Str(dDataBase)
    Local cCNBKeySeek

    Local nRecno

    DEFAULT nCNBOrder:=RetOrder("CNB","CNB_FILIAL+CNB_CONTRA+CNB_REVISA+CNB_NUMERO+CNB_ITEM")
    
    CNB->(dbSetOrder(nCNBOrder))

    For nRecno:=1 To nRecnos

        nCNARecno:=aCNARecnos[ nRecno ]
        //Forco o Posicionamento da Tabela CNA
        CNA->(dbGoto(nCNARecno))

        //Se o Final do Periodo da Planilha for Diferente do Ano Corrente
        IF (Year2Str(CNA->CNA_DTFIM)<>cYearBase)
            Loop
        EndIF

        //Forco o Posicionamento da Tabela CNB
        cCNBKeySeek:=cCNBFilial
        cCNBKeySeek+=CNA->CNA_CONTRA
        cCNBKeySeek+=CNA->CNA_REVISA
        cCNBKeySeek+=CNA->CNA_NUMERO
        
        IF CNB->(!dbSeek(cCNBKeySeek,.F.))
            Loop
        EndIF

        //Seta a Quantidade a ser Considerada no CNB
        StaticCall(NDJLIB001,SetMemVar,"CNB_QUANT",CNB->CNB_QUANT,.T.,.F.)

        //Seta o Valor Unitario a ser Considerado no CNB
        StaticCall(NDJLIB001,SetMemVar,"CNB_VLUNIT",CNB->CNB_VLUNIT,.T.,.F.)

        //Utiliza CNBQuantVld para Atualizar o Valor do Empenho
        CNBQuantVld(NIL,.F.)
        
        //Forca o Commit das Alteracoes de Empenho
        SZ0TTSCommit()

    Next nRecno

Return(NIL)

/*/
    Funcao:EmpFrmTrab
    Autor:Marinaldo de Jesus
    Data:23/08/2011
    Descricao:Preparar arquivos de Trabalhos com Informacoes de Empenho (SZ0) e Realizado (SD1) para uso em Formulas
    Uso:Formulas de Valores Empenhados e Realizados
    Sintaxe:StaticCall(U_NDJBLKSCVL,EmpFrmTrab)
/*/
Static Function EmpFrmTrab()

    Local cRDD:="DBFCDXADS"
    Local cQuery:=""
    Local cAlias:=Alias()
    Local cAliasQry:=GetNextAlias()

    Local cSpcTES:=Space(GetSx3Cache("D1_TES","X3_TAMANHO"))
    
    Local cAFBAlias:=StaticCall(NDJLIB001,GetMemVar,"__cTrbAFBAlias")
    Local cAJCAlias:=StaticCall(NDJLIB001,GetMemVar,"__cTrbAJCAlias")
    Local cSD1Alias:=StaticCall(NDJLIB001,GetMemVar,"__cTrbSD1Alias")
    Local cSZ0Alias:=StaticCall(NDJLIB001,GetMemVar,"__cTrbSZ0Alias")

    Local cAFBFilial:=xFilial("AFB")
    Local cAJCFilial:=xFilial("AJC")
    Local cSD1Filial:=xFilial("SD1")
    Local cSZ0Filial:=xFilial("SZ0")

    //Verifica se Ja Esta aberto e Encerra
    EmpFrmClose()

    //Prepara o Ambiente para a Tabela AFB
    IF ((cAFBAlias ==NIL).or. (cAFBAlias =="AFB"))
        StaticCall(NDJLIB004,SetPublic,"__cTrbAFBAlias",GetNextAlias(),"C",10,.T.,.T.)
    EndIF

    IF (StaticCall(NDJLIB001,GetMemVar,"__cTrbAFBFile")==NIL)
        StaticCall(NDJLIB004,SetPublic,"__cTrbAFBFile",CriaTrab(NIL,.F.),"C",NIL,.T.,.T.)
        __cTrbAFBFile+=".dbf"
    EndIF

    IF (StaticCall(NDJLIB001,GetMemVar,"__aTrbAFBBag")==NIL)
        StaticCall(NDJLIB004,SetPublic,"__aTrbAFBBag",NIL,"A",NIL,.T.,.T.)
        __aTrbAFBBag:=StaticCall(NDJLIB007,GetArrBagName,"__AFB__",__cTrbAFBFile,cRDD)
        __aTrbAFBBag[2][1][1]:="AFB_FILIAL+AFB_PROJET+AFB_REVISA+AFB_TAREFA"
        __aTrbAFBBag[2][1][2]:=&("{ ||"+"AFB_FILIAL+AFB_PROJET+AFB_REVISA+AFB_TAREFA"+"}")
        __aTrbAFBBag[2][1][3]:="__NDJSD001"
        __aTrbAFBBag[2][1][4]:="__NDJSD001"
        __aTrbAFBBag[2][1][5]:="__NDJSD001"
    EndIF

    StaticCall(NDJLIB007,CloseTmpFile,__cTrbAFBAlias,__cTrbAFBFile,__aTrbAFBBag)

    cQuery:="SELECT"+__cCRLF
    cQuery+="        AFB.AFB_FILIAL,"+__cCRLF
    cQuery+="        AFB.AFB_PROJET,"+__cCRLF
    cQuery+="        AFB.AFB_REVISA,"+__cCRLF
    cQuery+="        AFB.AFB_TAREFA,"+__cCRLF
    cQuery+="        SUM(AFB.AFB_VALOR) AFB_VALOR"+__cCRLF
    cQuery+="    FROM"+__cCRLF
    cQuery+="        AFB010 AFB"+__cCRLF
    cQuery+="    WHERE"+__cCRLF
    cQuery+="        AFB.D_E_L_E_T_ =' '"+__cCRLF
    cQuery+="        AND"+__cCRLF
    cQuery+="        AFB.AFB_FILIAL ='"+cAFBFilial+"'"+__cCRLF
    cQuery+="        AND"+__cCRLF
    cQuery+="        AFB.AFB_PROJET ='"+AF8->AF8_PROJET+"'"+__cCRLF
    cQuery+="        AND"+__cCRLF
    cQuery+="        AFB.AFB_REVISA ='"+AF8->AF8_REVISA+"'"+__cCRLF
    cQuery+="    GROUP BY"+__cCRLF
    cQuery+="        AFB.AFB_FILIAL,"+__cCRLF
    cQuery+="        AFB.AFB_PROJET,"+__cCRLF
    cQuery+="        AFB.AFB_REVISA,"+__cCRLF
    cQuery+="        AFB.AFB_TAREFA"+__cCRLF
    cQuery+="    ORDER BY"+__cCRLF
    cQuery+="        AFB.AFB_FILIAL,"+__cCRLF
    cQuery+="        AFB.AFB_PROJET,"+__cCRLF
    cQuery+="        AFB.AFB_REVISA,"+__cCRLF
    cQuery+="        AFB.AFB_TAREFA"+__cCRLF

    TCQUERY (cQuery)ALIAS (cAliasQry)NEW

    TcSetField(cAliasQry,"AFB_VALOR","N",18,2)

    StaticCall(NDJLIB007,MakeTmpFile,@cAliasQry,@__cTrbAFBAlias,@__cTrbAFBFile,{ || .T. },NIL,NIL,@__aTrbAFBBag,NIL,NIL,@cRDD)

    (cAliasQry)->(dbCloseArea())

    //Prepara o Ambiente para a Tabela AJC
    IF ((cAJCAlias ==NIL).or. (cAJCAlias =="AJC"))
        StaticCall(NDJLIB004,SetPublic,"__cTrbAJCAlias",GetNextAlias(),"C",10,.T.,.T.)
    EndIF

    IF (StaticCall(NDJLIB001,GetMemVar,"__cTrbAJCFile")==NIL)
        StaticCall(NDJLIB004,SetPublic,"__cTrbAJCFile",CriaTrab(NIL,.F.),"C",NIL,.T.,.T.)
        __cTrbAJCFile+=".dbf"
    EndIF

    IF (StaticCall(NDJLIB001,GetMemVar,"__aTrbAJCBag")==NIL)
        StaticCall(NDJLIB004,SetPublic,"__aTrbAJCBag",NIL,"A",NIL,.T.,.T.)
        __aTrbAJCBag:=StaticCall(NDJLIB007,GetArrBagName,"__AJC__",__cTrbAJCFile,cRDD)
        __aTrbAJCBag[2][1][1]:="AJC_FILIAL+AJC_PROJET+AJC_REVISA+AJC_TAREFA"
        __aTrbAJCBag[2][1][2]:=&("{ ||"+"AJC_FILIAL+AJC_PROJET+AJC_REVISA+AJC_TAREFA"+"}")
        __aTrbAJCBag[2][1][3]:="__NDJSD001"
        __aTrbAJCBag[2][1][4]:="__NDJSD001"
        __aTrbAJCBag[2][1][5]:="__NDJSD001"
    EndIF

    StaticCall(NDJLIB007,CloseTmpFile,__cTrbAJCAlias,__cTrbAJCFile,__aTrbAJCBag)

    cQuery:="SELECT"+__cCRLF
    cQuery+="        AJC.AJC_FILIAL,"+__cCRLF
    cQuery+="        AJC.AJC_PROJET,"+__cCRLF
    cQuery+="        AJC.AJC_REVISA,"+__cCRLF
    cQuery+="        AJC.AJC_TAREFA,"+__cCRLF
    cQuery+="        SUM(AJC.AJC_CUSTO1) AJC_CUSTO1"+__cCRLF
    cQuery+="    FROM"+__cCRLF
    cQuery+="        AJC010 AJC"+__cCRLF
    cQuery+="    WHERE"+__cCRLF
    cQuery+="        AJC.D_E_L_E_T_ =' '"+__cCRLF
    cQuery+="        AND"+__cCRLF
    cQuery+="        AJC.AJC_FILIAL ='"+cAJCFilial+"'"+__cCRLF
    cQuery+="        AND"+__cCRLF
    cQuery+="        AJC.AJC_PROJET ='"+AF8->AF8_PROJET+"'"+__cCRLF
    cQuery+="        AND"+__cCRLF
    cQuery+="        AJC.AJC_REVISA ='"+AF8->AF8_REVISA+"'"+__cCRLF
    cQuery+="    GROUP BY"+__cCRLF
    cQuery+="        AJC.AJC_FILIAL,"+__cCRLF
    cQuery+="        AJC.AJC_PROJET,"+__cCRLF
    cQuery+="        AJC.AJC_REVISA,"+__cCRLF
    cQuery+="        AJC.AJC_TAREFA"+__cCRLF
    cQuery+="    ORDER BY"+__cCRLF
    cQuery+="        AJC.AJC_FILIAL,"+__cCRLF
    cQuery+="        AJC.AJC_PROJET,"+__cCRLF
    cQuery+="        AJC.AJC_REVISA,"+__cCRLF
    cQuery+="        AJC.AJC_TAREFA"+__cCRLF

    TCQUERY (cQuery)ALIAS (cAliasQry)NEW

    TcSetField(cAliasQry,"AJC_CUSTO1","N",18,2)

    StaticCall(NDJLIB007,MakeTmpFile,@cAliasQry,@__cTrbAJCAlias,@__cTrbAJCFile,{ || .T. },NIL,NIL,@__aTrbAJCBag,NIL,NIL,@cRDD)

    (cAliasQry)->(dbCloseArea())
    
    //Prepara o Ambiente para a Tabela SZ1
    IF ((cSD1Alias ==NIL).or. (cSD1Alias =="SD1"))
        StaticCall(NDJLIB004,SetPublic,"__cTrbSD1Alias",GetNextAlias(),"C",10,.T.,.T.)
    EndIF

    IF (StaticCall(NDJLIB001,GetMemVar,"__cTrbSD1File")==NIL)
        StaticCall(NDJLIB004,SetPublic,"__cTrbSD1File",CriaTrab(NIL,.F.),"C",NIL,.T.,.T.)
        __cTrbSD1File+=".dbf"
    EndIF

    IF (StaticCall(NDJLIB001,GetMemVar,"__aTrbSD1Bag")==NIL)
        StaticCall(NDJLIB004,SetPublic,"__aTrbSD1Bag",NIL,"A",NIL,.T.,.T.)
        __aTrbSD1Bag:=StaticCall(NDJLIB007,GetArrBagName,"__SD1__",__cTrbSD1File,cRDD)
        __aTrbSD1Bag[2][1][1]:="D1_FILIAL+D1_XPROJET+D1_XREVIS+D1_XTAREFA"
        __aTrbSD1Bag[2][1][2]:=&("{ ||"+"D1_FILIAL+D1_XPROJET+D1_XREVIS+D1_XTAREFA"+"}")
        __aTrbSD1Bag[2][1][3]:="__NDJSD001"
        __aTrbSD1Bag[2][1][4]:="__NDJSD001"
        __aTrbSD1Bag[2][1][5]:="__NDJSD001"
    EndIF

    StaticCall(NDJLIB007,CloseTmpFile,__cTrbSD1Alias,__cTrbSD1File,__aTrbSD1Bag)

    cQuery:="SELECT"+__cCRLF
    cQuery+="    SD1.D1_FILIAL,"+__cCRLF
    cQuery+="    SD1.D1_XPROJET,"+__cCRLF
    cQuery+="    SD1.D1_XREVIS,"+__cCRLF
    cQuery+="    SD1.D1_XTAREFA,"+__cCRLF
    cQuery+="    SD1.D1_Z0LINKD,"+__cCRLF
    cQuery+="    SUM(SD1.D1_TOTAL) D1_TOTAL"+__cCRLF
    cQuery+="FROM"+__cCRLF
    cQuery+="    SD1010 SD1"+__cCRLF
    cQuery+="WHERE"+__cCRLF
    cQuery+="    SD1.D_E_L_E_T_ =' '"+__cCRLF
    cQuery+="    AND"+__cCRLF
    cQuery+="    SD1.D1_FILIAL ='"+cSD1Filial+"'"+__cCRLF
    cQuery+="    AND"+__cCRLF
    cQuery+="    SD1.D1_XPROJET ='"+AF8->AF8_PROJET+"'"+__cCRLF
    cQuery+="    AND"+__cCRLF
    cQuery+="    SD1.D1_XREVIS ='"+AF8->AF8_REVISA+"'"+__cCRLF
    cQuery+="    AND"+__cCRLF 
    cQuery+="    SD1.D1_TES <>'"+cSpcTES+"'"+__cCRLF
    cQuery+="GROUP BY"+__cCRLF
    cQuery+="    SD1.D1_FILIAL,"+__cCRLF
    cQuery+="    SD1.D1_XPROJET,"+__cCRLF
    cQuery+="    SD1.D1_XREVIS,"+__cCRLF
    cQuery+="    SD1.D1_XTAREFA,"+__cCRLF
    cQuery+="    SD1.D1_Z0LINKD"+__cCRLF
    cQuery+="ORDER BY"+__cCRLF
    cQuery+="    SD1.D1_FILIAL,"+__cCRLF
    cQuery+="    SD1.D1_XPROJET,"+__cCRLF
    cQuery+="    SD1.D1_XREVIS,"+__cCRLF
    cQuery+="    SD1.D1_XTAREFA,"+__cCRLF
    cQuery+="    SD1.D1_Z0LINKD"+__cCRLF

    TCQUERY (cQuery)ALIAS (cAliasQry)NEW

    TcSetField(cAliasQry,"D1_TOTAL","N",18,2)
    TcSetField(cAliasQry,"D1_Z0LINKD","L",1,0)

    StaticCall(NDJLIB007,MakeTmpFile,@cAliasQry,@__cTrbSD1Alias,@__cTrbSD1File,{ || .T. },NIL,NIL,@__aTrbSD1Bag,NIL,NIL,@cRDD)

    (cAliasQry)->(dbCloseArea())

    //Prepara o Ambiente para a Tabela SZ0
    IF ((cSZ0Alias ==NIL).or. (cSZ0Alias =="SZ0"))
        StaticCall(NDJLIB004,SetPublic,"__cTrbSZ0Alias",GetNextAlias(),"C",10,.T.,.T.)
    EndIF

    IF (StaticCall(NDJLIB001,GetMemVar,"__cTrbSZ0File")==NIL)
        StaticCall(NDJLIB004,SetPublic,"__cTrbSZ0File",CriaTrab(NIL,.F.),"C",NIL,.T.,.T.)
        __cTrbSZ0File+=".dbf"
    EndIF

    IF (StaticCall(NDJLIB001,GetMemVar,"__aTrbSZ0Bag")==NIL)
        StaticCall(NDJLIB004,SetPublic,"__aTrbSZ0Bag",NIL,"A",NIL,.T.,.T.)
        __aTrbSZ0Bag:=StaticCall(NDJLIB007,GetArrBagName,"__SZ0__",__cTrbSZ0File,cRDD)
        __aTrbSZ0Bag[2][1][1]:="Z0_FILIAL+Z0_XFILIAL+Z0_ALIAS+Z0_PROJETO+Z0_REVISAO+Z0_TAREFA"
        __aTrbSZ0Bag[2][1][2]:=&("{ ||"+"Z0_FILIAL+Z0_XFILIAL+Z0_ALIAS+Z0_PROJETO+Z0_REVISAO+Z0_TAREFA"+"}")
        __aTrbSZ0Bag[2][1][3]:="__NDJSZ001"
        __aTrbSZ0Bag[2][1][4]:="__NDJSZ001"
        __aTrbSZ0Bag[2][1][5]:="__NDJSZ001"
    EndIF

    StaticCall(NDJLIB007,CloseTmpFile,__cTrbSZ0Alias,__cTrbSZ0File,__aTrbSZ0Bag)

    cQuery:="SELECT"+__cCRLF
    cQuery+="    SZ0.Z0_FILIAL,"+__cCRLF
    cQuery+="    SZ0.Z0_XFILIAL,"+__cCRLF
    cQuery+="    SZ0.Z0_ALIAS,"+__cCRLF
    cQuery+="    SZ0.Z0_PROJETO,"+__cCRLF
    cQuery+="    SZ0.Z0_REVISAO,"+__cCRLF
    cQuery+="    SZ0.Z0_TAREFA,"+__cCRLF
    cQuery+="    SZ0.Z0_LINKED,"+__cCRLF
    cQuery+="    SUM(SZ0.Z0_VALOR) Z0_VALOR"+__cCRLF
    cQuery+="FROM"+__cCRLF
    cQuery+="    SZ0010 SZ0"+__cCRLF
    cQuery+="WHERE"+__cCRLF
    cQuery+="    SZ0.D_E_L_E_T_ =' '"+__cCRLF
    cQuery+="    AND"+__cCRLF
    cQuery+="    SZ0.Z0_FILIAL ='"+cSZ0Filial+"'"+__cCRLF
    cQuery+="    AND"+__cCRLF
    cQuery+="    SZ0.Z0_LINKED ='T'"+__cCRLF
    cQuery+="    AND"+__cCRLF
    cQuery+="    SZ0.Z0_PROJETO ='"+AF8->AF8_PROJET+"'"+__cCRLF
    cQuery+="    AND"+__cCRLF
    cQuery+="    SZ0.Z0_REVISAO ='"+AF8->AF8_REVISA+"'"+__cCRLF
    cQuery+="GROUP BY"+__cCRLF
    cQuery+="    SZ0.Z0_FILIAL,"+__cCRLF
    cQuery+="    SZ0.Z0_XFILIAL,"+__cCRLF
    cQuery+="    SZ0.Z0_ALIAS,"+__cCRLF
    cQuery+="    SZ0.Z0_PROJETO,"+__cCRLF
    cQuery+="    SZ0.Z0_REVISAO,"+__cCRLF
    cQuery+="    SZ0.Z0_TAREFA,"+__cCRLF
    cQuery+="    SZ0.Z0_LINKED"+__cCRLF
    cQuery+="ORDER BY"+__cCRLF
    cQuery+="    SZ0.Z0_FILIAL,"+__cCRLF
    cQuery+="    SZ0.Z0_XFILIAL,"+__cCRLF
    cQuery+="    SZ0.Z0_ALIAS,"+__cCRLF
    cQuery+="    SZ0.Z0_PROJETO,"+__cCRLF
    cQuery+="    SZ0.Z0_REVISAO,"+__cCRLF
    cQuery+="    SZ0.Z0_TAREFA,"+__cCRLF
    cQuery+="    SZ0.Z0_LINKED"+__cCRLF

    TCQUERY (cQuery)ALIAS (cAliasQry)NEW

    TcSetField(cAliasQry,"Z0_VALOR","N",18,2)
    TcSetField(cAliasQry,"Z0_LINKED","L",1,0)

    StaticCall(NDJLIB007,MakeTmpFile,@cAliasQry,@__cTrbSZ0Alias,@__cTrbSZ0File,{ || .T. },NIL,NIL,@__aTrbSZ0Bag,NIL,NIL,@cRDD)

    (cAliasQry)->(dbCloseArea())

    IF (Select(cAlias)>0)
        dbSelectArea(cAlias)
    Else
        dbSelectArea("AF8")
    EndIF

Return(NIL)

/*/
    Funcao:EmpFrmClose
    Autor:Marinaldo de Jesus
    Data:02/09/2011
    Descricao:Encerrar arquivos de Trabalhos com Informacoes de Empenho (SZ0) e Realizado (SD1) para uso em Formulas
    Uso:Formulas de Valores Empenhados e Realizados
    Sintaxe:StaticCall(U_NDJBLKSCVL,EmpFrmClose)
/*/
Static Function EmpFrmClose()

    Local cAFBAlias:=StaticCall(NDJLIB001,GetMemVar,"__cTrbAFBAlias")
    Local cAJCAlias:=StaticCall(NDJLIB001,GetMemVar,"__cTrbAJCAlias")
    Local cSD1Alias:=StaticCall(NDJLIB001,GetMemVar,"__cTrbSD1Alias")
    Local cSZ0Alias:=StaticCall(NDJLIB001,GetMemVar,"__cTrbSZ0Alias")

    IF (!(cAFBAlias ==NIL).and. !(cAFBAlias =="AFB"))
        TRYEXCEPTION
            StaticCall(NDJLIB007,CloseTmpFile,__cTrbAFBAlias,__cTrbAFBFile,__aTrbAFBBag)
        ENDEXCEPTION
    EndIF    

    IF (!(cAJCAlias ==NIL).and. !(cAJCAlias =="AJC"))
        TRYEXCEPTION
            StaticCall(NDJLIB007,CloseTmpFile,__cTrbAJCAlias,__cTrbAJCFile,__aTrbAJCBag)
        ENDEXCEPTION
    EndIF    
    
    IF (!(cSZ0Alias ==NIL).and. !(cSZ0Alias =="SZ0"))
        TRYEXCEPTION
            StaticCall(NDJLIB007,CloseTmpFile,__cTrbSZ0Alias,__cTrbSZ0File,__aTrbSZ0Bag)
        ENDEXCEPTION
    EndIF    

    IF (!(cSD1Alias ==NIL).and. !(cAFBAlias =="SD1"))
        TRYEXCEPTION
            StaticCall(NDJLIB007,CloseTmpFile,__cTrbSD1Alias,__cTrbSD1File,__aTrbSD1Bag)
        ENDEXCEPTION
    EndIF    

Return(NIL)

/*/
    Funcao:FrmPrevisto
    Autor:Marinaldo de Jesus
    Data:08/01/2011
    Descricao:Obter os Valores Previstos
    Uso:Formula de Valor Previsto no PMS
    Sintaxe:StaticCall(U_NDJBLKSCVL,FrmPrevisto)
/*/
Static Function FrmPrevisto()

    Local bEvalSkip:={ || .F. }
    Local bFieldsWhile:={ || AFB_FILIAL+AFB_PROJET+AFB_REVISA }

    Local cAlias:=__cTrbAFBAlias
    Local cProjeto:=AF8->AF8_PROJET
    Local cRevisao:=AF8->AF8_REVISA
    Local cTarefa:=""

    Local cFil:=xFilial(cAlias)
    Local cKeySeek:=(cFil+cProjeto+cRevisao)
    Local cIndexKey:="AFB_FILIAL+AFB_PROJET+AFB_REVISA+AFB_TAREFA"
    Local cAF8FldPut:="AF8_XCUPRE"
    Local cProcName1:="FrmPrevisto"

    Local cFieldTot:="AFB_VALOR"
    Local cFldTarefa:="AFB_TAREFA"

Return(FrmGetEmpVal(@cAlias,@cFil,@cKeySeek,@cIndexKey,@cProjeto,@cRevisao,@cTarefa,@cFieldTot,@cFldTarefa,@bFieldsWhile,@bEvalSkip,@cAF8FldPut,@cProcName1)) 

/*/
    Funcao:FrmEmpenho
    Autor:Marinaldo de Jesus
    Data:08/01/2011
    Descricao:Obter os Valores Empenhados
    Uso:Formula de Valor Empenhado no PMS
    Sintaxe:StaticCall(U_NDJBLKSCVL,FrmEmpenho)
/*/
Static Function FrmEmpenho()

    Local nValor:=SZ0FrmEmpenho("SC1")

    nValor+=SZ0FrmEmpenho("SC7")

Return(nValor)

/*/
    Funcao:SZ0FrmEmpenho
    Autor:Marinaldo de Jesus
    Data:17/08/2011
    Descricao:Obter os Valores Empenhados
    Uso:Formula de Valor Empenhado no PMS
    Sintaxe:StaticCall(U_NDJBLKSCVL,SZ0FrmEmpenho,cAliasSZ0)
/*/
Static Function SZ0FrmEmpenho(cAliasSZ0)

    Local bEvalSkip:={ || !(Z0_LINKED).or. !(cAliasSZ0 ==Z0_ALIAS)}
    Local bFieldsWhile:={ || Z0_FILIAL+Z0_XFILIAL+Z0_ALIAS+Z0_PROJETO+Z0_REVISAO }

    Local cAlias:=__cTrbSZ0Alias
    Local cProjeto:=AF8->AF8_PROJET
    Local cRevisao:=AF8->AF8_REVISA
    Local cTarefa:=""

    Local cFil:=xFilial(cAlias)
    Local cxFil:=xFilial(cAliasSZ0)
    Local cKeySeek:=(cFil+cxFil+cAliasSZ0+cProjeto+cRevisao)
    Local cIndexKey:="Z0_FILIAL+Z0_XFILIAL+Z0_ALIAS+Z0_PROJETO+Z0_REVISAO+Z0_TAREFA"
    Local cAF8FldPut:="AF8_XCUEMP"
    Local cProcName1:="FrmEmpenho"

    Local cFieldTot:="Z0_VALOR"
    Local cFldTarefa:="Z0_TAREFA"

Return(FrmGetEmpVal(@cAlias,@cFil,@cKeySeek,@cIndexKey,@cProjeto,@cRevisao,@cTarefa,@cFieldTot,@cFldTarefa,@bFieldsWhile,@bEvalSkip,@cAF8FldPut,@cProcName1)) 

/*/
    Funcao:SC1FrmEmpenho
    Autor:Marinaldo de Jesus
    Data:17/08/2011
    Descricao:Obter os Valores Empenhados
    Uso:Formula de Valor Empenhado no PMS
    Sintaxe:StaticCall(U_NDJBLKSCVL,SC1FrmEmpenho)
/*/
Static Function SC1FrmEmpenho()

    Local bEvalSkip:={ || !(C1_Z0LINKD).or. ((C1_MSBLQL =="1").AND. (C1_APROV =="R")) }
    Local bFieldsWhile:={ || C1_FILIAL+C1_XPROJET+C1_XREVISA }

    Local cAlias:="SC1"
    Local cProjeto:=AF8->AF8_PROJET
    Local cRevisao:=AF8->AF8_REVISA
    Local cTarefa:=""

    Local cFil:=xFilial(cAlias)
    Local cKeySeek:=(cFil+cProjeto+cRevisao)
    Local cIndexKey:="C1_FILIAL+C1_XPROJET+C1_XREVISA+C1_XTAREFA+C1_NUM+C1_ITEM"
    Local cAF8FldPut:="AF8_XCUEMP"
    Local cProcName1:="FrmEmpenho" 

    Local cFieldTot:="C1_XTOTAL"
    Local cFldTarefa:="C1_XTAREFA"

Return(FrmGetEmpVal(@cAlias,@cFil,@cKeySeek,@cIndexKey,@cProjeto,@cRevisao,@cTarefa,@cFieldTot,@cFldTarefa,@bFieldsWhile,@bEvalSkip,@cAF8FldPut,@cProcName1)) 

/*/
    Funcao:SC7FrmEmpenho
    Autor:Marinaldo de Jesus
    Data:17/08/2011
    Descricao:Obter os Valores Empenhados
    Uso:Formula de Valor Empenhado no PMS
    Sintaxe:StaticCall(U_NDJBLKSCVL,SC7FrmEmpenho)
/*/
Static Function SC7FrmEmpenho()

    Local bEvalSkip:={ || .F. }
    Local bFieldsWhile:={ || C7_FILIAL+C7_XPROJET+C7_XREVISA }

    Local cAlias:="SC7"
    Local cProjeto:=AF8->AF8_PROJET
    Local cRevisao:=AF8->AF8_REVISA
    Local cTarefa:=""

    Local cFil:=xFilial(cAlias)
    Local cKeySeek:=(cFil+cProjeto+cRevisao)
    Local cIndexKey:="C7_FILIAL+C7_XPROJET+C7_XREVIS+C7_XTAREFA+C7_NUM+C7_ITEM+C7_SEQUEN"
    Local cAF8FldPut:="AF8_XCUEMP"
    Local cProcName1:="FrmEmpenho" 

    Local cFieldTot:="C7_XTOTAL"
    Local cFldTarefa:="C7_XTAREFA"

Return(FrmGetEmpVal(@cAlias,@cFil,@cKeySeek,@cIndexKey,@cProjeto,@cRevisao,@cTarefa,@cFieldTot,@cFldTarefa,@bFieldsWhile,@bEvalSkip,@cAF8FldPut,@cProcName1))

/*/
    Funcao:FrmRealizado
    Autor:Marinaldo de Jesus
    Data:08/01/2011
    Descricao:Obter os Valores Realizados
    Uso:Formula de Valor Realizado no PMS
    Sintaxe:StaticCall(U_NDJBLKSCVL,FrmRealizado)
/*/
Static Function FrmRealizado()

    Local cProjeto:=AF8->AF8_PROJET
    Local cRevisao:=AF8->AF8_REVISA
    Local cAF8FldPut:="AF8_XCUREA"

    Local lTarefa:=.F.

    Local nTotal:=0

    nTotal:=SD1Realizado()
    nTotal+=AJCRealizado(@lTarefa)

    IF (;
            !(lTarefa);
            .and.;
            IsInCallStack("PMSPLNCALC");
  )
        AF8PutVal(@cProjeto,@cRevisao,@cAF8FldPut,@nTotal,.T.)
    EndIF

Return(nTotal)

/*/
    Funcao:SD1Realizado
    Autor:Marinaldo de Jesus
    Data:08/01/2011
    Descricao:Obter os Valores Realizados da Tabela SD1
    Uso:Formula de Valor Realizado no PMS Referente ao SD1
    Sintaxe:StaticCall(U_NDJBLKSCVL,FrmRealizado)
/*/
Static Function SD1Realizado()

    Local bEvalSkip:={ || .F. }
    Local bFieldsWhile:={ || D1_FILIAL+D1_XPROJET+D1_XREVIS }

    Local cAlias:=__cTrbSD1Alias
    Local cProjeto:=AF8->AF8_PROJET
    Local cRevisao:=AF8->AF8_REVISA
    Local cTarefa:="" 
    Local cSpcTES:=Space(GetSx3Cache("D1_TES","X3_TAMANHO"))

    Local cFil:=xFilial(cAlias)
    Local cKeySeek:=(cFil+cProjeto+cRevisao)
    Local cIndexKey:="D1_FILIAL+D1_XPROJET+D1_XREVIS+D1_XTAREFA"
    Local cAF8FldPut:=""
    Local cProcName1:="FrmRealizado" 

    Local cFieldTot:="D1_TOTAL"
    Local cFldTarefa:="D1_XTAREFA"

Return(FrmGetEmpVal(@cAlias,@cFil,@cKeySeek,@cIndexKey,@cProjeto,@cRevisao,@cTarefa,@cFieldTot,@cFldTarefa,@bFieldsWhile,@bEvalSkip,@cAF8FldPut,@cProcName1)) 

/*/
    Funcao:AJCRealizado
    Autor:Marinaldo de Jesus
    Data:08/01/2011
    Descricao:Obter os Valores Realizados da Tabela AJC
    Uso:Formula de Valor Realizado no PMS Referente ao AJC
    Sintaxe:StaticCall(U_NDJBLKSCVL,FrmRealizado)
/*/
Static Function AJCRealizado(lTarefa)

    Local bEvalSkip:={ || .F. }
    Local bFieldsWhile:={ || AJC_FILIAL+AJC_PROJET+AJC_REVISA }

    Local cAlias:=__cTrbAJCAlias
    Local cProjeto:=AF8->AF8_PROJET
    Local cRevisao:=AF8->AF8_REVISA
    Local cTarefa:="" 

    Local cFil:=xFilial(cAlias)
    Local cKeySeek:=(cFil+cProjeto+cRevisao)
    Local cIndexKey:="AJC_FILIAL+AJC_PROJET+AJC_REVISA+AJC_TAREFA"
    Local cAF8FldPut:=""
    Local cProcName1:="AJCRealizado" 

    Local cFieldTot:="AJC_CUSTO1"
    Local cFldTarefa:="AJC_TAREFA"

Return(FrmGetEmpVal(@cAlias,@cFil,@cKeySeek,@cIndexKey,@cProjeto,@cRevisao,@cTarefa,@cFieldTot,@cFldTarefa,@bFieldsWhile,@bEvalSkip,@cAF8FldPut,@cProcName1,@lTarefa)) 

/*/
    Funcao:FrmRealEmpenhado
    Autor:Marinaldo de Jesus
    Data:22/07/2011
    Descricao:Obter os Valores Realizados que nao Foram Empenhados via SC
    Uso:Formula de Valor Realizado no PMS
    Sintaxe:StaticCall(U_NDJBLKSCVL,FrmRealEmpenhado)
/*/
Static Function FrmRealEmpenhado()

    Local nTotal:=SD1RealEmpenhado()

Return(nTotal)

/*/
    Funcao:SD1RealEmpenhado()
    Autor:Marinaldo de Jesus
    Data:08/01/2011
    Descricao:Obter os Valores Realizados da Tabela SD1 que nao Foram Empenhados via SC
    Uso:FrmNaoEmpenhado
    Sintaxe:StaticCall(U_NDJBLKSCVL,SD1RealEmpenhado)
/*/
Static Function SD1RealEmpenhado()

    Local bEvalSkip:={ || !(D1_Z0LINKD)}
    Local bFieldsWhile:={ || D1_FILIAL+D1_XPROJET+D1_XREVIS }

    Local cAlias:=__cTrbSD1Alias
    Local cProjeto:=AF8->AF8_PROJET
    Local cRevisao:=AF8->AF8_REVISA
    Local cTarefa:="" 
    Local cD1Pedido:=Space(GetSx3Cache("D1_PEDIDO","X3_TAMANHO"))

    Local cFil:=xFilial(cAlias)
    Local cKeySeek:=(cFil+cProjeto+cRevisao)
    Local cIndexKey:="D1_FILIAL+D1_XPROJET+D1_XREVIS+D1_XTAREFA"
    Local cAF8FldPut:=""
    Local cProcName1:="FrmRealEmpenhado" 

    Local cFieldTot:="D1_TOTAL"
    Local cFldTarefa:="D1_XTAREFA"

Return(FrmGetEmpVal(@cAlias,@cFil,@cKeySeek,@cIndexKey,@cProjeto,@cRevisao,@cTarefa,@cFieldTot,@cFldTarefa,@bFieldsWhile,@bEvalSkip,@cAF8FldPut,@cProcName1)) 

/*/
    Funcao:FrmNaoEmpenhado
    Autor:Marinaldo de Jesus
    Data:22/07/2011
    Descricao:Obter os Valores Realizados que nao Foram Empenhados via SC
    Uso:Formula de Valor Realizado no PMS
    Sintaxe:StaticCall(U_NDJBLKSCVL,FrmNaoEmpenhado)
/*/
Static Function FrmNaoEmpenhado()

    Local nTotal:=SD1NaoEmpenhado()

Return(nTotal)

/*/
    Funcao:SD1NaoEmpenhado()
    Autor:Marinaldo de Jesus
    Data:08/01/2011
    Descricao:Obter os Valores Realizados da Tabela SD1 que nao Foram Empenhados via SC
    Uso:FrmNaoEmpenhado
    Sintaxe:StaticCall(U_NDJBLKSCVL,SD1NaoEmpenhado)
/*/
Static Function SD1NaoEmpenhado()

    Local bEvalSkip:={ || (D1_Z0LINKD)}
    Local bFieldsWhile:={ || D1_FILIAL+D1_XPROJET+D1_XREVIS }

    Local cAlias:=__cTrbSD1Alias
    Local cProjeto:=AF8->AF8_PROJET
    Local cRevisao:=AF8->AF8_REVISA
    Local cTarefa:="" 
    Local cD1Pedido:=Space(GetSx3Cache("D1_PEDIDO","X3_TAMANHO"))

    Local cFil:=xFilial(cAlias)
    Local cKeySeek:=(cFil+cProjeto+cRevisao)
    Local cIndexKey:="D1_FILIAL+D1_XPROJET+D1_XREVIS+D1_XTAREFA"
    Local cAF8FldPut:=""
    Local cProcName1:="FrmNaoEmpenhado" 

    Local cFieldTot:="D1_TOTAL"
    Local cFldTarefa:="D1_XTAREFA"

Return(FrmGetEmpVal(@cAlias,@cFil,@cKeySeek,@cIndexKey,@cProjeto,@cRevisao,@cTarefa,@cFieldTot,@cFldTarefa,@bFieldsWhile,@bEvalSkip,@cAF8FldPut,@cProcName1)) 

/*/
    Funcao:FrmGetEmpVal
    Autor:Marinaldo de Jesus
    Data:08/01/2011
    Descricao:Obter os Valores de Empenho
    Uso:Usado nas Funcoes de Formulas de Valores Previstos,Empenhados e Realizados
    Sintaxe:vide parametros formais
/*/
Static Function FrmGetEmpVal(cAlias,cFil,cKeySeek,cIndexKey,cProjeto,cRevisao,cTarefa,cFieldTot,cFldTarefa,bFieldsWhile,bEvalSkip,cAF8FldPut,cProcName1,lTarefa,lForceTable)

    Local aTSup

    Local bRetWhile
    Local bSkipCond
    Local bWhileCond

    Local cTarefaSup:=""
    Local cCtrlNivel
    Local cAlias4Fld:=Alias()

    Local lLastNivel:=.F.

    Local nLoop
    Local nLoops
    Local nTotal:=0
    Local nFieldTot
    Local nTarefaSup
    Local nNivelTree
    Local nIndexOrder
    Local nFieldTarefa

    lTarefa:=.F.

    IF (;
            (cAlias4Fld)->(FieldPos("XF9_TAREFA")>0);
            .or.;
            (cAlias4Fld:="",StaticCall(NDJLIB001,GetAlias4Fields,@cAlias4Fld,{ "XF9_TAREFA" }));
)
        lTarefa:=!(cProjeto $ (cAlias4Fld)->XF9_TAREFA)
        IF (lTarefa)
            cCtrlNivel:=(cAlias4Fld)->CTRLNIV
            nNivelTree:=(cAlias4Fld)->NIVTREE
            lLastNivel:=(Empty(nNivelTree).or. Empty(cCtrlNivel))
            cTarefa:=Padr((cAlias4Fld)->XF9_TAREFA,GetSX3Cache("AF9_TAREFA","X3_TAMANHO"))
            IF (lLastNivel)
                cKeySeek+=cTarefa
            EndIF    
        EndIF    
    EndIF    

    DEFAULT cProcName1:=ProcName(1)
    IF !(__cStkFrmTot ==(cProcName1+cEmpAnt+cKeySeek+cTarefa))

        nFieldTot:=(cAlias)->(FieldPos(cFieldTot))
        bRetWhile:={ || nTotal+=FieldGet(nFieldTot)}
        nFieldTarefa:=(cAlias)->(FieldPos(cFldTarefa))

        IF (;
                (lTarefa);
                .and.;
                !(lLastNivel);
  )
            aTSup:=StrTokArr2(cTarefa,".")
            nLoops:=Len(aTSup)
            For nLoop:=1 To nLoops
                cTarefaSup+=aTSup[ nLoop ]
                IF (nLoop < nLoops)
                    cTarefaSup+="."
                ElseIF ((nLoop+1)>=nLoops)
                    Exit
                EndIF
            Next nLoop
            cTarefaSup:=AllTrim (cTarefaSup)
            nTarefaSup:=Len(cTarefaSup)
            bSkipCond:={ || !(SubStr(FieldGet(nFieldTarefa),1,nTarefaSup)==cTarefaSup).or. Eval(bEvalSkip)}
        Else
            bSkipCond:=bEvalSkip
        EndIF

        nIndexOrder:=RetOrder(cAlias,cIndexKey)

        bWhileCond:={ || Eval(bFieldsWhile)+IF(lLastNivel,FieldGet(nFieldTarefa),"")==cKeySeek }

        dbExeWhile(cAlias,@nIndexOrder,@nTotal,@bRetWhile,@cKeySeek,@bWhileCond,@bSkipCond)

        __cStkFrmTot:=(cProcName1+cEmpAnt+cKeySeek+cTarefa)
        __nStkFrmTot:=nTotal

        IF !(lTarefa)

            IF (;
                    !Empty(cAF8FldPut);
                    .and.;
                    IsInCallStack("PMSPLNCALC");
      )
            
                AF8PutVal(@cProjeto,@cRevisao,@cAF8FldPut,@nTotal,@lForceTable)
                
            ENDIF    

        EndIF

    Else

        nTotal:=__nStkFrmTot

    EndIF    

Return(nTotal)

/*/
    Funcao:AF8PutVal
    Autor:Marinaldo de Jesus
    Data:23/03/2011
    Descricao:Gravar informacoes em campo da Tabela AF8
    Sintaxe:vide parametros formais
/*/
Static Function AF8PutVal(cProjeto,cRevisao,cAF8FldPut,uCntPut,lForceTable)

    Local aArea:=GetArea()
    Local aAF8Area:=AF8->(GetArea())

    Local cAlias:="AF8"
    Local cAF8Filial:=xFilial(@cAlias)
    Local cAF8KeySeek:=(cAF8Filial+cProjeto+cRevisao)

    Local nAF8Order:=RetOrder(@cAlias,"AF8_FILIAL+AF8_PROJET+AF8_REVISA")

    nAF8Order:=RetOrder("AF8","AF8_FILIAL+AF8_PROJET+AF8_REVISA")
    cAF8Filial:=xFilial("AF8")
    cAF8KeySeek:=(cAF8Filial+cProjeto+cRevisao)
    (cAlias)->(dbSetOrder(nAF8Order))
    IF (cAlias)->(dbSeek(cAF8KeySeek,.F.))
        DEFAULT lForceTable:=.T.
        StaticCall(NDJLIB001,__FieldPut,@cAlias,@cAF8FldPut,@uCntPut,@lForceTable)
    EndIF    

    RestArea(aAF8Area)
    RestArea(aArea)

Return(NIL)

/*/
    Funcao:SZ0ZeraVal
    Autor:Marinaldo de Jesus
    Data:18/05/2011
    Descricao:Zerar o Valor Empenhado de Acordo com Condicao passada por parametro
    Sintaxe:StaticCall(U_NDJBLKSCVL,SZ0ZeraVal,cWhere,[ lClearQuery ])
/*/
Static Function SZ0ZeraVal(cWhere,lClearQuery)

    Local cQuery:=""
    Local cSZ0SQLName

    BEGIN SEQUENCE

        IF Empty(cWhere)
            BREAK
        EndIF

        cSZ0SQLName:=RetSqlName("SZ0")

        cQuery:="UPDATE"+__cCRLF
        cQuery+="    "+cSZ0SQLName+__cCRLF
        cQuery+="SET"+__cCRLF
        cQuery+="    "+cSZ0SQLName+".Z0_VALOR =0"+__cCRLF
        cQuery+="WHERE"+__cCRLF
        cQuery+="    "+cSZ0SQLName+".Z0_VALOR >0"+__cCRLF
        cQuery+="AND"+__cCRLF
        cQuery+=cWhere

        DEFAULT lClearQuery:=.F.
        IF (lClearQuery)
            cQuery:=StaticCall(NDJLIB001,ClearQuery,cQuery)
        EndIF    

        TcSqlExec(cQuery)

    END SEQUENCE

Return(NIL)

/*/
    Funcao:NDJIniNoBlk
    Autor:Marinaldo de Jesus
    Data:24/05/2011
    Descricao:Verifica se O Projeto Esta Livre do Bloqueio
    Sintaxe:StaticCall(U_NDJBLKSCVL,NDJIniNoBlk,cProjeto)
/*/
Static Function NDJIniNoBlk(cProjeto)

    Local aSponsors
    Local aManagers

    Local cIniFile
    Local cSponsors
    Local cManagers
    Local cAF8Filial
    Local cNoBlkLKey

    Local cAF8KeySeek

    Local lNoBlk:=.F.

    Local nPos
    
    Local nSBLoop
    Local nSELoop

    Local nMBLoop
    Local nMELoop
    
    Local nAF8Order
    
    Static __aNoBlk
    Static __cNoBlkLKey

    BEGIN SEQUENCE

        IF Empty(cProjeto)
            BREAK
        EndIF

        IF !(Type("cEmpAnt")=="C")
            Private cEmpAnt:=""
        EndIF

        cAF8Filial:=xFilial("AF8")
        cAF8KeySeek:=(cAF8Filial+cProjeto)
        cNoBlkKey:=(cEmpAnt+cAF8KeySeek)

        DEFAULT __cNoBlkLKey:="__cNoBlkLKey"
        IF !(__cNoBlkLKey ==cEmpAnt)
            __cNoBlkLKey:=cEmpAnt
            __aNoBlk:={}
        EndIF

        nPos:=aScan(__aNoBlk,{ |aNoBlk| (aNoBlk[ 1 ] ==cNoBlkKey)})
        IF (nPos ==0)
        
            aAdd(__aNoBlk,{ cNoBlkKey,.F. })

            nPos:=Len(__aNoBlk)
            cIniFile:=NDJ_INI_FILE
            cSponsors:=StaticCall(NDJLIB019,IniGetPValue,cIniFile,"NoBlockByValue","sponsors_not_block_by_value","NO_FOUND",";")
            cManagers:=StaticCall(NDJLIB019,IniGetPValue,cIniFile,"NoBlockByValue","managers_not_block_by_value","NO_FOUND",";")
            IF (;
                    (cSponsors =="NO_FOUND");
                    .and.;
                    (cManagers =="NO_FOUND");
      )
                BREAK
            EndIF

            aSponsors:=StrTokArr2(cSponsors,",")
            nSELoop:=Len(aSponsors)

            aManagers:=StrTokArr2(cManagers,",")
            nMELoop:=Len(aSponsors)

            nAF8Order:=RetOrder("AF8","AF8_FILIAL+AF8_PROJET")

            AF8->(dbSetOrder(nAF8Order))
            
            IF AF8->(!dbSeek(cAF8KeySeek,.F.))
                BREAK
            EndIF
            
            While AF8->(!Eof() .and. cAF8KeySeek ==AF8_FILIAL+AF8_PROJET)
                For nSBLoop:=1 To nSELoop
                    IF (lNoBlk:=(aSponsors[ nSBLoop ] ==StaticCall(NDJLIB001,__FieldGet,"AF8","AF8_XCODSP",.T.)))
                        __aNoBlk[ nPos ][ 2 ]:=.T.
                        BREAK
                    EndIF
                Next nSBLoop
                For nMBLoop:=1 To nMELoop
                    IF (lNoBlk:=(aManagers[ nMBLoop ] ==StaticCall(NDJLIB001,__FieldGet,"AF8","AF8_XCODGE",.T.)))
                        __aNoBlk[ nPos ][ 2 ]:=.T.
                        BREAK
                    EndIF
                Next nMBLoop
                AF8->(dbSkip())
            End While

        EndIF

        lNoBlk:=__aNoBlk[ nPos ][ 2 ]

    END SEQUENCE

Return(lNoBlk)

/*/
    Funcao:ChkMaxLock
    Autor:Marinaldo de Jesus
    Data:24/05/2011
    Descricao:Verifica se Extrapolou a Quantidade de Locks permitidos
    Sintaxe:ChkMaxLock()
/*/
Static Function ChkMaxLock()
    //Forca o Commit das Alteracoes de Empenho
    SZ0TTSCommit()
    IF (++__nLocks >1000)
        __nLocks:=0
        StaticCall(NDJLIB003,AliasUnLock)
    EndIF
Return(NIL)

Static Function __Dummy(lRecursa)
    Local oException
    TRYEXCEPTION
        lRecursa:=.F.
        IF !(lRecursa)
            BREAK
        EndIF
        C1QUANTVLD()
        C1XPRECOVLD()
        C7PRECOVLD()
        C7QUANTVLD()
        D1QUANTVLD()
        D1VUNITVLD()
        FRMEMPENHO()
        FRMPREVISTO()
        FRMREALIZADO()
        SZ0ZeraVal()
        FrmRealEmpenhado()
        FrmNaoEmpenhado()
        CNEQUANTVLD()
        CNEVLUNITVLD()
        CNBQUANTVLD()
        CNBVLUNITVLD()
        CNATOSZ0()
        CNFTOSZ0()
        ALIASSZ0LNK()
        SC1FRMEMPENHO()
        SC7FRMEMPENHO()
        EmpFrmTrab()
        lRecursa:=__Dummy(.F.)
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return(lRecursa)
