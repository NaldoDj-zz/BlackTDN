#INCLUDE "NDJ.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AT010GRV บ Autor ณ Jose Carlos Noronhaบ Data ณ  15/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de entrada executado na grava็ใo das Informa็๕es     นฑฑ
ฑฑ             do Ativo, que serแ utilizado para levar as informa็๕es da  นฑฑ
ฑฑ             tabela de Itens da Nota Fiscal de Entrada (SD1) para a     นฑฑ
ฑฑ             tabela de Ativo Imobilizado (SN1).                         นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function AT010GRV()

Local aFromTo    := {}

Local cNumCot

V_Alias := Alias()
IF IsInCallStack( "MATA103" )
    
    PutToFrom( @aFromTo , "N1_XEQUIPA" , "D1_XEQUIPA"    )
    PutToFrom( @aFromTo , "N1_XCODSBM" , "D1_XCODSBM"    )
    PutToFrom( @aFromTo , "N1_XSBM"    , "D1_XSBM"         )
    PutToFrom( @aFromTo , "N1_XGARA"   , "D1_XGARA"     )
    PutToFrom( @aFromTo , "N1_XMODALI" , "D1_XMODALI"     )
    PutToFrom( @aFromTo , "N1_XNUMPRO" , "D1_XNUMPRO"     )
    PutToFrom( @aFromTo , "N1_XPROP1"  , "D1_XPROP1"     )
    PutToFrom( @aFromTo , "N1_XMODELO" , "D1_XMODELO"     )
    PutToFrom( @aFromTo , "N1_XMARCA"  , "D1_XMARCA"     )
    PutToFrom( @aFromTo , "N1_XNUMSC"  , "D1_XNUMSC"     )
    PutToFrom( @aFromTo , "N1_XITEMSC" , "D1_XITEMSC"     )
    PutToFrom( @aFromTo , "N1_XPROJET" , "D1_XPROJET"     )
    PutToFrom( @aFromTo , "N1_XREVIS"  , "D1_XREVIS"     )
    PutToFrom( @aFromTo , "N1_XTAREFA" , "D1_XTAREFA"     )
    PutToFrom( @aFromTo , "N1_XVISCTB" , "D1_XVISCTB"     )

    StaticCall( NDJLIB001 , NDJFromTo , "SD1" , "SN1" , @aFromTo )

    cNumCot := POSICIONE("SC7",1,xFilial("SC7")+SD1->(D1_PEDIDO+D1_ITEMPC),"C7_NUMCOT")
    StaticCall( NDJLIB001 , __FieldPut , "SN1" , "N1_XNUMCOT" , cNumCot , .T. )

    If (;
            ( Type("l103Class") == "L" );
            .and.;
            ( l103Class );
        )    
            U_ENDERSZ4()
    Endif
EndIF

DbSelectArea(V_Alias)

Return

/*/
ฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟ
ณFun…o    ณPutToFrom        ณAutorณMarinaldo de Jesusณ Data ณ23/11/2010ณ
รฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤด
ณDescri…o ณCarrega o Array para o De Para                                ณ
รฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด
ณSintaxe   ณ<Vide Parametros Formais>                                    ณ
รฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด
ณParametrosณ<Vide Parametros Formais>                                    ณ
รฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด
ณUso       ณGenerico                                                    ณ
ภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู/*/
Static Function PutToFrom( aFromTo, cTo , cFrom )
    aAdd( aFromTo, { cFrom , cTo } )
Return( NIL )

//
// 23/11/2010 - Noronha - Gravar Endere็os na SN1 para os itens do PC que foram distribuidos na SZ4
//
User Function ENDERSZ4

Local _cCodSZ4 := SD1->D1_XSZ2COD
Local _cNumSC  := SD1->D1_XNUMSC
Local _cItemSC := SD1->D1_XITEMSC
Local _cSequen := SD1->D1_XSEQUEN

Local nSZ4Order := RetOrder("SZ4","Z4_FILIAL+Z4_CODIGO+Z4_NUMSC+Z4_ITEMSC+Z4_SECITEM")

dbselectarea("SD1")

dbselectarea("SZ4")
dbsetorder(nSZ4Order)
dbseek(xFilial("SZ4")+_cCodSZ4+_cNumSC+_cItemSC+_cSequen)
dbselectarea("SN1")
IF Reclock("SN1",.F.)
    SN1->N1_XCLIORG    := SZ4->Z4_XCLIORG
    SN1->N1_XCODINS    := SZ4->Z4_XCLIINS
    SN1->N1_XLOJAIN    := SZ4->Z4_XLOJAIN
    SN1->N1_XCONTAT    := SZ4->Z4_XCONTAT
    SN1->N1_XRESPON    := SZ4->Z4_XRESPON 
    SN1->N1_XENDERE    := SZ4->Z4_XENDER
    SN1->N1_XESTINS    := SZ4->Z4_XESTINS
    SN1->N1_XCEPINS    := SZ4->Z4_XCEPINS
    If SN1->N1_ITEM <> "0001"
        If Type("nItemSN1") <> "U"
            nItemSN1++
            SN1->N1_ITEM := StrZero(nItemSN1,4)
        Endif
    Endif
    SN1->N1_XDESFOR := POSICIONE('SA2',1,XFILIAL('SA2')+SN1->(N1_FORNEC+N1_LOJA),'A2_NOME')
    SN1->N1_XCCPROJ := SD1->D1_CC
    SN1->N1_XCODOR  := SD1->D1_XCODOR
    SN1->N1_XDESCOR := POSICIONE('SZF',1,XFILIAL('SZF')+STR(VAL(SN1->N1_XCODOR),3),'ZF_XDESORI')
    SN1->( Msunlock() )
EndIF    

Return

Static Function _Dummy( lExit )
    Local oException
    TRYEXCEPTION
        DEFAULT lExit := .T.
        _Dummy( lExit )
        IF ( lExit )
            BREAK
        EndIF
        __cCRLF        := NIL    
    CATCHEXCEPTION USING oException
        IF ( ValType( oException ) == "O" )
            ConOut( oException:Description )
        EndIF
    ENDEXCEPTION
Return( NIL )
