#INCLUDE "NDJ.CH"

#DEFINE APO_INFO_PRG			1
#DEFINE APO_INFO_LANG			2
#DEFINE APO_INFO_BUILD_TYPE		3
#DEFINE APO_INFO_DATE_TIME		4
#DEFINE APO_INFO_TIME			5

#DEFINE APO_ARRAY_SIZE			5

/*/

	Funcao:		U_GetApoInfo
	Autor:		Marinaldo de Jesus
	Data:		28/09/2011
	Descricao:	Retorna String Html com informacoes dos Programas no RPO
	Sintaxe:	U_GetApoInfo(uQuery , cTkn , bEval , lGetApoFilter , lShowApoInfo , lCloseAfterShow , lHtml , lTableFormat )

/*/
User Function GetApoInfo( uQuery , cTkn , bEval , lGetApoFilter , lShowApoInfo , lCloseAfterShow , lHtml , lTableFormat )

	Local aApoInfo

	Local oVarInfo

	MsgRun( "Please Wait..." , "Getting the Object Inspector" , { || aApoInfo := MyGetApoInfo( @uQuery , @cTkn , @bEval , @lGetApoFilter ) } )

	MsgRun( "Please Wait..." , "Showing the Object Inspector" , { || oVarInfo := TVarInfo():New( @aApoInfo , "Object Inspector" ) } )

	BEGIN SEQUENCE

		DEFAULT lShowApoInfo	:= .T.
		DEFAULT lHtml			:= .T.
		DEFAULT lTableFormat 	:= .F.

		IF ( lShowApoInfo )
			oVarInfo:Save( @lHtml , @lTableFormat )
			oVarInfo:Show()
		Else
			ConOut( oVarInfo:Echo( @lHtml , @lTableFormat ) )
			While ( oVarInfo:GoNext() )
				ConOut( oVarInfo:Echo( @lHtml , @lTableFormat ) )
			End While
		EndIF

		DEFAULT lCloseAfterShow	:= .T.
		IF ( lCloseAfterShow )
			oVarInfo:Close( .T. , .F. )
		EndIF	
	
	END SEQUENCE

Return( oVarInfo )

/*/

	Funcao:		MyGetApoInfo
	Autor:		Marinaldo de Jesus
	Data:		28/09/2011
	Descricao:	Retorna Array com as Informacoes dos Programas contidos no RPO
	Sintaxe:	MyGetApoInfo( uacQuery , cTkn , bEval , lGetApoFilter )
/*/
Static Function MyGetApoInfo( uacQuery , cTkn , bEval , lGetApoFilter )

	Local aQuery					:= {}

	Local aApoInfo					:= {}

	Local aGFType					:= {}
	Local aGFPrg					:= {}
	Local aGFSize					:= {}
	Local aGFTime					:= {}
	Local aGFDateTime				:= {}

	Local aPrgs						:= {}
	Local aFuncInfo
	Local aGFcArray

	Local cPrgFile
	Local cTypeQry					:= ValType( uacQuery )

	Local lQuery					:= ( cTypeQry $ "A/C" )

	Local nBFA
	Local nEFA
	
	Local nApoInfo					:= 0

	DEFAULT bEval					:= { |aQuery,cPrgFile| aScan( aQuery, { |cQry| ( SubStr( cPrgFile , 1 , Len( cQry ) ) == cQry ) } ) > 0 }

	IF ( lQuery )
		IF ( cTypeQry == "C" )
			uacQuery				:= Upper( uacQuery )
			DEFAULT lGetApoFilter	:= ( "*" $ uacQuery )
			IF ( lGetApoFilter )
				aGFcArray			:= GetFuncArray( uacQuery , @aGFType , @aGFPrg , @aGFSize , @aGFDateTime , @aGFTime )
				lQuery				:= .F.
			Else
				IF !( cTkn == NIL )
					aQuery			:= StrTokArr( uacQuery , cTkn )
				Else
					aAdd( aQuery , Upper( uacQuery ) )
				EndIF
			EndIF
		ElseIF ( cTypeQry == "A" )
			aEval( uacQuery , { |cQry| aAdd( aQuery , Upper( cQry ) ) } )
		EndIF
	EndIF

	DEFAULT aGFcArray				:= GetFuncArray( "*" , @aGFType , @aGFPrg , @aGFSize , @aGFDateTime , @aGFTime )

	nEFA := Len( aGFPrg )
	For nBFA := 1 To nEFA
		cPrgFile := aGFPrg[ nBFA ]
		IF ( lQuery )
			IF !( Eval( bEval , aQuery , cPrgFile ) )
				Loop
			EndIF
		EndIF
		IF ( aScan( aPrgs , { |cPrg| ( cPrg == cPrgFile ) } ) > 0 )
			Loop
		EndIF
		aAdd( aPrgs , cPrgFile )
		aFuncInfo	:= GetApoInfo( cPrgFile )
		IF !Empty( aFuncInfo )
			++nApoInfo
			aAdd( aApoInfo , Array( APO_ARRAY_SIZE ) )
			aApoInfo[ nApoInfo ][ APO_INFO_PRG ]			:= aFuncInfo[ APO_INFO_PRG ]
			aApoInfo[ nApoInfo ][ APO_INFO_LANG ]			:= aFuncInfo[ APO_INFO_LANG ]
			aApoInfo[ nApoInfo ][ APO_INFO_BUILD_TYPE ]		:= aFuncInfo[ APO_INFO_BUILD_TYPE ]
			aApoInfo[ nApoInfo ][ APO_INFO_DATE_TIME ]		:= aFuncInfo[ APO_INFO_DATE_TIME ]
			aApoInfo[ nApoInfo ][ APO_INFO_TIME ]			:= aFuncInfo[ APO_INFO_TIME ]
		EndIF
	Next nBFA

Return( aApoInfo )

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