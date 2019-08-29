#INCLUDE "NDJ.CH"
/*
    Programa : BTDNCustomLogin.prg
    Funcao   : CustomLogin
    Autor    : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data     : 07/09/2012
    Uso      : Tela de Login Customizada no TOTVS/Protheus
*/
Static Procedure CustomLogin()
    
    Local aCustom        := Array(0)

    Local aMsObj
    
    Local cFind
    Local cReplace
    Local cbSource
    Local cClassName
    Local cMemberName
    
    Local oObj
    Local nObj
    
    Local nW
    Local nX
    Local nY
    
    aAdd(aCustom,{"TSAY","cCaption" ,"Fale com nosso suporte"                 ,"http://www.blacktdn.com.br"})
    aAdd(aCustom,{"TSAY","blClicked","HTTP://WWW.TOTVS.COM/SUPORTE/MICROSIGA" ,"HTTP://WWW.BLACKTDN.COM.BR"})

    aAdd(aCustom,{"TSAY","cCaption" ,"Perfil"                ,Space(Len("Perfil"))})
    aAdd(aCustom,{"TSAY","cCaption" ,"Segurança"             ,Space(Len("Segurança"))})
    aAdd(aCustom,{"TSAY","cCaption" ,"Mobilidade"            ,Space(Len("Mobilidade"))})
    aAdd(aCustom,{"TSAY","cCaption" ,"Produtividade"         ,Space(Len("Produtividade"))})
    aAdd(aCustom,{"TSAY","cCaption" ,"Integração"            ,Space(Len("Integração"))})
    aAdd(aCustom,{"TSAY","cCaption" ,"Rede de Empresas"      ,Space(Len("Rede de Empresas"))})
    aAdd(aCustom,{"TSAY","cCaption" ,"<br>o <b>by You</b>"   ,"<b> BlackTDN</b>"})
    aAdd(aCustom,{"TSAY","cCaption" ,"Clique aqui"           ,"<br>Clique aqui"})
    aAdd(aCustom,{"TSAY","cCaption" ,"<br><br>Clique aqui"   ,"<br>Clique aqui"})
    aAdd(aCustom,{"TSAY","blClicked","{|| FWBYLEARNMORE() }" ,"{||SHELLEXECUTE('OPEN','HTTP://WWW.BLACKTDN.COM.BR','','',5)}"})
    
    aAdd(aCustom,{"TBITMAP","cResName","fw_totvs_logo_61x27","fw_btdn_logo_61x27.png"})
    aAdd(aCustom,{"TBITMAP","cResName","fwlgn_byyou_icones" ,"fwlgn_btdn_icones.png"})
    aAdd(aCustom,{"TBITMAP","cResName","fwlgn_byyou_slogan" ,"fwlgn_btdn_slogan.png"})
    aAdd(aCustom,{"TBITMAP","cResName","fwlgn_byyou_bg"     ,"fwlgn_btdn_bg.png"})
    aAdd(aCustom,{"TBITMAP","cResName","fwby_logo"          ,"fwbtdn_logo.png"})
    
    nW := 0
    nY := Len( aCustom )
    While ( ( ++nW ) <= nY )
        cClassName := aCustom[nW][1]
        aMsObj       := FindMsObject( cClassName )
        For nX := nW TO nY
            IF .NOT.( cClassName == aCustom[nX][1] )
                EXIT
            EndIF
            cMemberName := aCustom[nX][2]
            cFind       := OemToAnsi(aCustom[nX][3])
            cReplace    := aCustom[nX][4]
            DO CASE
            CASE ( cClassName == "TSAY" )
                DO CASE
                CASE ( cMemberName == "cCaption" )
                    nObj := aScan( aMsObj , { |oObj|(ValType(oObj:cCaption)=="C").and.(cFind$oObj:cCaption) } )
                    IF ( nObj > 0 )
                        oObj          := aMsObj[ nObj ]
                        oObj:cCaption := StrTran(oObj:cCaption,cFind,cReplace)
                        oObj:Refresh()
                    EndIF    
                CASE ( cMemberName == "blClicked" )
                    nObj := aScan( aMsObj , { |oObj|(ValType(oObj:blClicked)=="B").and.(cFind$GetCbSource(oObj:blClicked) ) } )
                    IF ( nObj > 0 )
                        oObj            := aMsObj[ nObj ]
                        cbSource        := GetCbSource(oObj:blClicked)
                        cbSource        := StrTran(cbSource,cFind,cReplace)
                        oObj:blClicked  := &(cbSource)
                        oObj:Refresh()
                    EndIF    
                ENDCASE
            CASE ( cClassName == "TBITMAP" )
                nObj := aScan( aMsObj , { |oObj|(ValType(oObj:cResName)=="C").and.(cFind$oObj:cResName) } )
                IF ( nObj > 0 )
                    oObj             := aMsObj[ nObj ]
                    oObj:SetEmpty()
                    oObj:SetBmp(cReplace)
                    oObj:lAutoSize   := .T.
                    oObj:lStretch    := .F.
                    oObj:Refresh()
                    oObj:Show()
                EndIF    
            ENDCASE
            nW := nX
        Next nX
    End While

    SysRefresh()

Return

/*
    Programa : BTDNCustomLogin.prg
    Funcao   : FindMsObject
    Autor    : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data     : 07/09/2012
    Uso      : Retornar Lista de Objetos conforme cClassName
*/
Static Function FindMsObject(cMsClassName,oWnd)
Return(StaticCall(NDJLIB016,FindMsObject,@cMsClassName,@oWnd))

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        lRecursa := __Dummy( .F. )
        CustomLogin()
        SYMBOL_UNUSED( __cCRLF )
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
