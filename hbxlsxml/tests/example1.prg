/*
 * $Id: example.prg 17099 2011-10-28 18:34:39Z vouchcac $
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

#DEFINE NLINES_SAMPLE	( 100 * 5 )

#ifdef __HARBOUR__
FUNCTION main()
#else
#include "ptxlsxml.ch"
#xcommand WITH OBJECT oXml:addStyle(<v>)				=> oXml:addStyle(<v>) ; ++__nAddStyle
#xcommand :aVertical(<v>)		        				=> oXml:styles\[__nAddStyle\]:aVertical(<v>)
#xcommand :SetFontSize(<v>)   							=> oXml:styles\[__nAddStyle\]:SetFontSize(<v>)
#xcommand :alignWraptext()								=> oXml:styles\[__nAddStyle\]:alignWraptext()
#xcommand :SetFontSize(<v>)							=> oXml:styles\[__nAddStyle\]:SetfontSize(<v>)
#xcommand :setFontBold()								=> oXml:styles\[__nAddStyle\]:setFontBold()
#xcommand :alignHorizontal(<v>)     					=> oXml:styles\[__nAddStyle\]:alignHorizontal(<v>)
#xcommand :bgColor(<v>)								=> oXml:styles\[__nAddStyle\]:bgColor(<v>)
#xcommand :NFormat( <fs> )								=> oXml:styles\[__nAddStyle\]:NFormat(<fs>)
#xcommand WITH OBJECT oSheet							=> 
#xcommand :columnWidth(<n1>,<n2>)						=> oSheet:columnWidth(<n1>,<n2>)
#xcommand :writeString(<v1>,<v2>,<v3>,<v4>)  			=> oSheet:writeString(<v1>,<v2>,<v3>,<v4>)
#xcommand :writeNumber(<v1>,<v2>,<v3>,<v4>)			=> oSheet:writeNumber(<v1>,<v2>,<v3>,<v4>)
#xcommand :writeFormula(<v1>,<v2>,<v3>,<v4>,<v5>)	=> oSheet:writeFormula(<v1>,<v2>,<v3>,<v4>,<v5>)	
#xcommand :cellMerge(<v1>,<v2>,<v3>,<v4>)				=> oSheet:cellMerge(<v1>,<v2>,<v3>,<v4>)
#xcommand END WITH	 			 						=> 
USER FUNCTION example1Xls()
   LOCAL nVarNameLen 	:= SetVarNameLen(250)
   LOCAL __nAddStyle	:= 1
   LOCAL lSetCentury	:= __SetCentury("ON")
   LOCAL cTempPath		:= GetTempPath()
#endif

   LOCAL oXml, oSheet, xarquivo := "example1.xml"
   LOCAL i, i100, i100_09, xqtddoc, xttotnot, xtbascal, xtvlricm, xtbasipi, xtvlripi, aDoc, nLinha
   LOCAL xEmpresa   
   LOCAL xDataImp   
   LOCAL xHoraImp
   LOCAL xTitulo    
   LOCAL xPeriodo   
   LOCAL Lines
   LOCAL dDate		:= Date()
   LOCAL dDate_i
   LOCAL cCodCli

#ifndef __HARBOUR__
	xarquivo := CriaTrab(NIL,.F.)+".xml"
	HB_SYMBOL_UNUSED( __cCRLF )
	SetsDefault()
#else
   SET DATE TO BRITISH
   SET CENTURY ON
#endif   
 
   oXml:= ExcelWriterXML():New(xarquivo)
   oXml:setOverwriteFile(.t.)
      
   WITH OBJECT oXml:addStyle('textLeft')
      :alignHorizontal('Left')        
      :alignVertical('Center')
      :SetFontSize(10)
   END WITH
   
   WITH OBJECT oXml:addStyle('textLeftWrap')             
      :alignHorizontal('Left')        
      :alignVertical('Center')              
      :alignWraptext()
      :SetFontSize(10)
   END WITH
   WITH OBJECT oXml:addStyle('textLeftBold')             
      :alignHorizontal('Left')        
      :alignVertical('Center')
      :SetFontSize(10)
      :setFontBold()
   END WITH
   
   WITH OBJECT oXml:addStyle('textLeftBoldCor')             
      :alignHorizontal('Left')        
      :alignVertical('Center')
      :SetFontSize(10)
      :setFontBold()                  
      :bgColor('lightblue')                              
      :alignWraptext()
   END WITH
   
   WITH OBJECT oXml:addStyle('textRight')             
      :alignHorizontal('Right')        
      :alignVertical('Center')
      :SetFontSize(10)
   END WITH
   
   WITH OBJECT oXml:addStyle('textRightBold')             
      :alignHorizontal('Right')        
      :alignVertical('Center')
      :SetFontSize(10)
      :setFontBold()
   END WITH
   
   WITH OBJECT oXml:addStyle('textRightBoldCor')             
      :alignHorizontal('Right')        
      :alignVertical('Center')
      :SetFontSize(10)
      :setFontBold()
      :bgColor('lightblue')
      :alignWraptext()
   END WITH
   
   WITH OBJECT oXml:addStyle('numberRight')             
      :alignHorizontal('Right')
      :alignVertical('Center')
      :setNumberFormat('#,##0.00')         
      :SetFontSize(10)
   END WITH
   
   WITH OBJECT oXml:addStyle('numberRightBold')             
      :alignHorizontal('Right')
      :alignVertical('Center')
      :setNumberFormat('#,##0.00')         
      :SetFontSize(10)
      :setFontBold()
   END WITH
   
   WITH OBJECT oXml:addStyle('numberRightBoldCor')             
      :alignHorizontal('Right')
      :alignVertical('Center')
      :setNumberFormat('#,##0.00')         
      :SetFontSize(10)
      :setFontBold()
      :bgColor('lightblue')
   END WITH
   
   WITH OBJECT oXml:addStyle('numberRightZero')             
      :alignHorizontal('Right')
      :alignVertical('Center')
      :setNumberFormat('#,##0.00;[Red]-#,##0.00;;@') //'#,###.00')         
      :SetFontSize(10)    
      :setFontBold()
   END WITH
   
   WITH OBJECT oXml:addStyle('CabecLeft')             
      :alignHorizontal('Left')        
      :alignVertical('Center')
      :SetFontSize(12)
      :setFontBold()
   END WITH

   WITH OBJECT oXml:addStyle('CabecCenter')             
      :alignHorizontal('Center')
      :alignVertical('Center')
      :SetFontSize(12)
      :setFontBold()
   END WITH
   
   WITH OBJECT oXml:addStyle('CabecRight')             
      :alignHorizontal('Right')        
      :alignVertical('Center')
      :SetFontSize(12)
      :setFontBold()
   END WITH
   
   oSheet := oXml:addSheet('Plan1')     
   
   WITH OBJECT oSheet
      :columnWidth( 1,  70 ) // N.Fiscal
      :columnWidth( 2,  20 ) // TM
      :columnWidth( 3,  70 ) // Data Movto
      :columnWidth( 4,  70 ) // Data Emis.
      :columnWidth( 5,  50 ) // CFOP
      :columnWidth( 6,  50 ) // C›d. Cliente/Fornecedor
      :columnWidth( 7, 300 ) // Nome Cliente/Fornecedor
      :columnWidth( 8,  20 ) // UF       
      :columnWidth( 9,  80 ) // Vlr.Tot. 
      :columnWidth(10,  80 ) // Base Calc.
      :columnWidth(11,  80 ) // Vlr ICMS
      :columnWidth(12,  80 ) // Base IPI
      :columnWidth(13,  80 ) // Valor IPI
   
      xEmpresa:= "EMPRESA DEMONSTRACAO LTDA"
      xDataImp:= Dtoc(dDate)
      xTitulo := "RELATORIO PARA DEMONSTRAR XML EXCEL"
      xPeriodo:= Dtoc((dDate-NLINES_SAMPLE)-50) + " a " + Dtoc(dDate-50)
      xHoraImp:= Time()	
      
      nLinha:= 0
      :writeString(++nLinha,1,xEmpresa ,'CabecLeft')  
      :cellMerge(    nLinha,1, 5, 0)

      :writeString(  nLinha,7,xTitulo  ,'CabecCenter')  
      :cellMerge(    nLinha,7, 3, 0)

      :writeString(  nLinha,12,"Data:"+xDataImp ,'CabecRight')  
      :cellMerge(    nLinha,12, 1, 0)

      :writeString(++nLinha,1,"Periodo",'CabecLeft')
      :cellMerge(    nLinha,1, 5, 0)

      :writeString(  nLinha,7,xPeriodo ,'CabecCenter')  
      :cellMerge(    nLinha,7, 3, 0)

      :writeString(  nLinha,12,"Hora:"+xHoraImp ,'CabecRight')
      :cellMerge(    nLinha,12, 1, 0)

      :writeString(++nLinha, 1,"N.Fiscal"          ,'textLeftBoldCor' )
      :writeString(  nLinha, 2,"TM"                ,'textLeftBoldCor' )
      :writeString(  nLinha, 3,"Data Movto"        ,'textLeftBoldCor' )
      :writeString(  nLinha, 4,"Data Emis."        ,'textLeftBoldCor' )
      :writeString(  nLinha, 5,"CFOP"              ,'textLeftBoldCor' )
      :writeString(  nLinha, 6,"C›digo"            ,'textLeftBoldCor' )
      :writeString(  nLinha, 7,"Cliente/Fornecedor",'textLeftBoldCor' )
      :writeString(  nLinha, 8,"UF"                ,'textLeftBoldCor' )
      :writeString(  nLinha, 9,"Vlr.Tot."          ,'textRightBoldCor')
      :writeString(  nLinha,10,"Base Calc."        ,'textRightBoldCor')
      :writeString(  nLinha,11,"Vlr ICMS"          ,'textRightBoldCor')
      :writeString(  nLinha,12,"Base IPI"          ,'textRightBoldCor')
      :writeString(  nLinha,13,"Valor IPI"         ,'textRightBoldCor')
   END WITH

   xqtddoc:= xttotnot:= xtbascal:= xtvlricm:= xtbasipi:= xtvlripi:= 0
   
   aDoc := Array(13)
   FOR i:= 1 TO NLINES_SAMPLE
      i100 		:= ( i * 100 )
      i100_09	:= ( i100 * 0.90 )
      dDate_i	:= ( dDate - i )
      cCodCli	:= STRZERO(i,5)
      aDoc[01]	:= STRZERO(i,8)
      aDoc[02]	:= "VE"
      aDoc[03]	:= dDate_i-49
      aDoc[04]	:= dDate_i-50
      aDoc[05]	:= "5.102"
      aDoc[06]	:= cCodCli
      aDoc[07]	:= "NOME DO CLIENTE TESTE "+cCodCli
      aDoc[08]	:= "PR"
      aDoc[09]	:= i100
      aDoc[10]	:= i100_09
      aDoc[11]	:= i100*i100_09*0.12
      aDoc[12]	:= i100
      aDoc[13]	:= i100*0.10
      WITH OBJECT oSheet 
         :writeString(++nLinha, 1,aDoc[01],'textLeft')
         :writeString(  nLinha, 2,aDoc[02],'textLeft')
         :writeString(  nLinha, 3,DTOC(aDoc[03]),'textLeft')
         :writeString(  nLinha, 4,DTOC(aDoc[04]),'textLeft')
         :writeString(  nLinha, 5,aDoc[05],'textLeft')
         :writeString(  nLinha, 6,aDoc[06],'textLeft')
         :writeString(  nLinha, 7,aDoc[07],'textLeft')
         :writeString(  nLinha, 8,aDoc[08],'textLeft')
         :writeNumber(  nLinha, 9,aDoc[09],'numberRight')
         :writeNumber(  nLinha,10,aDoc[10],'numberRight')
         :writeNumber(  nLinha,11,aDoc[11],'numberRight')
         :writeNumber(  nLinha,12,aDoc[12],'numberRight')
         :writeNumber(  nLinha,13,aDoc[13],'numberRight')
      END WITH
      xqtddoc++
      xttotnot+= aDoc[09]
      xtbascal+= aDoc[10]
      xtvlricm+= aDoc[11]
      xtbasipi+= aDoc[12]
      xtvlripi+= aDoc[13]
   NEXT i

   Lines := AllTrim(Str(NLINES_SAMPLE))

   WITH OBJECT oSheet 
      :writeString(++nLinha, 1,"",'textLeft')
      :writeString(  nLinha, 2,"",'textLeft')
      :writeString(  nLinha, 3,"",'textLeft')
      :writeString(  nLinha, 4,"",'textLeft')
      :writeString(  nLinha, 5,"",'textLeft')
      :writeString(  nLinha, 6,"",'textLeft')
      :writeString(  nLinha, 7,"TOTAL ==> "+STR(xqtddoc,5)+" documentos",'textLeftBold')
      :writeString(  nLinha, 8,"",'textLeft')             
      :writeFormula('Number',nLinha,9,'=SUM(R[-'+Lines+']C:R[-1]C)','numberRightBold')
      :writeFormula('Number',nLinha,10,'=SUM(R[-'+Lines+']C:R[-1]C)','numberRightBold')
	  :writeFormula('Number',nLinha,11,'=SUM(R[-'+Lines+']C:R[-1]C)','numberRightBold')
      :writeFormula('Number',nLinha,12,'=SUM(R[-'+Lines+']C:R[-1]C)','numberRightBold')
      :writeFormula('Number',nLinha,13,'=SUM(R[-'+Lines+']C:R[-1]C)','numberRightBold')
      :writeString(++nLinha, 7,"CHECKSUM ==>" ,'textLeftBold')
      :writeString(  nLinha, 8,"",'textLeft')             
      :writeNumber(  nLinha, 9,xttotnot,'numberRightBold')
      :writeNumber(  nLinha,10,xtbascal,'numberRightBold')
      :writeNumber(  nLinha,11,xtvlricm,'numberRightBold')
      :writeNumber(  nLinha,12,xtbasipi,'numberRightBold')
      :writeNumber(  nLinha,13,xtvlripi,'numberRightBold')
   END WITH

   oXml:setOverwriteFile(.T.) 
   oXml:writeData(xarquivo)

#ifndef __HARBOUR__

 	IF __CopyFile(xarquivo,cTempPath+xarquivo)
 		fErase( xarquivo )
		oExcelApp	:= MsExcel():New()
		oExcelApp:WorkBooks:Open(cTempPath+xarquivo)
		oExcelApp:SetVisible(.T.)
		oExcelApp	:= oExcelApp:Destroy()
	EndIF	

	IF !( lSetCentury )
		__SetCentury("OFF")
	EndIF

	SetVarNameLen(nVarNameLen)

#endif   

   RETURN NIL

/*----------------------------------------------------------------------*/