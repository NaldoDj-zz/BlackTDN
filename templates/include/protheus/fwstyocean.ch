//==========================================================================================
// FWLayer
//==========================================================================================

#DEFINE FWOCN_LYR_TITLE	"QFrame { border-style: solid; "+;
						"    border-image: url(rpo:fwocn_lyr_title.png) 10 10 10 10 stretch; "+;
						"    border-top-width: 10px; "+;
						"    border-left-width: 10px; "+;
						"    border-right-width: 10px; "+;
						"    border-bottom-width: 0px; }"

#DEFINE FWOCN_LYR_RND_BDR	"Q3Frame { border-style: solid; "+;
							"    border-image: url(rpo:fwocn_lyr_light_round.png) 10 10 10 10 stretch; "+;
							"    border-top-width: 10px; "+;
							"    border-left-width: 10px; "+;
							"    border-right-width: 10px; "+;
							"    border-bottom-width: 10px; }"

#DEFINE FWOCN_LYR_RCT_BDR	"Q3Frame { border-style: solid; "+;
							"    border-image: url(rpo:fwocn_lyr_light_rect.png) 10 10 10 10 stretch; "+;
							"    border-top-width: 10px; "+;
							"    border-left-width: 10px; "+;
							"    border-right-width: 10px; "+;
							"    border-bottom-width: 10px; }"

#DEFINE FWOCN_LYR_BLUE_RCT_BDR	"Q3Frame { border-style: solid; "+;
							"    border-image: url(rpo:fwocn_lyr_blue_rect.png) 10 10 10 10 stretch; "+;
							"    border-top-width: 10px; "+;
							"    border-left-width: 10px; "+;
							"    border-right-width: 10px; "+;
							"    border-bottom-width: 10px; }"
	
#DEFINE FWOCN_LYR_SPT   "QPushButton { border-image: url(rpo:fwocn_lyr_spt_bg.png) 3 3 3 3 stretch; "+;		
						"    border-width: 3px }"+;
						"QPushButton:hover { border-image: url(rpo:fwocn_lyr_spt_bg.png) 3 3 3 3 stretch; "+;		
						"    border-width: 3px }"+;
						"QPushButton:pressed { border-image: url(rpo:fwocn_lyr_spt_bg.png) 3 3 3 3 stretch; "+;		
						"    border-width: 3px }"+;
						"QPushButton:focus { border-image: url(rpo:fwocn_lyr_spt_bg.png) 3 3 3 3 stretch; "+;		
						"    border-width: 3px }"




//======================================================================
// Genérico Light
//======================================================================

#DEFINE FWOCN_SAY        "QLabel { color: #000000; border: none; background: transparent; } "

#DEFINE FWOCN_BTN_FOCAL	"QPushButton { font: bold; "+;
						"    color: #FFFFFF; "+;
						"    border-image: url(rpo:fwocn_btn_focal.png) 3 3 3 3 stretch; "+;
						"    border-top-width: 3px; "+;
						"    border-left-width: 3px; "+;
						"    border-right-width: 3px; "+;
						"    border-bottom-width: 3px }"+;
						"QPushButton:pressed {	color: #FFFFFF; "+;
						"    border-image: url(rpo:fwocn_btn_prd.png) 3 3 3 3 stretch; "+;
						"    border-top-width: 3px; "+;
						"    border-left-width: 3px; "+;
						"    border-right-width: 3px; "+;
						"    border-bottom-width: 3px }"+;
						"QPushButton:disabled {	color: #FFFFFF; "+;
						"    border-image: url(rpo:fwocn_btn_focal_dld.png) 3 3 3 3 stretch; "+;
						"    border-top-width: 3px; "+;
						"    border-left-width: 3px; "+;
						"    border-right-width: 3px; "+;
						"    border-bottom-width: 3px }"

#DEFINE FWOCN_BTN_NML	"QPushButton { color: #024670; "+;
						"    border-image: url(rpo:fwocn_btn_nml.png) 3 3 3 3 stretch; "+;
						"    border-top-width: 3px; "+;
						"    border-left-width: 3px; "+;
						"    border-right-width: 3px; "+;
						"    border-bottom-width: 3px }"+;
						"QPushButton:pressed {	color: #FFFFFF; "+;
						"    border-image: url(rpo:fwocn_btn_prd.png) 3 3 3 3 stretch; "+;
						"    border-top-width: 3px; "+;
						"    border-left-width: 3px; "+;
						"    border-right-width: 3px; "+;
						"    border-bottom-width: 3px }"

#DEFINE FWOCN_CBX	"QComboBox { font: bold; "+;
					"    color: #2462A6; "+;
					"    background-color: #ffffff; "+;
					"    min-height: 17px; "+;
					"    max-height: 17px; "+;
					"    padding-left: 0px; "+;
					"    border-style: solid; "+;
					"    border-image: url(rpo:fwocn_cbx_get_nml.png) 2 2 2 2 round; "+;
					"    border-width: 2px }"+;
					"QComboBox:hover { color: #FFFFFF; "+;
					"    border-style: solid; "+;
					"    border-image: url(rpo:fwocn_cbx_get_hvr.png) 2 2 2 2 round; "+;
					"    border-width: 2px; }"+;
					"QComboBox:focus { color: #FFFFFF; "+;
					"    border-style: solid; "+;
					"    border-image: url(rpo:fwocn_cbx_get_sld.png) 2 2 2 2 round; "+;
					"    border-width: 2px; }"+;
					"QComboBox::down-arrow{ image: url( rpo:fwocn_cbx_arw_nml.png); }"+;
					"QComboBox::down-arrow:pressed { image: url( rpo:fwocn_cbx_arw_prd.png); }"+;
					"QComboBox::drop-down{ subcontrol-origin:padding; "+;
					"    subcontrol-position:top right; "+;
					"    width:17px; "+;
					"    border-left-width:0px; "+;
					"    border-top-right-radius:0px; "+;
					"    border-bottom-right-radius:0px; }"+;
					"QComboBox::indicator { image: url(rpo:fwocn_cbx_arw_nml.png) }"+;
					"QComboBox QListView{ color: #2462a6; "+;
					"    border-width: 1px; border-style: flat; }"

#DEFINE FWOCN_GET	"QLineEdit { color: #2462A6; "+;
					"    border-image: url(rpo:fwocn_get_nml.png) 3 3 3 3 stretch; "+;
					"    border-width: 3px; padding: -1px; }"+;
					"QLineEdit:hover { border-image: url(rpo:fwocn_get_hvr.png) 3 3 3 3 stretch; "+;
					"    border-top-width: 3px; "+;
					"    border-left-width: 3px; "+;
					"    border-right-width: 3px; "+;
					"    border-bottom-width: 3px; "+;
					"    border-image: url(rpo:fwocn_get_sld.png) 3 3 3 3 stretch; "+;
					"    border-top-width: 3px; "+;
					"    border-left-width: 3px; "+;
					"    border-right-width: 3px; "+;
					"    border-bottom-width: 3px }"

#DEFINE FWOCN_RDO	"QRadioButton { background-repeat: repeat-x; "+;
					"    background-repeat: repeat-y; "+;
					"    max-height: 16px; "+;
					"    min-height: 16px; "+;
					"    spacing: 7px; "+;
					"    padding-top: -1px; "+;
					"    padding-bottom: -1px; "+;
					"    color: #2462a6;  "+;
					"    background-image: url(rpo:fwocn_rdo_nml.png); }"+;
					"QRadioButton:hover { color: #0099FF; "+;
					"    background-image: url(rpo:fwocn_rdo_hvr.png); } "+;
					"QRadioButton:checked { color: #005284 } "+;
					"QRadioButton::indicator::checked { image: url(rpo:fwocn_rdo_ckd.png); }"+;
					"QRadioButton::indicator::unchecked { image: url(rpo:fwocn_rdo_unc.png); }"+;
					"QWidget { border-width: 0px }"
	
#DEFINE FWOCN_CHK	"QCheckBox { background-repeat: repeat-x;  "+;
					"    background-repeat: repeat-y;  "+;
					"    padding-top: 0px; "+;
					"    max-height: 14px; "+;
					"    min-height: 14px; "+;
					"    color: #2462a6; "+;
					"    background-image: url(rpo:fwocn_chk_nml.png); }"+;
					"QCheckBox:hover { color: #0099FF; "+;
					"    background-image: url(rpo:fwocn_chk_hvr.png) }"+;
					"QCheckBox::indicator::checked {image: url(rpo:fwocn_chk_ckd.png);}"+;
					"QCheckBox::indicator::unchecked {image: url(rpo:fwocn_chk_uck.png);}"+;
					"QWidget { border-width: 0px }"

#DEFINE FWOCN_SCR	"QScrollBar:horizontal{ background-image:url(rpo:fwocn_scr_hrz_bg.png) 2 2 2 2 stretch; }"+;
					"QScrollBar:horizontal{ background-repeat: repeat-x }"+;
					"QScrollBar:horizontal{ border-top-width:2px; }"+;
					"QScrollBar:horizontal{ border-right-width:2px; }"+;
					"QScrollBar:horizontal{ border-bottom-width:2px; }"+;
					"QScrollBar:horizontal{ border-left-width:2px; }"+;
					"QScrollBar:horizontal{ margin: 0 15px 0px 16px; }"+;
					"QScrollBar:horizontal{ max-height: 16px }"+;
					"QScrollBar:horizontal{ min-height: 16px }"+;
					"QScrollBar::handle:horizontal{ image:url(rpo:fwocn_scr_hrz.png); }"+;
					"QScrollBar::handle:horizontal{ border-image:url(rpo:fwocn_scr_hrz_btn_cnt_nml.png) 2 2 2 2 stretch; }"+;
					"QScrollBar::handle:horizontal:pressed{ border-image:url(rpo:fwocn_scr_hrz_btn_cnt_prd.png) 2 2 2 2 stretch; }"+;
					"QScrollBar::handle:horizontal{ border-top-width:2px; }"+;
					"QScrollBar::handle:horizontal{ border-right-width:2px; }"+;
					"QScrollBar::handle:horizontal{ border-bottom-width:2px; }"+;
					"QScrollBar::handle:horizontal{ border-left-width:2px; }"+;
					"QScrollBar::add-line:horizontal{ border-image:url(rpo:fwocn_scr_hrz_btn_rgt_nml.png) 2 2 2 2 stretch; }"+;
					"QScrollBar::add-line:horizontal:pressed{ border-image:url(rpo:fwocn_scr_hrz_btn_rgt_prd.png) 2 2 2 2 stretch; }"+;
					"QScrollBar::add-line:horizontal{ border-top-width:2px; }"+;
					"QScrollBar::add-line:horizontal{ border-right-width:2px; }"+;
					"QScrollBar::add-line:horizontal{ border-bottom-width:2px; }"+;
					"QScrollBar::add-line:horizontal{ border-left-width:2px; }"+;
					"QScrollBar::add-line:horizontal{ width: 13px; }"+;
					"QScrollBar::add-line:horizontal{ subcontrol-position:right; }"+;
					"QScrollBar::add-line:horizontal{ subcontrol-origin:margin; }"+;
					"QScrollBar::sub-line:horizontal{ border-image:url(rpo:fwocn_scr_hrz_btn_lft_nml.png) 2 2 2 2 stretch; }"+;
					"QScrollBar::sub-line:horizontal:pressed{ border-image:url(rpo:fwocn_scr_hrz_btn_lft_prd.png) 2 2 2 2 stretch; }"+;
					"QScrollBar::sub-line:horizontal{ border-top-width:2px; }"+;
					"QScrollBar::sub-line:horizontal{ border-right-width:2px; }"+;
					"QScrollBar::sub-line:horizontal{ border-bottom-width:2px; }"+;
					"QScrollBar::sub-line:horizontal{ border-left-width:2px; }"+;
					"QScrollBar::sub-line:horizontal{ width: 13px; }"+;
					"QScrollBar::sub-line:horizontal{ subcontrol-position:left; }"+;
					"QScrollBar::sub-line:horizontal{ subcontrol-origin:margin; }"+;
					"QScrollBar:vertical{ background-image:url(rpo:fwocn_scr_vrt_bg.png) 2 2 2 2 stretch; }"+;
					"QScrollBar:vertical{ margin: 16px 0 16px 0; }"+;
					"QScrollBar:vertical{ max-width: 16px }"+;
					"QScrollBar:vertical{ min-width: 16px }"+;
					"QScrollBar::handle:vertical{ image:url(rpo:fwocn_scr_vrt.png); }"+;
					"QScrollBar::handle:vertical{ border-image:url(rpo:fwocn_scr_vrt_btn_cnt_nml.png) 2 2 2 2 stretch; }"+;
					"QScrollBar::handle:vertical:pressed{ border-image:url(rpo:fwocn_scr_vrt_btn_cnt_prd.png) 2 2 2 2 stretch; }"+;
					"QScrollBar::handle:vertical{ border-top-width:2px; }"+;
					"QScrollBar::handle:vertical{ border-right-width:2px; }"+;
					"QScrollBar::handle:vertical{ border-bottom-width:2px; }"+;
					"QScrollBar::handle:vertical{ border-left-width:2px; }"+;
					"QScrollBar::add-line:vertical{ border-image:url(rpo:fwocn_scr_vrt_btn_btm_nml.png) 2 2 2 2 stretch; }"+;
					"QScrollBar::add-line:vertical:pressed{ border-image:url(rpo:fwocn_scr_vrt_btn_btm_prd.png) 2 2 2 2 stretch; }"+;
					"QScrollBar::add-line:vertical{ border-top-width:2px; }"+;
					"QScrollBar::add-line:vertical{ border-right-width:2px; }"+;
					"QScrollBar::add-line:vertical{ border-bottom-width:2px; }"+;
					"QScrollBar::add-line:vertical{ border-left-width:2px; }"+;
					"QScrollBar::add-line:vertical{ height: 13px; }"+;
					"QScrollBar::add-line:vertical{ subcontrol-position:bottom; }"+;
					"QScrollBar::add-line:vertical{ subcontrol-origin:margin; }"+;
					"QScrollBar::sub-line:vertical{ border-image:url(rpo:fwocn_scr_vrt_btn_top_nml.png) 2 2 2 2 stretch; }"+;
					"QScrollBar::sub-line:vertical:pressed{ border-image:url(rpo:fwocn_scr_vrt_btn_top_prd.png) 2 2 2 2 stretch; }"+;
					"QScrollBar::sub-line:vertical{ border-top-width:2px; }"+;
					"QScrollBar::sub-line:vertical{ border-right-width:2px; }"+;
					"QScrollBar::sub-line:vertical{ border-bottom-width:2px; }"+;
					"QScrollBar::sub-line:vertical{ border-left-width:2px; }"+;
					"QScrollBar::sub-line:vertical{ height: 13px; }"+;
					"QScrollBar::sub-line:vertical{ subcontrol-position:top; }"+;
					"QScrollBar::sub-line:vertical{ subcontrol-origin:margin; }"

#DEFINE FWOCN_LST	"Q3ListBox{ color: #2462a6; "+;
					"    border: 1px solid #DFDFDF; }"

#DEFINE FWOCN_TREE	"Q3ListView{ color: #2462A6; }"+;
					"Q3ListView{ border: 1px solid #DFDFDF; }"

#DEFINE FWOCN_MULTIGET	"Q3TextEdit{ color: #000000; "+;
					"    border: 1px solid #ABADB3 }"

#DEFINE FWOCN_PRC	"QProgressBar { border-image: url(rpo:fwocn_mtr_bg.png) 2 2 2 2 round stretch; "+;
					"    border-width: 2px; "+;
					"    background-color: #FFFFFF; }"+;
					"QProgressBar::chunk { background-image: url(rpo:fwocn_mtr.png); }"

#DEFINE FWOCN_BRW	"QHeaderView::section { color: #2462A6; "+;
					"    padding-left: 4px; "+;
					"    border-image:url(rpo:fwocn_brw_hdr_nml.png) 2 2 2 2 stretch; border-width: 2px; }"+;
					"Q3Table{ color: #2462A6; "+;
					"    border: 1px solid #DFDFDF; }"+;
					"Q3Header::section { color: #2462A6; "+;
					"    padding-left: 4px; "+;
					"    border-image:url(rpo:fwocn_brw_hdr_nml.png) 2 2 2 2 stretch; border-width: 2px; }"+;
					"Q3Header::section:pressed { border-image:url(rpo:fwocn_brw_hdr_prd.png) 2 2 2 2 stretch; border-width: 2px; }"

#DEFINE FWOCN_SPN	"QSpinBox { border: 1px solid #DFDFDF;  }"+;
					"QSpinBox::up-button { padding-top: -2px; "+;
					"    image: url(rpo:fwocn_spn_btn_top_nml.png); width: 18px; height: 18px; }"+;
					"QSpinBox::up-button:hover { image: url(rpo:fwocn_spn_btn_top_hvr.png); width: 18px; height: 18px; }"+;
					"QSpinBox::up-button:pressed { image: url(rpo:fwocn_spn_btn_top_prd.png); width: 18px; height: 18px; }"+;
					"QSpinBox::down-button { padding-bottom: -2px; "+;
					"    image: url(rpo:fwocn_spn_btn_btm_nml.png); width: 18px; height: 18px; }"+;
					"QSpinBox::down-button:hover { image: url(rpo:fwocn_spn_btn_btm_hvr.png); width: 18px; height: 18px; }"+;
					"QSpinBox::down-button:pressed { image: url(rpo:fwocn_spn_btn_btm_prd.png); width: 18px; height: 18px; }"

#DEFINE FWOCN_TLX	"QToolBox::tab { color: #2462A6; "+;
					"    border: 1px solid #DFDFDF; "+;
					"    border-image:url(rpo:fwocn_tlx_btn_nml.png) 2 2 2 2 stretch; border-width: 2px; }"+;
					"QToolBox::tab:pressed { border-image:url(rpo:fwocn_tlx_btn_prd.png) 2 2 2 2 stretch; border-width: 2px; }"

#DEFINE FWOCN_PNL_BDR	"QFrame { border-style: solid; " +;                                    
						"    border-image: url(rpo:fwocn_pnl_bdr.png) 3 3 3 3 stretch; "+;
						"    border-width: 3px }"

#DEFINE FWOCN_FLD	"QTabBar{ border-bottom: none; alignment: center; }"+;
					"QTabBar::tab{ background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, "+;
                    "    stop: 0.0 #E4EBF1, stop: 0.4 #BECEDD, "+;
                    "    stop: 0.5 #BECEDD, stop: 1.0 #F8FAFB); "+;
                    "    border: 1px solid #99CCFF; "+;
                    "    min-width: 8px; "+;
                    "    padding: 2px; "+;
                    "    color:#024670; }"+;
                    "QTabBar::tab:selected{ background-color: white; " +;
                    "    border-color: #ffff66; "+;
                    "    padding-top: 3px; "+;
                    "    margin-top: 1px; }"+;
                    "QTabBar::tab:!selected{ margin-top: 1px; }" +;
                    "QTabBar::tab:first{ border-top-left-radius: 10px; "+;
                    "    border-bottom-left-radius: 10px; }"+;
                    "QTabBar::tab:last{ border-bottom-right-radius: 10px; "+;
                    "    border-top-right-radius: 10px; }"

#DEFINE FWOCN_WPC " QTabBar::tab {background-color: #D6DDE2; " +;
                  "     border: 1px solid #FFFFFF; " +;
                  "     border-top-left-radius: 4px; " +;
                  "     border-top-right-radius: 4px; " +;
                  "     color: #024670; " +;
                  "     min-width: 150px; " +;
                  "     padding: 2px; }"+;
                  "QTabBar::tab:selected{ background-color: #EAF1F6; }"
                           
#DEFINE FWOCN_MSGBAR	"QStatusBar{background:#6F92A8} "+;
						"QLabel{ color:rgb(255,255,255); "+;
						"    border-width: 0px; "+;
						"    border-style:solid; }"
						
#DEFINE FWOCN_MSGBAR_BG	"QStatusBar { border-width:0px; "+;
						"    min-height:50px; "+;
						"    background:brown; "+;
						"    background-image: url(rpo:fwocn_stb_bdr.png);}"+;
                    	"QStatusBar::item { border:none; } "+;
                    	"QLabel{background-image:url(rpo:x.png); color:white}"

#DEFINE FWOCN_BAR_BG "QFrame{ background-color: #EAF1F6; }"

//======================================================================
// Browse
//======================================================================

#DEFINE FWOCN_BRW_BTN  "QPushButton{ border-image:url(rpo:x.png) 5 5 5 5 stretch; "+;
					   "    border-width: 0; "+;
					   "    color:#024670; "+;
                       "    text-decoration: underline; }"

#DEFINE FWOCN_BRW_OPT_FOCAL  "QPushButton{ font: bold; "+;
                             "    border-image:url(rpo:x.png) 5 5 5 5 stretch; "+;
						     "    border-width: 0; "+;
						     "    color: #024670; "+;
						     "    text-decoration: underline; }"+;
                             "QPushButton::menu-indicator{ image:url(rpo:fwocn_ppbtn_ind.png); "+;
                             "    subcontrol-position: right; "+;
                             "    subcontrol-origin: padding; "+;
                             "    left:-2px; }"

#DEFINE FWOCN_BRW_OPT  "QPushButton{ border-image:url(rpo:x.png) 5 5 5 5 stretch; "+;
					   "    border-width: 0; "+;
					   "    color:#024670; "+;
					   "    text-decoration: underline; }"+;
                       "QPushButton::menu-indicator{ image:url(rpo:fwocn_ppbtn_ind.png); "+;
                       "    subcontrol-position:right; "+;
                       "    subcontrol-origin:padding; "+;
                       "    left:-2px; }"

//======================================================================
// View
//======================================================================
#DEFINE FWOCN_VIEW_SEPARATOR "QLabel{background-color: White; margin-top: 2px; color: #004A77; "+;
							"font-family: Arial; font: bold ; font-size: 14px; border: none; "+;
							"border-bottom: 2px solid #004A77;}"
                       
