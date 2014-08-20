#xcommand DEFINE PANELONLINE <oPGOnline> ;
	=> ;
	<oPGOnline> := TPanelOnLine():New()
	
#xcommand PANELONLINE <oPGOnline> ADDPANEL ;
	[ NAME <cID> ] ;
	[ TITLE <cTitle> ] ;
	[ DESCR <cDescr> ] ;
	[ TYPE <nType> ] ;
	[ PARAMETERS <cPergunte> ] ;
	[ ONLOAD <cProcess> ] ;
	[ REFRESH <nSeconds> ];
	[ TOOLBAR <aToolBar> ];
	[ DEFAULT <nDefault> ];
	[ TITLECOMBO <cTitleCombo> ];
	[ DWHOST <cDWHost> ];
	[ DWNAME <cDWName> ];
	[ DWCONSULT <cDWConsult> ];
	[ DWTYPE <nDWType> ];
	[ <lExpress: PYME> ];
	=> ;
	<oPGOnline>:AddPanel(<cTitle>, <cDescr>, <nType>, [ <cPergunte> ] ,;
						 [<cProcess>], [ <nSeconds> ], [ <aToolBar> ], [ <nDefault> ], ;
						 <cID>, [ <cTitleCombo> ], [ <cDWHOST> ], ;
						 [ <cDWName> ], [ <cDWConsult> ], [ <nDWType> ], [<.lExpress.>]  )

#xcommand ACTIVATE PANELONLINE <oPGOnline> ;
	=> ;
	 <oPGOnline>:Activate()
	
