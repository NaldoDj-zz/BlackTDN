//--------------------------------------------------------------------
PROCEDURE Main()

   LOCAL hUsers    

   LOCAL cTEnv  := ""
   LOCAL cTSrv  := ""
   LOCAL cTUser := ""
   LOCAL cTPWD  := ""
   LOCAL nTPort := 0

   LOCAL oPtObj
   
   oPtObj := WIN_OLECREATEOBJECT( "apconnxcontrol.apconnx" )

   LoadConnectionParams(@cTEnv,@cTSrv,@nTPort,@cTUser,@cTPWD)
   
   oPTObj:Environment     := cTEnv
   oPTObj:Password        := cTPWD
   oPTObj:Port            := nTPort
   oPTObj:Server          := cTSrv
   oPTObj:User            := cTUser
   oPTObj:Connect() 
   
   IF ( oPTObj:Connected )
        oPTObj:AboutBOX()
        ? oPTObj:UsersCount()
        hUsers    := GetUsers(oPTObj)
        SendMessage( oPTObj , hUsers )
        KillPTUsers( oPTObj , hUsers , .T. )
   EndIF

   oPTObj:Disconnect()

   oPTObj := NIL

RETURN

//--------------------------------------------------------------------
STATIC FUNCTION GetUsers(oPTObj)

    LOCAL aTmp
    LOCAL hTmp

    LOCAL cUsers     := oPTObj:GetUsers()
    LOCAL hUsers    := {=>}
    LOCAL aUsers    := hb_aTokens( cUsers , ";"+ Chr(1) )
    LOCAL nUsers    := Len( aUsers )

    LOCAL i
    
    FOR i := 1 TO nUsers
        aTmp                        := hb_aTokens( aUsers[ i ] , ";" )
        hUsers[i]                    := {=>}
        hUsers[i]["USER_NAME"]         := aTmp[1]
        hUsers[i]["USER_COMPUTER"]     := aTmp[2]
        hUsers[i]["USER_THREAD_ID"]    := aTmp[3]
        IF ( Len( aTmp ) > 3 )
            hUsers[i]["USER_?"]     := aTmp[4]
        Else
            hUsers[i]["USER_?"]     := ""
        EndIF
    Next i

    FOR EACH hTmp IN hUsers
        ? hTmp["USER_NAME"]
        ? hTmp["USER_COMPUTER"]
        ? hTmp["USER_THREAD_ID"]
        ? hTmp["USER_?"]
    NEXT EACH

RETURN( hUsers )

//--------------------------------------------------------------------
STATIC PROCEDURE LoadConnectionParams(cTEnv,cTSrv,nTPort,cTUser,cTPWD)
    cTEnv  := "NDJ_01"
    cTSrv  := "127.0.0.1"
    nTPort := 4321
    cTUser := "TOTVS"
    cTPWD  := "SIGA"
RETURN

//--------------------------------------------------------------------
STATIC PROCEDURE SendMessage( oPTObj , hUsers )

    LOCAL hTmp

    FOR EACH hTmp IN hUsers
        IF ( Val(hTmp["USER_THREAD_ID"]) > 0 )
            oPTObj:SendMessage(hTmp["USER_NAME"],hTmp["USER_COMPUTER"],hTmp["USER_THREAD_ID"],hTmp["USER_?"],"Message From Harbour")
        EndIF    
    NEXT EACH

RETURN

//--------------------------------------------------------------------
STATIC PROCEDURE KillPTUsers( oPTObj , hUsers , lWait )

    LOCAL hTmp

    FOR EACH hTmp IN hUsers
        IF ( Val(hTmp["USER_THREAD_ID"]) > 0 )
            oPTObj:DisconnectUser(hTmp["USER_NAME"],hTmp["USER_COMPUTER"],hTmp["USER_THREAD_ID"],hTmp["USER_?"],lWait)
        EndIF    
    NEXT EACH

RETURN