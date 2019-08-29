#INCLUDE "NDJ.CH"
/*/
    Funcao:    RpcAC9ACBChk()
    Autor:    Marinaldo de Jesus
    Data:    13/04/2011
    Uso:    Chamada Via RPC para verificar os Links da AC9 com a ACB
    Sintaxe: 1 - RpcAC9ACBChk( { cEmp , cFil } )     //Chamada Direta
             2 - RpcAC9ACBChk( cEmp , cFil )         //Chamada Via Agendamento
/*/
User Function RpcAC9ACBChk( aParameters )

    Local cEmp
    Local cFil

    Local oException

    TRYEXCEPTION

        IF !Empty( aParameters )
            IF ( Len( aParameters ) > 1 )
                cEmp    := aParameters[1]
            EndIF
            IF ( Len( aParameters ) > 2 )
                cFil    := aParameters[2]
            EndIF
        EndIF
    
        DEFAULT cEmp    := "01"
        DEFAULT cFil    := "01"
        
        PREPARE ENVIRONMENT EMPRESA ( cEmp ) FILIAL ( cFil )

            AC9ACBChk()

        RESET ENVIRONMENT

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            ConOut( CaptureError() )
        EndIF

    ENDEXCEPTION

Return( NIL )

/*/
    Funcao:    AC9ACBChk()
    Autor:    Marinaldo de Jesus
    Data:    16/03/2011
    Uso:    Chamada Via RPC da Verificacao das Informacoes da Solicitacao de Compras
/*/
Static Function AC9ACBChk()

    Local cCRLF        := CRLF
    Local cQuery

    cQuery := "DELETE" + cCRLF
    cQuery += "        FROM" + cCRLF
    cQuery += "        " + RetSqlName( "AC9" ) + cCRLF
    cQuery += "WHERE" + cCRLF
    cQuery += "        NOT EXISTS" + cCRLF
    cQuery += "        (" + cCRLF
    cQuery += "            SELECT" + cCRLF
    cQuery += "            1"  + cCRLF
    cQuery += "            FROM"  + cCRLF
    cQuery += "            " + RetSqlName( "ACB" ) + " ACB " + cCRLF
    cQuery += "            WHERE" + cCRLF
    cQuery += "                ACB.ACB_CODOBJ = AC9010.AC9_CODOBJ" + cCRLF
    cQuery += "        )" + cCRLF

    cQuery := StaticCall( NDJLIB001 , ClearQuery , cQuery )

    TcSqlExec( cQuery )

Return( NIL )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        OtherdbArray()
        lRecursa    := __Dummy( .F. )
        __cCRLF        := NIL
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
