#xcommand DEFINE FWFILTERASK <oFilterAsk> ;
	[ <lNoView: NO VIEW> ] ;
	[ <lNoProfile: NO PROFILE> ] ;
	[ EXPRESSION <cExpression> ] ;
	=> ;
		<oFilterAsk> := FWFilterAsk():New();;
		If <.lNoView.>;;
			<oFilterAsk>:SetNoView(<.lNoView.>);;
		EndIf;;
		If( ValType(<cExpression>) == "C" );;
			<oFilterAsk>:SetExpression(<cExpression>);;
		EndIf;;
		If <.lNoProfile.>;;
			<oFilterAsk>:SetProfile(.F.);;
		EndIf

#xcommand ACTIVATE FWFILTERASK <oFilterAsk>;
	=> ;
		<oFilterAsk>:Activate()

#xcommand ADD ASK ;
	ID <cID> ;
	TITLE <cAsk> ;
	TYPE <cType> ;
	SIZE <nSize> ;
	[ DECIMAL <nDecimal> ] ;
	[ PICTURE <cPicture> ] ;
	[ OPTIONS <aOptions> ] ;
	[ LOOKUP <cLookUp> ] ;
	[ DEFAULT <xAnswer> ] ;
	[ VALID <bValid> ] ;
	OF <oFilterAsk>;
	=> ;
		<oFilterAsk>:AddAsk(<cID>,<cAsk>,<cType>,<nSize>,<nDecimal>,<cPicture>,<aOptions>,<cLookUp>,<bValid>,<xAnswer>);;
		
