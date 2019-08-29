#INCLUDE "NDJ.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NDJC001   ºAutor  ³Rafael Rezende      º Data ³  05/10/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de Consulta com o Objetivo de agilizar a consulta   º±±
±±º          ³ dos dados dos Contatos das Instituições.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACOM                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/                      
User Function NDJC001( _nTipoConsulta )

    Local aArea            := GetArea()
    Local _aRet            := {}
    
    Local cRet            := Space( TamSX3( "Z2_XCLIORG" )[01] )
    
    Local nRet
    
    Local oDlg
    Local oFont
    Local oFolder

    Private _aListCon      := {}
    Private _aListIns      := {}
    Private _aListRes      := {}

    Private _cCodOrg       := Space( TamSX3( "Z2_XCLIORG" )[01] )
    Private _cDesOrg       := ""
    Private _cLojaZero    := Replicate( "0" , GetSx3Cache( "A1_LOJA" , "X3_TAMANHO" ) )
    Private _cRetorno    := ""
    Private _cSvCodOrg    := "___cSvCodOrg____"

    Private _nAcao         := 0 

    Private _oOk         := LoadBitmap( GetResources(), "LBOK" )
    Private _oNo        := LoadBitmap( GetResources(), "LBNO" )
    Private _oCodOrg       := NIL
    Private _oDesOrg       := NIL
    Private _oListRes      := NIL
    Private _oListCon      := NIL
    Private _oListIns      := NIL                                                                               

    BEGIN SEQUENCE

        _nTipoConsulta        := If( ValType( _nTipoConsulta ) == "C", 1, _nTipoConsulta )
        IF ( StaticCall( NDJLIB001 , IsInGetDados , "Z2_XCLIORG" ) )
            _cCodOrg         := If( _nTipoConsulta == 2, GdFieldGet( "Z2_XCLIORG" ), Space( TamSX3( "Z2_XCLIORG" )[01] ) )
        ElseIF ( StaticCall( NDJLIB001 , IsInGetDados , "Z4_XCLIORG" ) )
            _cCodOrg         := If( _nTipoConsulta == 2, GdFieldGet( "Z4_XCLIORG" ), Space( TamSX3( "Z4_XCLIORG" )[01] ) )
        ElseIF ( StaticCall( NDJLIB001 , IsInGetDados , "N1_XCLIORG" ) )
            _cCodOrg         := If( _nTipoConsulta == 2, GdFieldGet( "N1_XCLIORG" ), Space( TamSX3( "N1_XCLIORG" )[01] ) )
        ElseIF ( StaticCall( NDJLIB001 , MDJIsMemVar , "N1_XCLIORG" ) )
            _cCodOrg         := If( _nTipoConsulta == 2, StaticCall( NDJLIB001 , GetMemVar , "N1_XCLIORG" ) , Space( TamSX3( "N1_XCLIORG" )[01] ) )
        EndIF
    
        _cCodOrg             := Padr( _cCodOrg , GetSx3Cache( "A1_COD" , "X3_TAMANHO" ) )
    
        DEFINE FONT oFont Name "Arial" SIZE 0, -12 Bold
        DEFINE MSDIALOG oDlg TITLE "Consulta Rápida de Contatos" FROM C(0), C(0) TO C(355), C(700) PIXEL
    
            @ C(004),C(004) TO C(034), C(293) LABEL " Organização " PIXEL OF oDlg
            @ C(016),C(011) MSGET _oCodOrg VAR _cCodOrg F3 "XSA101" SIZE C(039),C(009)  FONT oFont Color CLR_BLACK PICTURE "@!" PIXEL OF oDlg Valid ( fGatilho() )
            @ C(016),C(054) MSGET _oDesOrg VAR _cDesOrg SIZE C(229),C(009)  FONT oFont Color CLR_BLACK PICTURE "@!" PIXEL OF oDlg
            _oDesOrg:bWhen := { || .F. }
    
            @ C(007),C(300) BUTTON "Selecionar"    SIZE C(037), C(012) FONT oFont PIXEL OF oDlg ACTION ( If( fVerSelecao( @_nAcao, _nTipoConsulta ), oDlg:End(), ) )
            @ C(021),C(300) BUTTON "Fechar"     SIZE C(037), C(012) FONT oFont PIXEL OF oDlg ACTION ( oDlg:End() )
    
            oFolder := TFolder():New( C(040),C(005),{"&Instituições ","Responsável pelo &Serviço/Produto","Responsável pelo &Recebimento"},{"","",""},oDlg,,,,.T.,.T.,C(345),C(150))
    
            fListInstituicoes(oFolder:aDialogs[1])
            fListResponsavel(oFolder:aDialogs[2])    
            fListContatos(oFolder:aDialogs[3])
    
            If !Empty( _cCodOrg )
                _cCodOrg        := Padr( _cCodOrg , GetSx3Cache( "A1_COD" , "X3_TAMANHO" ) )
                fGatilho(.T.)
            EndIf
    
        ACTIVATE MSDIALOG oDlg CENTERED ON INIT _oListIns:SetFocus()
        
        If ( _nAcao == 1 )
            AxAltera( "SA1", RecNo(), 4 )
        ElseIf ( _nAcao == 2 )
    
            /*/
            ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            ³_aRet[01] --> Codigo de Organizacao              ³
            ³_aRet[02] --> Codigo da Instituicao ( Cliente )  ³
            ³_aRet[03] --> Loja da Instituicao                  ³
            ³_aRet[04] --> Resp. Termo                          ³
            ³_aRet[05] --> Resp. Receb                          ³
            ³_aRet[06] --> Endereço                             ³
            ³_aRet[07] --> Nome da Instituicao                 ³
            ³_aRet[08] --> CEP                                 ³
            ³_aRet[09] --> Estado                             ³
            ³_aRet[10] --> Nome Fantasia Organizacao             ³
            ³_aRet[11] --> Nome Fantasia Instituicao             ³
            ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
            _aRet        := Split( _cRetorno, ";" )     
            nRet        := Len( _aRet )
    
            PutSZ2( @_aRet , @nRet )
            PutSZ4( @_aRet , @nRet )
            PutSN1( @_aRet , @nRet )
    
            IF ( nRet >= 1 )
                cRet :=  _aRet[01]
            Else
                cRet :=  Space( TamSX3( "Z2_XCLIORG" )[01] )
            EndIF
            
        EndIf     
    
    END SEQUENCE
    
    RestArea( aArea )

Return( cRet )          

Static Function PutSZ2( _aRet , nRet )

    Local aGdFields    := {;
                            "Z2_XCLIINS",;
                            "Z2_XLOJAIN",;
                            "Z2_XRESPON",;
                            "Z2_XCONTAT",;
                            "Z2_XENDER",;
                            "Z2_XCEPINS",;
                            "Z2_XESTINS",;
                            "Z2_XDESORG",;
                            "Z2_XDESINS";
                         }

    IF ( StaticCall( NDJLIB001 , IsInGetDados , aGdFields ) )
        IF ( nRet >= 2 )
            GdFieldPut( "Z2_XCLIINS", _aRet[02] )    //Codigo da Instituicao ( Cliente )
        EndIF    
        IF ( nRet >= 3 )
            GdFieldPut( "Z2_XLOJAIN", _aRet[03] )    //Loja da Instituicao
        EndIF    
        IF ( nRet >= 4 )
            GdFieldPut( "Z2_XRESPON", _aRet[04] )    //Resp. Termo
        EndIF    
        IF ( nRet >= 5 )
            GdFieldPut( "Z2_XCONTAT", _aRet[05] )    //Resp. Receb
        EndIF    
        IF ( nRet >= 6 )
            GdFieldPut( "Z2_XENDER" , _aRet[06] )    //Endereço
        EndIF    
        IF ( nRet >= 8 )
            GdFieldPut( "Z2_XCEPINS" , _aRet[08] )    //CEP
        EndIF    
        IF ( nRet >= 9 )
            GdFieldPut( "Z2_XESTINS" , _aRet[09] )    //Estado
        EndIF    
        IF ( nRet >= 10 )
            GdFieldPut( "Z2_XDESORG" , _aRet[10] )    //Nome Fantasia Organizacao
        EndIF    
        IF ( nRet >= 11 )
            GdFieldPut( "Z2_XDESINS" , _aRet[11] )    //Nome Fantasia Instituicao
        EndIF    
    EndIF    

Return( NIL )

Static Function PutSZ4( _aRet , nRet )

    Local aGdFields    := {;
                            "Z4_XDESORG",;
                            "Z4_XCLIINS",;
                            "Z4_XDESINS",;
                            "Z4_XLOJAIN",;
                            "Z4_XRESPON",;
                            "Z4_XCONTAT",;
                            "Z4_XENDER",;
                            "Z4_XENDER",;
                            "Z4_XESTINS";
                         }

    IF ( StaticCall( NDJLIB001 , IsInGetDados , aGdFields ) )
        IF ( nRet >= 2 )
            GdFieldPut( "Z4_XCLIINS", _aRet[02] )
        EndIF    
        IF ( nRet >= 3 )
            GdFieldPut( "Z4_XLOJAIN", _aRet[03] )
        EndIF    
        IF ( nRet >= 4 )
            GdFieldPut( "Z4_XRESPON", _aRet[04] )
        EndIF    
        IF ( nRet >= 5 )
            GdFieldPut( "Z4_XCONTAT", _aRet[05] )
        EndIF    
        IF ( nRet >= 6 )
            GdFieldPut( "Z4_XENDER" , _aRet[06] )
        EndIF    
        IF ( nRet >= 8 )
            GdFieldPut( "Z4_XCEPINS" , _aRet[08] )
        EndIF    
        IF ( nRet >= 9 )
            GdFieldPut( "Z4_XESTINS" , _aRet[09] )
        EndIF    
        IF ( nRet >= 10 )
            GdFieldPut( "Z4_XDESORG" , _aRet[10] )
        EndIF    
        IF ( nRet >= 11 )
            GdFieldPut( "Z4_XDESINS" , _aRet[11] )
        EndIF    
    EndIF    

Return( NIL )

Static Function PutSN1( _aRet , nRet )
    Local aGdFields    := {;
                            "N1_XDESORG",;
                            "N1_XCODINS",;
                            "N1_XLOJAIN",;
                            "N1_XDESINS",;
                            "N1_XCONTAT",;
                            "N1_XDESCRR",;
                            "N1_XRESPON",;
                            "N1_XDESCRT",;
                            "N1_XENDERE",;
                            "N1_XCEPINS",;
                            "N1_XESTINS";
                         }

    IF ( StaticCall( NDJLIB001 , IsInGetDados , aGdFields ) )
        IF ( nRet >= 2 )
            GdFieldPut( "N1_XCODINS", _aRet[02] )    //Codigo da Instituicao ( Cliente )
        EndIF    
        IF ( nRet >= 3 )
            GdFieldPut( "N1_XLOJAIN", _aRet[03] )    //Loja da Instituicao
        EndIF    
        IF ( nRet >= 4 )
            GdFieldPut( "N1_XRESPON", _aRet[04] )    //Resp. Termo
            GdFieldPut( "N1_XDESCRT", RETFIELD("SU5",1,XFILIAL("SU5")+_aRet[04],"SU5->U5_CONTAT") )    //Desc. Resp. Termo
        EndIF    
        IF ( nRet >= 5 )
            GdFieldPut( "N1_XCONTAT", _aRet[05] )    //Resp. Receb
            GdFieldPut( "N1_XDESCRR", RETFIELD("SU5",1,XFILIAL("SU5")+_aRet[05],"SU5->U5_CONTAT") )    //Desc. Resp. Receb
        EndIF    
        IF ( nRet >= 6 )
            GdFieldPut( "N1_XENDERE" , _aRet[06] )    //Endereço
        EndIF    
        IF ( nRet >= 8 )
            GdFieldPut( "N1_XCEPINS" , _aRet[08] )    //CEP
        EndIF    
        IF ( nRet >= 9 )
            GdFieldPut( "N1_XESTINS" , _aRet[09] )    //Estado
        EndIF    
        IF ( nRet >= 10 )
            GdFieldPut( "N1_XDESORG" , _aRet[10] )    //Nome Fantasia Organizacao
        EndIF    
        IF ( nRet >= 11 )
            GdFieldPut( "N1_XDESINS" , _aRet[11] )    //Nome Fantasia Instituicao
        EndIF    
    Else
        IF ( StaticCall( NDJLIB001 , MDJIsMemVar , "N1_XCODINS" ) )
            IF ( nRet >= 2 )
                StaticCall( NDJLIB001 , SetMemVar , "N1_XCODINS", _aRet[02] )    //Codigo da Instituicao ( Cliente )
            EndIF    
        EndIF
        IF ( StaticCall( NDJLIB001 , MDJIsMemVar , "N1_XLOJAIN" ) )
            IF ( nRet >= 3 )
                StaticCall( NDJLIB001 , SetMemVar , "N1_XLOJAIN", _aRet[03] )    //Loja da Instituicao
            EndIF
        EndIF
        IF ( StaticCall( NDJLIB001 , MDJIsMemVar , "N1_XRESPON" ) )
            IF ( nRet >= 4 )
                StaticCall( NDJLIB001 , SetMemVar , "N1_XRESPON", _aRet[04] )    //Resp. Termo
                StaticCall( NDJLIB001 , SetMemVar , "N1_XDESCRT", RETFIELD("SU5",1,XFILIAL("SU5")+_aRet[04],"SU5->U5_CONTAT") )    //Desc. Resp. Termo
            EndIF    
        EndIF
        IF ( StaticCall( NDJLIB001 , MDJIsMemVar , "N1_XCONTAT" ) )
            IF ( nRet >= 5 )
                StaticCall( NDJLIB001 , SetMemVar , "N1_XCONTAT", _aRet[05] )    //Resp. Receb
                StaticCall( NDJLIB001 , SetMemVar , "N1_XDESCRR", RETFIELD("SU5",1,XFILIAL("SU5")+_aRet[05],"SU5->U5_CONTAT") )    //Desc. Resp. Receb
            EndIF    
        EndIF
        IF ( StaticCall( NDJLIB001 , MDJIsMemVar , "N1_XENDERE" ) )
            IF ( nRet >= 6 )
                StaticCall( NDJLIB001 , SetMemVar , "N1_XENDERE" , _aRet[06] )    //Endereço
            EndIF    
        EndIF
        IF ( StaticCall( NDJLIB001 , MDJIsMemVar , "N1_XCEPINS" ) )
            IF ( nRet >= 8 )
                StaticCall( NDJLIB001 , SetMemVar , "N1_XCEPINS" , _aRet[08] )    //CEP
            EndIF    
        EndIF
        IF ( StaticCall( NDJLIB001 , MDJIsMemVar , "N1_XESTINS" ) )    
            IF ( nRet >= 9 )
                StaticCall( NDJLIB001 , SetMemVar , "N1_XESTINS" , _aRet[09] )    //Estado
            EndIF    
        EndIF
        IF ( StaticCall( NDJLIB001 , MDJIsMemVar , "N1_XDESORG" ) )    
            IF ( nRet >= 10 )
                StaticCall( NDJLIB001 , SetMemVar , "N1_XDESORG" , _aRet[10] )    //Nome Fantasia Organizacao
            EndIF
        EndIF
        IF ( StaticCall( NDJLIB001 , MDJIsMemVar , "N1_XDESINS" ) )
            IF ( nRet >= 11 )
                StaticCall( NDJLIB001 , SetMemVar , "N1_XDESINS" ,  _aRet[11] )    //Nome Fantasia Instituicao
            EndIF    
        EndIF    
    EndIF    

Return( NIL )

Static Function fListInstituicoes(oDlg)

    aSize( _aListIns , 0 )
    aAdd( _aListIns , { .F. , "" , "" , "" , "" , "" , "" , "" } )
    @ C(005), C(005) LISTBOX _oListIns FIELDS ;
        Header " ", "Código" , "Loja" , "Nome" , "Fantasia" , "Endereço" , "CEP" , "Estado" SIZE C(340), C(120) OF oDlg PIXEL
    _oListIns:SetArray( _aListIns )
    _oListIns:bLDblClick := { || fCliqueInstituicao() }

    _oListIns:bLine := { || {;
                                IF( _aListIns[_oListIns:nAt][01], _oOk , _oNo ),    ;
                                    _aListIns[_oListIns:nAt][02],                        ;
                                    _aListIns[_oListIns:nAt][03],                        ;
                                    _aListIns[_oListIns:nAt][04],                        ;
                                    _aListIns[_oListIns:nAt][08],                        ;
                                    _aListIns[_oListIns:nAt][05],                        ;
                                    _aListIns[_oListIns:nAt][06],                        ;
                                    _aListIns[_oListIns:nAt][07]                        ;
                              };
                        }
    _oListIns:Disable()
    _oListIns:Refresh()

Return NIL                                                                                                                      

Static Function fListResponsavel(oDlg)

    aSize( _aListRes , 0 )
    aAdd( _aListRes , { .F. , "" , "" , "" , "" , "" , "" , "" , "" , 0 } )

    @ C(005), C(005) LISTBOX _oListRes FIELDS ;
        Header "  ", "Código", "Contato", "Endereço", "Tipo", "Assina Term.", "Celular", "Tel. Comercial", "E-mail", "Index";
        SIZE C(340), C(120) OF oDlg PIXEL
    _oListRes:SetArray( _aListRes )
    _oListRes:bLDblClick := { || fAtualizaFlag( @_oListRes, @_aListRes , .T. ) } 

    _oListRes:bLine := { || { If( _aListRes[_oListRes:nAt][01], _oOk, _oNo ) , ;
                                  _aListRes[_oListRes:nAt][02] ,;
                                  _aListRes[_oListRes:nAt][03] ,;
                                  _aListRes[_oListRes:nAt][04] ,;
                                  _aListRes[_oListRes:nAt][05] ,;
                                  _aListRes[_oListRes:nAt][06] ,;
                                  _aListRes[_oListRes:nAt][07] ,;
                                  _aListRes[_oListRes:nAt][08] ,;
                                  _aListRes[_oListRes:nAt][09] } }
    _oListRes:Refresh()
    _oListRes:Disable() 
  
Return NIL                                                                                                                      

Static Function fListContatos(oDlg)

    aSize( _aListCon , 0 )
    aAdd( _aListCon , { .F. , "" , "" , "" , "" , "" , "" , "" , "" , 0 } )

    @ C(005), C(005) LISTBOX _oListCon FIELDS ;
        Header "  ", "Código", "Contato", "Endereço", "Tipo", "Assina Term.", "Celular", "Tel. Comercial", "E-mail", "Index";
        SIZE C(340), C(120) OF oDlg PIXEL
    _oListCon:SetArray( _aListCon )
    _oListCon:bLDblClick := { || fAtualizaFlag( _oListCon, _aListCon ) } 

    _oListCon:bLine := { || { If( _aListCon[_oListCon:nAt][01], _oOk, _oNo ) , ;
                                  _aListCon[_oListCon:nAt][02] ,;
                                  _aListCon[_oListCon:nAt][03] ,;
                                  _aListCon[_oListCon:nAt][04] ,;
                                  _aListCon[_oListCon:nAt][05] ,;
                                  _aListCon[_oListCon:nAt][06] ,;
                                  _aListCon[_oListCon:nAt][07] ,;
                                  _aListCon[_oListCon:nAt][08] ,;
                                  _aListCon[_oListCon:nAt][09] } }

    _oListCon:Refresh() 
    _oListCon:Disable() 

Return NIL

Static Function C( nTam )                                                         

Local nHRes    :=    oMainWnd:nClientWidth    // Resolucao horizontal do monitor     
    If nHRes == 640    // Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
        nTam *= 0.8                                                                
    ElseIf (nHRes == 798).Or.(nHRes == 800)    // Resolucao 800x600                
        nTam *= 1                                                                  
    Else    // Resolucao 1024x768 e acima                                           
        nTam *= 1.28
    EndIf                                                                         
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                               
    //³Tratamento para tema "Flat"³                                               
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                               
    If "MP8" $ oApp:cVersion                                                      
        If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
            nTam *= 0.90                                                            
        EndIf                                                                      
    EndIf                                                                         
Return Int( nTam )
    
Static Function fGatilho(lFirst)

Local _aArea  := GetArea()

BEGIN SEQUENCE

    aSize( _aListIns , 0 )
    aSize( _aListRes , 0 )
    aSize( _aListCon , 0 )
    
    aAdd( _aListIns , { .F. , "" , "" , "" , "" , "" , "" , "" } )
    aAdd( _aListRes , { .F. , "" , "" , "" , "" , "" , "" , "" , "" , 0 } )
    aAdd( _aListCon , { .F. , "" , "" , "" , "" , "" , "" , "" , "" , 0 } )

    _oListIns:Refresh()
    _oListRes:Refresh()
    _oListCon:Refresh()

    _oListIns:Disable()
    _oListRes:Disable()
    _oListCon:Disable()

    If Empty( _cCodOrg )
    
        _cDesOrg := ""
    
        _oListIns:Disable()
        _oListIns:Refresh()
        
        _oListRes:Disable()
        _oListRes:Refresh()
        
        _oListCon:Disable()
        _oListCon:Refresh()
    
        BREAK
    
    EndIf 
    
    DbSelectArea( "SA1" )
    SA1->( DbSetOrder( RetOrder( "SA1" , "A1_COD+A1_LOJA" ) ) )
    Seek xFilial( "SA1" ) + _cCodOrg + _cLojaZero
    If SA1->( !Found() )
        Aviso( "Atenção", "A Organização informada não foi encontrada.", { "Voltar" } )
        Return .F.
    Else
        _cDesOrg := SA1->A1_NOME
        DEFAULT lFirst := .F.
        IF lFirst .or. !( _cSvCodOrg == _cCodOrg )
            IF !( lFirst )
                _cSvCodOrg := _cCodOrg
                MSAguarde( { || fCarregaInstituicoes() } , OemToAnsi( "Instituições" ) , OemToAnsi( "Aguarde, carregando as Instituições. . ." ) , .F. )
            Else
                fCarregaInstituicoes()
                lFirst := .F.
            EndIF    
        EndIF
    EndIf    

END SEQUENCE    

Return .T.
 
Static Function fCarregaInstituicoes()

Local _cQuery        := ""
Local _cAlias        := GetNextAlias()
Local cSA1Filial    := xFilial("SA1")
Local nElem            := 0
Local cSU5Table        := RetSqlName( "SU5" )
Local cAC8Table        := RetSqlName( "AC8" )

Local cAC8Filial    := xFilial( "AC8" )
Local cSU5Filial    := xFilial( "SU5" )
Local cAC8FilEnt    := xFilial( "SA1" )
Local lEnable        := .F.

_cCodOrg            := Padr( _cCodOrg , GetSx3Cache( "A1_COD" , "X3_TAMANHO" ) )

lPrim := .F.
If Len(_aListIns) == 1
   lPrim := .T.
Endif   
DbSelectArea( "SA1" )
SA1->( DbSetOrder( RetOrder( "SA1" , "A1_COD+A1_LOJA" ) ) )
Seek cSA1Filial + _cCodOrg + _cLojaZero
While SA1->(;
                    !Eof();
                    .And. ;
                     ( A1_FILIAL == cSA1Filial );
                     .And. ; 
                     ( A1_COD == _cCodOrg ) ;
               )    
    
    If ( _cLojaZero == SA1->A1_LOJA )
        SA1->( DbSkip() )
        Loop
    EndIf 

    _cQuery := "SELECT "
    _cQuery += "    COUNT(*) ELEMENTOS "
    _cQuery += "FROM "
    _cQuery += "    " + cSU5Table + " SU5 (NOLOCK), "
    _cQuery += "    " + cAC8Table + " AC8 (NOLOCK)  "
    _cQuery += "WHERE SU5.D_E_L_E_T_ = ' ' "
    _cQuery += "    AND AC8.D_E_L_E_T_ = ' ' "
    _cQuery += "     AND AC8_FILIAL = '" + cAC8Filial + "' "
    _cQuery += "     AND U5_FILIAL  = '" + cSU5Filial + "' "
    _cQuery += "     AND AC8_FILENT = '" + cAC8FilEnt + "' "
    _cQuery += "     AND AC8_CODENT = '" + SA1->( A1_COD + A1_LOJA ) + "' "
    _cQuery += "     AND AC8_ENTIDA = 'SA1' "
    _cQuery += "     AND AC8_CODCON = SU5.U5_CODCONT "
    
    TCQUERY _cQuery ALIAS ( _cAlias ) NEW

    IF ( ( _cAlias )->ELEMENTOS > 0 )

        If lPrim 
            nElem := 1
            lPrim := .F.
        Else
            aAdd( _aListIns , { .F. , "" , "" , "" , "" , "" , "" , "" } )
            ++nElem
        EndIF    
        
        _aListIns[nElem][1] := .F.
        _aListIns[nElem][2] := SA1->A1_COD
        _aListIns[nElem][3] := SA1->A1_LOJA
        _aListIns[nElem][4] := SA1->A1_NOME
        _aListIns[nElem][5] := SA1->A1_END
        _aListIns[nElem][6] := SA1->A1_CEP
        _aListIns[nElem][7] := SA1->A1_EST
        _aListIns[nElem][8] := SA1->A1_NREDUZ
        
        lEnable := .T.
    
    EndIF
    
    ( _cAlias )->( dbCloseArea() )
    
    SA1->( DbSkip() )  
    
End While

IF ( Len( _aListIns ) == 0  )
    aAdd( _aListIns , { .F. , "" , "" , "" , "" , "" , "" , "" } )
Else
    aSort( _aListIns , NIL , NIL , { |x,y| x[4]+x[2]+x[3] < y[4]+y[2]+y[3] } )
EndIf

IF lEnable
    _oListIns:Enable()
EndIF    

_oListIns:Refresh() 

If Empty(_aListIns[1][2])
    Aviso( "Atenção", "Para a Organização informada não foi encontrada nenhuma Instituição", { "Voltar" } )
    Return  
Endif    

Return

Static Function fCliqueInstituicao()

Local _aArea  := GetArea()

Local _cAlias := GetNextAlias()
Local _cQuery := ""
Local cEnder  := ""

Local _lFlag  := .F.
Local nIndex  := 0
   
fAtualizaFlag( @_oListIns , @_aListIns )

_lFlag  := _aListIns[_oListIns:nAt][01]

If _lFlag
 
    aSize( _aListRes , 0 )
    aSize( _aListCon , 0 )

    _oListRes:Refresh()
    _oListCon:Refresh()

    _oListRes:Disable()
    _oListCon:Disable()

    _cQuery := "  SELECT "
    _cQuery += "        AC8_CODCON, "
    _cQuery += "        U5_CONTAT, "
    _cQuery += "        AC8_XENDER, "
    _cQuery += "        AC8_XTPCON, "
    _cQuery += "        AC8_XASSIN, "
    _cQuery += "        U5_CELULAR, "
    _cQuery += "        U5_FCOM1, "
    _cQuery += "        U5_EMAIL "
    _cQuery += "    FROM " + RetSQLName( "SU5" ) + " SU5 (NOLOCK), "
    _cQuery += "         " + RetSQLName( "AC8" ) + " AC8 (NOLOCK)  "
    _cQuery += "   WHERE SU5.D_E_L_E_T_ = ' ' "
    _cQuery += "     AND AC8.D_E_L_E_T_ = ' ' "
    _cQuery += "     AND AC8_FILIAL = '" + xFilial( "AC8" ) + "' "
    _cQuery += "     AND U5_FILIAL  = '" + xFilial( "SU5" ) + "' "
    _cQuery += "     AND AC8_FILENT = '" + xFilial( "SA1" ) + "' "
    _cQuery += "     AND AC8_CODENT = '" + _aListIns[_oListIns:nAt][02] + _aListIns[_oListIns:nAt][03] + "' "
    _cQuery += "     AND AC8_ENTIDA = 'SA1' "
    _cQuery += "     AND AC8_CODCON = SU5.U5_CODCONT "
    
    TCQUERY _cQuery ALIAS ( _cAlias ) NEW

    cEnder    := _aListIns[_oListIns:nAt][05]
    
    IF ( _cAlias )->( !Eof() )
    
        While ( _cAlias )->( !Eof() )

            ++nIndex
            If AllTrim( ( _cAlias )->AC8_XASSIN ) == "S"
                ( _cAlias )->( aAdd( _aListRes , { .F. , AC8_CODCON , U5_CONTAT , IF(Empty(AC8_XENDER),cEnder,AC8_XENDER) , AC8_XTPCON , AC8_XASSIN , U5_CELULAR , U5_FCOM1 , U5_EMAIL , nIndex } ) )
                //Adicionar o Responsável pelo Servico/Produto como responspavel pelo Recebimento 
                ( _cAlias )->( aAdd( _aListCon , { .F. , AC8_CODCON , U5_CONTAT , IF(Empty(AC8_XENDER),cEnder,AC8_XENDER) , AC8_XTPCON , AC8_XASSIN , U5_CELULAR , U5_FCOM1 , U5_EMAIL , nIndex } ) )
            Else
                ( _cAlias )->( aAdd( _aListCon , { .F. , AC8_CODCON , U5_CONTAT , IF(Empty(AC8_XENDER),cEnder,AC8_XENDER) , AC8_XTPCON , AC8_XASSIN , U5_CELULAR , U5_FCOM1 , U5_EMAIL , nIndex } ) )
            EndIf

            ( _cAlias )->( DbSkip() )
        
        End While

        IF !Empty( _aListRes )
            _oListRes:Enable() 
        Else
            aSize( _aListRes ,  0 )
            aAdd( _aListRes , { .F. , "" , "" , "" , "" , "" , "" , "" , "" , 0 } )
            _oListRes:Disable()
        EndIF

        IF !Empty( _aListCon )
            _oListCon:Enable() 
        Else
            aSize( _aListCon ,  0 )
            aAdd( _aListCon , { .F. , "" , "" , "" , "" , "" , "" , "" , "" , 0 } )
            _oListCon:Disable() 
        EndIF
    
    Else

        aSize( _aListRes ,  0 )
        aSize( _aListCon ,  0 )
        
        aAdd( _aListRes , { .F. , "" , "" , "" , "" , "" , "" , "" , "" , 0 } )
        aAdd( _aListCon , { .F. , "" , "" , "" , "" , "" , "" , "" , "" , 0 } )

        _oListRes:Disable() 
        _oListCon:Disable() 

    EndIF
        
    ( _cAlias )->( dbCloseArea() )

Else

    aSize( _aListRes ,  0 )
    aSize( _aListCon ,  0 )

    aAdd( _aListRes , { .F. , "" , "" , "" , "" , "" , "" , "" , "" , 0 } )
    aAdd( _aListCon , { .F. , "" , "" , "" , "" , "" , "" , "" , "" , 0 } )
    
    _oListRes:Disable()
    _oListCon:Disable()  

EndIf 

If Empty(_aListRes[1][2])
    IF !Empty( GetNewPar( "NDJ_MCDCLI" , "" ) )
        Aviso(;
                "Atenção",; 
                "Para a Instituição selecionada não foi encontrado nenhum Responsável.";
                 + CRLF + ;
                 "Entre em Contato com: " + AllTrim( GetNewPar( "NDJ_MCDCLI" , "" ) ) ;
                 ,;
                { "Voltar" };
             )
    EndIF
    _aListIns[_oListIns:nAt][01] := .F.
Endif    

_oListRes:Refresh()
_oListCon:Refresh()

RestArea( _aArea ) 

Return

Static Function fVerSelecao( _nAcao, _nTipoConsulta )

    Local lRet         := .F. 
    Local nSA1Order    := RetOrder( "SA1" , "A1_COD+A1_LOJA" )

    BEGIN SEQUENCE
    
        If Empty( _cCodOrg )
            Aviso( "Atenção", "Selecione uma Organização primeiro!", { "Voltar" } )
            _nAcao    := 0    
            lRet    := .F.
            BREAK
        EndIf 
                                                    
        If ( _nTipoConsulta == 1 )
        
            If !fVerMarcacao( _oListIns, _aListIns )
                Aviso( "Atenção", "Selecione uma Instituição primeiro.", { "Voltar" } ) 
                _nAcao    := 0    
                lRet    := .F.
                BREAK
            EndIf 

            DbSelectArea( "SA1" ) 
            SA1->( DbSetOrder( 01 ) )
            Seek xFilial( "SA1" ) + _aListins[_oListIns:nAt][02] + _aListins[_oListIns:nAt][03]
            If SA1->( Found() )
                _nAcao    := 01 
                lRet     := .T.
                BREAK
            EndIf
        
        Else            
        
            If !fVerMarcacao( @_oListRes, @_aListRes )
                Aviso( "Atenção", "Selecione um Responsável pela Assinatura do Termo primeiro.", { "Voltar" } ) 
                _cSvCodOrg    := "___cSvCodOrg____"
                _nAcao    := 0    
                lRet    := .F.
                BREAK
            EndIf 
        
            If !fVerMarcacao( _oListCon, _aListCon )
                Aviso( "Atenção", "Selecione um Responsável pela Recebimento do Material primeiro.", { "Voltar" } ) 
                _cSvCodOrg    := "___cSvCodOrg____"
                _nAcao    := 0    
                lRet     := .F.
                BREAK
            EndIf 

            _nAcao         := 02 

            _cRetorno    := _cCodOrg                            //01 - Codigo de Organizacao    
            _cRetorno    += ";"
            _cRetorno    += _aListIns[_oListIns:nAt][02]        //02 - Codigo da Instituicao ( Cliente )
            _cRetorno    += ";"
            _cRetorno    += _aListIns[_oListIns:nAt][03]        //03 - Loja da Instituicao
            _cRetorno    += ";"
            _cRetorno    += _aListRes[_oListRes:nAt][02]        //04- Responsavel Termo
            _cRetorno    += ";"
            _cRetorno    += _aListCon[_oListCon:nAt][02]        //05 - Responsavel Recebimento
            _cRetorno    += ";"
            _cRetorno    += _aListCon[_oListCon:nAt][04]        //06 - Endereco
            _cRetorno    += ";"
            _cRetorno    += _aListIns[_oListIns:nAt][04]        //07 - Nome da Instituicao
            _cRetorno    += ";"
            _cRetorno    += _aListIns[_oListIns:nAt][06]        //08 - CEP
            _cRetorno    += ";"
            _cRetorno    += _aListIns[_oListIns:nAt][07]        //09 - Estado
            _cRetorno    += ";"
            _cRetorno    += PosAlias( "SA1" , _cCodOrg+"00" , NIL , "A1_NREDUZ" , nSA1Order , .F. )//10 - Nome Fantasia Organizacao
            _cRetorno    += ";"
            _cRetorno    += PosAlias( "SA1" , _aListIns[_oListIns:nAt][02]+_aListIns[_oListIns:nAt][03] , NIL , "A1_NREDUZ" , nSA1Order , .F. )//11 - Nome Fantasia Instituicao
            
            lRet        := .T.
            BREAK

        EndIf                                                                            
    
    END SEQUENCE
  
Return lRet

Static Function fAtualizaFlag( _oList , _aList , lRes )

    Local nAt
    Local nRes

    aEval( _aList , { |aElem,nPos| _aList[nPos][01] := .F. }  )

    _aList[_oList:nAt][01]    := .T.

    _oList:Refresh()

    DEFAULT lRes := .F.
    IF ( lRes )
         nAt     := aScan( _aListCon , { |x| ( x[10] == _aList[_oList:nAt][10] ) } )
         nRes    := aScan( _aListCon , { |x| x[1] } )
         IF ( ( nAt > 0 ) .and. .NOT.( nRes > 0 ) )
             aEval( _aListCon , { |aElem,nPos| _aListCon[nPos][01] := .F. }  )
             _aListCon[nAt][01]    := .T.
             _oListCon:nAt        := nAt
            _oListCon:Refresh()
        EndIF
    EndIF

Return( NIL )
                                             
Static Function fVerMarcacao( _oList, _aList )
Return( _aList[_oList:nAt][01]  )

User Function RPNC001F3()
Return( U_NDJC001( 2 ) )

Static Function Split( _cTexto, _cCaracter )
Return( StrTokArr2( _cTexto , _cCaracter ) )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        lRecursa    := __Dummy( .F. )
        __cCRLF        := NIL
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
