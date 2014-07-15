//----------------------------------------------------------------------------
    /*
        include     : uTCREPORTDef.ch
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 27/09/2012 
    */
//----------------------------------------------------------------------------
#IFNDEF _TCUSTOMREPORT_DEF_CH

	#DEFINE _TCUSTOMREPORT_DEF_CH

	#DEFINE TCR_AL_LEFT    	 0 	//Alinha Texto a Esquerda(padrão)
	#DEFINE TCR_AL_RIGHT   	 1 	//Alinha Texto a Direita
	#DEFINE TCR_AL_CENTER  	 2 	//Alinha Texto no Centro
	#DEFINE TCR_MARGIN     	 0 	//Margem da area de sangria da pagina.
	#DEFINE TCR_LINE_HEIGHT	40	//Altura da Linha
	#DEFINE TCR_MAX_LINEREL	60	//Numero de Linhas do Relatorio (R3)

	#DEFINE TCR_IMP_DISCO 1
	#DEFINE TCR_IMP_SPOOL 2
	#DEFINE TCR_IMP_EMAIL 3
	#DEFINE TCR_IMP_EXCEL 4
	#DEFINE TCR_IMP_HTML  5
	
	#DEFINE RPT_R3			   1
	#DEFINE RPT_TREPORT		   2

	#ifndef SYMBOL_UNUSED
		#define SYMBOL_UNUSED( symbol )  ( symbol := ( symbol ) )
	#endif

	#ifndef CRLF
		#define CRLF CHR(13)+CHR(10)	
	#endif

#ENDIF //_TCUSTOMREPORT_DEF_CH