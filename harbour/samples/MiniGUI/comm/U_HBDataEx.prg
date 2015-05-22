#INCLUDE "NDJ.CH"

#DEFINE HBDataExCommPath    "D:\totvs\p10\ndj\pdata\comm"
#DEFINE MULTDATA_TEST        50

//------------------------------------------------------------------------------------------------
    /*/
        Procedure:HBDataEx 
        Autor:Marinaldo de Jesus
        Data:22/02/2012
        Descricao:Exemplo de Uso de GetData e SendData
        Sintaxe:U_HBDataEx
    /*/
//------------------------------------------------------------------------------------------------
USER PROCEDURE HBDataEx()
    MsgRun("Aguarde....","Enviando Dados",{||HBSDataEx()})
    MsgRun("Aguarde....","Obtendo Dados" ,{||HBGDataEx()})
    IF MsgNoYes("Reenviar os Dados")
        MsgRun("Aguarde....","Enviando Dados",{||HBSDataEx()})
    EndIF
Return

//------------------------------------------------------------------------------------------------
    /*/
        Procedure:HBGDataEx
        Autor:Marinaldo de Jesus
        Data:22/02/2012
        Descricao:Exemplo de Uso da GetData
        Sintaxe:HBGDataEx
    /*/
//------------------------------------------------------------------------------------------------
Static Procedure HBGDataEx()

    Local aData
    Local oData

    Set StationName To "John_Station"
    Set CommPath    To HBDataExCommPath

    aData:=StaticCall(NDJLIB023,GetAllData)
    oData:=U_TVarInfoNew(aData,"HbGetData")
    oData:Save(.T.,.F.)
    oData:Show()
    
    Sleep(3000) //Wait 3 seconds to erase files

    oData:Close(.T.,.T.)

    oData:=NIL

Return

//------------------------------------------------------------------------------------------------
    /*/
        Procedure:HBSDataEx
        Autor:Marinaldo de Jesus
        Data:22/02/2012
        Descricao:Exemplo de Uso da SendData
        Sintaxe:HBSDataEx
    /*/
//------------------------------------------------------------------------------------------------
Static Procedure HBSDataEx()

    Local aData
    Local aMultData
    Local cDest:="John_Station"

    Local nI
    Local nF:=MULTDATA_TEST
    Local nB
    Local nT

    Set StationName To "Robert_Station"
    Set CommPath    To HBDataExCommPath

    StaticCall(NDJLIB023,SendData,cDest,"Olá")
    StaticCall(NDJLIB023,SendData,cDest,123456.789)
    StaticCall(NDJLIB023,SendData,cDest,.T.)
    StaticCall(NDJLIB023,SendData,cDest,.F.)
    StaticCall(NDJLIB023,SendData,cDest,Date())
    StaticCall(NDJLIB023,SendData,cDest,Dtos(Date()))

    aData:={;
                     {"Naldo"    ,Date()    ,.T.                ,1500.51   },;
                     {"OverFail" ,Date()-100,.F.                ,1500.52*4 },;
                     {"RLeg"     ,Date()+100,.F. .or. .T.       ,1500.53/2 },;
                     {"OBona"    ,Date()-100,.T. .and. .F.      ,1500.54*100},;
                     {"LF Altran",Date()+100,.NOT. .T. .and. .F.,1500.55*2 },; 
                     {"C Regazzo",Date()-100,.T. .and. .NOT. .F.,1500.56/4 };
              }

    StaticCall(NDJLIB023,SendData,cDest,aClone(aData))
    
    aMultData:=Array(0)
    nT:=Len(aData)

    For nI:=1 To nF
        For nB:=1 To nT
            aData[nB][1]:=Embaralha(aData[nB][1],0)
            aData[nB][2]:=aData[nB][2]+nI
            aData[nB][3]:=!(aData[nB][3])
            aData[nB][4]+=(nB*nI)
            aAdd(aMultData,aClone(aData[nB]))
        Next nB    
    Next nI

    StaticCall(NDJLIB023,SendData,cDest,aMultData)
    aSize(aMultData,0)
    aMultData:=NIL

Return

Static Function __Dummy(lRecursa)
    Local oException
    TRYEXCEPTION
        lRecursa:=.F.
        IF !(lRecursa)
            BREAK
        EndIF
        lRecursa:=__Dummy(.F.)
        SYMBOL_UNUSED(__cCRLF)
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return(lRecursa)
