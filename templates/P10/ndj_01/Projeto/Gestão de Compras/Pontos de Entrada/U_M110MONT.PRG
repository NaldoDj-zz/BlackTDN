#INCLUDE "NDJ.CH"
/*/
	Programa: 	M110MONT
	Data:		17/11/2010
	Autor:		Marinaldo de Jesus
	Descricao:	Implementacao do Ponto de Entrada M110MONT executado a partir da funcao a110Monta no MATA110
				Sera utilizado para Remontar o aHeader e o aCols de forma a permitirem os campos C1_PROJET, C1_REVISA e C1_TAREFA
/*/
User Function M110MONT()
    
	Local aCallStack

	Local aColsRmk
	Local aLocalCols
	Local aLocalHeader

	Local cField
	Local cNumSC1
	Local cProcName

	Local lCopia

	Local nOpc
	Local nOpcX
	Local nItem
	Local nItens
	Local nField
	Local nFields
	Local nFieldPos
	Local nStackCount
	
	Local uCnt

	BEGIN SEQUENCE

		nOpc				:= ParamIxb[2]
		IF ( nOpc == 1 )
			BREAK
		EndIF

        aCallStack            := StaticCall( NDJLIB001 , GetCallStack )
		cProcName			:= ProcName()
		nStackCount			:= 0
		aEval( aCallStack , { | cCallStack | IF( ( cCallStack == cProcName ) , ++nStackCount , NIL )  }  )

		IF ( nStackCount > 1  )
			BREAK
		EndIF

        IF StaticCall( NDJLIB001 , IsInGetDados , { "C1_XPROJET" , "C1_XTAREFA" , "C1_XREVISA" } )
			BREAK
		EndIF

		cNumSC1				:= ParamIxb[1]
		lCopia				:= ParamIxb[3]

		aLocalCols			:= aClone( aCols )
		aLocalHeader		:= aClone( aHeader )

		aCols				:= {}
		aHeader				:= {}

		DEFAULT nOpcX		:= 3
		nOpc				:= 1

		StaticCall( MATA110 , a110Monta , nOpc , NIL , lCopia , nOpcX )

		aCols				:= {}
		aColsRmk			:= GdRmkaCols(	@aHeader , .F. , .T. , .T. )

		nItem				:= 0
		nItens				:= Len( aLocalCols )

		While ( ++nItem <= nItens )
        	aAdd( aCols , aClone( aColsRmk[ 1 ] ) )
		End While

		nItens				:= Len( aLocalCols )
		nFields				:= Len( aLocalHeader )

		Private n			:= 0

		For nItem := 1 To nItens
			n				:= nItem
			For nField := 1 To nFields
				cField		:= aLocalHeader[ nField ][ __AHEADER_FIELD__ ]
				nFieldPos	:= GdFieldPos( cField )
				IF .NOT.( nFieldPos > 0 )
					Loop
				EndIF
				uCnt		:= aLocalCols[ nItem ][ nField ]
				GdFieldPut( cField , uCnt )
			Next nField
		Next nItem

	END SEQUENCE

Return( NIL )

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