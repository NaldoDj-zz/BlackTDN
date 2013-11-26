Function main()

   LOCAL hPessoa  := hb_hash()
   LOCAL hPessoas := hb_hash()
   LOCAL nPessoa  := 0 
   LOCAL nPessoas := 1000

   SET CENTURY ON
   SET DATE TO BRITISH 
   SET DATE FORMAT "mm/dd/yyyy"

   hPessoa["PESSOA"] := hb_hash()
   hb_HSetCaseMatch( hPessoa["PESSOA"] , .F. )

   hPessoa["PESSOA"]["NOME"]        := "BlackTDN"
   hPessoa["PESSOA"]["NASCIMENTO"]  := Ctod("01/01/2012")
   hPessoa["PESSOA"]["SEXO"]        := "M"
   hPessoa["PESSOA"]["PAIS"]        := "Brasil"
   hPessoa["PESSOA"]["ENDEREÇO"]    := "http://blacktdn.com.br"
   hPessoa["PESSOA"]["CEP"]         := "00000-000"

   ? 'hPessoa["PESSOA"]["NOME"] :' + LTrim(str(hb_hPos( hPessoa["PESSOA"] , "NOME" ) ))
   ? 'hPessoa["PESSOA"]["NOME"] :' + hb_hGet( hPessoa["PESSOA"] , "NOME" )
   ? hb_OsNewLine()
   
   ? 'hPessoa["PESSOA"]["NASCIMENTO"] :' + LTrim(str(hb_hPos( hPessoa["PESSOA"] , "NASCIMENTO" ) ))
   ? 'hPessoa["PESSOA"]["NASCIMENTO"] :' + dtoc( hb_hGet( hPessoa["PESSOA"] , "NASCIMENTO" ) )
   ? hb_OsNewLine()

   ? 'hPessoa["PESSOA"]["SEXO"] :' + LTrim(str(hb_hPos( hPessoa["PESSOA"] , "SEXO" )))
   ? 'hPessoa["PESSOA"]["SEXO"] :' + hb_hGet( hPessoa["PESSOA"] , "SEXO" )
   ? hb_OsNewLine()
   
   ? 'hPessoa["PESSOA"]["PAIS"] :' + LTrim(str(hb_hPos( hPessoa["PESSOA"] , "PAIS" )))
   ? 'hPessoa["PESSOA"]["PAIS"] :' + hb_hGet( hPessoa["PESSOA"] , "PAIS" )
   ? hb_OsNewLine()
   
   ? hb_AnsiToOem('hPessoa["PESSOA"]["ENDEREÇO"] :') + LTrim(str(hb_hPos( hPessoa["PESSOA"] , "ENDEREÇO" ) ))
   ? hb_AnsiToOem('hPessoa["PESSOA"]["ENDEREÇO"] :') + hb_hGet( hPessoa["PESSOA"] , "ENDEREÇO" )
   ? hb_OsNewLine()
   
   ? 'hPessoa["PESSOA"]["CEP"] :' + LTrim(str( hb_hPos( hPessoa["PESSOA"] , "CEP" ) ))
   ? 'hPessoa["PESSOA"]["CEP"] :' + hb_hGet( hPessoa["PESSOA"] , "CEP" )
   ? hb_OsNewLine()
   
   For nPessoa := 1 To nPessoas
      hPessoas[nPessoa]                         := hb_hClone(hPessoa)
      hPessoas[nPessoa]["PESSOA"]["NOME"]       += ' ' + StrZero(nPessoa,4)
      IF ( ( nPessoa % 2 ) == 0 )
         hPessoas[nPessoa]["PESSOA"]["NASCIMENTO"] := YearSum( hPessoas[nPessoa]["PESSOA"]["NASCIMENTO"] , nPessoa )
      Else
         hPessoas[nPessoa]["PESSOA"]["NASCIMENTO"] := YearSub( hPessoas[nPessoa]["PESSOA"]["NASCIMENTO"] , nPessoa )
      EndIF
   Next nPessoa
   
   FOR EACH hPessoa IN hPessoas
   
      ? 'hPessoa["PESSOA"]["NOME"] :' + LTrim(str(hb_hPos( hPessoa["PESSOA"] , "NOME" ) ))
      ? 'hPessoa["PESSOA"]["NOME"] :' + hb_hGet( hPessoa["PESSOA"] , "NOME" )
      ? hb_OsNewLine()
      
      ? 'hPessoa["PESSOA"]["NASCIMENTO"] :' + LTrim(str(hb_hPos( hPessoa["PESSOA"] , "NASCIMENTO" ) ))
      ? 'hPessoa["PESSOA"]["NASCIMENTO"] :' + dtoc( hb_hGet( hPessoa["PESSOA"] , "NASCIMENTO" ) )
      ? hb_OsNewLine()

      ? 'hPessoa["PESSOA"]["SEXO"] :' + LTrim(str(hb_hPos( hPessoa["PESSOA"] , "SEXO" )))
      ? 'hPessoa["PESSOA"]["SEXO"] :' + hb_hGet( hPessoa["PESSOA"] , "SEXO" )
      ? hb_OsNewLine()
      
      ? 'hPessoa["PESSOA"]["PAIS"] :' + LTrim(str(hb_hPos( hPessoa["PESSOA"] , "PAIS" )))
      ? 'hPessoa["PESSOA"]["PAIS"] :' + hb_hGet( hPessoa["PESSOA"] , "PAIS" )
      ? hb_OsNewLine()
      
      ? hb_AnsiToOem('hPessoa["PESSOA"]["ENDEREÇO"] :') + LTrim(str(hb_hPos( hPessoa["PESSOA"] , "ENDEREÇO" ) ))
      ? hb_AnsiToOem('hPessoa["PESSOA"]["ENDEREÇO"] :') + hb_hGet( hPessoa["PESSOA"] , "ENDEREÇO" )
      ? hb_OsNewLine()
      
      ? 'hPessoa["PESSOA"]["CEP"] :' + LTrim(str( hb_hPos( hPessoa["PESSOA"] , "CEP" ) ))
      ? 'hPessoa["PESSOA"]["CEP"] :' + hb_hGet( hPessoa["PESSOA"] , "CEP" )
      ? hb_OsNewLine()

   NEXT EACH \\hPessoa
   
   inkey(0)

Return( .T. )

Function Day2Str( uData )
   Local cType := ValType( uData )
IF ( cType == "D" )
   Return( StrZero( Day( uData ) , 2 ) )
ElseIF ( cType == "N" )
   Return( StrZero( uData , 2 ) )
ElseIF ( cType == "C" )
   Return( StrZero( Val( uData ) , 2 ) )
EndIF

Function Month2Str( uData )
   Local cType := ValType( uData )
IF ( cType == "D" )
   Return( StrZero( Month( uData ) , 2 ) )
ElseIF ( cType == "N" )
   Return( StrZero( uData , 2 ) )
ElseIF ( cType == "C" )
   Return( StrZero( Val( uData ) , 2 ) )
EndIF

Function Year2Str( uData )
   Local cType := ValType( uData )
IF ( cType == "D" )
   Return( StrZero( Year( uData ) , 4 ) )
ElseIF ( cType == "N" )
   Return( StrZero( uData , 4 ) )
ElseIF ( cType == "C" )
   Return( StrZero( Val( uData ) , 4 ) )
EndIF

Function Last_Day( dDate )

   Local nMonth
   Local nYear

   IF ( ValType( dDate ) == "C" )
      dDate := CToD( dDate )   
   EndIF

   nMonth := ( Month( dDate ) + 1 )
   nYear  := Year( dDate )
   IF ( nMonth > 12 )
      nMonth := 1
      ++nYear
   EndIF

   dDate := CToD( "01/" + Month2Str( nMonth ) + "/" + Year2Str( nYear ) )
   dDate -= 1

Return( Day( dDate ) )

Function YearSum( dDate , nYear )
 
   Local nMonthAux := Month( dDate )
   Local nDayAux   := Day( dDate )
   Local nYearAux  := Year( dDate )

   nYearAux += nYear
   dDate := Ctod( Day2Str( nDayAux ) + "/" + Month2Str( nMonthAux ) + "/" + Year2Str( nYearAux ) )
   IF Empty( dDate )
      dDate   := Ctod( Day2Str( 1 ) + "/" + Month2Str( nMonthAux ) + "/" + Year2Str( nYearAux ) )
      nDayAux := Last_Day( dDate )
      dDate   := Ctod( Day2Str( nDayAux ) + "/" + Month2Str( nMonthAux ) + "/" + Year2Str( nYearAux ) )
   EndIF

Return( dDate )

Function YearSub( dDate , nYear )

   Local nMonthAux := Month( dDate )
   Local nDayAux   := Day( dDate )
   Local nYearAux  := Year( dDate )

   nYearAux -= nYear
   dDate := Ctod( Day2Str( nDayAux ) + "/" + Month2Str( nMonthAux ) + "/" + Year2Str( nYearAux ) )
   IF Empty( dDate )
      dDate   := Ctod( Day2Str( 1 ) + "/" + Month2Str( nMonthAux ) + "/" + Year2Str( nYearAux ) )
      nDayAux := Last_Day( dDate )
      dDate   := Ctod( Day2Str( nDayAux ) + "/" + Month2Str( nMonthAux ) + "/" + Year2Str( nYearAux ) )
   EndIF

Return( dDate )