#INCLUDE "NDJ.CH"
/*/
    Function:    CN120PED
    Autor:        Marinaldo de Jesus
    Data:        25/12/2010
    Descricao:    Ponto de Entrada CN120PED. Executado na Funcao CN120GrvPeD em CNTA120
    Uso:        Implementação da gravacao dos campos especificos na Inclusao de um Pedido de Vendas via SIGAGCT
/*/
User Function CN120PED()

    Local aArea        := GetArea()
    Local aCNDArea    := CND->( GetArea() )
    Local aCNEArea    := CNE->( GetArea() )
    Local aRet        := Array( 2 )
    Local aCab        := Paramixb[1]
    Local aDet        := Paramixb[2]
    
    Local cMsgHelp
    
    Local lSC5        := .F.
    Local lSC7        := .F.

    Local oException

    TRYEXCEPTION

        lSC5    := ( aScan( aCab , { |aElem| ( "C5_" $ aElem[1] ) } ) > 0 )
        IF ( lSC5 )
            C5AddField( @aCab , @aDet )
            BREAK
        EndIF

        lSC7    := ( aScan( aCab , { |aElem| ( "C7_" $ aElem[1] ) } ) > 0 )
        IF ( lSC7 )
            C7AddField( @aCab , @aDet )
            BREAK
        EndIF

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            cMsgHelp := oException:Description
            Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            ConOut( cMsgHelp , oException:ErrorStack )
        EndIF    

    ENDEXCEPTION

    RestArea( aCNEArea )
    RestArea( aCNDArea )
    RestArea( aArea )

    aRet[1]    := aCab
    aRet[2]    := aDet 

Return( aRet )

/*/
    Function:    C7AddField
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descricao:    Adicionar campos Especificos no Array aCab e aDet para a Geracao do PC
/*/
Static Function C7AddField( aCab , aDet )

    Local aSC7Area    := SC7->( GetArea() )

    Local cDesFor
    Local cCNDFilial
    Local cCNEFilial
    Local cCNDCONTRA
    Local cCNDREVISA
    Local cCNDNUMERO
    Local cCNDNUMMED
    Local cCNEXNumSC
    Local cCNEXNumPC
    Local cCNDKeySeek
    Local cCNEKeySeek

    Local lAddNumSc        := .T.
    
    Local nC7CONTRA     := aScan( aCab , { |aElem| ( "C7_CONTRA"  $ aElem[1] ) } )
    Local nC7CONTREV    := aScan( aCab , { |aElem| ( "C7_CONTREV" $ aElem[1] ) } )
    Local nC7PLANILH    := aScan( aCab , { |aElem| ( "C7_PLANILH" $ aElem[1] ) } )
    Local nC7MEDICAO    := aScan( aCab , { |aElem| ( "C7_MEDICAO" $ aElem[1] ) } )
    Local nC7ITEMED

    Local nDet
    Local nDets
    Local nCNDOrder
    Local nCNEOrder

    BEGIN SEQUENCE

        StaticCall( NDJLIB004 , SetPublic , "__aCNERecnos" , NIL , "A" , 0 , .T. )

        IF ( nC7CONTRA == 0 )
            cCNDCONTRA    := CND->CND_CONTRA
        Else
            cCNDCONTRA    := aCab[1][nC7CONTRA][2]
        EndIF

        IF ( nC7CONTREV == 0 )
            cCNDREVISA    := CND->CND_REVISA
        Else
            cCNDREVISA    := aCab[1][nC7CONTREV][2]
        EndIF

        IF ( nC7PLANILH == 0 )
            cCNDNUMERO    := CND->CND_NUMERO
        Else
            cCNDNUMERO    := aCab[1][nC7PLANILH][2]
        EndIF

        IF ( nC7MEDICAO == 0 )
            cCNDNUMMED    := CND->CND_NUMMED
        Else
            cCNDNUMMED    := aCab[1][nC7MEDICAO][2]
        EndIF

        cCNDFilial        := xFilial( "CND" , CND->CND_FILIAL )

        nCNDOrder        := RetOrder( "CND" , "CND_FILIAL+CND_CONTRA+CND_REVISA+CND_NUMERO+CND_NUMMED" )

        CND->( dbSetOrder( nCNDOrder ) )

        cCNDKeySeek        := cCNDFilial
        cCNDKeySeek        += cCNDCONTRA
        cCNDKeySeek        += cCNDREVISA
        cCNDKeySeek        += cCNDNUMERO
        cCNDKeySeek        += cCNDNUMMED

        IF CND->( !dbSeek( cCNDKeySeek , .F. ) )
            BREAK
        EndIF

        cDesFor    := PosAlias( "SA2" , CND->(CND_FORNEC+CND_LJFORN) , NIL , "A2_NREDUZ" , RetOrder( "SA2" , "A2_FILIAL+A2_COD+A2_LOJA" ) , .F. )

         aAdd( aCab , { "C7_XDESFOR"    , cDesFor , NIL } )

        cCNEFilial        := xFilial( "CNE" , CND->CND_FILIAL )
        nCNEOrder        := RetOrder( "CNE" , "CNE_FILIAL+CNE_CONTRA+CNE_REVISA+CNE_NUMERO+CNE_NUMMED+CNE_ITEM" )

        CNE->( dbSetOrder( nCNEOrder ) )

        nDets             := Len( aDet )

        For nDet := 1 To nDets

            nC7ITEMED    := aScan( aDet[ nDet ] , { |aElem| ( "C7_ITEMED"  $ aElem[1] ) } )
            IF ( nC7ITEMED == 0 )
                Loop
            EndIF

            cCNEKeySeek        := cCNEFilial
            cCNEKeySeek        += cCNDCONTRA
            cCNEKeySeek        += cCNDREVISA
            cCNEKeySeek        += cCNDNUMERO
            cCNEKeySeek        += cCNDNUMMED
            cCNEKeySeek        += aDet[nDet][nC7ITEMED][2]
            
            IF CNE->( !dbSeek( cCNEKeySeek , .F. ) )
                Loop
            EndIF
            
            cCNEXNumSC        := AllTrim( CNE->CNE_XNUMSC )
            cCNEXNumPC        := AllTrim( CNE->CNE_XNUMPC )

            IF (;
                     ( "CNT" == SubStr( cCNEXNumSC , 1 , 3 ) );
                    .and.;
                    ( cCNEXNumSC == cCNEXNumPC );
                )
                lAddNumSc := .F.
                CNE->( aAdd( __aCNERecnos , Recno() ) )
            EndIF        

            IF ( lAddNumSc )
                aAdd( aDet[nDet] , { "C7_NUMSC"        , CNE->CNE_XNUMSC    , NIL } )
                aAdd( aDet[nDet] , { "C7_ITEMSC"    , CNE->CNE_XITMSC     , NIL } )
                aAdd( aDet[nDet] , { "C7_SEQUEN"    , CNE->CNE_XSEQPC    , NIL } )
                aAdd( aDet[nDet] , { "C7_XSZ2COD"    , CNE->CNE_XSZ2CO     , NIL } )
            EndIF    
            
            aAdd( aDet[nDet] , { "C7_XCODSBM"    , CNE->CNE_XCODSB     , NIL } )
            aAdd( aDet[nDet] , { "C7_XSBM"         , CNE->CNE_XSBM     , NIL } )
            aAdd( aDet[nDet] , { "C7_XPROJET"    , CNE->CNE_XPROJE    , NIL } ) 
            aAdd( aDet[nDet] , { "C7_XREVIS"    , CNE->CNE_XREVIS    , NIL } )
            aAdd( aDet[nDet] , { "C7_XTAREFA"    , CNE->CNE_XTAREF    , NIL } )
            aAdd( aDet[nDet] , { "C7_XCODOR"    , CNE->CNE_XCODOR    , NIL } )
            aAdd( aDet[nDet] , { "C7_CODORCA"    , CNE->CNE_XCODCA    , NIL } )
             aAdd( aDet[nDet] , { "C7_XNUMPRO"    , CNE->CNE_XNRPRO     , NIL } )
             aAdd( aDet[nDet] , { "C7_XMODALI"    , CNE->CNE_XMODAL     , NIL } )
             aAdd( aDet[nDet] , { "C7_XMARCA"    , CNE->CNE_XMARCA     , NIL } )
             aAdd( aDet[nDet] , { "C7_XMODELO"    , CNE->CNE_XMODEL     , NIL } )
              aAdd( aDet[nDet] , { "C7_XGARA"        , CNE->CNE_XGARA     , NIL } )
            aAdd( aDet[nDet] , { "C7_CC"        , CNE->CNE_XCC         , NIL } )
             aAdd( aDet[nDet] , { "C7_CONTA"        , CNE->CNE_XCONTA     , NIL } )
             aAdd( aDet[nDet] , { "C7_ITEMCTA"    , CNE->CNE_XITCTA     , NIL } )
             aAdd( aDet[nDet] , { "C7_CLVL"        , CNE->CNE_XCLVL     , NIL } )
             aAdd( aDet[nDet] , { "C7_USER"        , CNE->CNE_USERPC     , NIL } )
             aAdd( aDet[nDet] , { "C7_USERSC"    , CNE->CNE_USERSC     , NIL } )
            aAdd( aDet[nDet] , { "C7_XNUMPC"    , CNE->CNE_XNUMPC     , NIL } )
            aAdd( aDet[nDet] , { "C7_XITEMPC"    , CNE->CNE_XITMPC    , NIL } )
            aAdd( aDet[nDet] , { "C7_XSEQPC"    , CNE->CNE_XSEQPC     , NIL } )
            aAdd( aDet[nDet] , { "C7_XCODGE"    , CNE->CNE_XCODGE     , NIL } )
            aAdd( aDet[nDet] , { "C7_XVISCTB"    , CNE->CNE_XVISCT     , NIL } )
            aAdd( aDet[nDet] , { "C7_XDESFOR"    , cDesFor             , NIL } )
            aAdd( aDet[nDet] , { "C7_XINCHRS"    , Time()             , NIL } )

            /*/
                Forco a gravação das informações referente ao Contrato pois serao utilizadas no
                Ponto de Entrada: CN120PDM
            /*/
            aAdd( aDet[nDet] , { "C7_CONTRA"    , CNE->CNE_CONTRA     , NIL } )
            aAdd( aDet[nDet] , { "C7_CONTREV"    , CNE->CNE_REVISA      , NIL } )
            aAdd( aDet[nDet] , { "C7_PLANILH"    , CNE->CNE_NUMERO      , NIL } )
            aAdd( aDet[nDet] , { "C7_MEDICAO"    , CNE->CNE_NUMMED      , NIL } )
            aAdd( aDet[nDet] , { "C7_ITEMED"    , CNE->CNE_ITEM      , NIL } )

        Next nDet

    END SEQUENCE

    RestArea( aSC7Area )

Return( NIL )

/*/
    Function:    C5AddField
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descricao:    Adicionar campos Especificos no Array aCab e aDet para a Geracao do PV
/*/
Static Function C5AddField( aCab , aDet )

    Local aSC5Area    := SC5->( GetArea() )
    Local aSC6Area    := SC6->( GetArea() )

    BEGIN SEQUENCE

    END SEQUENCE

    RestArea( aSC6Area )
    RestArea( aSC5Area )

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
