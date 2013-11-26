#INCLUDE "NDJ.CH"
/*/
	Funcao:		MT110COR
	Autor:		Marinaldo de Jesus
	Descricao:	Implementacao do Ponto de Entrada MT110COR executado na funcao MATA110
				do programa MATA110 Tratamento de cores na mBrowse
/*/
User Function MT110COR()

	Local aCores	:= ParamIxb[1]
	
	Local nBmpPos

	IF !( ValType( aCores ) == "A" )
		aCores := {}
	EndIF
    
	IF (SC1->( FieldPos( "C1_APROV" ) ) > 0 )

		aAdd( aCores , { "C1_APROV=='1'" , "CRDIMG16" } )		//"Em Pr้-Analise"
		aAdd( aCores , { "C1_APROV=='2'" , "CFGIMG16" } )		//"Suspensa ou Aguardando Altera็๕es"

	EndIF
	
	nBmpPos	:= aScan( aCores , { |aBmp| Upper( AllTrim( aBmp[2] ) ) == "BR_AMARELO" } )
	IF ( nBmpPos > 0 )
		IF !( "C1_QUANT" $ aCores[ nBmpPos ][1] )
			aCores[ nBmpPos ][1] += " .AND. C1_QUJE<>C1_QUANT"	//Redefine SC Parcialmente Atendida
		EndIF	
	EndIF

	aCores[ nBmpPos ][1] := aCores[ nBmpPos ][1]

	IF IsInCallStack( "GetC1Status" )
		__aColors_ := aCores
		UserException( "IGetC1Status" )
	EndIF

	MT110COR() //Para carregas as Publics

Return( aCores )      

/*/
	Funcao:		GetC1Status
	Autor:		Marinaldo de Jesus
	Descricao:	Retornar o Status da SC1 conforme Array de Cores da mBrowse
	Sintaxe:	StaticCall( U_MT110COR , GetC1Status , cAlias , cResName , lArrColors )
/*/
Static Function GetC1Status( cAlias , cResName , lArrColors )

	Local bGetColors	:= { || Mata110() }			
	Local bGetLegend	:= { || A110Legenda() }

	DEFAULT cAlias 		:= "SC1"

Return( StaticCall( NDJLIB001 , BrwGetSLeg , @cAlias , @bGetColors , @bGetLegend , @cResName , @lArrColors ) )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MT110COR บ Autor ณ Jose Carlos Noronhaบ Data ณ  19/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de entrada executado no cadastro de clientes para    นฑฑ
ฑฑบ          ณ declarar a variavel como publica utilizada na consulta     นฑฑ
ฑฑบ          ณ rapida.                                                    นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/
Static Function MT110COR()

    StaticCall( NDJLIB004 , SetPublic , "lCopItSC1" , .T. )
    StaticCall( NDJLIB004 , SetPublic , "aColsSC1" , NIL , "A" , 0 , .T. )

Return( NIL )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
		GetC1Status()
		MT110COR()
		lRecursa	:= __Dummy( .F. )
		__cCRLF		:= NIL
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )