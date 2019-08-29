#INCLUDE "NDJ.CH"
/*
ܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜ
������������������������������������������������������������������������������
��ɍ͍͍͍͍͍͍͍͍͍͑ˍ͍͍͍э͍͍͍͍͍͍͍͍͍͍͍͍͋э͍͍͍͍͍v͍���
���Programa  �NDJA001I  �Autor  �Rafael Rezende      � Data �  01/10/2010  ���
��͍͍͍͍͍͍͍͍͍̍͘ʍ͍͍͍ύ͍͍͍͍͍͍͍͍͍͍͍͍͊ύ͍͍͍͍͍͍͹��
���Desc.     �  Rotina com o Objetivo de permitir a manuten磯 do cadastro ���
���          �de Institui絥s baseado na Rotina de Cadastro de Clientes.   ���
��͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍̍͘͹��
���Uso       � SIGAADV                                                     ���
��ȍ͍͍͍͍͏͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍ͼ��
������������������������������������������������������������������������������
ߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟ
*/

*----------------------*
User Function NDJA001I()
*----------------------*
StaticCall( NDJLIB004 , SetPublic , "_c_p_Tipo_Menu" , "I" )//Variavel p�blica utilizada nos pontos de Entrada MA030ROT e MA030BRW.

//Chamada da Rotina Padr㯠de Cadastro de Clientes 
Mata030()

Return 


*-------------------------------------------------*
User Function NDJVerOrganizacao( _cCodOrganizacao )
*-------------------------------------------------*
Local _aArea     := GetArea()
Local _lRet      := .T.
Local _cLoja     := StrZero( 0, TamSX3( "A1_LOJA" )[01] )
_cCodOrganizacao := If( _cCodOrganizacao == Nil, M->A1_COD, _cCodOrganizacao ) 

If ValType( _c_p_Tipo_Menu ) != "U" 

    If _c_p_Tipo_Menu == "O"
        DbSelectArea( "SA1" )
        DbSetOrder( 01 ) //A1_FILIAL + A1_COD + A1_LOJA 
        Seek XFilial( "SA1" ) + _cCodOrganizacao + _cLoja
        If Found()
            Aviso( "Aten磯", "A Organiza磯 informada jᠥxiste.", { "Voltar" } )
            _lRet := .F.
        Else
            _lRet := .T.
        End If
    Else
        DbSelectArea( "SA1" )
        DbSetOrder( 01 ) //A1_FILIAL + A1_COD + A1_LOJA 
        Seek XFilial( "SA1" ) + _cCodOrganizacao + _cLoja
        If !Found()
            Aviso( "Aten磯", "A Organiza磯 informada n㯠foi encontrada no Cadastro de Organiza絥s.", { "Voltar" } )
            _lRet := .F.
        Else  
            M->A1_LOJA := NDJRetLjInst( _cCodOrganizacao )
            _lRet := .T.
        End If 
    End If
Else
    _lRet := .T.
End If             

RestArea( _aArea )

Return _lRet

*----------------------------------------------*
Static Function NDJRetLjInst( _cCodOrganizacao )
*----------------------------------------------*
Local _aArea     := GetArea()
Local _cRet      := ""
Local _cQuery    := ""
Local _cAlias    := GetNextAlias()                       
_cCodOrganizacao := If( _cCodOrganizacao == Nil, M->A1_COD, _cCodOrganizacao )

If ValType( _c_p_Tipo_Menu ) != "U" 

    If _c_p_Tipo_Menu == "O"
        _cRet := "00"
    Else
        _cQuery := " SELECT MAX( A1_LOJA ) AS [LOJA] "
        _cQuery += "   FROM " + RetSQLName( "SA1" ) + " (NOLOCK) "
        _cQuery += "  WHERE D_E_L_E_T_ = ' ' "
        _cQuery += "    AND A1_FILIAL  = '" + XFilial( "SA1" ) + "' "
        _cQuery += "    AND A1_COD     = '" + _cCodOrganizacao + "' "
        TcQuery _cQuery Alias ( _cAlias ) New 
        If !( _cAlias )->( Eof() )
            _cRet := ( _cAlias )->LOJA
        Else
            _cRet := StrZero( 0, TamSX3( "A1_LOJA" )[01] )        
        End If 
        _cRet := Soma1( _cRet )
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
        lRecursa    := __Dummy( .F. )
        __cCRLF        := NIL
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
