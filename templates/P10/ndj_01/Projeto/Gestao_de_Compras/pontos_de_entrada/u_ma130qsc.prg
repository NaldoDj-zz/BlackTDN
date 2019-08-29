#INCLUDE "NDJ.CH"
/*/
    Funcao: MA130QSC
    Autor:    Marinaldo de Jesus
    Data:    22/10/2010
    Uso:    Ponto de Entrada MA130QSC na Rotina MATA130 na Geracao da Cotacao.
            Conforme Documento: MIT041 do Processo de Compras.
            1 ) A implementacao dessse ponto de Entrada ira fazer que todos os itens
            de cotacao sejam gerados separadamente. Essa implementacao eh tratada no retorno da funcao.
            2 ) Atribuir valores que serao gravados nos campos C1_XNUMPRO e C1_XMODALI pelo ponto de entrada MT130WF
/*/
User Function MA130QSC()

    Local aPerg            := {}
    Local aSX3Box        := {}
    
    Local __cMA130QSC    := "0000000"
    
    Local nPerg
    Local nTentou        := 0

    aAdd( aPerg , Array( 9 ) )
    nPerg := Len( aPerg )

    aPerg[nPerg][1]    :=  1                                                    //[1] : 1 - MsGet
    aPerg[nPerg][2]    := GetSx3Cache( "C1_XNUMPRO" , "X3_DESCRIC" )            //[2] : Descricao
    aPerg[nPerg][3]    := Space( GetSx3Cache( "C1_XNUMPRO" , "X3_TAMANHO" ) )    //[3] : String contendo o inicializador do campo
    aPerg[nPerg][4]    := GetSx3Cache( "C1_XNUMPRO" , "X3_PICTURE" )            //[4] : String contendo a Picture do campo
    aPerg[nPerg][5]    := "NaoVazio()"                                            //[5] : String contendo a validacao
    aPerg[nPerg][6]    := ""                                                    //[6] : Consulta F3
    aPerg[nPerg][7]    := ".T."                                                //[7] : String contendo a validacao When
    aPerg[nPerg][8]    := GetSx3Cache( "C1_XNUMPRO" , "X3_TAMANHO" ) + 100        //[8] : Tamanho do MsGet
    aPerg[nPerg][9]    := .T.                                                    //[9] : Flag .T./.F. Parametro Obrigatorio ?
    
    aAdd( aPerg , Array( 7 ) )
    nPerg := Len( aPerg )
    
    aSx3Box            := Sx3Box2Arr( "C1_XMODALI" )
    
    aPerg[nPerg][1]    := 2                                                    //[1] : 2 - Combo
    aPerg[nPerg][2]    := GetSx3Cache( "C1_XMODALI" , "X3_DESCRIC" )            //[2] : Descricao
    aPerg[nPerg][3]    := Len( aSx3Box )                                        //[3] : Numerico contendo a opcao inicial do combo
    aPerg[nPerg][4]    := aSx3Box                                                //[4] : Array contendo as opcoes do Combo
    aPerg[nPerg][5]    := GetSx3Cache( "C1_XMODALI" , "X3_TAMANHO" ) + 100        //[5] : Tamanho do Combo
    aPerg[nPerg][6]    := "NaoVazio()"                                            //[6] : Validacao
    aPerg[nPerg][7]    := .T.                                                    //[7] : Flag .T./.F. Parametro Obrigatorio ?

    MV_PAR01        := Space( GetSX3Cache( "C8_XNUMPRO" , "X3_TAMANHO" ) )
    MV_PAR02        := Space( GetSX3Cache( "C8_XMODALI" , "X3_TAMANHO" ) )

    While (;
                !ParamBox( @aPerg , GetSx3Cache( "C1_XNUMPRO" , "X3_DESCRIC" ) , NIL , NIL , NIL , .T. );
                .or.;
                ( Type( "MV_PAR02" ) == "N" );
            )    
        IF ( Type( "MV_PAR02" ) == "N" )
            MsgInfo( "Tipos Incompatíveis. Informe a Modalidade"   , "Atenção" )
            MV_PAR02    := Space( GetSX3Cache( "C8_XMODALI" , "X3_TAMANHO" ) )
        Else
            MsgInfo( "O Número do Processo e Modalidade São obrigatórios" , "Atenção"  )
        EndIF
        IF ( ++nTentou > 10 )
            Final( OemToAnsi( "As Informações de Processo e Modalidade são obrigatórias" )  )
        EndIF
    End While

    StaticCall( NDJLIB004 , SetPublic , "_C1XNumero" , MV_PAR01 )
    StaticCall( NDJLIB004 , SetPublic , "_C1XModali" , MV_PAR02 )

Return( { || __cMA130QSC := __Soma1( __cMA130QSC ) } ) 

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
