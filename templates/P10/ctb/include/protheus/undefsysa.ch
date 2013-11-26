#INCLUDE "MDJSYS.CH"
Static Function sysChkApon(aParamIxb)

#IFDEF _AMARC_TABLE_CHK_FIELD
	Local lPrvtChk	:= PrvtChk()
#ELSE
	Local lPrvtChk	:= .F.
#ENDIF	

Local aMarcacoes	:= aParamIxb[1]
Local aSemaphore    := U_MDJ001Exec( "GetSemaphore" , { "sysChkApon\sysChkApon.lck" } )

Local aSemaDate
Local aTabCalend

Local cFil
Local cNowDateTime

Local dPerIGeA
Local dPerFGeA
Local dSemaDate

Local nPosMarc
Local nPosDate
Local nMarcacoes

Begin Sequence

	IF !( lPrvtChk )
		Break
	EndIF

	aTabCalend	:= aParamIxb[2]
	cFil		:= xFilial( "SRA" , SRA->RA_FILIAL )

	SetMemVar( "PA_TOLATRA" , 999.99							, .T. )
	SetMemVar( "PA_TOLSAIA" , 999.99							, .T. )
	SetMemVar( "PA_TOLASAI" , "999-999-999-999-999-999-999-999"	, .T. )
	SetMemVar( "PA_TOLHEX"  , "999-999-999-999-999-999-999-999" , .T. )
	SetMemVar( "PA_TOLFALT" , 999.99							, .T. )

	SetMemVar( "PA_MARCAUT" , "1E-1S-2E-2S-3E-3S-4E-4S-"		, .T. )
	SetMemVar( "PA_ALEATOR" , "S"								, .T. )
	SetMemVar( "PA_MINALEA" , 10								, .T. )
	SetMemVar( "PA_AUTOMSM" , "S"								, .T. )
	SetMemVar( "PA_COMPMAR" , "S"								, .T. )
	SetMemVar( "R6_AUTOSAI" , ""								, .T. )

	IF (;
			!( Type( "dPerDe" ) == "D" );
			.or.;
			!( Type( "dPerAte" ) == "D" );
		)	
		Private dPerDe
		Private dPerAte
		IF !( CheckPonMes( @dPerDe , @dPerAte , .F. , .T. , .F. , cFil ) )
			Break
		EndIF
	EndIF

	dPerIGeA		:= dPerDe
	dPerFGeA		:= dPerAte
	IF SRA->( RA_ADMISSA > dPerDe .and. RA_ADMISSA <= dPerAte )
		dPerIGeA	:= SRA->RA_ADMISSA
	EndIF
	IF SRA->( RA_DEMISSA < dPerAte .and. !Empty( RA_DEMISSA ) )
		dPerFGeA	:= SRA->RA_DEMISSA
	EndIF

	dPerIGeA	:= Max( dPerIGeA , dPerDe  )
	dPerFGeA	:= Min( Min( dPerFGeA , dPerAte ) , MsDate() )

	IF !Empty( aSemaphore )
		nPosDate := aScan( aSemaphore , { |cDate| "MAXDATE" $ Upper( AllTrim( cDate ) ) } )
		IF ( nPosDate > 0 )
            aSemaDate := U_MDJ001Exec( "StrToArray" , { aSemaphore[nPosDate] , "=" } )
			IF ( Len( aSemaDate ) >= 2 )
				dSemaDate := StoD( aSemaDate[2] )
				IF !Empty( dSemaDate )
					dPerFGeA	:= Min( dPerFGeA , dSemaDate )
				EndIF
			EndIF
		EndIF
	EndIF

	IF ( dPerFGeA < dPerIGeA )
		Break
	EndIF

	PutMarcAuto( @aTabCalend , @aMarcacoes , @dPerIGeA , @dPerFGeA , @cFil , .F. , .F. )

	nPosMarc		:= 0
	nMarcacoes		:= Len( aMarcacoes )
	cNowDateTime	:= DataHora2Str( MsDate() , SecsToHrs( TimeToSecs( Time() ) ) )

	While ( ( nPosMarc := aScan( aMarcacoes , { |x| x[AMARC_DTHR2STR] >= cNowDateTime } ) ) > 0 )
		aDel( aMarcacoes , nPosMarc )
		aSize( aMarcacoes , --nMarcacoes )
	End While

	aEval( aMarcacoes , { |aElem,nElem| aMarcacoes[nElem,AMARC_FLAG] := "E" , aMarcacoes[nElem,AMARC_RELOGIO] := "00" } )

End Sequence

Return( aMarcacoes )

Static Function PrvtChk()

Local lPrvtChk := .F.

Begin Sequence

	lPrvtChk := _AMARC_TABLE_CHK_FIELD
	IF ( lPrvtChk )
		Break
	EndIF

	lPrvtChk := _AMARC_TABLE_CHK_FIELD_LN
	IF ( lPrvtChk )
		lPrvtChk := .F.
		Break
	EndIF
	
	lPrvtChk := _AMARC_TABLE_CHK_FIELD_VM
	IF ( lPrvtChk )
		Break
	EndIF

End Sequence

Return( lPrvtChk )
