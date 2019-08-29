#INCLUDE "NDJ.CH"
/*/
    Funcao:        FT340VLD
    Data:        20/12/2010
    Autor:        Marinaldo de Jesus
    Descricao:    Ponto de Entrada executado no progama FATA340.
                Sera utilizado para:
                1 ) Verificar se pode incluir novo Documento vinculado a SC;
/*/
User Function FT340VLD( lShowHelp )

    Local nOpcx                := ParamIxb[1]
    Local cFunName            := ParamIxb[2]
    
    Local lRet                 := .T.
    Local lLinkedDoc        := .F.
    Local lFt340Inclui        := .F.
    
    Local oException
    
    Static nStackCount        := 0

    TRYEXCEPTION    

        DEFAULT lShowHelp    := .F.

        IF !( IsInCallStack( "NDJSCDoc" ) )
            BREAK
        EndIF

        IF !( Type( "INCLUI" ) == "L" )
            lFt340Inclui := ( Upper( AllTrim( cFunName ) ) == Upper( AllTrim( "Ft340Inclu" ) ) )
            IF ( lFt340Inclui )
                IF ( nOpcx == 3 )
                    INCLUI := .T.
                EndIF    
            EndIF
            BREAK
        EndIF

        IF !( INCLUI )
            BREAK
        EndIF

        ++nStackCount

        lLinkedDoc        := StaticCall( U_FT340MNU , LinkedFile ) //Verifico se ja tem documento vinculado

        IF (;
                ( lLinkedDoc );
                .or.;
                ( nStackCount > 1 );
            )    
            MbrChgLoop( .F. )
            lRet    := .F.
            IF (;
                    ( nStackCount <= 1 );
                    .and.;
                    ( lLinkedDoc );
                )    
                lShowHelp    := .T.
                UserException( "Já existe documento vinculçado À essa Solicitação de Compras" )
            EndIF
            nStackCount    := 0
        EndIF

    CATCHEXCEPTION USING oException

        nStackCount    := 0
    
        IF ( ValType( oException ) == "O" )
            IF ( lShowHelp )
                Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
            Else
                ConOut( oException:Description , oException:ErrorStack )
            EndIF
        EndIF

    ENDEXCEPTION

Return( lRet )
