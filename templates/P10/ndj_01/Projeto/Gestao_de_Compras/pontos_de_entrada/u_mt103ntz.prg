#INCLUDE "NDJ.CH"
/*/
    Funcao:    MT103NTZ
    Autor:    Marinaldo de Jesus
    Data:    25/02/2011
    Uso:    Carregar a Natureza de Acordo com o Produto na Classificacao da Nota Fiscal 
    Obs.:    O parâmetro MV_2DUPNAT deverá estar com o conteúdo: SA2->A2_NATUREZ e o campo A2_NATUREZ, 
            para todos os registros de Fornecedores Deverão estar em branco, uma vez que o código da 
            Natureza será retornado baseado no Produto.
/*/
User Function MT103NTZ()

    Local cD1Cod
    Local cNatureza
    Local cMT103NTZ        := ParamIxb[1]
    Local cF4Filial        := xFilial( "SF4" )
    Local cB1Filial        := xFilial( "SB1" )

    Local nSF4Order        := RetOrder( "SF4" , "F4_FILIAL+F4_CODIGO" )
    Local nSB1Order        := RetOrder( "SB1" , "B1_FILIAL+B1_COD" )

    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "D1_TES" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "D1_TES" ) );
        )
        cD1Tes := GdFieldGet( "D1_TES" )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "D1_TES" ) )
        cD1Tes := StaticCall( NDJLIB001 , GetMemVar , "D1_TES" )
    EndIF

    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "D1_COD" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "D1_COD" ) );
        )
        cD1Cod := GdFieldGet( "D1_COD" )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "D1_COD" ) )
        cD1Cod := StaticCall( NDJLIB001 , GetMemVar , "D1_COD" )
    EndIF

    IF (;
            !Empty( cD1Tes );
            .and.;
            !Empty( cD1Cod );
        )    
        IF ( Posicione( "SF4" , nSF4Order , cF4Filial + cD1Tes , "F4_ATUATF" ) == "S" )
            cNatureza := Posicione( "SB1" , nSB1Order , cB1Filial + cD1Cod , "B1_XNATURE" )
        Else
            cNatureza := Posicione( "SB1" , nSB1Order , cB1Filial + cD1Cod , "B1_XNATU02" )
        EndIF
        IF !Empty( cNatureza )
            cMT103NTZ := cNatureza
        EndIF
    EndIF

Return( cMT103NTZ )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        lRecursa    := __Dummy( .F. )
        __CCRLF        := __CCRLF
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
