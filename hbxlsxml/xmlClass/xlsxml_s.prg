/*
 * #Id: xlsxml_s.prg 17099 2011-10-28 18:34:39Z vouchcac $
 */

 /*
 * Harbour Project source code:
 *
 * Copyright 2011 Fausto Di Creddo Trautwein, ftwein@yahoo.com.br
 * www - http://www.xharbour.org http://harbour-project.org
 *
 * Thanks TO Robert F Greer, PHP original version
 * http://sourceforge.net/projects/excelwriterxml/ 
 *
 * This program is free software; you can redistribute it AND/OR modify
 * it under the terms of the GNU General PUBLIC License as published by
 * the Free Software Foundation; either version 2, OR( at your option )
 * any later version.
 *
 * This program is distributed IN the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General PUBLIC License FOR more details.
 *
 * You should have received a copy of the GNU General PUBLIC License
 * along WITH this software; see the file COPYING.  IF NOT, write TO
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA( OR visit the web site http://www.gnu.org/ ).
 *
 * As a special exception, the Harbour Project gives permission FOR
 * additional uses of the text contained IN its release of Harbour.
 *
 * The exception is that, IF you link the Harbour libraries WITH other
 * files TO produce an executable, this does NOT by itself cause the
 * resulting executable TO be covered by the GNU General PUBLIC License.
 * Your use of that executable is IN no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does NOT however invalidate any other reasons why
 * the executable file might be covered by the GNU General PUBLIC License.
 *
 * This exception applies only TO the code released by the Harbour
 * Project under the name Harbour.  IF you copy code FROM other
 * Harbour Project OR Free Software Foundation releases into a copy of
 * Harbour, as the General PUBLIC License permits, the exception does
 * NOT apply TO the code that you add IN this way.  TO avoid misleading
 * anyone as TO the status of such modified files, you must delete
 * this exception notice FROM them.
 *
 * IF you write modifications of your own FOR Harbour, it is your choice
 * whether TO permit this exception TO apply TO your modifications.
 * IF you DO NOT wish that, delete this exception notice.
 *
 */
/*----------------------------------------------------------------------*/

#IFDEF __HARBOUR__
    #include "hbclass.ch"
#ELSE
    #include "ptxlsxml.ch"
#ENDIF    

/*----------------------------------------------------------------------*/

CREATE CLASS ExcelWriterXML_Sheet 

   DATA   id
   DATA   cells                                   INIT hb_hash()
   DATA   colWidth                                INIT hb_hash()
   DATA   rowHeight                               INIT hb_hash()
   DATA   URLs                                    INIT hb_hash()
   DATA   mergeCells                              INIT hb_hash()
   DATA   comments                                INIT hb_hash()
   DATA   formatErrors                            INIT hb_hash()
   DATA   ldisplayRightToLeft                     INIT .f.

   METHOD new( id )
   METHOD getID()
   METHOD addError( cFunction, cMessage )
   METHOD getErrors()
   METHOD writeFormula( dataType, row, column, xData, style )
   METHOD writeString( row, column, xData, style )
   METHOD writeNumber( row, column, xData, style )
   METHOD writeDateTime( row, column, xData, style )
   METHOD writeData( type, row, column, xData, style, formula )
   METHOD displayRightToLeft()
   METHOD getSheetXML( handle )
   METHOD cellWidth( row, col, width )
   METHOD columnWidth( col, width )
   METHOD cellHeight( row, col, height )
   METHOD setRowHeight( row, height )
   METHOD cellMerge( row,col, width, height )
   METHOD addComment( row, col, comment, author )
   
   ENDCLASS

/*----------------------------------------------------------------------*/

METHOD ExcelWriterXML_Sheet:new( id ) 

#ifndef __HARBOUR__
   ::id
   ::cells                  := hb_hash()
   ::colWidth               := hb_hash()
   ::rowHeight              := hb_hash()
   ::URLs                   := hb_hash()
   ::mergeCells             := hb_hash()
   ::comments               := hb_hash()
   ::formatErrors           := hb_hash()
   ::ldisplayRightToLeft    := .f.
#endif

   ::id := id 
   
   RETURN SELF
   
/*----------------------------------------------------------------------*/

METHOD ExcelWriterXML_Sheet:getID() 
      RETURN ::id
   
/*----------------------------------------------------------------------*/
      
METHOD ExcelWriterXML_Sheet:addError( cFunction, cMessage ) 
   LOCAL tmp := hb_hash()
   
   tmp[ 'sheet'        ] := ::id
   tmp[ 'FUNCTION'  ] := cFunction
   tmp[ 'MESSAGE'   ] := cMessage
   ::formatErrors += tmp
   RETURN NIL

/*----------------------------------------------------------------------*/
      
METHOD ExcelWriterXML_Sheet:getErrors() 
#ifdef __HARBOUR__
   RETURN ::formatErrors
#else
    RETURN ::formatErrors:aTHashID
#endif
/*----------------------------------------------------------------------*/
         
METHOD ExcelWriterXML_Sheet:writeFormula( dataType, row, column, xData, style ) 

   HB_SYMBOL_UNUSED( dataType )
   
   ::writeData( 'String', row, column, '', style, xData )
   
   RETURN NIL

/*----------------------------------------------------------------------*/
   
METHOD ExcelWriterXML_Sheet:writeString( row, column, xData, style ) 

   ::writeData( 'String', row, column, xData, style )
   
   RETURN NIL
   
/*----------------------------------------------------------------------*/
   
METHOD ExcelWriterXML_Sheet:writeNumber( row, column, xData, style ) 

   IF !( VALTYPE( xData ) == "N" )
      ::writeData( 'String', row, column, xData, style )
   ELSE
      ::writeData( 'Number', row ,column, ALLTRIM( STR( xData, 18, 6 ) ), style )
   ENDIF
   
   RETURN NIL
   
/*----------------------------------------------------------------------*/
   
METHOD ExcelWriterXML_Sheet:writeDateTime( row, column, xData, style ) 

   IF VALTYPE( xData ) == "D"
      ::writeData( 'DateTime', row, column, DTOC( xData ), style )
   ELSE
      ::writeData( 'String', row, column, xData, style )
   ENDIF
   
   RETURN NIL
   
/*----------------------------------------------------------------------*/
   
METHOD ExcelWriterXML_Sheet:writeData( type, row, column, xData, style, formula ) 
   LOCAL hcol, cell, styleID
   
   IF style != NIL
      IF HB_IsObject( style )
         styleID := style:getID()
      ELSE
         styleID := style
      ENDIF
   ELSE
      styleID := NIL
   ENDIF
   
    cell := hb_hash()
    cell[ 'type'   ] := type
    cell[ 'style'  ] := styleID
    cell[ 'data'   ] := xData
    cell[ 'formula'] := formula
   IF hb_hPos( ::cells, row ) > 0
      hcol := ::cells[ row ]
      hcol[ column ] := cell
      ::cells[ row ] := hcol   
   ELSE            
      hcol := hb_hash()
      hcol[ column ] := cell
      ::cells[ row ] := hcol
   ENDIF

   RETURN NIL
   
/*----------------------------------------------------------------------*/
   
METHOD ExcelWriterXML_Sheet:displayRightToLeft() 

   ::ldisplayRightToLeft := .t.
   
   RETURN NIL

/*----------------------------------------------------------------------*/
   
METHOD ExcelWriterXML_Sheet:getSheetXML( handle ) 
   LOCAL displayRightToLeft, ir, ic, xml, url
   LOCAL column, cell, xData, type, mergecell, comment, style, colIndex, colWidth 
   LOCAL row, rowData, rowHeight, formula
   
   displayRightToLeft := IIF( ::ldisplayRightToLeft, 'ss:RightToLeft="1"', "" )
      
   xml := '<Worksheet ss:Name="' + ::id + '" ' + displayRightToLeft + '>' + HB_OsNewLine()
   xml += '   <Table>' + HB_OsNewLine()
   
   fwrite( handle,xml )
   xml := ""
   
   IF len( ::colWidth ) > 0
      FOR ic := 1 TO LEN( ::colWidth )
         colIndex := hb_hKeyAt( ::colWidth, ic )
         colWidth := hb_hValueAt( ::colWidth, ic )
         colIndex := ALLTRIM( STR( colIndex, 10 ) )
         colWidth := ALLTRIM( STR( colWidth, 10 ) )
         xml += '      <Column ss:Index="' + colIndex + '" ss:AutoFitWidth="0" ss:Width="' + colWidth + '"/>' + HB_OsNewLine()
      NEXT
   ENDIF
   
   fwrite( handle, xml )
   xml := ""
   
   IF len( ::cells ) > 0
      FOR ir := 1 TO LEN( ::cells )
         row     := hb_hKeyAt( ::cells, ir )
         rowData := hb_HValueAt( ::cells, ir )
       
         IF hb_hPos( ::rowHeight, row ) > 0
            rowHeight := 'ss:AutoFitHeight="0" ss:Height="' + ALLTRIM( STR( ::rowHeight[ row ], 14, 2 ) ) + '"'
         ELSE
            rowHeight := ''
         ENDIF
   
         xml += '      <Row ss:Index="' + ALLTRIM( STR( row, 10 ) ) + '" ' + rowHeight + ' >' + HB_OsNewLine()
         FOR ic := 1 TO LEN( rowData )
            column := hb_hKeyAt( rowData, ic )
            cell   := hb_HValueAt( rowData, ic )
            IF !empty( cell[ 'formula' ] ) 
               formula := 'ss:Formula="' + cell['formula'] + '"'
            ELSE
               formula := ''
            ENDIF
            IF !empty( cell[ 'style' ] )
               style := 'ss:StyleID="' + cell[ 'style' ] + '"'
            ELSE 
               style := ''
            ENDIF
            URL := ''
            mergeCell := ''
            IF hb_hPos( ::mergeCells,row ) > 0
               IF hb_hPos( ::mergeCells[row],column ) > 0
                  mergeCell:= 'ss:MergeAcross="' + ALLTRIM( STR( ::mergeCells[row][column]['width'], 10 ) ) + '" ss:MergeDown="' + ALLTRIM( STR( ::mergeCells[row][column]['height'], 10 ) ) + '"'
               ENDIF
            ENDIF
            comment:= ''
            IF hb_hPos( ::comments,row ) > 0
               IF hb_hPos( ::comments[row],column ) > 0
                  comment := '               <Comment ss:Author="' + ::comments[row][column]['author'] + '">' + HB_OsNewLine()
                  comment += '               <ss:Data xmlns="http://www.w3.org/TR/REC-html40">' + HB_OsNewLine()
                  comment += '               <B><Font html:Face="Tahoma" x:CharSet="1" html:Size="8" html:Color="#000000">' + ::comments[row][column]['author'] + ':</Font></B>' + HB_OsNewLine()
                  comment += '               <Font html:Face="Tahoma" x:CharSet="1" html:Size="8" html:Color="#000000">' + ::comments[row][column]['comment'] + '</Font>' + HB_OsNewLine()
                  comment += '               </ss:Data>' + HB_OsNewLine()
                  comment += '               </Comment>' + HB_OsNewLine()
               ENDIF
            ENDIF
            comment := ''
            type  := cell[ 'type' ]
            xData := cell[ 'data' ]
            
            xml += '         <Cell ' + style + ' ss:Index="' + ALLTRIM( STR( column,10 ) ) + '" ' + URL + ' ' + mergeCell + ' ' + formula + '>' + HB_OsNewLine()
            xml += '            <Data ss:Type="' + type + '">'
            xml += oemToHtmlEspecial( xData )
            xml += '</Data>' + HB_OsNewLine()
            xml += comment
            xml += '         </Cell>' + HB_OsNewLine()
   
         NEXT
         xml += '      </Row>' + HB_OsNewLine()
                     
         fwrite( handle, xml )
         xml := ""
      NEXT
   ENDIF
   xml += '   </Table>'+HB_OsNewLine()
   xml += '</Worksheet>'+HB_OsNewLine()
   
   fwrite( handle, xml )
   xml := ""
   
   RETURN xml
   
/*----------------------------------------------------------------------*/

METHOD ExcelWriterXML_Sheet:cellWidth( row, col, width ) 

   HB_SYMBOL_UNUSED( row )
   HB_SYMBOL_UNUSED( col )
   
   IF width == NIL
      width := 48
   ENDIF
   ::columnWidth( col,width )
   
   RETURN NIL

/*----------------------------------------------------------------------*/
   
METHOD ExcelWriterXML_Sheet:columnWidth( col, width ) 

   IF width == NIL
      width := 48
   ENDIF
   ::colWidth[ col ] := width
   
   RETURN NIL

/*----------------------------------------------------------------------*/
   
METHOD ExcelWriterXML_Sheet:cellHeight( row, col, height ) 

   HB_SYMBOL_UNUSED( col )
   
   IF height == NIL
      height := 12.5
   ENDIF
   ::setRowHeight( row, height )
   
   RETURN NIL

/*----------------------------------------------------------------------*/
   
METHOD ExcelWriterXML_Sheet:setRowHeight( row, height ) 

   IF height == NIL
      height := 12.5
   ENDIF
   ::rowHeight[ row ] := height
   
   RETURN NIL

/*----------------------------------------------------------------------*/
   
METHOD ExcelWriterXML_Sheet:cellMerge( row,col, width, height )  
   LOCAL haux := hb_hash()
   
   IF hb_hPos( ::mergeCells, row ) > 0
      haux := ::mergeCells[ row ]
   ENDIF
   haux[ col ] := hb_hash()
   haux[ col ]['width' ] := width
   haux[ col ]['height'] := height
   
   ::mergeCells[ row ] := haux
      
   RETURN NIL
   
/*----------------------------------------------------------------------*/
   
METHOD ExcelWriterXML_Sheet:addComment( row, col,comment,author ) 
   LOCAL haux := hb_hash()
   
   haux[ col ] := hb_hash()
   haux[ col ][ 'comment'] := comment
   haux[ col ][ 'author' ] := author

   ::comments[ row ]:= haux
   
   RETURN NIL

/*----------------------------------------------------------------------*/

#ifndef  __HARBOUR__
    STATIC FUNCTION hb_hPos( hHash , hRow , hCol , hKey , lID )
    RETURN( hHash:hPos( @hRow , @hCol , @hKey , NIL , @lID ) )
    STATIC FUNCTION hb_hKeyAt( hHash , hRow , hCol , hKey , lATRow  , lID )
    RETURN( hHash:hGetKey( @hRow , @hCol , @hKey , @lATRow , NIL , @lID ) )
    STATIC FUNCTION hb_HValueAt( hHash , hRow , hCol , hKey , lID )
    RETURN( hHash:hGetValue( @hRow , @hCol , @hKey , .F. , @lID ) )
    STATIC FUNCTION oemToHtmlEspecial( xData )
    RETURN( StaticCall( xlsxml , oemToHtmlEspecial , @xData ) )
#endif
