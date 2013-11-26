#INCLUDE "NDJ.CH"
/*/
	Funcao:		MTA120G2
	Data:		03/12/2010
	Autor:		Marinaldo de Jesus
	Descricao:	Ponto de Entrada executado em A120Grava no progama MATA120.
				Sera utilizado para gravacao de informacoes complementares no SC7
				
/*/
User Function MTA120G2()

	Local aArea			:= GetArea()
	Local aSC7Area		:= SC7->( GetArea() )

	Local cSC7Filial
	Local cSC7NumPc
	Local cSC7SeqPc
	Local cSC7ItemPc
	Local cSC7XProp1
	Local cSC7XEquipa
	Local cSC7KeySeek
	Local cNewSC7Alias	

	Local lFound
	Local lExecute		:= .F.
	Local lCN120GrvPeD	:= IsInCallStack( "CN120GrvPeD" )
	
	Local nSC7Recno
	Local nSC7Order		
	
	Local oException
	
	TRYEXCEPTION

        cSC7NumPc    := StaticCall( NDJLIB001 , __FieldGet , "SC7" , "C7_XNUMPC"  , .T. )
		lExecute	:= ( lCN120GrvPeD .and. !Empty( cSC7NumPc ) )
		IF !( lExecute )
			BREAK
		EndIF
		
		cNewSC7Alias	:= GetNextAlias()
		IF !( ChkFile( "SC7" , .F. , cNewSC7Alias ) )
			BREAK	
		EndIF

        cSC7Filial    := StaticCall( NDJLIB001 , __FieldGet , "SC7" , "C7_FILIAL"  , .T. )
        cSC7ItemPc    := StaticCall( NDJLIB001 , __FieldGet , "SC7" , "C7_XITEMPC" , .T. )
        cSC7SeqPc    := StaticCall( NDJLIB001 , __FieldGet , "SC7" , "C7_XSEQPC"  , .T. )

		cSC7KeySeek	:= cSC7Filial
		cSC7KeySeek	+= cSC7NumPc
		cSC7KeySeek	+= cSC7ItemPc
		cSC7KeySeek	+= cSC7SeqPc

		nSC7Order	:= RetOrder( "SC7" , "C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN" )

		( cNewSC7Alias )->( dbSetOrder( nSC7Order ) )
		
		lFound		:= ( cNewSC7Alias )->( dbSeek( cSC7KeySeek , .F. ) )

		IF ( lFound )
			nSC7Recno	:= ( cNewSC7Alias )->( Recno() )
            cSC7XProp1    := StaticCall( NDJLIB001 , __FieldGet , cNewSC7Alias , "C7_XPROP1"   , .T. )
            cSC7XEquipa    := StaticCall( NDJLIB001 , __FieldGet , cNewSC7Alias , "C7_XEQUIPA"  , .T. )
            StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_XEQUIPA" , cSC7XEquipa , .T. )
            StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_XPROP1"  , cSC7XProp1  , .T. )
			SC7->( MsGoto( nSC7Recno ) )
			IF SC7->( !Eof() .and. !Bof() )
                StaticCall( U_NDJBLKSCVL , AliasSZ0Lnk , "SC7" )    //Verifica os Links do SC7 com o SZ0
			EndIF	
		EndIF

		( cNewSC7Alias )->( dbCloseArea() )

		//Forca o Commit das Alteracoes de Destinos
        StaticCall( U_NDJA002 , SZ4SZ5Commit )

		//Forca o Commit das Alteracoes de Empenho
        StaticCall( U_NDJBLKSCVL , SZ0TTSCommit )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			ConOut( oException:Description , oException:ErrorStack )
		EndIF

	ENDEXCEPTION

	RestArea( aSC7Area )
	RestArea( aArea )

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