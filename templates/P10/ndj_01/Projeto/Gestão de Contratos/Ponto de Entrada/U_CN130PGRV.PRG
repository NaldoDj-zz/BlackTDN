#INCLUDE "NDJ.CH"
/*/
	Function:	CN130PGRV
	Autor:		Marinaldo de Jesus
	Data:		25/12/2010
	Descricao:	Ponto de Entrada CN130Grv. Executado na Funcao CN200Grv em CNTA130 ( Manutencao de Medicoes )
	Uso:		Gravar Informacoes Complementares apos a Gravacao das Manutencao de Medicoes
/*/
User Function CN130PGRV()
	//Forca o Commit das Alteracoes de Empenho
    StaticCall( U_NDJBLKSCVL , SZ0TTSCommit )
	//Forca o Commit das Alteracoes de Destinos	
    StaticCall( U_NDJA002 , SZ4SZ5Commit )
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