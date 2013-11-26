/*
	Versão Otimizada baseada no original obtido em: 
	harbour & delphi speed comparison running string generator
	http://harbourlanguage.blogspot.com/2011/11/harbour-delphi-speed-comparison-running.html
	Marinaldo de Jesus - 2012-01-10 : 22:59
*/
FUNCTION main()

   ? "Testing KeyGen() FUNCTION ..."
   TestKeyGenSpeed( 2 )
   ?

   ? "Testing KeyGenX() FUNCTION (about 5 minutes) ..."
   TestKeyGenXSpeed( 2 )
   ?
   QUIT

RETURN( NIL )
 
FUNCTION TestKeyGenSpeed(nKeyGenLength)

	LOCAL xGen		:= ""
 	LOCAL Counter	:= 0
	LOCAL tBegin 	:= Seconds()
	LOCAL tEnd 		:= 0
	LOCAL lSw00 	:= .T.

	WHILE lSw00
		xGen	:= KeyGen(nKeyGenLength, xGen)
		lSw00	:= Len(xGen) > 0
		++Counter
	END WHILE

	tEnd := Seconds()
	? ("- Needed time to all <" + Str(nKeyGenLength) + "> Byte combinations are:  " + Str(tEnd - tBegin))
	? ("- Total operations tested was:  " + Str((Counter - 1)))

Return(NIL)

FUNCTION TestKeyGenXSpeed(nKeyGenLength)

	LOCAL xGen		:= ""
	LOCAL Counter	:= 0
	LOCAL tBegin	:= Seconds()
	LOCAL tEnd		:= 0
	LOCAL lSw00		:= .T.
	LOCAL cASCII
	LOCAL aTable	:= Array(0)
	LOCAL nTableLen
	
	AllAscii(@cASCII,@aTable,@nTableLen)

	WHILE lSw00
		xGen	:= KeyGenX(nKeyGenLength,xGen,@cASCII,@aTable,@nTableLen)
		lSw00	:= Len(xGen) > 0
		++Counter
	END WHILE

	tEnd := Seconds()
	? ("- Needed time to all <" + Str(nKeyGenLength) + "> Byte combinations are:  " + Str(tEnd - tBegin))
	? ("- Total operations tested was:  " + Str((Counter - 1)))

RETURN(NIL)

//()> {String}
FUNCTION AllAscii(__cAscii,__aTable,__nTableLen)

	// AllAscii() - Devuelve todos los caracteres de la tabla ASCII.
	// Desarrollo de la Función:  14-Jun-2011 > 14-Jun-2011
	// (c) Alejandro Padrino, 2.009 - 2.011
	//
	// Funciones Relacionadas:
	// - (Ninguna)
	//
	// __cOut - Cadena de Caracteres devuelta.
	// __nB00 - Bucle #00.
	//

	LOCAL __cOut := ""
	LOCAL __nB00 := -1 

	LOCAL __cTmp00

	WHILE ++__nB00 < 256
 		__cOut += Chr(__nB00)
	END WHILE

	__nB00		:= 0
	__cAscii	:= ""
	__nTableLen := Len( __cOut )

	WHILE ++__nB00 <= __nTableLen
		__cTmp00 := SubStr( __cOut, __nB00, 1 )
		IF ( At( __cTmp00, __cAscii ) < 1 )
			aAdd( __aTable, Asc( __cTmp00 ) )
			__cAscii += __cTmp00
		ENDIF
	END WHILE

	__nTableLen := Len( __cAscii )

RETURN(__cOut)
  
FUNCTION KeyGen( __nKeyLen, __cIn )

	// KeyGen () - String Builder.
	// Development of FUNCTION: 15-Jan-2009> 12-Aug-2011
	// (C) Alexander Godfather, 2009-2011
	//
	// FUNCTIONs:
	// - KeyGenX ()
	// - ReverseStr ()
	//
	// __nKeyLen - Maximum length of string.
	// __cIn - Initial value of the string.
	//
	// __cOut - The value returned by this FUNCTION.
	// __aOut - An array of characters.
	// __nBeginLen - Initial length string.
	// __lSw00 - Logical switch.
	// __nB00 - Temporary numeric variable # 00.
	//
	// This FUNCTION returns the following combination of characters that introduced  <__cIn>
	// By using the <256> characters in the ASCII table, with a length of
	// <__nKeyLen> Characters. Upon reaching the final combination of characters
	// Possible in the specified length, this FUNCTION returns a string
	// Empty character.
	//
	// IMPORTANT NOTICE: This feature can reduce the speed
	// Of your program as <__nKeyLen> value. if
	// Needs to work with programmable character table
	// Use <KeyGenX()> FUNCTION. Approximate speed
	// For all possible combinations using the <256>
	// ASCII characters, using <2> characters
	// Length in a PC with a CPU at a speed of <900> MHz,
	// Is <6> seconds, a <12.5> times slower than the
	// Version made ??with Delphi 4.01.
	//
	// Related Publications:
	// -
	//
	// Example of use:
	//
	// FUNCTION TestKeyGenSpeed(nKeyGenLength)
	//  LOCAL xGen := Space(0)
	//  LOCAL Counter := 0
	//  LOCAL tBegin := Seconds()
	//  LOCAL tEnd := 0
	//  LOCAL lSw00 := .F.
	//
	// WHILE (lSw00 <> .T.)
	//  xGen := KeyGen(nKeyGenLength, xGen)
	//  lSw00 := IF((Len(xGen) < 1), .T., lSw00)
	//  Counter := (Counter + 1)
	// END WHILE
	//
	//  tEnd := Seconds()
	//  ? ("- Needed time to all <" + Str(nKeyGenLength) + "> Byte combinations are:  " + NToCTime(tEnd - tBegin))
	//  ? ("- Total operations tested was:  " + Str((Counter - 1)))
	//  RETURN(NIL)
	//

	LOCAL __nBeginLen	:= Len( __cIn )
	LOCAL __cOut 		:= ReverseStr( @__cIn , __nBeginLen )
	LOCAL __nKeyLen1		:= __nKeyLen + 1
	LOCAL __aOut[__nKeyLen1]
	LOCAL __nB00 		:= 0
	LOCAL __lSw00 		:= .T.

	STATIC __Chr0		:= Chr( 0 )

	IF  __nKeyLen < 1
		RETURN( "" )
	ELSEIF __nBeginLen < 1
		RETURN( __Chr0 )
	ENDIF

	__nKeyLen := Max( 1, __nKeyLen )

	IF __nBeginLen > __nKeyLen
		RETURN( "" )
	ENDIF

	WHILE ++__nB00 <= __nKeyLen1
		__aOut[__nB00] := IF(  __nB00 <= __nBeginLen , Asc( SubStr(__cOut, __nB00, 1 ) ), -1 )
	END WHILE

	__nB00	:= 1
	__lSw00	:= .T.

	WHILE __nB00 <= __nKeyLen1
		IF __lSw00
			++__aOut[__nB00]
			__aOut[__nB00] %= 256
			__lSw00 := ( __aOut[__nB00] < 1 .AND. __nB00 <= __nBeginLen )
		ENDIF
		++__nB00
	END WHILE

	__cOut := ""
	__nB00 := __nKeyLen1

	WHILE ( __nB00 > 0 )
		IF __aOut[__nB00] > -1
			__cOut  += Chr(__aOut[__nB00] )
		ENDIF	
		--__nB00
	END WHILE

RETURN( IF( Len(__cOut ) > __nKeyLen, "", __cOut ) )

//()> {String}

FUNCTION KeyGenX( __nKeyLen, __cIn, __cASCII , __aTable , __nTableLen )

	// KeyGenX() - Generador de cadenas de caracteres con tabla de caracteres programable.
	// Desarrollo de la Función:  15-Ene-2009 > 12-Ago-2011
	// (c) Alejandro Padrino, 2.009 - 2.011
	//
	// Funciones Relacionadas:
	// - KeyGen()
	// - ReverseStr()
	//
	// __nKeyLen   - Longitud máxima de la cadena de caracteres.
	// __cIn       - Valor inicial de la cadena de caracteres.
	// __cTable    - Caracteres a usar en la Tabla de Caracteres Programable, indicados por orden de menor a mayor.
	//
	// __cOut      - Valor devuelto por esta función.
	// __aTable    - Matriz de la Tabla de Caracteres ASCII Programable.
	// __aOut      - Matriz de caracteres.
	// __cAscii    - Caracteres reconocidos en la Tabla de Caracteres.
	// __nBeginLen - Longitud inicial de la cadena de caracteres.
	// __nTableLen - Longitud inicial de la Tabla de Caracteres.
	// __lSw00     - Conmutador lógico.
	// __cTmp00    - Variable string temporal #00.
	// __nTmp00    - Variable numérica temporal #00.
	// __nB00      - Variable numérica temporal #01.
	//
	// Esta función devuelve la combinación de caracteres siguiente a la introducida
	// por <__cIn> usando los caracteres de la tabla ASCII indicados en <__cTable>, con
	// una longitud de <__nKeyLen> caracteres.  Al alcanzarse la última combinacion de
	// caracteres posible en la longitud indicada, esta función devuelve una cadena de
	// caracteres vacía.  El orden en que se indiquen los caracteres ASCII de <__cTable>
	// es significativo.
	//
	// AVISO IMPORTANTE:  Esta función puede reducir considerablemente la velocidad
	//                    de su programa según sean los valores de <__nKeyLen> y
	//                    <__cTable>.  Si necesita trabajar con los <256> caracteres
	//                    de la tabla ASCII utilice la funcion <KeyGen()>.  La velocidad
	//                    aproximada para todas las combinaciones posibles usando los <256>
	//                    caracteres de la tabla ASCII, usando <2> caracteres de longitud
	//                    en un PC con una CPU a una velocidad de <900> MHz, es de <300>
	//                    Segundos, unas <219> veces más lenta que la versión realizada
	//                    con Delphi 4.01.  Si <__cIn> contiene caracteres que no existan
	//                    en <__cTable>, éstos se sustituirán por el primer caracter
	//                    indicado en <__cTable>.
	//
	// Publicaciones Relacionadas:
	// - http://foro.elhacker.net/programacion_general/generador_de_caracteres_en_delphi-t242384.0.html;msg1484943
	// 

	LOCAL __nBeginLen 	:= Len( __cIn )
	LOCAL __nBeginLen1	:= __nBeginLen + 1
	LOCAL __cOut 		:= ReverseStr( @__cIn , __nBeginLen )
	LOCAL __nKeyLen1 	:= __nKeyLen + 1
	LOCAL __aOut[__nKeyLen1]
	LOCAL __cTmp00 		:= ""
	LOCAL __nB00 		:= 1
	LOCAL __lSw00		:= .T.

	IF ( __nKeyLen < 1 )
		RETURN( "" )
	ENDIF

	IF __nBeginLen < 1
		RETURN( Chr( __aTable[1] ) )
	ENDIF

	__nKeyLen := Max( 1, __nKeyLen )
	__nB00 := 0

	IF __nBeginLen > __nKeyLen
		RETURN( "" )
	ENDIF

	WHILE  ++__nB00 <= __nKeyLen1
		__cTmp00 := SubStr( __cOut, __nB00, 1 )
		__aOut[__nB00] := IF(__nB00 <= __nBeginLen, At( __cTmp00, __cAscii ),-1 )
	END WHILE

	__nB00 	:= 0
	__lSw00	:= .T.

	WHILE ++__nB00 <= __nKeyLen1
		IF __lSw00
			++__aOut[__nB00]
			IF __aOut[__nB00] > __nTableLen .OR. __aOut[__nB00] <= 1
				__aOut[__nB00]	:= 1
			ENDIF   
			__lSw00 := ( __aOut[__nB00] <= 1 ) .AND. ( __nB00 < __nBeginLen1 )
		ENDIF
	END WHILE

	__cOut := ""
	__nB00 := __nKeyLen1

	WHILE __nB00 >= 1
		IF __aOut[__nB00] > 0
			__cOut += Chr(__aTable[__aOut[__nB00]] )
		ENDIF	
		--__nB00
	END WHILE

RETURN( IF( (Len(__cOut ) > __nKeyLen ), "", __cOut ) )

//()> {String}

FUNCTION ReverseStr( __cInput , __nNum00 )

	// ReverseStr() - Devuelve una Cadena de Caracteres en orden inverso.
	// Desarrollo de la Función:  01-Dic-2004 > 01-Dic-2004
	// (c) Alejandro Padrino, 2.004
	//
	// Funciones Relacionadas:
	// - (Ninguna)
	//
	// __nNum00 - Variable numérica temporal #00.
	//

	LOCAL __ReverseStr	:= ""

	WHILE __nNum00 > 0 
		__ReverseStr += SubStr( __cInput, __nNum00--, 1 )
	END WHILE

RETURN( __ReverseStr )