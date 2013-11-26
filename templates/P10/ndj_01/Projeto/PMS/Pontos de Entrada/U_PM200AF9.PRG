#INCLUDE "NDJ.CH"
/*/
	Funcao: 	PM200AF9()
	Autor:		Marinaldo de Jesus
	Data:		10/02/2011
	Descricao:	Ponto de Entrada PM200AF9, executado em pmsa200 -> AF9AtuCode -> PM200AF9 -> Tarefas do Projeto para o tratamento de campos específicos na troca de EDT.
	Uso:		Sera utilizado para Atualizar os campos customizados de Tarefas com as novas tarefas do proejto.
				Campos Envolvidos: Todos aqueles pertencentes ao Grupo do SXG (X3_GRPSXG) 014 - EDT/Tarefa.
/*/
User Function PM200AF9()

	Local aParam
	Local aCampos
	Local aCamposUsr

	Local cFil
	Local cRev
	Local cTask
	Local cNewTask
	Local cProject

	Local oException
	
	TRYEXCEPTION

		aCampos		:= ParamIxb[1]
		aParam		:= ParamIxb[2]

		cFil		:= aParam[1]
		cProject	:= aParam[2]
		cRev        := aParam[3]
		cTask		:= aParam[4]
		cNewTask	:= aParam[5]

		aCamposUsr	:= {}

		aAdd( aCamposUsr , { "CNB" , RetOrder( "CNB" , "CNB_FILIAL+CNB_XPROJE+CNB_XREVIS+CNB_XTAREF"	) , "CNB_FILIAL+CNB_XPROJE+CNB_XREVIS+CNB_XTAREF"	, "CNB_XTAREF"	, xFilial("CNB",cFil) + cProject + cRev + cTask , cNewTask } )
		aAdd( aCamposUsr , { "CNE" , RetOrder( "CNE" , "CNE_FILIAL+CNE_XPROJE+CNE_XREVIS+CNE_XTAREF"	) , "CNE_FILIAL+CNE_XPROJE+CNE_XREVIS+CNE_XTAREF"	, "CNE_XTAREF"	, xFilial("CNE",cFil) + cProject + cRev + cTask , cNewTask } )
		aAdd( aCamposUsr , { "SC1" , RetOrder( "SC1" , "C1_FILIAL+C1_XPROJET+C1_XREVISA+C1_XTAREFA"		) , "C1_FILIAL+C1_XPROJET+C1_XREVISA+C1_XTAREFA"	, "C1_XTAREFA"	, xFilial("SC1",cFil) + cProject + cRev + cTask , cNewTask } )
		aAdd( aCamposUsr , { "SC7" , RetOrder( "SC7" , "C7_FILIAL+C7_XPROJET+C7_XREVIS+C7_XTAREFA"		) , "C7_FILIAL+C7_XPROJET+C7_XREVIS+C7_XTAREFA"		, "C7_XTAREFA"	, xFilial("SC7",cFil) + cProject + cRev + cTask , cNewTask } )
		aAdd( aCamposUsr , { "SC8" , RetOrder( "SC8" , "C8_FILIAL+C8_XPROJET+C8_XREVIS+C8_XTAREFA"		) , "AFI_FILIAL+AFI_PROJET+AFI_REVISA+AFI_TAREFA"	, "C8_XTAREFA"	, xFilial("SC8",cFil) + cProject + cRev + cTask , cNewTask } )
		aAdd( aCamposUsr , { "SD1" , RetOrder( "SD1" , "D1_FILIAL+D1_XPROJET+D1_XREVIS+D1_XTAREFA"		) , "D1_FILIAL+D1_XPROJET+D1_XREVIS+D1_XTAREFA"		, "D1_XTAREFA"	, xFilial("SD2",cFil) + cProject + cRev + cTask , cNewTask } )
		aAdd( aCamposUsr , { "SN1" , RetOrder( "SN1" , "N1_FILIAL+N1_XPROJET+N1_XREVIS+N1_XTAREFA"		) , "N1_FILIAL+N1_XPROJET+N1_XREVIS+N1_XTAREFA"		, "N1_XTAREFA"	, xFilial("SN1",cFil) + cProject + cRev + cTask , cNewTask } )
		aAdd( aCamposUsr , { "SZR" , RetOrder( "SZR" , "ZR_FILIAL+ZR_TRFPRJ+ZR_TRFPRJ"					) , "ZR_FILIAL+ZR_TRFPRJ+ZR_TRFPRJ"					, "ZR_TRFPRJ"	, xFilial("SZR",cFil) + cProject + cTask		 , cNewTask } )

	CATCHEXCEPTION USING oException

		aCamposUsr	:=  {}

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
			ConOut( oException:Description , oException:ErrorStack )
		EndIF
	
	ENDEXCEPTION

Return( aCamposUsr )

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