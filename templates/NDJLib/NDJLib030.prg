#include "ndj.ch"
/*
	Fun‡„o		: HMSToTime
	Autor		: Marinaldo de Jesus
	Data		: 20/04/2012
	Descri‡„o	: Transformar Valores de Horas, Minutos e Segundos em String no Padrao "HH:MM:SS"
	Sintaxe		: HmsToTime( [ < nHours > ] , [ < nMinuts > ] , [ < nSeconds > ] )
	Parametros	: nHours 	-> Valor das Horas
				  nMinuts	-> Valor dos Minutos
				  nSeconds	-> Valor dos Segundos
*/				  
Static Function HMSToTime( nHours , nMinuts , nSeconds )

	Local cTime
	
	DEFAULT nHours		:= 0
	DEFAULT nMinuts		:= 0
	DEFAULT nSeconds	:= 0
	
	cTime := AllTrim( Str( nHours ) )
	cTime := StrZero( Val( cTime ) , Max( Len( cTime ) , 2 ) )
	cTime += ":"
	cTime += StrZero( Val( AllTrim( Str( nMinuts  ) ) ) , 2 )
	cTime += ":"
	cTime += StrZero( Val( AllTrim( Str( nSeconds ) ) ) , 2 )

Return( cTime )

/*/
	Fun‡„o		: SecsToHMS
	Autor		: Marinaldo de Jesus
	Data		: 20/04/2012
	Descri‡„o	: Converte Segundos para Horas, Minutos e Segundos
	Sintaxe		: SecsToHMS( nSecsToHMS , @nHours , @nMinuts , @nSeconds )
	Parametros	: nSecsToHMS -> Numero de Segundos que sera convertidos
				  nHours     -> Valor das Horas
                  nMinuts    -> Valor dos Minutos
				  nSeconds	 -> Valor dos Segundos
				  cRet     	 -> Tipo do Retorno Desejado: "H" ou "h" -> nHours
                                                          "M" ou "m" -> nMinuts
                                                          "S" ou "s" -> nSedonds
*/                                                          
Static Function SecsToHMS( nSecsToHMS , nHours , nMinuts , nSeconds , cRet )

	Local nRet	:= 0
	
	DEFAULT nSecsToHMS	:= 0
	DEFAULT cRet		:= "H"
	
	nHours		:= SecsToHrs( nSecsToHMS )
	nMinuts		:= SecsToMin( nSecsToHMS )
	nSeconds	:= ( HrsToSecs( nHours ) + MinToSecs( nMinuts ) )
	nSeconds	:= ( nSecsToHMS - nSeconds )
	nSeconds	:= Int( nSeconds )
	nSeconds	:= Mod( nSeconds , 60 )
	
	IF ( cRet $ "Hh" )
		nRet := nHours
	ElseIF ( cRet $ "Mm" )
		nRet := nMinuts
	ElseIF ( cRet $ "Ss" )
		nRet := nSeconds
	EndIF

Return( nRet )

/*
	Fun‡„o		: SecsToTime
	Autor		: Marinaldo de Jesus
	Data		: 20/04/2012
	Descri‡„o	: Converte Segundos para Horas, Minutos e Segundos retornando a string no formato "HH:MM:SS"
	Sintaxe		: SecsToTime( nSecs )
	Parametros  : nSeconds	-> Valor dos Segundos
	Retorno     : "HH:MM:SS"
*/
Static Function SecsToTime( nSecs )

	Local nHours
	Local nMinuts
	Local nSeconds
	
	SecsToHMS( nSecs , @nHours , @nMinuts , @nSeconds )

Return( HMSToTime( nHours , nMinuts , nSeconds ) )

/*
	Fun‡„o		: TimeToSecs
	Autor		: Marinaldo de Jesus
	Data		: 20/04/2012
	Descri‡„o	: Transformar a Sting Retornada pela Time() em Segundos
	Sintaxe		: TimeToSenconds( < cTime > )
	Parametros	: cTime	-> String Contendo as Horas, Minutos e Segundos Retorna da Pela Funcao Time "HH:MM:SS"
	Retorno		: Segundos
*/
Static Function TimeToSecs( cTime )

	Local nHours
	Local nMinuts
	Local nSeconds
	
	DEFAULT cTime	:= "00:00:00"
	
	ExtractTime( cTime , @nHours , @nMinuts , @nSeconds )
	
	nMinuts		+= __Hrs2Min( nHours )
	nSeconds	+= ( nMinuts * 60 )

Return( nSeconds )

/*/
	Fun‡„o		: TimeToSeconds
	Autor		: Marinaldo de Jesus
	Data		: 20/04/2012
	Descri‡„o	: Transformar a Sting Retornada pela Time() em Segundos
	Sintaxe		: TimeToSenconds( < cTime > )
	Parametros	: cTime	-> String Contendo as Horas, Minutos e Segundos Retorna da Pela Funcao Time "HH:MM:SS"
	Retorno		: Segundos
	Observa‡„o	: Utiliza a Funcao TimeToSecs() para a conversao
*/
Static Function TimeToSeconds( cTime )
Return( TimeToSecs( cTime ) )

/*/
	Fun‡„o		: SecsToHrs
	Autor		: Marinaldo de Jesus
	Data		: 20/04/2012
	Descri‡„o	: Converte Segundos para Horas
	Sintaxe		: SecsToHrs( nSeconds )
	Parametros	: nSeconds -> Numero de Segundos que sera convertidos
	Retorno		: nHours
*/
Static Function SecsToHrs( nSeconds )

	Local nHours
	
	nHours	:= ( nSeconds / 3600 )
	nHours	:= Int( nHours )

Return( nHours )

/*
	Fun‡„o		: HrsToSecs
	Autor		: Marinaldo de Jesus
	Data		: 20/04/2012
	Descri‡„o	: Converte Horas para Segundos
	Sintaxe		: HrsToSecs( nHours )
	Parametros	: nHours	-> Numero de Horas que sera convertidas
	Retorno		: nSeconds
*/
Static Function HrsToSecs( nHours )
Return( ( nHours * 3600 ) )

/*
	Fun‡„o		: SecsToMin
	Autor		: Marinaldo de Jesus
	Data		: 20/04/2012
	Descri‡„o	: Converte Segundos para Minutos
	Sintaxe		: SecsToMin( nSeconds )
	Parametros	: nSeconds -> Numero de Segundos que serao convertidos
	Retorno		: nMinuts
*/
Static Function SecsToMin( nSeconds )

	Local nMinuts
	
	nMinuts		:= ( nSeconds / 60 )
	nMinuts		:= Int( nMinuts )
	nMinuts		:= Mod( nMinuts , 60 )

Return( nMinuts )

/*
	Fun‡„o		: MinToSecs
	Autor		: Marinaldo de Jesus
	Data		: 20/04/2012
	Descri‡„o	: Converte Minutos para Segundos
	Sintaxe		: MinToSecs( nMinuts )
	Parametros	: nMinuts	-> Numero de Minutos que serao convertidos
	Retorno		: nSeconds
*/
Static Function MinToSecs( nMinuts )
Return( ( nMinuts * 60 ) )

/*
	Fun‡„o		: IncTime
	Autor		: Marinaldo de Jesus
	Data		: 20/04/2012
	Descri‡„o	: Incrementar Valores de Horas, Minutos e Segundos na String cTime
	Retorno		: "HH:MM:SS"
*/
Static Function IncTime( cTime , nIncHours , nIncMinuts , nIncSeconds )

	Local nSeconds
	Local nMinuts
	Local nHours
	
	DEFAULT nIncHours	:= 0
	DEFAULT nIncMinuts	:= 0
	DEFAULT nIncSeconds	:= 0
	
	ExtractTime( cTime , @nHours , @nMinuts , @nSeconds )
	
	nHours		+= nIncHours
	nMinuts		+= nIncMinuts
	nSeconds	+= nIncSeconds
	nSeconds	:= ( HrsToSecs( nHours ) + MinToSecs( nMinuts ) + nSeconds )

Return( SecsToTime( nSeconds ) )

/*
	Fun‡„o		: DecTime
	Autor		: Marinaldo de Jesus
	Data		: 20/04/2012
	Descri‡„o	: Decrementar Valores de Horas, Minutos e Segundos na String cTime
	Retorno		: "HH:MM:SS"
*/
Static Function DecTime( cTime , nDecHours , nDecMinuts , nDecSeconds )

	Local nSeconds
	Local nMinuts
	Local nHours
	
	DEFAULT nDecHours	:= 0
	DEFAULT nDecMinuts	:= 0
	DEFAULT nDecSeconds	:= 0
	
	ExtractTime( cTime , @nHours , @nMinuts , @nSeconds )
	
	nHours		-= nDecHours
	nMinuts		-= nDecMinuts
	nSeconds	-= nDecSeconds
	nSeconds	:= ( HrsToSecs( nHours ) + MinToSecs( nMinuts ) + nSeconds )

Return( SecsToTime( nSeconds ) )

/*
	Fun‡„o		: Time2NextDay
	Autor		: Marinaldo de Jesus
	Data		: 20/04/2012
	Descri‡„o	: Tratar Time e Date no padrao "00:00:00" para Time >= "24:00:00"
	Retorno		: aTimeTo24Hr
*/
Static Function Time2NextDay( cTime , dDate )

	While ( Val( cTime ) >= 24 )
		cTime := DecTime( cTime , 24 )
		++dDate
	End While

Return( { cTime , dDate } )

/*
	Fun‡„o		: ExtractTime
	Autor		: Marinaldo de Jesus
	Data		: 20/04/2012
	Descri‡„o	: Extrair Valores de Horas, Minutos e Segundos da String cTime
	Sintaxe		: ExtractTime( cTime , @nHours , @nMinuts , @nSeconds , cRet )
	Parametros  : cTime	   -> String de Horas no padrao "00:00:00"
				  nHours   -> Valor das Horas
				  nMinuts  -> Valor dos Minutos
				  nSeconds -> Valor dos Segundos
				  cRet     -> Tipo do Retorno Formal Desejado:  "H" ou "h" -> nHours
																"M" ou "m" -> nMinuts
																"S" ou "s" -> nSedonds
	Retorno		: nRet
*/
Static Function ExtractTime( cTime , nHours , nMinuts , nSeconds , cRet )

	Local nRet		:= 0
	
	Local nAt
	
	DEFAULT cTime	:= "00:00:00"
	DEFAULT cRet	:= "H"
	
	nAt			:= ( At( ":" , cTime ) - 1 )
	nHours		:= Val( SubStr( cTime , 1 , nAt ) )
	nMinuts		:= Val( SubStr( cTime , -5 , 2 ) )
	nSeconds	:= Val( SubStr( cTime , -2 ) )
	
	IF ( cRet $ "Hh" )
		nRet := nHours
	ElseIF ( cRet $ "Mm" )
		nRet := nMinuts
	ElseIF ( cRet $ "Ss" )
		nRet := nSeconds
	EndIF
	
Return( nRet )

/*
	Fun‡„o		: MediumTime
	Autor		: Marinaldo de Jesus
	Data		: 20/04/2012
	Descri‡„o	: Retornar o Tempo Medio
	Retorno		: cMediumTime
*/
Static Function MediumTime( cTime , nDividendo , lMiliSecs )

	Local cMediumTime	:= "00:00:00"
	
	Local nSeconds
	Local nMediumTime
	Local nMiliSecs
	
	IF ( nDividendo > 0 )
	
		nSeconds	:= TimeToSecs( cTime )
		nSeconds	:= ( nSeconds / nDividendo )
		nMediumTime	:= Int( nSeconds )
	
		nMiliSecs	:= ( nSeconds - nMediumTime )
		nMiliSecs	*= 100
		nMiliSecs	:= Int( nMiliSecs )
	
		cMediumTime	:= SecsToTime( nMediumTime )
	
		DEFAULT lMiliSecs	:= .F.
		IF (;
				( lMiliSecs );
				.and.;
				( nMiliSecs > 0 );
			)
			cMediumTime += ( ":" + StrZero( nMiliSecs , 02 ) )
		EndIF
	
	EndIF

Return( cMediumTime )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
    	lRecursa	:= __Dummy( .F. )
    	INCTIME()
    	MEDIUMTIME()
    	TIME2NEXTDAY()
    	TIMETOSECONDS()
    	SYMBOL_UNUSED( __cCRLF )
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )
