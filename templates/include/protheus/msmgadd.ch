/*
	Header : msmgadd.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _MSMGADD_CH_
#define _MSMGADD_CH_

#xcommand ADD FIELD <aField>		;
	TITULO		<cTitle>		;
	CAMPO		<cField>		;
	TIPO		<cType>			;
	TAMANHO		<nSize>			;
	DECIMAL		<nDecimal>		;
	[ PICTURE	<cPicture> ]	;
	[ VALID		<uValid> ]		;
	[ <lObrigat: OBRIGAT> ]		;
	NIVEL		<nLevel>		;
	[ INITPAD	<cInitPad> ]	;
	[ F3		<cF3> ]			;
	[ WHEN		<uWhen> ]		;
	[ <lVisual:	VISUAL> ]		;
	[ <lChave:	CHAVE> ]		;
	[ BOX		<cBox> ]		;
	[ FOLDER	<nFolder> ]		;
    [ <lNAltera: NAO ALTERA>]	;
    [ PICTVAR   <cPictVar>]		;
	=>							;
	<aField> := If(ValType(<aField>) <> "A",{},<aField>);;
	Aadd(<aField>,{<cTitle>,<cField>,<cType>,<nSize>,<nDecimal>,<cPicture>,<{uValid}>,;
		<.lObrigat.>,<nLevel>,<cInitPad>,<cF3>,<{uWhen}>,<.lVisual.>,<.lChave.>,<cBox>,;
        <nFolder>,<.lNAltera.>,<cPictVar>})
		
#endif		