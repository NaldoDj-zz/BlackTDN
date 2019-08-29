#INCLUDE "NDJ.CH"
/*/
    Funcao:     FT340CHG
    Autor:        Marinaldo de Jesus
    Data:        20/12/2010
    Descricao:    Implementacao do Ponto de Entrada FT340CHG para a tratamento dos arquivos provenientes da SC no programa FATA340
/*/
User Function FT340CHG()

    Local cExt        := ""
    Local cNameServ    := ParamIxb[1]

    TRYEXCEPTION

        IF !( IsInCallStack( "NDJSCDoc" ) )
            BREAK
        EndIF

        SplitPath( cNameServ , NIL , NIL , NIL , @cExt ) 

        cNameServ    := "sc"+cA110Num+cExt

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            ConOut( CaptureError() )
        EndIF

    ENDEXCEPTION

Return( cNameServ )

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
