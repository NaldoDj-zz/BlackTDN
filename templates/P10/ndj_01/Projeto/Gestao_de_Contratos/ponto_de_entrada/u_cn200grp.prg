#INCLUDE "NDJ.CH"
/*/
    Function:    CN200GRP
    Autor:        Marinaldo de Jesus
    Data:        25/12/2010
    Descricao:    Ponto de Entrada CN200GRP. Executado na Funcao CN200Grv em CNTA200 ( Rotina de cadastro das planilhas de contrato )
    Uso:        Gravar Informacoes Complementares apos a Gravacao das Planilhas de Contratos
/*/
User Function CN200GRP()
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
        lRecursa    := __Dummy( .F. )
        __cCRLF        := NIL
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
