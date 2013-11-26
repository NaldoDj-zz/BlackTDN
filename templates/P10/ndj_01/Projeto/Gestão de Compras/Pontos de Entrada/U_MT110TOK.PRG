#INCLUDE "NDJ.CH"
/*/
	Funcao:		U_MT110TOK
	Autor:		Marinaldo de Jesus
	Data:		29/06/2011
	Uso:		Validacao de Todas as Linhas da Solicitacao de Compras
	Descricao:  Ponto de Entrada MT110TOK executado em A110TudOk do Programa MATA110 (Solicitacao de Compras)
/*/
User Function MT110TOK()

	Local lTudoOK		:= .T.
	Local lC1XREFCNT	:= .F.

	Local nSvn			:= n

	Local nItem
	Local nItens		:= Len( aCols )

	Local nQtd
	Local nQtdCnt
	Local nC1Quant

	Local oException

	TRYEXCEPTION

        IF ( StaticCall( NDJLIB001 , IsInGetDados , { "C1_XREFCNT" , "C1_QUANT" } ) )
			nQtdCnt		:= 0
			nC1XREFCNT	:= GdFieldPos( "C1_XREFCNT" )
			nC1Quant	:= GdFieldPos( "C1_QUANT" 	)
		EndIF

		For nItem := 1 To nItens
			n := nItem
			IF !( GdDeleted() )
				lTudoOK := U_MT110LOK()
				IF !( lTudoOK )
					UserException( "Existem Inconsisências na Solicitação de Compras." + CRLF + "Linha: " + Str( n ) )
				EndIF
				IF ( nC1XREFCNT > 0 )
					IF !( lC1XREFCNT )
						lC1XREFCNT	:= aCols[ n ][ nC1XREFCNT ]
					EndIF
					IF ( lC1XREFCNT )
						IF ( ( ++nQtdCnt ) == 1 )
							nQtd 	:= aCols[ n ][ nC1Quant ]
						Else
							lTudoOK	:= ( nQtd == aCols[ n ][ nC1Quant ] )
							IF !( lTudoOK )
								UserException( "A Quantidade Informada está incorreta." + CRLF + "Linha: " + Str( n ) )
							EndIF
						EndIF
					EndIF	
				EndIF	
			EndIF
		Next nItem

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
			ConOut( CaptureError() )
		EndIF	

	ENDEXCEPTION

	n	:= nSvn 

Return( lTudoOK  )

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