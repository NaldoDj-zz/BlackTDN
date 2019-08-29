#INCLUDE "NDJ.CH"
/*/
    Funcao:        MT110TEL
    Autor:        Marinaldo de Jesus
    Data:        09/11/2010
    Descricao:    Implementacao do Ponto de Entrada MT110TEL. Usado no MATA110 esse Ponto de Entrada Ira permitir incluir informacoes
                no Cabecalho da SC. Trabalha em conjunto com o Ponto de Entrada MT110GET.
/*/
User Function MT110TEL()
    
    Local aTGet            := StaticCall( NDJLIB016 , FindMsObject , "TGET" )
    Local aPosGet

    Local bXREFCNTVld    := { || ( __ReadVar := "M->C1_XREFCNT" , M->C1_XREFCNT := lC1XREFCNT , ( IF( !( M->C1_XREFCNT ) , dC1XDTPPAG := Ctod("//") , .T. ) , IF( CheckSX3( "C1_XREFCNT" , @lC1XREFCNT ) , ( oC1XDTPPAG:SetFocus() , .T. ) , .F. ) ) ) }
    Local bXDTPPAGVld    := { || ( __ReadVar := "M->C1_XDTPPAG" , M->C1_XDTPPAG := dC1XDTPPAG , CheckSX3( "C1_XDTPPAG" , @dC1XDTPPAG ) ) }
    
    Local bXREFCNTWhen    := { || INCLUI .and. !( M->C1_XREFCNT ) } 
    Local bXDTPPAGWhen    := { || IF( !( M->C1_XREFCNT ) , dC1XDTPPAG := Ctod("//") , .T. ) , INCLUI .and. M->C1_XREFCNT .and. Empty( M->C1_XDTPPAG ) }
    
    Local bCodComprVld
    
    Local lCodComprVld
    Local lChekSX3Compr    

    Local nAT
    Local nReg
    Local nOpcx

    Local oDlg

    Local oC1XREFCNT
    Local oC1XDTPPAG

    oDlg        := ParamIxb[1]
    aPosGet        := ParamIxb[2]
    nOpcx        := ParamIxb[3]
    nReg        := Paramixb[4]

    IF ( INCLUI )
        aRotSetOpc( "SC1" , @nReg , nOpcx )
    EndIF

    nAT            := aScan( aTGet , { |oObj| Upper( AllTrim( oObj:cReadVar ) ) == "CCODCOMPR" } )
    IF ( nAT > 0 )
        bCodComprVld    := aTGet[ nAT ]:bValid
        lCodComprVld    := ( ValType( bCodComprVld ) == "B" )
        IF !( lCodComprVld )
            TRYEXCEPTION
                lChekSX3Compr    :=     !( "CHECKSX3" $ Upper( GetCBSource( bCodComprVld ) ) )
            CATCHEXCEPTION
                lChekSX3Compr    := .T.
            ENDEXCEPTION
        EndIF
        DEFAULT lChekSX3Compr    := .T.
        IF ( !( lCodComprVld ) .or. ( lChekSX3Compr ) )
            IF ( lCodComprVld )
                aTGet[ nAT ]:bValid        := { || Eval( bCodComprVld ) .and. CheckSX3( "C1_CODCOMP" , cCodCompr ) }
            Else
                aTGet[ nAT ]:bValid        := { || CheckSX3( "C1_CODCOMP" , cCodCompr ) }
            EndIF    
        EndIF
    EndIF

    SC1->( MsGoto( nReg ) )

    StaticCall( NDJLIB004 , SetPublic , "lC1XREFCNT" , StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_XREFCNT" , .T. ) , "L" , NIL , .T. )
    StaticCall( NDJLIB004 , SetPublic , "dC1XDTPPAG" , StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_XDTPPAG" , .T. ) , "D" , NIL , .T. )

    lC1XREFCNT    := StaticCall( NDJLIB001 , SetMemVar , "C1_XREFCNT" , lC1XREFCNT , .T. , .T. , .F. , .T. , NIL , .T. )
    dC1XDTPPAG    := StaticCall( NDJLIB001 , SetMemVar , "C1_XDTPPAG" , dC1XDTPPAG , .T. , .T. , .F. , .T. , NIL , .T. )

    @ 42,aPosGet[1,1] SAY GetSx3Cache( "C1_XREFCNT" , "X3_TITULO" )                                             OF oDlg PIXEL SIZE 045,009
    @ 41,aPosGet[1,2] CHECKBOX oC1XREFCNT VAR lC1XREFCNT VALID Eval( bXREFCNTVld )    WHEN Eval( bXREFCNTWhen )    OF oDlg PIXEL SIZE 005,010

    @ 42,aPosGet[1,3] SAY GetSx3Cache( "C1_XDTPPAG" , "X3_TITULO" )                                             OF oDlg PIXEL SIZE 045,009
    @ 41,aPosGet[1,4] MSGET oC1XDTPPAG VAR dC1XDTPPAG VALID Eval( bXDTPPAGVld )     WHEN Eval( bXDTPPAGWhen )    OF oDlg PIXEL SIZE 045,010

Return( .T. )

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
