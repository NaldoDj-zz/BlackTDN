#INCLUDE "NDJ.CH"
/*/
	Funcao:		M110EXIT
	Data:		28/11/2010
	Autor:		Marinaldo de Jesus
	Descricao:	Ponto de Entrada executando apos clicar no botao Sair ou no (x) do Dialog da Solicitacao de Compras
				Sera utilizado para remover os vinculos entre a SZ0 e SZ3/SZ2 quando esses nao forem efetivados pela confirmacao
/*/
User Function M110EXIT()

	Local aArea			:= GetArea()
	Local aRecno		:= {}

	Local lExistOk		:= .T.
	Local lFT340Grv		:= .F.
		
	Local oException

	TRYEXCEPTION

        StaticCall( U_NDJBLKSCVL , AliasSZ0Lnk , "SC1" , .F. )    //Verifica os Links do SC1 com o SZ0

        StaticCall( U_NDJA001 , SZ2SZ3Commit )                    //Forca o Commit dos Destinos da SC1
        StaticCall( U_NDJA001 , SC1LinkSZ2 , .F. )                //Verifica os Links do SC1 com o SZ2

        StaticCall( U_NDJBLKSCVL , SZ0TTSCommit )                //Forca o Commit das Alteracoes de Empenho

		IF (;
				( Type( "INCLUI" ) == "L" );
				.and.;
				( INCLUI );
			)
			StaticCall( U_FT340MNU , LinkedFile )															//Garanto o Posicionamento no Documento a Ser Excluido
            StaticCall( NDJLIB001 , SetMemVar , "ACB_CODOBJ" , ACB->ACB_CODOBJ , .T. , .T. )                //Carrega a Variavel de Memoria com o Conteudo do Campo
            StaticCall( NDJLIB001 , SetMemVar , "ACB_OBJETO" , AllTrim( ACB->ACB_OBJETO ) , .T. , .T. )    //Carrega a Variavel de Memoria com o Conteudo do Campo
			IF ACB->( !Eof() .and. !Bof() )
				lFT340Grv := .T.
				StaticCall( U_FT340GRV , DocSc1ToAC9 , 3 , cA110Num )											//Exclui o Relacionamento na AC9
				FT340Grv( 3 , @aRecno )																			//Exclui o Documento
				StaticCall( U_FT340GRV , FT340Commit )
			EndIF
		EndIF

	CATCHEXCEPTION USING oException

		IF ( lFT340Grv )
			StaticCall( U_FT340GRV , FT340Commit )
		EndIF

		IF ( ValType( oException ) == "O" )
			ConOut( oException:Description , oException:ErrorStack )
		EndIF	
	
	ENDEXCEPTION

	RestArea( aArea )

Return( lExistOk )

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