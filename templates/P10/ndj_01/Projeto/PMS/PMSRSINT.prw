#INCLUDE "NDJ.CH"

//===================================================================== */
/* ==================================================================== */
User Function PMSRSINT
/* ==================================================================== */
//===================================================================== */
Private oProjDe     := NIL
Private oProjAte    := NIL	
Private oOriDe      := NIL	
Private oOriAte     := NIL	
Private cProjDe     := Space(10)
Private cProjAte    := Space(10)
Private cOriDe      := Space(03)
Private cOriAte     := Space(03)
Private cFiltroBrow := "" 
Private cIDUsuario  := RetCodUsr()

Private cNmArqProj  := ""
Private cNmArqGrid  := ""

bBloco := { |lEnd| ExbConsole() }
MsAguarde(bBloco,"Aguarde",OemToAnsi("Visão Gerencial - Catalogando projetos..."),.F.)

Return( Nil )

/* --------------------------------------------------------------------- */
/* --------------------------------------------------------------------- */
STATIC Function aBrowMarca( cAlias, cMarca, nMarca, lTodos, lInverte )
/* --------------------------------------------------------------------- */
/* --------------------------------------------------------------------- */
LOCAL lSavTTS
LOCAL nRec
LOCAL cAliasAnt  := Alias()

DEFAULT lInverte := .F.
DEFAULT lTodos   := .T.

lSavTTS    := __TTSInUse
__TTSInUse := .F.

DBSelectArea(cAlias)
nRec := Recno()

If lTodos
   ( cNmArqGrid )->(dbGoTop())
   Do While ( cNmArqGrid )->(!Eof())
      Reclock(cNmArqGrid,.F.)
      
      If lInverte             
         
         If ( ( cNmArqGrid )->MARK == ThisMark() )
         
            ( cNmArqGrid )->MARK := ""
         Else
            ( cNmArqGrid )->MARK := cMarca          
         EndIf               

      Else
         If ( nMarca == 0 )         
         
            ( cNmArqGrid )->MARK := ""
         Else 
            ( cNmArqGrid )->MARK := cMarca 
         EndIf   
      EndIf
      ( cNmArqGrid )->(MsUnlock())
      ( cNmArqGrid )->(dbSkip())
   Enddo
   ( cNmArqGrid )->(dbGoTop())
Else
   Reclock(cNmArqGrid,.F.)
   
   If lInverte 

      If ( ( cNmArqGrid )->MARK == ThisMark() )
      
         ( cNmArqGrid )->MARK := ""
      Else
         ( cNmArqGrid )->MARK := cMarca          
      EndIf               

   Else
      If ( nMarca == 0 )
      
         ( cNmArqGrid )->MARK := ""
      Else 
         ( cNmArqGrid )->MARK := cMarca 
      EndIf   
   EndIf
   ( cNmArqGrid )->(MsUnlock())
Endif

( cNmArqGrid )->( DBGoto( nRec ) )

__TTSInUse := lSavTTS

DBSelectArea( cAliasAnt )

Return

/* --------------------------------------------------------------------- */
/* --------------------------------------------------------------------- */
Static Function fMarca()                                                  
/* --------------------------------------------------------------------- */
/* --------------------------------------------------------------------- */
Local bBloco := { |lEnd| aBrowMarca( cNmArqGrid, cMarca, 1, .T., .F. ) }

MsAguarde(bBloco,"Aguarde",OemToAnsi("Marcando..."),.F.)   

Return

/* --------------------------------------------------------------------- */
/* --------------------------------------------------------------------- */
Static Function fDesMarca()                                               
/* --------------------------------------------------------------------- */ 
/* --------------------------------------------------------------------- */
Local bBloco := { |lEnd| aBrowMarca( cNmArqGrid, cMarca, 0, .T., .F. ) }

MsAguarde(bBloco,"Aguarde",OemToAnsi("Desmarcando..."),.F.)

Return

/* --------------------------------------------------------------------- */
/* --------------------------------------------------------------------- */
Static Function fInverte()                                               
/* --------------------------------------------------------------------- */ 
/* --------------------------------------------------------------------- */
Local bBloco := { |lEnd| aBrowMarca( cNmArqGrid, cMarca, NIL, .T., .T. ) }

MsAguarde(bBloco,"Aguarde",OemToAnsi("Invertendo Marcações..."),.F.)

Return

/* --------------------------------------------------------------------- */
/* --------------------------------------------------------------------- */
Static Function fPosCombo()
/* --------------------------------------------------------------------- */ 
/* --------------------------------------------------------------------- */
Local nPosCombo

For nPosCombo := 1 To Len(aGrupos)

	If ( cGrupo == aGrupos[ nPosCombo ] )
	
  	   Exit
	Endif	
Next nPosCombo

Return nPosCombo
   
/* --------------------------------------------------------------------- */
/* --------------------------------------------------------------------- */
Static Function ChgColBrow()
/* --------------------------------------------------------------------- */
/* --------------------------------------------------------------------- */
Local nPosCombo := fPosCombo()  
Local aIndex    := {}

If ( cFiltroBrow <> "" )

   cFiltroBrow := ""

   EndFilBrw( cNmArqGrid, aIndex )

   aIndex      := {}

   Eval( {|| FilBrowse( cNmArqGrid, @aIndex, @cFiltroBrow ) } )

   ( cNmArqProj )->( DBGoTop() )
EndIf
   
oMark1:oBrowse:Hide()
oMark2:oBrowse:Hide()
oMark3:oBrowse:Hide()
oMark4:oBrowse:Hide()
oMark5:oBrowse:Hide()
oMark6:oBrowse:Hide()
oMark7:oBrowse:Hide()
oMark8:oBrowse:Hide()

( cNmArqProj )->( DBCloseArea() )

bBloco := { |lEnd| AbreQuery() }
MsAguarde(bBloco,"Aguarde",OemToAnsi("Catalogando..."),.F.)   

( cNmArqGrid )->( DBGOTOP() )

Do Case
   Case nPosCombo = 1
        oMark1:oBrowse:Show()
        oMark1:oBrowse:Refresh()        
        
   Case nPosCombo = 2
        oMark2:oBrowse:Show()
        oMark2:oBrowse:Refresh()                
        
   Case nPosCombo = 3
        oMark3:oBrowse:Show()     
        oMark3:oBrowse:Refresh()                
        
   Case nPosCombo = 4
        oMark4:oBrowse:Show()
        oMark4:oBrowse:Refresh()                        
        
   Case nPosCombo = 5
        oMark5:oBrowse:Show()
        oMark5:oBrowse:Refresh()                        
        
   Case nPosCombo = 6
        oMark6:oBrowse:Show()     
        oMark6:oBrowse:Refresh()                        
        
   Case nPosCombo = 7
        oMark7:oBrowse:Show()
        oMark7:oBrowse:Refresh()                                

   Case nPosCombo = 8
        oMark8:oBrowse:Show()
        oMark8:oBrowse:Refresh()
EndCase

Return                    

/* --------------------------------------------------------------------- */
/* --------------------------------------------------------------------- */
Static Function MontaWhere()
/* --------------------------------------------------------------------- */
/* --------------------------------------------------------------------- */
Local nRegistro   := Recno()
Local cMontaWhere := "WHERE "
Local cRegistros  := ""
Local nPosCombo   := fPosCombo()

( cNmArqGrid )->( DBGoTop() )
Do While ( cNmArqGrid )->(! Eof() )

   If ( Alltrim( ( cNmArqGrid )->MARK ) <> "" )      
      
      Do Case
         Case nPosCombo = 1 //"Por Projetos"                   
             cRegistros += "'"+( cNmArqGrid )->AF8PROJET+"', "
        
         Case nPosCombo = 2 //"Por Origem de Recurso" 
             cRegistros += "'"+( cNmArqGrid )->AF8XCODOR+"', "
   
         Case nPosCombo = 3 //"Por Tema Estratégico"  
             cRegistros += "'"+( cNmArqGrid )->AF8XCODTE+"', "
   
         Case nPosCombo = 4 //"Por Tipo de Ação"      
             cRegistros += "'"+( cNmArqGrid )->AF8XCODTA+"', "

         Case nPosCombo = 5 //"Por Indicador"                             
             cRegistros += "'"+( cNmArqGrid )->AF8XCODIN+"', "

         Case nPosCombo = 6 //"Por Sponsor"           
             cRegistros += "'"+( cNmArqGrid )->AF8XCODSP+"', "

         Case nPosCombo = 7 //"Por Gerente"                   
             cRegistros += "'"+( cNmArqGrid )->AF8XCODGE+"', "
             
         Case nPosCombo = 8 //"Por Macro Processo"                   
             cRegistros += "'"+( cNmArqGrid )->AF8XCODMA+"', "             
      EndCase
   EndIf
   ( cNmArqGrid )->( DBSkip() )
Enddo

cRegistros := Alltrim( cRegistros )

If ( Right( cRegistros, 1 ) == "," )
   cRegistros := SubString( cRegistros, 1, Len( cRegistros ) - 1 )
EndIf

Do Case
   Case nPosCombo = 1 //"Por Projetos"                   
        cMontaWhere += "AF8_PROJET IN ( " + cRegistros + " )"
        
   Case nPosCombo = 2 //"Por Origem de Recurso" 
        cMontaWhere += "AF8_XCODOR IN ( " + cRegistros + " )"
   
   Case nPosCombo = 3 //"Por Tema Estratégico"  
        cMontaWhere += "AF8_XCODTE IN ( " + cRegistros + " )"
   
   Case nPosCombo = 4 //"Por Tipo de Ação"      
        cMontaWhere += "AF8_XCODTA IN ( " + cRegistros + " )"

   Case nPosCombo = 5 //"Por Indicador"                             
        cMontaWhere += "AF8_XCODIN IN ( " + cRegistros + " )"

   Case nPosCombo = 6 //"Por Sponsor"           
        cMontaWhere += "AF8_XCODSP IN ( " + cRegistros + " )"

   Case nPosCombo = 7 //"Por Gerente"                   
        cMontaWhere += "AF8_XCODGE IN ( " + cRegistros + " )"        
        
   Case nPosCombo = 8 //"Por Macro Processo"                   
        cMontaWhere += "AF8_XCODMA IN ( " + cRegistros + " )"                
EndCase                                                     

( cNmArqGrid )->( DBGoto( nRegistro ) )

Return cMontaWhere

/* --------------------------------------------------------------------- */
/* --------------------------------------------------------------------- */
Static Function BuscaColBrow( nPosCombo )
/* --------------------------------------------------------------------- */
/* --------------------------------------------------------------------- */
Default nPosCombo := fPosCombo()

aCampos := {}
AADD( aCampos, { "MARK", "", "Selecionar" , "" })
   
Do Case                             
   Case nPosCombo = 1 //"Por Projetos"          
        AADD( aCampos, { "AF8PROJET", "", OemToAnsi("Id Projeto") 	       , "" })
        AADD( aCampos, { "AF8DESCRI", "", OemToAnsi("Projeto")             , "" })
        
   Case nPosCombo = 2 //"Por Origem de Recurso" 
        AADD( aCampos, { "AF8XCODOR", "", OemToAnsi("Id Origem de Recurso"), "" })
        AADD( aCampos, { "AF8XDORIG", "", OemToAnsi("Origem de Recurso")   , "" })
   
   Case nPosCombo = 3 //"Por Tema Estratégico"  
        AADD( aCampos, { "AF8XCODTE", "", OemToAnsi("Id Tema Estatégico")  , "" })
        AADD( aCampos, { "AF8XTEMA" , "", OemToAnsi("Tema Estatégico")	   , "" })
   
   Case nPosCombo = 4 //"Por Tipo de Ação"      
        AADD( aCampos, { "AF8XCODTA", "", OemToAnsi("Id Tipo de Ação")	   , "" })
        AADD( aCampos, { "AF8XDESTA", "", OemToAnsi("Tipo de Ação")	       , "" })

   Case nPosCombo = 5 //"Por Indicador"                             
        AADD( aCampos, { "AF8XCODIN", "", OemToAnsi("Id Indicador")	       , "" })
        AADD( aCampos, { "AF8XIND"  , "", OemToAnsi("Indicador")	       , "" })
      
   Case nPosCombo = 6 //"Por Sponsor"           
        AADD( aCampos, { "AF8XCODSP", "", OemToAnsi("Id Sponsor")	       , "" })
        AADD( aCampos, { "AF8XSPON" , "", OemToAnsi("Sponsor")	           , "" })
        
   Case nPosCombo = 7 //"Por Gerente"                   
        AADD( aCampos, { "AF8XCODGE", "", OemToAnsi("Id Gerente")          , "" })
        AADD( aCampos, { "AF8XGER"  , "", OemToAnsi("Gerente")	           , "" })        
        
   Case nPosCombo = 8 //"Por Macro Processo"                   
        AADD( aCampos, { "AF8XCODMA", "", OemToAnsi("Id Macro Processo")   , "" })
        AADD( aCampos, { "AF8XMACRO", "", OemToAnsi("Macro Processo")      , "" })                
EndCase                         

Return aCampos                                  

/* --------------------------------------------------------------------- */
/* --------------------------------------------------------------------- */
Static Function AbreQuery()
/* --------------------------------------------------------------------- */
/* --------------------------------------------------------------------- */
Local nPosCombo    := fPosCombo()
Local cQuery       := ""
Local cQryProjUsu  := ""
Local lSmartFilter := .F.

DBSelectArea(cNmArqGrid)
( cNmArqGrid )->( DBGOTOP() )
Do While ( cNmArqGrid )->(!Eof())
   RECLOCK( cNmArqGrid, .F. )
   ( cNmArqGrid )->( DBDelete() )
   MSUNLOCK()
   ( cNmArqGrid )->( DBSkip() )
EndDo

If ( ( nPosCombo = Nil ) .Or. ( nPosCombo > 8 ) )
   nPosCombo := 1
EndIf

Do Case
   Case nPosCombo = 1 
        cQuery := MemoRead( "\SQL\porprojeto.sql" )
   Case nPosCombo = 2 
        cQuery := MemoRead( "\SQL\pororigem.sql" )
   Case nPosCombo = 3 
        cQuery := MemoRead( "\SQL\portema.sql" )
   Case nPosCombo = 4
        cQuery := MemoRead( "\SQL\portipoacao.sql" )
   Case nPosCombo = 5
        cQuery := MemoRead( "\SQL\porindicador.sql" )
   Case nPosCombo = 6
        cQuery := MemoRead( "\SQL\porsponsor.sql" )
   Case nPosCombo = 7
        cQuery := MemoRead( "\SQL\porgerente.sql" )
   Case nPosCombo = 8
        cQuery := MemoRead( "\SQL\pormacroproc.sql" )
EndCase        
   
lSmartFilter := GetMV("MV_SMRTFIL")
   
If ( AT( "@USERID", cQuery ) <> 0 )

   If lSmartFilter
      
      cQryProjUsu := "   AND AF8.AF8_PROJET IN ( SELECT AFX_PROJET "
      cQryProjUsu += "                             FROM AFX010 AS AFX "
      cQryProjUsu += "                            WHERE AFX.D_E_L_E_T_ = '' " 
      cQryProjUsu += "                              AND AFX.AFX_FASE   = '03' "
      cQryProjUsu += "                              AND AFX_USER       = '" + cIDUsuario + "' )"

      cQuery      := STUFF( cQuery, AT( "@USERID", cQuery ), 7, cQryProjUsu )
   Else
      cQuery      := STUFF( cQuery, AT( "@USERID", cQuery ), 7, "" )
   EndIf
EndIf

cNmArqProj := Alltrim( CriaTrab(,.F.) )
DBUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery), cNmArqProj, .F., .T.)   

COUNT TO nRecCount

If ( nRecCount == 0 )
   MsgStop("Não foi possível iniciar o aplicativo!")
   ( cNmArqProj )->(DBCloseArea())
   ( cNmArqGrid )->(DBCloseArea())
Else
   ( cNmArqProj )->( DBGoTop() )

   Do While ( cNmArqProj )->(!Eof())   

      Do Case
         Case nPosCombo = 1 //"Por Projetos"          
              cAF8PROJET := ( cNmArqProj )->AF8_PROJET
              cAF8DESCRI := ( cNmArqProj )->AF8_DESCRI              
              cAF8REVISA := ( cNmArqProj )->AF8_REVISA
        
         Case nPosCombo = 2 //"Por Origem de Recurso" 
              cAF8XCODOR := ( cNmArqProj )->AF8_XCODOR
              cAF8XDORIG := ( cNmArqProj )->AF8_XDORIG                                
   
         Case nPosCombo = 3 //"Por Tema Estratégico"  
              cAF8XCODTE := ( cNmArqProj )->AF8_XCODTE
              cAF8XTEMA  := ( cNmArqProj )->AF8_XTEMA                                 
   
         Case nPosCombo = 4 //"Por Tipo de Ação"      
              cAF8XCODTA := ( cNmArqProj )->AF8_XCODTA
              cAF8XDESTA := ( cNmArqProj )->AF8_XDESTA                                 

         Case nPosCombo = 5 //"Por Indicador"                             
              cAF8XCODIN := ( cNmArqProj )->AF8_XCODIN
              cAF8XIND   := ( cNmArqProj )->AF8_XIND                                  
      
         Case nPosCombo = 6 //"Por Sponsor"           
              cAF8XCODSP := ( cNmArqProj )->AF8_XCODSP
              cAF8XSPON  := ( cNmArqProj )->AF8_XSPON                                  
        
         Case nPosCombo = 7 //"Por Gerente"                   
              cAF8XCODGE := ( cNmArqProj )->AF8_XCODGE
              cAF8XGER   := ( cNmArqProj )->AF8_XGER                                                      

         Case nPosCombo = 8 //"Por Macro Processo"                   
              cAF8XCODMA := ( cNmArqProj )->AF8_XCODMA
              cAF8XMACRO := ( cNmArqProj )->AF8_XMACRO                                 
      EndCase
      
      DBSelectArea(cNmArqGrid)
  	  RECLOCK( cNmArqGrid, .T. )

      Do Case
         Case nPosCombo = 1 //"Por Projetos"          
              ( cNmArqGrid )->AF8PROJET := cAF8PROJET
              ( cNmArqGrid )->AF8REVISA := cAF8REVISA              
              ( cNmArqGrid )->AF8DESCRI := cAF8DESCRI     
        
         Case nPosCombo = 2 //"Por Origem de Recurso" 
              ( cNmArqGrid )->AF8XCODOR := cAF8XCODOR
              ( cNmArqGrid )->AF8XDORIG := cAF8XDORIG
   
         Case nPosCombo = 3 //"Por Tema Estratégico"  
              ( cNmArqGrid )->AF8XCODTE := cAF8XCODTE
              ( cNmArqGrid )->AF8XTEMA  := cAF8XTEMA
   
         Case nPosCombo = 4 //"Por Tipo de Ação"      
              ( cNmArqGrid )->AF8XCODTA := cAF8XCODTA
              ( cNmArqGrid )->AF8XDESTA := cAF8XDESTA

         Case nPosCombo = 5 //"Por Indicador"                             
              ( cNmArqGrid )->AF8XCODIN := cAF8XCODIN
              ( cNmArqGrid )->AF8XIND   := cAF8XIND
      
         Case nPosCombo = 6 //"Por Sponsor"           
              ( cNmArqGrid )->AF8XCODSP := cAF8XCODSP
              ( cNmArqGrid )->AF8XSPON  := cAF8XSPON
        
         Case nPosCombo = 7 //"Por Gerente"                   
              ( cNmArqGrid )->AF8XCODGE := cAF8XCODGE
              ( cNmArqGrid )->AF8XGER   := cAF8XGER 
              
         Case nPosCombo = 8 //"Por Macro Processo"                   
              ( cNmArqGrid )->AF8XCODMA := cAF8XCODMA
              ( cNmArqGrid )->AF8XMACRO := cAF8XMACRO
      EndCase

	  MSUNLOCK()
	 
	  DBSelectArea(cNmArqProj)
	  ( cNmArqProj )->( DBSkip() )
   EndDo
        
   DBSelectArea(cNmArqGrid)
   ( cNmArqGrid )->( DBGoTop() )   

   Do Case
      Case nPosCombo = 1 //"Por Projetos"           
           DBCreateIndex( cNmInd2 := CriaTrab( NIL, .F. ), "AF8DESCRI", { || AF8DESCRI } )
           DBCreateIndex( cNmInd1 := CriaTrab( NIL, .F. ), "AF8PROJET", { || AF8PROJET } )           
           DBSetIndex( cNmInd1 )
           DBSetIndex( cNmInd2 ) 
           DBSetOrder( 2 )                     
        
      Case nPosCombo = 2 //"Por Origem de Recurso" 
           DBCreateIndex( cNmInd4 := CriaTrab( NIL, .F. ), "AF8XDORIG", { || AF8XDORIG } )            
           DBCreateIndex( cNmInd3 := CriaTrab( NIL, .F. ), "AF8XCODOR", { || AF8XCODOR } ) 
           DBSetIndex( cNmInd3 )
           DBSetIndex( cNmInd4 ) 
           DBSetOrder( 2 )                     
   
      Case nPosCombo = 3 //"Por Tema Estratégico"                                           
           DBCreateIndex( cNmInd6 := CriaTrab( NIL, .F. ), "AF8XTEMA" , { || AF8XTEMA  } )                
           DBCreateIndex( cNmInd5 := CriaTrab( NIL, .F. ), "AF8XCODTE", { || AF8XCODTE } ) 
           DBSetIndex( cNmInd5 )
           DBSetIndex( cNmInd6 ) 
           DBSetOrder( 2 )                     
   
      Case nPosCombo = 4 //"Por Tipo de Ação"      
           DBCreateIndex( cNmInd8 := CriaTrab( NIL, .F. ), "AF8XDESTA", { || AF8XDESTA } )
           DBCreateIndex( cNmInd7 := CriaTrab( NIL, .F. ), "AF8XCODTA", { || AF8XCODTA } )
           DBSetIndex( cNmInd7 )
           DBSetIndex( cNmInd8 ) 
           DBSetOrder( 2 )                     

      Case nPosCombo = 5 //"Por Indicador"                             
           DBCreateIndex( cNmInd0 := CriaTrab( NIL, .F. ), "AF8XIND"  , { || AF8XIND   } ) 
           DBCreateIndex( cNmInd9 := CriaTrab( NIL, .F. ), "AF8XCODIN", { || AF8XCODIN } ) 
           DBSetIndex( cNmInd9 )
           DBSetIndex( cNmInd0 ) 
                      
      Case nPosCombo = 6 //"Por Sponsor"
           DBCreateIndex( cNmIndB := CriaTrab( NIL, .F. ), "AF8XSPON" , { || AF8XSPON  } )
           DBCreateIndex( cNmIndA := CriaTrab( NIL, .F. ), "AF8XCODSP", { || AF8XCODSP } )
           DBSetIndex( cNmIndA )
           DBSetIndex( cNmIndB ) 
              
      Case nPosCombo = 7 //"Por Gerente"
           DBCreateIndex( cNmIndD := CriaTrab( NIL, .F. ), "AF8XGER"  , { || AF8XGER   } )
           DBCreateIndex( cNmIndC := CriaTrab( NIL, .F. ), "AF8XCODGE", { || AF8XCODGE } )
           DBSetIndex( cNmIndC )
           DBSetIndex( cNmIndD )            
                    
      Case nPosCombo = 8 //"Por Macro Processo"
           DBCreateIndex( cNmIndF := CriaTrab( NIL, .F. ), "AF8XMACRO", { || AF8XMACRO } )
           DBCreateIndex( cNmIndE := CriaTrab( NIL, .F. ), "AF8XCODMA", { || AF8XCODMA } )
           DBSetIndex( cNmIndE )
           DBSetIndex( cNmIndF )
   EndCase
   DBSetOrder( 2 )           
   
   ( cNmArqGrid )->( DBGOTOP() )

EndIf

Return

/* --------------------------------------------------------------------- */
/* --------------------------------------------------------------------- */
Static Function ExbConsole()
/* --------------------------------------------------------------------- */
/* --------------------------------------------------------------------- */
Local clblTpRel   := "Tipo de Relatório:"
Local clblPDe     := "Projeto De"
Local clblPAte    := "Projeto Ate"
Local clblORecDe  := "Origem do Recurso De"
Local clblORecAte := "Origem do Recurso Ate"
Local clblPeriodo := "Período:"
Local clblRadiPer := "Considerar período:"
Local clblTipRel  := "Layout do Relatório:"
Local clblNtsProj := "Considerar na geração do relatório:"

Local cQuery      := ""

Local aListBox1   := {}
Local aProjetos   := {}

Local oFont	      := NIL
Local oRadio	  := NIL	
Local oPeriodo	  := NIL	

Local oGrupo  	  := NIL
Local oTipRel     := NIL
Local oNotasProj  := NIL 

Local lInverte    := .F.

Local nRecCount
Local nOpc        := 0                      
Local nLinha
Local nPosCombo
Local nIndex 

Local cIndex      := ""
Local cChave      := ""

Local cAF1ORCAME  := ""
Local cAF8PROJET  := ""
Local cAF8REVISA  := ""
Local cAF8XCODOR  := ""
Local cAF1DESCRI  := ""
Local cAF1XCODOR  := ""

Local cAF1XDIR    := ""
Local cAF1XUNIOR  := ""
Local cAF8XCODSP  := ""
Local cAF8XSPON   := ""
Local cAF1XGER    := ""
Local cAF1XDESTA  := ""
Local cAF1XMACRO  := ""
Local cAF1XTEMA   := ""
Local cAF1XDESC   := ""
Local cAF1XDPROG  := ""
Local cAF1XDATIN  := ""
Local cAF1XDATFI  := ""
Local cAF1FASE    := ""
Local cAF1XSTATU  := ""
Local cAF1XPRIO   := ""
Local cAF8DESCRI  := ""

Local cAF8XDORIG  := "" 
Local cAF8XCODTE  := ""
Local cAF8XTEMA   := ""
Local cAF8XCODTA  := ""
Local cAF8XDESTA  := ""
Local cAF8XCODIN  := ""
Local cAF8XIND    := ""
Local cAF8XINDS   := ""

Local cAF8XCODGE  := ""
Local cAF8XGER    := ""
Local cAF8XCODMA  := ""
Local cAF8XMACRO  := ""

Local cNmInd1     := ""
Local cNmInd2     := ""
Local cNmInd3     := ""
Local cNmInd4     := ""
Local cNmInd5     := ""
Local cNmInd6     := ""
Local cNmInd7     := ""
Local cNmInd8     := ""

Local _aSize      := {}

Local oPanel

Private nOpcRad	  := 1
Private nTipRel

Private cPeriodo  := ""
Private cNotasProj:= ""

Private aMeses    := { "Janeiro" , "Fevereiro", "Março" , "Abril"   , "Maio"   ,;
                       "Junho"   , "Julho"    , "Agosto", "Setembro", "Outubro",;
                       "Novembro", "Dezembro" }            

Private oMark1    := NIL
Private oMark2    := NIL
Private oMark3    := NIL
Private oMark4    := NIL
Private oMark5    := NIL
Private oMark6    := NIL
Private oMark7    := NIL
Private oMark8    := NIL

Private aNotasProj:= { "Todas as notas pagas do projeto",;
                       "Todas as notas do projeto" }

Private aGrupos   := { "Por Projetos"          ,;
                       "Por Origem de Recurso" ,;
                       "Por Tema Estratégico"  ,;
                       "Por Tipo de Ação"      ,;
                       "Por Indicador"         ,;                       
                       "Por Sponsor"           ,;                       
                       "Por Gerente"           ,;
                       "Por Macro Processo"     }

Private aCampos   := {}
Private cGrupo    := ""
Private cMarca    := GetMark()

cPeriodo          := aMeses[Month(Date())]

AADD( aProjetos, { "MARK"     , "C",  02, 0 } )
AADD( aProjetos, { "AF8PROJET", "C",  10, 0 } )
AADD( aProjetos, { "AF8REVISA", "C",  04, 0 } )
AADD( aProjetos, { "AF8DESCRI", "C",  90, 0 } )
AADD( aProjetos, { "AF8XCODOR", "C",  03, 0 } )
AADD( aProjetos, { "AF8XDORIG", "C",  40, 0 } )
AADD( aProjetos, { "AF8XCODTE", "C",  03, 0 } )
AADD( aProjetos, { "AF8XTEMA" , "C",  40, 0 } )
AADD( aProjetos, { "AF8XCODTA", "C",  03, 0 } )
AADD( aProjetos, { "AF8XDESTA", "C",  20, 0 } )
AADD( aProjetos, { "AF8XCODIN", "C",  03, 0 } )
AADD( aProjetos, { "AF8XIND"  , "C",  80, 0 } )
AADD( aProjetos, { "AF8XINDS" , "C",  80, 0 } )
AADD( aProjetos, { "AF8XCODSP", "C",  06, 0 } )
AADD( aProjetos, { "AF8XSPON" , "C",  30, 0 } )
AADD( aProjetos, { "AF8XCODGE", "C",  06, 0 } )
AADD( aProjetos, { "AF8XGER"  , "C",  30, 0 } )
AADD( aProjetos, { "AF8XCODMA", "C",  03, 0 } )
AADD( aProjetos, { "AF8XMACRO", "C",  80, 0 } )

cNmArqGrid := Alltrim( CriaTrab(,.F.) )

MsCreate( cNmArqGrid, aProjetos, "TOPCONN" ) 
DBUseArea( .T., "TOPCONN", cNmArqGrid, cNmArqGrid, .T., .F. ) 

AbreQuery()

_aSize     := MsAdvSize()
_aSize [1] := 1
_aSize [5] := 802

DEFINE MSDIALOG oDlg TITLE OemToAnsi("Visão Gerencial - Seleção/Impressão de Projetos do PA-2011 (PREVISTO X REALIZADO)") From _aSize [1], _aSize [1] TO _aSize [6], _aSize [5] OF oMainWnd PIXEL

@ 000,000 MSPANEL oPanel OF oDlg
oPanel:Align	:= CONTROL_ALIGN_ALLCLIENT

nLinha   := _aSize [1] + 4

@ nLinha,( _aSize [1] +  3  ) Say OemToAnsi(clblTpRel  )                   OF oPanel  SIZE 060,015 PIXEL FONT oFont COLOR CLR_HBLUE
@ nLinha,( _aSize [1] + 45  ) COMBOBOX oGrupo    Var cGrupo  ITEMS aGrupos OF oPanel  SIZE 060,015 PIXEL FONT oFont ON CHANGE ChgColBrow()
  
@ nLinha,( _aSize [1] + 109 ) Say OemToAnsi(clblPeriodo)                   OF oPanel  SIZE 060,015 PIXEL FONT oFont COLOR CLR_HBLUE
@ nLinha,( _aSize [1] + 130 ) COMBOBOX oPeriodo Var cPeriodo ITEMS aMeses  OF oPanel  SIZE 060,015 PIXEL FONT oFont

@ nLinha,( _aSize [1] + 193 ) SAY OemToAnsi(clblRadiPer)                   OF oPanel  SIZE 060,015 PIXEL FONT oFont COLOR CLR_HBLUE
@ nLinha,( _aSize [1] + 283 ) SAY OemToAnsi(clblTipRel)                    OF oPanel  SIZE 060,015 PIXEL FONT oFont COLOR CLR_HBLUE
@ nLinha := 3
@ nLinha,( _aSize [1] + 241 ) RADIO    oRadio   Var nOpcRad  ITEMS "Mensal","Acumulado"   ;
                                                          OF oPanel  SIZE 060,015
                                                                                                                    
nOpcRad  := 2

@ nLinha,( _aSize [1] + 332 ) RADIO    oTipRel  Var nTipRel  ITEMS "Sintético","Analítico";
                                                          OF oPanel  SIZE 060,015   
                                                                                                                          
@ ( _aSize [1] +  25 ),( _aSize [1] + 338 ) BUTTON OemToAnsi("Finalizar")             SIZE 060,015 FONT oPanel:oFont ACTION (nOpc:=2,oDlg:End());
                                                                                                                                              OF oDlg PIXEL
                                                                                                            
@ ( _aSize [1] +  45 ),( _aSize [1] + 338 ) BUTTON OemToAnsi("Desmarcar Todos")       SIZE 060,015 FONT oDlg:oFont ACTION fDesmarca()    OF oPanel PIXEL
@ ( _aSize [1] +  65 ),( _aSize [1] + 338 ) BUTTON OemToAnsi("Marcar Todos")          SIZE 060,015 FONT oDlg:oFont ACTION fMarca()       OF oPanel PIXEL
@ ( _aSize [1] +  85 ),( _aSize [1] + 338 ) BUTTON OemToAnsi("Inverter Marcações")    SIZE 060,015 FONT oDlg:oFont ACTION fInverte()     OF oPanel PIXEL
@ ( _aSize [1] + 105 ),( _aSize [1] + 338 ) BUTTON OemToAnsi("Filtrar Dados")         SIZE 060,015 FONT oDlg:oFont ACTION fFiltraBrow()  OF oPanel PIXEL
@ ( _aSize [1] + 125 ),( _aSize [1] + 338 ) BUTTON OemToAnsi("Gerar Relatório PDF")   SIZE 060,015 FONT oDlg:oFont ACTION MsAguarde( {|| VerIReport(2) }, "Aguarde", OemToAnsi("Gerando arquivo pdf..."     ), .F. ) OF oPanel PIXEL
@ ( _aSize [1] + 145 ),( _aSize [1] + 338 ) BUTTON OemToAnsi("Gerar Relatório EXCEL") SIZE 060,015 FONT oDlg:oFont ACTION MsAguarde( {|| VerIReport(3) }, "Aguarde", OemToAnsi("Gerando arquivo xls..."     ), .F. ) OF oPanel PIXEL

_aSize [4] -= 9

@ _aSize [4],( _aSize [1] +  3 ) Say OemToAnsi(clblNtsProj)                          OF oPanel  SIZE 100,015 PIXEL FONT oFont COLOR CLR_HBLUE
@ _aSize [4],( _aSize [1] + 89 ) COMBOBOX oNotasProj Var cNotasProj ITEMS aNotasProj OF oPanel  SIZE 100,015 PIXEL FONT oFont

_aSize [4] -= 5
_aSize [3] := 335

oMark2 := MSSelect():New( cNmArqGrid, "MARK",, BuscaColBrow( 2 ), @lInverte, @cMarca, { _aSize [1] +25, _aSize [1]+3, _aSize [4], _aSize [3] }, "( cNmArqGrid )->(DBGOTOP())","( cNmArqGrid )->(DBGOBOTTOM())",,, ) 
oMark2 :oBrowse:Hide()   
oMark2 :oBrowse:bHeaderClick := {|oBrow,nCol| OrdenaBrow( oBrow:nColPos := nCol ) }
oMark2 :oBrowse:SetHeaderImage( 2, "COLRIGHT" )
oMark2 :oBrowse:SetHeaderImage( 3, "COLDOWN"  )

oMark3 := MSSelect():New( cNmArqGrid, "MARK",, BuscaColBrow( 3 ), @lInverte, @cMarca, { _aSize [1] +25, _aSize [1]+3, _aSize [4], _aSize [3] }, "( cNmArqGrid )->(DBGOTOP())","( cNmArqGrid )->(DBGOBOTTOM())",,, )
oMark3 :oBrowse:Hide()
oMark3 :oBrowse:bHeaderClick := {|oBrow,nCol| OrdenaBrow( oBrow:nColPos := nCol ) }
oMark3 :oBrowse:SetHeaderImage( 2, "COLRIGHT" )
oMark3 :oBrowse:SetHeaderImage( 3, "COLDOWN"  )

oMark4 := MSSelect():New( cNmArqGrid, "MARK",, BuscaColBrow( 4 ), @lInverte, @cMarca, { _aSize [1] +25, _aSize [1]+3, _aSize [4], _aSize [3] }, "( cNmArqGrid )->(DBGOTOP())","( cNmArqGrid )->(DBGOBOTTOM())",,, )
oMark4 :oBrowse:Hide()   
oMark4 :oBrowse:bHeaderClick := {|oBrow,nCol| OrdenaBrow( oBrow:nColPos := nCol ) }
oMark4 :oBrowse:SetHeaderImage( 2, "COLRIGHT" )
oMark4 :oBrowse:SetHeaderImage( 3, "COLDOWN"  )

oMark5 := MSSelect():New( cNmArqGrid, "MARK",, BuscaColBrow( 5 ), @lInverte, @cMarca, { _aSize [1] +25, _aSize [1]+3, _aSize [4], _aSize [3] }, "( cNmArqGrid )->(DBGOTOP())","( cNmArqGrid )->(DBGOBOTTOM())",,, )
oMark5 :oBrowse:Hide()
oMark5 :oBrowse:bHeaderClick := {|oBrow,nCol| OrdenaBrow( oBrow:nColPos := nCol ) }
oMark5 :oBrowse:SetHeaderImage( 2, "COLRIGHT" )
oMark5 :oBrowse:SetHeaderImage( 3, "COLDOWN"  )

oMark6 := MSSelect():New( cNmArqGrid, "MARK",, BuscaColBrow( 6 ), @lInverte, @cMarca, { _aSize [1] +25, _aSize [1]+3, _aSize [4], _aSize [3] }, "( cNmArqGrid )->(DBGOTOP())","( cNmArqGrid )->(DBGOBOTTOM())",,, )
oMark6 :oBrowse:Hide()
oMark6 :oBrowse:bHeaderClick := {|oBrow,nCol| OrdenaBrow( oBrow:nColPos := nCol ) }
oMark6 :oBrowse:SetHeaderImage( 2, "COLRIGHT" )
oMark6 :oBrowse:SetHeaderImage( 3, "COLDOWN"  )

oMark7 := MSSelect():New( cNmArqGrid, "MARK",, BuscaColBrow( 7 ), @lInverte, @cMarca, { _aSize [1] +25, _aSize [1]+3, _aSize [4], _aSize [3] }, "( cNmArqGrid )->(DBGOTOP())","( cNmArqGrid )->(DBGOBOTTOM())",,, )
oMark7 :oBrowse:Hide()
oMark7 :oBrowse:bHeaderClick := {|oBrow,nCol| OrdenaBrow( oBrow:nColPos := nCol ) }
oMark7 :oBrowse:SetHeaderImage( 2, "COLRIGHT" )
oMark7 :oBrowse:SetHeaderImage( 3, "COLDOWN"  )

oMark8 := MSSelect():New( cNmArqGrid, "MARK",, BuscaColBrow( 8 ), @lInverte, @cMarca, { _aSize [1] +25, _aSize [1]+3, _aSize [4], _aSize [3] }, "( cNmArqGrid )->(DBGOTOP())","( cNmArqGrid )->(DBGOBOTTOM())",,, )
oMark8 :oBrowse:Hide()
oMark8 :oBrowse:bHeaderClick := {|oBrow,nCol| OrdenaBrow( oBrow:nColPos := nCol ) }
oMark8 :oBrowse:SetHeaderImage( 2, "COLRIGHT" )
oMark8 :oBrowse:SetHeaderImage( 3, "COLDOWN"  )

oMark1 := MSSelect():New( cNmArqGrid, "MARK",, BuscaColBrow( 1 ), @lInverte, @cMarca, { _aSize [1] +25, _aSize [1]+3, _aSize [4], _aSize [3] }, "( cNmArqGrid )->(DBGOTOP())","( cNmArqGrid )->(DBGOBOTTOM())",,, )
oMark1 :oBrowse:Show()
oMark1 :oBrowse:bHeaderClick := {|oBrow,nCol| OrdenaBrow( oBrow:nColPos := nCol ) }
oMark1 :oBrowse:SetHeaderImage( 2, "COLRIGHT" )
oMark1 :oBrowse:SetHeaderImage( 3, "COLDOWN"  )
   
( cNmArqGrid )->( DBGOTOP() )
                         	
ACTIVATE MSDIALOG oDlg

If ( nOpc == 2 )
   ( cNmArqProj )->(DBCloseArea())
   ( cNmArqGrid )->(DBCloseArea())
   MsErase(cNmArqProj,,"TOPCONN")
   MsErase(cNmArqGrid,,"TOPCONN")
EndIf           

Return( Nil )

/* --------------------------------------------------------------------- */
/* --------------------------------------------------------------------- */
Static Function fFiltraBrow()
/* --------------------------------------------------------------------- */
/* --------------------------------------------------------------------- */  
Local nPosCombo := fPosCombo()
Local aCampos   := {}  
Local aIndex    := {}
Local nIndAtivo

Do Case                             
   Case nPosCombo = 1 //"Por Projetos"          
        AADD( aCampos, { "AF8PROJET", OemToAnsi("Id Projeto") 	       , .T., 1, 10, "@9", "C", 0 } )
        AADD( aCampos, { "AF8DESCRI", OemToAnsi("Projeto")             , .T., 2, 90, "@!", "C", 0 } )
        
   Case nPosCombo = 2 //"Por Origem de Recurso" 
        AADD( aCampos, { "AF8XCODOR", OemToAnsi("Id Origem de Recurso"), .T., 1, 03, "@9", "C", 0 } )
        AADD( aCampos, { "AF8XDORIG", OemToAnsi("Origem de Recurso")   , .T., 2, 40, "@!", "C", 0 } )
   
   Case nPosCombo = 3 //"Por Tema Estratégico"  
        AADD( aCampos, { "AF8XCODTE", OemToAnsi("Id Tema Estatégico")  , .T., 1, 03, "@9", "C", 0 } )
        AADD( aCampos, { "AF8XTEMA" , OemToAnsi("Tema Estatégico")	   , .T., 2, 40, "@!", "C", 0 } )
   
   Case nPosCombo = 4 //"Por Tipo de Ação"      
        AADD( aCampos, { "AF8XCODTA", OemToAnsi("Id Tipo de Ação")	   , .T., 1, 03, "@9", "C", 0 } )
        AADD( aCampos, { "AF8XDESTA", OemToAnsi("Tipo de Ação")	       , .T., 2, 20, "@!", "C", 0 } )

   Case nPosCombo = 5 //"Por Indicador"                             
        AADD( aCampos, { "AF8XCODIN", OemToAnsi("Id Indicador")	       , .T., 1, 03, "@9", "C", 0 } )
        AADD( aCampos, { "AF8XIND"  , OemToAnsi("Indicador")	       , .T., 2, 80, "@!", "C", 0 } )
      
   Case nPosCombo = 6 //"Por Sponsor"           
        AADD( aCampos, { "AF8XCODSP", OemToAnsi("Id Sponsor")	       , .T., 1, 06, "@9", "C", 0 } )
        AADD( aCampos, { "AF8XSPON" , OemToAnsi("Sponsor")	           , .T., 2, 30, "@!", "C", 0 } )
        
   Case nPosCombo = 7 //"Por Gerente"                   
        AADD( aCampos, { "AF8XCODGE", OemToAnsi("Id Gerente")          , .T., 1, 06, "@9", "C", 0 } )
        AADD( aCampos, { "AF8XGER"  , OemToAnsi("Gerente")	           , .T., 2, 30, "@!", "C", 0 } )                
        
   Case nPosCombo = 8 //"Por Macro Processo"                   
        AADD( aCampos, { "AF8XCODMA", OemToAnsi("Id Macro Processo")   , .T., 1, 03, "@9", "C", 0 } )
        AADD( aCampos, { "AF8XMACRO", OemToAnsi("Macro Processo")      , .T., 2, 80, "@!", "C", 0 } )                      
EndCase                                          
      

cFiltroBrow := BuildExpr( ,,,, {|| &("cNmArqGrid->( DBGoTop() )")  } ,,, "Filtrar Grid",,, aCampos )

nIndAtivo   := IndexOrd()

EndFilBrw( cNmArqGrid, aIndex )

Eval( {|| FilBrowse( cNmArqGrid, @aIndex, @cFiltroBrow ) } )

OrdenaBrow( nIndAtivo + 1 )

Return                

/* --------------------------------------------------------------------- */
/* --------------------------------------------------------------------- */
Static Function OrdenaBrow( nColBrow )
/* --------------------------------------------------------------------- */
/* --------------------------------------------------------------------- */
Local nPosCombo := fPosCombo()

If ( nColBrow > 1 )

   nColBrow -= 1
   ( cNmArqGrid )->( DBSetOrder( nColBrow ) )
   ( cNmArqGrid )->( DBGoTop() )
   
   Do Case
      Case nPosCombo = 1 //"Por Projetos"
           oMark1:oBrowse:SetHeaderImage( ( nColBrow + 1 ), "COLDOWN" )
           oMark1:oBrowse:SetHeaderImage( If( ( nColBrow + 1 ) = 2, 3, 2 ), "COLRIGHT"  )  
           oMark1:oBrowse:Refresh()
                            
      Case nPosCombo = 2 //"Por Origem de Recurso"     
           oMark2:oBrowse:SetHeaderImage( ( nColBrow + 1 ), "COLDOWN" )
           oMark2:oBrowse:SetHeaderImage( If( ( nColBrow + 1 ) = 2, 3, 2 ), "COLRIGHT"  )  
           oMark2:oBrowse:Refresh()                       
      
      Case nPosCombo = 3 //"Por Tema Estratégico" 
           oMark3:oBrowse:SetHeaderImage( ( nColBrow + 1 ), "COLDOWN" )
           oMark3:oBrowse:SetHeaderImage( If( ( nColBrow + 1 ) = 2, 3, 2 ), "COLRIGHT"  )  
           oMark3:oBrowse:Refresh()                       

      Case nPosCombo = 4 //"Por Tipo de Ação"      
           oMark4:oBrowse:SetHeaderImage( ( nColBrow + 1 ), "COLDOWN" )
           oMark4:oBrowse:SetHeaderImage( If( ( nColBrow + 1 ) = 2, 3, 2 ), "COLRIGHT"  )  
           oMark4:oBrowse:Refresh()                       
                 
      Case nPosCombo = 5 //"Por Indicador"                               
           oMark5:oBrowse:SetHeaderImage( ( nColBrow + 1 ), "COLDOWN" )
           oMark5:oBrowse:SetHeaderImage( If( ( nColBrow + 1 ) = 2, 3, 2 ), "COLRIGHT"  )  
           oMark5:oBrowse:Refresh()                       
      
      Case nPosCombo = 6 //"Por Sponsor"                                 
           oMark6:oBrowse:SetHeaderImage( ( nColBrow + 1 ), "COLDOWN" )
           oMark6:oBrowse:SetHeaderImage( If( ( nColBrow + 1 ) = 2, 3, 2 ), "COLRIGHT"  )  
           oMark6:oBrowse:Refresh()                       
      
      Case nPosCombo = 7 //"Por Gerente"               			
           oMark7:oBrowse:SetHeaderImage( ( nColBrow + 1 ), "COLDOWN" )
           oMark7:oBrowse:SetHeaderImage( If( ( nColBrow + 1 ) = 2, 3, 2 ), "COLRIGHT"  )  
           oMark7:oBrowse:Refresh()                       
      
      Case nPosCombo = 8 //"Por Macro Processo"               			
           oMark8:oBrowse:SetHeaderImage( ( nColBrow + 1 ), "COLDOWN" )
           oMark8:oBrowse:SetHeaderImage( If( ( nColBrow + 1 ) = 2, 3, 2 ), "COLRIGHT"  )  
           oMark8:oBrowse:Refresh()           
   EndCase
         
EndIf

Return
   
/* --------------------------------------------------------------------- */
/* --------------------------------------------------------------------- */
Static Function VerIReport( nVisualiza )
/* --------------------------------------------------------------------- */
/* --------------------------------------------------------------------- */
Local nPosCombo    := fPosCombo()
Local lAoMenos1    := .F.
Local lExecJava    := .F.
Local lCopiouArq   := .F.
Local nRegistro    := Recno()
Local cRootPath      
Local cQuery       := ""
Local cQueryDet    := ""
Local cNmArqSQL    := ""
Local cNmArqSQLDET := ""
Local cParamRel    := ""
Local cDescRelat   := ""
Local cMasterDet   := ""
Local nPerCombo
Local nNotasProj        

If ( nVisualiza == 3 )
   If ! ApOleClient("MsExcel")
        MsgStop("Microsoft Excel não instalado.")
        Return
   EndIf
EndIf

If ( nTipRel == 2 .And. nPosCombo > 1 )

   MsgStop("Apenas o relatório analítico por projeto encontra-se disponível para consulta/impressão.")
   Return
Else   
	If ( nTipRel == 2 )
	
	  cDescRelat := "Relatório Analítico"
	Else
	  cDescRelat := "Relatório Sintético"
	EndIf

	( cNmArqGrid )->( DBGoTop() )
	Do While ( cNmArqGrid )->(! Eof() )     

	  If ( Alltrim( ( cNmArqGrid )->MARK ) <> "" )      
		 lAoMenos1 := .T.                      
	  EndIf   
	  ( cNmArqGrid )->( DBSkip() )           
	Enddo

	If ! lAoMenos1
	
	     MsgStop( OemToAnsi( "Não há nada selecionado!" ) )
	     ( cNmArqGrid )->( DBGOTO( nRegistro ) )      
	Else

	  For nNotasProj := 1 To Len(aNotasProj)

		  If ( cNotasProj == aNotasProj[ nNotasProj ] )
			 Exit
		  Endif	
	  Next nNotasProj
	  
	  If ( nNotasProj == 1 )

		 If ( nTipRel == 2 )                       
			cQuery    := MemoRead( "\SQL\DETirepropacao.sql" )
			cQueryDET := MemoRead( "\SQL\_irepropacaoDET.sql" ) 
		 Else
			cQuery := MemoRead( "\SQL\irepropacao.sql" )
		 EndIf
	  Else
	  
		 If ( nTipRel == 2 )                       
			cQuery    := MemoRead( "\SQL\DETirepvisaopms.sql" )
			cQueryDet := MemoRead( "\SQL\_irepvisaopmsDET.sql" )
		 Else
			cQuery := MemoRead( "\SQL\irepvisaopms.sql" )
		 EndIf
	  EndIf
	  
	  For nPerCombo := 1 To Len(aMeses)
		  If ( cPeriodo == aMeses[ nPerCombo ] )
			 Exit
		  Endif	
	  Next nPerCombo

	  cDataIni := "01/"+ALLTRIM(STR(nPerCombo))+"/"+ALLTRIM(STR(YEAR(DATE())))
	  cDataFin := "01/"+ALLTRIM(STR(nPerCombo))+"/"+ALLTRIM(STR(YEAR(DATE())))

	  cDataIni := DTOS(Firstday(CTOD(cDataIni)))
	  cDataFin := DTOS(Lastday (CTOD(cDataFin)))

	  If ( nOpcRad == 2 )
		 cDescRelat += " Acumulado ( "
		 cDataIni   := "'"+ "20110101" +"'"
		 cDataFin   := "'"+ cDataFin   +"'"
	  Else
		 cDescRelat += " Mensal ( "
		 cDataIni   := "'"+ cDataIni   +"'"
		 cDataFin   := "'"+ cDataFin   +"'"
	  EndIf

	  cDescRelat += cPeriodo + " )"

	  While ( AT( "@DATAINI", cQuery ) <> 0 )
		 cQuery := STUFF( cQuery, AT( "@DATAINI", cQuery ), 8, cDataIni )
	  EndDo                                               

	  While ( AT( "@DATAFIN", cQuery ) <> 0 )
		 cQuery := STUFF( cQuery, AT( "@DATAFIN", cQuery ), 8, cDataFin )
	  EndDo                                                     

	  cQuery += " "
	  cQuery += MontaWhere()
	  cQuery += " "

	  Do Case
		 Case nPosCombo = 1 //"Por Projetos"
			  cQuery += "ORDER BY AF8_PROJET, AF8_REVISA, AF8_XCODOR"
	          
		 Case nPosCombo = 2 //"Por Origem de Recurso"     
			  cQuery += "ORDER BY AF8_XCODOR, AF8_PROJET, AF8_REVISA"				                                                                                                   
	          
		 Case nPosCombo = 3 //"Por Tema Estratégico" 
			  cQuery += "ORDER BY AF8_XCODTE, AF8_PROJET, AF8_REVISA"	        
	          
		 Case nPosCombo = 4 //"Por Tipo de Ação"     
			  cQuery += "ORDER BY AF8_XCODTA, AF8_PROJET, AF8_REVISA"	   	   	      
	          
		 Case nPosCombo = 5 //"Por Indicador"                               
			  cQuery += "ORDER BY AF8_XCODIN, AF8_PROJET, AF8_REVISA"			    	      	      
	          
		 Case nPosCombo = 6 //"Por Sponsor"                                 
			  cQuery += "ORDER BY AF8_XCODSP, AF8_PROJET, AF8_REVISA"
	          
		 Case nPosCombo = 7 //"Por Gerente"               			
			  cQuery += "ORDER BY AF8_XCODGE, AF8_PROJET, AF8_REVISA"

		 Case nPosCombo = 8 //"Por Macro Processo"               			
			  cQuery += "ORDER BY AF8_XCODMA, AF8_PROJET, AF8_REVISA"
	  EndCase             
	  
	  cNmArqSQL   := Alltrim(CriaTrab(,.F.))+".sql"
	  MemoWrite( "\SQL\"+cNmArqSQL, cQuery )       
	  
	  If ( nTipRel == 2 )                       
		 cNmArqSQLDET := STUFF( cNmArqSQL, AT( ".", cNmArqSQL ), 1, "DET." )
		 MemoWrite( "\SQL\"+cNmArqSQLDET, cQueryDet )
	  EndIf

	  cRootPath   := GetSrvProfString( "ROOTPATH", "" )
	  
	  cDirFile    := cRootPath + "\web\reports\VerIReport\dist\VerIreport.jar"
	  
	  While ( AT( "\", cRootPath ) <> 0 )
		cRootPath := STUFF( cRootPath, AT( "\", cRootPath ), 1, "." )
	  EndDo                                               
	  
	  While ( AT( ".", cRootPath ) <> 0 )
		cRootPath := STUFF( cRootPath, AT( ".", cRootPath ), 1, "\\" )        
	  EndDo                                                           

	  cRootPath   := cRootPath + "\\web\\reports\\"
	  cParamRel   := AllTrim(Str(nPosCombo))
	  cVisualiza  := AllTrim(Str(nVisualiza))
	  cMasterDet  := AllTrim(Str(nTipRel))
	  
	  cString     := "'"
	  cString     += "JAVA.EXE -jar "
	  cString     += '"' + cDirFile   + '" '
	  cString     += '"' + cRootPath  + "VerIReport\\ireport.properties"+'" '
	  cString     += '"' + cNmArqSQL  + '" '
	  cString     += '"' + cParamRel  + '" '
	  cString     += '"' + cVisualiza + '" '
	  cString     += '"' + cMasterDet + '" '
	  cString     += '"' + "0"        + '" '

	  If ( nTipRel == 2 )
		 cString  += '"' + cDescRelat   + '" '
		 cString  += '"' + cNmArqSQLDET + '" '
	  Else
		 cString  += '"' + cDescRelat   + '" '
		 cString  += '"' + ""           + '" '
	  EndIf

	  cString     += '"' + AllTrim(Str(nNotasProj)) + '"'  
	  cString     += "'"
	                           
      lExecJava   := WAITRUNSRV( &cString, .T., "C:\" )
	  
      If ! lExecJava
   
           MsgStop( OemToAnsi( "Não foi possível gerar/exibir o relatório." ) )
           Return
      Else   

	     If ( cVisualiza == "2" )
		    cNmArq1  := "\web\reports\PDFTEMP\"+StrTran(cNmArqSQL,".sql","" )
 		    cNmArq1  := Substr( cNmArq1, 1, Len( cNmArq1 ) - 1 ) + ".pdf"
		    cNmArq2  := AllTrim(GetTempPath()) +StrTran(cNmArqSQL,".sql","" )
		    cNmArq2  := Substr( cNmArq2, 1, Len( cNmArq2 ) - 1 ) + ".pdf"         
	     Else 
		    cNmArq1  := "\web\reports\XLSTEMP\"+StrTran(cNmArqSQL,".sql","" )
		    cNmArq1  := Substr( cNmArq1, 1, Len( cNmArq1 ) - 1 ) + ".xls"
		    cNmArq2  := AllTrim(GetTempPath()) +StrTran(cNmArqSQL,".sql","" )
		    cNmArq2  := Substr( cNmArq2, 1, Len( cNmArq2 ) - 1 ) + ".xls" 
	     EndIf                                                                   

	     lCopiouArq  := __copyfile( cNmArq1, cNmArq2 )
	     
   	     FErase( "\SQL\"+cNmArqSQL )

	     If ( nTipRel == 2 )

		    FErase( "\SQL\"+cNmArqSQLDET )
	     EndIf
	  
	     FErase( cNmArq1 )	     
	           
         If ! lCopiouArq
   
              MsgStop( OemToAnsi( "Não foi possível gerar/exibir o relatório." ) )
              Return      
         Else   
                 	     
	        ShellExecute( "Open", cNmArq2, "", AllTrim(GetTempPath()), 1 )	                    
	     EndIf   	     
	     
	  EndIf
	  
	  ( cNmArqGrid )->( DBGOTOP() )	  
	EndIf
EndIf

Return

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
		lRecursa	:= __Dummy( .F. )
		__cCRLF		:= NIL
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )