#INCLUDE "NDJ.CH"
/*/
    Funcao: MT103FIM
    Autor:    Marinaldo de Jesus
    Data:    14/08/2011
    Uso:    Executada a partir da A103NFiscal em MATA103.
/*/
User Function MT103FIM()
    TRYEXCEPTION
        //Forca o Commit das Alteracoes de Destinos
        StaticCall( U_NDJA002 , SZ4SZ5Commit )
        //Forca o Commit das Alteracoes de Empenho
        StaticCall( U_NDJBLKSCVL , SZ0TTSCommit )
        //Libera os Locks Pendentes
        StaticCall( NDJLIB003 , AliasUnLock )
    CATCHEXCEPTION
    ENDEXCEPTION
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
