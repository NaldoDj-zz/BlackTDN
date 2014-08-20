#xcommand DEFINE REPORT [ <oReport> ] NAME <cName> ;
	[ TITLE <cTitle> ] ;
	[ PARAMETER <uParam> ] ;
	[ ACTION <bAction> ] ;
	[ DESCRIPTION <cDesc> ] ;
	[ <lLandscape: LANDSCAPE> ] ;
	[ TOTAL TEXT <cTotalText> ] ;
	[ <lTotalInCol: TOTAL IN COLUMN> ] ;
	[ PAGE TOTAL TEXT <cPageTText> ] ;
	[ <lPageTInCol: PAGE TOTAL IN COLUMN> ] ;
	[ <lTPageBreak: TOTAL PAGE BREAK> ] ;
	[ COLUMN SPACE <nColSpace> ] ;
	[ FORMPARAM <aCustomPar> ] ;
	[ <lNoDict: NODICTIONARY> ] ;
	=> ;
	[ <oReport> := ] TReport():New(<cName>, [ <cTitle> ], [ <uParam> ], [ <bAction> ] ,;
								[ <cDesc> ], [ <.lLandscape.> ], [ <cTotalText> ], [ !<.lTotalInCol.> ],;
								[ <cPageTText> ], [ !<.lPageTInCol.> ], [ <.lTPageBreak.> ], [ <nColSpace> ], [ <aCustomPar> ], [ <.lNoDict.> ] )
	
#xcommand DEFINE SECTION [ <oSection> ] OF <oParent> ;
	[ TITLE <cTitle> ] ;
	[ <table: TABLE, TABLES> <cTable,...> ] ;
	[ <lLoadCells: LOAD CELLS> ] ;
	[ <totaltext: TOTAL TEXT> <cTotalText> ] ;
	[ <lTotalInCol: TOTAL IN COLUMN> ] ;
	[ <lHeaderPage: PAGE HEADER> ] ;
	[ <lHeaderBreak: BREAK HEADER> ] ;
	[ <lPageBreak: PAGE BREAK> ] ;
	[ <lLineBreak: LINE BREAK> ] ;
	[ <lLineStyle: LINE STYLE> ] ;
	[ <lAutoSize: AUTO SIZE> ] ;
	[ ORDERS <aOrder> ] ;
	[ LEFT MARGIN <nLeftMargin> ] ;
	[ COLUMN SPACE <nColSpace> ] ;
	[ SEPARATOR <cSeparator> ] ;
	[ LINES BEFORE <nLinesBefore> ] ;
	[ COLUMNS <nCols> ] ;
	[ COLOR <nClrBack> [,<nClrFore>] ] ;
	=> ;
	[ <oSection> := ] TRSection():New(<oParent>, [ <cTitle> ], [ \{<cTable>\} ], [ <aOrder> ] ,;
								 [ <.lLoadCells.> ], , [ <cTotalText> ], [ !<.lTotalInCol.> ], [ <.lHeaderPage.> ],;
								 [ <.lHeaderBreak.> ], [ <.lPageBreak.> ], [ <.lLineBreak.> ], [ <nLeftMargin> ],;
								 [ <.lLineStyle.> ], [ <nColSpace> ], [<.lAutoSize.>], [<cSeparator>],;
								 [ <nLinesBefore> ], [ <nCols> ], [ <nClrBack> ], [ <nClrFore> ])

#xcommand DEFINE CELL [ <oCell> ] NAME <cName> OF <oParent> ;
	[ ALIAS <cAlias> ] ;
	[ TITLE <cTitle> ] ;
	[ PICTURE <cPicture> ] ;
	[ SIZE <nSize> [ <lPixel: PIXEL> ] ] ;
	[ BLOCK <bBlock> ] ;
	[ ALIGN <cAlign: LEFT,RIGHT,CENTER> ] ;
	[ <lLineBreak: LINE BREAK> ] ;
	[ <lCellBreak: CELL BREAK> ] ;
	[ <lAutoSize: AUTO SIZE> ] ;
	[ HEADER ALIGN <cHeaderAlign: LEFT,RIGHT,CENTER> ] ;
	[ COLUMN SPACE <nColSpace> ] ;
	[ COLOR <nClrBack> [,<nClrFore>] ] ;
	[ <lBold: BOLD> ] ;
	=> ;
	[ <oCell> := ] TRCell():New(<oParent>, <cName>, [ <cAlias> ], [ <cTitle> ],;
							[ <cPicture> ], [ <nSize> ], [ <.lPixel.> ], [ <bBlock> ],;
							[ <"cAlign"> ], [ <.lLineBreak.> ], [ <"cHeaderAlign"> ], [ <.lCellBreak.> ],;
							[ <nColSpace> ], [<.lAutoSize.>], [ <nClrBack> ], [ <nClrFore> ], [<.lBold.>])

#xcommand DEFINE BREAK [ <oBreak> ] [ NAME <cName> ] OF <oParent> ;
	[ WHEN <uBreak> ] ;
	[ TITLE <cTitle> ] ;
	[ <lTotalInLine: TOTAL IN LINE> ] ;
	[ <lPageBreak: PAGE BREAK> ] ;
	=> ;
	[ <oBreak> := ] TRBreak():New(<oParent>, [ <uBreak> ], [ <cTitle> ], [ <.lTotalInLine.> ],;
								[ <cName> ], [ <.lPageBreak.> ])
	
#xcommand DEFINE FUNCTION [ <oFunction> ] [ NAME <cName> ] FROM <oCell> [ OF <oParent>] ;
	[ FUNCTION <cFunction: COUNT,SUM,MAX,MIN,AVERAGE,ONPRINT,TIMESUM,TIMESUB,TIMEAVERAGE> ] ;
	[ BREAK <oBreak> ] ;
	[ TITLE <cTitle> ] ;
	[ PICTURE <cPicture> ] ;
	[ FORMULA <uFormula> ] ;
	[ <lEndSection: NO END SECTION> ] ;
	[ <lEndReport: NO END REPORT> ] ;
	[ <lEndPage: END PAGE> ] ;
	[ <lDisable: DISABLE> ] ;
	[ WHEN <bCondition> ] ;
	[ PRINT WHEN <bCanPrint> ] ;
	=> ;
	[ <oFunction> := ] TRFunction():New(<oCell>, [ <cName> ], [ <"cFunction"> ], [ <oBreak> ],;
									[ <cTitle> ], [ <cPicture> ], [ <uFormula> ], [ !<.lEndSection.> ],;
									[ !<.lEndReport.> ], [ <.lEndPage.> ], [ <oParent> ], [ <bCondition> ],;
									[<.lDisable.>], [ <bCanPrint> ])

#xcommand DEFINE COLLECTION [ <oCollection> ] [ NAME <cName> ] OF <oParent> ;
	[ FUNCTION <cFunction: COUNT,SUM,MAX,MIN,AVERAGE,ONPRINT,TIMESUM,TIMESUB> ] ;
	FORMULA <uFormula> ;
	CONTENT <uContent> ;
	[ BREAK <oBreak> ] ;
	[ TITLE <cTitle> ] ;
	[ PICTURE <cPicture> ] ;
	[ <lEndSection: NO END SECTION> ] ;
	[ <lEndReport: NO END REPORT> ] ;
	[ WHEN <bCondition> ] ;
	=> ;
	[ <oCollection> := ] TRCollection():New([ <cName> ], [ <"cFunction"> ], [ <oBreak> ],;
									[ <cTitle> ], [ <cPicture> ], [ <uFormula> ], [ !<.lEndSection.> ],;
									[ !<.lEndReport.> ], [ <oParent> ], [ <bCondition> ],;
									[ <uContent> ])

#xcommand DEFINE BORDER OF <oObj> <cEdge: EDGE_TOP,EDGE_BOTTOM,EDGE_LEFT,EDGE_RIGHT,EDGE_ALL> [ WEIGHT <nWeight> ] [ COLOR <nRGBColor>] ;
	=> ;
	<oObj>:SetBorder(Subs(<"cEdge">,6), [ <nWeight> ], [ <nRGBColor> ])

#xcommand DEFINE HEADER BORDER OF <oObj> <cEdge: EDGE_TOP,EDGE_BOTTOM,EDGE_LEFT,EDGE_RIGHT,EDGE_ALL> [ WEIGHT <nWeight> ] [ COLOR <nRGBColor>] ;
	=> ;
	<oObj>:SetBorder(Subs(<"cEdge">,6), [ <nWeight> ], [ <nRGBColor> ], .T. )

#xcommand DEFINE CELL BORDER OF <oObj> <cEdge: EDGE_TOP,EDGE_BOTTOM,EDGE_LEFT,EDGE_RIGHT,EDGE_ALL> [ WEIGHT <nWeight> ] [ COLOR <nRGBColor>] ;
	=> ;
	<oObj>:SetCellBorder(Subs(<"cEdge">,6), [ <nWeight> ], [ <nRGBColor> ])

#xcommand DEFINE CELL HEADER BORDER OF <oObj> <cEdge: EDGE_TOP,EDGE_BOTTOM,EDGE_LEFT,EDGE_RIGHT,EDGE_ALL> [ WEIGHT <nWeight> ] [ COLOR <nRGBColor>] ;
	=> ;
	<oObj>:SetCellBorder(Subs(<"cEdge">,6), [ <nWeight> ], [ <nRGBColor> ], .T. )

