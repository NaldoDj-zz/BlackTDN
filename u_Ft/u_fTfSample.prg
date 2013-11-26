#INCLUDE "PROTHEUS.CH"
/*/
	Funcao:		FTFSample
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Exemplo de Uso da Classe fT
/*/
User Function FTFSample()

	Local aCab
	Local aDet

	Local cFile			:= "fTfSample.csv"	//Deve estar em \system\

	aFile 				:= FileToArr( @cFile )
	aCab				:= aFile[1]
	aDet	 			:= aFile[2]

Return( { aCab , aDet } )

/*/
	Funcao:		FileToArr
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Exemplo de Uso da Classe fT
/*/
Static Function FileToArr( cFile )

	Local aCab			:= {}
	Local aDet			:= {}

	Local cLine			:= ""
	Local cToken		:= Chr(255)

	Local ofT			:= fT():New()

	BEGIN SEQUENCE

		IF ( ofT:ft_fUse( cFile ) <= 0 )
			ofT:ft_fUse()
			BREAK
		EndIF

		While !( ofT:ft_fEof() )
			IncProc()
			cLine 		:= ofT:ft_fReadLn()
			ConOut( cLine )
			cLine		:= StrTran( cLine , '""' , '" "' )   	//Carrego um espaço em branco
			cLine		:= StrTran( cLine , '","' , cToken )	//Defino o Separador
			cLine		:= StrTran( cLine , '"' , "" )			//Retiro as Aspas 
			IF ( ofT:ft_fRecno() == 1 )
				aCab	:= StrTokArr( cLine , cToken )			//A primeira Linha contem o Cabeçalho dos campos
			Else
				aAdd( aDet , StrTokArr( cLine , cToken ) )		//As demais linhas sao os Detalhes
			EndIF
			cLine		:= "" 
			ofT:ft_fSkip()
		End While

		ofT:ft_fUse()

	END SEQUENCE

Return( { aCab , aDet } )