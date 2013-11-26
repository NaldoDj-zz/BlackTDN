#INCLUDE "NDJ.CH"
/*/
	Programa:	U_MT097APR
	Autor:		Marinaldo de Jesus
	Data:		05/05/2011
	Descricao:	Ponto de Entrada MT097APR. Executado Apos a Liberacao do Pedido de Compras e no laco que percorre a SC7
                Sera utilizado para gravar campos especificos da NDJ durante o Processo de Aprovacao de Pedido
/*/
User Function MT097APR()

	Local aArea		:= GetArea()
	
	Local oException

	TRYEXCEPTION

		C7LibToC1()

	CATCHEXCEPTION USING oException

	ENDEXCEPTION

	RestArea( aArea )

Return( NIL )

/*/
	Funcao:		C7LibToC1
	Autor:		Marinaldo de Jesus
	Data:		05/05/2011
	Descricao:	Grava Informacoes Customizadas Durante o Processo de Liberacao de Pedido
/*/
Static Function C7LibToC1()

	Local aSC7Area		:= SC7->( GetArea() )
	Local aSC1Area		:= SC1->( GetArea() )
	Local aFromTo		:= {}
	
	Local cSC1Filial	:= xFilial( "SC1" )
	Local cSC1KeySeek

	Local nSC1Order		:= RetOrder( "SC1" , "C1_FILIAL+C1_NUM+C1_ITEM" )
	
	SC1->( dbSetOrder( nSC1Order ) )

	PutToFrom( @aFromTo , "C1_XDATPRF" , "C7_DATPRF" )

	cSC1KeySeek			:= cSC1Filial
	cSC1KeySeek			+= SC7->C7_NUMSC
	cSC1KeySeek			+= SC7->C7_ITEMSC

	IF SC1->( dbSeek( cSC1KeySeek , .F. ) )
        StaticCall( NDJLIB001 , NDJFromTo , "SC7" , "SC1" , @aFromTo )
	EndIF

	RestArea( aSC1Area )
	RestArea( aSC7Area )

Return( NIL )

/*/
	Funcao:		PutToFrom
	Autor:		Marinaldo de Jesus
	Data:		05/05/2011
	Descricao:	Carrega o Array de Para
/*/
Static Function PutToFrom( aFromTo, cTo , cFrom )
	aAdd( aFromTo, { cFrom , cTo } )
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