#INCLUDE "NDJ.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPMA110GERA บ Autor ณ Jose Carlos Noronhaบ Data ณ  18/10/10  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de entrada executado na                              นฑฑ
ฑฑ           ณ com de/para entre as tabelas AF1 e AF8.                    นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/
User Function PMA110GERA()

    Local aArea            := GetArea()
    Local aFromTo        := {}

    PutToFrom( @aFromTo , "AF8_XCODTA"    , "AF1_XCODTA" ) 
    PutToFrom( @aFromTo , "AF8_XDESTA"    , "AF1_XDESTA" ) 

    PutToFrom( @aFromTo , "AF8_XCODOR"     , "AF1_XCODOR" ) 
    PutToFrom( @aFromTo , "AF8_XDORIG"    , "AF1_XDORIG" ) 

    PutToFrom( @aFromTo , "AF8_XCODSP"     , "AF1_XCODSP" ) 
    PutToFrom( @aFromTo , "AF8_XSPO"     , "AF1_XSPO"   ) 

    PutToFrom( @aFromTo , "AF8_XCODGE"     , "AF1_XCODGE" ) 
    PutToFrom( @aFromTo , "AF8_XGER"     , "AF1_XGER"   ) 

    PutToFrom( @aFromTo , "AF8_XCODPR"     , "AF1_XCODPR" ) 
    PutToFrom( @aFromTo , "AF8_XDPROG"     , "AF1_XDPROG" ) 

    PutToFrom( @aFromTo , "AF8_XCODDI"     , "AF1_XCODDI" ) 
    PutToFrom( @aFromTo , "AF8_XDIR"     , "AF1_XDIR"   ) 

    PutToFrom( @aFromTo , "AF8_XCODOE"     , "AF1_XCODOE" ) 
    PutToFrom( @aFromTo , "AF8_XDESC"     , "AF1_XDESC"  ) 

    PutToFrom( @aFromTo , "AF8_XCOPM"     , "AF1_XCOPM"  ) 
    PutToFrom( @aFromTo , "AF8_XPMORG"     , "AF1_XPMORG" ) 

    PutToFrom( @aFromTo , "AF8_XCODIS"     , "AF1_XCODIS" ) 
    PutToFrom( @aFromTo , "AF8_XINDS"     , "AF1_XINDS"  ) 

    PutToFrom( @aFromTo , "AF8_XCODTE"     , "AF1_XCODTE" ) 
    PutToFrom( @aFromTo , "AF8_XTEMA"     , "AF1_XTEMA"  ) 

    PutToFrom( @aFromTo , "AF8_XCODUN"     , "AF1_XCODUN" ) 
    PutToFrom( @aFromTo , "AF8_XUNIOR"     , "AF1_XUNIOR" ) 

    PutToFrom( @aFromTo , "AF8_XCODMA"     , "AF1_XCODMA" ) 
    PutToFrom( @aFromTo , "AF8_XMACRO"     , "AF1_XMACRO" ) 

    PutToFrom( @aFromTo , "AF8_XCODIN"     , "AF1_XCODIN" ) 
    PutToFrom( @aFromTo , "AF8_XIND"     , "AF1_XIND"   ) 

    PutToFrom( @aFromTo , "AF8_XCODUN"    , "AF1_XCODUN" ) 
    PutToFrom( @aFromTo , "AF8_XDESUN"     , "AF1_XDESUN" ) 

    StaticCall( NDJLIB001 , NDJFromTo , "AF1" , "AF8" , @aFromTo )

    RestArea( aArea )

Return( NIL )

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
                                                
Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        lRecursa    := __Dummy( .F. )
        __cCRLF        := NIL
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
