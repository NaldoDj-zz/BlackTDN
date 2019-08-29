#INCLUDE "NDJ.CH"
/*/
    Funcao:        MA140BUT
    Data:        03/12/2010
    Autor:        Marinaldo de Jesus
    Descricao:    Ponto de Entrada executado no progama MATA140.
                Sera utilizado incluir novo botao na EnchoiceBar das PN (Pre-Notas) de forma a:
                1 ) Permitir a consulta aos valores Orcados/Empenhados
                2 ) Possibilitar obter informacoes do Projeto NDJ para a Pre-Nota
/*/
User Function MA140BUT()

    Local aMyBtns    := U_MA103BUT()    //consulta aos valores Orcados/Empenhados

    Local oException

    TRYEXCEPTION

        IF IsInCallStack( "NDJPreNFA" )
            //Informacoes sobre o Projeto
            aAdd( aMyBtns , { "NDJ_PROJETO_INFO" , { || NDJInfoPrj() } , OemToAnsi( "Informações do Projeto" ) , "Info.Proj." } )
        EndIF    

    CATCHEXCEPTION oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , FunName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION    

Return( aMyBtns )

/*/
    Funcao:        NDJInfoPrj
    Data:        20/12/2010
    Autor:        Marinaldo de Jesus
    Descricao:    Retorna a Consulta Padrao ao Projeto NDJ e Atualiza Resultados.
/*/
Static Function NDJInfoPrj()

    Local cF3PreNFA
    Local cException
    
    Local oException

    TRYEXCEPTION

        cF3PreNFA    := GetNewPar( "NDJ_F3PNFA" , "NDJPRJ" )

        IF !( StaticCall( NDJLIB001 , NDJEvalF3 , cF3PreNFA , .F. , @cException ) )
            UserException( cException )
        EndIF

        //Limpar o Codigo do Produto Forcando a Redigitacao
        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "D1_COD" );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "D1_COD" ) );
            )
            GdFieldPut( "D1_COD" , Space( GetSX3Cache( "D1_COD" , "X3_TAMANHO" ) ) )
        ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "D1_COD" ) )
            StaticCall( NDJLIB001 , SetMemVar , "D1_COD" , Space( GetSX3Cache( "D1_COD" , "X3_TAMANHO" ) ) )
        EndIF

    CATCHEXCEPTION oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
            ConOut( CaptureError() )
        EndIF

    ENDEXCEPTION

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
