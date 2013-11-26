#ifdef SPANISH
	#define STR0001 "Este programa imprimira el mayor por"
	#define STR0002 " de acuerdo con los parametros sugeridos por el usuario."
	#define STR0004 "A Rayas"
	#define STR0005 "Administracion"
	#define STR0006 "Emision del mayor contable por "
	#define STR0007 "MAYOR POR "
	#define STR0008 " ANALITICO EN "
	#define STR0009 "DE"
	#define STR0010 "A "
	#define STR0011 "(PRESUP.)"
	#define STR0012 "(GESTION)"
	Static  STR0013 :=  "LOTE/SUB/DOC/LINEA H I S T O R I A L                        COMPENSAC"
	Static  STR0014 :=  "LOTE/SUB/DOC/LINEA H I S T O R I A L                        C/PARTIDA                      DEBITO          CREDITO       SALDO ACTUAL"
	#define STR0015 "***** ANULADO POR EL OPERADOR *****"
	#define STR0016 "ITEM  - "
	#define STR0017 "T o t a l  "
	#define STR0018 "Creando archivo temporal..."
	#define STR0019 "FECHA"
	#define STR0020 "T o t a l  de la  C u e n t a ==> "
	#define STR0021 " SINTETICO EN "
	#define STR0022 "POR TRANSPORTAR : "
	#define STR0023 "DE TRANSPORTE : "
	#define STR0024 "CUENTA - "
	Static  STR0025 :=  "FECHA                                                                            DEBITO               CREDITO            SALDO ACTUAL"
	Static  STR0026 :=  "DEBITO         CREDITO     SALDO ACTUAL"
	#define STR0027 "SALDO ANTERIOR:"
	#define STR0028 "Item"
	#define STR0029 "Asientos Contables   "
	#define STR0030 "FCHA"		
	#define STR0031 "LOTE/SUB/DOC/LINEA"
	#define STR0032 "HISTORIAL"
	#define STR0033 "XPARTIDA"
	Static  STR0034 :=  "DEBITO"
	Static  STR0035 :=  "CREDITO"
	#define STR0036 "SALDO ACT. "
	#define STR0037 "Total."
	#define STR0038 "Complemento"
	#define STR0039 "DESCRIPC."
#else
	#ifdef ENGLISH
		#define STR0001 "This program will print the Ledger by "
		#define STR0002 " according to the parameters selected by the user. "
		#define STR0004 "Z.Form"
		#define STR0005 "Management"
		#define STR0006 "Print Accounting Ledger by "
		#define STR0007 " LEDGER BY "
		#define STR0008 " DETAILED IN "
		#define STR0009 "FROM"
		#define STR0010 "TO"
		#define STR0011 "(BUDGETED)"
		#define STR0012 "(MANAGERIAL)"
		Static  STR0013 :=  "LOT/SUB/DOC/LINE HISTORY                                    W/ENTRY  "
		Static  STR0014 :=  "LOT /SUB/DOC/LINE  H I S T O R Y                            W/ENTRY                        DEBIT           CREDIT        CURR.BALAC."
		#define STR0015 "***** CANCELLED BY OPERATOR   *****"
		#define STR0016 "ITEM  - "
		#define STR0017 " T o t a l s  "
		#define STR0018 "Creating Temporary File..."
		#define STR0019 "DATE"
		#define STR0020 "A c c o u n t    T o t a l   ==> "
		#define STR0021 " SUMMARIZED IN "
		#define STR0022 "TO TRANSPORT : "
		#define STR0023 "FROM TRANSPORT : "
		#define STR0024 "ACCOUNT - "
		Static  STR0025 :=  "DATE                                                                             DEBIT                CREDIT           CURR.BALANCE"
		Static  STR0026 :=  "DEBIT          CREDIT       CURR.BALAC."
		#define STR0027 "PREVIOUS BALANCE:"
		#define STR0028 "Item"
		#define STR0029 "Accounting entries   "
		#define STR0030 "DATE"		
		#define STR0031 "LOT/SUB/DOC/LINE  "
		#define STR0032 "HISTORY  "
		#define STR0033 "X ENTRY "
		Static  STR0034 :=  "DEBIT "
		Static  STR0035 :=  "CREDIT "
		#define STR0036 "CURRENT BLN"
		#define STR0037 "Totals"
		#define STR0038 "Complement "
		#define STR0039 "DESCRIPT."
	#else
		#define STR0001 "Este programa ira imprimir o Razao por "
		#define STR0002 " de acordo com os parametros sugeridos pelo usuario. "
		#define STR0004 "Zebrado"
		#define STR0005 "Administracao"
		#define STR0006 "Emissao do Razao Contabil por "
		#define STR0007 "RAZAO POR "
		#define STR0008 " ANALITICO EM  "
		#define STR0009 "DE"
		#define STR0010 "ATE"
		#define STR0011 "(ORCADO)"
		#define STR0012 "(GERENCIAL)"
		Static  STR0013 :=  "LOTE/SUB/DOC/LINHA H I S T O R I C O                        C/PARTIDA"
		Static  STR0014 :=  "LOTE/SUB/DOC/LINHA H I S T O R I C O                        C/PARTIDA                      DEBITO          CREDITO       SALDO ATUAL"
		#define STR0015 "***** CANCELADO PELO OPERADOR *****"
		#define STR0016 "ITEM  - "
		#define STR0017 "T o t a i s  "
		#define STR0018 "Criando Arquivo Temporario..."
		#define STR0019 "DATA"
		#define STR0020 "T o t a i s  d a  C o n t a  ==> "
		#define STR0021 " SINTETICO EM "
		#define STR0022 "A TRANSPORTAR : "
		#define STR0023 "DE TRANSPORTE : "
		#define STR0024 "CONTA - "
		Static  STR0025 :=  "DATA                                                                            DEBITO               CREDITO            SALDO ATUAL"
		Static  STR0026 :=  "DEBITO         CREDITO      SALDO ATUAL"
		#define STR0027 "SALDO ANTERIOR:"
		#define STR0028 "Item"
		#define STR0029 "Lançamentos Contábeis"
		#define STR0030 "DATA"		
		#define STR0031 "LOTE/SUB/DOC/LINHA"
		#define STR0032 "HISTORICO"
		#define STR0033 "XPARTIDA"
		Static  STR0034 :=  "DEBITO"
		Static  STR0035 :=  "CREDITO"
		#define STR0036 "SALDO ATUAL"
		#define STR0037 "Totais"
		#define STR0038 "Complemento"
		#define STR0039 "DESCRICAO"
	#endif
#endif

#IFDEF SPANISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil

		If cPaisLoc == "ALL"
			STR0013 := "LOTE/SUB/DOC/LINEA H I S T O R I A L                        COMPENSAC"
			STR0014 := "LOTE/SUB/DOC/LINEA H I S T O R I A L                        C/PARTIDA                      DEBITO          CREDITO       SALDO ACTUAL"
			STR0025 := "FECHA                                                                            DEBITO               CREDITO            SALDO ACTUAL"
			STR0026 := "DEBITO         CREDITO     SALDO ACTUAL"
			STR0034 := "DEBITO"
			STR0035 := "CREDITO"
		ElseIf cPaisLoc == "MEX"
			STR0013 := "LOTE/SUB/POL/LINEA H I S T O R I A L                        C/PARTIDA"
			STR0014 := "LOTE/SUB/PLZ/LINEA H I S T O R I A L                         C/PARTIDA                      CARGO           ABONO         SALDO ACTUAL"
			STR0025 := "FECHA                                                                            CARGO                ABONO              SALDO ACTUAL"
			STR0026 := "DEBITO         Credito     SALDO ACTUAL"
			STR0034 := "DEBITO"
			STR0035 := "CREDITO"
		EndIf
	Return Nil
#ENDIF

#IFDEF ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil

		If cPaisLoc == "ALL"
			STR0013 := "LOT/SUB/DOC/LINE HISTORY                                    W/ENTRY  "
			STR0014 := "LOT /SUB/DOC/LINE  H I S T O R Y                            W/ENTRY                        DEBIT           CREDIT        CURR.BALAC."
			STR0025 := "DATE                                                                             DEBIT                CREDIT           CURR.BALANCE"
			STR0026 := "DEBIT          CREDIT       CURR.BALAC."
			STR0034 := "DEBIT "
			STR0035 := "CREDIT "
		ElseIf cPaisLoc == "MEX"
			STR0013 := "LOT/SUB/DOC/LINE HISTORY                                    W/ENTRY  "
			STR0014 := "LOT /SUB/DOC/LINE  H I S T O R Y                            W/ENTRY                        DEBIT           CREDIT        CURR.BALAC."
			STR0025 := "DATE                                                                             DEBIT                CREDIT           CURR.BALANCE"
			STR0026 := "DEBIT          CREDIT       CURR.BALAC."
			STR0034 := "DEBIT "
			STR0035 := "CREDIT "
		EndIf
	Return Nil
#ENDIF

#IFNDEF SPANISH
 #IFNDEF ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil

		If cPaisLoc == "ALL"
			STR0013 := "LOTE/SUB/DOC/LINHA H I S T O R I C O                        C/PARTIDA"
			STR0014 := "LOTE/SUB/DOC/LINHA H I S T O R I C O                        C/PARTIDA                      DEBITO          CREDITO       SALDO ATUAL"
			STR0025 := "DATA                                                                            DEBITO               CREDITO            SALDO ATUAL"
			STR0026 := "DEBITO         CREDITO      SALDO ATUAL"
			STR0034 := "DEBITO"
			STR0035 := "CREDITO"
		ElseIf cPaisLoc == "MEX"
			STR0013 := "LOTE/SUB/DOC/LINHA H I S T O R I C O                        C/PARTIDA"
			STR0014 := "LOTE/SUB/DOC/LINHA H I S T O R I C O                        C/PARTIDA                      DEBITO          CREDITO       SALDO ATUAL"
			STR0025 := "DATA                                                                            DEBITO               CREDITO            SALDO ATUAL"
			STR0026 := "DEBITO         CREDITO      SALDO ATUAL"
			STR0034 := "DEBITO"
			STR0035 := "CREDITO"
		EndIf
	Return Nil
 #ENDIF
#ENDIF
