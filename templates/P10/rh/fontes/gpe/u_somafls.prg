#INCLUDE "PROTHEUS.CH"
#INCLUDE "TRYEXCEPTION.CH"
User Function SomaFlds( cField1 , cField2 , nMax , cOper )

	Local cField1Desc
	Local cField2Desc
	
	Local cException

	Local lFldsOk 		:= .T.
	
	Local nField1
	Local nField2
	Local nFieldPos 
	
	Local oException
	
	TRYEXCEPTION

		IF (;
				IsInGetDados( { cField1 } );
				.and.;
				!( IsCpoVar( cField1 ) );
			)
			nField1 	:= GdFieldGet( cField1 )
		ElseIF ( IsMemVar( cField1 ) )
			nField1 := GetMemVar( cField1 )
		ElseIF ( ( nFieldPos := ( Alias() )->( FieldPos( cField1 ) ) ) > 0 )
			nField1 := ( Alias() )->( FieldGet( nFieldPos ) )
		EndIF	

		IF (;
				IsInGetDados( { cField2 } );
				.and.;
				!( IsCpoVar( cField2 ) );
			)
			nField2 	:= GdFieldGet( cField2 )
		ElseIF ( IsMemVar( cField2 ) )
			nField2 := GetMemVar( cField2 )
		ElseIF ( ( nFieldPos := ( Alias() )->( FieldPos( cField2 ) ) ) > 0 )
			nField2 := ( Alias() )->( FieldGet( nFieldPos ) )
		EndIF	

		IF (;
				!Empty( nField1 );
				.and.;
				!Empty( nField2 );
			)

			DEFAUlT nMax 	:= 0
			DEFAULT cOper	:= "=="
			
			IF !( &( Eval( { || AllTrim( Str( nField1 ) ) + "+" + AllTrim( Str( nField2 ) ) + cOper + AllTrim( Str( nMax ) ) } ) ) )

				IF ( IsInGetDados( { cField1 } ) )
					cField1Desc	:= aHeader[ GdFieldPos( cField1 ) , 1 ]
				EndIF	

				IF ( IsInGetDados( { cField2 } ) )
					cField2Desc	:= aHeader[ GdFieldPos( cField2 ) , 1 ]
				EndIF	

				cException := "Invalid Field(s) value(s) : "

				cException += CRLF
				cException += CRLF
				
				cException += cField1

				IF !Empty( cField1Desc )
					cException += "(" + cField1Desc + ")
				EndIF

				cException += " or "
                
				cException += cField2
				
				IF !Empty( cField2Desc )
					cException += "(" + cField2Desc + ")" 
				EndIF	

				UserException( cException )

			EndIF
						
		EndIF		
				
	
	CATCHEXCEPTION USING oException
	
		lFldsOk := .F. 
		
		MsgInfo( OemToAnsi( oException:Description ) )
	
	ENDEXCEPTION
	
Return( lFldsOk )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³IsCpoVar     ³Autor³Marinaldo de Jesus    ³ Data ³29/01/2010³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Verificar se a Variavel de Memoria Ativa corresponde ao  cam³
³          ³po passado por Parametro.									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³Generico													³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function IsCpoVar( cField )

	Local cVar	:= Upper( AllTrim( SubStr( ReadVar() , 4 ) ) )
	                                      
	DEFAULT cField := ""                  
	cField := Upper( AllTrim( cField ) )

Return( ( cVar == cField ) )