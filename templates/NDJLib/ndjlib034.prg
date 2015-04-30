#include "totvs.ch"
//------------------------------------------------------------------------------------------------
    /*/
        CLASS:tLogReport
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:27/01/2015
        Descricao:Geracao de Log 
        Sintaxe:tLogReport():New()->Objeto do Tipo tLogReport
    /*/
//------------------------------------------------------------------------------------------------
CLASS tLogReport FROM tHash

    DATA oTReport

    METHOD NEW() CONSTRUCTOR
    METHOD FreeObj()

    METHOD ClassName()
    
    METHOD AddGroup(cLGroupName)
    METHOD AddDetail(cLGroupName,cDetail)

    METHOD PrintDialog(cLotTitle)

ENDCLASS

User Function tLogReport()
Return(tLogReport():New())

METHOD NEW() CLASS tLogReport
	_Super:New()
Return(self)

METHOD ClassName() CLASS tLogReport
Return("TLOGREPORT")

METHOD AddGroup(cLGroupName) CLASS tLogReport
    DEFAULT cLGroupName:="__noname__"
    self:Set(cLGroupName,Array(0))
Return(self)

METHOD AddDetail(cLGroupName,cDetail) CLASS tLogReport
    DEFAULT cLGroupName:="__noname__"
    aAdd(self:Get(cLGroupName),cDetail)
Return(self)

METHOD PrintDialog(cLotTitle) CLASS tLogReport 
    Local aLogs:=self:GetAllSessions()
    Local lPrint:=(Len(self:GetAllSessions())>0)
    BEGIN SEQUENCE
        IF .NOT.(lPrint)
            BREAK
        ENDIF
        self:oTReport:=ReportDef(self,cLotTitle)
        lPrint:=(ValType(self:oTReport)=="O")
        IF .NOT.(lPrint)
            BREAK
        ENDIF
        DEFAULT cLotTitle:="__notitle__"
        lPrint:=self:oTReport:PrintDialog()
    END SEQUENCE
Return(lPrint)

METHOD FreeObj() CLASS tLogReport
    Local aLogs:=self:GetAllSessions()
    aEval(aLogs,{|c|self:Del(c)})
    aSize(aLogs,0)
    IF (ValType(self:oTReport)=="O")
        self:oTReport:=FreeObj(self:oTReport)
    EndIF
    self:=FreeObj(self)
Return(self)

Static Function ReportDef(oself,cLotTitle)

    Local aSections

    Local cReport:=CriaTrab(NIL,.F.)
    Local cSection
    
    Local nD
    Local nJ  
    Local nPageWidth
    
    Local oTReport:=TReport():New(cReport,cLotTitle,NIL,{|oTReport|ReportPrint(@oTReport,@oSections,@oself)},cLotTitle)
    Local oSections:=tHash():New()

    oTReport:SetEdit(.F.)
    oTReport:SetLandScape()
    oTReport:SetTotalInLine(.F.)
    oTReport:cFontBody:="Courier New"

    oTReport:oPrint:=tMSPrinter():New(cLotTitle)
    oTReport:oPrint:SetLandScape()
    oTReport:oPrint:SetpaperSize(9/*A4 210 x 297 mm*/)
    nPageWidth:=oTReport:PageWidth()
    
    cSection:="HeaderLog"
    oSection:=TRSection():New(oTReport,cSection)
    oSections:Set(cSection,oSection)

    TRCell():New(oSection,cSection,cSection,NIL,NIL,nPageWidth)

    oSection:Cell(cSection):oFontBody:=TFont():New("Lucida Console",NIL,12,NIL,.T./*lBold*/,NIL,NIL,NIL,NIL,.F./*lUnderline*/,.T./*lItalic*/)

    cSection:="DetailLog"
    oSection:=TRSection():New(oTReport,cSection)
    oSections:Set(cSection,oSection)

    TRCell():New(oSection,cSection,cSection,NIL,NIL,nPageWidth)

    aSections:=oSections:GetAllSessions()
    nJ:=Len(aSections)
    For nD:=1 To nJ
       cSection:=aSections[nD]
       oSection:=oSections:Get(cSection)
       oSection:SetEdit(.F.)
       oSection:SetHeaderPage(.F.)
       oSection:SetTotalInLine(.F.)
       oSection:SetHeaderBreak(.F.)
       oSection:SetHeaderSection(.F.)
    Next nD
    
Return(oTReport)

Static Procedure ReportPrint(oTReport,oSections,oself)

    Local aLogD
    Local aLogT:=oself:GetAllSessions()
    
    Local cLogD
    Local cLogT
    
    Local cSection
   
    Local nD
    Local nH
    
    Local nTD
    Local nTH:=Len(aLogT)

    Local oSection

    cSection:="HeaderLog"
    oSection:=oSections:Get(cSection)
    oSection:Cell(cSection):SetBlock({||cLogT})

    cSection:="DetailLog"
    oSection:=oSections:Get(cSection)
    oSection:Cell(cSection):SetBlock({||cLogD})   

    oTReport:SetMeter(nTH)
    
    For nH:=1 To nTH
        oTReport:IncMeter()
        cLogT:=aLogT[nH]
        cSection:="HeaderLog"
        oSection:=oSections:Get(cSection)
        oSection:Init()
            oSection:PrintLine()
        oSection:Finish() 
        aLogD:=oself:Get(cLogT)
        nTD:=Len(aLogD)
        For nD:= 1 To nTD
            cLogD:=aLogD[nD]
            cSection:="DetailLog"
            oSection:=oSections:Get(cSection)
            oSection:Init()
                oSection:PrintLine()
            oSection:Finish()
        Next nD
    Next nH

Return