#ifndef _PTXLSXML_CH

	#define _PTXLSXML_CH

	/*/
        Arquivo:    PTXLSXML.CH
		Autor:		Marinaldo de Jesus
        Data:		04/12/2011
		Descricao:	Arquivo de Cabecalho utilizado para compatibilizar as classes para geracao
				    de arquivo xml baseada no Harbour Project
        Sintaxe:    #INCLUDE "PTXLSXML.CH"    
	/*/

	#ifndef HB_SYMBOL_UNUSED
		#define HB_SYMBOL_UNUSED( symbol )		( symbol := ( symbol ) )
	#endif

	#include "tfini.ch"
	#include "thbhash.ch"

	#xtranslate HB_OsNewLine()  					=> __cCRLF
	#xtranslate hb_AIns(<a>,<v>,<p>,<l>)			=> aAdd(<a>,<v>,<p>)
	#xtranslate hb_fileExists(<f>)					=> file(<f>)
	#xtranslate hb_fcreate(<f>,<fc>,<fo>)			=> fcreate(<f>,NIL,NIL)
	#xtranslate hb_isChar(<v>)						=> ( ValType(<v>) == "C" )
	#xtranslate HB_IsObject( <v> )					=> ( ValType(<v>) == "O" )
	#xtranslate HB_IsNumeric( <v> )					=> ( ValType(<v>) == "N" )
	#xtranslate Subs(								=> SubStr(
                                                	
	#xtranslate hb_hash()							=> THBHash():New()
	#xtranslate hcolor\[<k>\] := <v>				=> hcolor:hAdd(NIL,<k>,<v>)
	#xtranslate positions\[<k>\] :=  <v>			=> positions:hAdd(NIL,<k>,<v>)
	#xtranslate tmp\[<k>\] :=  <v>					=> tmp:hAdd(NIL,<k>,<v>)
	
	#xtranslate hcol := hb_hash()					=> HB_SYMBOL_UNUSED( hcol )
	#xtranslate cell := hb_hash()					=> HB_SYMBOL_UNUSED( cell )
	#xtranslate cell\[<k>\] :=  <v>				=> ::cells:hAddEx(row,column,<k>,<v>)
	#xtranslate cell\[<k>\]							=> cell:hGetValue(ir,column,<k>,.F.)
	#xtranslate hcol\[<column>\] := <cell>			=> 
	#xtranslate hcol := ::cells\[<row>\]			=> 
	#xtranslate ::cells\[<row>\] := <hcol>			=> 
	
	#xtranslate haux := ::mergeCells\[<row>\]		=> 
	#xtranslate haux\[<col>\] := hb_hash()			=>

	#xtranslate haux\[<col>\]\['width'\]:=<width>		=> ::mergeCells:hAddEx(row,<col>,'width',<width>)
	#xtranslate haux\[<col>\]\['height'\]:=<height>	=> ::mergeCells:hAddEx(row,<col>,'height',<height>)
	#xtranslate ::mergeCells\[<row>\] := <haux>		=>

	#xtranslate haux\[<col>\]\['comment'\]:=<comment>	=> ::comments:hAddEx(row,<col>,'comment',<comment>)
	#xtranslate haux\[<col>\]\['author'\]:=<author>	=> ::comments:hAddEx(row,<col>,'author',<author>)
	#xtranslate ::comments\[<row>\]:= <haux>			=>


	#xtranslate ::colWidth\[<col>\] := <width>		=> ::colWidth:hAddEx(NIL,<col>,<col>,<width>)
	#xtranslate ::rowHeight\[<row>\] := <height>	=> ::rowHeight:hAddEx(NIL,<row>,<row>,<height>)
	
	#xtranslate hb_hPos(::namedColorsIE,<v>)		=> hb_hPos(::namedColorsIE,NIL,NIL,<v>)
	#xtranslate color := ::namedColorsIE\[<k>\] 	=> color := ::namedColorsIE:HGetValue(NIL,NIL,<k>)

	#xtranslate hb_hPos(pData,<v>)					=> hb_hPos(pData,NIL,NIL,<v>)
	#xtranslate pData\[<k>\]						=> pData:HGetValue(NIL,NIL,<k>)
    #xtranslate pData    := auxdata:Value			=> pData	:= positions:hGetKey(NIL,NIL,position,.F.,.T.,.F.)

    #xtranslate position := auxdata:Key				=> position := positions:hGetKey(NIL,auxdata,NIL,.F.,.T.,.T.)
	#xtranslate style:getStyleXML()					=> ::styles\[style\]:getStyleXML()
	#xtranslate sheet:getSheetXML(<handle>)			=> ::sheets\[sheet\]:getSheetXML(<handle>)
	#xtranslate sheet:getErrors()					=> ::sheets\[sheet\]:getErrors()

	#xtranslate LOCAL haux := hb_hash()				=>

	#xcommand IF id == sheet:getID()				=> IF id == ::sheets\[sheet\]:getID()
	#xcommand IF id == style:getID()				=> IF id == ::styles\[style\]:getID()

	#xtranslate style:name(<v>)						=> style:SetName(<v>)

	#xtranslate :alignVertical(<v>)	 				=> :aVertical(<v>)
	#xtranslate :alignVerticaltext()	 			=> :aVerticaltext()
	#xtranslate :setNumberFormat(<fs>) 				=> :NFormat(<fs>)
	#xtranslate :setNumberFormatDate() 				=> :NFormatDate()
	#xtranslate :setNumberFormatTime() 				=> :NFormatTime()
	#xtranslate :setNumberFormatDatetime() 			=> :NFormatDTime()

	#xtranslate alignVertical(<v>)					=> aVertical(<v>)
	#xtranslate alignVerticaltext() 				=> aVerticaltext()
	#xtranslate setNumberFormat(<fs>)	 			=> NFormat(<fs>)
	#xtranslate setNumberFormatDate() 				=> NFormatDate()
	#xtranslate setNumberFormatTime() 				=> NFormatTime()
	#xtranslate setNumberFormatDatetime() 			=> NFormatDTime()

    #xtranslate colIndex := hb_hKeyAt(::colWidth,ic)	=> colIndex := hb_hKeyAt(::colWidth,NIL,ic)
    #xtranslate colWidth := hb_hValueAt(::colWidth,ic)	=> colWidth := hb_hValueAt(::colWidth,NIL,ic)

    #xtranslate row     := hb_hKeyAt(::cells,ir)		=> row		:= hb_hKeyAt(::cells,ir,NIL,NIL,.T.,.T.)
    #xtranslate rowData := hb_hValueAt(::cells,ir)		=> rowData	:= ::cells
    #xtranslate column	:= hb_hKeyAt(rowData,ic)		=> column	:= hb_hKeyAt(rowData,ir,ic,NIL,.F.,.T.)
    #xtranslate cell   	:= hb_hValueAt(rowData,ic)		=> cell   	:= rowData

	#xtranslate STR(::rowHeight\[<row>\],<int>,<dec>) =>;
													   STR(::rowHeight:HGetValue(<row>),<int>,<dec>)

	#xtranslate hb_hPos(::mergeCells,row)					=> ::mergeCells:hATRow(row,.F.)
	#xtranslate hb_hPos(::mergeCells\[<row>\],<column>)	=> ::mergeCells:hATCol(row,column,NIL,NIL,.F.)
	#xtranslate ::mergeCells\[<row>\]\[<column>\]\[<p>\] => ::mergeCells:HGetValue(<row>,<column>,<p>,.F.)

	#xtranslate hb_hPos(::comments,row) 					=> ::comments:hATRow(row,.F.)
	#xtranslate hb_hPos(::comments\[<row>\],<column>) 		=> ::comments:hATCol(row,column,NIL,NIL,.F.)
	#xtranslate ::comments\[<row>\]\[<column>\]\[<p>\] 	=> ::comments:HGetValue(<row>,<column>,<p>,.F.)

	#xtranslate ::formatErrors += tmp				=> aEval( tmp:aTHashID , { \|hash\| aAdd( ::formatErrors:aTHashID , hash ) } ) 
	#xtranslate LEN( ::formatErrors )				=> LEN( ::formatErrors:aTHashID )
	#xcommand RETURN ::formatErrors				=> RETURN ::formatErrors:aTHashID

	#xtranslate CREATE CLASS <clsName>				=> CLASS <clsName> FROM LongClassName
	#xtranslate METHOD <clsName>:<clsMethod> 		=> METHOD <clsMethod> CLASS <clsName>

	#xtranslate FOR EACH auxdata IN positions		=> FOR auxdata := 1 TO Len( IF(!Empty(positions:aTHashID),positions:aTHashID\[1\]\[HASH_ID_OBJCOL\],positions:aTHashID) )
	#xcommand FOR EACH sheet IN ::sheets 			=> FOR sheet := 1 TO Len( ::sheets:aTHashID )
	#xcommand FOR EACH <x> IN <y>					=> FOR <x> := 1 TO Len( <y> )

	#xtranslate len( ::colWidth )					=> IF(!Empty(::colWidth:aTHashID),len(::colWidth:aTHashID\[1\]\[HASH_ID_OBJCOL\]),0)
	#xtranslate len( ::cells )						=> len(::cells:aTHashID )

	#xcommand FOR ic := 1 TO LEN(rowData)			=> FOR ic := 1 TO LEN(rowData:hHashIDObjCol(ir))
	#xcommand FOR ic := 1 TO LEN( ::colWidth )		=> FOR ic := 1 TO LEN(::colWidth:aTHashID)
	#xcommand FOR ir := 1 TO LEN( ::cells )		=> FOR ir := 1 TO LEN(::cells:aTHashID)

	#xtranslate INIT <v>							=> 

	#ifdef TOTVS
		#include "totvs.ch"
	#else
		#include "protheus.ch"
	#endif	
	#include "msobject.ch"

	Static __cCRLF			:= CRLF

#endif
