#INCLUDE "NDJ.CH"
/*/
    Funcao:     SD1ToAFN
    Autor:        Marinaldo de Jesus
    Data:        25/01/2011
    Uso:        Criar os Vinculos do PMS com as Documentos de Entrada ( AFN vs SF1/SD1 )
    Sintaxe:    StaticCall( U_SD1ToAFN , SD1ToAFN , nRecSF1 , cNFiscal , cSerie , cA100For , cLoja , cTipo , lDeleta )
/*/
Static Function SD1ToAFN( nRecSF1 , cNFiscal , cSerie , cA100For , cLoja , cTipo , lDeleta )

    Local aArea            := GetArea()
    Local aSF1Area        := SF1->( GetArea() )

    Local cSF1Filial
    Local cSD1Filial
    Local cAFNFilial

    Local cSF1KeySeek
    Local cSD1KeySeek
    Local cANFKeySeek

    Local lLock
    Local lAddNew
    Local lForceDelete    := .F.

    Local nSF1Order
    Local nSD1Order
    Local nAFNOrder

    Local oException

    TRYEXCEPTION

        IF Empty( nRecSF1 )

            nSF1Order    := RetOrder( "SF1" , "F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO" )

            cSF1Filial    := xFilial( "SF1" )

            cSF1KeySeek := cSF1Filial
            cSF1KeySeek += cNFiscal
            cSF1KeySeek += cSerie
            cSF1KeySeek += cA100For
            cSF1KeySeek += cLoja
            cSF1KeySeek += cTipo

            SF1->( dbSetOrder( nSF1Order ) )

            IF SF1->( !dbSeek( cSF1KeySeek , .F. ) )
                lForceDelete    := .T.
            Else
                nRecSF1    := SF1->( Recno() )
            EndIF

        EndIF

        IF !( lForceDelete )

            SF1->( MsGoto( nRecSF1 ) )

            cSF1Filial    := SF1->F1_FILIAL
            cNFiscal    := SF1->F1_DOC
            cSerie        := SF1->F1_SERIE
            cA100For    := SF1->F1_FORNECE
            cLoja        := SF1->F1_LOJA
            cTipo        := SF1->F1_TIPO

        Else

            lDelete        := .T.

        EndIF    

        nSD1Order    := RetOrder( "SD1" , "D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM" )

        cSD1Filial    := xFilial( "SD1" )

        cSD1KeySeek    := cSD1Filial
        cSD1KeySeek    += cNFiscal
        cSD1KeySeek    += cSerie
        cSD1KeySeek    += cA100For
        cSD1KeySeek    += cLoja

        IF !( lDeleta )
            lDeleta    := SD1->( !dbSeek( cSD1KeySeek  , .F. ) )
        EndIF

        cAFNFilial    := xFilial( "AFN" )

        nAFNOrder    := RetOrder( "AFN" , "AFN_FILIAL+AFN_DOC+AFN_SERIE+AFN_FORNEC+AFN_LOJA+AFN_ITEM+AFN_PROJET+AFN_REVISA+AFN_TAREFA" )

        AFN->( dbSetOrder( nAFNOrder ) )

        IF ( lDeleta )

            cAFNKeySeek    := cAFNFilial
            cAFNKeySeek    += cNFiscal
            cAFNKeySeek    += cSerie
            cAFNKeySeek    += cA100For
            cAFNKeySeek    += cLoja

            IF AFN->( !dbSeek( cAFNKeySeek , .F. ) )
                BREAK
            EndIF

            While AFN->(;
                            !Eof();
                            .and.;
                            ( AFN_FILIAL+AFN_DOC+AFN_SERIE+AFN_FORNEC+AFN_LOJA == cAFNKeySeek );
                        )

                AFN->( dbDelete() )

                AFN->( dbSkip() )

            End While

            BREAK

        EndIF

        AFN->( dbSetOrder( nAFNOrder ) )

        While SD1->(;
                        !Eof();
                        .and.;
                        ( D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA == cSD1KeySeek );
                    )

            cAFNKeySeek    := cAFNFilial
            cAFNKeySeek    += SD1->D1_DOC
            cAFNKeySeek    += SD1->D1_SERIE
            cAFNKeySeek    += SD1->D1_FORNECE
            cAFNKeySeek    += SD1->D1_LOJA
            cAFNKeySeek    += SD1->D1_ITEM
            cAFNKeySeek    += SD1->D1_XPROJET
            cAFNKeySeek    += SD1->D1_XREVIS
            cAFNKeySeek    += SD1->D1_XTAREFA

            lAddNew        := AFN->( !dbSeek( cAFNKeySeek , .F. ) )

            lLock        := AFN->( RecLock( "AFN" , lAddNew ) )

            IF ( lLock )

                AFN->AFN_FILIAL    := cAFNFilial
                AFN->AFN_PROJET    := SD1->D1_XPROJET
                AFN->AFN_TAREFA    := SD1->D1_XTAREFA
                AFN->AFN_REVISA    := SD1->D1_XREVIS
                AFN->AFN_DOC    := SD1->D1_DOC
                AFN->AFN_SERIE    := SD1->D1_SERIE
                AFN->AFN_FORNEC    := SD1->D1_FORNECE
                AFN->AFN_LOJA      := SD1->D1_LOJA
                AFN->AFN_COD       := SD1->D1_COD
                AFN->AFN_ITEM      := SD1->D1_ITEM
                AFN->AFN_TIPONF    := SD1->D1_TIPO
                AFN->AFN_QUANT    := SD1->D1_QUANT

                AFN->( MsUnLock() )

            EndIF

            SD1->( dbSkip() )
        
        End While
    
    CATCHEXCEPTION USING oException

        IF ( ValType( "oException" ) == "O" )
            ConOut( oException:Description )
        EndIF

    ENDEXCEPTION

    RestArea( aSF1Area )
    RestArea( aArea )

Return( NIL )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        SD1ToAFN()
        lRecursa    := __Dummy( .F. )
        __cCRLF        := NIL
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
