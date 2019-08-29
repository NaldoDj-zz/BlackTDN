#INCLUDE "NDJ.CH"
/*/
    Funcao:     CN200PID
    Autor:        Marinaldo de Jesus
    Data:        23/12/2010
    Descricao:    Implementacao do Ponto de Entrada CN200PID em CNTA200
                Será utilizado complementar o Filtro pra a Selecao dos Pedidos a serem adicionados a Contratos
/*/
User Function CN200PID()
    
    Local aArea        := GetArea()
    
    Local cC7NUm
    Local cFiltro
    Local cContrato
    Local cSC7Filial
    Local cCN9Filial
    Local cCNCFilial
    Local cNextAlias
    Local cFornecedor
    Local cC7XCTNCNB

    Local lExecute
    Local lAditivo
    Local lContrato
    Local lGdFornece
    
    Local nFieldPos

    Local oException
    
    TRYEXCEPTION

        lAditivo    := IsInCallStack("NDJADITIVOS")
        lContrato    := ( IsInCallStack("NDJCONTRATOS") .and. !( lAditivo ) )
        lExecute    := ( lContrato .or. lAditivo )
        IF !( lExecute )    //Ira executar apenas quando proveniente da Geracao de Contratos ou de Aditivo
            BREAK
        EndIF

        cSC7Filial    := xFilial( "SC7" )

        IF ( lContrato )
        
            cC7NUm        := SC7->C7_NUM
            cFiltro        := "( C7_FILIAL=='" + cSC7Filial + "' .and. C7_NUM='" + cC7NUm + "' )"

            BREAK

        EndIF
        
        IF ( lAditivo )

            lGdFornece := (;
                                ( ValType( "oGetDad1" ) == "O" );
                                .and.;
                                StaticCall( NDJLIB001 , IsInGetDados , "CNC_CODIGO" , oGetDad1:aHeader , oGetDad1:aCols , oGetDad1:nAt );
                            )    
        
            IF ( lGdFornece )

                cFornecedor := GdFieldGet( "CNC_CODIGO" , oGetDad1:nAt , .F. , oGetDad1:aHeader , oGetDad1:aCols )

                cC7XCTNCNB    := Space( GetSx3Cache( "C7_XCTNCNB" , "X3_TAMANHO" ) )
                
                cFiltro        := "("
                cFiltro        +=         "C7_FILIAL=='" + cSC7Filial + "' .and. C7_XCNTADT == .T. .and. C7_XCTNCNB=='" + cC7XCTNCNB + "'"
                IF !Empty( cFornecedor )
                    cFiltro    +=         " .and. C7_FORNECE=='" + cFornecedor + "'"
                EndIF
                cFiltro        += ")"

                BREAK
            
            EndIF
            
            IF (;
                    StaticCall( NDJLIB001 , IsInGetDados , "CN9_NUMERO" );
                    .and.;
                    !( StaticCall( NDJLIB001 , IsCpoVar ,  "CN9_NUMERO" ) );
                )
                cContrato    := GdFieldGet( "CN9_NUMERO" )
            ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "CN9_NUMERO" ) )
                cContrato    := StaticCall( NDJLIB001 , GetMemVar , "CN9_NUMERO" )
            ElseIF ( CN9->( nFieldPos := FieldPos( "CN9_NUMERO" ) ) > 0 )
                cContrato    := CN9->( FieldGet( nFieldPos ) )
            EndIF
            
            cCN9Filial    := xFilial( "CN9" )
            cCNCFilial    := xFilial( "CNC" , cCN9Filial )

            cNextAlias    := GetNextAlias()
            BEGINSQL ALIAS cNextAlias
                SELECT DISTINCT
                    CNC.CNC_CODIGO+CNC.CNC_LOJA FORNECEDOR
                FROM
                    %table:CNC% CNC,
                    %table:CN9% CN9
                WHERE
                    CN9.%NotDel%
                AND
                    CN9.CN9_FILIAL = %exp:cCN9Filial%
                AND    
                    CN9.CN9_NUMERO = %exp:cContrato%
                AND
                    CNC.%NotDel%
                AND
                    CNC.CNC_FILIAL = %exp:cCNCFilial%
                AND
                    CNC.CNC_NUMERO = CN9.CN9_NUMERO
            ENDSQL
            
            cFornecedor := ""
            While ( cNextAlias )->( !Eof() )
                cFornecedor += ( cNextAlias )->FORNECEDOR
                cFornecedor += "/"
                ( cNextAlias )->( dbSkip() )
            End While

            ( cNextAlias )->( dbCloseArea() )

            cC7XCTNCNB    := Space( GetSx3Cache( "C7_XCTNCNB" , "X3_TAMANHO" ) )
            
            cFiltro        := "("
            cFiltro        +=         "C7_FILIAL=='" + cSC7Filial + "' .and. C7_XCNTADT == .T. .and. C7_XCTNCNB=='" + cC7XCTNCNB + "'"
            IF !Empty( cFornecedor )
                cFiltro    +=         " .and. C7_FORNECE+C7_LOJA$'" + cFornecedor + "'"
            EndIF
            cFiltro        += ")"

            BREAK

        EndIF

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
            ConCout( CaptureError())
        EndIF    

    ENDEXCEPTION

    RestArea( aArea )

Return( cFiltro )

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
