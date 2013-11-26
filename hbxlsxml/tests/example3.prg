/*
 * $Id: example3.prg 17099 2011-10-28 18:34:39Z vouchcac $
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
#ifdef __HARBOUR__
FUNCTION main()
#else
#include "ptxlsxml.ch"
USER FUNCTION example3Xls()
   LOCAL nVarNameLen 	:= SetVarNameLen(250)
   LOCAL cTempPath		:= GetTempPath()
#endif	
   LOCAL xml, sheet1, format4
   LOCAL xarquivo		:= 'example3.xml'
#ifndef __HARBOUR__
	xarquivo := CriaTrab(NIL,.F.)+".xml"
	HB_SYMBOL_UNUSED( __cCRLF )
	SetsDefault()
#else
   SET DATE TO BRITISH
   SET CENTURY ON
#endif 
   
xml:= ExcelWriterXML():New(xarquivo)
   
   sheet1 = xml:addSheet('Plan 1')
   
   format4 = xml:addStyle('my style')
   format4:setFontSize(20)
   format4:setFontColor('yellow')
   format4:bgColor('blue')
#ifndef __HARBOUR__
   //:Border Esta funcionando no Protheus e no harbour nao
   format4:border(NIL,'3',NIL,'Double')
#endif   

   sheet1:columnWidth(1,150)
   sheet1:columnWidth(2,150)
   sheet1:columnWidth(3,150)

   sheet1:writeString(1,1,'celula 1_A',format4)
   sheet1:cellMerge(1,1,1,0)
   sheet1:writeString(1,3,'celula 1_C',format4)

   sheet1:writeString(2,1,'celula 2_A',format4)
   sheet1:writeString(2,2,'celula 2_B',format4)
   sheet1:writeString(2,3,'celula 2_C',format4)

   sheet1:writeString(3,1,'celula 3_A',format4)
   sheet1:writeString(3,2,'celula 3_B',format4)
   sheet1:writeString(3,3,'celula 3_C',format4)

   sheet1:writeString(4,1,'celula 4_A',format4)
   sheet1:writeString(4,2,'celula 4_B',format4)
   sheet1:writeString(4,3,'celula 4_C',format4)

   sheet1:writeString(5,1,'celula 5_A',format4)
   sheet1:writeString(5,2,'celula 5_B',format4)
   sheet1:writeString(5,3,'celula 5_C',format4)

   sheet1:writeString(6,1,'celula 6_A_C',format4)
   sheet1:cellMerge(6,1,2,0)
   
   sheet1:writeString(7,1,'celula 7_A_C',format4)
   sheet1:cellMerge(7,1,2,0)

   sheet1:writeString(8,1,'celula 8_A',format4)
   sheet1:writeString(8,2,'celula 8_B',format4)
   sheet1:writeString(8,3,'celula 8_C',format4)

   sheet1:writeString(9,2,'celula 9_B',format4)

   xml:setOverwriteFile(.T.) 
   xml:writeData(xarquivo)

#ifndef __HARBOUR__

 	IF __CopyFile(xarquivo,cTempPath+xarquivo)
	 	fErase( xarquivo )
		oExcelApp	:= MsExcel():New()
		oExcelApp:WorkBooks:Open(cTempPath+xarquivo)
		oExcelApp:SetVisible(.T.)   
		oExcelApp	:= oExcelApp:Destroy()
	EndIF	

	SetVarNameLen(nVarNameLen)

#endif   

   RETURN NIL 

/*----------------------------------------------------------------------*/                      