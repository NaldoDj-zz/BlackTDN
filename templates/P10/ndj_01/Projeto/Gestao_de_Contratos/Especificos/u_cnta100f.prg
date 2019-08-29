#INCLUDE "NDJ.CH"
/*/
    Function:    U_CNTA100F
    Autor:        Marinaldo de Jesus
    Data:        05/01/2011
    Descricao:    Cadastro de Fornecedores/Contratos
    Sintaxe:    U_CNTA100F
/*/
User Function CNTA100F()

    Local aArea             := GetArea()
    Local aSA2Area            := SA2->( GetArea() )
    Local aCNCArea            := CNC->( GetArea() )
    Local aCN9Area            := CN9->( GetArea() )

    Local cExprFilTop        := ""

    BEGIN SEQUENCE

        Private aRotina        := {;
                                    { "Pesquisar"    , "PesqBrw"                                                        , 0 , 01 } ,;
                                    { "Contratos"    , "StaticCall(U_CNTA100F,CNTA100CNC,'SA2',SA2->(Recno()),2)"    , 0 , 02 }  ;
                                }

        Private aTela        := {}
        Private aGets        := {}

        Private cCadastro    := OemToAnsi( "Cadastro de Fornecedores vs Contratos" )

        cExprFilTop    := "A2_COD+A2_LOJA "
        cExprFilTop    += "IN "
        cExprFilTop    += "("
        cExprFilTop    +=    "SELECT DISTINCT "
        cExprFilTop    +=         "SA2.A2_COD+SA2.A2_LOJA "
        cExprFilTop    +=     "FROM "
        cExprFilTop    +=         RetSqlName( "SA2" ) + " SA2, "
        cExprFilTop    +=         RetSqlName( "CNC" ) + " CNC, "
        cExprFilTop    +=         RetSqlName( "CN9" ) + " CN9 "
        cExprFilTop    +=     "WHERE "
        cExprFilTop    +=         "SA2.D_E_L_E_T_<>'*'"
        cExprFilTop    +=     " AND "
        cExprFilTop    +=         "CNC.D_E_L_E_T_<>'*'"
        cExprFilTop    +=     " AND "
        cExprFilTop    +=         "CN9.D_E_L_E_T_<>'*'"
        cExprFilTop    +=     " AND "
        cExprFilTop    +=         "SA2.A2_FILIAL = '" + xFilial( "SA2" ) + "'"
        cExprFilTop    +=     " AND "
        cExprFilTop    +=         "CNC.CNC_FILIAL = '" + xFilial( "CNC" ) + "'"
        cExprFilTop    +=     " AND "
        cExprFilTop    +=         "CN9.CN9_FILIAL = '" + xFilial( "CN9" ) + "'"
        cExprFilTop    +=     " AND "
        cExprFilTop    +=         "SA2.A2_COD = CNC.CNC_CODIGO"
        cExprFilTop    +=     " AND "
        cExprFilTop    +=         "SA2.A2_LOJA = CNC.CNC_LOJA"
        cExprFilTop    +=     " AND "
        cExprFilTop    +=         "CNC.CNC_NUMERO = CN9.CN9_NUMERO"
        cExprFilTop    += ")"

        dbSelectArea( "SA2" )

        MBrowse( 6 , 1 , 22 , 75 , "SA2" , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , cExprFilTop )

    END SEQUENCE

    RestArea( aCNCArea )
    RestArea( aCN9Area )
    RestArea( aSA2Area )
    RestArea( aArea )

Return( NIL )

/*/
    Function:    CNTA100CNC
    Autor:        Marinaldo de Jesus
    Data:        05/01/2011
    Descricao:    Chamada a Rotina de Contrato
    Sintaxe:    StaticCall(U_CNTA100F,CNTA100CNC,cAlias,nReg,nOpc)
/*/
Static Function CNTA100CNC( cAlias , nReg , nOpc )

    Local aArea            := GetArea()
    Local aIndex        := {}
    Local aSA2Area        := SA2->( GetArea() )

    Local cFiltra
    Local cCNCAlias            := "CNC"
    Local cCNCKeySeek

    Local lFound

    Local nCNCOrder            := RetOrder( cCNCAlias , "CNC_FILIAL+CNC_CODIGO+CNC_LOJA+CNC_NUMERO" )

    Local oException

    Local uRet
    
    TRYEXCEPTION
    
        SA2->( MsGoto( nReg ) )

        cCNCKeySeek            := xFilial( "CNC" , SA2->A2_FILIAL )
        cCNCKeySeek            += SA2->A2_COD
        cCNCKeySeek            += SA2->A2_LOJA

        CNC->( dbSetOrder( nCNCOrder ) )

        lFound                := CNC->( dbSeek( cCNCKeySeek , .F. ) )
        IF !( lFound )
            UserException( "Não Existe Contrato Vinculado à Esse Fornecedor. " )
        EndIF

        cFiltra                := SA2->( "@CNC_CODIGO='"+A2_COD+"' AND CNC_LOJA='"+A2_LOJA+"'" )

        Private aRotina        := {;
                                    { "Pesquisar"    , "PesqBrw"                                                        , 0 , 01 } ,;
                                    { "Contrato"    , "StaticCall(U_CNTA100F,CNTA100CN9,'CNC',CNC->(Recno()),2)"    , 0 , 02 }  ;
                                }

        Private aTela        := {}
        Private aGets        := {}
        Private bFiltraBrw    := { || FilBrowse( "CNC" , @aIndex , @cFiltra ) }

        dbSelectArea( "CNC" )

        aIndex    := {}
        CNC->( Eval( bFiltraBrw ) )

            mBrowse( 6 , 1 , 22 , 75 , "CNC" )

        EndFilBrw( "CNC" , @aIndex )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
            ConOut( CaptureError() )
        EndIF

    ENDEXCEPTION

    RestArea( aArea )
    RestArea( aSA2Area )

Return( uRet )

/*/
    Funcao:        CNTA100CN9
    Autor:        Marinaldo de Jesus
    Data:        05/11/2011
    Descricao:    Chamada aa Funcao de Manutencao de Contratos Padrao
/*/
Static Function CNTA100CN9( cAlias , nReg , nOpc ) 

    Local aArea            := GetArea()
    Local aIndex        := {}
    Local aCNCArea        := CNC->( GetArea() )
    Local aModuloReSet    := SetModulo( "SIGAGCT" , "GCT" )
    
    Local bSvFilBrw        := bFiltraBrw
    
    Local cCN9Filter    := ""
    Local cCN9Alias        := "CN9"
    Local cCN9KeySeek
    Local cSvExprFilTop

    Local nCN9Reg
    Local nCN9Order        := RetOrder( cCN9Alias , "CN9_FILIAL+CN9_NUMERO+CN9_REVISA" )

    Local uRet

    EndFilBrw( "CNC" , @aIndex )

    TRYEXCEPTION

        CNC->( MsGoto( nReg ) )
        IF CNC->( Eof() .or. Bof() )
            UserException( "Contrato Não Localizado. " + CRLF + CRLF + "Entre em Contato com o Administrador do Sistema" )        
        EndIF
        
        cCN9KeySeek            := xFilial( "CN9" , CNC->CNC_FILIAL )
        cCN9KeySeek            += CNC->CNC_NUMERO

        CN9->( dbSetOrder( nCN9Order ) )
        lFound                := CN9->( dbSeek( cCN9KeySeek , .F. ) )

        IF !( lFound )
            UserException( "Contrato Não Localizado. " + CRLF + CRLF + "Entre em Contato com o Administrador do Sistema" )
        EndIF

        nCN9Reg                := CN9->( Recno() )

        cCN9Filter            := "CN9_NUMERO='" + CN9->CN9_NUMERO + "'" 

        CNTA100Filter( cCN9Filter )

        cSvExprFilTop := StaticCall( NDJLIB001 , GetSetMbFilter , cCN9Filter )

        SetMBTopFilter( "CNC" , ""  )
        SetMBTopFilter( "CN9" , cCN9Filter , .F. )

        uRet    := __Execute( "CNTA100()" , "xxxxxxxxxxxxxxxxxxxx" , "CNTA100" , AllTrim(Str(nModulo)) , "" , 1 , .T. )

        StaticCall( NDJLIB001 , GetSetMbFilter , cSvExprFilTop )

        SetMBTopFilter( "CN9" , "" )

        SetMBTopFilter( "CNC" , cSvExprFilTop )

        //Sistema Padrao nao Esta Eliminado o Filtro de Browse, Forcamos a Liberacao
        CN9->( aAdd( aIndex , { "" , IndexOrd() } ) )
        CN9->( EndFilBrw( "CN9" , aIndex ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
            ConOut( CaptureError() )
        EndIF

    ENDEXCEPTION

    CNC->( Eval( bSvFilBrw ) )

    ReSetModulo( aModuloReSet )

    RestArea( aArea )
    RestArea( aCNCArea )

Return( uRet )

/*/
    Funcao:        CNTA100Filter
    Autor:        Marinaldo de Jesus
    Data:        05/11/2011
    Descricao:    Setar o Filtro para A CN9 Contratos
    Sintaxe:    StaticCall( U_CNTA100F , CNTA100Filter , <cSetFilter>  )
/*/
Static Function CNTA100Filter( cSetFilter  )

    Local cFilter
    
    Static cCNTA100Filter
    
    DEFAULT cSetFilter    := ""
    
    cFilter            := cCNTA100Filter
    cCNTA100Filter    := cSetFilter

Return( cFilter )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        CNTA100CN9()
        CNTA100CNC()
        lRecursa := __Dummy( .F. )
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
