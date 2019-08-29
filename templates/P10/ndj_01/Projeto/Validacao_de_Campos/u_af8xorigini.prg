#INCLUDE "NDJ.CH"
/*/
    Funcao: U_Af8xOrigIni
    Autor:    Marinaldo de Jesus
    Uso:    Inicializador padrao para o campo AF8_XORIG
/*/
User Function Af8xOrigIni()

    Local aArea        := GetArea()
    Local aAF1Area    := AF1->( GetArea() )
    Local cInitPad    := POSICIONE('AF1',1,XFILIAL('AF8')+AF8->AF8_ORCAME,'AF1_XDORIG')                                                                  
    
    RestArea( aAF1Area  )
    RestArea( aArea  )

Return( cInitPad )

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
