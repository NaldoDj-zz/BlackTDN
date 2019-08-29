#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "DBSTRUCT.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWBROWSE.CH"

#DEFINE TC_COMMIT_TRANS        10

#DEFINE DBGOTO_INTERVAL        20

#DEFINE LINES_INSERT        30

#DEFINE AT_DELETED            1
#DEFINE AT_RA_FILIAL        2
#DEFINE AT_RA_MAT            3
#DEFINE AT_RA_NOME            4
#DEFINE AT_RA_SALARIO        5
#DEFINE AT_RA_ADMISSA        6
#DEFINE AT_RA_OK            7
#DEFINE AT_RA_DEMISSA        8
#DEFINE AT_RA_SEXO            9
#DEFINE AT_RA_MSBLQL        10
#DEFINE AT_R_E_C_N_O_        11

#DEFINE AT_FIELDS            12

#DEFINE AT_R_E_C_D_E_L_        AT_FIELDS

/*
     Funcao           : U_SQLiteEx()
     Autor         : Marinaldo de jesus [ www.blacktdn.com.br ]
     Data          : 10/06/2012
     Uso           : Demonstrar o Uso da Classe TSQLite em ADVPL
*/
User Function SQLiteEx()
    Local bExec            := { || SQLiteEx( @lIsBlind ) }
    Local lIsBlind        := MyIsBlind()
    Local lSetCentury    := __SetCentury("ON")
    IF ( lIsBlind )
        RpcSetType(3)
        PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
            #IFDEF TOP
                SetTopType( "A" )
            #ENDIF
            SetsDefault()
            lSetCentury    := __SetCentury("ON")
            Eval( bExec )
        RESET ENVIRONMENT
    Else
        MsAguarde( bExec )
    EndIF
    IF !( lSetCentury )
        __SetCentury("OFF")        
    EndIF
Return( NIL )

/*
     Funcao           : SQLiteEx()
     Autor         : Marinaldo de jesus [ www.blacktdn.com.br ]
     Data          : 10/06/2012
     Uso           : Demonstrar o Uso da Classe TSQLite em ADVPL
*/
Static Function SQLiteEx(lIsBlind)
    
    Local aFiliais            := { "01" , "02" , "03" , "04" , "05" , "06" , "07" , "08" , "09" , "10" }
    Local aSetField
    Local aBTDN_SRA010
    
    Local cAlias
    Local cQuery

    Local cType
    Local cField
    Local cValue
    
    Local cOrdKey
    Local cOrdFor

    Local cTCCommit            := ProcName()

    Local dMsDate
    
    Local lM                := .T.
    Local ldbGoTo            := .F.
    Local lDeleted            := .F.
    Local lNotExistTable    := .F.

    Local nGoTo                := 0
    Local nLine                := 0
    Local nLines            := 0
    Local nRecNo            := 0
    Local nField            := 0
    Local nFields            := 0
    Local nMaxRec            := 0
    Local nFilial            := 0
    Local nFiliais            := Len( aFiliais )

    Local uValue
    Local oTSQLite            := U_TSQLite("ODBC","SQLite3","127.0.0.1",7890)

    BEGIN SEQUENCE

        #IFDEF __DEBUG
            oTSQLite:SetConsoleError(.T.)
            oTSQLite:SuperClass()
        #ENDIF    

        IF !( oTSQLite:OpenConnection() )
            BREAK
        EndIF

        lNotExistTable    := ( .NOT. oTSQLite:SQLiteTable( "BTDN_SRA010" ) )

        oTSQLite:BeginStruct()
            oTSQLite:addField("RA_FILIAL"    ,"C",02,0)
            oTSQLite:addField("RA_MAT"        ,"C",06,0)
            oTSQLite:addField("RA_NOME"        ,"C",40,0)
            oTSQLite:addField("RA_SALARIO"     ,"N",15,2)
            oTSQLite:addField("RA_ADMISSA"     ,"D",08,0)
            oTSQLite:addField("RA_OK"          ,"L",01,0)
            oTSQLite:addField("RA_DEMISSA"    ,"D",08,0)
            oTSQLite:addField("RA_SEXO"        ,"C",01,0)
            oTSQLite:addField("RA_OBS"        ,"M",10,0)
            oTSQLite:addField("RA_MSBLQL"    ,"C",01,0)
        oTSQLite:EndStruct()

        aBTDN_SRA010 := oTSQLite:SetStruct()   

        IF ( lNotExistTable )

            lNotExistTable := ( .NOT. oTSQLite:dbCreate( "BTDN_SRA010" ) )
            IF ( lNotExistTable )
                BREAK
            EndIF

        EndIF

        cQuery    := "SELECT MAX( SRA.R_E_C_N_O_ ) AS R_E_C_N_O_ FROM BTDN_SRA010 SRA;"

        cAlias    := oTSQLite:GetNextAlias() //Obtendo o próximo Alias Disponivel

        IF !( oTSQLite:dbQuery( @cAlias , cQuery , .T. ) )
            BREAK //Nao foi possivel a abertura da Tabela
        EndIF

        nMaxRec    := oTSQLite:FieldGet( "R_E_C_N_O_" )
        
        //TODO: Resolver Isso
        IF ( ValType( nMaxRec ) == "C" )
            nMaxRec := Val( nMaxRec )    
        EndIF

        oTSQLite:dbClose()

        nMaxRec += 1
        nLines    := ( ( nMaxRec + LINES_INSERT ) - 1 )
        dMsDate    := MsDate()

        oTSQLite:BeginTransaction( cTCCommit )

        For nFilial := 1 To nFiliais
            For nLine := nMaxRec To nLines
                   nRecno := nLine
                cQuery := "INSERT INTO "
                cQuery += "[BTDN_SRA010]("
                cQuery += "[RA_FILIAL]"
                cQuery += ","
                cQuery += "[RA_MAT]"
                cQuery += ","
                cQuery += "[RA_NOME]"
                cQuery += ","
                cQuery += "[RA_SALARIO]"
                cQuery += ","
                cQuery += "[RA_ADMISSA]"
                cQuery += ","
                cQuery += "[RA_OK]"
                cQuery += ","
                cQuery += "[RA_DEMISSA]"
                cQuery += ","
                cQuery += "[RA_SEXO]"
                cQuery += ","
                cQuery += "[RA_OBS]"
                cQuery += ","
                cQuery += "[RA_MSBLQL]"
                cQuery += ","
                cQuery += "[D_E_L_E_T_]"
                cQuery += ","
                cQuery += "[R_E_C_N_O_]"
                cQuery += ","
                cQuery += "[R_E_C_D_E_L_]"
                cQuery += ") "
                cQuery += "VALUES("
                cQuery += oTSQLite:P2SQL(aFiliais[nFilial])
                cQuery += ","
                cQuery += oTSQLite:P2SQL(StrZero(nLine,6))
                cQuery += ","
                cQuery += oTSQLite:P2SQL("NOME "+StrZero(nLine,6))
                cQuery += ","
                cQuery += oTSQLite:P2SQL(nLine+(nLine/Randomize(1,11)))
                cQuery += ","
                cQuery += oTSQLite:P2SQL(MonthSub(dMsDate,((nLines-nLine)+1)))
                cQuery += ","
                cQuery += oTSQLite:P2SQL(.NOT.(lDeleted))
                cQuery += ","
                cQuery += oTSQLite:P2SQL(IF(lDeleted,dMsDate,""))
                cQuery += ","
                cQuery += oTSQLite:P2SQL(IF(lM,"M","F"))
                cQuery += ","
                cQuery += oTSQLite:P2SQL("NOME "+StrZero(nLine,6))
                cQuery += ","
                cQuery += oTSQLite:P2SQL(IF(lDeleted,"1","2"))
                cQuery += ","
                cQuery += oTSQLite:P2SQL(IF(lDeleted,"*"," "))
                cQuery += ","
                cQuery += oTSQLite:P2SQL(nRecno)
                cQuery += ","
                cQuery += oTSQLite:P2SQL(IF(lDeleted,nRecno,0))
                cQuery += ");"
                oTSQLite:SqlExec( cQuery )
                lM             := !( lM )
                lDeleted    := ( ( nLine % 3 ) == 0 )
                IF ( ( nLine % TC_COMMIT_TRANS ) == 0 )
                    oTSQLite:CommitTransaction( cTCCommit )
                    ConOut("[INSERT][RecNo]:["+LTrim(Str(nRecno))+"][TC_COMMIT]")
                    oTSQLite:EndTransaction( cTCCommit )
                    oTSQLite:BeginTransaction( cTCCommit )
                Else
                    ConOut("[INSERT][RecNo]:["+LTrim(Str(nRecno))+"]")
                EndIF
            Next nLine
            oTSQLite:CommitTransaction( cTCCommit )
            oTSQLite:EndTransaction( cTCCommit )
            oTSQLite:BeginTransaction( cTCCommit )
            nMaxRec := nLine
            nLines    := ( ( nMaxRec + LINES_INSERT ) - 1 )
        Next nFilial
        oTSQLite:CommitTransaction( cTCCommit )
        oTSQLite:EndTransaction( cTCCommit )

        cQuery    := "SELECT "
        cQuery     += "    ( CASE WHEN SRA.D_E_L_E_T_ = '*' THEN 'T' ELSE 'F' END ) AS DELETED,"
        cQuery     += "    SRA.* "
        cQuery     += "FROM  "
        cQuery     += "    BTDN_SRA010 SRA;"    //Elaboramos a string para a consulta

        IF !( oTSQLite:dbQuery( @cAlias , cQuery , .T. ) )
            BREAK //Nao foi possivel a abertura da Tabela
        EndIF

        ConOut( "" , "Tabela BTDN_SRA010 Aberta com Sucesso" , "" )

        aSetField    := oTSQLite:SetField( @aBTDN_SRA010 )

        IF !( lIsBlind )
            TSQLBrw( @oTSQLite , @aSetField )
            oTSQLite:ClearFilter()
            oTSQLite:dbGoTop()
        ENDIF

        nFields     := oTSQLite:Fields()

        ConOut("","[Skip|GoTo]:[BEGIN]","")

        While !( oTSQLite:Eof() )
            For nField := 1 To nFields 
                cField        := oTSQLite:FieldName( nField )
                uValue        := oTSQLite:FieldGet( nField )
                cType        := ValType( uValue )
                cValue        := AllTrim( cValToChar( uValue ) )
                ConOut("[FieldName]:["+cField+"][FieldType]:["+cType+"][FieldValue]:["+cValue+"]")
            Next nField
            ConOut("")
               nRecno            := oTSQLite:RecNo()
               lDeleted        := oTSQLite:Deleted()
            ConOut("")
               IF ( ldbGoTo )
                ConOut("[GoTo][RecNo]:["+LTrim(Str(nRecno))+"][Deleted]:["+cValToChar(lDeleted)+"]")
                   oTSQLite:ClearFilter()
                   ldbGoTo        := .F.
               Else
                   ConOut("[Skip][RecNo]:["+LTrim(Str(nRecno))+"][Deleted]:["+cValToChar(lDeleted)+"]")
                   ldbGoTo        := ( ( nRecno % DBGOTO_INTERVAL ) == 0 )
               EndIF
               IF ( ldbGoTo )
                   nGoTo        := ( nRecno + 1 )
                oTSQLite:dbGoTo(nGoTo)
               Else
                   oTSQLite:dbSkip()
               EndIF
        End While

        ConOut("","[Skip|GoTo]:[END]","")
        
        ConOut("","[GoTo]:[BEGIN]","")

        nGoTo                := 0
        nLines                *= nFiliais
        oTSQLite:dbGoTop()
        While !( oTSQLite:Eof() )
            IF ( ++nGoTo > nLines )
                EXIT
            EndIF
               nRecno            := Randomize(1,nLines)
            IF !( oTSQLite:dbGoTo(@nRecno,.T.) )
                Loop
            EndIF
            For nField := 1 To nFields 
                cField        := oTSQLite:FieldName( nField )
                uValue        := oTSQLite:FieldGet( nField )
                cType        := ValType( uValue )
                cValue        := AllTrim( cValToChar( uValue ) )
                ConOut("[FieldName]:["+cField+"][FieldType]:["+cType+"][FieldValue]:["+cValue+"]")
            Next nField
            ConOut("")
            lDeleted        := oTSQLite:Deleted()
            ConOut("[GoTo][RecNo]:["+LTrim(Str(nRecno))+"][Deleted]:["+cValToChar(lDeleted)+"]")
            ConOut("")
        End While

        ConOut("","[GoTo]:[END]","")
    
        For nFilial := 1 To ( nFiliais )
        
            cOrdKey        := "RA_FILIAL+RA_SEXO+RA_NOME"
            cOrdFor        := "RA_FILIAL=='"+aFiliais[nFilial]+"'.AND.RA_SEXO=='M'"

            oTSQLite:IndRegua( @cOrdKey , @cOrdFor , "Aguarde...Indexando" , !( lIsBlind ) )
            IF !( oTSQLite:Eof() )

                ConOut("","[IndRegua]:[BEGIN]","")
                ConOut("","[INDEXKEY]["+cOrdKey+"]","")
                ConOut("","[INDEXFOR]["+cOrdFor+"]","")

                While !( oTSQLite:Eof() )
                    For nField := 1 To nFields 
                        cField        := oTSQLite:FieldName( nField )
                        uValue        := oTSQLite:FieldGet( nField )
                        cType        := ValType( uValue )
                        cValue        := AllTrim( cValToChar( uValue ) )
                        ConOut("[FieldName]:["+cField+"][FieldType]:["+cType+"][FieldValue]:["+cValue+"]")
                    Next nField
                    ConOut("")
                       nRecno            := oTSQLite:RecNo()
                       lDeleted        := oTSQLite:Deleted()
                    ConOut("[Skip][RecNo]:["+LTrim(Str(nRecno))+"][Deleted]:["+cValToChar(lDeleted)+"]")
                    ConOut("")
                       oTSQLite:dbSkip()
                End While
        
                ConOut("","[INDEXKEY]["+cOrdKey+"]","")
                ConOut("","[INDEXFOR]["+cOrdFor+"]","")
                ConOut("","[IndRegua]:[END]","")
        

            EndIF

            cOrdKey    := "RA_FILIAL+RA_SEXO+RA_NOME"
            cOrdFor    := "RA_FILIAL=='"+aFiliais[nFilial]+"'.AND.RA_SEXO=='F' .AND. DTOS(RA_DEMISSA)=='        '"

            oTSQLite:IndRegua( @cOrdKey , @cOrdFor , "Aguarde...Indexando" , !( lIsBlind ) )
            IF !( oTSQLite:Eof() )

                ConOut("","[IndRegua]:[BEGIN]","")
                ConOut("","[INDEXKEY]["+cOrdKey+"]","")
                ConOut("","[INDEXFOR]["+cOrdFor+"]","")

                While !( oTSQLite:Eof() )
                    For nField := 1 To nFields 
                        cField        := oTSQLite:FieldName( nField )
                        uValue        := oTSQLite:FieldGet( nField )
                        cType        := ValType( uValue )
                        cValue        := AllTrim( cValToChar( uValue ) )
                        ConOut("[FieldName]:["+cField+"][FieldType]:["+cType+"][FieldValue]:["+cValue+"]")
                    Next nField
                    ConOut("")
                       nRecno            := oTSQLite:RecNo()
                       lDeleted        := oTSQLite:Deleted()
                    ConOut("[Skip][RecNo]:["+LTrim(Str(nRecno))+"][Deleted]:["+cValToChar(lDeleted)+"]")
                    ConOut("")
                       oTSQLite:dbSkip()
                End While
        
                ConOut("","[INDEXKEY]["+cOrdKey+"]","")
                ConOut("","[INDEXFOR]["+cOrdFor+"]","")
                ConOut("","[IndRegua]:[END]","")   
            
            EndIF    
        
        Next nFilial    

        oTSQLite:dbClose()

    END SEQUENCE

    #IFDEF __DEBUG
        oTSQLite:DropTable("BTDN_SRA010")
        oTSQLite:DropTable("TOP_FIELD")
    #ENDIF    

    oTSQLite:CloseConnection()
    oTSQLite    := oTSQLite:Destroy()

Return( NIL )

/*
     Funcao           : MyIsBlind
     Autor         : Marinaldo de jesus [ www.blacktdn.com.br ]
     Data          : 10/06/2012
     Uso           : Verifica se Esta em Modo Blind
*/
Static Function MyIsBlind()
Return( StaticCall( TSQLITE , MyIsBlind ) )

/*
     Funcao           : TSQLBrw
     Autor         : Marinaldo de jesus [ www.blacktdn.com.br ]
     Data          : 10/06/2012
     Uso           : Chamada a Funcao de Browse Array (TListBox)
*/
Static Function TSQLBrw( oTSQLite , aSetField )

    Local aFields        := Fields2Brw( oTSQLite:cCurrentAlias , @aSetField )
    Local aListBox        := Array(0)

    Local aAdvSize
    Local aObjSize
    Local aObjCoords
    Local aInfoAdvSize

    Local cQFilter         := Space( GetSx3Cache( "RA_NOME" , "X3_TAMANHO" ) )

    Local oOk              := LoadBitmap( GetResources(), "br_verde" )
    Local oNo              := LoadBitmap( GetResources(), "br_vermelho" )

    Local oDlg
    Local oPanel
    Local oListBox
    
    Local oGetFilter
    Local oGrpFilter
    Local oGrpListBox

    Local oBtnEnd
    Local oBtnFilter

    BuildLBoxArray( @oTSQLite , @cQFilter , @aListBox , @oListBox )

    aAdvSize        := MsAdvSize( .F. , .F. )
    aInfoAdvSize    := { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
    aObjCoords        := {}
    aObjSize        := {}
    aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
    aAdd( aObjCoords , { 015 , 025 , .T. , .F. } )
    aObjSize        := MsObjSize( aInfoAdvSize , aObjCoords )

    DEFINE MSDIALOG oDlg TITLE "SQLite Browse Array Table" FROM aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF GetWndDefault() PIXEL                                        

        @ 000,000 MSPANEL oPanel OF oDlg
        oPanel:Align    := CONTROL_ALIGN_ALLCLIENT

        oGrpListBox        := TGroup():New( aObjSize[1][1],aObjSize[1][2],aObjSize[1][3],aObjSize[1][4],"",oPanel,CLR_BLACK,CLR_WHITE,.T.,.F. )
        @ (aObjSize[1][1]+8),(aObjSize[1][2]+2) LISTBOX oListBox;
        FIELDS HEADER    "",;
                        aFields[AT_RA_FILIAL][1],;
                        aFields[AT_RA_MAT][1],;
                        aFields[AT_RA_NOME][1],;
                        aFields[AT_RA_SALARIO][1],;
                        aFields[AT_RA_ADMISSA][1],;
                        aFields[AT_RA_OK][1],;
                        aFields[AT_RA_DEMISSA][1],;
                        aFields[AT_RA_SEXO][1],;
                        aFields[AT_RA_MSBLQL][1],;
                        aFields[AT_R_E_C_N_O_][1],;
                        aFields[AT_R_E_C_D_E_L_][1];
        SIZE (aObjSize[1][4]-5), aObjSize[1][3]-10;
        OF oGrpListBox PIXEL ;
        COLSIZES 050,; //AT_DELETED
                 010,; //AT_RA_FILIAL
                 020,; //AT_RA_MAT
                 100,; //AT_RA_NOME
                 050,; //AT_RA_SALARIO
                 040,; //AT_RA_ADMISSA
                 010,; //AT_RA_OK
                 040,; //AT_RA_DEMISSA
                 010,; //AT_RA_SEXO
                 050,; //AT_RA_MSBLQL
                 050,; //AT_R_E_C_N_O_
                 050   //AT_R_E_C_D_E_L_

        oListBox:SetArray( aListBox )

        oListBox:bLine    := { || oTSQLite:dbGoTo( aListBox[ oListBox:nAT ][ AT_R_E_C_N_O_ ] ),;
                                {;
                                    IF(aListBox[oListBox:nAT][AT_DELETED],oNo,oOk),;
                                    aListBox[oListBox:nAT][AT_RA_FILIAL],;
                                    aListBox[oListBox:nAT][AT_RA_MAT],;
                                    aListBox[oListBox:nAT][AT_RA_NOME],;
                                    Transform(aListBox[oListBox:nAT][AT_RA_SALARIO],aFields[AT_RA_SALARIO][6]),;
                                    aListBox[oListBox:nAT][AT_RA_ADMISSA],;
                                    aListBox[oListBox:nAT][AT_RA_OK],;
                                    aListBox[oListBox:nAT][AT_RA_DEMISSA],;
                                    aListBox[oListBox:nAT][AT_RA_SEXO],;
                                    aListBox[oListBox:nAT][AT_RA_MSBLQL],;
                                    aListBox[oListBox:nAT][AT_R_E_C_N_O_],;
                                    aListBox[oListBox:nAT][AT_R_E_C_D_E_L_];
                                 };
                              }

        oGrpFilter        := TGroup():New( aObjSize[2][1] , aObjSize[2][2] , ( aObjSize[2][3] - 3 ) , ( aObjSize[2][4]/100*40 - 2 ),"&Filtrar",oPanel,CLR_BLACK,CLR_WHITE,.T.,.F. )            
        oGetFilter         := TGet():New( aObjSize[2][1] + 8,aObjSize[2][2]+1,{|u| If(PCount()>0,cQFilter:=u,cQFilter)},oGrpFilter,( aObjSize[2][4]/100*40 - 2 )-48-1,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"",@cQFilter,,)
        oBtnFilter        := TButton():New( aObjSize[2][1] + 8,( aObjSize[2][4]/100*40 - 2 ) - 48,"&Filtrar",oGrpFilter,{|| QFilter( @oTSQLite , @cQFilter , @aListBox , @oListBox )},046,010,,,,.T.,,"",,,,.F. )                    

        oBtnEnd            := TButton():New( aObjSize[2][1] + 4 , aObjSize[2][4] - 48,"&Sair",oPanel,{|| oDlg:End()},048,18.5,,,,.T.,,"",,,,.F. )                                            

    ACTIVATE DIALOG oDlg CENTERED

Return( NIL )

/*
     Funcao           : QFilter
     Autor         : Marinaldo de jesus [ www.blacktdn.com.br ]
     Data          : 10/06/2012
     Uso           : Setar o Filtro para a ListBox
*/
Static Function QFilter( oTSQLite , cQFilter , aListBox , oListBox )
    DEFAULT cQFilter    := ""
    BuildLBoxArray( @oTSQLite , @cQFilter , @aListBox , @oListBox )
    oListBox:nAT        := 1
    oListBox:Reset()
Return( .T. )

/*
     Funcao           : BuildLBoxArray
     Autor         : Marinaldo de jesus [ www.blacktdn.com.br ]
     Data          : 10/06/2012
     Uso           : Carregar os dados para o ListBox
*/
Static Function BuildLBoxArray( oTSQLite , cQFilter , aListBox , oListBox )

    Local cOrdKey    := "RA_FILIAL+RA_MAT"
    Local cOrdFor    := "RA_FILIAL==RA_FILIAL"

    Local nListBox := 0

    aSize( aListBox , nListBox )

    DEFAULT cQFilter    := ""
    
    IF !Empty( cQFilter )
        cOrdFor        := "'"+cQFilter+"'$RA_NOME"
        oTSQLite:IndRegua( @cOrdKey , @cOrdFor , "Aguarde...Indexando" , .T. )
    Else
        oTSQLite:IndRegua( @cOrdKey , @cOrdFor , "Aguarde...Indexando" , .T. )
    EndIF

    While !( oTSQLite:Eof() )

        ++nListBox
        aAdd( aListBox , Array( AT_FIELDS ) )

        aListBox[ nListBox ][ AT_DELETED        ]    := oTSQLite:FieldGet("DELETED")
        aListBox[ nListBox ][ AT_RA_FILIAL        ]    := oTSQLite:FieldGet("RA_FILIAL")
        aListBox[ nListBox ][ AT_RA_MAT            ]    := oTSQLite:FieldGet("RA_MAT")
        aListBox[ nListBox ][ AT_RA_NOME        ]    := oTSQLite:FieldGet("RA_NOME")
        aListBox[ nListBox ][ AT_RA_SALARIO        ]    := oTSQLite:FieldGet("RA_SALARIO")
        aListBox[ nListBox ][ AT_RA_ADMISSA        ]    := oTSQLite:FieldGet("RA_ADMISSA")
        aListBox[ nListBox ][ AT_RA_OK            ]    := oTSQLite:FieldGet("RA_OK")
        aListBox[ nListBox ][ AT_RA_DEMISSA        ]    := oTSQLite:FieldGet("RA_DEMISSA")
        aListBox[ nListBox ][ AT_RA_SEXO        ]    := oTSQLite:FieldGet("RA_SEXO")
        aListBox[ nListBox ][ AT_RA_MSBLQL        ]    := oTSQLite:FieldGet("RA_MSBLQL")
        aListBox[ nListBox ][ AT_R_E_C_N_O_        ]    := oTSQLite:FieldGet("R_E_C_N_O_")
        aListBox[ nListBox ][ AT_R_E_C_D_E_L_    ]    := oTSQLite:FieldGet("R_E_C_D_E_L_")

        oTSQLite:dbSkip()

    End While

    lBuildOk := ( nListBox > 0 )
    IF !( lBuildOk  )

        ++nListBox
        aAdd( aListBox , Array( AT_FIELDS ) )

        aListBox[ nListBox ][ AT_DELETED        ]    := oTSQLite:FieldGet("DELETED")
        aListBox[ nListBox ][ AT_RA_FILIAL        ]    := oTSQLite:FieldGet("RA_FILIAL")
        aListBox[ nListBox ][ AT_RA_MAT            ]    := oTSQLite:FieldGet("RA_MAT")
        aListBox[ nListBox ][ AT_RA_NOME        ]    := oTSQLite:FieldGet("RA_NOME")
        aListBox[ nListBox ][ AT_RA_SALARIO        ]    := oTSQLite:FieldGet("RA_SALARIO")
        aListBox[ nListBox ][ AT_RA_ADMISSA        ]    := oTSQLite:FieldGet("RA_ADMISSA")
        aListBox[ nListBox ][ AT_RA_OK            ]    := oTSQLite:FieldGet("RA_OK")
        aListBox[ nListBox ][ AT_RA_DEMISSA        ]    := oTSQLite:FieldGet("RA_DEMISSA")
        aListBox[ nListBox ][ AT_RA_SEXO        ]    := oTSQLite:FieldGet("RA_SEXO")
        aListBox[ nListBox ][ AT_RA_MSBLQL        ]    := oTSQLite:FieldGet("RA_MSBLQL")
        aListBox[ nListBox ][ AT_R_E_C_N_O_        ]    := oTSQLite:FieldGet("R_E_C_N_O_")
        aListBox[ nListBox ][ AT_R_E_C_D_E_L_    ]    := oTSQLite:FieldGet("R_E_C_D_E_L_")

    EndIF

Return( lBuildOk )

/*
     Funcao           : Fields2Brw
     Autor         : Marinaldo de jesus [ www.blacktdn.com.br ]
     Data          : 10/06/2012
     Uso           : Carregar os campos para a funcao de Browse
*/
Static Function Fields2Brw( cAlias , adbStruct )

    Local aArea        := GetArea()
    Local aSX3Area    := SX3->( GetArea() )

    Local aFields    := Array(0)
    
    Local cField

    Local lSX3
    Local lField

    Local i            := 0
    Local nField
    Local nFields    := Len( adbStruct )
    Local nX3PadR    := Len( SX3->X3_CAMPO )

    SX3->( dbSetOrder( 2 ) ) //X3_CAMPO
    For nField := 1 To nFields

        cField    := adbStruct[nField][DBS_NAME]
        lField    := ( cAlias )->( FieldPos( cField ) > 0 )

        IF !( lField )
            Loop
        EndIF

        cField    := Padr( cField , Max( Len( cField ) , nX3PadR ) )

        lSX3    := ( SX3->( dBSeek( cField , .F. ) ) .and. ( ( cAlias )->( FieldPos( SX3->X3_CAMPO ) ) > 0 ) )

        ++i
        aAdd( aFields , Array( 6 ) )

        IF ( lSX3 )
            aFields[i][1] := SX3->X3_TITULO
            aFields[i][2] := cField
            aFields[i][3] := SX3->X3_TIPO
            aFields[i][4] := SX3->X3_TAMANHO
            aFields[i][5] := SX3->X3_DECIMAL
            aFields[i][6] := SX3->X3_PICTURE
        Else
            aFields[i][1] := cField
            aFields[i][2] := cField
            aFields[i][3] := adbStruct[nField][DBS_TYPE]
            aFields[i][4] := adbStruct[nField][DBS_LEN]
            aFields[i][5] := adbStruct[nField][DBS_DEC]
            aFields[i][6] := ""
        EndIf

    Next nField

    RestArea( aSX3Area )
    RestArea( aArea )

Return( aFields )
