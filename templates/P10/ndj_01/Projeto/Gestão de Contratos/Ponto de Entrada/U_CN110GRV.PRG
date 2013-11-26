#INCLUDE "NDJ.CH"
/*/
	Funcao: 	CN110GRV
	Autor:		Marinaldo de Jesus
	Data:		22/12/2010
	Descricao:	Implementacao do Ponto de Entrada CN110GRV executado na CN110Grava em CNTA110
				Sera utilizado para gravar informacoes Complementares apos a Gravacao dos dados do Cronograma Financeiro
/*/
User Function CN110GRV()

	Local aStackParam

	Local cCron
	Local cContra
	Local cRevisa
	
	Local cCN9Filial

	Local nOpc		:= ParamIxb[ 1 ]

	IF (;
			( nOpc == 3 );	//Inclusao
			.or.;
			( nOpc == 4 );	//Alteracao
		)	

		//Obtenho o Conteudo das Variaveis baseado na Pilha de Chamadas
        cCron		:= StaticCall( NDJLIB006 , ReadStackParameters , Upper( "CN110Grava" ) , Upper( "cCron"   ) , NIL , NIL , @aStackParam )
        cContra		:= StaticCall( NDJLIB006 , ReadStackParameters , Upper( "CN110Grava" ) , Upper( "cContra" ) , NIL , NIL , @aStackParam )
        cRevisa		:= StaticCall( NDJLIB006 , ReadStackParameters , Upper( "CN110Grava" ) , Upper( "cRevisa" ) , NIL , NIL , @aStackParam )

		cCN9Filial	:= xFilial( "CN9" )

		//Atualiza os Valores Empenhados de Acordo com o Cronograma Financeiro
        StaticCall( U_NDJBLKSCVL , CNFToSZ0 , @nOpc , @cCN9Filial , @cContra , @cRevisa , @cCron )

	EndIF	

Return( NIL )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
    	lRecursa	:= __Dummy( .F. )
    	__cCRLF		:= NIL
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )