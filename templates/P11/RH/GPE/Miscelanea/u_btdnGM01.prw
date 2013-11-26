#INCLUDE "PROTHEUS.CH"
#INCLUDE "DBSTRUCT.CH"

Static __cCRLF := CRLF

/*
	Programa	: u_btdnGM01.PRW
	Funcao		: u_btdnGM01
	Autor		: Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data		: 20/06/2013
	Descricao	: Importacao de Movimento Mensal Via CSV (Arquivo Delimitado por ";").
				  O arquivo devera ter cabeçalho com as seguintes informações:	
				  1 ) RC_FILIAL
				  2 ) RC_MAT
				  3 ) RC_PD
				  4 ) RC_TIPO1
				  5 ) RC_HORAS
				  6 ) RC_VALOR
				  7 ) RC_DATA
				  8 ) RC_SEMANA
				  9 ) RC_CC
				 10 ) RC_PARCELA
				 11 ) RC_TIPO2
*/                          
User Function btdnGM01()

	Local aArea			:= GetArea()
	Local aAreaSRA		:= SRA->( GetArea() )
	Local aAreaSRC		:= SRC->( GetArea() )
	Local aAreaSRV		:= SRV->( GetArea() )
	Local aAreaCTT		:= CTT->( GetArea() )

	Local bProcess		:= { |oProcess,oPanel| btdnGM01(@oProcess,@oPanel) }

	Local cDescri		:= OemToAnsi( "Este Programa irá efetuar a Importação de arquivo da Folha de Pagamento (Movimento Mensal) conforme arquivo Selecionado" )
	Local cProcess		:= "btdnGM01"
   
	Local oProcess

	Private aRotina 	:= MenuDef()

	Private Inclui 		:= .T.							

	Private cCadastro	:= OemtoAnsi( "Importação de Arquivos Folha de Pagamento: Movimento Mensal" )

	oProcess			:= tNewProcess():New(@cProcess,@cCadastro,@bProcess,@cDescri,"", NIL,.T.,5,"Aguarde...Importando",.T.)

	RestArea( aArea    )
	RestArea( aAreaSRA )
	RestArea( aAreaSRC )
	RestArea( aAreaSRV )
	RestArea( aAreaCTT )

Return( NIL )

/*
	Programa	: u_btdnGM01.PRW
	Funcao		: btdnGM01
	Autor		: Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data		: 20/06/2013
	Descricao	: Importacao de Movimento Mensal Via CSV (Arquivo Delimitado por ";").
*/                          
Static Function btdnGM01(oProcess,oPanel)

	Local aError		:= Array(0)

	Local cFile
	Local cStartPath

	Local bError      	:= { |e| oError := e , BREAK(e) }
	Local bErrorBlock

	Local cError
	
	Local oError

	oProcess:SaveLog( OemToAnsi( "Inicio da Importação" ) )

	bErrorBlock	:= ErrorBlock( bError )
	BEGIN SEQUENCE

		IF .NOT.( PgsExclusive() )
		   UserException( GetHelp( "PGSEXC" ) )
		EndIF

		SplitPath(GetTempPath(),@cStartPath)
		IF .NOT.( SubStr(cStartPath,-1)=="\")
			cStartPath += "\"
		EndIF
		cStartPath += "people\"

		cFile	:= cGetFile( "(*.csv)|*.csv" ,"Texto-Delimitado(csv)",1,@cStartPath,.F.,nOR(GETF_LOCALHARD,GETF_LOCALFLOPPY,GETF_NETWORKDRIVE),.T.,.T.)
		
		IF Empty( cFile )
			UserException( GetHelp("NOFLEIMPOR") )
		EndIF
		
		IF .NOT.( File( cFile ) )
			UserException( GetHelp("NOFLEIMPOR") )
		EndIF

		ImportCSVExcel(@oProcess,@oPanel,@cFile)

	RECOVER

		IF ( ValType( oError ) == "O" )
			cError	:= oError:Description
			aAdd( aError , cError )
			oProcess:SaveLog( "ERRO: " + OemToAnsi( cError )  )
			IF MsgNoYes( "Ocorreram Erros Durante o Processo de Importação. Deseja Visualizar?" , "AVISO!!!" )
				fMakeLog( { aError } , { "Log de Ocorrências na Importação do arquivo: " + cFile } , "" , .T. , NIL , cCadastro , NIL , NIL , NIL , .F. )  
			EndIF	
		EndIF

	END SEQUENCE

	PgsShared()

	oProcess:SaveLog( OemToAnsi( "Final da Importação" ) )

Return( NIL )

/*
	Programa	: u_btdnGM01.PRW
	Funcao		: ImportCSVExcel
	Autor		: Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data		: 20/06/2013
	Descricao	: Importacao de Movimento Mensal Via CSV (Arquivo Delimitado por ";").
*/                          
Static Function ImportCSVExcel(oProcess,oPanel,cFile)

	Local aError		:= Array(0)
	Local cError
	
	Local aHeader		:= Array(0)
	Local aCols			:= Array(0)

	Local aFields		:= Array(0)
	
	Local cLine			:= ""
	Local cRANome

	Local cSRAFilial
	Local cSRCFilial
	Local cSRVFilial
	Local cCTTFilial
			
	Local cSRAKeySeek
	Local cSRCKeySeek
	Local cSRVKeySeek
	Local cCTTKeySeek
	
	Local nField
	Local nFields
	Local nCntFields
	Local nHeaderLine
	
	Local nFieldPos
	Local nfLastRec

	Local nSRAOrder
	Local nSRCOrder
	Local nSRVOrder
	Local nCTTOrder
	
	Local cRCFILIAL
	Local cRCMAT
	Local cRCPD
	Local cRCTIPO1
	Local nRCHORAS
	Local nRCVALOR
	Local dRCDATA
	Local cRCSEMANA
	Local cRCCC
	Local nRCPARCELA
	Local cRCTIPO2

	Local nRC_FILIAL
	Local nRC_MAT
	Local nRC_PD
	Local nRC_TIPO1
	Local nRC_HORAS
	Local nRC_VALOR
	Local nRC_DATA
	Local nRC_SEMANA
	Local nRC_CC
	Local nRC_PARCELA
	Local nRC_TIPO2
    
	Local nMatSize		:= GetSX3Cache("RA_MAT","X3_TAMANHO")
	Local nFilialSize	:= GetSX3Cache("RA_FILIAL","X3_TAMANHO")

	Local lError
	Local bError      	:= { |e| oError := e , BREAK(e) }
	Local bErrorBlock
	
	Local nfh

	IF Empty( cFile )
		UserException( GetHelp("NOFLEIMPOR") + " " + OemToAnsi( "Arquivo : " + cFile + " " + "Não Encontrado" )  )
	EndIF
	oProcess:SaveLog( "Importando Arquivo: " + cFile  )

 	nfh	:= ft_fUse( cFile )
	IF ( nfh < 0 )
		UserException( "Erro na abertura do arquivo: " + cFile + "[Error: "+LTrim(Str(fError()))+"]" )
	EndIF

	nfLastRec	:= ft_fLastRec()
	IF ( nfLastRec == 0 )
		ft_fUse()
		UserException( "Nao existem informações a serem importadas para o arquivo: " + cFile )
	EndIF
	
	aAdd( aFields , { "RC_FILIAL"  , SRC->(FieldPos("RC_FILIAL"))  , NIL } )
	aAdd( aFields , { "RC_MAT"     , SRC->(FieldPos("RC_MAT"))     , NIL } )
	aAdd( aFields , { "RC_PD"      , SRC->(FieldPos("RC_PD"))      , NIL } )
	aAdd( aFields , { "RC_TIPO1"   , SRC->(FieldPos("RC_TIPO1"))   , NIL } )
	aAdd( aFields , { "RC_HORAS"   , SRC->(FieldPos("RC_HORAS"))   , NIL } )
	aAdd( aFields , { "RC_VALOR"   , SRC->(FieldPos("RC_VALOR"))   , NIL } )
	aAdd( aFields , { "RC_DATA"    , SRC->(FieldPos("RC_DATA"))    , NIL } )
	aAdd( aFields , { "RC_SEMANA"  , SRC->(FieldPos("RC_SEMANA"))  , NIL } )
	aAdd( aFields , { "RC_CC"      , SRC->(FieldPos("RC_CC"))      , NIL } )
	aAdd( aFields , { "RC_PARCELA" , SRC->(FieldPos("RC_PARCELA")) , NIL } )
	aAdd( aFields , { "RC_TIPO2"   , SRC->(FieldPos("RC_TIPO2"))   , NIL } )
	
	nFields		:= Len( aFields )     

	nCntFields	:= 0
	nHeaderLine	:= 0	

	oProcess:SetRegua1( 0 )
	oProcess:SetRegua2( nfLastRec )

	ft_fGoTop()

	While .NOT.( ft_fEof() )
		oProcess:IncRegua2( "Carregando Estrutura..." )
		cLine 	:= Upper(AllTrim(ft_fReadLn()))
		While ( ";;" $ cLine )
			cLine 	:= StrTran(cLine,";;","; ;")
		End While
		For nField := 1 To nFields
			IF ( aFields[nField][1] $ cLine )
				++nCntFields
			EndIF
		Next nField
		++nHeaderLine
		IF ( nCntFields == nFields )
			aHeader	:= StrToKArr(cLine,";")
			ft_fSkip()
			EXIT
		EndIF
		nCntFields	:= 0	
		ft_fSkip()
	End While
	
	IF Empty( aHeader )
		ft_fUse()
		UserException( "Estrutura do arquivo: " + cFile + " Inválida. O Arquivo não será importado" )
	EndIF

	oProcess:SetRegua2( nFields )
	For nField := 1 To nFields
		oProcess:IncRegua2( "Montando Estrutura..." )
		nFieldPos	:= aScan(aHeader,{|cField|aFields[nField][1]$cField})		
		IF ( nFieldPos > 0 )
			aFields[nField][3]	:= nFieldPos	
		EndIF
	Next nFields

	nRC_FILIAL	:= aFields[01][3]
	nRC_MAT		:= aFields[02][3]
	nRC_PD		:= aFields[03][3]
	nRC_TIPO1	:= aFields[04][3]
	nRC_HORAS	:= aFields[05][3]
	nRC_VALOR	:= aFields[06][3]
	nRC_DATA	:= aFields[07][3]
	nRC_SEMANA	:= aFields[08][3]
	nRC_CC		:= aFields[09][3]
	nRC_PARCELA	:= aFields[10][3]
	nRC_TIPO2	:= aFields[11][3]
		
	nSRAOrder	:= RetOrder( "SRA" , "RA_FILIAL+RA_MAT" )
	SRA->( dbSetOrder( nSRAOrder ) )
	                                   
	nSRCOrder	:= RetOrder( "SRC" , "RC_FILIAL+RC_MAT+RC_PD" )
	SRC->( dbSetOrder( nSRCOrder ) )
	
	nSRVOrder	:= RetOrder( "SRV" , "RV_FILIAL+RV_COD" )
	SRV->( dbSetOrder( nSRVOrder ) )
	
	nCTTOrder	:= RetOrder( "CTT" , "CTT_FILIAL+CTT_CUSTO" )
	CTT->( dbSetOrder( nCTTOrder ) )
	
	nfLastRec -= nHeaderLine

	oProcess:SetRegua1( nfLastRec )
	oProcess:SetRegua2( nfLastRec )

	While .NOT.( ft_fEof() )

		cLine 	:= Upper(AllTrim(ft_fReadLn()))
		While ( ";;" $ cLine )
			cLine 	:= StrTran(cLine,";;","; ;")
		End While
		
		aCols	:= StrToKArr(cLine,";")
	
		bErrorBlock	:= ErrorBlock( bError )
		BEGIN SEQUENCE
			
			bErrorBlock	:= ErrorBlock( bError )
			BEGIN SEQUENCE    
				cRCFILIAL	:= PadL(AllTrim(aCols[nRC_FILIAL]),nFilialSize,"0")
			RECOVER
				BREAK
			END SEQUENCE
			ErrorBlock( bErrorBlock )
						
			bErrorBlock	:= ErrorBlock( bError )
			BEGIN SEQUENCE    
				cRCMAT	:=	PadL(AllTrim(aCols[nRC_MAT]),nMatSize,"0")
			RECOVER
				BREAK
			END SEQUENCE
			ErrorBlock( bErrorBlock )
	
			bErrorBlock	:= ErrorBlock( bError )
			BEGIN SEQUENCE    
				cRCPD	:= aCols[nRC_PD]
			RECOVER
				BREAK
			END SEQUENCE
			ErrorBlock( bErrorBlock )
	
			bErrorBlock	:= ErrorBlock( bError )
			BEGIN SEQUENCE    
				cRCTIPO1	:= Upper(AllTrim(aCols[nRC_TIPO1]))
			RECOVER
				BREAK
			END SEQUENCE
			ErrorBlock( bErrorBlock )
	
			bErrorBlock	:= ErrorBlock( bError )
			BEGIN SEQUENCE    
				nRCHORAS	:= Val( aCols[nRC_HORAS] )
			RECOVER
				BREAK
			END SEQUENCE
			ErrorBlock( bErrorBlock )
	
			bErrorBlock	:= ErrorBlock( bError )
			BEGIN SEQUENCE    
				nRCVALOR	:= Val( aCols[nRC_VALOR] )
			RECOVER
				BREAK
			END SEQUENCE
			ErrorBlock( bErrorBlock )
	
			bErrorBlock	:= ErrorBlock( bError )
			BEGIN SEQUENCE    
				dRCDATA		:= CtoD( aCols[nRC_DATA] )
			RECOVER
				BREAK
			END SEQUENCE
			ErrorBlock( bErrorBlock )
			
			bErrorBlock	:= ErrorBlock( bError )
			BEGIN SEQUENCE    
				cRCSEMANA	:= aCols[nRC_SEMANA]
			RECOVER
				BREAK
			END SEQUENCE
			ErrorBlock( bErrorBlock )
			
			bErrorBlock	:= ErrorBlock( bError )
			BEGIN SEQUENCE    
				cRCCC		:= aCols[nRC_CC]
			RECOVER
				BREAK
			END SEQUENCE
			ErrorBlock( bErrorBlock )
	
			bErrorBlock	:= ErrorBlock( bError )
			BEGIN SEQUENCE    
				nRCPARCELA	:= Val( aCols[nRC_PARCELA] )
			RECOVER
				BREAK
			END SEQUENCE
			ErrorBlock( bErrorBlock )
		
			bErrorBlock	:= ErrorBlock( bError )
			BEGIN SEQUENCE    
				cRCTIPO2	:= aCols[nRC_TIPO2]
			RECOVER
				BREAK
			END SEQUENCE
			ErrorBlock( bErrorBlock )
			
			cSRAFilial	:= xFilial("SRA",cRCFILIAL)
			
			cSRAKeySeek := cSRAFilial
			cSRAKeySeek += cRCMAT
			
			IF SRA->( .NOT.( dbSeek( cSRAKeySeek , .F. ) ) )
				UserException( "Filial " + cSRAFilial + " e Matricula: " + cRCMAT + " Não Cadastradas no Sistema. Registro " + LTrim(Str(ft_fRecno())) + " não será importado" )
			EndIF

			oProcess:IncRegua2( "Importando: " + SRA->RA_NOME )

			cSRVFilial	:= xFilial("SRV",cRCFILIAL)
			
			cSRVKeySeek := cSRVFilial
			cSRVKeySeek += cRCPD

			IF SRV->( .NOT.( dbSeek( cSRVKeySeek , .F. ) ) )
				UserException( "Filial " + cSRVFilial + " e Verba: " + cRCPD + " Não Cadastradas no Sistema. Registro " + LTrim(Str(ft_fRecno())) + " não será importado" )
			EndIF
			
			IF ( cRCTIPO1 $ "D/H" )
				IF Empty( nRCHORAS )
					UserException( "Filial " + cSRAFilial + " e Matricula: " + cRCMAT + " Verba sem Quantidade' Informada. Registro " + LTrim(Str(ft_fRecno())) + " não será importado" )
				EndIF
			EndIF
			IF ( cRCTIPO1 $ "V" )
				IF Empty( nRCVALOR )
					UserException( "Filial " + cSRAFilial + " e Matricula: " + cRCMAT + " Verba sem Valor Informado. Registro " + LTrim(Str(ft_fRecno())) + " não será importado" )
				EndIF
			EndIF
	
			cCTTFilial	:= xFilial("CTT",cRCFILIAL)
			
			cCTTKeySeek := cCTTFilial
			cCTTKeySeek += cRCCC

			IF CTT->( .NOT.( dbSeek( cCTTKeySeek , .F. ) ) )
				UserException( "Filial " + cCTTFilial + " e Centro de Custo: " + cRCCC + " Não Cadastrados no Sistema. Registro " + LTrim(Str(ft_fRecno())) + " não será importado" )
			EndIF

			cSRCFilial	:= xFilial("SRC",cRCFILIAL)
			
			cSRCKeySeek := cSRCFilial
			cSRCKeySeek += cRCMAT
			cSRCKeySeek += cRCPD

	   		IF SRC->( dbSeek( cSRCKeySeek , .F. ) )
    			UserException( "Filial " + cSRCFilial + " e Matricula: " + cRCMAT + " Já Existe Lançamento na Verba: "+cRCPD+" para o Funcionário. Registro " + LTrim(Str(ft_fRecno())) + " não será importado" )
    		EndIF

			bErrorBlock	:= ErrorBlock( bError )
			BEGIN SEQUENCE    
	
				BeginTran()
			
					IF .NOT.( SRC->( RecLock( "SRC" , .T. ) ) )
						BREAK
					EndIF
			
					#IFDEF DEBUG
						cRCSEMANA		:= "@@"
						dRCDATA			:= CtoD("31/12/3999")
					#ENDIF	
					
					SRC->RC_FILIAL	:= cRCFILIAL
					SRC->RC_MAT		:= cRCMAT
					SRC->RC_PD		:= cRCPD
					SRC->RC_TIPO1	:= cRCTIPO1
					SRC->RC_HORAS	:= nRCHORAS
					SRC->RC_VALOR	:= nRCVALOR
					SRC->RC_DATA	:= dRCDATA
					SRC->RC_SEMANA	:= cRCSEMANA
					SRC->RC_CC		:= cRCCC	
					SRC->RC_PARCELA	:= nRCPARCELA
					SRC->RC_TIPO2	:= cRCTIPO2
				
					SRC->( MsUnLock() )
			
				EndTran()
		    
             RECOVER
		     
		     	IF ( InTransaction() )
		     		DisarmTransaction()
		    		EndTran() 
		     	EndIF
	
				IF ( ValType( oError ) == "O" )
					cError	:= oError:Description
					aAdd( aError , cError )
					oProcess:SaveLog( "ERRO: " + OemToAnsi( cError )  )
				EndIF
		     
		     END SEQUENCE
		     ErrorBlock( bErrorBlock )
		
		RECOVER

				IF ( ValType( oError ) == "O" )
					cError	:= oError:Description
					aAdd( aError , cError )
					oProcess:SaveLog( "ERRO: " + OemToAnsi( cError )  )
				EndIF
	     
		END SEQUENCE
		ErrorBlock( bErrorBlock )
		
		MsUnLockAll()
		
		ft_fSkip()
	
		oProcess:IncRegua1( "Processando..." )

	End While

	ft_fUse()

	IF .NOT.( Empty( aError ) )
		IF MsgNoYes( "Ocorreram Erros Durante o Processo de Importação. Deseja Visualizar?" , "AVISO!!!" )
			fMakeLog( { aError } , { "Log de Ocorrências na Importação do arquivo: " + cFile } , "" , .T. , NIL , cCadastro , NIL , NIL , NIL , .F. )  
		EndIF
	EndIF

	oProcess:SaveLog(  "Arquivo Importado: " +  cFile )

Return( NIL )

/*
	Programa	: u_btdnGM01.PRW
	Funcao		: GetHelp()
	Autor		: Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data		: 20/06/2013
	Descricao	: Retorna Texto do Helop sem CRLF
*/                          
Static Function GetHelp( cHelp )
Return(StrTran(Ap5GetHelp(cHelp),__cCRLF," "))

/*
	Programa	: u_btdnGM01.PRW
	Funcao		: MenuDef()
	Autor		: Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data		: 20/06/2013
	Descricao	: Funcao Padrao para Retorno do Menu
*/                          
Static Function MenuDef()
	Local aMenu := {{"","",0,1},{"","",0,2},{"","",0,3},{"","",0,4}}
Return(aMenu)