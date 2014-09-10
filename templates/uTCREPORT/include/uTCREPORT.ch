//----------------------------------------------------------------------------
    /*
        include     : uTCREPORT.ch
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 27/09/2012 
    */
//----------------------------------------------------------------------------
#IFNDEF _uTCREPORT_CH

    #include "uTCREPORTDef.ch"
    
    #ifdef SPANISH
        #define __STR0001 "TReport"
        #define __STR0002 "¡Atención!"
        #define __STR0003 "INTERRUMPIDO POR EL USUARIO..."
        #define __STR0004 "R3"
        #define __STR0005 "Opciones de impresión"
        #define __STR0006 "Imprima en"
    #else
        #ifdef ENGLISH
            #define __STR0001 "TReport"
            #define __STR0002 "Attention!"
            #define __STR0003 "STOPPED THE USER ... "
            #define __STR0004 "R3"
            #define __STR0005 "Print Options"
            #define __STR0006 "Print on"
        #else
            #define __STR0001 "TReport"
            #define __STR0002 "Atenção!"
            #define __STR0003 "INTERROMPIDO PELO USUARIO..."
            #define __STR0004 "R3"
            #define __STR0005 "Opções de Impressão" 
            #define __STR0006 "Imprimir em"
        #endif
    #endif

    #xcommand uTCREPORT [<force: FORCE>] ACTIVATE => ;
    _SetOwnerPrvt("__oTCPrint",NIL);;
    _SetOwnerPrvt("__nOpcRpt",.F.);;
    _SetOwnerPrvt("__lDHeader",.T.);;
    IF ( IsBlind() );;
        IF (<.force.>);;
            __nOpcRpt   := RPT_TREPORT;;
        ELSE;;
            __nOpcRpt   := RPT_R3;;
        ENDIF;;    
    ELSE;;
        IF (<.force.>);;
            __nOpcRpt   := RPT_TREPORT;;
        ELSE;;
            __nOpcRpt   := __SWOpcRpt();;
        ENDIF;;
    ENDIF;;

    #xtranslate SetPrint([<prm,...>])    => __SetPrint(@__nOpcRpt,[<prm>])
    #xtranslate SetDefault([<prm,...>])  => __SetDefault(@__nOpcRpt,[<prm>])
    #xtranslate RptStatus([<prm,...>])   => __RptStatus(@__nOpcRpt,[<prm>])
    #xtranslate SetRegua([<prm,...>])    => __SetRegua(@__nOpcRpt,[<prm>])
    #xtranslate IncRegua([<prm,...>])    => __IncRegua(@__nOpcRpt,[<prm>])
    #xtranslate OurSpool([<prm,...>])    => __OurSpool(@__nOpcRpt,[<prm>])
    #xtranslate MS_FLUSH([<prm,...>])    => __Ms_Flush(@__nOpcRpt,[<prm>])
    
    #xtranslate Cabec([<prm,...>])       => __Cabec(@__nOpcRpt,[<prm>])
    #xtranslate Roda([<prm,...>])        => __Roda(@__nOpcRpt,[<prm>])

    #xtranslate Impr([<prm,...>])        => __Impr(@__nOpcRpt,[<prm>])

    #xtranslate FmtLin([<prm,...>])      => __FmtLin(@__nOpcRpt,[<prm>])
    #xtranslate Interrupcao([<prm,...>]) => __Interrupt(@__nOpcRpt,[<prm>])

    #xcommand @ <nRow>,<nCol> PSAY <cText> [FONT <oFont> ][ PICTURE <cPict> ] => __PrintOut(@__nOpcRpt,<nRow>,<nCol>,<cText>,[<cPict>],[<oFont>])
    #xtranslate PrintOut([<prm,...>])   => __PrintOut(@__nOpcRpt,[<prm>])

    #xcommand uTCREPORT ADD HEADER <aHeader>   => __HeaderAdd(@__nOpcRpt,<aHeader>)
    #xcommand uTCREPORT DEL HEADER <aHeader>   => __HeaderDel(@__nOpcRpt,<aHeader>)
    #xcommand uTCREPORT GET HEADER <aHeader>   => <aHeader> := __HeaderGet(@__nOpcRpt)

    #xcommand uTCREPORT HIDE DEFAULT HEADER    => ( __lDHeader := .F. )
    #xcommand uTCREPORT SHOW DEFAULT HEADER    => ( __lDHeader := .T. )

    #xcommand uTCREPORT SET PAGE BREAK         => __SetPageBreak(@__nOpcRpt)
    #xcommand uTCREPORT CHK PAGE BREAK [<n>]   => __ChkPgBreak(@__nOpcRpt,[<n>])
    #xcommand uTCREPORT SET LINE HEIGHT <n>    => __SetLineHeight(@__nOpcRpt,<n>)
    #xcommand uTCREPORT SET EDIT <x:ON,OFF,&>  => __SetEdit(@__nOpcRpt,<(x)>)
    #xcommand uTCREPORT SET EDIT (<x>)         => __SetEdit(@__nOpcRpt,<(x)>)

    #xcommand uTCREPORT SET R3 MAX LINE <n>    => __SetMaxLine(@__nOpcRpt,<n>)
    #xcommand uTCREPORT GET R3 MAX LINE <n>    => <n> := __GetMaxLine(@__nOpcRpt)
    #xcommand uTCREPORT SET R3 CABEC <b>       => __SetR3Cabec(<b>)
    
    #xcommand uTCREPORT GETORDER TO <v>        => <v> := __GetOrder(@__nOpcRpt)
    #xcommand uTCREPORT SETORDER <n>           => __SetOrder(@__nOpcRpt,<n>)

    #xcommand uTCREPORT SET FONT ;
                 [<cName>] ;
                 [ SIZE <nWidth>,<nHeight> ] ;
                 [ <from:FROM USER> ] ;
                 [ <bold: BOLD> ] ;
                 [ <italic: ITALIC> ] ;
                 [ <underline: UNDERLINE> ] ;
                 [ WEIGHT <nWeight> ] ;
                 [ NESCAPEMENT <nEscapement> ] ;
                 [ <header: HEADER> ] ;
           => ;
           __SetFont(__nOpcRpt,[<.header.>],[<cName>],[<nWidth>],[<nHeight>],[<.from.>],[<.bold.>],[<nEscapement>],NIL,[<nWeight>],[<.italic.>],[<.underline.>])
    
    #xcommand nLin := nLin+<n> => __IncLine(@__nOpcRpt,<n>)
    #xcommand ++nLin           => __IncLine(@__nOpcRpt,1)
    #xcommand nLin++           => __IncLine(@__nOpcRpt,1)
    #xcommand ++ nLin          => __IncLine(@__nOpcRpt,1)
    #xcommand nLin ++          => __IncLine(@__nOpcRpt,1)
    #xcommand LI := LI+<n>     => __IncLine(@__nOpcRpt,<n>)
    #xcommand ++LI             => __IncLine(@__nOpcRpt,1)
    #xcommand LI++             => __IncLine(@__nOpcRpt,1)
    #xcommand ++ LI            => __IncLine(@__nOpcRpt,1)
    #xcommand LI ++            => __IncLine(@__nOpcRpt,1)

    #xcommand aReturn\[8\] => __GetOrder(@__nOpcRpt)

    Static Function __SetPrint(__nOpcRpt,cAlias,cProgram,cPergunte,cTitle,cDesc1,cDesc2,cDesc3,lDic,aOrd,lCompres,cSize,uParm12,lFilter,lCrystal,cNameDrv,uParm16,lServer,cPortPrint)
        __oTCPrint := StaticCall(uTCREPORT,__SetPrint,@__nOpcRpt,@cAlias,@cProgram,@cPergunte,@cTitle,@cDesc1,@cDesc2,@cDesc3,@lDic,@aOrd,@lCompres,@cSize,@uParm12,@lFilter,@lCrystal,@cNameDrv,@uParm16,@lServer,@cPortPrint)
    Return(__oTCPrint)

    Static Function __SetDefault(__nOpcRpt,aReturn,cAlias,uParm3,lNoAsk,cSize,nFormat)
        __oTCPrint := StaticCall(uTCREPORT,__SetDefault,@__nOpcRpt,@aReturn,@cAlias,@uParm3,@lNoAsk,@cSize,@nFormat)
    Return(__oTCPrint)

    Static Function __RptStatus(__nOpcRpt,bAction,cTitle,cMsg)
    Return(StaticCall(uTCREPORT,__RptStatus,@__nOpcRpt,@bAction,@cTitle,@cMsg))
    
    Static Function __SetRegua(__nOpcRpt,n)
    Return(StaticCall(uTCREPORT,__SetRegua,@__nOpcRpt,@n))

    Static Function __IncRegua(__nOpcRpt,c)
    Return(StaticCall(uTCREPORT,__IncRegua,@__nOpcRpt,@c))

    Static Function __PrintOut(__nOpcRpt,nRow,nCol,cText,cPict,oFont)
    Return(StaticCall(uTCREPORT,__PrintOut,@__nOpcRpt,@nRow,@nCol,@cText,@cPict,@oFont))

    Static Function __Impr(__nOpcRpt,cDetalhe,cFimFolha,nReg,cRoda,nColuna,lSalta,lMVImpSX1,bCabec,bRoda,lQbLinDet)
    Return(StaticCall(uTCREPORT,__Impr,@__nOpcRpt,@cDetalhe,@cFimFolha,@nReg,@cRoda,@nColuna,@lSalta,@lMVImpSX1,@bCabec,@bRoda,@lQbLinDet))

    Static Function __IncLine(__nOpcRpt,n)
    Return(StaticCall(uTCREPORT,__IncLine,@__nOpcRpt,@n))

    Static Function __SetPageBreak(__nOpcRpt)
    Return(StaticCall(uTCREPORT,__SetPageBreak,@__nOpcRpt))

    Static Function __ChkPgBreak(__nOpcRpt,nLPrn,cFimFolha,bCabec,bRoda,nReg)
    Return(StaticCall(uTCREPORT,__ChkPgBreak,@__nOpcRpt,@nLPrn,@cFimFolha,@bCabec,@bRoda,@nReg))
    
    Static Function __HeaderAdd(__nOpcRpt,aHeader)
    Return(StaticCall(uTCREPORT,__HeaderAdd,@__nOpcRpt,@aHeader))

    Static Function __HeaderDel(__nOpcRpt,aHeader)
    Return(StaticCall(uTCREPORT,__HeaderDel,@__nOpcRpt,@aHeader))

    Static Function __HeaderGet(__nOpcRpt)
    Return(StaticCall(uTCREPORT,__HeaderGet,@__nOpcRpt))

    Static Function __OurSpool(__nOpcRpt,wNRel)
    Return(StaticCall(uTCREPORT,__OurSpool,@__nOpcRpt,@wNRel))
    
    Static Function __Ms_Flush(__nOpcRpt)
    Return(StaticCall(uTCREPORT,__Ms_Flush,@__nOpcRpt))

    Static Function __Cabec(__nOpcRpt,cTitulo,cCabec1,cCabec2,cPrograma,cTamanho,nFormato,uPar7,lPerg,cLogo)
    Return(StaticCall(uTCREPORT,__Cabec,@__nOpcRpt,@cTitulo,@cCabec1,@cCabec2,@cPrograma,@cTamanho,@nFormato,@uPar7,@lPerg,@cLogo))

    Static Function __Roda(__nOpcRpt,uPar1,uPar2,cTamanho,lPageAfter)
    Return(StaticCall(uTCREPORT,__Roda,@__nOpcRpt,@uPar1,@uPar2,@cTamanho,@lPageAfter))
    
    Static Function __GetOrder(__nOpcRpt)
    Return(StaticCall(uTCREPORT,__GetOrder,@__nOpcRpt))

    Static Function __SetOrder(__nOpcRpt,nOrder)
    Return(StaticCall(uTCREPORT,__SetOrder,@__nOpcRpt,@nOrder))

    Static Function __SetFont(__nOpcRpt,lHeader,cName,uPar2,nHeight,uPar4,lBold,uPar6,uPar7,uPar8,uPar9,lUnderline,lItalic)
        Local cVar
        lHeader := IF((lHeader==NIL),.F.,lHeader)
        IF ( lHeader )
            cVar := "__oTHFont"
        Else
            cVar := "__oTBFont"
        EndIF    
        _SetOwnerPrvt(cVar,StaticCall(uTCREPORT,__SetFont,@__nOpcRpt,@cName,@uPar2,@nHeight,@uPar4,@lBold,@uPar6,@uPar7,@uPar8,@uPar9,@lUnderline,@lItalic))
    Return(&(cVar))

    Static Function __SetLineHeight(__nOpcRpt,n)
        _SetOwnerPrvt("__nLHeigth",StaticCall(uTCREPORT,__SetLineHeight,@__nOpcRpt,@n))
    Return(__nLHeigth)

    Static Function __SetEdit(__nOpcRpt,x)
        _SetOwnerPrvt("__lEdit",StaticCall(uTCREPORT,__SetEdit,@__nOpcRpt,@x))
    Return(__lEdit)

    Static Function __SetMaxLine(__nOpcRpt,n)
        _SetOwnerPrvt("__nR3MaxLine",StaticCall(uTCREPORT,__SetMaxLine,@__nOpcRpt,@n))
    Return(__nR3MaxLine)

    Static Function __GetMaxLine(__nOpcRpt)
    Return(__SetMaxLine(@__nOpcRpt))
    
    Static Function __SetR3Cabec(b)
        Local cTypeB := ValType(b)
        _SetOwnerPrvt("__bR3Cabec",NIL)
        __bR3Cabec := IF((cTypeB=="B").or.(cTypeB=="U"),b,NIL)
    Return(__bR3Cabec)

    Static Function __CheckSum()
    Return(StaticCall(uTCREPORT,BTDNChkSum))

    Static Function __FmtLin(__nOpcRpt,aValores,cFundo,cPictN,cPictC,nLin,lImprime,bCabec,nTamLin)
    Return(StaticCall(uTCREPORT,__FmtLin,@__nOpcRpt,@aValores,@cFundo,@cPictN,@cPictC,@nLin,@lImprime,@bCabec,@nTamLin))
    
    Static Function __Interrupt(__nOpcRpt,lEnd)
    Return(StaticCall(uTCREPORT,__Interrupt,@__nOpcRpt,@lEnd))
    
    Static Function __SWOpcRpt()
        Local aRadio        := Array(0)
        Local aParamBox     := Array(0)
        Local nRpt          := RPT_TREPORT
        Local nParamBox
        IF (__CheckSum())
            Private MV_PAR01    := 3
            aAdd(aParamBox,Array(8))
            nParamBox := Len(aParamBox)
            aAdd( aRadio , "1-"+__STR0004 )                     //"R3"
            aAdd( aRadio , "2-"+__STR0001 )                     //"TReport"
            aParamBox[nParamBox][1] := 3                        //Radio
            aParamBox[nParamBox][2] := OemToAnsi(__STR0006)     //Descrição : "Imprimir em?"
            aParamBox[nParamBox][3] := nRpt                     //Numérico contendo a opção inicial do Radio
            aParamBox[nParamBox][4] := aRadio                   //Array contendo as opções do Radio
            aParamBox[nParamBox][5] := 100                      //Tamanho do Radio
            aParamBox[nParamBox][6] := "AllWaysTrue()"          //Validação
            aParamBox[nParamBox][7] := .T.                      //Flag .T./.F. Parâmetro Obrigatório ?
            aParamBox[nParamBox][8] := "AllWaysTrue()"          //String contendo a validação When
            IF ParamBox(@aParamBox,__STR0005,NIL,NIL,NIL,.T.)   //"Opções de Impressão"
                nRpt := MV_PAR01
            EndIF    
        EndIF    
    Return(nRpt)

    Static Function __Dummy(lRecursa) //warning W0010 Static Function <?> never called
        lRecursa := .F.
        IF (lRecursa)
            __Dummy(.F.)
            __SWOpcRpt()
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
            __SetLineHeight()
            __SetEdit()
            __SetMaxLine()
            __GetMaxline() 
            __SetR3Cabec()
            __CheckSum()
            __FmtLin()
            __Interrupt()
       EndIF
    Return(lRecursa)

#ENDIF //_uTCREPORT_CH