#INCLUDE "NDJ.CH"
/*/
    Funcao:        MT120LEG
    Autor:        Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada MT120LEG executado na funcao A120Legenda
                do programa MATA120 para adicionar novos elementos na Legenda
/*/
User Function MT120LEG()
    
    Local aLegend    := ParamIxb[1]

    IF !( ValType( aLegend ) == "A" )
        aLegend := {}
    EndIF

    aAdd( aLegend , { "NDJSOLICITACNT_16"    , OemToAnsi( "Solicitação de Contrato" ) } )
    aAdd( aLegend , { "NDJADITIVOCNT_16"    , OemToAnsi( "Solicitação de Aditivo"  ) } )
    aAdd( aLegend , { "BPMSDOCA_16"            , OemToAnsi( "Bloqueado por Contrato"  ) } )
    aAdd( aLegend , { "CADEADO_16"            , OemToAnsi( "Bloqueado por Orçamento" ) } )

    IF IsInCallStack( "GetC7Status" )
        __aLegend_ := aLegend
        UserException( "IGetC7Status" )
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
