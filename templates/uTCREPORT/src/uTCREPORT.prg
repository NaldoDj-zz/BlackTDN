#ifdef TOTVS
    #include "totvs.ch"
#else
    #include "protheus.ch"
#endif    
#include "uTCREPORTDef.ch"

Static __cAlias
Static __aHeaders       := Array(0)
Static __nTCRMaxLine    := TCR_MAX_LINEREL

#IFDEF __BTDNVDEMO
    Static __nBTDND
    Static __oBTDNFD
#ENDIF

//----------------------------------------------------------------------------
    /*
        Programa    : uTCREPORT.prg
        Class       : uTCREPORT
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 27/09/2012 
    */
//----------------------------------------------------------------------------
CLASS uTCREPORT FROM TREPORT

    DATA aHeaders

    DATA bHPrint
    
    DATA lEdit
    DATA lExcel

    DATA nLine
    DATA nHPag
    DATA nVPag
    DATA nHLine

    DATA oBFont
    DATA oHFont

    METHOD New(cReport,cTitle,uParam,bAction,cDescription) CONSTRUCTOR
    METHOD SetTReport()
    METHOD ChkBreak()
    METHOD HeaderAdd(aHeader)
    METHOD HeaderDel(aHeader)
    METHOD HeaderPrint(aHeaders)
    METHOD SetPageBreak()
    METHOD ChkPgBreak(nLPrn)
    METHOD IncLine(nLines,lChkPgBreak)
    METHOD SetFont(oBFont,lHeader)

    METHOD PrintOut(nPosH,cLinePrt,nNewLine,oBFontPrt,nAlign,cPict)

END CLASS

User Function uTCREPORT(cReport,cTitle,uParam,bAction,cDescription)
Return(uTCREPORT():New(@cReport,@cTitle,@uParam,@bAction,@cDescription))

//----------------------------------------------------------------------------
    /*
        Programa    : uTCREPORT.prg
        Method      : New
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 27/09/2012 
    */
//----------------------------------------------------------------------------
METHOD New(cReport,cTitle,uParam,bAction,cDescription) CLASS uTCREPORT

    Local lChkSum    := btdnChkSum()
    
    Self:aHeaders    := Array(0)

    Self:lEdit       := .F.
    Self:lExcel      := .F.

    IF .NOT.( lChkSum )
        Final("Unauthorized User","Process Aborted")
    EndIF

    _Super:New(@cReport,@cTitle,@uParam,@bAction,@cDescription)

Return(Self)

//----------------------------------------------------------------------------
    /*
        Programa    : uTCREPORT.prg
        Method      : SetTReport
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 27/09/2012 
    */
//----------------------------------------------------------------------------
METHOD SetTReport() CLASS uTCREPORT
    
    Local bErrorBlock
    
    Local cAlias
    Local cFilter
    
    Local lSQL
    Local lSection

    Local lChkSum    := btdnChkSum()

    Local oBFont
    Local oSection

    IF .NOT.( lChkSum )
        Final("Unauthorized User","Process Aborted")
    EndIF

    IF (;
            IsInCallStack("PRINTDIALOG");
            .and.;
            IsInCallStack("PRINT");
        )    

        bErrorBlock := ErrorBlock({|e|BREAK(e)})
        BEGIN SEQUENCE
            Self:ClrFore()
        END SEQUENCE
        BEGIN SEQUENCE
            Self:ClrBack()
        END SEQUENCE
        ErrorBlock(bErrorBlock)

        Self:lEdit  := ( Self:GetEdit() .and. VerSenha(110) ) //acesso para alterar configuracao de impressao

        oSection    := Self:Section(Self:cTitle)
        lSection    := ( ValType(oSection)=="O" )
        
        IF ( Self:lEdit )
            Self:nHLine := Self:nLineHeight
            __nLHeigth  := Self:nHLine
            IF ( lSection )
                oSection:nLineHeight := __nLHeigth
            EndIF    
            BEGIN SEQUENCE
                lChgBFont := .NOT.( ValType(Self:oBFont)=="O" )
                IF ( lChgBFont )
                    BREAK
                EndIF
                lChgBFont := .NOT.( Self:cFontBody == Self:oBFont:Name )
                IF ( lChgBFont )
                    BREAK
                EndIF
                lChgBFont := .NOT.( Self:nFontBody == ABS( Self:oBFont:nHeight ) ) 
                IF ( lChgBFont )
                    BREAK
                EndIF
                lChgBFont := .NOT.( Self:lBold == Self:oBFont:Bold )
                IF ( lChgBFont )
                    BREAK
                EndIF
                lChgBFont := .NOT.( Self:lItalic == Self:oBFont:Italic )
                IF ( lChgBFont )
                    BREAK
                EndIF
                lChgBFont := .NOT.( Self:lUnderline == Self:oBFont:Underline )
            END SEQUENCE
            IF ( lChgBFont )
                oBFont := __SetFont(RPT_TREPORT,Self:cFontBody,NIL,Self:nFontBody,NIL,Self:lBold,NIL,NIL,NIL,NIL,Self:lUnderline,Self:lItalic)
                Self:SetFont(oBFont)
            EndIF
        EndIF

        Self:SetFont()
        Self:SetFont(,.T.)
        DEFAULT Self:bHPrint        := { |aHeader| Self:HeaderPrint(@aHeader) }
        DEFAULT Self:nHPag          := Self:PageWidth()
        DEFAULT Self:nVPag          := Self:PageHeight()
        DEFAULT Self:nLine          := ( Self:nVPag+1 )
        Self:nVPag -= ( TCR_LINE_HEIGHT * 3 )
        Self:SetLineHeight(Self:nHLine)
        Self:lExcel                 := ( Self:nDevice == TCR_IMP_EXCEL )
        IF ( Self:lExcel )
            Self:lXlsHeader         := .T.
            Self:lEmptyLineExcel    := .F.
        EndIF
        IF ( lSection )
            Self:nCLRBack   := oSection:nCLRBack
            Self:nCLRFore   := oSection:nCLRFore 
            Self:oBRDBottom := oSection:oBRDBottom
            Self:oBRDLeft   := oSection:oBRDLeft
            Self:oBRDRight  := oSection:oBRDRight
            Self:oBRDTop    := oSection:oBRDTop
            Self:oCLRBack   := oSection:oCLRBack
            IF( Self:lUserFilter )
                //TODO: Verificar o porque da ocorrencia de erros quando usa (restaura) os filtros salvos nos relatorios R3
                //      A solução para a não ocorrência do erro, ao final do relatório, e criar e salvar um novo     filtro
                //      usando o próprio tReport.
                bErrorBlock := ErrorBlock({|e|BREAK(e)})
                BEGIN SEQUENCE
                    cAlias  := oSection:cAlias
                    lSQL    := (cAlias)->( RddName() == "TOPCONN" )
                    cFilter := oSection:GetUserExp(@cAlias,@lSQL)
                    IF .NOT.( Empty( cFilter ) )
                        oSection:SetFilter(IF(lSQL,"@","")+cFilter,,,@cAlias)
                    EndIF
                END SEQUENCE
                ErrorBlock(bErrorBlock)    
            EndIF
        EndIF    

    EndIF
    
Return(Self)

//----------------------------------------------------------------------------
    /*
        Programa    : uTCREPORT.prg
        Method      : SetFont
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 27/09/2012 
    */
//----------------------------------------------------------------------------
METHOD SetFont(oFont,lHeader) CLASS uTCREPORT

    Local cFont

    Local oLFont

    DEFAULT lHeader := .F.
    
    cFont    := IF( lHeader , "__oTHFont" , "__oTBFont" )
    
    DEFAULT oFont   := IF((Type(cFont)=="O"),IF(lHeader,__oTHFont,__oTBFont),NIL)

    IF ( lHeader )
        oLFont := IF((Self:oHFont==NIL),Self:oFontHeader,Self:oHFont)
    Else
        oLFont := IF((Self:oBFont==NIL),Self:oFontBody,Self:oBFont)
    EndIF    

    IF ( oFont == NIL )
        IF ( lHeader )
            DEFAULT Self:oHFont    := Self:oFontHeader
        Else
            DEFAULT Self:oBFont    := Self:oFontBody
        EndIF    
    Else
        IF ( lHeader )
            Self:oHFont    := oFont
        Else
            Self:oBFont    := oFont
        EndIF    
    EndIF

    IF ( lHeader )
        __oTHFont           := Self:oHFont
        DEFAULT oLFont      := Self:oHFont
        Self:oFontHeader    := Self:oHFont
    Else
        __oTBFont           := Self:oBFont
        DEFAULT oLFont      := Self:oBFont
        IF ( ValType(Self:oBFont) == "O" )
            Self:oFontBody  := Self:oBFont
            Self:cFontBody  := Self:oBFont:Name
            Self:nFontBody  := Abs(Self:oBFont:nHeight)
            Self:lBold      := Self:oBFont:Bold
            Self:lItalic    := Self:oBFont:Italic
            Self:lUnderline := Self:oBFont:Underline
        Else
            Self:cFontBody  := "Courier New"
            Self:nFontBody  := 10
            Self:lBold      := .F.
            Self:lItalic    := .F.
            Self:lUnderline := .F.
        EndIF    
    EndIF    

Return( oLFont )

//----------------------------------------------------------------------------
    /*
        Programa    : uTCREPORT.prg
        Method      : ChkBreak
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 27/09/2012 
    */
//----------------------------------------------------------------------------
METHOD ChkBreak() CLASS uTCREPORT
    
    Local cDate
    Local cHFName

    Local lBreak
    
    Local nHFSize
    Local nHorzRes
    
    Local oBrush
    
    lBreak := IsInBreak()
    
    IF (lBreak)
        
        Self:EndPage()

        DEFAULT Self:oPage:nHorzRes := Self:nHPag
        nHorzRes := Self:oPage:nHorzRes

        IF ( Self:lHeaderVisible )
        
            cDate:=DtoC(Date())
            Self:SetFont(,.T.)
            
            cHFName := Self:oFontHeader:Name
            nHFSize := Self:oFontHeader:nHeight

            Self:nPxPage        := Self:Char2Pix("BLACKTDN"+cDate,cHFName,nHFSize)    
            Self:nPxDate        := Self:Char2Pix("BLACKTDN"+cDate,cHFName,nHFSize)
            Self:nPxTitle       := (Self:Char2Pix(Self:cTitle,cHFName,nHFSize)/2)
            Self:nPxDataBase    := Self:Char2Pix("BLACKTDN"+cDate,cHFName,nHFSize)
        
            Self:oPage:nHorzRes -= Self:Char2Pix("BTDN",cHFName,nHFSize)
        
        EndIF    

        Self:StartPage()

        Self:oPage:nHorzRes := nHorzRes
        Self:nLine          := Self:Row()
        
        Self:IncLine(1,.F.)

        oBrush := Self:ClrBack(.T.)
        IF ( oBrush <> NIL )
            Self:FillRect({Self:nLine,0,Self:nVPag,Self:nHPag},@oBrush)
            oBrush:End()
        EndIF

    EndIF

Return(lBreak)

//----------------------------------------------------------------------------
    /*
        Programa    : uTCREPORT.prg
        Method      : HeaderAdd
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 27/09/2012 
    */
//----------------------------------------------------------------------------
METHOD HeaderAdd(aHeader) CLASS uTCREPORT
    Local nAT
    IF (ValType(aHeader)=="A")
        nAT := aScan( Self:aHeaders , { |e| Compare(e,aHeader) } )
        IF ( nAT == 0 )
            aAdd( Self:aHeaders , aHeader )
        EndIF    
    EndIF
Return( Self:aHeaders )

//----------------------------------------------------------------------------
    /*
        Programa    : uTCREPORT.prg
        Method      : HeaderDel
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 27/09/2012 
    */
//----------------------------------------------------------------------------
METHOD HeaderDel(aHeader) CLASS uTCREPORT
    Local nAT := aScan( Self:aHeaders , { |e| Compare(e,aHeader) } )
    IF ( nAT > 0 )
        aDel( Self:aHeaders , nAT )
        aSize( Self:aHeaders , ( Len( Self:aHeaders  ) - 1  ) )
    EndIF    
Return( Self:aHeaders )

//----------------------------------------------------------------------------
    /*
        Programa    : uTCREPORT.prg
        Method      : HeaderPrint
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 27/09/2012 
    */
//----------------------------------------------------------------------------
METHOD HeaderPrint(aHeaders) CLASS uTCREPORT

    Local cLinePrn
    Local xLinePrn

    Local nHeader
    Local nHeaders
    
    Local nField
    Local nFields

    DEFAULT aHeaders    := Array(0)

    //----------------------------------------------------------------------------
        /*
            aHeaders[nHeader][nField][1] -> Col
            aHeaders[nHeader][nField][2] -> Text or bText
            aHeaders[nHeader][nField][3] -> Size
        */
    //----------------------------------------------------------------------------

    nHeaders := Len( aHeaders )
    For nHeader := 1 To nHeaders
        IF .NOT.(Empty(aHeaders[nHeader]))
            cLinePrn := ""
            nFields  := Len( aHeaders[nHeader] )
            For nField := 1 To nFields
                xLinePrn := aHeaders[nHeader][nField][2]
                cLinePrn += PadR(IF((ValType(xLinePrn)=="B"),Eval(xLinePrn),xLinePrn),aHeaders[nHeader][nField][3])
            Next nField
            Self:PrintOut(aHeaders[nHeader][1][1],cLinePrn)
            Self:PrintOut( 0 , "" , 1 )
        EndIF    
    Next nHeader

    Self:PrintOut( 0 , "" , 1 )

Return( Self:nLine )

//----------------------------------------------------------------------------
    /*
        Programa    : uTCREPORT.prg
        Method      : SetPageBreak
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 27/09/2012 
    */
//----------------------------------------------------------------------------
METHOD SetPageBreak() CLASS uTCREPORT 
    Self:IncLine(Self:nVPag+1,.F.)
Return( IsInBreak() )

//----------------------------------------------------------------------------
    /*
        Programa    : uTCREPORT.prg
        Method      : ChkPgBreak
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 27/09/2012 
    */
//----------------------------------------------------------------------------
METHOD ChkPgBreak(nLPrn) CLASS uTCREPORT
    DEFAULT nLPrn     := 0
    IF ((Self:nLine+(Self:nHLine*nLPrn))>=(Self:nVPag-nLPrn))
        Self:SetPageBreak()
    EndIF
    IF ( Self:ChkBreak() )
        Eval(Self:bHPrint,Self:aHeaders)
    EndIF
Return(Self:nLine)

//----------------------------------------------------------------------------
    /*
        Programa    : uTCREPORT.prg
        Method      : IncLine
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 27/09/2012 
    */
//----------------------------------------------------------------------------
METHOD IncLine(nLines,lChkPgBreak) CLASS uTCREPORT
    Local nIncRow
    DEFAULT nLines          := 1
    DEFAULT lChkPgBreak     := .T.
    nIncRow     := (Self:nHLine*nLines)
    Self:nLine  := Self:IncRow(@nIncRow)
    IF ( lChkPgBreak )
        Self:ChkPgBreak()
    EndIF
Return(Self:nLine)

//----------------------------------------------------------------------------
    /*
        Programa    : uTCREPORT.prg
        Method      : PrintOut
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 27/09/2012 
    */
//----------------------------------------------------------------------------
METHOD PrintOut(nPosH,cLinePrt,nNewLine,oBFontPrt,nAlign,cPict) CLASS uTCREPORT 
    
    Local bErrorBlock
    
    Local cType     := ValType(cLinePrt)
    
    Local lPrtLine  := .F.
    Local lFatLine  := .F.
    Local lThinLine := .F.

    Local nRow
    Local nCol

    Local nClrFore

    Self:SetFont()

    DEFAULT nPosH       := 0
    DEFAULT cLinePrt    := ""    
    DEFAULT nNewLine    := 0
    DEFAULT oBFontPrt   := Self:oBFont
    DEFAULT nAlign      := TCR_AL_LEFT

    IF .NOT.( Self:lExcel )
        lPrtLine    := ((cType=="C").and.(("-"$cLinePrt).or.("."$cLinePrt).or.("="$cLinePrt).or.("*"$cLinePrt)))
        IF ( lPrtLine )
            lThinLine := (Empty(StrTran(cLinePrt,"-","")).or.Empty(StrTran(cLinePrt,".","")))
            IF .NOT.( lThinLine )
                lFatLine := (Empty(StrTran(cLinePrt,"=","")).or.Empty(StrTran(cLinePrt,"*","")))
            EndIF
            lPrtLine := ( ( lThinLine ) .or. ( lFatLine ) )
        EndIF
    EndIF    

    IF ( lPrtLine )
        nRow    := Self:nLine
        nCol    := 0
        Self:SetRow(nRow)
        Self:SetCol(nCol)
        IF ( lThinLine )
            Self:ThinLine()
        Else
            Self:FatLine()
        EndIF
    Else
        IF ( ValType(cPict) == "C" )
            cLinePrt    := Transform(cLinePrt,cPict)
            cType    := "C"
        EndIF
        IF .NOT.( cType == "C" )
            cLinePrt := cValToChar( cLinePrt )
        EndIF
        nRow    := Self:nLine
        nCol    := nPosH
        IF ( Self:nHLine <= 1 )
            Cmtr2Pix(@nRow,@nCol)
        Else
            Cmtr2Pix(0,@nCol)
        EndIF    
        Self:SetRow(nRow)
        Self:SetCol(nCol)
        bErrorBlock := ErrorBlock({|e|BREAK(e)})
        BEGIN SEQUENCE
            nClrFore := Self:ClrFore()
        RECOVER
            BEGIN SEQUENCE
                nClrFore := CLR_BLACK
            RECOVER
                nClrFore := 0
            END SEQUENCE    
        END SEQUENCE
        ErrorBlock(bErrorBlock)
        IF ( Self:lExcel )
            Self:PrintText(@cLinePrt,@nRow,@nCol,@nClrFore,Self:cXlsTHStyle)
        Else
            Self:Say(@nRow,@nCol,@cLinePrt,@oBFontPrt,NIL,@nClrFore,NIL,@nAlign)
        EndIF    
    EndIF

Return(Self:IncLine(nNewLine))

//----------------------------------------------------------------------------
    /*
        Programa    : uTCREPORT.prg
        Function    : IsInBreak
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 27/09/2012 
    */
//----------------------------------------------------------------------------
Static Function IsInBreak()
    Local lIsInBreak := (__oTCPrint:nLine==0)
    IF .NOT.(lIsInBreak)
        lIsInBreak := ((__oTCPrint:nLine+__oTCPrint:nHLine)>=__oTCPrint:nVPag)
    EndIF
Return(lIsInBreak)

//----------------------------------------------------------------------------
    /*
        Programa    : uTCREPORT.prg
        Function    : Cmtr2Pix
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 27/09/2012 
    */
//----------------------------------------------------------------------------
Static Function Cmtr2Pix(nRow,nCol)
    __oTCPrint:oPrint:Cmtr2Pix(@nRow,@nCol)
Return({nRow,nCol})

Static Function __SetPrint(__nOpcRpt,cAlias,cProgram,cPergunte,cTitle,cDesc1,cDesc2,cDesc3,lDic,aOrd,lCompres,cSize,uParm12,lFilter,lCrystal,cNameDrv,uParm16,lServer,cPortPrint)

    Local cSvPerg   := cPergunte
    Local cDescription
    
    Local lChkSum   := (__nOpcRpt==RPT_TREPORT)
    
    Local lFLandScape
    
    Local oTRSection

    Local __Dummy
    
    aFill(__aHeaders,0)

    IF ( lChkSum )
        lChkSum := btdnChkSum()
    EndIF    

    __cAlias    := cAlias

    IF .NOT.(lChkSum)
        __Dummy := SetPrint(@cAlias,@cProgram,@cPergunte,@cTitle,@cDesc1,@cDesc2,@cDesc3,@lDic,@aOrd,@lCompres,@cSize,@uParm12,@lFilter,@lCrystal,@cNameDrv,@uParm16,@lServer,@cPortPrint)
    ElseIF (__nOpcRpt==RPT_TREPORT)
        DEFAULT cDesc1 := ""
        DEFAULT cDesc2 := ""
        DEFAULT cDesc3 := ""
        IF .NOT.(Empty(cPergunte))
            //----------------------------------------------------------------------------
            //Forca a Carga das Perguntas
            Pergunte(cPergunte,.T.)
            //----------------------------------------------------------------------------
            //Desabilita a Pergunta no TReport
            cPergunte := ""
        EndIF
        cDescription   := cDesc1 + CRLF
        cDescription   += cDesc2 + CRLF
        cDescription   += cDesc3 + CRLF
        __Dummy             := U_uTCREPORT(@cProgram,@cTitle,@cPergunte,/*bAction*/,@cDescription)
        cPergunte           := cSvPerg  
        oTRSection          := TRSection():New(@__Dummy,@cTitle,@cAlias,@aOrd)
        oTRSection:cAlias    := cAlias
        lFLandScape := (((Type("TAMANHO")=="C").and.TAMANHO=="G").or.((Type("NTAMANHO")=="C").and.NTAMANHO=="G"))
        IF (lFLandScape)
            //----------------------------------------------------------------------------
            //Define o modo de Impressao como Paisagem
            __Dummy:SetLandScape()          
            //----------------------------------------------------------------------------
            //Desabilita a escolha da Orientação de Impressao
            __Dummy:DisableOrientation() 
        EndIF    
    EndIF
Return(__Dummy)

Static Function __SetDefault(__nOpcRpt,aReturn,cAlias,uParm3,lNoAsk,cSize,nFormat)
    Local __Dummy
    IF (__nOpcRpt==RPT_R3)
        __Dumm  := SetDefault(@aReturn,@cAlias,@uParm3,@lNoAsk,@cSize,@nFormat)
    ElseIF ( Type("__oTCPrint") == "O" )
        __Dummy := __oTCPrint
    EndIF
Return(__Dummy)

Static Function __RptStatus(__nOpcRpt,bAction,cTitle,cMsg)
    Local oSection
    Local __Dummy
    IF (__nOpcRpt==RPT_TREPORT)
        __oTCPrint:SetAction({||__oTCPrint:SetTReport(),Eval(bAction)})
        __oTCPrint:SetFont()
        __oTCPrint:SetFont(,.T.)
        __oTCPrint:nHLine := IF((Type("__nLHeigth")=="N"),__nLHeigth,TCR_LINE_HEIGHT)
        __oTCPrint:SetLineHeight(__oTCPrint:nHLine)
        oSection := __oTCPrint:Section(__oTCPrint:cTitle)
        IF ( ValType(oSection)=="O" )
            oSection:nLineHeight := __oTCPrint:nHLine
        EndIF    
        IF ( Type( "__lEdit" ) == "L" )
            __oTCPrint:SetEdit(@__lEdit)
        EndIF    
        __Dummy := __oTCPrint:PrintDialog()
        IF ( __oTCPrint:Cancel() )
            __OurSpool(__nOpcRpt)
        EndIF
    ELSE
        __SetMaxLine(__nOpcRpt)
        __Dummy := RptStatus(@bAction,@cTitle,@cMsg)
    ENDIF
Return(__Dummy)

Static Function __SetRegua(__nOpcRpt,n)
    Local __Dummy
    DEFAULT n := 0
    IF (__nOpcRpt==RPT_TREPORT)
        __Dummy := __oTCPrint:IncMeter(n)
    ELSE
        __Dummy := SetRegua(n)
    ENDIF
Return(__Dummy)

Static Function __IncRegua(__nOpcRpt,c)
    Local cAlias
    Local oSection
    Local __Dummy
    IF (__nOpcRpt==RPT_TREPORT)
        __Dummy := __oTCPrint:IncMeter(c)
        IF ( __oTCPrint:Cancel() )
            oSection    := __oTCPrint:Section(__oTCPrint:cTitle)
            IF (ValType(oSection)=="O")
                cAlias    := oSection:cAlias
                IF (ValType(cAlias)=="C")
                    IF ( Select(cAlias) > 0 )
                        (cAlias)->( dbGoBottom() )
                        (cAlias)->( dbSkip() )
                        While (cAlias)->( .NOT.( Eof() ) )
                            (cAlias)->( dbSkip() )
                        End While
                    EndIF
                EndIF
            EndIF    
            __oTCPrint:CancelPrint()
        EndIF
    ELSE
        __Dummy := IncRegua(c)
        IF (Type("lAbortPrint")=="L")
            IF (lAbortPrint)
                cAlias := __cAlias
                IF (ValType(cAlias)=="C")
                    IF ( Select(cAlias) > 0 )    
                        (cAlias)->( dbGoBottom() )
                        (cAlias)->( dbSkip() )
                        While (cAlias)->( .NOT.( Eof() ) )
                            (cAlias)->( dbSkip() )
                        End While
                    EndIF    
                EndIF
            EndIF
        EndIF
    ENDIF
Return(__Dummy)

Static Function __PrintOut(__nOpcRpt,nRow,nCol,cText,cPict,oBFont)
    Local __Dummy
    #IFDEF __BTDNVDEMO
        Local nHLine
        Local oTFont
    #ENDIF
    IF (__nOpcRpt==RPT_TREPORT)
        IF .NOT.( __lDHeader )
            __oTCPrint:HideHeader()
        ELSE
            __oTCPrint:ShowHeader()
        EndIF
        #IFDEF __BTDNVDEMO
            DEFAULT __nBTDND  := 0
            DEFAULT __oBTDNFD := __SetFont(RPT_TREPORT,"TAHOMA",NIL,10,NIL,.T.,NIL,NIL,NIL,NIL,.F.,.F.)
            nHLine := __oTCPrint:nHLine
            __oTCPrint:nHLine := 60
            __oTCPrint:SetLineHeight(__oTCPrint:nHLine)
            oTFont := __oTCPrint:SetFont(__oBTDNFD)
            IF ( ( ( ++__nBTDND ) % 30 ) == 0 )
                __IncLine(@__nOpcRpt,1)
                IF .NOT.( __oTCPrint:lExcel )
                    __oTCPrint:PrintOut(@nCol,Replicate("-",__oTCPrint:nHPag),0,@__oBTDNFD,NIL,NIL,@cPict)
                EndIF
                __oTCPrint:PrintOut(@nCol,SubStr(Replicate("|BLACKTDN uTCREPORT DEMO",IF(__oTCPrint:lExcel,113,__oTCPrint:nHPag)),1,IF(__oTCPrint:lExcel,113,__oTCPrint:nHPag)),0,@__oBTDNFD,NIL,NIL,@cPict)
                IF .NOT.( __oTCPrint:lExcel )
                    __IncLine(@__nOpcRpt,1)
                    __oTCPrint:PrintOut(@nCol,Replicate("-",__oTCPrint:nHPag),0,@__oBTDNFD,NIL,NIL,@cPict)                    
                EndIF
                __IncLine(@__nOpcRpt,1)
            ENDIF    
            __oTCPrint:nHLine := nHLine
            __oTCPrint:SetLineHeight(__oTCPrint:nHLine)
            __oTCPrint:SetFont(oTFont)
        #ENDIF
        __Dummy := __oTCPrint:PrintOut(@nCol,@cText,0,@oBFont,NIL,NIL,@cPict)
    ELSEIF (__nOpcRpt==RPT_R3)
        __Dummy := PrintOut(@nRow,@nCol,@cText,@cPict,@oBFont)
    ENDIF
Return(__Dummy)

Static Function __Impr(__nOpcRpt,cDetalhe,cFimFolha,nReg,cRoda,nColuna,lSalta,lMVImpSX1,bCabec,bRoda,lQbLinDet)

    Local cDetCab
    Local cWCabec
    
    Local lbRoda
    Local lbCabec
    Local lwCabec0
    Local lIsInBreak

    Local nCb
    Local nRow
    Local nCol
    
    Local __Dummy

       IF (__nOpcRpt==RPT_TREPORT)

        BEGIN SEQUENCE
        
            DEFAULT cFimFolha   := ""
            DEFAULT nReg        := 0
    
            lbRoda      := ( ValType(bRoda) == "B" )
            lIsInBreak  := __IsInPageBreak(__nOpcRpt)    
            IF (;
                    ( cFimFolha $ "FP" );
                    .or.;
                    ( lIsInBreak );
                )
                IF .NOT.( __oTCPrint:nLine == 0 )
                    IF (;
                            ( cFimFolha $ "F" );
                            .or.;
                            .NOT.( cRoda == NIL );
                        )
                        IF .NOT.( lbRoda )
                            __Roda(__nOpcRpt)
                        Else
                            Eval( bRoda )
                        EndIF    
                    EndIF
                EndIF
                __SetPageBreak(@__nOpcRpt)
            EndIF

            IF (;
                    ( cFimFolha == "F" );
                    .or.;
                    (;
                        ( cFimFolha == "P" );
                        .and.;
                        Empty( cDetalhe );
                    );
                )
                BREAK
            EndIF

            lIsInBreak  := __IsInPageBreak(__nOpcRpt)

            IF ( lIsInBreak )
                lbCabec     := ( ValType( bCabec ) == "B" )
                lwCabec0    := ( ( Type( "wCabec0" ) == "N" ) .and. ( wCabec0 > 0 ) )
                IF ( .NOT.( lbCabec ) .and. ( lwCabec0 ) )
                    aEval( __oTCPrint:aHeaders , { |aHeader| __oTCPrint:HeaderDel(aHeader) } )
                    For nCb := 1 To wCabec0
                           cWCabec := ("wCabec"+Alltrim(Str(nCb)))
                           IF .NOT.( Type(cWCabec) == "U" )
                            cDetCab := &(cWCabec)
                            //----------------------------------------------------------------------------
                                /*
                                    aHeaders[nHeader][nField][1] -> Col
                                    aHeaders[nHeader][nField][2] -> Text or bText
                                    aHeaders[nHeader][nField][3] -> Size
                                 */
                             //----------------------------------------------------------------------------
                               __oTCPrint:HeaderAdd( { { 0 , cDetCab , Len(cDetCab) } } )
                           EndIF
                    Next nCb
                Else
                    __oTCPrint:SetCustomText( bCabec )
                EndIF
                __ChkPgBreak(@__nOpcRpt)
            EndIF

            DEFAULT nColuna := 0
            
            nRow    := __oTCPrint:nLine
            nCol    := nColuna
            
            __Dummy := __PrintOut(@__nOpcRpt,@nRow,@nCol,@cDetalhe)
            
            DEFAULT lSalta      := .T.
            DEFAULT lQbLinDet   := .F.
    
            IF ( ( lSalta ) .or. ( lQbLinDet ) )
                __IncLine(@__nOpcRpt,1)
            EndIF
          
         END SEQUENCE   

    ElseIF (__nOpcRpt==RPT_R3)
       
           __Dummy := Impr(@cDetalhe,@cFimFolha,@nReg,@cRoda,@nColuna,@lSalta,@lMVImpSX1,@bCabec,@bRoda,@lQbLinDet)
    
    EndIF

Return(__Dummy)

Static Function __IncLine(__nOpcRpt,n,lChkPgBreak)
    Local __Dummy
    DEFAULT n := 0
    IF (__nOpcRpt==RPT_TREPORT)
        IF .NOT.( __lDHeader )
            __oTCPrint:HideHeader()
        ELSE
            __oTCPrint:ShowHeader()
        EndIF
        __Dummy := __oTCPrint:IncLine(n)
    ElseIF (__nOpcRpt==RPT_R3)
        IF ( Type( "LI" ) == "N" )
            IF .NOT.( varRef( __Dummy , LI ) )
                LI += n    
            EndIF
        ELSEIF ( Type( "nLi" ) == "N" )
            IF .NOT.( varRef( __Dummy , nLi ) )
                nLi += n    
            EndIF
        ELSEIF ( Type( "nLin" ) == "N" )
            IF .NOT.( varRef( __Dummy , nLin ) )
                nLin += n    
            EndIF
        EndIF
        DEFAULT __Dummy := 0
        __Dummy += n
        DEFAULT lChkPgBreak := .T.
        IF ( lChkPgBreak )
            __Dummy := __ChkPgBreak(__nOpcRpt)
        EndIF    
    ENDIF
Return(__Dummy)

Static Function __SetPageBreak(__nOpcRpt)
    Local __Dummy
       IF (__nOpcRpt==RPT_TREPORT)
           __Dummy := __oTCPrint:SetPageBreak()
       ElseIF (__nOpcRpt==RPT_R3)
        __SetMaxLine(__nOpcRpt)
           __Dummy := __IncLine(__nOpcRpt,__nTCRMaxLine+1,.F.)
       EndIF
Return(__Dummy)

Static Function __ChkPgBreak(__nOpcRpt,nLPrn)
    
    Local bCabec
    
    Local cTitulo
    Local cCabec1
    Local cCabec2
    Local cTamanho
    Local cNomeProg
    
    Local lDHeader
    
    Local nComp
    
    Local __Dummy    
    DEFAULT nLPrn     := 0
    
    IF (__nOpcRpt==RPT_TREPORT)
        __Dummy := __oTCPrint:ChkPgBreak(nLPrn)
    ElseIF (__nOpcRpt==RPT_R3)
        IF ( Type( "LI" ) == "N" )
            varRef( __Dummy , LI )
        ELSEIF ( Type( "nLi" ) == "N" )
            varRef( __Dummy , nLi )
        ELSEIF ( Type( "nLin" ) == "N" )
            varRef( __Dummy , nLin )
        EndIF
        IF ( __IsInPageBreak(@__nOpcRpt,@__Dummy,@nLPrn) )
            IF ( Type("__bR3Cabec") == "B" )
                bCabec   := __bR3Cabec
            Else
                lDHeader  := ( ( Type("__lDHeader") == "L" ) .and. __lDHeader )
                IF ( lDHeader )
                    cTitulo     := IF((Type("TITULO")=="C"),TITULO,"")
                    cCabec1     := IF((Type("wCabec1")=="C"),wCabec1,IF((Type("Cabec1")=="C"),Cabec1,""))
                    cCabec2     := IF((Type("wCabec2")=="C"),wCabec2,IF((Type("Cabec2")=="C"),Cabec2,""))
                    cTamanho    := IF((Type("TAMANHO")=="C"),TAMANHO,IF((Type("NTAMANHO")=="C"),NTAMANHO,"G"))
                    cNomeProg   := IF((Type("NOMEPROG")=="C"),NOMEPROG,FunName())
                    nComp       := IF((Type("aReturn")=="A").and.(Len(aReturn)>=4),IF((aReturn[4]==1),15,18),18)
                    bCabec      := { || Cabec(@cTitulo,@cCabec1,@cCabec2,@cNomeProg,@cTamanho,@nComp) }
                EndIF
            EndIF
            DEFAULT bCabec := { || 0 }
            __Dummy := Eval( bCabec )
            __Dummy += 1
            __Dummy := __HeaderPrint()
        EndIF
    EndIF
Return( __Dummy )

Static Function __IsInPageBreak(__nOpcRpt,nLine,nLPrn)
    Local lPGBreak  := .F.
    Local __Dummy   := nLine
    IF (__nOpcRpt==RPT_TREPORT)
        lPGBreak    := IsInBreak()
    ElseIF (__nOpcRpt==RPT_R3)
        DEFAULT __Dummy := 0
        DEFAULT nLPrn   := 0
        __SetMaxLine(__nOpcRpt)
        //----------------------------------------------------------------------------
        // Salto de Página. Neste caso o formulario tem TCR_MAX_LINEREL linhas...
        lPGBreak    := ( __Dummy > ( __nTCRMaxLine - nLPrn ) ) 
        IF ( lPGBreak )
            __Dummy := __SetPageBreak(__nOpcRpt)
        EndIF
        nLine := __Dummy
    EndIF    
Return(lPGBreak)

Static Function __HeaderAdd(__nOpcRpt,aHeader)
    IF (__nOpcRpt==RPT_TREPORT)
        __oTCPrint:HeaderAdd(aHeader)
    ElseIF (__nOpcRpt==RPT_R3)
        aAdd( __aHeaders , aHeader )
    EndIF
Return(__aHeaders)

Static Function __HeaderDel(__nOpcRpt,aHeader)
    Local nAT
    IF (__nOpcRpt==RPT_TREPORT)
        __oTCPrint:HeaderDel(aHeader)
    ElseIF (__nOpcRpt==RPT_R3)
        nAT := aScan( __aHeaders , { |e| Compare(e,aHeader) } )
        IF ( nAT > 0 )
            aDel( __aHeaders , nAT )
            aSize( __aHeaders , ( Len( __aHeaders  ) - 1  ) )
        EndIF    
    EndIF
Return(__aHeaders)

Static Function __HeaderGet(__nOpcRpt)
    Local aHeaders
    IF (__nOpcRpt==RPT_TREPORT)
        aHeaders := __oTCPrint:aHeaders
    ElseIF (__nOpcRpt==RPT_R3)
        aHeaders := __aHeaders
    EndIF
Return(aHeaders)

Static Function __OurSpool(__nOpcRpt,wNRel)
    Local nfh
    Local nFile
    Local bError
    Local bErrorBlock
    Local __Dummy
    Local oSection
    aFill(__aHeaders,0)
    __cAlias := NIL
    __SetMaxLine(__nOpcRpt,TCR_MAX_LINEREL)
    dbCommitAll()
    SET PRINTER TO
    __Dummy := "FechaRel"
    IF FindFunction(__Dummy)
        &__Dummy.(,)    
    EndIF
    __Ms_Flush(__nOpcRpt)
    IF (__nOpcRpt==RPT_R3)
        __Dummy := OurSpool(wNRel)
    ElseIF (__nOpcRpt==RPT_TREPORT)
        bError      := {|e|BREAK(e)}
        bErrorBlock := ErrorBlock(bError)
        BEGIN SEQUENCE
            oSection := __oTCPrint:Section(__oTCPrint:cTitle)
            IF ( ValType( oSection ) == "O" )
                IF ( ( __oTCPrint:lUserFilter ) .OR. .NOT.( Empty(oSection:cFilter) ) )
                    oSection:CloseFilter()
                EndIF
            EndIF    
            IF .NOT.( Empty( __oTCPrint:cFile ) )
                IF File(__oTCPrint:cFile)
                    nFile := -1
                    While ( ( nfh := fOpen(__oTCPrint:cFile) ) == -1 )
                        fClose( ++nFile )
                        IF ( nFile > 99999 )
                            EXIT
                        EndIF
                    End While
                    IF .NOT.( nfh == -1 )
                        fClose( nfh )
                    EndIF
                EndIF    
            EndIF
            __oTCPrint:Finish()
            __oTCPrint:FreeAllObjs()
        RECOVER
            //...
        END SEQUENCE
        ErrorBlock(bErrorBlock)
        IF (Type("__oTCPrint")=="O")
            __oTCPrint := FreeObj(__oTCPrint)
        EndIF
    EndIF
    __Dummy := "FechaRel"
    IF FindFunction(__Dummy)
        &__Dummy.(,)    
    EndIF
    __Ms_Flush(__nOpcRpt)
Return(NIL)

Static Function __Ms_Flush(__nOpcRpt)
    Local oSection
    aFill(__aHeaders,0)
    __cAlias     := NIL
    __SetMaxLine(__nOpcRpt,TCR_MAX_LINEREL)
    IF ((__nOpcRpt==RPT_TREPORT).and.(Type("__oTCPrint")=="O"))
        oSection := __oTCPrint:Section(__oTCPrint:cTitle)
        IF (ValType(oSection)=="O")
            IF ((__oTCPrint:lUserFilter).OR..NOT.(Empty(oSection:cFilter)))
                oSection:CloseFilter()
            EndIF
        EndIF
    EndIF   
Return(MS_FLUSH())

Static Function __Cabec(__nOpcRpt,cTitulo,cCabec1,cCabec2,cPrograma,cTamanho,nFormato,uPar7,lPerg,cLogo)
    Local __Dummy
    __SetPageBreak(@__nOpcRpt)
    IF (__nOpcRpt==RPT_TREPORT)
        __oTCPrint:cTitle    := cTitulo
        aEval( __oTCPrint:aHeaders , { |aHeader| __oTCPrint:HeaderDel(aHeader) } )
        IF .NOT.( Empty( cCabec1 ) )
            //----------------------------------------------------------------------------
                /*
                *    aHeaders[nHeader][nField][1] -> Col
                *     aHeaders[nHeader][nField][2] -> Text or bText
                *    aHeaders[nHeader][nField][3] -> Size
                */
            //----------------------------------------------------------------------------
            __oTCPrint:HeaderAdd( { { 0 , cCabec1 , Len(cCabec1) } } )
        EndIF
        IF .NOT.( Empty( cCabec2 ) )
            //----------------------------------------------------------------------------
                /*
                *    aHeaders[nHeader][nField][1] -> Col
                *    aHeaders[nHeader][nField][2] -> Text or bText
                *    aHeaders[nHeader][nField][3] -> Size
                */
            //----------------------------------------------------------------------------
            __oTCPrint:HeaderAdd( { { 0 , cCabec2 , Len(cCabec2) } } )
        EndIF    
        __Dummy    := __oTCPrint:ChkPgBreak()
    ElseIF (__nOpcRpt==RPT_R3)
        __Dummy    := Cabec(@cTitulo,@cCabec1,@cCabec2,@cPrograma,@cTamanho,@nFormato,@uPar7,@lPerg,@cLogo)
    EndIF
Return(__Dummy)

Static Function __Roda(__nOpcRpt,uPar1,uPar2,cTamanho,lPageAfter)
    Local __Dummy
    IF (__nOpcRpt==RPT_TREPORT)
        __Dummy := __oTCPrint:EndPage(.T.)
    ElseIF (__nOpcRpt==RPT_R3)
        __Dummy := Roda(@uPar1,@uPar2,@cTamanho,@lPageAfter)
    EndIF
Return(__Dummy)

Static Function __GetOrder(__nOpcRpt)
    Local __Dummy
    IF (__nOpcRpt==RPT_TREPORT)
        __Dummy     := __oTCPrint:GetOrder()
    Else
        __Dummy     := IF(((Type("aReturn")=="A").and.(Len(aReturn)>=8)),aReturn[8],1)
    EndIF
    DEFAULT __Dummy := 1
Return(__Dummy) 

Static Function __SetOrder(__nOpcRpt,nOrder)
    Local __Dummy   := __GetOrder(__nOpcRpt)
    Local oSection
    DEFAULT nOrder  := 1
    IF (__nOpcRpt==RPT_TREPORT)
        oSection    := __oTCPrint:Section(__oTCPrint:cTitle)
        IF (ValType(oSection)=="O")
            oSection:SetOrder(nOrder)
        EndIF    
    ElseIF ((Type("aReturn")=="A").and.(Len(aReturn)>=8))
        aReturn[8]  := nOrder
    EndIF
Return(__Dummy) 

Static Function __SetFont(__nOpcRpt,cName,uPar2,nHeight,uPar4,lBold,uPar6,uPar7,uPar8,uPar9,lUnderline,lItalic)
    Local __Dummy
    IF (__nOpcRpt==RPT_TREPORT)
        __Dummy := TFont():New(@cName,@uPar2,@nHeight,@uPar4,@lBold,@uPar6,@uPar7,@uPar8,@uPar9,@lUnderline,@lItalic)
    EndIF
Return(__Dummy)

Static Function __SetLineHeight(__nOpcRpt,n)
    DEFAULT n := TCR_LINE_HEIGHT
Return(n)

Static Function __SetEdit(__nOpcRpt,x)
    Local cType    := ValType(x)
    Local __Dummy  := .F.
    IF (__nOpcRpt==RPT_TREPORT)
        DO CASE
        CASE ( cType == "C")
            x := Upper(x)
            __Dummy := ( x == "ON" )
        CASE ( cType == "L" )
            __Dummy := x
        CASE ( cType == "N" )
            __Dummy := ( x <> 0     )
        ENDCASE
    EndIF    
Return(__Dummy)

Static Function __HeaderPrint(aHeaders)

    Local cLinePrn
    Local xLinePrn

    Local nLine

    Local nHeader
    Local nHeaders

    Local nField
    Local nFields

    DEFAULT aHeaders    := __aHeaders

    //----------------------------------------------------------------------------
        /*
        *    aHeaders[nHeader][nField][1] -> Col
        *    aHeaders[nHeader][nField][2] -> Text or bText
        *    aHeaders[nHeader][nField][3] -> Size
        */
    //----------------------------------------------------------------------------

    IF ( Type( "LI" ) == "N" )
        varRef( nLine , LI )
    ELSEIF ( Type( "nLi" ) == "N" )
        varRef( nLine , nLi )                            '
    ELSEIF ( Type( "nLin" ) == "N" )
        varRef( nLine , nLin )
    Else
        nLine := 0
    EndIF

    nHeaders := Len( aHeaders )
    For nHeader := 1 To nHeaders
        IF .NOT.(Empty(aHeaders[nHeader]))
            cLinePrn := ""
            nFields  := Len( aHeaders[nHeader] )
            For nField := 1 To nFields
                xLinePrn    := aHeaders[nHeader][nField][2]
                cLinePrn    += PadR(IF((ValType(xLinePrn)=="B"),Eval(xLinePrn),xLinePrn),aHeaders[nHeader][nField][3])
            Next nField
            __PrintOut(RPT_R3,nLine,aHeaders[nHeader][1][1],cLinePrn)
            ++nLine
        EndIF
    Next nHeader

    ++nLine

Return( nLine )

Static Function __SetMaxLine(__nOpcRpt,n)
    Local cValTypeN := ValType(n)
    SYMBOL_UNUSED(__nOpcRpt)
    IF ( n == NIL )
        IF (Type("__nR3MaxLine") == "N")
            __nTCRMaxLine := __nR3MaxLine
        Else
            __nTCRMaxLine := TCR_MAX_LINEREL
        EndIF
    Else    
        IF ((cValTypeN=="C").and.(Val(n)==0))
            n := TCR_MAX_LINEREL
        ElseIF .NOT.(cValTypeN=="C")
            n := TCR_MAX_LINEREL
        EndIF
        __nTCRMaxLine := n
    EndIF    
Return(__nTCRMaxLine)

Static Function __FmtLin(__nOpcRpt,aValores,cFundo,cPictN,cPictC,nLin,lImprime,bCabec,nTamLin)
    Local __Dummy
    IF(__nOpcRpt==RPT_R3)
        __Dummy := FmtLin(@aValores,@cFundo,@cPictN,@cPictC,@nLin,@lImprime,@bCabec,@nTamLin)
    Else
        __Dummy := _TCRFmtLin(@__nOpcRpt,@aValores,@cFundo,@cPictN,@cPictC,@nLin,@lImprime,@bCabec,@nTamLin)
    EndIF
Return(__Dummy)

Static Function _TCRFmtLin(__nOpcRpt,aValores,xFundo,cPictN,cPictC,nLin,lImprime,bCabec,nTamLin)

    Local cAlias        := Alias()

    Local cCnt          := ""
    Local cChr          := ""
    Local nAT           := 0

    Local i             := 0
    Local j             := 0
    Local nFor          := 1

    Local cFrmt         := ""
    
    Local cPictNPad     := "@E 999,999,999.99"
    Local cPictCPad     := "@!"
    
    Local cDet
    
    Local cFind         := "#"
    Local cReplace      := "±"
    
    Local cTypeFundo    := ValType(xFundo)

    Local nRow
    Local nCol
    
    Local nFundo
    Local nValores      := 0

    IF ( cTypeFundo == "C" )
        xFundo := StrTran(xFundo,cFind,cReplace)
    ElseIF ( cTypeFundo == "A" )
        nFundo := Len(xFundo)
        For i := 1 To nFundo
            xFundo[i] := StrTran(xFundo[i],cFind,cReplace)
        Next i
    EndIF
    
    aValores := IF(Empty(aValores),Array(0),aValores)
    aValores := IF(cTypeFundo=="C",aValores,Array(0))
    lImprime := IF(lImprime==NIL,.T.,lImprime)
    
    nValores :=  Len(aValores)
    For nFor := 1 To nValores
        IF ( ValType(aValores[nFor])=="C" )
            IF ( AT(cReplace,aValores[nFor]) > 0 )
                aValores[nFor] := StrTran(aValores[nFor],cReplace,"_")
            EndIF
        EndIF
    Next nFor
    
    lbCabec := ((ValType(bCabec)=="B").and.__IsInPageBreak(.T.,@nLin,1))
    
    IF ( lbCabec )
        nTamLin := IF(nTamLin==NIL,220,nTamLin)
        xFundo  := ("+"+Replic("-",nTamLin-2)+"+")
        nRow    := __IncLine(@__nOpcRpt,1,.F.)
        nLin    := nRow
        nCol    := 0
        __PrintOut(@__nOpcRpt,@nRow,@nCol,@xFundo)
        Eval(bCabec)
    EndIF

    For i := 1 To nValores
        IF ( ValType(aValores[i]) == "A" )
            IF .NOT.(Empty(aValores[i][2]))
                cCnt:=Transform(aValores[i][1],aValores[i][2])
            Else
                IF ( ValType(aValores[i][1]) == "N" )
                    cCnt:=Str(aValores[i][1])
                Else
                    cCnt:=aValores[i][1]
                EndIf
            EndIF
        Else
            cPictN      := IF(Empty(cPictN),cPictNPad,cPictN)
            cPictC      := IF(Empty(cPictC),cPictCPad,cPictC)
            aValores[i] := IF(aValores[i]==NIL,"",aValores[i])
            IF ( ValType(aValores[i] ) == "N" )
                cCnt:=Transform(aValores[i],cPictN)
            Else
                cCnt:=Transform(aValores[i],cPictC)
            EndIF
        EndIF
        nAT     := 0
        cFrmt   := ""
        nAT     := At(cReplace,xFundo)
        IF ( nAT > 0 )
            cChr:=cReplace
            j    := nAT
            While (cChr==cReplace)
                cChr:=Substr(xFundo,j,1)
                IF (cChr==cReplace)
                    cFrmt+=cChr
                EndIF
                j++
            End While
            IF (Len(cFrmt)>Len(cCnt))
                IF .NOT.( ValType(aValores[i]) == "N" )
                    cCnt += Space(Len(cFrmt)-Len(cCnt))
                Else
                    cCnt := (Space(Len(cFrmt)-Len(cCnt))+cCnt)
                EndIF
            EndIF
            xFundo:=Stuff(xFundo,nAT,Len(cCnt),cCnt)
        EndIF
    Next i

    IF (lImprime)
        IF (cTypeFundo=="C")
            xFundo      := {xFundo}
            cTypeFundo  := "A"
        EndIF
        IF ( cTypeFundo == "A" )
            nFundo := Len(xFundo)
            For i:=1 To nFundo
                nRow    := __IncLine(@__nOpcRpt,1,.F.)
                nLin    := nRow
                nCol    := 0
                cDet    := xFundo[i]
                __PrintOut(@__nOpcRpt,@nRow,@nCol,@cDet)
            Next i
        EndIF
    EndIF
    
    IF ( nValores > 0 )
        aFill( aValores , NIL )
    EndIF

    IF ( .NOT.( Empty(cAlias) ) .and. ( Select(cAlias) > 0 ) )
        dbSelectArea(cAlias)
    EndIF    

Return( xFundo )

Static Function __Interrupt(__nOpcRpt,lEnd)
    Local __Dummy
    IF(__nOpcRpt==RPT_R3)
        __Dummy := Interrupcao(@lEnd)
    Else
        __Dummy := Interrupt(@__nOpcRpt,@lEnd)
    EndIF    
Return(__Dummy)

Static Function Interrupt(__nOpcRpt,lEnd)

    Local cDetalhe  := OemToAnsi(__STR0003)
    
    Local lRet
    
    Local nRow      := 0
    Local nCol      := 0
    
    SysRefresh()
    DEFAULT lEnd    := .F.
    lRet            := lEnd
    
    IF ( lRet )
        __PrintOut(@__nOpcRpt,@nRow,@nCol,@cDetalhe)
    EndIF

Return( lRet )

Static Function btdnChkSum()
    Local lChecked  := StaticCall(btdnChkSum,BTDNRPTCHK,"UTCREPORT",ProcName(1)) 
    BEGIN SEQUENCE
        DEFAULT lChecked    := .F.
        IF .NOT.( lChecked )
            BREAK
        ENDIF
        lChecked    := ((Type("__lBTDNRPTCHK")=="L").and.(__lBTDNRPTCHK))
        IF .NOT.( lChecked )
            BREAK
        EndIF
        lChecked    := ((Type("__cBTDNRPTCHK")=="C").and.(__cBTDNRPTCHK=="UTCREPORT"))
        IF .NOT.( lChecked )
            BREAK
        EndIF
        lChecked    := ((Type("__dBTDNRPTCHK")=="D").and.(DtoS(__dBTDNRPTCHK)>=DtoS(MsDate())))
    END SEQUENCE
Return(lChecked)

//----------------------------------------------------------------------------
//warning W0010 Static Function <?> never called
Static Function __Dummy(lRecursa) 
    lRecursa := .F.
    IF (lRecursa)
        __Dummy(.F.)
        __SetPrint()
        __SetDefault()
        __RptStatus()
        __SetRegua()
        __IncRegua()
        __PrintOut()
        __Impr()
        __IncLine()
        __SetPageBreak()
        __HeaderAdd()
        __HeaderDel()
        __HeaderGet()
        __OurSpool()
        __Ms_Flush()
        __Cabec()
        __Roda()
        __GetOrder()
        __SetOrder()
        __SetFont()
        __SetLineHeight()
        __SetEdit()
        __SetMaxLine()
        __FmtLin()
        __Interrupt()
        btdnChkSum()
   EndIF
Return(lRecursa)
