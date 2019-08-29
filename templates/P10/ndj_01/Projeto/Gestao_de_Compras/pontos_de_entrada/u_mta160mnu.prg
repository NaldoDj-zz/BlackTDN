#INCLUDE "NDJ.CH"
/*/
    Funcao: MTA160MNU
    Autor:    Marinaldo de Jesus
    Data:    14/12/2010
    Uso:    Executada no programa MATA160. 
            Sera utilizado alterar a descricao do aRotina de Analisar para Aprovar/Reprovar.
/*/
User Function MTA160MNU()

    Local lUMata160    := IsInCallStack( "U_MATA160"  )

    Local nPosOpc

    BEGIN SEQUENCE

        StaticCall( NDJLIB004 , SetPublic , "cNDJSC8FMbr" , NIL , "C" , 0 , .F. )

        IF !( Type( "aRotina" ) == "A" )
            BREAK
        EndIF

        aAdd( aRotina , Array( 4 ) )
        nIndex     := Len( aRotina )
        aRotina[ nIndex ][1]    := OemToAnsi( "Hist. Reprovação" )
        aRotina[ nIndex ][2]    := "StaticCall( U_MTA160MNU , SC8HistReprova )"
        aRotina[ nIndex ][3]    := 0
        aRotina[ nIndex ][4]    := 2

        IF ( lUMata160 )    //Altera a Descricao para Aprovar/Reprovar
            nPosOpc    := aScan( aRotina , { |aOpc| ( Upper( AllTrim( aOpc[1] ) ) == "ANALISAR" ) } )
            IF .NOT.( nPosOpc > 0 )
                BREAK
            EndIF
            aRotina[nPosOpc][1] := "Aprovar/Reprovar"
        EndIF    

    END SEQUENCE

Return( NIL )

/*/
    Funcao:        SC8HistReprova
    Autor:        Marinaldo de Jesus
    Data:        04/05/2011
    Descricao:    Apresenta o Historico de Recusa de Cotacao
/*/
Static Function SC8HistReprova()

    Local aFixe                := {}
    Local aArea                := GetArea()
    Local aSC8Area            := SC8->( GetArea() )
    
    Local cExprFilTop

    Local nFixe                := 0
    Local nIndex            := 0
    Local nSZ6Order            := RetOrder( "SZ6" , "Z6_FILIAL+Z6_NUMSC8" )

    Private aRotina            := {}
    
    Private aGets
    Private aTela
    
    Private cCadastro        := "Histórico de Recusa de Cotação"

    aAdd( aRotina , Array( 4 ) )
    nIndex     := Len( aRotina )
    aRotina[ nIndex ][1]    := "Pesquisar"
    aRotina[ nIndex ][2]    := "PesqBrw"
    aRotina[ nIndex ][3]    := 0
    aRotina[ nIndex ][4]    := 1

    aAdd( aRotina , Array( 4 ) )
    nIndex     := Len( aRotina )
    aRotina[ nIndex ][1]    := "Visualizar"
    aRotina[ nIndex ][2]    := "AxVisual"
    aRotina[ nIndex ][3]    := 0
    aRotina[ nIndex ][4]    := 2

    SZ6->( dbSetOrder( nSZ6Order ) )

    cExprFilTop     := "Z6_NUMSC8='" + SC8->C8_NUM + "' AND Z6_HRECCOT='T'"
    cNDJSC8FMbr        := StaticCall( NDJLIB001 , GetSetMbFilter , cExprFilTop )

    SetMBTopFilter( "SC8" , ""  )
    SetMBTopFilter( "SZ6" , cExprFilTop , .F. )

    aAdd( aFixe , Array( 6 ) )
    nFixe := Len( aFixe )
    aFixe[nFixe][1] := GetSx3Cache( "Z6_NUMSC8" , "X3_TITULO"  )
    aFixe[nFixe][2] := "Z6_NUMSC8"
    aFixe[nFixe][3] := GetSx3Cache( "Z6_NUMSC8" , "X3_TIPO"    )
    aFixe[nFixe][4] := GetSx3Cache( "Z6_NUMSC8" , "X3_TAMANHO" )
    aFixe[nFixe][5] := GetSx3Cache( "Z6_NUMSC8" , "X3_DECIMAL" )
    aFixe[nFixe][6] := GetSx3Cache( "Z6_NUMSC8" , "X3_PICTURE" )

    aAdd( aFixe , Array( 6 ) )
    nFixe := Len( aFixe )
    aFixe[nFixe][1] := GetSx3Cache( "Z6_ITEMSC8" , "X3_TITULO"  )
    aFixe[nFixe][2] := "Z6_ITEMSC8"
    aFixe[nFixe][3] := GetSx3Cache( "Z6_ITEMSC8" , "X3_TIPO"    )
    aFixe[nFixe][4] := GetSx3Cache( "Z6_ITEMSC8" , "X3_TAMANHO" )
    aFixe[nFixe][5] := GetSx3Cache( "Z6_ITEMSC8" , "X3_DECIMAL" )
    aFixe[nFixe][6] := GetSx3Cache( "Z6_ITEMSC8" , "X3_PICTURE" )

    aAdd( aFixe , Array( 6 ) )
    nFixe := Len( aFixe )
    aFixe[nFixe][1] := GetSx3Cache( "Z6_FORSC8" , "X3_TITULO"  )
    aFixe[nFixe][2] := "Z6_FORSC8"
    aFixe[nFixe][3] := GetSx3Cache( "Z6_FORSC8" , "X3_TIPO"    )
    aFixe[nFixe][4] := GetSx3Cache( "Z6_FORSC8" , "X3_TAMANHO" )
    aFixe[nFixe][5] := GetSx3Cache( "Z6_FORSC8" , "X3_DECIMAL" )
    aFixe[nFixe][6] := GetSx3Cache( "Z6_FORSC8" , "X3_PICTURE" )

    aAdd( aFixe , Array( 6 ) )
    nFixe := Len( aFixe )
    aFixe[nFixe][1] := GetSx3Cache( "Z6_LOJSC8" , "X3_TITULO"  )
    aFixe[nFixe][2] := "Z6_LOJSC8"
    aFixe[nFixe][3] := GetSx3Cache( "Z6_LOJSC8" , "X3_TIPO"    )
    aFixe[nFixe][4] := GetSx3Cache( "Z6_LOJSC8" , "X3_TAMANHO" )
    aFixe[nFixe][5] := GetSx3Cache( "Z6_LOJSC8" , "X3_DECIMAL" )
    aFixe[nFixe][6] := GetSx3Cache( "Z6_LOJSC8" , "X3_PICTURE" )

    aAdd( aFixe , Array( 6 ) )
    nFixe := Len( aFixe )
    aFixe[nFixe][1] := GetSx3Cache( "Z6_HRECCOT" , "X3_TITULO"  )
    aFixe[nFixe][2] := "Z6_HRECCOT"
    aFixe[nFixe][3] := GetSx3Cache( "Z6_HRECCOT" , "X3_TIPO"    )
    aFixe[nFixe][4] := GetSx3Cache( "Z6_HRECCOT" , "X3_TAMANHO" )
    aFixe[nFixe][5] := GetSx3Cache( "Z6_HRECCOT" , "X3_DECIMAL" )
    aFixe[nFixe][6] := GetSx3Cache( "Z6_HRECCOT" , "X3_PICTURE" )

    aAdd( aFixe , Array( 6 ) )
    nFixe := Len( aFixe )
    aFixe[nFixe][1] := GetSx3Cache( "Z6_NUMSC" , "X3_TITULO"  )
    aFixe[nFixe][2] := "Z6_NUMSC"
    aFixe[nFixe][3] := GetSx3Cache( "Z6_NUMSC" , "X3_TIPO"    )
    aFixe[nFixe][4] := GetSx3Cache( "Z6_NUMSC" , "X3_TAMANHO" )
    aFixe[nFixe][5] := GetSx3Cache( "Z6_NUMSC" , "X3_DECIMAL" )
    aFixe[nFixe][6] := GetSx3Cache( "Z6_NUMSC" , "X3_PICTURE" )

    aAdd( aFixe , Array( 6 ) )
    nFixe := Len( aFixe )
    aFixe[nFixe][1] := GetSx3Cache( "Z6_ITEMSC" , "X3_TITULO"  )
    aFixe[nFixe][2] := "Z6_ITEMSC"
    aFixe[nFixe][3] := GetSx3Cache( "Z6_ITEMSC" , "X3_TIPO"    )
    aFixe[nFixe][4] := GetSx3Cache( "Z6_ITEMSC" , "X3_TAMANHO" )
    aFixe[nFixe][5] := GetSx3Cache( "Z6_ITEMSC" , "X3_DECIMAL" )
    aFixe[nFixe][6] := GetSx3Cache( "Z6_ITEMSC" , "X3_PICTURE" )

    aAdd( aFixe , Array( 6 ) )
    nFixe := Len( aFixe )
    aFixe[nFixe][1] := GetSx3Cache( "Z6_USER" , "X3_TITULO"  )
    aFixe[nFixe][2] := "Z6_USER"
    aFixe[nFixe][3] := GetSx3Cache( "Z6_USER" , "X3_TIPO"       )
    aFixe[nFixe][4] := GetSx3Cache( "Z6_USER" , "X3_TAMANHO" )
    aFixe[nFixe][5] := GetSx3Cache( "Z6_USER" , "X3_DECIMAL" )
    aFixe[nFixe][6] := GetSx3Cache( "Z6_USER" , "X3_PICTURE" )

    aAdd( aFixe , Array( 6 ) )
    nFixe := Len( aFixe )
    aFixe[nFixe][1] := GetSx3Cache( "Z6_DUSER" , "X3_TITULO"  )
    aFixe[nFixe][2] := "Z6_DUSER"
    aFixe[nFixe][3] := GetSx3Cache( "Z6_DUSER" , "X3_TIPO"    )
    aFixe[nFixe][4] := GetSx3Cache( "Z6_DUSER" , "X3_TAMANHO" )
    aFixe[nFixe][5] := GetSx3Cache( "Z6_DUSER" , "X3_DECIMAL" )
    aFixe[nFixe][6] := GetSx3Cache( "Z6_DUSER" , "X3_PICTURE" )

    aAdd( aFixe , Array( 6 ) )
    nFixe := Len( aFixe )
    aFixe[nFixe][1] := GetSx3Cache( "Z6_DATA" , "X3_TITULO"  )
    aFixe[nFixe][2] := "Z6_DATA"
    aFixe[nFixe][3] := GetSx3Cache( "Z6_DATA" , "X3_TIPO"       )
    aFixe[nFixe][4] := GetSx3Cache( "Z6_DATA" , "X3_TAMANHO" )
    aFixe[nFixe][5] := GetSx3Cache( "Z6_DATA" , "X3_DECIMAL" )
    aFixe[nFixe][6] := GetSx3Cache( "Z6_DATA" , "X3_PICTURE" )

    aAdd( aFixe , Array( 6 ) )
    nFixe := Len( aFixe )
    aFixe[nFixe][1] := GetSx3Cache( "Z6_HORA" , "X3_TITULO"  )
    aFixe[nFixe][2] := "Z6_HORA"
    aFixe[nFixe][3] := GetSx3Cache( "Z6_HORA" , "X3_TIPO"       )
    aFixe[nFixe][4] := GetSx3Cache( "Z6_HORA" , "X3_TAMANHO" )
    aFixe[nFixe][5] := GetSx3Cache( "Z6_HORA" , "X3_DECIMAL" )
    aFixe[nFixe][6] := GetSx3Cache( "Z6_HORA" , "X3_PICTURE" )

    aAdd( aFixe , Array( 6 ) )
    nFixe := Len( aFixe )
    aFixe[nFixe][1] := GetSx3Cache( "Z6_OBS" , "X3_TITULO"  )
    aFixe[nFixe][2] := "Z6_OBS"
    aFixe[nFixe][3] := GetSx3Cache( "Z6_OBS" , "X3_TIPO"      )
    aFixe[nFixe][4] := GetSx3Cache( "Z6_OBS" , "X3_TAMANHO" )
    aFixe[nFixe][5] := GetSx3Cache( "Z6_OBS" , "X3_DECIMAL" )
    aFixe[nFixe][6] := GetSx3Cache( "Z6_OBS" , "X3_PICTURE" )

    mBrowse( 6 , 1 , 22 , 75 , "SZ6" , @aFixe , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , @cExprFilTop )

    CursorWait()

    MbrRstFilter()    

    IF ( Type( "bFiltraBrw" ) == "B" )
        IF ( "SC8" $ GetCbSource( bFiltraBrw ) )
            Eval( bFiltraBrw )
        EndIF
    EndIF

    RestArea( aSC8Area )
    RestArea( aArea )

    CursorArrow()

Return( NIL )

/*/
    Funcao:        MbrRstFilter
    Autor:        Marinaldo de Jesus
    Data:        15/03/2011
    Descricao:    Restaura o Filtro de Browse
/*/
Static Function MbrRstFilter()
Return( StaticCall( NDJLIB001 , MbrRstFilter , "SC8" , "cNDJSC8FMbr" ) )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        SC8HistReprova()
        MbrRstFilter()
        lRecursa    := __Dummy( .F. )
        __cCRLF        := NIL
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
