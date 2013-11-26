#INCLUDE "NDJ.CH"
/*/
	Funcao:		MT120FIM
	Data:		03/12/2010
	Autor:		Marinaldo de Jesus
	Descricao:	Ponto de Entrada executado no progama MATA120.
				- Sera utilizado para:
				1 ) Forcar o Commit das Alteracoes de Destinos
				2 ) Forcar o Commit das Alteracoes de Empenho
				
/*/
User Function MT120FIM()

	Local nOpc			:= ParamIxb[1]
	Local cA120Num		:= ParamIxb[2]
	Local nOpcA			:= ParamIxb[3]

	Local cSC7Filial	:= xFilial( "SC7" )
	Local cSC7KeySeek	:= ( cSC7Filial + cA120Num )

	Local nSC7Order		:= RetOrder( "SC7" , "C7_FILIAL+C7_NUM+C7_ITEM" )

	Local nRecno
	Local nRecnos

	Local oException

	TRYEXCEPTION

		SC7->( dbSetOrder( nSC7Order ) )
		SC7->( dbSeek( cSC7KeySeek ) )
		While SC7->( !Eof() .and. C7_FILIAL+C7_NUM == cSC7KeySeek )
            SC7->( StaticCall( NDJLIB003 , LockSoft , "SC7" ) )
			SC7->( dbSkip() )
		End While

		//Forca o Commit das Alteracoes de Destinos
        StaticCall( U_NDJA001 , SZ2SZ3Commit )

		//Forca o Commit das Alteracoes de Destinos
        StaticCall( U_NDJA002 , SZ4SZ5Commit )

		//Forca o Commit das Alteracoes de Empenho
        StaticCall( U_NDJBLKSCVL , SZ0TTSCommit )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			ConOut( oException:Description , oException:ErrorStack )
		EndIF

	ENDEXCEPTION

    StaticCall( NDJLIB003 , AliasUnLock )

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