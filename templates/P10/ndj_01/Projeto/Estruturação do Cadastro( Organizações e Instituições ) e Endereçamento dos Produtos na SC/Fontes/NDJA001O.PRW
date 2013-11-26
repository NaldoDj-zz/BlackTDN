#INCLUDE "NDJ.CH"
/*
ܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜ
������������������������������������������������������������������������������
��ɍ͍͍͍͍͍͍͍͍͍͑ˍ͍͍͍э͍͍͍͍͍͍͍͍͍͍͍͍͋э͍͍͍͍͍v͍���
���Programa  �NDJA001O  �Autor  �Rafael Rezende      � Data �  09/09/2010  ���
��͍͍͍͍͍͍͍͍͍̍͘ʍ͍͍͍ύ͍͍͍͍͍͍͍͍͍͍͍͍͊ύ͍͍͍͍͍͍͹��
���Desc.     �  Rotina com o Objetivo de permitir a manuten磯 do cadastro ���
���          �de Organiza絥s baseado na Rotina de Cadastro de Clientes.   ���
��͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍̍͘͹��
���Uso       � SIGAADV                                                     ���
��ȍ͍͍͍͍͏͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍ͼ��
������������������������������������������������������������������������������
ߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟ
*/

*----------------------*
User Function NDJA001O()
*----------------------*                       
StaticCall( NDJLIB004 , SetPublic , "_c_p_Tipo_Menu" , "O" )//Variavel p�blica utilizada nos pontos de Entrada MA030ROT e MA030BRW.

//Chamada da Rotina Padr㯠de Cadastro de Clientes 
Mata030()

Return


*-----------------------------*
User Function NDJRetOrgCodigo()
*-----------------------------*
Local _aArea  := GetArea()
Local _cRet   := ""
Local _cQuery := ""
Local _cAlias := GetNextAlias()

If ValType( _c_p_Tipo_Menu ) != "U" 

	If _c_p_Tipo_Menu == "O"

		_cQuery := " SELECT MAX( A1_COD ) AS [CODIGO] "
		_cQuery += "   FROM " + RetSQLName( "SA1" ) + " (NOLOCK) "
		_cQuery += "  WHERE D_E_L_E_T_ = ' ' "
		_cQuery += "    AND A1_FILIAL  = '" + XFilial( "SA1" ) + "' "
		TcQuery _cQuery Alias ( _cAlias ) New 
		If !( _cAlias )->( Eof() )
			_cRet := ( _cAlias )->CODIGO
		Else
			_cRet := StrZero( 0, TamSX3( "A1_COD" )[01] )		
		End If 
		_cRet := Soma1( _cRet )
	Else  
		_cRet := ""
	End If  
Else
	_cRet := ""
End If 
		
RestArea( _aArea )

Return _cRet 

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
		lRecursa	:= __Dummy( .F. )
		__cCRLF		:= NIL
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )