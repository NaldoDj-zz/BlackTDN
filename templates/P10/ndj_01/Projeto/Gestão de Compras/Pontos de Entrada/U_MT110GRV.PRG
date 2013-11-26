#INCLUDE "NDJ.CH"
/*/
	Funcao:		MT110GRV
	Data:		24/11/2010
	Autor:		Marinaldo de Jesus
	Descricao:	Ponto de Entrada Apos a Gravacao da Solicitacao de Compras
				Sera utilizado para Excluir os Registros da SZ3 e SZ2 qando
				da Exclusao de uma Solicitacao de Compras
/*/
User Function MT110GRV()

	Local lCopia		:= ParamIxb[1]
	Local lIsDeleted    := .F.

	Local nRecno		:= SC1->( Recno() )

	BEGIN SEQUENCE

		DEFAULT lCopia	:= .F.
		IF ( lCopia )	
			//..Por Enquanto nao faz nada
		EndIF

		lIsDeleted := SC1->( Deleted() )

        StaticCall( U_NDJA001 , SC1LinkSZ2 , lIsDeleted )                //Verifica os Links do SC1 com o SZ2

        StaticCall( U_NDJBLKSCVL , AliasSZ0Lnk , "SC1" , lIsDeleted )    //Verifica os Links do SC1 com o SZ0

		IF ( lIsDeleted )
			BREAK
		EndIF

		SC1->( MsGoto( nRecno ) )
        StaticCall( NDJLIB001 , __FieldPut , "SC1" , "C1_APROV"  , "1" , .T. )    //Deixa o Status Sempre como Pre-Analise

	END SEQUENCE

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