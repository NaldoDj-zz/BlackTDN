#INCLUDE "NDJ.CH"
/*/
    Funcao:        MT110LEG
    Autor:        Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada MT110LEG executado na funcao A110Legenda
                do programa MATA110 para adicionar novos elementos na Legenda
/*/
User Function MT110LEG()
    
    Local aLegend    := ParamIxb[1]

    IF !( ValType( aLegend ) == "A" )
        aLegend := {}
    EndIF

    aAdd( aLegend , { "CRDIMG16"        , OemToAnsi( "Em Pré-Analise" ) } )
    aAdd( aLegend , { "CFGIMG16"        , OemToAnsi( "Suspensa ou Aguardando Alterações" ) } )

    IF IsInCallStack( "GetC1Status" )
        __aLegend_ := aLegend
        UserException( "IGetC1Status" )
    EndIF

Return( aLegend )

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
