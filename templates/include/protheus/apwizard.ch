/*
	Header : apwizard.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _APWIZARD_CH_
#define _APWIZARD_CH_

#xcommand DEFINE WIZARD <oWizard>;
				 [ TITLE <cTitle> ] ;
				 [ HEADER <chTitle> ];
				 [ MESSAGE <chMsg> ];
				 [ TEXT <cText> ];
				 [ NEXT <bNext> ];
				 [ FINISH <bFinish> ];
				 [ <lPanel: PANEL> ];
				 [ <lNoFirst: NOFIRSTPANEL> ];
		 => ;
			 <oWizard> = APWizard():New( <chTitle>, <chMsg>, <cTitle>, <cText>,;
										 <bNext>, <bFinish>, <.lPanel.>, , , <.lNoFirst.> )
					  
#xcommand ACTIVATE WIZARD <oWizard> ;
				 [ <lCenter: CENTER, CENTERED> ];
				 [ VALID <bValid> ];
				 [ ON INIT <bInit> ];
				 [ WHEN <bWhen> ];
		  => ;
			 <oWizard>:Activate( <.lCenter.>, <bValid>, <bInit>, <bWhen> )

#xcommand CREATE PANEL <oWizard> ;
				 [ HEADER <chTitle> ];
				 [ MESSAGE <chMsg> ];
				 [ BACK <bBack> ];
				 [ NEXT <bNext> ];
				 [ FINISH <bFinish> ];
				 [ <lPanel: PANEL> ];
				 [ EXEC <bExecute> ];
		  => ;
			 <oWizard>:NewPanel( <chTitle>, <chMsg>, <bBack>, <bNext>, <bFinish>, <.lPanel.>, <bExecute> )
				 
#endif				 