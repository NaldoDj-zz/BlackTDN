#define DMPAPER_LETTER      1           // Letter 8 1/2 x 11 in
#define DMPAPER_LETTERSMALL 2           // Letter Small 8 1/2 x 11 in
#define DMPAPER_TABLOID     3           // Tabloid 11 x 17 in
#define DMPAPER_LEDGER      4           // Ledger 17 x 11 in
#define DMPAPER_LEGAL       5           // Legal 8 1/2 x 14 in
#define DMPAPER_STATEMENT   6           // Statement 5 1/2 x 8 1/2 in
#define DMPAPER_EXECUTIVE   7           // Executive 7 1/4 x 10 1/2 in
#define DMPAPER_A3          8           // A3 297 x 420 mm
#define DMPAPER_A4          9           // A4 210 x 297 mm
#define DMPAPER_A4SMALL     10          // A4 Small 210 x 297 mm
#define DMPAPER_A5          11          // A5 148 x 210 mm
#define DMPAPER_B4          12          // B4 250 x 354
#define DMPAPER_B5          13          // B5 182 x 257 mm
#define DMPAPER_FOLIO       14          // Folio 8 1/2 x 13 in
#define DMPAPER_QUARTO      15          // Quarto 215 x 275 mm
#define DMPAPER_10X14       16          // 10x14 in
#define DMPAPER_11X17       17          // 11x17 in
#define DMPAPER_NOTE        18          // Note 8 1/2 x 11 in
#define DMPAPER_ENV_9       19          // Envelope #9 3 7/8 x 8 7/8
#define DMPAPER_ENV_10      20          // Envelope #10 4 1/8 x 9 1/2
#define DMPAPER_ENV_11      21          // Envelope #11 4 1/2 x 10 3/8
#define DMPAPER_ENV_12      22          // Envelope #12 4 \276 x 11
#define DMPAPER_ENV_14      23          // Envelope #14 5 x 11 1/2
#define DMPAPER_CSHEET      24          // C size sheet
#define DMPAPER_DSHEET      25          // D size sheet
#define DMPAPER_ESHEET      26          // E size sheet
#define DMPAPER_ENV_DL      27          // Envelope DL 110 x 220mm
#define DMPAPER_ENV_C5      28          // Envelope C5 162 x 229 mm
#define DMPAPER_ENV_C3      29          // Envelope C3  324 x 458 mm
#define DMPAPER_ENV_C4      30          // Envelope C4  229 x 324 mm
#define DMPAPER_ENV_C6      31          // Envelope C6  114 x 162 mm
#define DMPAPER_ENV_C65     32          // Envelope C65 114 x 229 mm
#define DMPAPER_ENV_B4      33          // Envelope B4  250 x 353 mm
#define DMPAPER_ENV_B5      34          // Envelope B5  176 x 250 mm
#define DMPAPER_ENV_B6      35          // Envelope B6  176 x 125 mm
#define DMPAPER_ENV_ITALY   36          // Envelope 110 x 230 mm
#define DMPAPER_ENV_MONARCH 37          // Envelope Monarch 3.875 x 7.5 in
#define DMPAPER_ENV_PERSONAL 38         // 6 3/4 Envelope 3 5/8 x 6 1/2 in
#define DMPAPER_FANFOLD_US  39          // US Std Fanfold 14 7/8 x 11 in
#define DMPAPER_FANFOLD_STD_GERMAN  40  // German Std Fanfold 8 1/2 x 12 in
#define DMPAPER_FANFOLD_LGL_GERMAN  41  // German Legal Fanfold 8 1/2 x 13 in

#define CELL_ALIGN_LEFT		1
#define CELL_ALIGN_CENTER	2
#define CELL_ALIGN_RIGHT	3

#define BORDER_NONE         0
#define BORDER_CONTINUOUS   1
#define BORDER_PARENT       2
#define BORDER_HEADERPARENT 3
#define BORDER_CELL         4
#define BORDER_FUNCTION     6
#define BORDER_SECTION      7

#define EDGE_TOP      1
#define EDGE_BOTTOM   2
#define EDGE_LEFT     3
#define EDGE_RIGHT    4
#define EDGE_ALL      5

#define NEGATIVE_PARENTHESES 1
#define NEGATIVE_SIGNAL      2

// Constantes para identificar o tipo de impressão.
#DEFINE IMP_DISCO 1
#DEFINE IMP_SPOOL 2
#DEFINE IMP_EMAIL 3
#DEFINE IMP_EXCEL 4
#DEFINE IMP_HTML  5
#DEFINE IMP_PDF   6
#DEFINE IMP_ODF   7
#DEFINE IMP_PDFMAIL 8
#DEFINE IMP_MAILCOMPROVA 9

//Constante contendo os tipos de impressão possiveis para o ECM
#DEFINE IMP_ECM				"4|5|6|7"

#DEFINE AMB_SERVER 1
#DEFINE AMB_CLIENT 2
#DEFINE AMB_ECM	   3

#DEFINE PORTRAIT  1
#DEFINE LANDSCAPE 2

#DEFINE NO_REMOTE     -1
#DEFINE REMOTE_DELPHI  0
#DEFINE REMOTE_QTWIN   1
#DEFINE REMOTE_QTLINUX 2

#DEFINE TYPE_CELL     1
#DEFINE TYPE_FORMULA  2
#DEFINE TYPE_FUNCTION 3
#DEFINE TYPE_USER     4

#DEFINE COLLECTION_VALUE   0
#DEFINE COLLECTION_REPORT  1
#DEFINE COLLECTION_SECTION 2
#DEFINE COLLECTION_PAGE    3

//------------------------------------
//Estrutura do array de tabelas
//------------------------------------
#DEFINE TSEEK	1
#DEFINE TCACHE	2
#DEFINE TSTRUCT	3

#DEFINE TALIAS	1
#DEFINE TDESC	2

//------------------------------------
//Estrutura do array de campos
//------------------------------------
#DEFINE FSTRUCTALL		1
#DEFINE FSTRUCTFIELD	2

#DEFINE FTITLE		1
#DEFINE FTOOLTIP	2
#DEFINE FFIELD		3
#DEFINE FTYPE		4
#DEFINE FSIZE		5
#DEFINE FDECIMAL	6
#DEFINE FCOMBOBOX	7
#DEFINE FOBRIGAT	8
#DEFINE FUSED		9
#DEFINE FCONTEXT	10
#DEFINE FNIVEL		11
#DEFINE FTABLE		12
#DEFINE FPICTURE	13
#DEFINE FCONPAD		14

//------------------------------------
//Estrutura do array de indices
//------------------------------------
#DEFINE ISTRUCTALL		1
#DEFINE ISTRUCTINDEX	2

#DEFINE IDESC	1
#DEFINE IKEY	2
#DEFINE IDESC	3
#DEFINE ITABLE	4

//------------------------------------
//Estrutura do array de perguntas
//------------------------------------
#DEFINE PGROUP		1
#DEFINE PORDER		2
#DEFINE PGSC		3
#DEFINE PTYPE		4
#DEFINE PDESC		5
#DEFINE PPERG1		6
#DEFINE PPERG2		7
#DEFINE PPERG3		8
#DEFINE PPERG4		9
#DEFINE PPERG5		10
#DEFINE PPYME		11
#DEFINE PPICTURE	12



