#INCLUDE "PROTHEUS.CH"
#INCLUDE "TRYEXCEPTION.CH"
/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Programa  ³U_CHKRDZREL³Autor³Marinaldo de Jesus	           ³Data  ³18/01/2010³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descricoes³Ponto de Entrada U_CHKRDZREL                         				 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³SINAF - Verificar Relacionamento entre RD0 e Entidades Quando RD0 com³
³          ³partilhado entre empresas											 ³
ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³            ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL                    ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Programador ³Data      ³Nro. Ocorr.³Motivo da Alteracao                         ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³            ³          ³           ³                    						 ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
User Function ChkRdzRel()

	Local aArea			:= GetArea()
	Local aAreaRDZ		:= RDZ->( GetArea() )
	Local nRDZOrder 	:= RetOrder("RDZ","RDZ_FILIAL+RDZ_CODRD0")
	
	Local lChange		:= .F.
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
				lChange 	:= .T.
			EndIF
		EndIF
		
	CATCHEXCEPTION USING oException
	
		lChange := .F.
	
	ENDEXCEPTION

	RestArea( aAreaRDZ )
	RestArea( aArea )

Return( lChange )