
/*
	Header : winapi.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _WINAPI_CH
#define _WINAPI_CH

#define IDOK                       1
#define ID_OK                      1
#define IDCANCEL                   2

#define BN_CLICKED                 0

#define CS_VREDRAW                 1  // 0x0001
#define CS_HREDRAW                 2  // 0x0002
#define CS_GLOBALCLASS         16384  // 0x4000

#define CS_OWNDC                  32  // 0x0020
#define CS_CLASSDC                64  // 0x0040
#define CS_PARENTDC              128  // 0x0080

#define CS_BYTEALIGNCLIENT      4096  // 0x1000
#define CS_BYTEALIGNWINDOW      8192  // 0x2000

#define WS_OVERLAPPED              0  // 0x00000000L
#define WS_POPUP          2147483648  // 0x80000000L
#define WS_CHILD          1073741824  // 0x40000000L

#define WS_CLIPSIBLINGS     67108864  // 0x04000000L
#define WS_CLIPCHILDREN     33554432  // 0x02000000L

#define WS_VISIBLE         268435456  // 0x10000000L
#define WS_DISABLED        134217728  // 0x08000000L

#define WS_MINIMIZE        536870912  // 0x20000000L
#define WS_MAXIMIZE         16777216  // 0x01000000L

#define WS_CAPTION          12582912  // 0x00C00000L
#define WS_BORDER            8388608  // 0x00800000L
#define WS_DLGFRAME          4194304  // 0x00400000L
#define WS_VSCROLL           2097152  // 0x00200000L
#define WS_HSCROLL           1048576  // 0x00100000L
#define WS_SYSMENU            524288  // 0x00080000L
#define WS_THICKFRAME         262144  // 0x00040000L
#define WS_MINIMIZEBOX        131072  // 0x00020000L
#define WS_MAXIMIZEBOX         65536  // 0x00010000L

#define WS_GROUP              131072  // 0x00020000L
#define WS_TABSTOP             65536  // 0x00010000L

#define WS_OVERLAPPEDWINDOW (WS_OVERLAPPED + WS_CAPTION + WS_SYSMENU + WS_THICKFRAME + WS_MINIMIZEBOX + WS_MAXIMIZEBOX)
#define WS_POPUPWINDOW	    (WS_POPUP + WS_BORDER + WS_SYSMENU)
#define WS_CHILDWINDOW	    (WS_CHILD)

#define ES_LEFT                    0
#define ES_RIGHT                   2
#define ES_MULTILINE               4
#define ES_AUTOHSCROLL           128    // 0x0080
#define ES_WANTRETURN           4096    // 0x1000

#define WM_NULL                    0    // 0x0000
#define WM_DESTROY                 2    // 0x0002
#define WM_MOVE                    3
#define WM_SIZE                    5    // 0x0005
#define WM_SETFOCUS                7    // 0x0007
#define WM_KILLFOCUS               8    // 0x0008
#define WM_PAINT                  15    // 0x000F
#define WM_CLOSE                  16    // 0x0010
#define WM_QUERYENDSESSION        17    // 0x0011
#define WM_QUIT                   18    // 0x0012
#define WM_SYSCOLORCHANGE         21    // 0x0015
#define WM_ENDSESSION             22    // 0x0016
#define WM_SYSTEMERROR            23    // 0x0017
#define WM_WININICHANGE           26    // 0x001A
#define WM_DEVMODECHANGE          27    // 0x001B
#define WM_FONTCHANGE             29    // 0x001D
#define WM_TIMECHANGE             30    // 0x001E
#define WM_SPOOLERSTATUS          42    // 0x002A
#define WM_COMPACTING             65    // 0x0041

#define WM_GETDLGCODE            135    // 0x0087
#define WM_CHAR                  258    // 0x0102
#define WM_COMMAND               273    // 0x0111
#define WM_MOUSEMOVE             512    // 0x0200
#define WM_LBUTTONDOWN           513    // 0x0201
#define WM_LBUTTONUP             514    // 0x0202
#define WM_RBUTTONDOWN           516    // 0x0204
#define WM_RBUTTONUP             517    // 0x0205
#define WM_KEYDOWN               256    // 0x0100
#define WM_KEYUP                 257    // 0x0101
#define WM_INITDIALOG            272    // 0x0110
#define WM_TIMER                 275    // 0x0113
#define WM_HSCROLL               276    // 0x0115
#define WM_VSCROLL               277    // 0x0115

#define WM_QUERYNEWPALETTE       783    // 0x030F
#define WM_PALETTEISCHANGING     784    // 0x0310
#define WM_PALETTECHANGED        785    // 0x0311

#define WM_USER                 1024    // 0x0400

#define DS_SYSMODAL                2
#define DS_MODALFRAME            128  // 0x80

// Dialogs

#define DLGC_WANTARROWS                    1
#define DLGC_WANTTAB                       2
#define DLGC_WANTALLKEYS                   4
#define DLGC_WANTCHARS                   128

// ListBox Styles

#define LBS_NOTIFY               1
#define LBS_SORT                 2
#define LBS_OWNERDRAWFIXED      16  //    0x10
#define LBS_USETABSTOPS        128  //    0x80
#define LBS_NOINTEGRALHEIGHT   256  //   0x100
#define LBS_WANTKEYBOARDINPUT 1024  //   0x400
#define LBS_DISABLENOSCROLL   4096  //  0x1000
#define LBS_STANDARD      10485763  //0xA00003

// ComboBox Styles

#define CBS_SIMPLE               1  // 0x0001
#define CBS_DROPDOWN             2  // 0x0002
#define CBS_DROPDOWNLIST         3  // 0x0003
#define CBS_OWNERDRAWFIXED      16  // 0x0010
#define CBS_AUTOHSCROLL         64  // 0x0040
#define CBS_OEMCONVERT         128  // 0x0080
#define CBS_SORT               256  // 0x0100
#define CBS_DISABLENOSCROLL   2048  // 0x0800

// ScrollBar

#define SB_LINEUP                          0
#define SB_LINELEFT                        0
#define SB_LINEDOWN                        1
#define SB_LINERIGHT                       1
#define SB_PAGEUP                          2
#define SB_PAGELEFT                        2
#define SB_PAGEDOWN                        3
#define SB_PAGERIGHT                       3
#define SB_THUMBPOSITION                   4
#define SB_THUMBTRACK                      5
#define SB_TOP                             6
#define SB_LEFT                            6
#define SB_BOTTOM                          7
#define SB_RIGHT                           7
#define SB_ENDSCROLL                       8

// Scroll Bar styles

#define SBS_HORZ                           0
#define SBS_VERT                           1

// CheckBox

#define BS_PUSHBUTTON                     0
#define BS_DEFPUSHBUTTON                  1
#define BS_CHECKBOX                       2
#define BS_AUTOCHECKBOX                   3   // 0x00000003
#define BS_GROUPBOX                       7
#define BS_AUTORADIOBUTTON                9

/* Pen Styles */
#define PS_SOLID                          0
#define PS_DASH                           1
#define PS_DOT                            2
#define PS_DASHDOT                        3
#define PS_DASHDOTDOT                     4
#define PS_NULL                           5
#define PS_INSIDEFRAME                    6

#define SS_BLACKRECT                      4
#define SS_WHITERECT                      6
#define SS_WHITEFRAME                     9
#define SS_LEFT                           0
#define SS_SIMPLE                        11   // 0x0B

// VBX Support

#define DLGINIT 240

// ZIPs Support

#define FN_UNZIP  15000

#endif
