//==========================================================================================
// FWLayer
//==========================================================================================

#DEFINE FWSST_LYR_TITLE	"QFrame { color: #FFFFFF; border-style: solid; "+;
							"    border-image: url(rpo:fwsst_lyr_title.png) 10 10 10 10 stretch; "+;
							"    border-top-width: 10px; "+;
							"    border-left-width: 10px; "+;
							"    border-right-width: 10px; "+;
							"    border-bottom-width: 0px; }"

#DEFINE FWSST_LYR_RND_BDR	"Q3Frame { border-style: solid; "+;
							"    border-image: url(rpo:fwsst_lyr_light_round.png) 10 10 10 10 stretch; "+;
							"    border-top-width: 10px; "+;
							"    border-left-width: 10px; "+;
							"    border-right-width: 10px; "+;
							"    border-bottom-width: 10px; }"

#DEFINE FWSST_LYR_RCT_BDR	"Q3Frame { border-style: solid; "+;
							"    border-image: url(rpo:fwsst_lyr_light_rect.png) 10 10 10 10 stretch; "+;
							"    border-top-width: 10px; "+;
							"    border-left-width: 10px; "+;
							"    border-right-width: 10px; "+;
							"    border-bottom-width: 10px; }"

#DEFINE FWSST_LYR_BLUE_RCT_BDR	"Q3Frame { border-style: solid; "+;
								"    border-image: url(rpo:fwsst_lyr_blue_rect.png) 10 10 10 10 stretch; "+;
								"    border-top-width: 10px; "+;
								"    border-left-width: 10px; "+;
								"    border-right-width: 10px; "+;
								"    border-bottom-width: 10px; }"

#DEFINE FWSST_LYR_SPT   "QPushButton { border-image: url(rpo:fwsst_lyr_spt_bg.png) 3 3 3 3 stretch; "+;		
						"    border-width: 3px }"+;
						"QPushButton:hover { border-image: url(rpo:fwsst_lyr_spt_bg.png) 3 3 3 3 stretch; "+;		
						"    border-width: 3px }"+;
						"QPushButton:pressed { border-image: url(rpo:fwsst_lyr_spt_bg.png) 3 3 3 3 stretch; "+;		
						"    border-width: 3px }"+;
						"QPushButton:focus { border-image: url(rpo:fwsst_lyr_spt_bg.png) 3 3 3 3 stretch; "+;		
						"    border-width: 3px }"


//======================================================================
// Genérico Light
//======================================================================
#DEFINE FWSST_SAY    "QLabel { color: #472929; border: none; background: transparent; } "


#DEFINE FWSST_BTN_FOCAL	"QPushButton { font: bold; "+;
						"    color: #FFFFFF; "+;
						"    border-image: url(rpo:fwsst_btn_focal.png) 3 3 3 3 stretch; "+;
						"    border-top-width: 3px; "+;
						"    border-left-width: 3px; "+;
						"    border-right-width: 3px; "+;
						"    border-bottom-width: 3px }"+;
						"QPushButton:pressed {	color: #FFFFFF; "+;
						"    border-image: url(rpo:fwsst_btn_prd.png) 3 3 3 3 stretch; "+;
						"    border-top-width: 3px; "+;
						"    border-left-width: 3px; "+;
						"    border-right-width: 3px; "+;
						"    border-bottom-width: 3px }"+;
						"QPushButton:disabled {	color: #FFFFFF; "+;
						"    border-image: url(rpo:fwsst_btn_focal_dld.png) 3 3 3 3 stretch; "+;
						"    border-top-width: 3px; "+;
						"    border-left-width: 3px; "+;
						"    border-right-width: 3px; "+;
						"    border-bottom-width: 3px }"

#DEFINE FWSST_BTN_NML	"QPushButton { color: #424242; "+;
						"    border-image: url(rpo:fwsst_btn_nml.png) 3 3 3 3 stretch; "+;
						"    border-top-width: 3px; "+;
						"    border-left-width: 3px; "+;
						"    border-right-width: 3px; "+;
						"    border-bottom-width: 3px }"+;
						"QPushButton:pressed {	color: #FFFFFF; "+;
						"    border-image: url(rpo:fwsst_btn_prd.png) 3 3 3 3 stretch; "+;
						"    border-top-width: 3px; "+;
						"    border-left-width: 3px; "+;
						"    border-right-width: 3px; "+;
						"    border-bottom-width: 3px }"

#DEFINE FWSST_CBX	"QComboBox { font: bold; "+;
					"    color: #472929; "+;
					"    background-color: #ffffff; "+;
					"    min-height: 17px; "+;
					"    max-height: 17px; "+;
					"    padding-left: 0px; "+;
					"    border-style: solid; "+;
					"    border-image: url(rpo:fwsst_cbx_get_nml.png) 2 2 2 2 round; "+;
					"    border-width: 2px }"+;
					"QComboBox:hover { color: #FFFFFF; "+;
					"    border-style: solid; "+;
					"    border-image: url(rpo:fwsst_cbx_get_hvr.png) 2 2 2 2 round; "+;
					"    border-width: 2px; }"+;
					"QComboBox:focus { color: #FFFFFF; "+;
					"    border-style: solid; "+;
					"    border-image: url(rpo:fwsst_cbx_get_sld.png) 2 2 2 2 round; "+;
					"    border-width: 2px; }"+;
					"QComboBox::down-arrow{ image: url( rpo:fwsst_cbx_arw_nml.png); }"+;
					"QComboBox::down-arrow:pressed { image: url( rpo:fwsst_cbx_arw_prd.png); }"+;
					"QComboBox::drop-down{ subcontrol-origin:padding; "+;
					"    subcontrol-position:top right; "+;
					"    width:17px; "+;
					"    border-left-width:0px; "+;
					"    border-top-right-radius:0px; "+;
					"    border-bottom-right-radius:0px; }"+;
					"QComboBox::indicator { image: url(rpo:fwsst_cbx_arw_nml.png) }"+;
					"QComboBox QListView{ color: #472929; "+;
					"    border-width: 1px; border-style: flat; }"

#DEFINE FWSST_GET	"QLineEdit { color: #000000; selection-background-color: #CA5F5E;"+;
					"    border-image: url(rpo:fwsst_get_nml.png) 3 3 3 3 stretch; "+;
					"    border-width: 3px; padding: -1px; }"+;
					"QLineEdit:hover { border-image: url(rpo:fwsst_get_hvr.png) 3 3 3 3 stretch; "+;
					"    border-width: 3px; padding: -1px; }"+;
					"QLineEdit:focus { border-image: url(rpo:fwsst_get_sld.png) 3 3 3 3 stretch; "+;
					"    border-width: 3px; padding: -1px; }"+;
					"QLineEdit:disabled { color:#000000; "+;
					"    border-image: url(rpo:fwsst_get_dld.png) 3 3 3 3 stretch; "+;
					"    border-width: 3px; padding: -1px; }"

#DEFINE FWSST_RDO	"QRadioButton { background-repeat: repeat-x; "+;
					"    background-repeat: repeat-y; "+;
					"    max-height: 16px; "+;
					"    min-height: 16px; "+;
					"    spacing: 7px; "+;
					"    padding-top: -1px; "+;
					"    padding-bottom: -1px; "+;
					"    color: #472929;  "+;
					"    background-image: url(rpo:fwsst_rdo_nml.png); }"+;
					"QRadioButton:hover { color: #D40003; "+;
					"    background-image: url(rpo:fwsst_rdo_hvr.png); } "+;
					"QRadioButton:checked { color: #005284 } "+;
					"QRadioButton::indicator::checked { image: url(rpo:fwsst_rdo_ckd.png); }"+;
					"QRadioButton::indicator::unchecked { image: url(rpo:fwsst_rdo_unc.png); }"+;
					"QWidget { border-width: 0px }"
	
#DEFINE FWSST_CHK	"QCheckBox { background-repeat: repeat-x;  "+;
					"    background-repeat: repeat-y;  "+;
					"    padding-top: 0px; "+;
					"    max-height: 14px; "+;
					"    min-height: 14px; "+;
					"    color: #472929; "+;
					"    background-image: url(rpo:fwsst_chk_nml.png); }"+;
					"QCheckBox:hover { color: #D40003; "+;
					"    background-image: url(rpo:fwsst_chk_hvr.png) }"+;
					"QCheckBox::indicator::checked {image: url(rpo:fwsst_chk_ckd.png);}"+;
					"QCheckBox::indicator::unchecked {image: url(rpo:fwsst_chk_uck.png);}"+;
					"QWidget { border-width: 0px }"

#DEFINE FWSST_SCR	"QScrollBar:horizontal{ background-image:url(rpo:fwsst_scr_hrz_bg.png) 2 2 2 2 stretch; }"+;
					"QScrollBar:horizontal{ background-repeat: repeat-x }"+;
					"QScrollBar:horizontal{ border-top-width:2px; }"+;
					"QScrollBar:horizontal{ border-right-width:2px; }"+;
					"QScrollBar:horizontal{ border-bottom-width:2px; }"+;
					"QScrollBar:horizontal{ border-left-width:2px; }"+;
					"QScrollBar:horizontal{ margin: 0 15px 0px 16px; }"+;
					"QScrollBar:horizontal{ max-height: 16px }"+;
					"QScrollBar:horizontal{ min-height: 16px }"+;
					"QScrollBar::handle:horizontal{ image:url(rpo:fwsst_scr_hrz.png); }"+;
					"QScrollBar::handle:horizontal{ border-image:url(rpo:fwsst_scr_hrz_btn_cnt_nml.png) 2 2 2 2 stretch; }"+;
					"QScrollBar::handle:horizontal:pressed{ border-image:url(rpo:fwsst_scr_hrz_btn_cnt_prd.png) 2 2 2 2 stretch; }"+;
					"QScrollBar::handle:horizontal{ border-top-width:2px; }"+;
					"QScrollBar::handle:horizontal{ border-right-width:2px; }"+;
					"QScrollBar::handle:horizontal{ border-bottom-width:2px; }"+;
					"QScrollBar::handle:horizontal{ border-left-width:2px; }"+;
					"QScrollBar::add-line:horizontal{ border-image:url(rpo:fwsst_scr_hrz_btn_rgt_nml.png) 2 2 2 2 stretch; }"+;
					"QScrollBar::add-line:horizontal:pressed{ border-image:url(rpo:fwsst_scr_hrz_btn_rgt_prd.png) 2 2 2 2 stretch; }"+;
					"QScrollBar::add-line:horizontal{ border-top-width:2px; }"+;
					"QScrollBar::add-line:horizontal{ border-right-width:2px; }"+;
					"QScrollBar::add-line:horizontal{ border-bottom-width:2px; }"+;
					"QScrollBar::add-line:horizontal{ border-left-width:2px; }"+;
					"QScrollBar::add-line:horizontal{ width: 13px; }"+;
					"QScrollBar::add-line:horizontal{ subcontrol-position:right; }"+;
					"QScrollBar::add-line:horizontal{ subcontrol-origin:margin; }"+;
					"QScrollBar::sub-line:horizontal{ border-image:url(rpo:fwsst_scr_hrz_btn_lft_nml.png) 2 2 2 2 stretch; }"+;
					"QScrollBar::sub-line:horizontal:pressed{ border-image:url(rpo:fwsst_scr_hrz_btn_lft_prd.png) 2 2 2 2 stretch; }"+;
					"QScrollBar::sub-line:horizontal{ border-top-width:2px; }"+;
					"QScrollBar::sub-line:horizontal{ border-right-width:2px; }"+;
					"QScrollBar::sub-line:horizontal{ border-bottom-width:2px; }"+;
					"QScrollBar::sub-line:horizontal{ border-left-width:2px; }"+;
					"QScrollBar::sub-line:horizontal{ width: 13px; }"+;
					"QScrollBar::sub-line:horizontal{ subcontrol-position:left; }"+;
					"QScrollBar::sub-line:horizontal{ subcontrol-origin:margin; }"+;
					"QScrollBar:vertical{ background-image:url(rpo:fwsst_scr_vrt_bg.png) 2 2 2 2 stretch; }"+;
					"QScrollBar:vertical{ margin: 16px 0 16px 0; }"+;
					"QScrollBar:vertical{ max-width: 16px }"+;
					"QScrollBar:vertical{ min-width: 16px }"+;
					"QScrollBar::handle:vertical{ image:url(rpo:fwsst_scr_vrt.png); }"+;
					"QScrollBar::handle:vertical{ border-image:url(rpo:fwsst_scr_vrt_btn_cnt_nml.png) 2 2 2 2 stretch; }"+;
					"QScrollBar::handle:vertical:pressed{ border-image:url(rpo:fwsst_scr_vrt_btn_cnt_prd.png) 2 2 2 2 stretch; }"+;
					"QScrollBar::handle:vertical{ border-top-width:2px; }"+;
					"QScrollBar::handle:vertical{ border-right-width:2px; }"+;
					"QScrollBar::handle:vertical{ border-bottom-width:2px; }"+;
					"QScrollBar::handle:vertical{ border-left-width:2px; }"+;
					"QScrollBar::add-line:vertical{ border-image:url(rpo:fwsst_scr_vrt_btn_btm_nml.png) 2 2 2 2 stretch; }"+;
					"QScrollBar::add-line:vertical:pressed{ border-image:url(rpo:fwsst_scr_vrt_btn_btm_prd.png) 2 2 2 2 stretch; }"+;
					"QScrollBar::add-line:vertical{ border-top-width:2px; }"+;
					"QScrollBar::add-line:vertical{ border-right-width:2px; }"+;
					"QScrollBar::add-line:vertical{ border-bottom-width:2px; }"+;
					"QScrollBar::add-line:vertical{ border-left-width:2px; }"+;
					"QScrollBar::add-line:vertical{ height: 13px; }"+;
					"QScrollBar::add-line:vertical{ subcontrol-position:bottom; }"+;
					"QScrollBar::add-line:vertical{ subcontrol-origin:margin; }"+;
					"QScrollBar::sub-line:vertical{ border-image:url(rpo:fwsst_scr_vrt_btn_top_nml.png) 2 2 2 2 stretch; }"+;
					"QScrollBar::sub-line:vertical:pressed{ border-image:url(rpo:fwsst_scr_vrt_btn_top_prd.png) 2 2 2 2 stretch; }"+;
					"QScrollBar::sub-line:vertical{ border-top-width:2px; }"+;
					"QScrollBar::sub-line:vertical{ border-right-width:2px; }"+;
					"QScrollBar::sub-line:vertical{ border-bottom-width:2px; }"+;
					"QScrollBar::sub-line:vertical{ border-left-width:2px; }"+;
					"QScrollBar::sub-line:vertical{ height: 13px; }"+;
					"QScrollBar::sub-line:vertical{ subcontrol-position:top; }"+;
					"QScrollBar::sub-line:vertical{ subcontrol-origin:margin; }"

#DEFINE FWSST_LST	"Q3ListBox{ border-image:none; "+;
					"    color: #472929; "+;
					"    border: 1px solid #B6B6B6; }"+;
					"Q3ListBox{ selection-background-color: #FB292A; "+;
					"    alternate-background-color: #FF0000; "+;
					"    background: #FFFFFF; color: #000000; border: 1px solid #9E9E9E; }"

#DEFINE FWSST_TREE	"Q3ListView{ color: #472929; }"+;
					"Q3ListView{ border: 1px solid #DFDFDF; }"

#DEFINE FWSST_MULTIGET	"Q3TextEdit{ color: #472929; selection-background-color: #CA5F5E;"+;
						"    border-image: url(rpo:fwsst_get_nml.png) 3 3 3 3 stretch; "+;
						"    border-top-width: 3px; "+;
						"    border-left-width: 3px; "+;
						"    border-right-width: 3px; "+;
						"    border-bottom-width: 3px; }"+;
						"Q3TextEdit:hover { border-image: url(rpo:fwsst_get_hvr.png) 3 3 3 3 stretch; "+;
						"    border-top-width: 3px; "+;
						"    border-left-width: 3px; "+;
						"    border-right-width: 3px; "+;
						"    border-bottom-width: 3px; }"+;
						"Q3TextEdit:focus { border-image: url(rpo:fwsst_get_sld.png) 3 3 3 3 stretch; "+;
						"    border-top-width: 3px; "+;
						"    border-left-width: 3px; "+;
						"    border-right-width: 3px; "+;
						"    border-bottom-width: 3px }"

#DEFINE FWSST_PRC	"QProgressBar { border-image: url(rpo:fwsst_mtr_bg.png) 2 2 2 2 round stretch; "+;
					"    border-width: 2px; "+;
					"    background-color: #FFFFFF; "+;
					"    max-height:7px; }"+;
					"QProgressBar::chunk { background-image: url(rpo:fwsst_mtr.png); }"

#DEFINE FWSST_BRW	"QHeaderView::section { color: #472929; "+;
					"    padding-left: 4px; "+;
					"    border-image:url(rpo:fwsst_brw_hdr_nml.png) 2 2 2 2 stretch; border-width: 2px; height: 30px; }"+;
					"Q3Table{ color: #0000FF; "+;
					"    border: 1px solid #DFDFDF; }"+;
					"Q3Header::section { color: #00FF00; "+;
					"    padding-left: 4px; "+;
					"    border-image:url(rpo:fwsst_brw_hdr_nml.png) 2 2 2 2 stretch; border-width: 2px; }"+;
					"Q3Header::section:pressed { border-image:url(rpo:fwsst_brw_hdr_prd.png) 2 2 2 2 stretch; border-width: 2px; }"

#DEFINE FWSST_SPN	"QSpinBox { border: 1px solid #DFDFDF;  }"+;
					"QSpinBox::up-button { padding-top: -2px; "+;
					"    image: url(rpo:fwsst_spn_btn_top_nml.png); width: 18px; height: 18px; }"+;
					"QSpinBox::up-button:hover { image: url(rpo:fwsst_spn_btn_top_hvr.png); width: 18px; height: 18px; }"+;
					"QSpinBox::up-button:pressed { image: url(rpo:fwsst_spn_btn_top_prd.png); width: 18px; height: 18px; }"+;
					"QSpinBox::down-button { padding-bottom: -2px; "+;
					"    image: url(rpo:fwsst_spn_btn_btm_nml.png); width: 18px; height: 18px; }"+;
					"QSpinBox::down-button:hover { image: url(rpo:fwsst_spn_btn_btm_hvr.png); width: 18px; height: 18px; }"+;
					"QSpinBox::down-button:pressed { image: url(rpo:fwsst_spn_btn_btm_prd.png); width: 18px; height: 18px; }"

#DEFINE FWSST_TLX	"QToolBox::tab { color: #472929; "+;
					"    border: 1px solid #DFDFDF; "+;
					"    border-image:url(rpo:fwsst_tlx_btn_nml.png) 2 2 2 2 stretch; border-width: 2px; }"+;
					"QToolBox::tab:pressed { border-image:url(rpo:fwsst_tlx_btn_prd.png) 2 2 2 2 stretch; border-width: 2px; }"

#DEFINE FWSST_PNL_BDR	"Q3Frame { border-style:solid; "+;
						"border-width:1px; "+;
						"border-color:#d2e0ed;}"

#DEFINE FWSST_FLD	"QTabBar{ border-bottom: none; alignment: center; }"+;
					"QTabBar::tab{ background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, "+;
                    "    stop: 0.0 #F6E1E1, stop: 0.4 #D47B7A, "+;
                    "    stop: 0.5 #D47B7A, stop: 1.0 #F6E1E1); "+;
                    "    border: 1px solid #D98A89; "+;
                    "    min-width: 8px; "+;
                    "    padding: 2px; "+;
                    "    color:#472929; }"+;
                    "QTabBar::tab:selected{ background-color: white; " +;
                    "    border-color: #D98A89; "+;
                    "    padding-top: 3px; "+;
                    "    margin-top: 1px; }"+;
                    "QTabBar::tab:!selected{ margin-top: 1px; }" +;
                    "QTabBar::tab:first{ border-top-left-radius: 10px; "+;
                    "    border-bottom-left-radius: 10px; }"+;
                    "QTabBar::tab:last{ border-bottom-right-radius: 10px; "+;
                    "    border-top-right-radius: 10px; }"

#DEFINE FWSST_WPC " QTabBar::tab {background-color: #E7B6B5; " +;
                  "     border: 1px solid #FFFFFF; " +;
                  "     border-top-left-radius: 4px; " +;
                  "     border-top-right-radius: 4px; " +;
                  "     color: #472929; " +;
                  "     min-width: 150px; " +;
                  "     padding: 2px; }"+;
                  "QTabBar::tab:selected{ background-color: #FBF0F0; }"
                           
#DEFINE FWSST_MSGBAR	"QStatusBar{background:#C12224; } "+;
						"QLabel{ color:rgb(255,255,255); "+;
						"    border-width: 0px; "+;
						"    border-style:solid; }"

#DEFINE FWSST_MSGBAR_BG	"QStatusBar { border-width: 0px; "+;
						"    min-height:50px; "+;
						"    background:brown; "+;
						"    background-image: url(rpo:fwsst_stb_bdr.png); "+;
						"    border: none }"+;
                    	"QStatusBar::item { border:none; } "+;
                    	"QLabel{background-image:url(rpo:x.png); color:white}"

#DEFINE FWSST_BAR_BG "QFrame{ background-color: #FFFFFF; }"

// Menu Popup
#DEFINE FWSST_POPUP	"QMenu{ border: 1px solid #7A8A99; background-color: #fff;}"+;
			 	 					 	 "QMenu::item:selected{border-image:url(rpo:fwsst_popup.png) 2 2 2 2 stretch; padding: 2px 25px 2px 20px;}"+;
  		 	 					 	 "QMenu::item { background-color:transparent; border:2px solid transparent; padding: 2px 25px 2px 20px}"

//======================================================================
// Browse
//======================================================================

#DEFINE FWSST_BRW_BTN  "QPushButton{ border-image:url(rpo:x.png) 5 5 5 5 stretch; "+;
					   "    border-width: 0; "+;
					   "    color:#472929; "+;
                       "    text-decoration: underline; }"

#DEFINE	FWSST_BRW_OPT_FOCAL  "QPushButton{ font: bold; "+;
                             "    border-image:url(rpo:x.png) 5 5 5 5 stretch; "+;
						     "    border-width: 0; "+;
						     "    color: #472929; "+;
						     "    text-decoration: underline; }"+;
                             "QPushButton::menu-indicator{ image:url(rpo:fwsst_ppbtn_ind.png); "+;
                             "    subcontrol-position: right; "+;
                             "    subcontrol-origin: padding; "+;
                             "    left:-2px; }"

#DEFINE FWSST_BRW_OPT  "QPushButton{ border-image:url(rpo:x.png) 5 5 5 5 stretch; "+;
					   "    border-width: 0; "+;
					   "    color:#472929; "+;
					   "    text-decoration: underline; }"+;
                       "QPushButton::menu-indicator{ image:url(rpo:fwsst_ppbtn_ind.png); "+;
                       "    subcontrol-position:right; "+;
                       "    subcontrol-origin:padding; "+;
                       "    left:-2px; }"

//======================================================================
// View
//======================================================================
#DEFINE FWSST_VIEW_SEPARATOR "QLabel{background-color: White; margin-top: 2px; color: #472929; "+;
							"font-family: Arial; font: bold ; font-size: 14px; border: none; "+;
							"border-bottom: 2px solid #472929;}"
