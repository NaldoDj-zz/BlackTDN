
/*
	Header : vkey.ch
	Copyright (c) 1997-2008, TOTVS SA
	All rights reserved.
*/

#ifndef _VKEY_CH
#define _VKEY_CH

#define VK_LBUTTON          1         //  0x01
#define VK_RBUTTON          2         //  0x02
#define VK_CANCEL           3         //  0x03
#define VK_MBUTTON          4         //  0x04
#define VK_BACK             8         //  0x08
#define VK_TAB              9         //  0x09
#define VK_CLEAR            12        //  0x0C
#define VK_RETURN           13        //  0x0D
#define VK_SHIFT            16        //  0x10
#define VK_CONTROL          17        //  0x11
#define VK_MENU             18        //  0x12
#define VK_PAUSE            19        //  0x13
#define VK_CAPITAL          20        //  0x14
#define VK_ESCAPE           27        //  0x1B
#define VK_SPACE            32        //  0x20
#define VK_PRIOR            33        //  0x21
#define VK_NEXT             34        //  0x22
#define VK_END              35        //  0x23
#define VK_HOME             36        //  0x24
#define VK_LEFT             37        //  0x25
#define VK_UP               38        //  0x26
#define VK_RIGHT            39        //  0x27
#define VK_DOWN             40        //  0x28
#define VK_SELECT           41        //  0x29
#define VK_PRINT            42        //  0x2A
#define VK_EXECUTE          43        //  0x2B
#define VK_SNAPSHOT         44        //  0x2C
#define VK_INSERT           45        //  0x2D
#define VK_DELETE           46        //  0x2E
#define VK_HELP             47        //  0x2F
#define VK_NUMPAD0          96        //  0x60
#define VK_NUMPAD1          97        //  0x61
#define VK_NUMPAD2          98        //  0x62
#define VK_NUMPAD3          99        //  0x63
#define VK_NUMPAD4         100        //  0x64
#define VK_NUMPAD5         101        //  0x65
#define VK_NUMPAD6         102        //  0x66
#define VK_NUMPAD7         103        //  0x67
#define VK_NUMPAD8         104        //  0x68
#define VK_NUMPAD9         105        //  0x69
#define VK_MULTIPLY        106        //  0x6A
#define VK_ADD             107        //  0x6B
#define VK_SEPARATOR       108        //  0x6C
#define VK_SUBTRACT        109        //  0x6D
#define VK_DECIMAL         110        //  0x6E
#define VK_DIVIDE          111        //  0x6F
#define VK_F1              112        //  0x70
#define VK_F2              113        //  0x71
#define VK_F3              114        //  0x72
#define VK_F4              115        //  0x73
#define VK_F5              116        //  0x74
#define VK_F6              117        //  0x75
#define VK_F7              118        //  0x76
#define VK_F8              119        //  0x77
#define VK_F9              120        //  0x78
#define VK_F10             121        //  0x79
#define VK_F11             122        //  0x7A
#define VK_F12             123        //  0x7B
#define VK_F13             124        //  0x7C
#define VK_F14             125        //  0x7D
#define VK_F15             126        //  0x7E
#define VK_F16             127        //  0x7F
#define VK_F17             128        //  0x80
#define VK_F18             129        //  0x81
#define VK_F19             130        //  0x82
#define VK_F20             131        //  0x83
#define VK_F21             132        //  0x84
#define VK_F22             133        //  0x85
#define VK_F23             134        //  0x86
#define VK_F24             135        //  0x87
#define VK_NUMLOCK         144        //  0x90
#define VK_SCROLL          145        //  0x91

#define ACC_NORMAL        1
#define ACC_SHIFT         4
#define ACC_CONTROL       8
#define ACC_ALT          16

//                                                             
// Retirado do Inkey.ch do Clipper 5.3, devido a bug do        
// FiveWin nas combinações (SHIFT, CTRL, ALT) + FN             
//-----------------------------------------------------        
// Control keys                                                
#define K_CTRL_A            1    //   Ctrl-A, Home                 
#define K_CTRL_B            2    //   Ctrl-B, Ctrl-Right arrow     
#define K_CTRL_C            3    //   Ctrl-C, PgDn, Ctrl-ScrollLock
#define K_CTRL_D            4    //   Ctrl-D, Right arrow          
#define K_CTRL_E            5    //   Ctrl-E, Up arrow             
#define K_CTRL_F            6    //   Ctrl-F, End                  
#define K_CTRL_G            7    //   Ctrl-G, Del                  
#define K_CTRL_H            8    //   Ctrl-H, Backspace            
#define K_CTRL_I            9    //   Ctrl-I, Tab                  
#define K_CTRL_J            10   //   Ctrl-J                        
#define K_CTRL_K            11   //   Ctrl-K                        
#define K_CTRL_L            12   //   Ctrl-L                        
#define K_CTRL_M            13   //   Ctrl-M, Return                
#define K_CTRL_N            14   //   Ctrl-N                        
#define K_CTRL_O            15   //   Ctrl-O                        
#define K_CTRL_P            16   //   Ctrl-P                        
#define K_CTRL_Q            17   //   Ctrl-Q                        
#define K_CTRL_R            18   //   Ctrl-R, PgUp                  
#define K_CTRL_S            19   //   Ctrl-S, Left arrow            
#define K_CTRL_T            20   //   Ctrl-T                        
#define K_CTRL_U            21   //   Ctrl-U                        
#define K_CTRL_V            22   //   Ctrl-V, Ins                   
#define K_CTRL_W            23   //   Ctrl-W, Ctrl-End              
#define K_CTRL_X            24   //   Ctrl-X, Down arrow            
#define K_CTRL_Y            25   //   Ctrl-Y                        
#define K_CTRL_Z            26   //   Ctrl-Z, Ctrl-Left arrow       
#define K_CTRL_1            50   //   Ctrl-1
#define K_CTRL_2            51   //   Ctrl-2
#define K_CTRL_3            52   //   Ctrl-3
#define K_CTRL_4            53   //   Ctrl-4
#define K_CTRL_5            54   //   Ctrl-5
#define K_CTRL_6            55   //   Ctrl-6
#define K_CTRL_7            56   //   Ctrl-7
#define K_CTRL_8            57   //   Ctrl-8
#define K_CTRL_9            58   //   Ctrl-9
#define K_CTRL_0            59   //   Ctrl-0
#define K_CTRL_UNDERSCORE   60   //   Ctrl-UNDERSCORE
#define K_CTRL_EQUAL        61   //   Ctrl-EQUAL
#define K_CTRL_KEYPAD_1     62   //   Ctrl-Keypad_1
#define K_CTRL_KEYPAD_2     63   //   Ctrl-Keypad_2
#define K_CTRL_KEYPAD_3     64   //   Ctrl-Keypad_3
#define K_CTRL_KEYPAD_4     65   //   Ctrl-Keypad_4
#define K_CTRL_KEYPAD_5     66   //   Ctrl-Keypad_5
#define K_CTRL_KEYPAD_6     67   //   Ctrl-Keypad_6
#define K_CTRL_KEYPAD_7     68   //   Ctrl-Keypad_7
#define K_CTRL_KEYPAD_8     69   //   Ctrl-Keypad_8
#define K_CTRL_KEYPAD_9     70   //   Ctrl-Keypad_9
#define K_CTRL_KEYPAD_0     71   //   Ctrl-Keypad_0
#define K_CTRL_LEFT         72   //   Ctrl-LEFT
#define K_CTRL_UP           73   //   Ctrl-UP
#define K_CTRL_RIGHT        74   //   Ctrl-RIGHT
#define K_CTRL_DOWN         75   //   Ctrl-DOWN
#define K_CTRL_KEYPAD_LEFT  76   //   Ctrl-Keypad_LEFT
#define K_CTRL_KEYPAD_UP    77   //   Ctrl-Keypad_UP
#define K_CTRL_KEYPAD_RIGHT 78   //   Ctrl-Keypad_RIGHT
#define K_CTRL_KEYPAD_DOWN  79   //   Ctrl-Keypad_DOWN
                                                               
// Alt keys                                                    
#define K_ALT_A         286   //   Alt-A                       
#define K_ALT_B         304   //   Alt-B                       
#define K_ALT_C         302   //   Alt-C                       
#define K_ALT_D         288   //   Alt-D                       
#define K_ALT_E         274   //   Alt-E                       
#define K_ALT_F         289   //   Alt-F                       
#define K_ALT_G         290   //   Alt-G                       
#define K_ALT_H         291   //   Alt-H                       
#define K_ALT_I         279   //   Alt-I                       
#define K_ALT_J         292   //   Alt-J                       
#define K_ALT_K         293   //   Alt-K                       
#define K_ALT_L         294   //   Alt-L                       
#define K_ALT_M         306   //   Alt-M                       
#define K_ALT_N         305   //   Alt-N                       
#define K_ALT_O         280   //   Alt-O                       
#define K_ALT_P         281   //   Alt-P                       
#define K_ALT_Q         272   //   Alt-Q                       
#define K_ALT_R         275   //   Alt-R                       
#define K_ALT_S         287   //   Alt-S                       
#define K_ALT_T         276   //   Alt-T                       
#define K_ALT_U         278   //   Alt-U                       
#define K_ALT_V         303   //   Alt-V                       
#define K_ALT_W         273   //   Alt-W                       
#define K_ALT_X         301   //   Alt-X                       
#define K_ALT_Y         277   //   Alt-Y                       
#define K_ALT_Z         300   //   Alt-Z                       
                                                               
// Control-function keys                                       
#define K_CTRL_F1       -20   //   Ctrl-F1                     
#define K_CTRL_F2       -21   //   Ctrl-F2                     
#define K_CTRL_F3       -22   //   Ctrl-F4                     
#define K_CTRL_F4       -23   //   Ctrl-F3                     
#define K_CTRL_F5       -24   //   Ctrl-F5                     
#define K_CTRL_F6       -25   //   Ctrl-F6                     
#define K_CTRL_F7       -26   //   Ctrl-F7                     
#define K_CTRL_F8       -27   //   Ctrl-F8                     
#define K_CTRL_F9       -28   //   Ctrl-F9                     
#define K_CTRL_F10      -29   //   Ctrl-F10                    
#define K_CTRL_F11      -44   // * Ctrl-F11                    
#define K_CTRL_F12      -45   // * Ctrl-F12                    
                                                               
// Alt-function keys                                           
#define K_ALT_F1       -30   //   Alt-F1                       
#define K_ALT_F2       -31   //   Alt-F2                       
#define K_ALT_F3       -32   //   Alt-F3                       
#define K_ALT_F4       -33   //   Alt-F4                       
#define K_ALT_F5       -34   //   Alt-F5                       
#define K_ALT_F6       -35   //   Alt-F6                       
#define K_ALT_F7       -36   //   Alt-F7                       
#define K_ALT_F8       -37   //   Alt-F8                       
#define K_ALT_F9       -38   //   Alt-F9                       
#define K_ALT_F10      -39   //   Alt-F10                      
#define K_ALT_F11      -46   // * Alt-F11                      
#define K_ALT_F12      -47   // * Alt-F12                      
                                                               
// Shift-function keys                                         
#define K_SH_F1       -10   //   Shift-F1                      
#define K_SH_F2       -11   //   Shift-F2                      
#define K_SH_F3       -12   //   Shift-F3                      
#define K_SH_F4       -13   //   Shift-F4                      
#define K_SH_F5       -14   //   Shift-F5                      
#define K_SH_F6       -15   //   Shift-F6                      
#define K_SH_F7       -16   //   Shift-F7                      
#define K_SH_F8       -17   //   Shift-F8                      
#define K_SH_F9       -18   //   Shift-F9                      
#define K_SH_F10      -19   //   Shift-F10                     
#define K_SH_F11      -42   // * Shift-F11                     
#define K_SH_F12      -43   // * Shift-F12                     

#endif
