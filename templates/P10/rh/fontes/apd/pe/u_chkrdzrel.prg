#INCLUDE "PROTHEUS.CH"
#INCLUDE "TRYEXCEPTION.CH"
/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
?rograma  ?_CHKRDZREL?utor?arinaldo de Jesus               ?ata  ?8/01/2010?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
?escricoes?onto de Entrada U_CHKRDZREL                                          ?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
?so       ?INAF - Verificar Relacionamento entre RD0 e Entidades Quando RD0 com?
?         ?artilhado entre empresas                                             ?
ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
?           ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL                    ?
ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
?rogramador ?ata      ?ro. Ocorr.?otivo da Alteracao                         ?
ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
?           ?         ?          ?                                            ?
ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
User Function ChkRdzRel()

    Local aArea            := GetArea()
    Local aAreaRDZ        := RDZ->( GetArea() )
    Local nRDZOrder     := RetOrder("RDZ","RDZ_FILIAL+RDZ_CODRD0")
    
    Local lChange        := .F.
    Local oException
    
    Static cLastEmpFil

    TRYEXCEPTION

        RDZ->( dbSetOrder( nRDZOrder) )

        IF ( PARAMIXB[1] == "INIT" )
            IF RDZ->( dbSeek( xFilial( "RDZ" ) + GetMemVar(  "RD0_CODIGO" ) ) )
                IF ( RDZ->RDZ_EMPENT <> cEmpAnt )
                    cLastEmpFil := ( cEmpAnt +  cFilAnt )
                    RDZ->( GetEmpr( RDZ_EMPENT + RDZ_FILENT ) )
                    lChange := .T.
                EndIF
            EndIF
        ElseIF (;
                    ( PARAMIXB[1] == "END" );
                    .and.;
                    ( PARAMIXB[2] );
                )    
            IF (;
                    ( cLastEmpFil <> NIL );
                    .and.;
                    !( cLastEmpFil == ( cEmpAnt + cFilAnt ) );
                )    
                GetEmpr( cLastEmpFil )
                cLastEmpFil := NIL
                lChange     := .T.
            EndIF
        EndIF
        
    CATCHEXCEPTION USING oException
    
        lChange := .F.
    
    ENDEXCEPTION

    RestArea( aAreaRDZ )
    RestArea( aArea )

Return( lChange )
