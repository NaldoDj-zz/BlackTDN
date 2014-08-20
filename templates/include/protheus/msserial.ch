/*
	Header : msserial.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _MSSERIAL_CH_
#define _MSSERIAL_CH_

//--< N£mero das portas seriais >------------------------------------------
#define pnCustom  0
#define pnCOM1    1
#define pnCOM2    2
#define pnCOM3    3
#define pnCOM4    4
#define pnCOM5    5
#define pnCOM6    6
#define pnCOM7    7
#define pnCOM8    8
#define pnCOM9    9
#define pnCOM10   10
#define pnCOM11   11
#define pnCOM12   12
#define pnCOM13   13
#define pnCOM14   14
#define pnCOM15   15
#define pnCOM16   16

//--< Velocidades de transmissao - Baud Rates >----------------------------
#define brCustom   0
#define br110      1
#define br300      2
#define br600      3
#define br1200     4
#define br2400     5
#define br4800     6
#define br9600     7
#define br14400    8
#define br19200    9
#define br38400   10
#define br56000   11
#define br57600   12
#define br115200  13
#define br128000  14
#define br256000  15

//--< Data bits >----------------------------------------------------------
#define db5BITS    0
#define db6BITS    1
#define db7BITS    2
#define db8BITS    3

//--< Bit de parada - Stop bits >------------------------------------------
#define sb1BITS      0
#define sb1HALFBITS  1
#define sb2BITS      2

//--< Bit de paridade >----------------------------------------------------
#define ptNONE   0
#define ptODD    1
#define ptEVEN   2
#define ptMARK   3
#define ptSPACE  4

//--< Controle de fluxo por hardware >-------------------------------------
#define hfNONE       0
#define hfNONERTSON  1
#define hfRTSCTS     2

//--< Controle de fluxo por software >-------------------------------------
#define sfNONE    0  
#define sfXONXOFF 1

//--< Recebimento de pacotes incompletos >---------------------------------
#define pmDiscard 0
#define pmPass    1

//--< Determina a versão que será utilizado >------------------------------
#define vDLL16   16
#define vDLL32   32

#endif

