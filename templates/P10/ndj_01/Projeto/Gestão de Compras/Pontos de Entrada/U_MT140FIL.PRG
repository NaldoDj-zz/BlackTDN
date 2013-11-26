#INCLUDE "NDJ.CH"
/*/
	Funcao: MT140FIL
	Autor:	Marinaldo de Jesus
	Data:	29/01/2011
	Uso:	Executado a partir da MATA140 em MATA140.
			Sera utilizado para Verificar se a Rotina Chamadora eh a de Aprovacao de Atesto e Filtra as Informacoes da SF1.
/*/
User Function MT140FIL()

	Local cTipo
	Local cCodUser
	Local cFiltraSF1

    Local lNDJAtesto    := .F.
	Local lMata140A		:= .F.
	Local lMata140V		:= .F.
	
	Local oException

	TRYEXCEPTION

		IF !( SD1->( RddName() ) == "TOPCONN" )
			SD1->( dbCloseArea() )
			ChkFile( "SD1" )
		EndIF

        lNDJAtesto            := StaticCall( NDJLIB001 , GetMemVar , "NDJ_ATESTO" )
        DEFAULT lNDJAtesto    := .F.
        IF !( lNDJAtesto )                                    
			BREAK
		EndIF

		lMata140A			:= IsInCallStack( "U_MATA140A" )
		IF !( lMata140A )
			lMata140V		:= IsInCallStack( "U_MATA140V" )
		EndIF	

        cTipo    := StaticCall( NDJLIB001 , GetMemVar , "NDJ_ATTIPO" )
	
		IF ( Type( "cCadastro" ) == "C" )
			IF ( lMata140A )
				cCadastro += " :: ( Atesto ) "
			ElseIF ( lMata140V )
				IF ( cTipo == "S" )
					cCadastro += " :: ( Pré-Notas Atestadas ) "
				ElseIF ( cTipo == "R" )
					cCadastro += " :: ( Pré-Notas Recusadas ) "
				ElseIF ( cTipo == "A" )
					cCadastro += " :: ( Pré-Notas Aguardando Atesto ) "
				EndIF
			EndIF
		EndIF

        cCodUser    := StaticCall( NDJLIB014 , RetCodUsr )

        //Se estiver no Grupo de Administradores, Atesta qualquer Pre-Nota de acordo como parametro NDJ_ADMPNF ou NDJ_GRPPNF
        IF GetNewPar( "NDJ_ADMPNF" , .F. )
			IF (;
					PswUsrGrp( cCodUser , "000000" );
					.or.;
                    PswUsrGrp( cCodUser , GetNewPar( "NDJ_GRPPNF" , "@@@@@@" ) );
				)	
				cFiltraSF1	:= "F1_XATESTO='"+ cTipo + "'"
				BREAK
			EndIF
		EndIF

		//Caso Contrario, Apenas as Pre-Notas do Projeto a que pertence ou que estejam no Programa ao qual Faz Parte
		cFiltraSF1	:= "F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO"
		cFiltraSF1	+= FilterAtesto( @cCodUser , @cTipo )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			ConOut( oException:Description , oException:ErrorStack )
		EndIF

	ENDEXCEPTION

Return( cFiltraSF1 )

/*/
	Funcao: 	FilterAtesto
	Autor:		Marinaldo de Jesus
	Data:		29/01/2011
	Uso:		Retorna o Filtro para obtencao dos Registros da Tabela SF1 a Serem Atestados conforme Codigo do Usuario
	Sintaxe:    (1) FilterAtesto( cCodUser , cTipo , lAddProjet , lRmvCRLF )
				(2) StaticCall( U_MT140FIL , FilterAtesto , cCodUser , cTipo , lAddProjet , lRmvCRLF )
/*/
Static Function FilterAtesto( cCodUser , cTipo , lAddProjet , lRmvCRLF )

	Local cCRLF			:= CRLF
	Local cFiltraSF1	:= " "
	
	DEFAULT cTipo		:= "A"
	DEFAULT lAddProjet	:= .F.

	cFiltraSF1	+= "			IN" + cCRLF
	cFiltraSF1	+= "			(" + cCRLF
	cFiltraSF1	+= "				SELECT"+ cCRLF
	cFiltraSF1	+= "					SF1.F1_FILIAL+SF1.F1_DOC+SF1.F1_SERIE+SF1.F1_FORNECE+SF1.F1_LOJA+SF1.F1_TIPO"+IF(lAddProjet,"+SD1.D1_XPROJET" ,"")+cCRLF
	cFiltraSF1	+= "				FROM" + cCRLF
	cFiltraSF1	+= "					" + RetSqlName( "SF1" ) + " SF1," + cCRLF
	cFiltraSF1	+= "					" + RetSqlName( "SD1" ) + " SD1" + cCRLF 
	cFiltraSF1	+= "				WHERE" + cCRLF 
	cFiltraSF1	+= "					SF1.D_E_L_E_T_<>'*'" + cCRLF 
	cFiltraSF1	+= "				AND " + cCRLF 
	cFiltraSF1	+= "					SD1.D_E_L_E_T_<>'*'" + cCRLF 
	cFiltraSF1	+= "				AND  " + cCRLF
	cFiltraSF1	+= "					SF1.F1_FILIAL='"+xFilial("SF1")+"'" + cCRLF 
	cFiltraSF1	+= "				AND " + cCRLF 
	cFiltraSF1	+= "					SF1.F1_XATESTO='"+cTipo+"'" + cCRLF 
	cFiltraSF1	+= "				AND" + cCRLF 
	cFiltraSF1	+= "					SD1.D1_FILIAL='"+xFilial("SD1")+"'" + cCRLF 
	cFiltraSF1	+= "				AND" + cCRLF
	cFiltraSF1	+= "					SD1.D1_XATESTO='"+cTipo+"'" + cCRLF
	cFiltraSF1	+= "				AND" + cCRLF
	cFiltraSF1	+= "					SF1.F1_DOC=SD1.D1_DOC" + cCRLF 
	cFiltraSF1	+= "				AND" + cCRLF 
	cFiltraSF1	+= "					SF1.F1_SERIE=SD1.D1_SERIE" + cCRLF 
	cFiltraSF1	+= "				AND" + cCRLF
	cFiltraSF1	+= "					SF1.F1_FORNECE=SD1.D1_FORNECE" + cCRLF 
	cFiltraSF1	+= "				AND" + cCRLF
	cFiltraSF1	+= "					SF1.F1_LOJA=SD1.D1_LOJA" + cCRLF
	cFiltraSF1	+= "				AND" + cCRLF 
	cFiltraSF1	+= "					SF1.F1_TIPO=SD1.D1_TIPO" + cCRLF
	cFiltraSF1	+= "				AND" + cCRLF
	cFiltraSF1	+= "				(" + cCRLF
	cFiltraSF1	+= "						(SD1.D1_XUSER='"+cCodUser+"')" + cCRLF
	cFiltraSF1	+= "					OR" + cCRLF
	cFiltraSF1	+= "						(SD1.D1_XCODGE='"+cCodUser+"')" + cCRLF
	cFiltraSF1	+= "					OR" + cCRLF
	cFiltraSF1	+= "					EXISTS" + cCRLF
	cFiltraSF1	+= "					(" + cCRLF
	cFiltraSF1	+= "						SELECT" + cCRLF
	cFiltraSF1	+= "							1" + cCRLF
	cFiltraSF1	+= "						FROM" + cCRLF
	cFiltraSF1	+= "							" + RetSqlName( "AFX" ) + " AFX" + cCRLF
	cFiltraSF1	+= "						WHERE" + cCRLF
	cFiltraSF1	+= "							AFX.D_E_L_E_T_<>'*'" + cCRLF
	cFiltraSF1	+= "						AND" + cCRLF
	cFiltraSF1	+= "							AFX.AFX_FILIAL='"+xFilial("AFX")+"'" + cCRLF
	cFiltraSF1	+= "						AND" + cCRLF
	cFiltraSF1	+= "							AFX.AFX_PROJET=SD1.D1_XPROJET" + cCRLF
	cFiltraSF1	+= "						AND" + cCRLF
	cFiltraSF1	+= "							AFX.AFX_USER='"+cCodUser+"'" + cCRLF
	cFiltraSF1	+= "						AND" + cCRLF	
	cFiltraSF1	+= "						(" + cCRLF 
	cFiltraSF1	+= "							(" + cCRLF 
	cFiltraSF1	+= "								(AFX.AFX_XATNFE='1')" + cCRLF 
	cFiltraSF1	+= "								AND" + cCRLF	
	cFiltraSF1	+= "								(" + cCRLF 
	cFiltraSF1	+= "									(SD1.D1_XUSER='"+cCodUser+"')" + cCRLF 
	cFiltraSF1	+= "									OR" + cCRLF 
	cFiltraSF1	+= "									(SD1.D1_XCODGE='"+cCodUser+"')" + cCRLF 
	cFiltraSF1	+= "								)" + cCRLF 
	cFiltraSF1	+= "							)" + cCRLF 
	cFiltraSF1	+= "							OR" + cCRLF 
	cFiltraSF1	+= "							(AFX.AFX_XATNFE='2')" + cCRLF
	cFiltraSF1	+= "						 )" + cCRLF 
	cFiltraSF1	+= "					)" + cCRLF
	cFiltraSF1	+= "				OR" + cCRLF 
	cFiltraSF1	+= "					EXISTS" + cCRLF
	cFiltraSF1	+= "					(" + cCRLF
	cFiltraSF1	+= "						SELECT" + cCRLF
	cFiltraSF1	+= "							1" + cCRLF 
	cFiltraSF1	+= "						FROM" + cCRLF 
	cFiltraSF1	+= "							" + RetSqlName( "SZJ" ) + " SZJ," + cCRLF 
	cFiltraSF1	+= "							" + RetSqlName( "SZK" ) + " SZK," + cCRLF 
	cFiltraSF1	+= "							" + RetSqlName( "AF8" ) + " AF8" + cCRLF
	cFiltraSF1	+= "						WHERE" + cCRLF 
	cFiltraSF1	+= "							AF8.AF8_PROJET=SD1.D1_XPROJET" + cCRLF 
	cFiltraSF1	+= "						AND" + cCRLF 
	cFiltraSF1	+= "							AF8.AF8_XCPROG=SZJ.ZJ_XCODPRO" + cCRLF 
	cFiltraSF1	+= "						AND" + cCRLF 
	cFiltraSF1	+= "							SZJ.D_E_L_E_T_<>'*'" + cCRLF 
	cFiltraSF1	+= "						AND" + cCRLF 
	cFiltraSF1	+= "							SZK.D_E_L_E_T_<>'*'" + cCRLF 
	cFiltraSF1	+= "						AND" + cCRLF 
	cFiltraSF1	+= "							SZJ.ZJ_FILIAL='"+xFilial("SZJ")+"'" + cCRLF 
	cFiltraSF1	+= "						AND" + cCRLF 
	cFiltraSF1	+= "							SZK.ZK_FILIAL='"+xFilial("SZK")+"'" + cCRLF 
	cFiltraSF1	+= "						AND" + cCRLF 
	cFiltraSF1	+= "							SZJ.ZJ_XCODPRO=SZK.ZK_XCODPRO" + cCRLF 
	cFiltraSF1	+= "						AND" + cCRLF 
	cFiltraSF1	+= "							SZK.ZK_CGESTOR='"+cCodUser+"'" + cCRLF 
	cFiltraSF1	+= "						AND" + cCRLF 
	cFiltraSF1	+= "							SZK.ZK_XATNFE='1'" + cCRLF 
	cFiltraSF1	+= "						AND" + cCRLF 
	cFiltraSF1	+= "							SZK.ZK_STATUS='1'" + cCRLF 
	cFiltraSF1	+= "					)" + cCRLF
	cFiltraSF1	+= "				)" + cCRLF 
	cFiltraSF1	+= "			)" + cCRLF
	cFiltraSF1	+= " " + cCRLF

	DEFAULT lRmvCRLF := .T.
	IF ( lRmvCRLF )
        cFiltraSF1    := StaticCall( NDJLIB001 , ClearQuery , cFiltraSF1 )
	EndIF

Return( cFiltraSF1 )

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