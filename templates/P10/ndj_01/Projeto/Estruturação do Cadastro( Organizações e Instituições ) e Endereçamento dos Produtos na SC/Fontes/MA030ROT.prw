#INCLUDE "NDJ.CH"
*----------------------*
User Function MA030ROT()
*----------------------*]
Local _aRet := {} 
Local I        

If Type ( "_c_p_Tipo_Menu" ) == "U"
	Return aRotina 
End If 

If _c_p_Tipo_Menu != "O"
    aAdd( _aRet, { "Pesq. Rápida","U_NDJC001" , 0, 2 } )
End If
For I := 01 To Len ( aRotina ) 
	If _c_p_Tipo_Menu == "O" .And. Upper( Alltrim( aRotina[I][02] ) ) == "FTCONTATO"	
		Loop 
	End If                             	
	aAdd( _aRet, aClone( aRotina[I] ) )	
Next I

aRotina := {}


Return _aRet

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
		lRecursa 		:= __Dummy( .F. )
		__cCRLF		:= NIL
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )