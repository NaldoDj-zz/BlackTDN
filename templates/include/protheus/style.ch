/*
Nao esta em uso
Static STYLE0000 := "QWiget{background-color:#ffffff}"+;
			"QPushButton{border-style:solid;"+;
			" order-image:url(rpo:x.png) 4 4 4 4 stretch;"+;
			" border-width: 4px;}"+;
			"QPushButton:hover{color:#000000;"+;
			" border-style:solid;"+;
			" border-image:url(rpo:DefaultBorderWhite.png) 4 4 4 4 stretch;"+;
			" border-width:4px;"+;
			" color:#000000;"+;
			" border-style:solid;"+;
			" border-image:url(rpo:x.png) 4 4 4 4 stretch;"+;
			" border-width:4px;}"+;
			"QPushButton:pressed{color:#000000;"+;
			" border-style:solid;"+;
			" border-image:url(rpo:DefaultBorderWhiteOver.png) 4 4 4 4 stretch;"+;
			" border-width:4px;}"+;
			"QLineEdit{border-style:solid;"+;
			" border-color:rgb(224,224,224);"+;
			" border-width:1px;"+;
			" border-radius:4px;}"+;
			"QLineEdit:hover{border-style:solid;"+;
			" color:#CCCCCC;"+;
			" border-color:rgb(70,70,70);"+;
			" border-width:1px;"+;
			" border-radius:4px;}"+;
			"QLineEdit:focus{border-style:solid;"+;
			" color:#CCCCCC;"+;
			" border-color:rgb(180,180,180);"+;
			" border-width:1px;"+;
			" border-radius:4px;}"+;
			"QComboBox{color:#bdbdbd;"+;
			" border-style:solid;"+;
			" border-image:url(rpo:GenericBorderWhite.png) 5 5 5 5 stretch;"+;
			" background-image:url(rpo:SetaScroll.png);"+;
			" background-repeat:repeat-y;"+;
   		" background-position:right;"+;
			" border-width:5px;}"+;
			"QComboBox:hover{color:#000000;"+;
			" border-style:solid;"+;
			" border-image:url(rpo:GenericBorderWhiteOver.png) 5 5 5 5 stretch;"+;
			" border-width:5px;}"+;
			"QComboBox:focus{border-width:5px;"+;
			" color:#000000;"+;
			" border-style:solid;"+;
			" border-image:url(rpo:GenericBorderWhiteOver.png) 5 5 5 5 stretch;}"+;
			"QCheckBox{color:#000000;"+;
			" background-repeat:repeat-x;"+;
			" background-repeat:repeat-y;"+;
			" spacing:20px;"+;
			" background-image:url(rpo:IndicatorCheckBox.png);}"+;
			"QCheckBox:hover{background-image:url(rpo:IndicatorCheckBoxOver.png);}"+;
			"QCheckBox:checked{background-image:url(rpo:IndicatorCheckBoxChecked.png);}"+;
			"QCheckBox::indicator{image: url(rpo:x.png);}"+;
			"QLabel{color:#747474;} "
*/           
Static FWMULTIGET :=	"Q3TextEdit{ color: #000000; "+;
						"    border-image: url(rpo:cssGet.png) 2 2 2 2 stretch; "+;
						"    border-width: 2px; }"+;
						"Q3TextEdit:focus { border-image: url(rpo:cssGetFocus.png) 2 2 2 2 stretch; "+;
						"    border-width: 2px; }"+;
						"Q3TextEdit:disabled { border-image: url(rpo:cssGetDisable.png) 2 2 2 2 stretch; "+;
						"    border-width: 2px; }"
///ccs Button
Static STYLE0001 := "QPushButton{background-color:white;"+;
			" color:#bdbdbd;"+;
			" border-style:solid;"+;
			" border-image:url(rpo:DarkBorderWhite.png) 9 9 9 9 stretch;"+;
			" border-width:9px;}"+;
			"QPushButton:hover{color:#000000;"+;
			" border-image:url(rpo:DarkBorderWhiteFocus.png) 9 9 9 9 stretch;}"+;
			"QPushButton:focus{color:#000000;"+;
			" border-image:url(rpo:DarkBorderWhiteFocus.png) 9 9 9 9 stretch;}"+;
			"QPushButton:pressed{color:#ffffff;"+;
			" border-image:url(rpo:DarkBorderBlackFocus.png) 9 9 9 9 stretch;}"

///ccs Get			
Static STYLE0002 := "QLineEdit{color:#ffffff;"+;
			" border-style:solid;"+;
			" border-image:url(rpo:DarkBorderBlack.png) 9 9 9 9 stretch;"+;
			" border-width:9px;}"+;
			"QLineEdit:hover{border-image:url(rpo:DarkBorderBlackOver.png) 9 9 9 9 stretch;}"+;
			"QLineEdit:focus{border-image:url(rpo:DarkBorderBlackFocus.png) 9 9 9 9 stretch;}"
			
///ccs Say			
Static STYLE0003 := "QLabel{color:#000000;}"

///ccs GetSearch
Static STYLE0004 := "QLineEdit{color:#9692a9;"+;
			" border-style:solid;"+;
			" border-image:url(rpo:VistaBgBlack.png) 8 8 8 8 stretch;"+;
			" border-width:8px;}"

///ccs MenuTop 			
Static STYLE0005 := "QMenuBar{color:#ffffff;"+;
			" padding-top:3px;"+;
			" background-image:url(rpo:VistaBgBlackMenu.png);}"+;
			"QMenu{background-color:#ffffff;"+;
			" color:#000000;"+;
			" border-style:solid;"+;
			" border-image:url(rpo:CleanBorderWhite.png) 4 4 4 4 stretch;"+;
			" border-width:4px;}"+;
			"QToolBar{background-image:url(rpo:x.png);}"

///ccs Combo
Static STYLE0006 := "QComboBox{color:#ffffff;"+;
				" border-style:solid;"+;
				" border-image:url(rpo:DarkBorderBlack.png) 9 9 17 9 stretch;"+;
				" border-width:9px;"+;
				" background-image:url(rpo:SetaScroll.png);"+;
				" background-repeat:repeat-y;"+;
        " background-position:right;}"+;
				"QComboBox:hover{border-image:url(rpo:DarkBorderBlackOver.png) 9 9 9 9 stretch;}"+;
				"QComboBox:focus{border-image:url(rpo:DarkBorderBlackFocus.png) 9 9 9 9 stretch;}"+;
				"QWidget{border-style:solid;"+;
				" border-image:url(rpo:DarkBorderBlack.png) 9 9 9 9 stretch;"+;
				" border-style:solid;"+;
				" border-width:9px;}"

///ccs CheckBox
Static STYLE0007 := "QCheckBox{color:#000000;"+;
			" background-repeat:repeat-x;"+;
			" background-repeat:repeat-y;"+;
			" spacing:20px;"+;
			" background-image:url(rpo:IndicatorCheckBox.png);}"+;
			"QCheckBox:hover{background-image:url(rpo:IndicatorCheckBoxOver.png);}"+;
			"QCheckBox:checked{background-image:url(rpo:IndicatorCheckBoxChecked.png);}"+;
			"QCheckBox::indicator{image:url(rpo:x.png);}"

///ccs Split
Static STYLE0008 := "QPushButton{background-color:white;"+;
			" color:#bdbdbd;"+;
			" border-style:solid;"+;
			" border-image:url(rpo:SplitBorderWhite.png) 2 2 2 2 stretch;"+;
			" border-width:2px;}"+;
			"QPushButton:hover{color:#000000;"+;
			" border-image:url(rpo:SplitBorderWhiteOver.png) 2 2 2 2 stretch;}"+;
			"QPushButton:focus{color:#000000;"+;
			" border-image:url(rpo:SplitBorderWhiteOver.png) 2 2 2 2 stretch;}"+;
			"QPushButton:pressed{color:#ffffff;"+;
			" border-image:url(rpo:SplitBorderWhiteOver.png) 2 2 2 2 stretch;}"
		
///ccs GetExecute 			
Static STYLE0009 := "QLineEdit{color:#000000;"+;
			" border-style:solid;"+;
			" border-image:url(rpo:ExecuteBorderWhite.png) 8 8 8 8 stretch;"+;
			" border-width:8px;}"

///ccs ButtonCloseWindow
Static STYLE0010 := "QPushButton{border-style:solid;"+;
			" border-image:url(rpo:DarkBorderWhite.png) 9 9 9 9 stretch;"+;
			" border-width:9px;}"+;
			"QPushButton:hover{color:#000000;"+;
			" border-image:url(rpo:DarkBorderWhiteFocus.png) 9 9 9 9 stretch;}"+;
			"QPushButton:focus{color:#000000;"+;
			" border-image:url(rpo:DarkBorderWhiteFocus.png) 9 9 9 9 stretch;}"+;
			"QPushButton:pressed{color:#ffffff;"+;
			" border-image:url(rpo:DarkBorderBlackFocus.png) 9 9 9 9 stretch;}"

// Menu Lateral Nivel 01
Static STYLE0012 := "QPushButton{background-color:#ebedf3;"+;
			" border-image:url(rpo:SepGroup1.png) 5 5 5 5 stretch;"+;
			" color:#000000;}"+;
			"QPushButton:hover{background-color:#cdd2e0;}"+;
			"QPushButton:pressed{background-color:#cdd2e0;}"

// Menu Lateral Nivel 02
Static STYLE0013 := "QPushButton{border-width:5px;"+;
			" background-color:#a9b1c7;"+;
			" border-image:url(rpo:SepGroup2.png) 5 5 5 5 stretch;"+;
			" color:#ffffff;}"+;
			"QPushButton:hover{background-color:#66749a;}"+;
			"QPushButton:pressed{background-color:#66749a;}"

// Menu Lateral Nivel 03
Static STYLE0014 := "QPushButton{border-width:5px;"+;
			" background-color:#66749a;"+;
			" border-image:url(rpo:SepGroup3.png) 5 5 5 5 stretch;"+;
			" color:#ffffff;}"+;
			"QPushButton:hover{background-color:#4b536c;}"+;
			"QPushButton:pressed{background-color:#4b536c;}"

// Menu Lateral Nivel 04
Static STYLE0015 := "QPushButton{border-width:5px;"+;
			" background-color:#4b536c;"+;
			" border-image:url(rpo:SepGroup4.png) 5 5 5 5 stretch;"+;
			" color:#ffffff;}"+;
			"QPushButton:hover{background-color:#292f42;}"+;
			"QPushButton:pressed{background-color:#292f42;}"

// Menu Lateral Nivel 05
Static STYLE0016 := "QPushButton{border-width:5px;"+;
			" background-color:#292f42;"+;
			" border-image:url(rpo:SepGroup5.png) 5 5 5 5 stretch;"+;
			" color:#ffffff;}"+;
			"QPushButton:hover{background-color:#222534;}"+;
			"QPushButton:pressed{background-color:#222534;}"
			
///ccs Button Important
Static STYLE0017 := "QPushButton{color:#4e6195;"+;
			" border-style:solid;"+;
			" border-image:url(rpo:DarkBorderBlue.png) 9 9 9 9 stretch;"+;
			" border-width:9px;}"+;
			"QPushButton:hover{color:#000000;"+;
			" border-image:url(rpo:DarkBorderBlueFocus.png) 9 9 9 9 stretch;}"+;
			"QPushButton:focus{color:#000000;"+;
			" border-image:url(rpo:DarkBorderBlueFocus.png) 9 9 9 9 stretch;}"+;
			"QPushButton:pressed{color:#000000;"+;
			" border-image:url(rpo:DarkBorderBlueFocus.png) 9 9 9 9 stretch;}"

///ccs MBrowse 			
Static STYLE0019 := ""					

///ccs MBrowse 			
Static STYLE0020 := "QWidget{border-color:rgb(180,180,180);"+;
			" border-width:1px;"+;
			" border-radius:4px;}"

///ccs Button Copiar
Static STYLE0021 := "QPushButton{color:#4e6195;"+;
			" border-style:solid;"+;
			" background-image:url(rpo:Salvar.PNG);"+;
			" border-image:url(rpo:TransparentBorder.png) 17 17 17 17 stretch;"+;
			" border-width:17px;}"+;
			"QPushButton:hover{color:#000000;"+;
			" border-image:url(rpo:TransparentBorderOver.png) 17 17 17 17 stretch;}"+;
			"QPushButton:focus{color:#000000;"+;
			" border-image:url(rpo:TransparentBorderOver.png) 17 17 17 17 stretch;}"+;
			"QPushButton:pressed{color:#FFFFFF;"+;
			" border-image:url(rpo:TransparentBorderOver.png) 17 17 17 17 stretch;}"

Static STYLE0022 := "QTab{background-image:url(rpo:DarkBorderWhite.png);}"+;
			"QTabBarWidget{background-image:url(rpo:DarkBorderWhite.png);}"+;
			"QTabBar{background-color:#FFFFFF;}"+;
			"QWidget{background-color:#FFFFFF;}"
			
Static STYLE0023 := "background-image:url(rpo:WhiteBorderFolder.png)"

Static STYLE0024 := "QPushButton{background-color:#ebedf3;"+;
					" border-image:url(rpo:SepGroup1.png) 5 5 5 5 stretch;"+;
					" color:#000000;}"+;
					"QPushButton:hover{background-color: #cdd2e0;}"+;
					"QPushButton:pressed{background-color:#cdd2e0;}"+;
					"QPushButton::menu-indicator{image:url(rpo:menuindicator.png);"+;
          " subcontrol-position:right;"+;
          " subcontrol-origin:padding;"+;
          " left:-2px;}"
					
// Protheus Search
Static STYLE0025 := "QPushButton{border-width:5px;"+;
			" border-image:url(rpo:bg.png) 5 5 5 5 stretch;"+;
			" background-image:url(rpo:BG.PNG);"+;
			" color:#ffffff;}"+;
			"QPushButton:hover{background-color:#292f42;"+;
			" border-image:url(rpo:SepGroup4.png) 5 5 5 5 stretch;}"+;
			"QPushButton:pressed{background-color:#292f42;"+;
			" border-image:url(rpo:SepGroup4.png) 5 5 5 5 stretch;}"

STATIC uInit := __InitStyle()
Static Function __InitStyle()
Local cBuild := GetBuild() 

	//-------------------------
	If cBuild >= "7.00.081216P-20090316"
	//-------------------------

		///ccs MenuTop 			
		STYLE0005 := "QMenuBar{color:#ffffff;"+;
		             " padding-top:3px;"+;
		             " background-color:transparent;"+;
           			 " background-image:url(rpo:VistaBgBlackMenu.png);}"+;
                 "QMenuBar::item:selected{border:1px solid white;"+;
                 " border-right:1px solid #A0A0A0;;"+;
                 " border-bottom:1px solid #A0A0A0;}"+;
                 "QMenuBar::item:pressed{border:1px solid white;"+;
                 " border-left:1px solid #A0A0A0;"+;
                 " border-top:1px solid #A0A0A0;}"+;
           			 "QMenu{background-color:#ffffff;"+;
           			 " color:#000000;"+;
			           " border-style:solid;"+;
           			 " border-image:url(rpo:CleanBorderWhite.png) 4 4 4 4 stretch;"+;
           			 " border-style:solid; border-width: 4px;}"+;
				 				 "QMenu::item:selected {margin:1px 3px 1px 3px;"+;
				 				 " background-color:#DEE7EC;"+;
				 				 " border:1px solid #8CACBB;"+;
				 				 " padding:2px 25px 2px 20px;}"+;
				         "QMenu::item{margin:1px 3px 1px 3px;"+;
				         " background-color:transparent;"+;
				         " border:1px solid transparent;"+;
				         " padding:2px 25px 2px 20px;}"+;
           			 "QToolBar{background-image:url(rpo: x.png);}"

		///ccs Combo
    STYLE0006 := "QComboBox{color:#ffffff;"+;
 	               " border-style:solid;"+;
	               " border-width:9px;"+;
	               " background-position:right;"+;
                 " min-height:12px;"+;
                 " padding-right:5px;"+;
                 " border-image:url(rpo:DarkBorderBlack.png) 9 9 17 9 stretch;}"+;
	               "QComboBox:hover{color:#ffffff;"+;
                 " border-style:solid;"+;
	               " border-image:url(rpo:DarkBorderBlackOver.png) 9 9 9 9 stretch;"+;
	               " border-width:9px;}"+;
	               "QComboBox:focus{color:#ffffff;"+;
                 " border-style:solid;"+;
	               " border-image:url(rpo:DarkBorderBlackFocus.png) 9 9 9 9 stretch;"+;
	               " border-width:9px;}"+;
	               "QComboBox:content{border-image:url(rpo:DarkBorderBlack.png) 9 9 9 9 stretch}"+;
	               "QComboBox::down-arrow{image:url(rpo:SetaScroll.png);}"+;
	               "QComboBox::down-arrow:on{top:1px;left: 1px;}"+;
	               "QComboBox::drop-down{subcontrol-origin:padding;"+;
                 " subcontrol-position:top right;"+;
                 " width:15px;"+;
                 " border-left-width:1px;"+;
                 " border-left-color:darkgray;"+;
	               " border-left-style:solid;"+;
								 " border-top-right-radius:3px;"+;
								 " border-bottom-right-radius:3px;}"+;
	               "QComboBox QListView{border-image:url(rpo:DarkBorderBlack.png) 9 9 9 9 stretch;"+;
	               " color:white;"+;
								 " border-width:3px;"+;
								 " border-style:solid}"

	EndIf
Return Nil
