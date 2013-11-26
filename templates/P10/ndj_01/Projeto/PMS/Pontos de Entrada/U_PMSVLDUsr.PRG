#INCLUDE "NDJ.CH"
/*/
	Funcao:		PMSVLDUsr
	Autor:		Marinaldo de Jesus
	Data:		27/11/2010
	Descricao:	Ponto de Entrada na Rotina de Validacao de Usuarios do PMS executado em PmsChkUser na PMSXFUNA.PRX
/*/
User Function PMSVLDUsr()

	Local bFields	:= { ||;
								cProjeto,	;
								cTarefa,	;
								cEDT,		;
								cEDTPai,	;
								nCheck,		;
								cCampo,		;
								cRevisa,	;
								cUserID,	;
								lCheckPai,	;
								lRet		;
							}	

	Local cProjeto	:= ParamIxb[01]
	Local cTarefa	:= ParamIxb[02]
	Local cEDT		:= ParamIxb[03]
	Local cEDTPai	:= ParamIxb[04]
	Local nCheck	:= ParamIxb[05]
	Local cCampo	:= ParamIxb[06]
	Local cRevisa	:= ParamIxb[07]
	Local cUserID	:= ParamIxb[08]
	Local lCheckPai	:= ParamIxb[09]
	Local lRet		:= ParamIxb[10]

	Local lUserOk	:= lRet 
	Local lDisable	:= ( IsInCallStack( "A220CtrMenu" )  )
	
	Local oException

	BEGIN SEQUENCE

        IF ( GetNewPar( "NDJ_PMSADM" , .T. ) )
			IF !( lUserOk )
                lUserOk := PswUsrGrp( StaticCall( NDJLIB014 , RetCodUsr ) , "000000" )
			EndIF 
		EndIF	
		
		IF ( lDisable )
			lUserOk := ( lUserOk .and. ( "GERSC" $ cCampo ) )
		EndIF

		IF !( ValType( lUserOk ) == "L" )
			TRYEXCEPTION
			    Eval( bFields )
			CATCHEXCEPTION USING oException
		    	IF ( ValType( oException ) == "O" )
			    	lUserOk	:= .F.  
		    		//...
		    	EndIF
			ENDEXCEPTION
		EndIF

	END SEQUENCE

	//Utilizo o PE mais Externo para Garantir a Liberacao de Todos os Locks
    StaticCall( NDJLIB003 , AliasUnLock )

Return( lUserOk )

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