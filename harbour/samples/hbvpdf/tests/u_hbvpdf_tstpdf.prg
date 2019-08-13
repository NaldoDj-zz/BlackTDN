#include "totvs.ch"
#include "hbvpdf.ch"
USER FUNCTION tsthbvpdf()

    local nWidth:=200,nTab,nI,nJ,nK,nCol,nRow,aStyle,aFonts
    local nTop,nLeft,nBottom,nRight,cText,oPDF,aText
    local aColor:={;
                   "FF0000","8B0000","800000","FF4500","D2691E","B8860B","FF8C00","FFA500","DAA520","808000","FFD700","FFFF00","ADFF2F","9ACD32","7FFF00","7CFC00","00FF00","32CD32","008000","006400",;
                   "66CDAA","7FFFD4","87CEFA","87CEEB","F0F8FF","E0FFFF","B0C4DE","B0E0E6","AFEEEE","ADD8E6","8FBC8F","90EE90","98FB98","00FA9A","00FF7F","3CB371","2E8B57","228B22","556B2F","6B8E23",;
                   "5F9EA0","40E0D0","48D1CC","00CED1","20B2AA","008B8B","008080","2F4F4F","00BFFF","00FFFF","00FFFF","0000FF","0000CD","00008B","000080","1E90FF","4169E1","4682B4","6495ED","7B68EE",;
                   "C71585","FF1493","FF00FF","FF00FF","9370DB","DDADDD","DB7093","FF69B4","DA70D6","EE82EE","BA55D3","9932CC","8A2BE2","9400D3","8B008B","800080","4B0082","191970","483D8B","6A5ACD",;
                   "DC143C","B22222","A52A2A","CD5C5C","FA8072","E9967A","FFA07A","F5DEB3","FFDEAD","EEE8AA","FFDAB9","FFE4C4","FFEFD5","FFE4E1","FFE4B5","D2B48C","DEB887","F0E68C","BDB76B","F4A460",;
                   "FDF5E6","FFF8DC","FAF0E6","FAFAD2","FFFACD","FFEBCD","FFFFE0","FAEBD7","FFF5EE","FFF0F5","D8BFD8","FFC0CB","FFB6C1","BC8F8F","F08080","FF7F50","FF6347","8B4513","A0522D","CD853F",;
                   "FFFAFA","FFFFF0","E6E6FA","FFFAF0","F8F8FF","F0FFF0","F5F5DC","F0FFFF","F5FFFA","708090","778899","F5F5F5","DCDCDC","D3D3D3","C0C0C0","A9A9A9","808080","696969","000000","FFFFFF";
    }
    Local cTempPath:=(GetTempPath()+"hbvpdf\")
    Local cTempFile:=(cTempPath+CriaTrab(NIL,.F.))
    Local cPDFFile:=(cTempFile+".pdf")
    Local cPDFHeader:=(cTempFile+".hea")

    set date format "YYYY/MM/DD"

    SYMBOL_UNUSED(__cCRLF)

    IF !(hbvpdfResources(cTempPath))
        hbvpdfResources(cTempPath,.T.)
        Return(.f.)
    EndIF

    While File(cPDFFile) .or. File(cPDFHeader)
           cTempFile:=(cTempPath+CriaTrab(NIL,.F.))
           cPDFFile:=(cTempFile+".pdf")
           cPDFHeader:=(cTempFile+".hea")
    End While

    aStyle:={"Normal","Bold","Italic","BoldItalic"}

    aFonts:={{"Times",.t.,.t.,.t.,.t.},;
            {"Helvetica",.t.,.t.,.t.,.t.},;
            {"Courier",.t.,.t.,.t.,.t.}
    }

    oPDF:=tPdf():New(cPDFFile,nWidth,.t.)
    oPDF:EditOnHeader()
    oPDF:Image(cTempPath+"BlackTDNBlog_1246_212_r1.JPG",0,0,"M",25,oPDF:WIDTH()) // file,row,col,units,height,width
    oPDF:EditOffHeader()
    oPDF:SaveHeader(cPDFHeader)
    oPDF:BookOpen()

    GetText(2,@aText)

    nFontSize:=oPDF:FontSize(12)

    oPDF:NewPage("LETTER","P",6)
    oPDF:BookAdd("tPDF",1,oPDF:PageNumber(),0)
    oPDF:BookAdd("Change Log",2,oPDF:PageNumber(),0)
    nTab:=0
    oPDF:SetFont("Helvetica",NIL,oPDF:FontSize())
    For nI:=1 To Len(aText)
        cText:=aText[nI]
        IF ("("$cText)
            cText:=oPDF:StringB(cText)
        EndIF
        oPDF:Text(cText,nI,5,nWidth,nTab,1,"",oPDF:Colorize(oPDF:rgbToHex(75,0,130)))
    Next nI

    oPDF:FontSize(nFontSize)

    *   oPDF:CloseHeader()

    oPDF:NewPage("LETTER","P",6)
    oPDF:BookAdd("Grids & Borders",1,oPDF:PageNumber(),0)
    oPDF:BookAdd("Simple Grid",2,oPDF:PageNumber(),0)

    for nI:=0 to 792 step 36
       oPDF:Box(nI,0,nI,612,0.01,,"D")
    next nI
    for nI:=0 to 612 step 36
       oPDF:Box(0,nI,792,nI,0.01,,"D")
    next nI

    oPDF:NewPage("LETTER","P",6)
    oPDF:BookAdd("10 dots border ",2,oPDF:PageNumber(),0)
    oPDF:Box(0,0,792,612,10,,"D")
    nFontSize:=oPDF:FontSize(12)
    nTab:=0
    oPDF:SetFont("Arial",BOLDITALIC,oPDF:FontSize())
    For nI:=1 To Len(aText)
        cText:=aText[nI]
        IF ("("$cText)
            cText:=oPDF:StringB(cText)
        EndIF
        oPDF:Text(cText,nI,5,nWidth,nTab,1,"",oPDF:Colorize(oPDF:rgbToHex(75,0,130)))
    Next nI
    oPDF:FontSize(nFontSize)

    oPDF:NewPage("LETTER","P",6)
    oPDF:BookAdd("Boxes",1,oPDF:PageNumber(),0)
    oPDF:BookAdd("Boxes",2,oPDF:PageNumber(),0)

    nRow:=85
    nCol:=85
    oPDF:Box(nRow,(nCol*2),(nRow*3),(nCol*4),1.00,15,"D")
    oPDF:Box(nRow+10,(nCol*2)+10,(nRow*3)+10,(nCol*4)+10,0.50,25,"D")
    oPDF:Box(nRow+20,(nCol*2)+20,(nRow*3)+20,(nCol*4)+20,0.25,35,"D")
    oPDF:Box(nRow+30,(nCol*2)+30,(nRow*3)+30,(nCol*4)+30,0.15,45,"D")
    oPDF:Box(nRow+40,(nCol*2)+40,(nRow*3)+40,(nCol*4)+40,0.10,55,"D")
    oPDF:Box(nRow+50,(nCol*2)+50,(nRow*3)+50,(nCol*4)+50,0.05,65,"D")
    oPDF:Box(nRow+60,(nCol*2)+60,(nRow*3)+60,(nCol*4)+60,0.01,75,"D")
    oPDF:Box(nRow+70,(nCol*2)+70,(nRow*3)+70,(nCol*4)+70,0.01,85,"D")
    oPDF:Box(nRow+80,(nCol*2)+80,(nRow*3)+80,(nCol*4)+80,0.01,95,"D")
    oPDF:Box(nRow+90,(nCol*2)+90,(nRow*3)+90,(nCol*4)+90,0.01,100,"D")

    for nI:=1 to 7
      nRow:=150+nI*10
      for nJ:=1 to 20
          nCol:=nJ*10-3
          oPDF:Box(nRow,nCol,nRow+10,nCol+10,0.01,nI*10,"M",oPDF:Colorize(aColor[(nI-1)*20+nJ]))
      next nJ
    next nI

    oPDF:NewPage("LETTER","P",6)
    oPDF:BookAdd("Color Boxes ",2,oPDF:PageNumber(),0)
    for nI:=1 to 140
       nTop:=(nI-1)*2.4
       nLeft:=(nI-1)*2.1
       nBottom:=oPDF:PageY()-(nI-1)*2.47
       nRight:=oPDF:PageX()-(nI-1)*2.18
       oPDF:Box1(nTop,nLeft,nBottom,nRight,10,oPDF:Colorize(aColor[Len(aColor)+1-nI]))
    next nI

    oPDF:NewPage("LETTER","P",6)
    oPDF:BookAdd("Memos",1,oPDF:PageNumber(),0)
    oPDF:BookAdd("Different Styles & Colors",2,oPDF:PageNumber(),0)
    nWidth:=90
    nTab:=0
    cText:=GetText(1)

    oPDF:Text(cText,8,107.95,nWidth,nTab,5,'M',oPDF:Colorize(oPDF:rgbToHex(255,215,0)))
    oPDF:Text(cText,40,107.95,nWidth,nTab,3,'M',oPDF:Colorize(oPDF:rgbToHex(160,82,45)))
    oPDF:Text(cText,72,107.95,nWidth,nTab,2,'M',oPDF:Colorize(oPDF:rgbToHex(75,0,130)))
    oPDF:Text(cText,112,107.95-nWidth / 2,nWidth,nTab,1,'M',oPDF:Colorize(oPDF:rgbToHex(0,139,139)))

    oPDF:Text(cText,34,100,nWidth,nTab,5,'R',oPDF:Colorize(oPDF:rgbToHex(219,112,147)))
    oPDF:Text(cText,41,100,nWidth,nTab,3,'R',oPDF:Colorize(oPDF:rgbToHex(72,61,139)))
    oPDF:Text(cText,48,100,nWidth,nTab,2,'R',oPDF:Colorize(oPDF:rgbToHex(0,100,0)))
    oPDF:Text(cText,55,35,nWidth,nTab,1,'R',oPDF:Colorize(oPDF:rgbToHex(105,105,105)))

    oPDF:NewPage("LETTER","P",6)
    oPDF:BookAdd("Fonts",1,oPDF:PageNumber(),0)
    oPDF:BookAdd("Different Styles",2,oPDF:PageNumber(),0)
    nK:=6
    for nI:=1 to len(aFonts)  // Fonts
        ++nk
        for nJ:=1 to 4           // Styles
            if aFonts[nI][nJ+1]
                oPDF:SetFont(aFonts[nI][1],nJ-1,oPDF:FontSize())
                oPDF:RJust("This is a test for "+aFonts[nI][1]+" "+aStyle[nJ],nK++,oPDF:WIDTH(),"R")
            endif
        next nJ
        oPDF:RJust(oPDF:Underline("Underline"),nK++,oPDF:WIDTH(),"R")
        oPDF:RJust(oPDF:Reverse("Test"),nK,oPDF:WIDTH(),"R")
    next nI

    oPDF:NewPage("LETTER","P",6)
    oPDF:BookAdd("Pictures",1,oPDF:PageNumber(),0)
    oPDF:BookAdd("JPEG",2,oPDF:PageNumber(),0)
    oPDF:Image(cTempPath+"BlackTDNBlog_1246_212_r1.JPG",50,0,"M",25,oPDF:WIDTH()) // file,row,col,units,height,width
    oPDF:Text(OemToAnsi("Subi num pé de melância pra comer batata Frita"),9,5,oPDF:WIDTH(),0,1,"",oPDF:Colorize(oPDF:rgbToHex(150,20,60)))
    oPDF:Text(OemToAnsi("Como o tempo era de manga eu cai da bicicleta"),11,5,oPDF:WIDTH(),0,1,"",oPDF:Colorize(oPDF:rgbToHex(150,20,60)))
    oPDF:RJust(oPDF:Underline("JPEG"),0,oPDF:WIDTH()+10,"R")

    oPDF:NewPage("LETTER","P",6)
    oPDF:BookAdd("JPEG",2,oPDF:PageNumber(),0)
    oPDF:Image(cTempPath+"bannerBlackTDN_160_64.JPG",0,0,"M") // file,row,col,units,height,width
    oPDF:RJust(oPDF:Underline("JPEG"),0,oPDF:WIDTH()+10,"R")

    oPDF:NewPage("LETTER","P",6)
    oPDF:BookAdd("JPEG",2,oPDF:PageNumber(),0)
    oPDF:Image(cTempPath+"BlackTDN_250x250.JPG",50,0,"M",Min(oPDF:WIDTH(),250)/100*50,Min(oPDF:WIDTH(),250)/100*50) // file,row,col,units,height,width
    oPDF:RJust(oPDF:Underline("JPEG"),0,oPDF:WIDTH()+10,"R")

    oPDF:NewPage("LETTER","P",6)
    oPDF:BookAdd("TIFF",2,oPDF:PageNumber(),0)
    //             file,row,col,units,height,width
    oPDF:Image(cTempPath+"hbvpdf_color.tif",0,0,"M")
    oPDF:RJust(oPDF:Underline("TIFF"),0,oPDF:WIDTH()+10,"R")

    oPDF:NewPage("LETTER","P",6)
    oPDF:BookAdd("JPEG",2,oPDF:PageNumber(),0)
    oPDF:Image(cTempPath+"hbvpdf_color.jpg",30,0,"M")
    oPDF:RJust(oPDF:Underline("JPEG"),0,oPDF:WIDTH()+10,"R")

    oPDF:NewPage("LETTER","P",6)
    oPDF:BookAdd("JPEG",2,oPDF:PageNumber(),0)
    oPDF:Image(cTempPath+"pdf_logo.jpg",0,0,"M",Min(oPDF:WIDTH(),250)/100*12,Min(oPDF:WIDTH(),250)/100*12)
    oPDF:RJust(oPDF:Underline("JPEG"),0,oPDF:WIDTH()+10,"R")

    oPDF:OpenHeader(cPDFHeader)

    oPDF:NewPage("LETTER","P",6)
    oPDF:BookAdd("Headers",1,oPDF:PageNumber(),0)
    oPDF:BookAdd("Picture Header Page 14",2,oPDF:PageNumber(),0)

    oPDF:SetFont("Helvetica",NIL,oPDF:FontSize())
    oPDF:AtSay(oPDF:Colorize(oPDF:rgbToHex(251,45,5))+'Red Sample of header repeating on pages 14-16',1,20,"R")

    oPDF:NewPage("LETTER","P",6)
    oPDF:BookAdd("Picture Header Page 15",2,oPDF:PageNumber(),0)

    oPDF:SetFont("Helvetica",NIL,oPDF:FontSize())
    oPDF:AtSay(oPDF:Colorize(oPDF:rgbToHex(31,102,36))+'Green Sample of header repeating on pages  15-16',1,20,"R")

    oPDF:NewPage("LETTER","P",6)
    oPDF:BookAdd("Picture Header Page 16",2,oPDF:PageNumber(),0)

    oPDF:SetFont("Helvetica",NIL,oPDF:FontSize())
    oPDF:AtSay(oPDF:Colorize(oPDF:rgbToHex(44,95,172))+'Blue Sample of header repeating on pages  16-16',1,20,"R")

    oPDF:Close()

    oPDF:Execute(cPDFFile)

    //oPDF:FilePrint()

    oPDF:=FreeObj(oPDF)

    hbvpdfResources(cTempPath,.T.)
    fErase(cPDFHeader)

return(.t.)

Static Function GetText(nText,aText)

    Local cText:=""

    IF nText==1

        cText+="Subi num pé de melância pra comer batata frita,"+__cCRLF
        cText+="como o tempo era de manga,eu cai da bicicleta"+__cCRLF
        cText:=OemToAnsi(cText)

    Else

        cText+=__cCRLF+";"
        cText+=__cCRLF+";"
        cText+="Welcome to _pure_ Clipper Pdf Library!"+";"
        cText+=__cCRLF+";"
        cText+="Changes in Release 0.08"+";"
        cText+="1. Fixed page buffer string overflow."+";"
        cText+=__cCRLF+";"
        cText+="Changes in Release 0.07a"+";"
        cText+="1. Fixed minor errors with JPEG function to work properly with GRAY & RGB"+";"
        cText+=__cCRLF+";"
        cText+="Changes in Release 0.07."+";"
        cText+="1. Fixed minor errors"+";"
        cText+=__cCRLF+";"
        cText+="Changes in Release 0.06."+";"
        cText+="1. Added new function pdfBox1 for colorful boxes"+";"
        cText+="2. Added new page to demo program"+";"
        cText+=__cCRLF+";"
        cText+="Changes in Release 0.05."+";"
        cText+="All changes commented as // 0.04."+";"
        cText+="1. Added #ifdef-#endif for Harbour support (see end of file pdf.prd)"+";"
        cText+="2. Fixed minor error for allow different page sizes (A4,...)"+";"
        cText+=__cCRLF+";"
        cText+="Changes in Release 0.04."+";"
        cText+="All changes commented as // 0.04."+";"
        cText+="1. Added Courier font."+";"
        cText+="2. TOP,LEFT,BOTTOM changed to PDFTOP,PDFLEFT,PDFBOTTOM to avoid conflicts."+";"
        cText+="All changes commented as // 0.04."+";"
        cText+="**** Please note 3 most popular fonts now available: Times,Helvetica"+";"
        cText+=",Courier. When you calling pdfSetFont,please use only above names."+";"
        cText+=__cCRLF+";"
        cText+="Changes in Release 0.03."+";"
        cText+="Replaced function from Clipper Tools and Nanfor for Clipper Source."+";"
        cText+=__cCRLF+";"
        cText+="This is first public release 0.02."+";"
        cText+=__cCRLF+";"
        cText+="Please send your comments on"+";"
        cText+="andvit@sympatico.ca"+";"
        cText+="Thank you"+";"

        aText:=StrTokArr2(cText,";")

    EndIF

Return(cText)

Static Function hbvpdfResources(cTempPath,lRemove)

    Local aResources:=Array(0)

    LOCAL lOK:=.F.

    BEGIN SEQUENCE

        IF !lIsDir(cTempPath)
            MakeDir(cTempPath)
        EndIF

        lOK:=lIsDir(cTempPath)
        IF !(lOK)
            BREAK
        EndIF

        aAdd(aResources,"bannerBlackTDN_160_64.JPG")
        aAdd(aResources,"BlackTDNBlog_1246_212_r1.JPG")
        aAdd(aResources,"BlackTDN_250x250.JPG")
        aAdd(aResources,"hbvpdf_color.jpg")
        aAdd(aResources,"hbvpdf_color.tif")
        aAdd(aResources,"pdf_logo.jpg")

        DEFAULT lRemove:=.F.
        IF (lRemove)
            aEval(aResources,{|cResName|IF(File(cTempPath+cResName),FErase(cTempPath+cResName),NIL)})
        Else
            aEval(aResources,{|cResName|IF(lOK,lOK:=Resource2File(cResName,cTempPath+cResName),NIL)})
        EndIF

    END SEQUENCE

Return(lOK)
