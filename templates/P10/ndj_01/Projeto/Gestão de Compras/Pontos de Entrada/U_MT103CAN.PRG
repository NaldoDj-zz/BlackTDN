#INCLUDE "NDJ.CH"
/*/
	Programa:	MT103CAN
	Autor:		Marinaldo de Jesus
	Data:		24/08/2011
	Descricao:	Ponto de Entrada Executado nos programas MATA103 se Clicou no Botao Cancelar
/*/
User Function MT103CAN()
    StaticCall( NDJLIB004 , SetPublic , "__lMT103CAN"     , .T.    , "L" , 1 , .T. )    //Cancelou o Processo na MATA103
    StaticCall( U_NDJBLKSCVL , SZ0TTSCommit )                                        //Forca o Commit das Alteracoes de Empenho
    StaticCall( U_NDJA002 , SZ4SZ5Commit )                                            //Forca o Commit das Alteracoes de Destinos    
Return( NIL )

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