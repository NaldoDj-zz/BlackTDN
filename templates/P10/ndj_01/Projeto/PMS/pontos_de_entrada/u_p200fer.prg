#INCLUDE "NDJ.CH"
/*/
    Funcao: P200FER
    Autor:    Marinaldo de Jesus
    Data:    08/02/2011
    Uso:    Implementação do Ponto de Entrada P200FER, executado nas Rotinas PMSA410 e PMSA200. Usado para inibir a utilização das opções
            disponíveis no botão Ferramentas.
/*/
User Function P200FER()

    Local aEnable
    Local aDisable

    Local nIndex
    Local nLoop
    Local nLoops
    
    Local oMenu            := ParamIxb
    Local oException

    TRYEXCEPTION

        IF !( ValType( oMenu ) == "O" )
            BREAK
        EndIF
        
        aEnable        := {}
        aDisable    := { Lower( "Recodificar" ) }

        nLoops        := Len( aEnable )
        For nLoop := 1 To nLoops
            nIndex         := aScan( oMenu:aItems , { |x| Lower( AllTrim( x:cCaption ) ) == aEnable[nLoop] } )
            IF ( nIndex > 0 )
                oMenu:aItems[ nIndex ]:Enable()
            EndIF
        Next nLoop

        nLoops        := Len( aDisable )
        For nLoop := 1 To nLoops
            nIndex         := aScan( oMenu:aItems , { |x| Lower( AllTrim( x:cCaption ) ) == aDisable[nLoop] } )
            IF ( nIndex > 0 )
                oMenu:aItems[ nIndex ]:Disable()
            EndIF
        Next nLoop

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
            ConOut( oException:Description , oException:ErrorStack )
        EndIF    

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
