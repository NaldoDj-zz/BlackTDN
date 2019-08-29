#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/* ======================================================================================================== */
/* ======================================================================================================== */
User Function ATFCPATRI
/* ======================================================================================================== */
/* ======================================================================================================== */
Local   nVarNameLen       := SetVarNameLen( 100 )

Private oMarkBrowse       := NIL
Private oTipoDocumento    := NIL
Private oSitAlocacao      := NIL
Private oInstituicao      := NIL
Private oQtdVolumes       := Nil
Private oListaTransp      := Nil
Private oPnlInfo          := Nil

Private nTipRel
Private nOpcRad              := 1
Private nSeqNDocAlocacao  := 0
Private nTamNDocAlocacao  := 9
Private nTamNDocTransfere := 8
Private nQtdVolumes       := 0
Private nTlEdicTop
Private nTlEdicLeft
Private nTlEdicBott
Private nTlEdicRigt
Private nTlEdicLarg
Private nTlEdicAlt 

Private cBMPPath          := "\system\"
Private cTxtAbreTela      := OemToAnsi("Carregando dados...")
Private cTxtMarca         := OemToAnsi("Marcando...")
Private cTxtDesMarca      := OemToAnsi("Desmarcando...")
Private cTxtInvMarca      := OemToAnsi("Invertendo Marcações...")
Private cTxtAbreQry       := OemToAnsi("Catalogando...")
Private cTxtJanPrinc      := OemToAnsi("Ativos - Transferência")
Private cTxtJanGraficos   := OemToAnsi("Seleção/Impressão de Gráficos")
Private cMensSDados       := OemToAnsi("Não há nada selecionado!" )
Private cMensAguarde      := OemToAnsi("Aguarde" )
Private cMensRestriRelat  := OemToAnsi("Apenas o relatório analítico por projeto encontra-se disponível para consulta/impressão." )
Private cMensExcelNInst   := OemToAnsi("Microsoft Excel não instalado.")
Private cMensAmpliGraf    := OemToAnsi("Clique no gráfico, para que ele seja ampliado nesta área." )
Private cLblButFilGrid    := OemToAnsi("Filtrar Grid")
Private cFiltroBrow       := ""
Private cNmArqAtvImob     := ""
Private cPeriodo          := ""                   
Private cQryBrowse        := "\SQL\AtivosImob.sql"
Private cIDUsuario        := RetCodUsr()
Private cMarca            := GetMark()
Private cNDocAlocacao     := SPACE  ( nTamNDocAlocacao  )
Private cNDocTransfere    := SPACE  ( nTamNDocTransfere )
Private cTipoDocumento    := ""
Private cTranspTipoDoc    := ""
Private cSitAlocacao      := ""
Private cSeqNDocAlocacao  := ""
Private cSeqNDocTransfere := ""
Private cInstituicao      := ""
Private cTxtTit1ColBrow   := ""
Private cTxtTit2ColBrow   := "Numero Proc."
Private cTxtTit3ColBrow   := "Cod. do Bem"
Private cTxtTit4ColBrow   := "Descr. Sint."
Private cTxtTit5ColBrow   := "Nota Fiscal"
Private cTxtTit6ColBrow   := OemToAnsi( "Série N.F." )
Private cTxtTit7ColBrow   := "Num.Plaqueta"
Private cTxtTit8ColBrow   := "Marca"
Private cTxtTit9ColBrow   := "Modelo"
Private cTxtTitAColBrow   := OemToAnsi( "Num. Série" )
Private cTxtTitBColBrow   := OemToAnsi( "Doc. Alocação" )
Private cTxtTitCColBrow   := OemToAnsi( "Doc. Transporte" )
Private cListaTransp      := ""

Private aCampos           := {}
Private aInstAuxOrd1      := {}
Private aInstAuxOrd2      := {}
Private aTipoDocumento    := { "", "TRA", "LOG" }
Private aTranspTipoDoc    := { "", "ADP", "DEC" }
Private aSitAlocacao      := { "", "A - Alocação Nova", "B - Baixa de Itens", "C - Correções" }
Private aInstituicao      := {}
Private aInstitOrd1       := {}
Private aInstitOrd2       := {}                       
Private aSeqsTipoDoc      := {}
Private aSeqsTranTip      := {}
Private aAuxSqTipoDoc     := {}
Private aAuxSqTranTip     := {}
Private aListaTransp      := {}
Private aTrspAuxOrd1      := {}
Private aTrspAuxOrd2      := {}
Private aTranspOrd1       := {}
Private aTranspOrd2       := {}

Private lGravDocsAlocTran := .F.
Private lTelaModNormal    := .T.
Private lCargaCampos1Vez  := .T.
Private lSelTransp        := .F.

Private cNmArqGrid        := Alltrim( CriaTrab(,.F.) )

If ( fAbreTelaOpc() <> 0 )

   bBloco := { |lEnd| ConsoleOp() }
   MsAguarde( bBloco, cMensAguarde, cTxtAbreTela, .F. )
EndIf

SetVarNameLen( nVarNameLen )

Return( Nil )

/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
STATIC Function GetMark( lUpper, cAlias, cCampo )
/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Local cSavAlias := Alias()
Local cBytes    := "0123456789ABCDEFGHIJKLMNOPQRSTUVXYWZabcdefghijklmnopqrstuvxywz"
Local cMark
Local nMaxByte  := 62
Local nBytes    := 2, cField, uField, nMark, cNamePar := "MV_MARK"
Local lReSeek   := .f.
Local nR, nX, nMy

If ( cAlias != Nil .and. cCampo != Nil )

   cField := Alltrim(cAlias)+"->"+Alltrim(cCampo)
   
   IF Type(cField) == "C"

      uField := &cField
      nBytes := Len(uField)
      
      IF nBytes > 8

         UserException("Invalid Field Length in GetMark")
      Endif
      
      If ( nBytes > 2 )

         cNamePar := "MV_MARK"+Alltrim(Str(nBytes,1,0))
      EndIf      
  EndIf  
EndIf

nMark := GetMV(cNamePar)

While !RecLock("SX6")

  lReSeek := .t.
end             

nMark  := GetMV(cNamePar)

lUpper := If( lUpper==Nil , .F. , lUpper )

If ( lUpper )

   cBytes   := SubStr(cBytes,1,36)
   nMaxByte := 36
Endif

If ( (nMark+2) >= ( nMaxByte**nBytes ) )

   nMark := 0
Endif

nMark++
nMy    := nMark
cMark  := ""

While ( nMY > 61 )

  nX    := Int( nMy / nMaxByte)
  nR    := Round(nMY - ( nX * nMaxByte) ,0)
  cMark := Subs(cBytes,nR+1,1)+cMark
  nMy   := nX 
End      

cMark := Subs(cBytes,nMy+1,1)+cMark

IF Len(cMark) < nBytes

   cMark := Replicate("0",(nBytes - Len(cMark)))+cMark
Endif

Replace X6_CONTEUD with StrZero(nMark,12,0)
Replace X6_CONTENG with StrZero(nMark,12,0)
Replace X6_CONTSPA with StrZero(nMark,12,0)

MSrUnLock(Recno())

dbSelectArea(cSavAlias)

Return cMark

/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
STATIC Function aBrowMarca( cAlias, cMarca, nMarca, lTodos, lInverte )
/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
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

/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Static Function fMarca()                                                  
/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Local bBloco := { |lEnd| aBrowMarca( cNmArqGrid, cMarca, 1, .T., .F. ) }

MsAguarde( bBloco, cMensAguarde, cTxtMarca, .F. )
Return

/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Static Function fDesMarca()                                               
/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Local bBloco := { |lEnd| aBrowMarca( cNmArqGrid, cMarca, 0, .T., .F. ) }

MsAguarde( bBloco, cMensAguarde, cTxtDesMarca, .F. )
Return

/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Static Function fInverte()                                               
/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Local bBloco := { |lEnd| aBrowMarca( cNmArqGrid, cMarca, NIL, .T., .T. ) }

MsAguarde( bBloco, cMensAguarde, cTxtInvMarca, .F.)
Return

/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Static Function fPreenchVets()                                             
/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Local cNmArqCmbx   := Alltrim( CriaTrab(,.F.) )
Local cNmArqSA2    := ""
Local cQuerySA2    := ""
Local cQryCmbxInst := "\SQL\CmbxInstituicao.sql"
Local cQuery       := MemoRead( cQryCmbxInst )           
Local cQueryAux    := " ORDER BY A1_NOME"
Local cFotran      := ""
Local cSavAlias    := ""
Local nScan        := 0
Local nRecCount
Local nPosVetor
Local nVetorPos
Local lLeCmbInstit := .F.
              
cQueryAux     := cQuery + cQueryAux

DBUseArea( .T., "TOPCONN", TCGenQry(,,cQueryAux), cNmArqCmbx, .F., .T. )

COUNT TO nRecCount

If ( nRecCount == 0 )

   MsgStop( OemToAnsi( "Não foi possível iniciar o aplicativo!" ) )
   
   ( cNmArqCmbx )->( DBCloseArea() )

   MsErase( cNmArqCmbx,, "TOPCONN" )
Else
   ( cNmArqCmbx )->( DBGoTop() )
   
   cFoTran    := Alltrim( GetMV("NDJ_FOTRAN") ) //00012401,00079001,00020302,
   
   If ( ( cFoTran <> "" ) .AND. ( AT( ",", cFoTran ) <> 0 ) )

      If ( Right( cFoTran, 1 ) <> "," )
   
         cFoTran := cFoTran + ","
      EndIf   

      Do While ( cFoTran <> "" )
      
         AADD( aListaTransp, SubStr( cFoTran, 1, AT( ",", cFoTran ) - 1 ) )
         cFoTran := AllTrim( SubStr( cFoTran, AT( ",", cFoTran ) + 1, Len( cFoTran ) ) )
      EndDo
   EndIf

   ASort( aListaTransp )
   
   ASIZE( aInstAuxOrd1, ( nRecCount + 1 ) )
   ASIZE( aInstAuxOrd2, ( nRecCount + 1 ) )
   ASIZE( aInstitOrd1 , Len( aInstAuxOrd1 ) )
   ASIZE( aInstitOrd2 , Len( aInstAuxOrd2 ) )
         
   nPosVetor  := 2
               
   Do While ( cNmArqCmbx )->(!Eof())

      aInstAuxOrd1[nPosVetor]    := { "", "", "" }
            
      aInstAuxOrd1[nPosVetor][1] := ( cNmArqCmbx )->A1_COD
      aInstAuxOrd1[nPosVetor][2] := ( cNmArqCmbx )->A1_LOJA
      aInstAuxOrd1[nPosVetor][3] := ( cNmArqCmbx )->A1_NOME
      
      aInstitOrd1 [nPosVetor]    := aInstAuxOrd1[nPosVetor][1] + ' - ' + aInstAuxOrd1[nPosVetor][2] + ' - ' + aInstAuxOrd1[nPosVetor][3]
            
      nPosVetor += 1
   
      ( cNmArqCmbx )->( DBSkip() )
   EndDo
   
   ( cNmArqCmbx )->( DBCloseArea() )      

   MsErase( cNmArqCmbx,, "TOPCONN" )      
   
   cNmArqCmbx := Alltrim( CriaTrab(,.F.) )

   cQueryAux  := " ORDER BY A1_COD, A1_LOJA"

   cQueryAux  := cQuery + cQueryAux

   DBUseArea( .T., "TOPCONN", TCGenQry(,,cQueryAux), cNmArqCmbx, .F., .T. )      

   ( cNmArqCmbx )->( DBGoTop() )
        
   nPosVetor  := 2
   
   Do While ( cNmArqCmbx )->(!Eof())

      aInstAuxOrd2[nPosVetor]    := { "", "", "" }
            
      aInstAuxOrd2[nPosVetor][1] := ( cNmArqCmbx )->A1_COD
      aInstAuxOrd2[nPosVetor][2] := ( cNmArqCmbx )->A1_LOJA
      aInstAuxOrd2[nPosVetor][3] := ( cNmArqCmbx )->A1_NOME

      aInstitOrd2 [nPosVetor]    := aInstAuxOrd2[nPosVetor][1] + ' - ' + aInstAuxOrd2[nPosVetor][2] + ' - ' + aInstAuxOrd2[nPosVetor][3]
      
      nPosVetor += 1
   
      ( cNmArqCmbx )->( DBSkip() )
   EndDo

   ( cNmArqCmbx )->( DBCloseArea() )

   MsErase( cNmArqCmbx,, "TOPCONN" )
   
   If ( Len( aListaTransp ) > 0 )
         
      If lLeCmbInstit
   
         AADD( aTranspOrd2, "" )
    
         For nPosVetor := 1 To Len( aListaTransp )
          
             nScan     := 0
    
             For nVetorPos := 2 To Len( aInstAuxOrd2 )
    
                 If ( aInstAuxOrd2[nVetorPos][1]+aInstAuxOrd2[nVetorPos][2] == aListaTransp[nPosVetor] )
                  
                    nScan := nVetorPos
                    Exit
                 EndIf
             Next nVetorPos
              
             If ( nScan > 0 )
              
                AADD( aTrspAuxOrd2, { "", "", "" } )
                aTrspAuxOrd2[Len(aTrspAuxOrd2)][1] := aInstAuxOrd2[nScan][1]
                aTrspAuxOrd2[Len(aTrspAuxOrd2)][2] := aInstAuxOrd2[nScan][2]
                aTrspAuxOrd2[Len(aTrspAuxOrd2)][3] := aInstAuxOrd2[nScan][3]
                              
                If ( AllTrim( aTrspAuxOrd2[Len(aTrspAuxOrd2)][1] ) <> "" )
                 
                   AADD( aTranspOrd2, aTrspAuxOrd2[Len(aTrspAuxOrd2)][1] + ' - ' + aTrspAuxOrd2[Len(aTrspAuxOrd2)][2] + ' - ' + aTrspAuxOrd2[Len(aTrspAuxOrd2)][3] )
                EndIf
             EndIf
         Next nPosVetor
          
         aListaTransp := aTranspOrd2         
      Else
         AADD( aTranspOrd2, "" )
    
            cNmArqSA2 := Alltrim( CriaTrab(,.F.) )
      
         cQuerySA2 := "SELECT A2_COD, A2_LOJA, A2_NOME "
         cQuerySA2 += "  FROM SA2010 "
         cQuerySA2 += " WHERE D_E_L_E_T_ = '' "
         cQuerySA2 += "   AND A2_COD+A2_LOJA "
         cQuerySA2 += "       IN ( "
         
         For nPosVetor := 1 To Len( aListaTransp )

             cQuerySA2 += "'" + AllTrim( aListaTransp[nPosVetor] ) + "', "
         Next nPosVetor 
         
         cQuerySA2 := AllTrim( cQuerySA2 )
         cQuerySA2 := SubStr( cQuerySA2, 1, Len( cQuerySA2 ) - 1 ) + " ) "
         cQuerySA2 += "ORDER BY A2_COD, A2_LOJA "
      
         DBUseArea( .T., "TOPCONN", TCGenQry(,,cQuerySA2), cNmArqSA2, .F., .T. )
         
         COUNT TO nRecCount

         If ( nRecCount <> 0 )

            ( cNmArqSA2 )->(DBGoTop())
                       
            Do While ( cNmArqSA2 )->(!Eof())
                        
               AADD( aTrspAuxOrd2, { "", "", "" } )
               aTrspAuxOrd2[Len(aTrspAuxOrd2)][1] := ( cNmArqSA2 )->A2_COD
               aTrspAuxOrd2[Len(aTrspAuxOrd2)][2] := ( cNmArqSA2 )->A2_LOJA
               aTrspAuxOrd2[Len(aTrspAuxOrd2)][3] := ( cNmArqSA2 )->A2_NOME
                                               
               AADD( aTranspOrd2, aTrspAuxOrd2[Len(aTrspAuxOrd2)][1] + ' - ' + aTrspAuxOrd2[Len(aTrspAuxOrd2)][2] + ' - ' + aTrspAuxOrd2[Len(aTrspAuxOrd2)][3] )
               
               ( cNmArqSA2 )->(DBSkip())
            Enddo
            ( cNmArqSA2 )->(DBCloseArea())
            
            MsErase( cNmArqSA2,, "TOPCONN" )
         EndIf         
         aListaTransp := aTranspOrd2
      EndIf                          
      
   EndIf   
EndIf
Return

/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Static Function ChgTipoDoc()
/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Local nPosCombo
Local nHaTipo := .F.

For nPosCombo := 1 To Len(aTipoDocumento)

    If ( AllTrim( cTipoDocumento ) == AllTrim( aTipoDocumento[ nPosCombo ] ) )
      
       If ( AllTrim( cTipoDocumento ) == "" )  
       
          nHaTipo := .F.
       Else
          nHaTipo := .T.
       EndIf          
         Exit
    Endif    
Next nPosCombo   

If nHaTipo 

   If ( Len( AllTrim( cNDocAlocacao ) ) == 0 )
   
      cNDocAlocacao := AllTrim( cTipoDocumento )
   Else
      cNDocAlocacao := STUFF( cNDocAlocacao, 1, 3, AllTrim( cTipoDocumento ) )
       
      If ( Len( AllTrim( cNDocAlocacao ) ) == 4 )
      
         cSeqNDocAlocacao := AllTrim( aSeqsTipoDoc[Ascan( aAuxSqTipoDoc, { |x|, x == AllTrim( cTipoDocumento ) } )][2] )
         cNDocAlocacao    := SubStr( cNDocAlocacao, 1, 4 ) + cSeqNDocAlocacao
      EndIf
   EndIf

   If ( AllTrim( cSitAlocacao ) <> "" )
   
      cNDocAlocacao := STUFF( cNDocAlocacao, 4, 1, SubStr( cSitAlocacao, 1, 1 ) )
      cNDocAlocacao := SubStr( cNDocAlocacao, 1, 4 )
   
      If ( Len( AllTrim( cNDocAlocacao ) ) == 4 )

         cSeqNDocAlocacao := AllTrim( aSeqsTipoDoc[Ascan( aAuxSqTipoDoc, { |x|, x == AllTrim( cTipoDocumento ) } )][2] )
         cNDocAlocacao    := SubStr( cNDocAlocacao, 1, 4 ) + cSeqNDocAlocacao
      EndIf   
   EndIf   
   
Else
   cNDocAlocacao := ""
EndIf

Return nPosCombo

/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Static Function ChgSitAloc()
/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Local nPosCombo
Local nHaTipo := .F.

For nPosCombo := 1 To Len(aSitAlocacao)

    If ( SubStr( cSitAlocacao, 1, 1 ) ==  SubStr( aSitAlocacao[ nPosCombo ], 1, 1 ) )

       If ( AllTrim( cSitAlocacao ) == "" )
       
          nHaTipo := .F.
       Else
          nHaTipo := .T.
       EndIf          
    EndIf
Next nPosCombo

If nHaTipo 

   If ( AllTrim( cTipoDocumento ) <> "" )
   
      cNDocAlocacao := AllTrim( cTipoDocumento )
   EndIf

   If ( Len( AllTrim( cNDocAlocacao ) ) == 0 )
   
      cNDocAlocacao := cNDocAlocacao
   Else
      cNDocAlocacao := STUFF( cNDocAlocacao, 4, 1, SubStr( cSitAlocacao, 1, 1 ) )
   
      If ( Len( AllTrim( cNDocAlocacao ) ) == 4 )

         cSeqNDocAlocacao := AllTrim( aSeqsTipoDoc[Ascan( aAuxSqTipoDoc, { |x|, x == AllTrim( cTipoDocumento ) } )][2] )
         cNDocAlocacao    := SubStr( cNDocAlocacao, 1, 4 ) + cSeqNDocAlocacao         
      EndIf
   EndIf
Else
   cNDocAlocacao := ""
EndIf

Return nPosCombo                          

/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Static Function ChgTipoTransp()
/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Local nPosCombo
Local nHaTipo := .F.

For nPosCombo := 1 To Len(aTranspTipoDoc)

    If ( AllTrim( cTranspTipoDoc ) ==  AllTrim( aTranspTipoDoc[ nPosCombo ] ) )
    
       If ( AllTrim( cTranspTipoDoc ) == "" )
       
          nHaTipo := .F.
       Else
          nHaTipo := .T.
       EndIf
         Exit
    EndIf
Next nPosCombo

If nHaTipo 

   cNDocTransfere := AllTrim( cTranspTipoDoc )
   
   If ( Len( AllTrim( cNDocTransfere ) ) == 3 )

      cSeqNDocTransfere := AllTrim( aSeqsTranTip[Ascan( aAuxSqTranTip, { |x|, x == AllTrim( cTranspTipoDoc ) } )][2] )
      cNDocTransfere    := SubStr( cNDocTransfere, 1, 3 ) + cSeqNDocTransfere
      lSelTransp        := .T.
      ExbTitsTransp( lSelTransp )
   EndIf      
Else
   cNDocTransfere := ""       
   lSelTransp     := .F.
   ExbTitsTransp( lSelTransp )
EndIf

Return nPosCombo                          
   
/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Static Function ChgCmbxInst()
/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Local aIndex      := {}
Local nPosCmbInst := oInstituicao:nAt
Local nRecCount
Local cFornecedor := ""
Local cLoja       := ""

SET FILTER TO 

cFornecedor := SubStr( AllTrim( cInstituicao ),  1, 6 )
cLoja       := SubStr( AllTrim( cInstituicao ), 10, 2 )
      
If ( AllTrim( cFornecedor ) <> "" ) .And. ( AllTrim( cLoja ) <> "" )
    
   SET FILTER TO (cNmArqGrid)->N1_XCLIORG == cFornecedor .AND. (cNmArqGrid)->N1_XLOJAIN == cLoja .AND. (cNmArqGrid)->GRAVADO <> "2"
EndIf

(cNmArqGrid)->( DBGoTop() )

Eval(oMarkBrowse:oBrowse:bGoTop)
oMarkBrowse:oBrowse:Refresh()

COUNT TO nRecCount

If ( nRecCount == 0 )

   MsgInfo( OemToAnsi( "Não há ativo imobilizado, que corresponda a instituição selecionada." ) )
   
EndIf

Return                    

/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Static Function fFiltraBrow()
/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Local aCampos   := {}  
Local aIndex    := {}
Local nIndAtivo

AADD( aCampos, { "N1_XNUMPRO", cTxtTit2ColBrow, .T., 1, 15, "@!", "C", 0 } )
AADD( aCampos, { "N1_CBASE"  , cTxtTit3ColBrow, .T., 2, 10, "@!", "C", 0 } )
AADD( aCampos, { "N1_DESCRIC", cTxtTit4ColBrow, .T., 3, 60, "@!", "C", 0 } )
AADD( aCampos, { "N1_NFISCAL", cTxtTit5ColBrow, .T., 4, 09, "@!", "C", 0 } )
AADD( aCampos, { "N1_NSERIE" , cTxtTit6ColBrow, .T., 5, 03, "@!", "C", 0 } )
AADD( aCampos, { "N1_CHAPA"  , cTxtTit7ColBrow, .T., 6, 07, "@!", "C", 0 } )
AADD( aCampos, { "N1_XMARCA" , cTxtTit8ColBrow, .T., 7, 15, "@!", "C", 0 } )
AADD( aCampos, { "N1_XMODELO", cTxtTit9ColBrow, .T., 8, 15, "@!", "C", 0 } )
AADD( aCampos, { "N1_XSERIE" , cTxtTitAColBrow, .T., 9, 15, "@!", "C", 0 } )
AADD( aCampos, { "N1_XDOCALO", cTxtTitBColBrow, .T.,12, 16, "@!", "C", 0 } )
AADD( aCampos, { "N1_XDOCTRA", cTxtTitCColBrow, .T.,13, 16, "@!", "C", 0 } )

cFiltroBrow := BuildExpr( ,,,, {|| &("cNmArqGrid->( DBGoTop() )")  } ,,, cLblButFilGrid,,, aCampos )
nIndAtivo   := IndexOrd()

EndFilBrw( cNmArqGrid, aIndex )

Eval( {|| FilBrowse( cNmArqGrid, @aIndex, @cFiltroBrow ) } )

OrdenaBrow( nIndAtivo )

Return                

/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Static Function OrdenaBrow( nColBrow )
/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */

oMarkBrowse :oBrowse:SetHeaderImage( 3, "COLRIGHT" )
oMarkBrowse :oBrowse:SetHeaderImage( 4, "COLRIGHT" )
oMarkBrowse :oBrowse:SetHeaderImage( 5, "COLRIGHT" )

nColBrow -= 2
( cNmArqGrid )->( DBSetOrder( nColBrow ) )
( cNmArqGrid )->( DBGoTop() )   
nColBrow += 2
      
oMarkBrowse:oBrowse:SetHeaderImage( nColBrow, "COLDOWN" )
   
Eval(oMarkBrowse:oBrowse:bGoTop)    
oMarkBrowse:oBrowse:Refresh()

Return                

/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Static Function BuscaSeqs()
/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Local cNmArqSeq := Alltrim( CriaTrab(,.F.) )
Local cQuery    := ""
Local nPosVetor 

For nPosVetor := 1 To Len( aTipoDocumento )

    If ( AllTrim( aTipoDocumento[ nPosVetor ] ) <> "" )
    
       AADD( aSeqsTipoDoc , { aTipoDocumento[ nPosVetor ], "" } )
       AADD( aAuxSqTipoDoc, aTipoDocumento[ nPosVetor ] )
    EndIf    
Next nPosVetor
                        
For nPosVetor := 1 To Len( aTranspTipoDoc )

    If ( AllTrim( aTranspTipoDoc[ nPosVetor ] ) <> "" )
            
       AADD( aSeqsTranTip , { aTranspTipoDoc[ nPosVetor ], "" } )       
       AADD( aAuxSqTranTip, aTranspTipoDoc[ nPosVetor ] )
    EndIf    
Next nPosVetor

cQuery := "SELECT LEFT( N1_XDOCALO, 3 ) CODSEQ,
cQuery += "       ISNULL( CONVERT( INT, MAX( RIGHT( RTRIM( N1_XDOCALO ), 6 ) ) ), 0 ) NUMSEQ
cQuery += "  FROM SN1010
cQuery += " WHERE D_E_L_E_T_  = '' 
cQuery += "   AND N1_XDOCALO <> ''
cQuery += "GROUP BY LEFT( N1_XDOCALO, 3 )"
cQuery += "UNION"
cQuery := "SELECT LEFT( N1_XDOCTRA, 3 ) CODSEQ,
cQuery += "       ISNULL( CONVERT( INT, MAX( RIGHT( RTRIM( N1_XDOCTRA ), 6 ) ) ), 0 ) NUMSEQ
cQuery += "  FROM SN1010
cQuery += " WHERE D_E_L_E_T_  = '' 
cQuery += "   AND N1_XDOCTRA <> ''
cQuery += "GROUP BY LEFT( N1_XDOCTRA, 3 )"

DBUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cNmArqSeq, .F., .T. )

( cNmArqSeq )->(dbGoTop())
Do While ( cNmArqSeq )->(!Eof())

   cCodSeq := ( cNmArqSeq )->CODSEQ
   nScan   := Ascan( aAuxSqTipoDoc, { |x|, x == cCodSeq } )
   
   If ( nScan <> 0 )

      aSeqsTipoDoc[ nScan ][2] := SubStr( AllTrim( Str( Year( Date() ) ) ), 3, 2 ) + STRZERO( ( cNmArqSeq )->NUMSEQ + 1, 6 )
   Else
      nScan := Ascan( aAuxSqTranTip, { |x|, x == cCodSeq } )
   
      If ( nScan <> 0 )
                            
         aSeqsTranTip[ nScan ][2] := SubStr( AllTrim( Str( Year( Date() ) ) ), 3, 2 ) + STRZERO( ( cNmArqSeq )->NUMSEQ + 1, 6 )
      EndIf
   EndIf
   
   ( cNmArqSeq )->( dbSkip() )
Enddo

For nPosVetor := 1 To Len( aSeqsTipoDoc )

    If ( AllTrim( aSeqsTipoDoc[nPosVetor][2] ) == "" )

       aSeqsTipoDoc[nPosVetor][2] := SubStr( AllTrim( Str( Year( Date() ) ) ), 3, 2 ) + "000001"
    EndIf
Next nPosVetor

For nPosVetor := 1 To Len( aSeqsTranTip )

    If ( AllTrim( aSeqsTranTip[nPosVetor][2] ) == "" )

       aSeqsTranTip[nPosVetor][2] := SubStr( AllTrim( Str( Year( Date() ) ) ), 3, 2 ) + "000001"
    EndIf
Next nPosVetor

( cNmArqSeq )->( DBCloseArea() )

Return

/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Static Function fLegendas()
/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Local aCores := {}

AADD( aCores, { "(cNmArqGrid)->MARK <> cMarca .AND. AllTrim((cNmArqGrid)->GRAVADO) == '' ", "BR_BRANCO"   } )
AADD( aCores, { "(cNmArqGrid)->MARK == cMarca .AND. AllTrim((cNmArqGrid)->GRAVADO) == '' ", "BR_BRANCO"   } )
AADD( aCores, { "(cNmArqGrid)->MARK == cMarca .AND. AllTrim((cNmArqGrid)->GRAVADO) == '0'", "BR_VERMELHO" } )
AADD( aCores, { "(cNmArqGrid)->MARK == cMarca .AND. AllTrim((cNmArqGrid)->GRAVADO) == '1'", "BR_VERDE"    } )
AADD( aCores, { "(cNmArqGrid)->MARK <> cMarca .AND. AllTrim((cNmArqGrid)->GRAVADO) == '1'", "BR_VERDE"    } )
AADD( aCores, { "(cNmArqGrid)->MARK == cMarca .AND. AllTrim((cNmArqGrid)->GRAVADO) == '2'", "BR_AZUL"     } )
AADD( aCores, { "(cNmArqGrid)->MARK <> cMarca .AND. AllTrim((cNmArqGrid)->GRAVADO) == '2'", "BR_AZUL"     } )

Return aCores


Static Function fVerDocIRep( nTipoDoc )

Local cQuery := ""

cQuery += "select N1_XPROJET,"
cQuery += "       N1_XTAREFA,"
cQuery += "       N1_ITEM,"
cQuery += "       (select AF8_DESCRI FROM AF8010 WHERE AF8_PROJET = N1_XPROJET) DESCRIC,"
cQuery += "       N1_XNUMPRO,"
cQuery += "       N1_DESCRIC,"
cQuery += "       N1_XMARCA,"
cQuery += "       N1_XMODELO,"
cQuery += "       N1_XSERIE,"
cQuery += "       N1_XSBM,"
cQuery += "       N1_XNUMSC,"
cQuery += "       N1_XITEMSC,"
cQuery += "       (select A1_NOME from SA1010 WHERE N1_XCLIORG = A1_COD AND A1_LOJA = '00') AS ORGAM,"
cQuery += "       (select U5_CONTAT from SU5010 WHERE N1_XCONTAT = U5_CODCONT) AS CONTATO,"
cQuery += "       A1_NOME,"
cQuery += "       A1_END,"
cQuery += "       A1_BAIRRO,"
cQuery += "       A1_MUN,"
cQuery += "       A1_EST,"
cQuery += "       A1_CEP,"
cQuery += "       A1_TEL,"
cQuery += "       A1_DDD,"
cQuery += "       (select N3_VORIG3 from SN3010 where (N1_CBASE = N3_CBASE AND N1_FILIAL = N3_FILIAL AND N1_ITEM = N3_ITEM)) AS VALOR"
cQuery += "  from SN1010 
cQuery += "       LEFT JOIN 
cQuery += "       SA1010 ON N1_XCODINS = A1_COD     AND 
cQuery += "                 A1_LOJA    = N1_XLOJAIN 

If ( ( cNmArqGrid )->GRAVADO == "2" )

   cQuery += " Where N1_XDOCALO = '" + Alltrim( ( cNmArqGrid )->N1_XDOCALO ) + "'"
Else
   cQuery += " Where N1_XDOCALO = '" + cNDocAlocacao + "'"
EndIf   

If ( nTipoDoc == 1 )

   fIReport( , cQuery,, 2, "patrialocacao" )
Else 
   fIReport( , cQuery,, 2, "patritransporte" )
EndIf   

Return 

Static Function fIReport( cArqSql, cQuery, lGravaQuery, nTipoVisual, cNomeRelJasper, cPathJava )
Local cRootPath     := ""     
Local cNmArqSQL     := ""
Local cVisualiza    := ""
Local cString       := ""
Local cNmArq1       := ""
Local cNmArq2       := ""
Local cDateTime     := ""
Local cMensSemExcel := OemToAnsi( "Microsoft Excel não instalado." )
Local cMensErro     := OemToAnsi( "Não foi possível gerar/exibir o relatório." )
Local lExecutou     := .F.

Default cPathJava   := "C:\Program Files (x86)\Java\jre6\bin\"
Default nTipoVisual := 2
Default lGravaQuery := .F.
Default cQuery      := ""

If ( ( nTipoVisual == 2 ) .Or. ( nTipoVisual == 3 ) )

   If nTipoVisual == 3
   
      If !ApOleClient("MsExcel")
      
         MsgStop( cMensSemExcel )
         Return( lExecutou )
      EndIf
   EndIf              
   
   If ( ( cArqSql == "" ) .And. ( cQuery == "" ) )

      MsgStop("Pesquisa não detectada para geração/exibição do relatório.")
      Return( lExecutou )
   EndIf      

   If cQuery <> ""

      cNmArqSQL := cNomeRelJasper+".sql"
         
      If File( "\SQL\"+cNmArqSQL )
               
         cDateTime := DTOC( MsDate() ) + "_" + Time()
                                                      
         cDateTime := SUBSTR( cDateTime, 07, 4 ) + "_" + ;
                      SUBSTR( cDateTime, 04, 2 ) + "_" + ;
                      SUBSTR( cDateTime, 01, 2 ) + "_" + ;
                      SUBSTR( cDateTime, 12, 8 )
                               
         While ( AT( ":", cDateTime ) <> 0 )
           cDateTime := STUFF( cDateTime, AT( ":", cDateTime ), 1, "_" )
         EndDo                                                                 
                  
         FRename( "\SQL\"+cNmArqSQL, "\SQL\"+StrTran(cNmArqSQL,".sql", "_" + cDateTime + ".sql" ) )
      EndIf

      MemoWrite( "\SQL\"+cNmArqSQL, cQuery )
      
   Else 
      cNmArqSQL := cArqSql+".sql"
   EndIf      
      
   cRootPath  := GetSrvProfString( "ROOTPATH", "" )
   cDirFile   := cRootPath + "\web\reports\ExecIReport\dist\ExecIReport.jar"
      
   While ( AT( "\", cRootPath ) <> 0 )
     cRootPath := STUFF( cRootPath, AT( "\", cRootPath ), 1, "." )
   EndDo                                               
      
   While ( AT( ".", cRootPath ) <> 0 )
     cRootPath := STUFF( cRootPath, AT( ".", cRootPath ), 1, "\\" )        
   EndDo                                                           

   cRootPath  := cRootPath + "\\web\\reports\\"
   cVisualiza := AllTrim(Str(nTipoVisual))
                  
   cString    := "'"
   cString    += cPathJava + "JAVA.EXE -jar "
   cString    += '"' + cDirFile       + '" '
   cString    += '"' + cNmArqSQL      + '" '
   cString    += '"' + cVisualiza     + '" '   
   cString    += '"' + cNomeRelJasper + '" '
   cString    += '"' + cRootPath      + "ExecIReport\\ireport.properties" + '" '
   cString    += '"' + "0"            + '"'
   cString    += "'"
                           
   lExecutou  := WAITRUNSRV( &cString, .T., cPathJava )
   
   If ! lExecutou
   
      MsgStop( cMensErro )
      Return( lExecutou )      
   Else
   
      If nTipoVisual == 2
      
         cNmArq1 := "\web\reports\PDFTEMP\"+cNomeRelJasper+".pdf"
         cNmArq2 := AllTrim(GetTempPath()) +cNomeRelJasper+".pdf"
      Else 
      
         cNmArq1 := "\web\reports\XLSTEMP\"+cNomeRelJasper+".xls"
         cNmArq2 := AllTrim(GetTempPath()) +cNomeRelJasper+".xls"
      EndIf                                                                   

      lExecutou  := __copyfile( cNmArq1, cNmArq2 )
      
      If ! lExecutou
   
         MsgStop( cMensErro )
         Return( lExecutou )      
      Else   
      
         If cQuery <> ""
         
            If ! lGravaQuery
                     
               FErase( "\SQL\"+cNmArqSQL )
            EndIf  
                        
         EndIf
            
         FErase( cNmArq1 )

         If lExecutou
            ShellExecute( "Open", cNmArq2, "", AllTrim(GetTempPath()), 1 )      
         EndIf                  
      EndIf            
   EndIf         
EndIf
Return( lExecutou )

/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Static Function fChangeCmbx( nOrdem )
/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
If ( nOrdem == 1 )

   oPnlInstOrd2:Hide()
   oPnlInstOrd1:Show()
Else
   oPnlInstOrd1:Hide()
   oPnlInstOrd2:Show()
EndIf
Return

/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Static Function fHabilBotao()
/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Return( If( lGravDocsAlocTran, .T., .F. ) )

/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Static Function fGravar()                                                                           
/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Local nRegistro  := Recno()

If ( ( AllTrim( cNDocAlocacao ) <> "" ) )

   ( cNmArqGrid )->(dbGoTop())
   Do While ( cNmArqGrid )->(!Eof())

      If ( ( cNmArqGrid )->GRAVADO <> "2" )
      
         If ( ( cNmArqGrid )->MARK == cMarca )
            
            If ( Alltrim( ( cNmArqGrid )->N1_XDOCALO ) == "" )

               DBSelectArea("SN1")
               SN1->( DBGOTO( ( cNmArqGrid )->NUMREG ) )
               RECLOCK( "SN1", .F. )
               SN1->N1_XDOCALO := cNDocAlocacao
               SN1->N1_XDOCTRA := cNDocTransfere
               SN1->N1_XTRANSP := SubStr( cListaTransp,  1, 6 )
               SN1->N1_XLOJTRA := SubStr( cListaTransp, 10, 2 )
               SN1->N1_XQTDVOL := nQtdVolumes
               SN1->( MSUNLOCK() )

               DBSelectArea(cNmArqGrid)         
               RECLOCK( cNmArqGrid, .F. )
               ( cNmArqGrid )->GRAVADO    := "1"
               ( cNmArqGrid )->N1_XDOCALO := cNDocAlocacao
               ( cNmArqGrid )->N1_XDOCTRA := cNDocTransfere
               MSUNLOCK()                       
            EndIf
         EndIf                          
      EndIf
            
      ( cNmArqGrid )->( DBSkip() )
   Enddo
   ( cNmArqGrid )->( DBGOTO( nRegistro ) )
   
   lGravDocsAlocTran := .T.
   oMarkBrowse:oBrowse:Refresh()   
Else
   
   If ( AllTrim( cNDocAlocacao ) == "" )

      MsgInfo( OemToAnsi( "Preencha o número do documento de alocação." ) )
   EndIf   
   
   If ( AllTrim( cNDocTransfere ) == "" )

      If ( Alltrim( cListaTransp ) == "" )

         MsgInfo( OemToAnsi( "Selecione a transportadora." ) )
      EndIf   
   EndIf
EndIf
Return

/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Static Function fAbreTelaOpc()
/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Local _aSize        := MsAdvSize()
Local cTxtJanela    := OemToAnsi( "Patrimônio" )               
Local cModApresTela := OemToAnsi( "Selecione o modo de apresentação da tela:" )
Local clblTlNormal  := OemToAnsi( "Normal" )
Local clblTlManut   := OemToAnsi( "Manutenção" )
Local clblFinaliza  := OemToAnsi( "Finalizar" )
Local nOpc          := 0
Local oBmpPatrimon  := Nil
Local cBMPPatri     := cBMPPath + "LogoPatri.BMP"

Local oDlg
Local oPanel         := Nil

_aSize [1] := 1
_aSize [5] := 415

_aSize [1] += 50
_aSize [6] := _aSize [1] + 190
_aSize [5] -= 54

oDlg   := MSDialog():New( _aSize [1], _aSize [1], _aSize [6], _aSize [5], cTxtJanela,,,,,, CLR_WHITE,, oMainWnd, .T. )

@ 000,000 MSPANEL oPanel OF oDlg
oPanel:Align    := CONTROL_ALIGN_ALLCLIENT

_aSize [1] -= 50

oBmpPatrimon := TBitmap():New( 001, 001, 082, 082,, cBMPPatri, .F., oPanel,,, .F., .F.,,, .T.,, .T.,, .T. )
oBmpPatrimon :lAutoSize    := .F.
oBmpPatrimon :lStretch     := .T.
oBmpPatrimon :lTransparent := .F.

@ ( _aSize [1] + 008 ), ( _aSize [1] + 092 ) BUTTON clblFinaliza SIZE 060,015 FONT oDlg:oFont ACTION (nOpc:=0,oDlg:End()) OF oPanel PIXEL

@ ( _aSize [1] + 028 ), ( _aSize [1] + 092 ) Say cModApresTela   OF oPanel SIZE 060,070 PIXEL FONT oDlg:oFont COLOR CLR_HBLUE

@ ( _aSize [1] + 048 ), ( _aSize [1] + 092 ) BUTTON clblTlNormal SIZE 060,015 FONT oDlg:oFont ACTION (nOpc:=1,oDlg:End()) OF oPanel PIXEL
@ ( _aSize [1] + 068 ), ( _aSize [1] + 092 ) BUTTON clblTlManut  SIZE 060,015 FONT oDlg:oFont ACTION (nOpc:=2,oDlg:End()) OF oPanel PIXEL

ACTIVATE MSDIALOG oDlg

If ( nOpc == 1 )

   lTelaModNormal := .T.
Else
   lTelaModNormal := .F.
EndIf

Return nOpc

/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Static Function ExbTitsTransp( lAtivo )
/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
If ( ! lAtivo )

   nQtdVolumes  := 0 
   cListaTransp := ""
EndIf

@ 009, 002 Say "Transportadora" OF oPnlInfo SIZE 070,009 PIXEL FONT oPnlInfo:oFont COLOR If( lAtivo, CLR_BLUE, CLR_GRAY )
@ 009, 292 Say "Qtd. Volumes"   OF oPnlInfo SIZE 060,009 PIXEL FONT oPnlInfo:oFont COLOR If( lAtivo, CLR_BLUE, CLR_GRAY )
Return 

/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Static Function ConsoleOp()
/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Local oFont                := NIL
Local oNDocAlocacao     := NIL
Local oNDocTransfere    := NIL
Local oSitAlocacao      := NIL

Local nOpc              := 0
Local nNUMREG
Local nRecCount
Local nLinha
Local nPosCombo
Local nPosVetor 
Local nIndex 

Local lInverte          := .F.

Local cQuery            := ""
Local cQryProjUsu       := ""
Local cIndex            := ""
Local cChave            := ""
Local cMARK             := ""
Local cN1XNUMPRO        := ""
Local cN1CBASE          := ""
Local cN1DESCRIC        := ""
Local cN1NFISCAL        := ""
Local cN1NSERIE         := ""
Local cN1CHAPA          := ""
Local cN1XMARCA         := ""
Local cN1XMODELO        := ""
Local cN1XSERIE         := ""
Local cN1XCLIORG        := ""
Local cN1XLOJAIN        := ""

Local cNmInd1           := ""
Local cNmInd2           := ""
Local cNmInd3           := ""
Local cNmInd4           := ""
Local cNmInd5           := ""
Local cNmInd6           := ""
Local cNmInd7           := ""
Local cNmInd8           := ""
Local cNmInd9           := ""

Local cLblButFinaliza   := OemToAnsi( "Finalizar" )
Local cLblButDesMarca   := OemToAnsi( "Desmarcar Todos" )
Local cLblButMarcaAll   := OemToAnsi( "Marcar Todos" )
Local cLblButInvMarca   := OemToAnsi( "Inverter Marcações" )
Local cLblButFiltra     := OemToAnsi( "Filtrar Dados" )

Local cCptJanPrincipal  := OemToAnsi( "Patrimônio" )
Local clblNDocAlocacao  := OemToAnsi( "Número do Documento de Alocação" )
Local clblTipoDocumento := OemToAnsi( "Tipo do Documento de Alocação" )   
Local clblTranspTipoDoc := OemToAnsi( "Tipo do Documento de Transporte" )
Local clblSitAlocacao   := OemToAnsi( "Situação da Alocação" )
Local clblNDocTransfere := OemToAnsi( "Número do Documento de Transporte" )
Local clblInstituicao   := OemToAnsi( "Instituição" )
Local cLblTranspGerDoc  := OemToAnsi( "Gerar Doc. Transporte" )
Local cLblAlocGerDoc    := OemToAnsi( "Gerar Doc. Alocação" )
Local cLblGravar        := OemToAnsi( "Gravar" ) 
Local cLblNovoDoc       := OemToAnsi( "Gerar Novo Documento" )
Local cLblBut2          := ""

Local aListBox1         := {}
Local aAtvImob          := {}
Local _aSize            := {}

Local oBmpBtDn          := Nil
Local oBmpBtUp          := Nil

Local cBMPBTDn          := cBMPPath + "down.bmp"
Local cBMPBTUp          := cBMPPath + "up.bmp"

Local oPanel

BuscaSeqs()

AADD( aAtvImob, { "MARK"      , "C", 02, 0 } )
AADD( aAtvImob, { "N1_XNUMPRO", "C", 15, 0 } )
AADD( aAtvImob, { "N1_CBASE"  , "C", 10, 0 } )
AADD( aAtvImob, { "N1_DESCRIC", "C", 60, 0 } )
AADD( aAtvImob, { "N1_NFISCAL", "C", 09, 0 } )
AADD( aAtvImob, { "N1_NSERIE" , "C", 03, 0 } )
AADD( aAtvImob, { "N1_CHAPA"  , "C", 07, 0 } )
AADD( aAtvImob, { "N1_XMARCA" , "C", 15, 0 } )
AADD( aAtvImob, { "N1_XMODELO", "C", 15, 0 } )
AADD( aAtvImob, { "N1_XSERIE" , "C", 15, 0 } )
AADD( aAtvImob, { "N1_XCLIORG", "C", 06, 0 } )
AADD( aAtvImob, { "N1_XLOJAIN", "C", 02, 0 } )
AADD( aAtvImob, { "N1_XDOCALO", "C", 16, 0 } )
AADD( aAtvImob, { "N1_XDOCTRA", "C", 16, 0 } )
AADD( aAtvImob, { "GRAVADO"   , "C", 01, 0 } )
AADD( aAtvImob, { "NUMREG"    , "N", 09, 0 } )

MsCreate( cNmArqGrid, aAtvImob, "TOPCONN" ) 
DBUseArea( .T., "TOPCONN", cNmArqGrid, cNmArqGrid, .T., .F. ) 

DBSelectArea(cNmArqGrid)
( cNmArqGrid )->( DBGOTOP() )

Do While ( cNmArqGrid )->(!Eof())

   RECLOCK( cNmArqGrid, .F. )
   ( cNmArqGrid )->( DBDelete() )
   MSUNLOCK()
   ( cNmArqGrid )->( DBSkip() )
EndDo

cQuery        := MemoRead( cQryBrowse )

cNmArqAtvImob := Alltrim( CriaTrab(,.F.) )

DBUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cNmArqAtvImob, .F., .T. )

COUNT TO nRecCount

If ( nRecCount == 0 )

   MsgStop( OemToAnsi( "Não foi possível iniciar o aplicativo!" ) )
   
   ( cNmArqAtvImob )->(DBCloseArea())
   ( cNmArqGrid    )->(DBCloseArea())
Else
   ( cNmArqAtvImob )->( DBGoTop() )

   Do While ( cNmArqAtvImob )->(!Eof())   

      cN1XNUMPRO  := ( cNmArqAtvImob )->N1_XNUMPRO
      cN1CBASE    := ( cNmArqAtvImob )->N1_CBASE   
      cN1DESCRIC  := ( cNmArqAtvImob )->N1_DESCRIC 
      cN1NFISCAL  := ( cNmArqAtvImob )->N1_NFISCAL 
      cN1NSERIE   := ( cNmArqAtvImob )->N1_NSERIE  
      cN1CHAPA    := ( cNmArqAtvImob )->N1_CHAPA   
      cN1XMARCA   := ( cNmArqAtvImob )->N1_XMARCA  
      cN1XMODELO  := ( cNmArqAtvImob )->N1_XMODELO 
      cN1XSERIE   := ( cNmArqAtvImob )->N1_XSERIE  
      cN1XCLIORG  := ( cNmArqAtvImob )->N1_XCLIORG
      cN1XLOJAIN  := ( cNmArqAtvImob )->N1_XLOJAIN
      nNUMREG     := ( cNmArqAtvImob )->R_E_C_N_O_
      
      DBSelectArea(cNmArqGrid)
        RECLOCK( cNmArqGrid, .T. )

      ( cNmArqGrid )->N1_XNUMPRO := cN1XNUMPRO
      ( cNmArqGrid )->N1_CBASE   := cN1CBASE
      ( cNmArqGrid )->N1_DESCRIC := cN1DESCRIC
      ( cNmArqGrid )->N1_NFISCAL := cN1NFISCAL
      ( cNmArqGrid )->N1_NSERIE  := cN1NSERIE
      ( cNmArqGrid )->N1_CHAPA   := cN1CHAPA
      ( cNmArqGrid )->N1_XMARCA  := cN1XMARCA
      ( cNmArqGrid )->N1_XMODELO := cN1XMODELO
      ( cNmArqGrid )->N1_XSERIE  := cN1XSERIE
      ( cNmArqGrid )->N1_XCLIORG := cN1XCLIORG
      ( cNmArqGrid )->N1_XLOJAIN := cN1XLOJAIN
      ( cNmArqGrid )->NUMREG     := nNUMREG 
              
      MSUNLOCK()
     
      DBSelectArea(cNmArqAtvImob)
      ( cNmArqAtvImob )->( DBSkip() )
   EndDo
        
   DBSelectArea(cNmArqGrid)
   ( cNmArqGrid )->( DBGoTop() )   

   DBCreateIndex( cNmInd3 := CriaTrab( NIL, .F. ), "N1_DESCRIC", { || N1_DESCRIC } )
   DBCreateIndex( cNmInd2 := CriaTrab( NIL, .F. ), "N1_CBASE"  , { || N1_CBASE   } )
   DBCreateIndex( cNmInd1 := CriaTrab( NIL, .F. ), "N1_XNUMPRO", { || N1_XNUMPRO } )
   
   DBSetIndex( cNmInd1 )
   DBSetIndex( cNmInd2 )
   DBSetIndex( cNmInd3 )
   
   DBSetOrder( 1 )
   
   ( cNmArqGrid )->( DBGOTOP() )   
EndIf

fPreenchVets()

aInstituicao      := aInstitOrd1

_aSize            := MsAdvSize()

oPanel     := MSDialog():New( _aSize [1], _aSize [1], _aSize [6], _aSize [5], cCptJanPrincipal,,,,,, CLR_WHITE,, oMainWnd, .T. )

@ 000,000 MSPANEL oPanel OF oDlg
oPanel:Align    := CONTROL_ALIGN_ALLCLIENT
                                
nLinha            := _aSize [1] + 2

@ nLinha,( _aSize [1] + 003 )      Say clblInstituicao    OF oPanel SIZE 060,015 PIXEL FONT oFont COLOR CLR_HBLUE
@ nLinha,( _aSize [1] + 264 + 12 ) Say clblTipoDocumento  OF oPanel SIZE 060,015 PIXEL FONT oFont COLOR If( lTelaModNormal, CLR_HBLUE, CLR_GRAY )
@ nLinha,( _aSize [1] + 329 + 12 ) Say clblSitAlocacao    OF oPanel SIZE 060,015 PIXEL FONT oFont COLOR If( lTelaModNormal, CLR_HBLUE, CLR_GRAY )
@ nLinha,( _aSize [1] + 394 + 12 ) Say clblNDocAlocacao   OF oPanel SIZE 060,015 PIXEL FONT oFont COLOR If( lTelaModNormal, CLR_HBLUE, CLR_GRAY )
@ nLinha,( _aSize [1] + 459 + 12 ) Say clblTranspTipoDoc  OF oPanel SIZE 060,015 PIXEL FONT oFont COLOR If( lTelaModNormal, CLR_HBLUE, CLR_GRAY )
@ nLinha,( _aSize [1] + 524 + 12 ) Say clblNDocTransfere  OF oPanel SIZE 060,015 PIXEL FONT oFont COLOR If( lTelaModNormal, CLR_HBLUE, CLR_GRAY )

nLinha            := _aSize [1] + 17

oPnlInstOrd2      := TPanel():New( nLinha - 1, _aSize [1] + 001, "", oPanel,,,,,, ( _aSize [1] + 247 ), nLinha - 1, .F., .F. )

@ 001, 002 MSCOMBOBOX oInstituicao VAR cInstituicao ITEMS aInstitOrd2 OF oPnlInstOrd2 SIZE 245,015 PIXEL FONT oFont ON CHANGE ChgCmbxInst()

oPnlInstOrd2      :Hide()

oPnlInstOrd1      := TPanel():New( nLinha - 1, _aSize [1] + 001, "", oPanel,,,,,, ( _aSize [1] + 247 ), nLinha - 1, .F., .F. )

@ 001, 002 MSCOMBOBOX oInstituicao VAR cInstituicao ITEMS aInstitOrd1 OF oPnlInstOrd1 SIZE 245,015 PIXEL FONT oFont ON CHANGE ChgCmbxInst()

oBmpBtDn := TBitmap():New( nLinha,( _aSize [1] + 250 ), 010, 011,, cBMPBTDn, .T., oPanel, {|| fChangeCmbx(1) },, .F., .T.,,, .T.,, .T.,, .F. )
oBmpBtDn :lAutoSize    := .F.
oBmpBtDn :lStretch     := .T.
oBmpBtDn :lTransparent := .F.

oBmpBtUp := TBitmap():New( nLinha,( _aSize [1] + 262 ), 010, 011,, cBMPBTUp, .T., oPanel, {|| fChangeCmbx(2) },, .F., .T.,,, .T.,, .T.,, .F. )
oBmpBtUp :lAutoSize    := .F.
oBmpBtUp :lStretch     := .T.
oBmpBtUp :lTransparent := .F.

@ nLinha,( _aSize [1] + 264 + 12 ) COMBOBOX oTipoDocumento Var cTipoDocumento ITEMS aTipoDocumento OF oPanel   SIZE 060,015 PIXEL ;
                                                                                                   FONT oFont ON CHANGE ChgTipoDoc()     ;
                                                                                                   WHEN lTelaModNormal

@ nLinha,( _aSize [1] + 329 + 12 ) COMBOBOX oSitAlocacao   Var cSitAlocacao   ITEMS aSitAlocacao   OF oPanel   SIZE 060,015 PIXEL ;
                                                                                                   FONT oFont ON CHANGE ChgSitAloc()     ;
                                                                                                   WHEN lTelaModNormal

@ nLinha,( _aSize [1] + 394 + 12 ) GET oNDocAlocacao       VAR cNDocAlocacao                       OF oPanel   SIZE 060,009 PIXEL ;
                                                                                                   FONT oFont WHEN .F.

@ nLinha,( _aSize [1] + 459 + 12 ) COMBOBOX oTranspTipoDoc VAR cTranspTipoDoc ITEMS aTranspTipoDoc OF oPanel   SIZE 060,015 PIXEL ;
                                                                                                   FONT oFont ON CHANGE ChgTipoTransp()  ;
                                                                                                   WHEN lTelaModNormal

@ nLinha,( _aSize [1] + 524 + 12 ) GET oNDocTransfere      VAR cNDocTransfere                      OF oPanel   SIZE 060,009 PIXEL ;
                                                                                                   FONT oFont                            ;
                                                                                                   WHEN .F.
                                                                                                   
nTopBrow     := _aSize [1] + 32
nTlEdicTop   := nTopBrow 

nLeftBrow    := _aSize [1]
nTlEdicLeft  := nLeftBrow

nBottomBrow  := _aSize [4] - 30
//nTlEdicBott  := _aSize [6] - 30 
nTlEdicBott  := _aSize [6] - 60 

nRigthBrow   := _aSize [3] - 63
nTlEdicRigt  := _aSize [5] - 265

nTlEdicLarg  := _aSize [3] - 200
nTlEdicAlt   := _aSize [4] - 100

nColButtons  := nRigthBrow + 3

oPnlInfo     := TPanel():New( ( nBottomBrow + 3 ), ( _aSize [1] + 3 ), OemToAnsi( "Informações Complementares:" ), oPanel, ,,,,, ( nRigthBrow - nLeftBrow ), 030, .F., .T. )

ExbTitsTransp( lSelTransp )

@ 009, 042 MSCOMBOBOX oListaTransp VAR cListaTransp ITEMS aListaTransp OF oPnlInfo SIZE 245,015 PIXEL FONT oFont WHEN lSelTransp
oQtdVolumes  := TGet():New( 009, 325, {|u| if(PCount()>0,nQtdVolumes:=u,nQtdVolumes)}, oPnlInfo, 020,009,"9999", ,,,,,,.T.,,, {|| lSelTransp },,,,,,, 'nQtdVolumes')
                  
@ nTopBrow          , nColButtons BUTTON cLblButFinaliza  SIZE 060,015 FONT oDlg:oFont ACTION (nOpc:=2,oDlg:End());
                                                                                                                      OF oPanel PIXEL
@ ( nTopBrow + 020 ), nColButtons BUTTON cLblButDesMarca  SIZE 060,015 FONT oDlg:oFont ACTION fDesmarca()    OF oPanel PIXEL
@ ( nTopBrow + 040 ), nColButtons BUTTON cLblButMarcaAll  SIZE 060,015 FONT oDlg:oFont ACTION fMarca()       OF oPanel PIXEL
@ ( nTopBrow + 060 ), nColButtons BUTTON cLblButInvMarca  SIZE 060,015 FONT oDlg:oFont ACTION fInverte()     OF oPanel PIXEL
@ ( nTopBrow + 080 ), nColButtons BUTTON cLblButFiltra    SIZE 060,015 FONT oDlg:oFont ACTION fFiltraBrow()  OF oPanel PIXEL
@ ( nTopBrow + 100 ), nColButtons BUTTON cLblTranspGerDoc SIZE 060,015 FONT oDlg:oFont ACTION MsAguarde( {|| fVerDocIRep(2) }, "Aguarde", OemToAnsi("Gerando documento de transporte..." ), .F. ) OF oPanel PIXEL WHEN fHabilBotao()
@ ( nTopBrow + 120 ), nColButtons BUTTON cLblAlocGerDoc   SIZE 060,015 FONT oDlg:oFont ACTION MsAguarde( {|| fVerDocIRep(1) }, "Aguarde", OemToAnsi("Gerando documento de alocação..."   ), .F. ) OF oPanel PIXEL WHEN fHabilBotao()
@ ( nTopBrow + 140 ), nColButtons BUTTON cLblGravar       SIZE 060,015 FONT oDlg:oFont ACTION MsAguarde( {|| fGravar()      }, "Aguarde", OemToAnsi("Gravando..."                        ), .F. ) OF oPanel PIXEL WHEN lTelaModNormal
@ ( nTopBrow + 160 ), nColButtons BUTTON cLblNovoDoc      SIZE 060,015 FONT oDlg:oFont ACTION MsAguarde( {|| fGeraDocNovo() }, "Aguarde", OemToAnsi("Gerando documento novo..." ), .F. );
                                                                                                                      OF oPanel PIXEL WHEN fHabilBotao()
@ ( nTopBrow + 180 ), nColButtons BUTTON cLblBut2         SIZE 060,015 FONT oDlg:oFont                       OF oPanel PIXEL WHEN .F.
                 
AADD( aCampos , { "MARK"      , "", cTxtTit1ColBrow, "" } )                      
AADD( aCampos , { "N1_XNUMPRO", "", cTxtTit2ColBrow, "" } )
AADD( aCampos , { "N1_CBASE"  , "", cTxtTit3ColBrow, "" } )
AADD( aCampos , { "N1_DESCRIC", "", cTxtTit4ColBrow, "" } )
AADD( aCampos , { "N1_NFISCAL", "", cTxtTit5ColBrow, "" } )
AADD( aCampos , { "N1_NSERIE" , "", cTxtTit6ColBrow, "" } )
AADD( aCampos , { "N1_CHAPA"  , "", cTxtTit7ColBrow, "" } )
AADD( aCampos , { "N1_XMARCA" , "", cTxtTit8ColBrow, "" } )
AADD( aCampos , { "N1_XMODELO", "", cTxtTit9ColBrow, "" } )
AADD( aCampos , { "N1_XSERIE" , "", cTxtTitAColBrow, "" } )
AADD( aCampos , { "N1_XDOCALO", "", cTxtTitBColBrow, "" } )
AADD( aCampos , { "N1_XDOCTRA", "", cTxtTitCColBrow, "" } )

oMarkBrowse := MSSelect():New( cNmArqGrid, "MARK",, aCampos, @lInverte, @cMarca,;
              { nTopBrow, nLeftBrow, nBottomBrow, nRigthBrow }, "(cNmArqGrid)->(DBGOTOP())","(cNmArqGrid)->(DBGOBOTTOM())",;
              oPanel,, fLegendas() )

oMarkBrowse :oBrowse:Show()
oMarkBrowse :oBrowse:bHeaderClick := {|oBrow,nCol| OrdenaBrow( oBrow:nColPos := nCol ) }

oMarkBrowse :oBrowse:SetHeaderImage( 3, "COLDOWN"  )
oMarkBrowse :oBrowse:SetHeaderImage( 4, "COLRIGHT" )
oMarkBrowse :oBrowse:SetHeaderImage( 5, "COLRIGHT" )

oMarkBrowse :oBrowse:bRClicked    := { || fExbTelaCad() }

( cNmArqGrid )->( DBGOTOP() )   

Eval(oMarkBrowse:oBrowse:bGoTop)
oMarkBrowse:oBrowse:Refresh()
                                
ACTIVATE MSDIALOG oDlg

If ( nOpc == 2 )   
   ( cNmArqAtvImob )->(DBCloseArea())
   ( cNmArqGrid    )->(DBCloseArea())
   
   MsErase(cNmArqAtvImob,,"TOPCONN")
   MsErase(cNmArqGrid   ,,"TOPCONN")
EndIf           

Return( Nil )

/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Static Function fGeraDocNovo()
/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Local cFornecedor := ""
Local cLoja       := ""
Local nRegistro   := Recno()

lGravDocsAlocTran := .F.

( cNmArqGrid )->(dbGoTop())
Do While ( cNmArqGrid )->(!Eof())
      
   If ( ( cNmArqGrid )->GRAVADO == "1" )

      RECLOCK( cNmArqGrid, .F. )
      ( cNmArqGrid )->GRAVADO := "2"
      MSUNLOCK()                             
   EndIf
      
   ( cNmArqGrid )->( DBSkip() )
Enddo
( cNmArqGrid )->( DBGOTO( nRegistro ) )
   
oMarkBrowse:oBrowse:Refresh()   

aSeqsTipoDoc  := {}
aSeqsTranTip  := {}
aAuxSqTipoDoc := {}
aAuxSqTranTip := {}

BuscaSeqs()

cSeqNDocAlocacao  := AllTrim( aSeqsTipoDoc[Ascan( aAuxSqTipoDoc, { |x|, x == AllTrim( cTipoDocumento ) } )][2] )
cNDocAlocacao     := SubStr( cNDocAlocacao, 1, 4 ) + cSeqNDocAlocacao

If ( AllTrim( cNDocTransfere ) <> "" )

   cSeqNDocTransfere := AllTrim( aSeqsTranTip[Ascan( aAuxSqTranTip, { |x|, x == AllTrim( cTranspTipoDoc ) } )][2] )
   cNDocTransfere    := SubStr( cNDocTransfere, 1, 3 ) + cSeqNDocTransfere
EndIf   

DBSelectArea(cNmArqGrid)         
SET FILTER TO

If ( oInstituicao:nAt == 1 )
   
   SET FILTER TO (cNmArqGrid)->GRAVADO <> "2"
Else   
   cFornecedor := SubStr( AllTrim( cInstituicao ),  1, 6 )
   cLoja       := SubStr( AllTrim( cInstituicao ), 10, 2 )
      
   If ( AllTrim( cFornecedor ) <> "" ) .And. ( AllTrim( cLoja ) <> "" )
    
      SET FILTER TO (cNmArqGrid)->N1_XCLIORG == cFornecedor .AND. (cNmArqGrid)->N1_XLOJAIN == cLoja .AND. (cNmArqGrid)->GRAVADO <> "2"
   EndIf
EndIf   

(cNmArqGrid)->( DBGoTop() )

Eval(oMarkBrowse:oBrowse:bGoTop)
oMarkBrowse:oBrowse:Refresh()

Return 

/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Static Function fExbTelaCad()
/* -------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------- */
Local _aSize     := MsAdvSize()    

Local nOpc       := 0
Local nRegistro  := Recno()
Local nCorTexto  := 0
Local nFieldSize

Local aCampos    := { { "cN1NFiscal", "C",  9, 0, .T., OemToAnsi( "Nota Fiscal")  , "@!"          , ""       },;
                      { "cN1NSerie ", "C",  3, 0, .T., OemToAnsi( "Série N.F.")   , ""            , ""       },;
                      { "cN1Chapa  ", "C",  7, 0, .T., OemToAnsi( "Num. Plaqueta"), "@!"          , ""       },;
                      { "nN1MesCPis", "N",  3, 0, .T., OemToAnsi( "Meses CI.Pis") , "999"         , ""       },;
                      { "cN1DiaCtb ", "C",  2, 0, .T., OemToAnsi( "Cod. Diário")  , "@!"          , "CVL"    },; 
                      { "cN1NoDia  ", "C", 10, 0, .T., OemToAnsi( "Seq. Diário")  , "@!"          , ""       },; 
                      { "dN1dtclass", "D",  8, 0, .T., OemToAnsi( "Data Classif") , ""            , ""       },; 
                      { "cN1CodCusd", "C", 20, 0, .T., OemToAnsi( "Cod. Custod.") , "@!"          , ""       },; 
                      { "cN1TpCustd", "C",  1, 0, .T., OemToAnsi( "Tipo Custod.") , "@!"          , ""       },; 
                      { "cN1TpBem  ", "C",  4, 0, .T., OemToAnsi( "Tipo Bem")     , "@!"          , "X5GEGF" },; 
                      { "cN1TpOutr ", "C", 50, 0, .T., OemToAnsi( "Tp. Outros")   , "@!"          , ""       },; 
                      { "cN1XCLIORG", "C",  6, 0, .T., OemToAnsi( "Organização")  , "@!"          , "SN1ORG" },; 
                      { "cN1XCODINS", "C",  6, 0, .T., OemToAnsi( "Instituição")  , "@!"          , "SN1CLI" },;  
                      { "cN1XLOJAIN", "C",  2, 0, .T., OemToAnsi( "Loja Inst.")   , "@!"          , ""       },; 
                      { "cN1XCONTAT", "C",  6, 0, .T., OemToAnsi( "Resp. Receb.") , "@!"          , "SN1CNT" },; 
                      { "cN1Xrespon", "C",  6, 0, .T., OemToAnsi( "Resp. Termo")  , "@!"          , "SN1RES" },; 
                      { "cN1XENDERE", "C",100, 0, .T., OemToAnsi( "Ender.Dest.")  , "@!"          , ""       },; 
                      { "cN1XESTINS", "C",  2, 0, .T., OemToAnsi( "Estado")       , "@!"          , ""       },; 
                      { "cN1XCEPINS", "C",  8, 0, .T., OemToAnsi( "CEP")          , "@R 99999-999", ""       },; 
                      { "cN1XNUMCOT", "C",  6, 0, .T., OemToAnsi( "Num. Cotação") , "@!"          , ""       },; 
                      { "cN1XNUMSC ", "C",  6, 0, .T., OemToAnsi( "Num. SC")      , "@!"          , ""       },; 
                      { "cN1XITEMSC", "C",  4, 0, .T., OemToAnsi( "Item da S.C")  , "@!"          , "SBMX"   },; 
                      { "cN1XCODSBM", "C",  4, 0, .T., OemToAnsi( "Despesa")      , "@!"          , ""       },; 
                      { "cN1XSBM   ", "C", 30, 0, .T., OemToAnsi( "Descrição")    , "@!"          , ""       },; 
                      { "mN1XEQUIPA", "M", 10, 0, .T., OemToAnsi( "Espec. Tecni") , ""            , ""       },; 
                      { "cN1XMarca ", "C", 15, 0, .T., OemToAnsi( "Marca")        , "@!"          , ""       },; 
                      { "cN1XModelo", "C", 15, 0, .T., OemToAnsi( "Modelo")       , "@!"          , ""       },; 
                      { "nN1XGARA  ", "N",  2, 0, .T., OemToAnsi( "Garantia")     , "@E 99"       , ""       },; 
                      { "cN1XSerie ", "C", 15, 0, .T., OemToAnsi( "Num. Série")   , "@!"          , ""       },; 
                      { "cN1XNUMPRO", "C", 15, 0, .T., OemToAnsi( "Número Proc.") , "@!"          , ""       },; 
                      { "cN1XMODALI", "C",  1, 0, .T., OemToAnsi( "Modalidade")   , "@!"          , ""       },; 
                      { "cN1XDOCALO", "C", 16, 0, .T., OemToAnsi( "Doc. Alocação"), "@!"          , ""       },; 
                      { "mXHIST    ", "M", 10, 0, .T., OemToAnsi( "Histórico")    , ""            , ""       },; 
                      { "cN1XPROJET", "C", 10, 0, .T., OemToAnsi( "Projeto")      , ""            , ""       },; 
                      { "cN1XREVIS ", "C",  4, 0, .T., OemToAnsi( "Rev.Proj.NDJ") , "@!"          , ""       },; 
                      { "cN1XTarefa", "C", 60, 0, .T., OemToAnsi( "Tarefa Proj.") , ""            , ""       },; 
                      { "cN1XCCPROJ", "C", 13, 0, .T., OemToAnsi( "CC Projeto")   , "@!"          , "CTT"    },;  
                      { "cN1XCODOR ", "C",  3, 0, .T., OemToAnsi( "Cod. Origem")  , "@!"          , "SZF"    },;   
                      { "cN1XDESCOR", "C", 30, 0, .T., OemToAnsi( "Descrição")    , "@!"          , ""       },;  
                      { "cN1XINCHRS", "C",  8, 0, .T., OemToAnsi( "Hr.Inclusão")  , "@!"          , ""       },;  
                      { "cN1XALTHRS", "C",  8, 0, .T., OemToAnsi( "Hr.Alteração") , "@!"          , ""       },;  
                      { "nN1XNproce", "N",  5, 0, .T., OemToAnsi( "Num.Processo") , "@!"          , ""       },;  
                      { "cN1XASSOCI", "C", 10, 0, .T., OemToAnsi( "It.Associado") , ""            , ""       },;  
                      { "cN1XPROCED", "C", 40, 0, .T., OemToAnsi( "Procedência")  , "@!"          , ""       },;  
                      { "cN1XVISCTB", "C", 13, 0, .T., OemToAnsi( "Visão Contab."), "@!"          , "CTDVIS" } }

Local oPanel   := Nil
Local oN1NFiscal := Nil
Local oN1NSerie  := Nil
Local oN1Chapa   := Nil 
Local oN1MesCPis := Nil 
Local oN1DiaCtb  := Nil 
Local oN1NoDia   := Nil 
Local oN1dtclass := Nil
Local oN1CodCusd := Nil
Local oN1TpCustd := Nil
Local oN1TpBem   := Nil
Local oN1TpOutr  := Nil
Local oN1XCLIORG := Nil
Local oN1XCODINS := Nil
Local oN1XLOJAIN := Nil
Local oN1XCONTAT := Nil
Local oN1Xrespon := Nil
Local oN1XENDERE := Nil
Local oN1XESTINS := Nil
Local oN1XCEPINS := Nil
Local oN1XNUMCOT := Nil
Local oN1XNUMSC  := Nil
Local oN1XITEMSC := Nil
Local oN1XCODSBM := Nil
Local oN1XSBM    := Nil
Local oN1XEQUIPA := Nil
Local oN1XMarca  := Nil 
Local oN1XModelo := Nil 
Local oN1XGARA   := Nil 
Local oN1XSerie  := Nil 
Local oN1XNUMPRO := Nil 
Local oN1XMODALI := Nil 
Local oN1XDOCALO := Nil 
Local oXHIST     := Nil
Local oN1XPROJET := Nil
Local oN1XREVIS  := Nil
Local oN1XTarefa := Nil
Local oN1XCCPROJ := Nil
Local oN1XCODOR  := Nil
Local oN1XDESCOR := Nil
Local oN1XINCHRS := Nil
Local oN1XALTHRS := Nil
Local oN1XNproce := Nil 
Local oN1XASSOCI := Nil 
Local oN1XPROCED := Nil 
Local oN1XVISCTB := Nil

Local cN1NFiscal := SPACE(  9)
Local cN1NSerie  := SPACE(  3)
Local cN1Chapa   := SPACE(  7)
Local nN1MesCPis := 0
Local cN1DiaCtb  := SPACE(  2)
Local cN1NoDia   := SPACE( 10)
Local dN1dtclass
Local cN1CodCusd := SPACE( 20)
Local cN1TpCustd := SPACE(  1)
Local cN1TpBem   := SPACE(  4)
Local cN1TpOutr  := SPACE( 50)
Local cN1XCLIORG := SPACE(  6)
Local cN1XCODINS := SPACE(  6)
Local cN1XLOJAIN := SPACE(  2)
Local cN1XCONTAT := SPACE(  6)
Local cN1Xrespon := SPACE(  6)
Local cN1XENDERE := SPACE(100)
Local cN1XESTINS := SPACE(  2)
Local cN1XCEPINS := SPACE(  8)
Local cN1XNUMCOT := SPACE(  6)
Local cN1XNUMSC  := SPACE(  6)
Local cN1XITEMSC := SPACE(  4)
Local cN1XCODSBM := SPACE(  4)
Local cN1XSBM    := SPACE( 30)
Local mN1XEQUIPA
Local cN1XMarca  := SPACE( 15)
Local cN1XModelo := SPACE( 15)
Local nN1XGARA   := 0
Local cN1XSerie  := SPACE( 15)
Local cN1XNUMPRO := SPACE( 15)
Local cN1XMODALI := SPACE(  1)
Local cN1XDOCALO := SPACE( 16)
Local mXHIST   
Local cN1XPROJET := SPACE( 10)
Local cN1XREVIS  := SPACE(  4)
Local cN1XTarefa := SPACE( 60)
Local cN1XCCPROJ := SPACE( 13)
Local cN1XCODOR  := SPACE(  3)
Local cN1XDESCOR := SPACE( 30)
Local cN1XINCHRS := SPACE(  8)
Local cN1XALTHRS := SPACE(  8)
Local nN1XNproce := 0
Local cN1XASSOCI := SPACE( 10)
Local cN1XPROCED := SPACE( 40)
Local cN1XVISCTB := SPACE( 13)
Local cTxtJanela := OemToAnsi( "Patrimônio - Edição de dados" )
Local clblTlRet  := "Retorna"
Local clblTlGrv  := "Gravar"
Local cDescCampo := ""        

DBSelectArea("SN1")
SN1->( DBGOTO( ( cNmArqGrid )->NUMREG ) )

cN1NFiscal := SN1->N1_NFiscal
cN1NSerie  := SN1->N1_NSerie
cN1Chapa   := SN1->N1_Chapa
nN1MesCPis := SN1->N1_MesCPis
cN1DiaCtb  := SN1->N1_DiaCtb
cN1NoDia   := SN1->N1_NoDia
dN1dtclass := SN1->N1_dtclass 
cN1CodCusd := SN1->N1_CodCusd
cN1TpCustd := SN1->N1_TpCustd
cN1TpBem   := SN1->N1_TpBem
cN1TpOutr  := SN1->N1_TpOutr
cN1XCLIORG := SN1->N1_XCLIORG
cN1XCODINS := SN1->N1_XCODINS
cN1XLOJAIN := SN1->N1_XLOJAIN
cN1XCONTAT := SN1->N1_XCONTAT
cN1Xrespon := SN1->N1_Xrespon
cN1XENDERE := SN1->N1_XENDERE
cN1XESTINS := SN1->N1_XESTINS
cN1XCEPINS := SN1->N1_XCEPINS
cN1XNUMCOT := SN1->N1_XNUMCOT
cN1XNUMSC  := SN1->N1_XNUMSC  
cN1XITEMSC := SN1->N1_XITEMSC
cN1XCODSBM := SN1->N1_XCODSBM
cN1XSBM    := SN1->N1_XSBM  
mN1XEQUIPA := SN1->N1_XEQUIPA
cN1XMarca  := SN1->N1_XMarca 
cN1XModelo := SN1->N1_XModelo 
nN1XGARA   := SN1->N1_XGARA 
cN1XSerie  := SN1->N1_XSerie 
cN1XNUMPRO := SN1->N1_XNUMPRO 
cN1XMODALI := SN1->N1_XMODALI 
cN1XDOCALO := SN1->N1_XDOCALO 
mXHIST     := SN1->N1_XHIST
cN1XPROJET := SN1->N1_XPROJET
cN1XREVIS  := SN1->N1_XREVIS
cN1XTarefa := SN1->N1_XTarefa 
cN1XCCPROJ := SN1->N1_XCCPROJ
cN1XCODOR  := SN1->N1_XCODOR
cN1XDESCOR := SN1->N1_XDESCOR
cN1XINCHRS := SN1->N1_XINCHRS
cN1XALTHRS := SN1->N1_XALTHRS
nN1XNproce := SN1->N1_XNproce
cN1XASSOCI := SN1->N1_XASSOCI
cN1XPROCED := SN1->N1_XPROCED
cN1XVISCTB := SN1->N1_XVISCTB

DBSelectArea(cNmArqGrid)
( cNmArqGrid )->( DBGOTO( nRegistro ) )

_aSize [1] := 1
_aSize [5] := 802

_aSize [1] += 40
_aSize [6] -= 80
_aSize [5] -= 40

oDlg   := MSDialog():New( nTlEdicTop, nTlEdicLeft, nTlEdicBott, nTlEdicRigt, cTxtJanela,,,,,, CLR_WHITE,, oMainWnd, .T. )

@ 000,000 MSPANEL oPanel OF oDlg
oPanel:Align    := CONTROL_ALIGN_ALLCLIENT

nTopo     := 1
nEsquerda := 1
nLargura  := nTlEdicLarg 
nAltura   := nTlEdicAlt  + 58
   
oScroll   := TScrollBox():New( oPanel, nTopo, nEsquerda, nAltura, nLargura, .T., .T., .T. )

_aSize [1] -= 40        


@ ( _aSize [1] + 002 ), ( nLargura + 5 ) BUTTON clblTlRet SIZE 060,015 FONT oDlg:oFont ACTION (nOpc:=1,oDlg:End()) OF oPanel PIXEL
@ ( _aSize [1] + 022 ), ( nLargura + 5 ) BUTTON clblTlGrv SIZE 060,015 FONT oDlg:oFont ACTION (nOpc:=2,oDlg:End()) OF oPanel PIXEL

nColunas   := 2
nLinhas    := 5

@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[01][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15 
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[02][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15    
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[03][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15 
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[04][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[05][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15 
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[06][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[07][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15 
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[08][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[09][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15 
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[10][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[11][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15 
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[12][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[13][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15 
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[14][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[15][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15 
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[16][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[17][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15 
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[18][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[19][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15 
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[20][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[21][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15 
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[22][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[23][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15 
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[24][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[25][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 35
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[26][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[27][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15 
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[28][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[29][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15 
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[30][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[31][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15 
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[32][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[33][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 35
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[34][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[35][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15 
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[36][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[37][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15 
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[38][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[39][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15 
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[40][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[41][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15 
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[42][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[43][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15 
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[44][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 15
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say aCampos[45][6] OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont COLOR If( nCorTexto == 0, CLR_BLACK, CLR_HBLUE )
nLinhas    += 05 
@ ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ) Say Space(5)       OF oScroll SIZE 060,009 PIXEL FONT oDlg:oFont

nColunas   := 45
nLinhas    := 4

nFieldSize := CalcFieldSize( aCampos[01][2], aCampos[01][3], aCampos[01][4], aCampos[01][7], aCampos[01][6] )
oN1NFiscal := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1NFiscal:=u,cN1NFiscal)}, oScroll, nFieldSize,009,aCampos[01][7], ,,,,,,.T.,,,,,,,,,, aCampos[01][1])
oN1NFiscal:cF3 := If( ( aCampos[01][8] <> "" ), aCampos[01][8], Nil )
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[02][2], aCampos[02][3], aCampos[02][4], aCampos[02][7], aCampos[02][6] )
oN1NSerie  := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1NSerie :=u,cN1NSerie )}, oScroll, nFieldSize,009,aCampos[02][7], ,,,,,,.T.,,,,,,,,,, aCampos[02][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[03][2], aCampos[03][3], aCampos[03][4], aCampos[03][7], aCampos[03][6] )
oN1Chapa   := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1Chapa  :=u,cN1Chapa  )}, oScroll, nFieldSize,009,aCampos[03][7], ,,,,,,.T.,,,,,,,,,, aCampos[03][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[04][2], aCampos[04][3], aCampos[04][4], aCampos[04][7], aCampos[04][6] )
oN1MesCPis := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,nN1MesCPis:=u,nN1MesCPis)}, oScroll, nFieldSize,009,aCampos[04][7], ,,,,,,.T.,,,,,,,,,, aCampos[04][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[05][2], aCampos[05][3], aCampos[05][4], aCampos[05][7], aCampos[05][6] )
oN1DiaCtb  := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1DiaCtb :=u,cN1DiaCtb )}, oScroll, nFieldSize,009,aCampos[05][7], ,,,,,,.T.,,,,,,,,,, aCampos[05][1])
oN1DiaCtb:cF3 := If( ( aCampos[05][8] <> "" ), aCampos[05][8], Nil )
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[06][2], aCampos[06][3], aCampos[06][4], aCampos[06][7], aCampos[06][6] )
oN1NoDia   := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1NoDia  :=u,cN1NoDia  )}, oScroll, nFieldSize,009,aCampos[06][7], ,,,,,,.T.,,,,,,,,,, aCampos[06][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[07][2], aCampos[07][3], aCampos[07][4], aCampos[07][7], aCampos[07][6] )
oN1dtclass := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,dN1dtclass:=u,dN1dtclass)}, oScroll, nFieldSize,009,aCampos[07][7], ,,,,,,.T.,,,,,,,,,, aCampos[07][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[08][2], aCampos[08][3], aCampos[08][4], aCampos[08][7], aCampos[08][6] )
oN1CodCusd := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1CodCusd:=u,cN1CodCusd)}, oScroll, nFieldSize,009,aCampos[08][7], ,,,,,,.T.,,,,,,,,,, aCampos[08][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[09][2], aCampos[09][3], aCampos[09][4], aCampos[09][7], aCampos[09][6] )
oN1TpCustd := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1TpCustd:=u,cN1TpCustd)}, oScroll, nFieldSize,009,aCampos[09][7], ,,,,,,.T.,,,,,,,,,, aCampos[09][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[10][2], aCampos[10][3], aCampos[10][4], aCampos[10][7], aCampos[10][6] )
oN1TpBem   := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1TpBem  :=u,cN1TpBem  )}, oScroll, nFieldSize,009,aCampos[10][7], ,,,,,,.T.,,,,,,,,,, aCampos[10][1])
oN1TpBem:cF3 := If( ( aCampos[10][8] <> "" ), aCampos[10][8], Nil )
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[11][2], aCampos[11][3], aCampos[11][4], aCampos[11][7], aCampos[11][6] )
oN1TpOutr  := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1TpOutr :=u,cN1TpOutr )}, oScroll, nFieldSize,009,aCampos[11][7], ,,,,,,.T.,,,,,,,,,, aCampos[11][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[12][2], aCampos[12][3], aCampos[12][4], aCampos[12][7], aCampos[12][6] )
oN1XCLIORG := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XCLIORG:=u,cN1XCLIORG)}, oScroll, nFieldSize,009,aCampos[12][7], ,,,,,,.T.,,,,,,,,,, aCampos[12][1])
oN1XCLIORG:cF3 := If( ( aCampos[12][8] <> "" ), aCampos[12][8], Nil )
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[13][2], aCampos[13][3], aCampos[13][4], aCampos[13][7], aCampos[13][6] )
oN1XCODINS := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XCODINS:=u,cN1XCODINS)}, oScroll, nFieldSize,009,aCampos[13][7], ,,,,,,.T.,,,,,,,,,, aCampos[13][1])
oN1XCODINS:cF3 := If( ( aCampos[13][8] <> "" ), aCampos[13][8], Nil )
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[14][2], aCampos[14][3], aCampos[14][4], aCampos[14][7], aCampos[14][6] )
oN1XLOJAIN := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XLOJAIN:=u,cN1XLOJAIN)}, oScroll, nFieldSize,009,aCampos[14][7], ,,,,,,.T.,,,,,,,,,, aCampos[14][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[15][2], aCampos[15][3], aCampos[15][4], aCampos[15][7], aCampos[15][6] )
oN1XCONTAT := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XCONTAT:=u,cN1XCONTAT)}, oScroll, nFieldSize,009,aCampos[15][7], ,,,,,,.T.,,,,,,,,,, aCampos[15][1])
oN1XCONTAT:cF3 := If( ( aCampos[15][8] <> "" ), aCampos[15][8], Nil )
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[16][2], aCampos[16][3], aCampos[16][4], aCampos[16][7], aCampos[16][6] )
oN1Xrespon := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1Xrespon:=u,cN1Xrespon)}, oScroll, nFieldSize,009,aCampos[16][7], ,,,,,,.T.,,,,,,,,,, aCampos[16][1])
oN1Xrespon:cF3 := If( ( aCampos[16][8] <> "" ), aCampos[16][8], Nil )
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[17][2], aCampos[17][3], aCampos[17][4], aCampos[17][7], aCampos[17][6] )
oN1XENDERE := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XENDERE:=u,cN1XENDERE)}, oScroll, nFieldSize,009,aCampos[17][7], ,,,,,,.T.,,,,,,,,,, aCampos[17][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[18][2], aCampos[18][3], aCampos[18][4], aCampos[18][7], aCampos[18][6] )
oN1XESTINS := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XESTINS:=u,cN1XESTINS)}, oScroll, nFieldSize,009,aCampos[18][7], ,,,,,,.T.,,,,,,,,,, aCampos[18][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[19][2], aCampos[19][3], aCampos[19][4], aCampos[19][7], aCampos[19][6] )
oN1XCEPINS := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XCEPINS:=u,cN1XCEPINS)}, oScroll, nFieldSize,009,aCampos[19][7], ,,,,,,.T.,,,,,,,,,, aCampos[19][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[20][2], aCampos[20][3], aCampos[20][4], aCampos[20][7], aCampos[20][6] )
oN1XNUMCOT := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XNUMCOT:=u,cN1XNUMCOT)}, oScroll, nFieldSize,009,aCampos[20][7], ,,,,,,.T.,,,,,,,,,, aCampos[20][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[21][2], aCampos[21][3], aCampos[21][4], aCampos[21][7], aCampos[21][6] )
oN1XNUMSC  := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XNUMSC :=u,cN1XNUMSC )}, oScroll, nFieldSize,009,aCampos[21][7], ,,,,,,.T.,,,,,,,,,, aCampos[21][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[22][2], aCampos[22][3], aCampos[22][4], aCampos[22][7], aCampos[22][6] )
oN1XITEMSC := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XITEMSC:=u,cN1XITEMSC)}, oScroll, nFieldSize,009,aCampos[22][7], ,,,,,,.T.,,,,,,,,,, aCampos[22][1])
oN1XITEMSC:cF3 := If( ( aCampos[22][8] <> "" ), aCampos[22][8], Nil )
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[23][2], aCampos[23][3], aCampos[23][4], aCampos[23][7], aCampos[23][6] )
oN1XCODSBM := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XCODSBM:=u,cN1XCODSBM)}, oScroll, nFieldSize,009,aCampos[23][7], ,,,,,,.T.,,,,,,,,,, aCampos[23][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[24][2], aCampos[24][3], aCampos[24][4], aCampos[24][7], aCampos[24][6] )
oN1XSBM    := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XSBM   :=u,cN1XSBM   )}, oScroll, nFieldSize,009,aCampos[24][7], ,,,,,,.T.,,,,,,,,,, aCampos[24][1])
nLinhas    += 15

nFieldSize := 200
oN1XEQUIPA := TMultiget():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,mN1XEQUIPA:=u,mN1XEQUIPA)}, oScroll, nFieldSize, 029,,.T.,,,,.T.,,,,,,.F.,,,,.F.,.T.)
nLinhas    += 35

nFieldSize := CalcFieldSize( aCampos[26][2], aCampos[26][3], aCampos[26][4], aCampos[26][7], aCampos[26][6] )
oN1XMarca  := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XMarca :=u,cN1XMarca )}, oScroll, nFieldSize,009,aCampos[26][7], ,,,,,,.T.,,,,,,,,,, aCampos[26][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[27][2], aCampos[27][3], aCampos[27][4], aCampos[27][7], aCampos[27][6] )
oN1XModelo := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XModelo:=u,cN1XModelo)}, oScroll, nFieldSize,009,aCampos[27][7], ,,,,,,.T.,,,,,,,,,, aCampos[27][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[28][2], aCampos[28][3], aCampos[28][4], aCampos[28][7], aCampos[28][6] )
oN1XGARA   := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,nN1XGARA  :=u,nN1XGARA  )}, oScroll, nFieldSize,009,aCampos[28][7], ,,,,,,.T.,,,,,,,,,, aCampos[28][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[29][2], aCampos[29][3], aCampos[29][4], aCampos[29][7], aCampos[29][6] )
oN1XSerie  := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XSerie :=u,cN1XSerie )}, oScroll, nFieldSize,009,aCampos[29][7], ,,,,,,.T.,,,,,,,,,, aCampos[29][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[30][2], aCampos[30][3], aCampos[30][4], aCampos[30][7], aCampos[30][6] )
oN1XNUMPRO := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XNUMPRO:=u,cN1XNUMPRO)}, oScroll, nFieldSize,009,aCampos[30][7], ,,,,,,.T.,,,,,,,,,, aCampos[30][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[31][2], aCampos[31][3], aCampos[31][4], aCampos[31][7], aCampos[31][6] )
oN1XMODALI := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XMODALI:=u,cN1XMODALI)}, oScroll, nFieldSize,009,aCampos[31][7], ,,,,,,.T.,,,,,,,,,, aCampos[31][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[32][2], aCampos[32][3], aCampos[32][4], aCampos[32][7], aCampos[32][6] )
oN1XDOCALO := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XDOCALO:=u,cN1XDOCALO)}, oScroll, nFieldSize,009,aCampos[32][7], ,,,,,,.T.,,,,,,,,,, aCampos[32][1])
nLinhas    += 15

nFieldSize := 200
oN1XEQUIPA := TMultiget():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,mXHIST:=u,mXHIST )}, oScroll, nFieldSize, 029,,.T.,,,,.T.,,,,,,.F.,,,,.F.,.T.)
nLinhas    += 35

nFieldSize := CalcFieldSize( aCampos[34][2], aCampos[34][3], aCampos[34][4], aCampos[34][7], aCampos[34][6] )
oN1XPROJET := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XPROJET:=u,cN1XPROJET)}, oScroll, nFieldSize,009,aCampos[34][7], ,,,,,,.T.,,,,,,,,,, aCampos[34][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[35][2], aCampos[35][3], aCampos[35][4], aCampos[35][7], aCampos[35][6] )
oN1XREVIS  := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XREVIS :=u,cN1XREVIS )}, oScroll, nFieldSize,009,aCampos[35][7], ,,,,,,.T.,,,,,,,,,, aCampos[35][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[36][2], aCampos[36][3], aCampos[36][4], aCampos[36][7], aCampos[36][6] )
oN1XTarefa := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XTarefa:=u,cN1XTarefa)}, oScroll, nFieldSize,009,aCampos[36][7], ,,,,,,.T.,,,,,,,,,, aCampos[36][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[37][2], aCampos[37][3], aCampos[37][4], aCampos[37][7], aCampos[37][6] )
oN1XCCPROJ := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XCCPROJ:=u,cN1XCCPROJ)}, oScroll, nFieldSize,009,aCampos[37][7], ,,,,,,.T.,,,,,,,,,, aCampos[37][1])
oN1XCCPROJ:cF3 := If( ( aCampos[37][8] <> "" ), aCampos[37][8], Nil )
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[38][2], aCampos[38][3], aCampos[38][4], aCampos[38][7], aCampos[38][6] )
oN1XCODOR  := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XCODOR :=u,cN1XCODOR )}, oScroll, nFieldSize,009,aCampos[38][7], ,,,,,,.T.,,,,,,,,,, aCampos[38][1])
oN1XCODOR:cF3 := If( ( aCampos[38][8] <> "" ), aCampos[38][8], Nil )
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[39][2], aCampos[39][3], aCampos[39][4], aCampos[39][7], aCampos[39][6] )
oN1XDESCOR := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XDESCOR:=u,cN1XDESCOR)}, oScroll, nFieldSize,009,aCampos[39][7], ,,,,,,.T.,,,,,,,,,, aCampos[39][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[40][2], aCampos[40][3], aCampos[40][4], aCampos[40][7], aCampos[40][6] )
oN1XINCHRS := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XINCHRS:=u,cN1XINCHRS)}, oScroll, nFieldSize,009,aCampos[40][7], ,,,,,,.T.,,,,,,,,,, aCampos[40][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[41][2], aCampos[41][3], aCampos[41][4], aCampos[41][7], aCampos[41][6] )
oN1XALTHRS := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XALTHRS:=u,cN1XALTHRS)}, oScroll, nFieldSize,009,aCampos[41][7], ,,,,,,.T.,,,,,,,,,, aCampos[41][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[42][2], aCampos[42][3], aCampos[42][4], aCampos[42][7], aCampos[42][6] )
oN1XNproce := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,nN1XNproce:=u,nN1XNproce)}, oScroll, nFieldSize,009,aCampos[42][7], ,,,,,,.T.,,,,,,,,,, aCampos[42][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[43][2], aCampos[43][3], aCampos[43][4], aCampos[43][7], aCampos[43][6] )
oN1XASSOCI := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XASSOCI:=u,cN1XASSOCI)}, oScroll, nFieldSize,009,aCampos[43][7], ,,,,,,.T.,,,,,,,,,, aCampos[43][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[44][2], aCampos[44][3], aCampos[44][4], aCampos[44][7], aCampos[44][6] )
oN1XPROCED := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XPROCED:=u,cN1XPROCED)}, oScroll, nFieldSize,009,aCampos[44][7], ,,,,,,.T.,,,,,,,,,, aCampos[44][1])
nLinhas    += 15

nFieldSize := CalcFieldSize( aCampos[45][2], aCampos[45][3], aCampos[45][4], aCampos[45][7], aCampos[45][6] )
oN1XVISCTB := TGet():New( ( _aSize [1] + nLinhas ), ( _aSize [1] + nColunas ), {|u| if(PCount()>0,cN1XVISCTB:=u,cN1XVISCTB)}, oScroll, nFieldSize,009,aCampos[45][7], ,,,,,,.T.,,,,,,,,,, aCampos[45][1])
oN1XVISCTB:cF3 := If( ( aCampos[45][8] <> "" ), aCampos[45][8], Nil )
nLinhas    += 15

ACTIVATE MSDIALOG oDlg

If ( nOpc == 2 )

   DBSelectArea("SN1")
   SN1->( DBGOTO( ( cNmArqGrid )->NUMREG ) )
   
   RECLOCK( "SN1", .F. )      
   SN1->N1_NFiscal := cN1NFiscal
   SN1->N1_NSerie  := cN1NSerie  
   SN1->N1_Chapa   := cN1Chapa    
   SN1->N1_MesCPis := nN1MesCPis
   SN1->N1_DiaCtb  := cN1DiaCtb   
   SN1->N1_NoDia   := cN1NoDia    
   SN1->N1_dtclass := dN1dtclass  
   SN1->N1_CodCusd := cN1CodCusd  
   SN1->N1_TpCustd := cN1TpCustd  
   SN1->N1_TpBem   := cN1TpBem    
   SN1->N1_TpOutr  := cN1TpOutr   
   SN1->N1_XCLIORG := cN1XCLIORG  
   SN1->N1_XCODINS := cN1XCODINS  
   SN1->N1_XLOJAIN := cN1XLOJAIN  
   SN1->N1_XCONTAT := cN1XCONTAT  
   SN1->N1_Xrespon := cN1Xrespon  
   SN1->N1_XENDERE := cN1XENDERE  
   SN1->N1_XESTINS := cN1XESTINS
   SN1->N1_XCEPINS := cN1XCEPINS
   SN1->N1_XNUMCOT := cN1XNUMCOT
   SN1->N1_XNUMSC  := cN1XNUMSC   
   SN1->N1_XITEMSC := cN1XITEMSC  
   SN1->N1_XCODSBM := cN1XCODSBM  
   SN1->N1_XSBM    := cN1XSBM     
   SN1->N1_XEQUIPA := mN1XEQUIPA  
   SN1->N1_XMarca  := cN1XMarca   
   SN1->N1_XModelo := cN1XModelo  
   SN1->N1_XGARA   := nN1XGARA    
   SN1->N1_XSerie  := cN1XSerie   
   SN1->N1_XNUMPRO := cN1XNUMPRO  
   SN1->N1_XMODALI := cN1XMODALI  
   SN1->N1_XDOCALO := cN1XDOCALO  
   SN1->N1_XHIST   := mXHIST      
   SN1->N1_XPROJET := cN1XPROJET  
   SN1->N1_XREVIS  := cN1XREVIS   
   SN1->N1_XTarefa := cN1XTarefa  
   SN1->N1_XCCPROJ := cN1XCCPROJ  
   SN1->N1_XCODOR  := cN1XCODOR   
   SN1->N1_XDESCOR := cN1XDESCOR  
   SN1->N1_XINCHRS := cN1XINCHRS  
   SN1->N1_XALTHRS := cN1XALTHRS 
   SN1->N1_XNproce := nN1XNproce 
   SN1->N1_XASSOCI := cN1XASSOCI 
   SN1->N1_XPROCED := cN1XPROCED 
   SN1->N1_XVISCTB := cN1XVISCTB          
   MSUNLOCK()                       
   
   DBSelectArea(cNmArqGrid)
   ( cNmArqGrid )->( DBGOTO( nRegistro ) )
   
   RECLOCK( cNmArqGrid, .F. )
   ( cNmArqGrid )->N1_XNUMPRO := cN1XNUMPRO
   ( cNmArqGrid )->N1_XMARCA  := cN1XMARCA
   ( cNmArqGrid )->N1_XMODELO := cN1XMODELO
   ( cNmArqGrid )->N1_XSERIE  := cN1XSERIE
   ( cNmArqGrid )->GRAVADO    := "0"
   MSUNLOCK()                       
   
   If ( AllTrim((cNmArqGrid)->MARK) == "" )
   
      aBrowMarca( cNmArqGrid, cMarca, 1, .F., .F. )
   EndIf      

   oMarkBrowse:oBrowse:Refresh()
   
   MsgInfo( OemtoAnsi( "Gravação de dados concluída com sucesso!" ) )   
EndIf
Return
