#INCLUDE "NDJ.CH"
/*/
	Progama:	QIEIMPRL
	Data:	    25/01/2011
	Autor:		Marinaldo de Jesus
	Descricao:	Implementacao do Ponto de Entrada QIEIMPRL, originalmente definido pra a integracao com o SIGAQIE, para gravar a vinculacao dos
				Documentos de Entrada com os Projetos do PMS.
/*/
User Function QIEIMPRL()

	Local aArea			:= GetArea()
	Local aSF1Area		:= SF1->( GetArea() )
	Local aStackPrm

	Local cLoja
	Local cTipo
	Local cSerie
	Local cNFiscal
	Local cA100For

	Local lDeleta

	Local nOper			:= ParamIxb[ 1 ]	//1-Add;2-Modify;3-Delete
	Local nRecSF1

	Local oException

	TRYEXCEPTION

        nRecSF1            := StaticCall(NDJLIB006,ReadStackParameters,"A103GRAVA","NRECSF1",NIL,NIL,@aStackPrm)
		
		IF Empty( nRecSF1 )

            cNFiscal    := StaticCall(NDJLIB006,ReadStackParameters,"A103NFISCAL","CNFISCAL",NIL,NIL,@aStackPrm)
            cSerie        := StaticCall(NDJLIB006,ReadStackParameters,"A103NFISCAL","CSERIE",NIL,NIL,@aStackPrm)
            cA100For    := StaticCall(NDJLIB006,ReadStackParameters,"A103NFISCAL","CA100FOR",NIL,NIL,@aStackPrm)
            cLoja        := StaticCall(NDJLIB006,ReadStackParameters,"A103NFISCAL","CLOJA",NIL,NIL,@aStackPrm)
            cTipo        := StaticCall(NDJLIB006,ReadStackParameters,"A103NFISCAL","CTIPO",NIL,NIL,@aStackPrm)

		Else
		
			SF1->( MsGoto( nRecSF1 ) )  
			
			cNFiscal	:= SF1->F1_DOC
			cSerie		:= SF1->F1_SERIE
			cA100For	:= SF1->F1_FORNECE
			cLoja		:= SF1->F1_LOJA
			cTipo		:= SF1->F1_TIPO
		
		EndIF

        lDeleta        := StaticCall(NDJLIB006,ReadStackParameters,"A103GRAVA","LDELETA",NIL,NIL,@aStackPrm)
		IF !( lDeleta )
			lDeleta	:= ( nOper == 3 )
		EndIF	

		StaticCall( U_SD1ToAFN , SD1ToAFN , @nRecSF1 , @cNFiscal , @cSerie , @cA100For , @cLoja , @cTipo , @lDeleta )
	
	CATCHEXCEPTION USING oException

		IF ( ValType( "oException" ) == "O" )
			ConOut( oException:Description )
		EndIF

	ENDEXCEPTION

	RestArea( aSF1Area )
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