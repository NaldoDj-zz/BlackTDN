// ######################################################################################
// Projeto: DATA WAREHOUSE
// Modulo : Ferramentas
// Fonte  : DWVersion - Definição de versão, release e build do SigaDW
// ---------+-------------------+--------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+--------------------------------------------------------
// 18.12.03 | 0548-Alan Candido |
// 27.09.05 | 0548-Alan Candido | versão 3.0
// --------------------------------------------------------------------------------------

#define VERSION  "3"
#define RELEASE  "00"
//#define DW_BETA_RELEASE // indica que é versão beta
#ifdef DW_BETA_RELEASE
  #define FASE   "R-4 beta"
#else
  #define FASE   "R-4"
#endif

#define ESTATISTICAS    // habilita processos estatisticos

#define BUILD    "061101"
