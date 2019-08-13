#include "protheus.ch"

/*
    PROGRAMA: U_CT102BUT.PRG
    Funcao: U_CT102BUT
    Autor: Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data: 17/09/2012
    Uso: Ponto de Entrada CT102BUT. Utilizado para adicionar novas opcoes no menu aRotina no programa
    CTBA102.    
*/
User Function CT102BUT()

    Local aMenuDef:= ParamIxb
    Local aMenuNew:= Array(0)
    Local lAddBFilter:= .T.

    #IFNDEF DEBUG
        lAddBFilter:= .NOT.((PswAdmin(NIL,NIL,RetCodUsr())==0))
    #ENDIF
    IF (lAddBFilter)
        CT102AddBFilter(@aMenuDef,@aMenuNew)
    EndIF    

Return(aMenuNew)

/*
    PROGRAMA: U_CT102BUT.PRG
    Funcao: CT102AddBFilter
    Autor: Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data: 17/09/2012
    Uso: Adiciona Opcao de Filtro no Menu aRotina
*/
Static Procedure CT102AddBFilter(aMenuDef,aMenuNew)

    Local aNewMenu
    Local aNewItem

    Local nAT
    Local nNewItem

    BEGIN SEQUENCE

        IF ( Select("CT2") > 0 )
            IF CT2->( Eof() .and. Bof() )
                U_CT102CFilter() //Garanto que na Entrada da Rotina o Filtro seja Limpo
            EndIF
        EndIF    

        IF ( Len(aMenuDef) == 0 )
            BREAK
        EndIF

        nAT:= aScan(aMenuDef,{|x|x[4]==3}) //Procuro pela Opção de Inclusao
        IF ( nAT == 0 )
            BREAK
        EndIF

        aNewItem:= Array(0)

        aAdd( aNewItem , aClone(aMenuDef[nAT]) )
        nNewItem:= Len(aNewItem)
        aNewItem[nNewItem][1]:= "Filtrar"
        aNewItem[nNewItem][2]:= "U_CT102BFilter"

        aAdd( aNewItem , aClone(aMenuDef[nAT]) )
        nNewItem:= Len(aNewItem)
        aNewItem[nNewItem][1]:= "Limpar"
        aNewItem[nNewItem][2]:= "U_CT102CFilter"

        aNewMenu:= aClone(aMenuDef[nAT])
        aNewMenu[1]:= "Filtro"
        aNewMenu[2]:= aNewItem

        aAdd(aMenuNew,aNewMenu)

    END SEQUENCE
        
Return

/*
    PROGRAMA: U_CT102BUT.PRG
    Funcao: U_CT102BFilter
    Autor: Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data: 17/09/2012
    Uso: Adicionar opção de Filtro Customizado no menu aRotina do Programa CTBA102
*/
User Function CT102BFilter(cAlias,nReg,nOpc)

    Local aFields:= Array(0)

    Local aFilter

    Local bErrorBlock 

    Local cX3Box
    Local cX3Campo

    Local cFilter:= ""
    Local cCT2Index:= "CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC"
    Local cIndexFilter
    
    Local lSeeAll
    Local lObjBrw

    Local nField
    Local nCT2Order:= RetOrder("CT2",cCT2Index)

    Local oWnd
    Local oFilter
    Local oObjBrow

    BEGIN SEQUENCE

        oObjBrow:= GetObjBrow()
        lObjBrw:= ( ValType(oObjBrow)=="O" )

        IF .NOT.( lObjBrw )
            BREAK
        ENDIF

        oWnd:= oObjBrow:oWnd
        oFilter:= FWFilter():New(oWnd,{||.T.})

        cAlias:= "CT2"

        aFields:= Array(0)

        SX3->( dbSeek( cAlias , .F. ) )
        While SX3->( .NOT.( Eof() ) .and. X3_ARQUIVO == cAlias )
            cX3Campo:= AllTrim(SX3->X3_CAMPO)
            IF ( ( SX3->X3_CONTEXT $ " R" ) .and. .NOT.( "CT2_DATA" == cX3Campo ) )
                aAdd(aFields,Array(10))
                nField:= Len(aFields)
                aFields[nField][01]:= cX3Campo
                aFields[nField][02]:= SX3->X3_TITULO
                aFields[nField][03]:= SX3->X3_TIPO
                aFields[nField][04]:= SX3->X3_TAMANHO
                aFields[nField][05]:= SX3->X3_DECIMAL
                aFields[nField][06]:= SX3->X3_PICTURE
                cX3Box := SX3->( X3cBox() )
                IF .NOT.( Empty(cX3Box) )
                    aX3Box:= SX3->( RetSx3Box( cX3Box , NIL , NIL , X3_TAMANHO , NIL ) )
                    aFields[nField][07]:= aClone( aX3Box )
                Else
                    aFields[nField][07]:= Array(0)
                EndIF
                aFields[nField][08]:= "" //???SX3->X3_F3
                aFields[nField][09]:= { || .T. }
                aFields[nField][10]:= ""
            EndIF
            SX3->( dbSkip() )
        End While
    
        (cAlias)->( dbSetOrder( nCT2Order ) )
    
        oFilter:SetAlias(cAlias)
        oFilter:SetField(aFields)
        oFilter:SetSqlFilter(.T.)
        bErrorBlock:= ErrorBlock({|o|Break(o)})
        BEGIN SEQUENCE
            oFilter:EditFilter()
        RECOVER
            ApMsgInfo("Opção de Filtro Customizado não disponível para a Inferface em Uso.", "A T E N Ç Ã O !!!")
            ErrorBlock(bErrorBlock)
            BREAK
        END SEQUENCE    
        ErrorBlock(bErrorBlock)
        
        aFilter:= oFilter:aFilter
        
        oFilter:= FreeObj(oFilter)
    
        BEGIN SEQUENCE
    
            IF .NOT.( ChkInterval(.T.) )
                BREAK
            EndIF
    
            #IFNDEF ORTOBOM_DEBUG
                lSeeAll:= .F.
            #ELSE
                IF (PswAdmin(NIL,NIL,RetCodUsr())==0)
                    lSeeAll:= ( aScan( oObjBrow:aColumns , { |o| "Filial" $ o:cHeading } ) > 0 )
                EndIF
            #ENDIF    
        
            IF ( .NOT.Empty( aFilter ) )
                IF .NOT.( Empty( aFilter[1][2] ) )
                    cFilter:= AddKeyFields(@cCT2Index,@lSeeAll,.T.)
                    cFilter += " AND ("+aFilter[1][2]+")"
                Else
                    cFilter:= AddKeyFields(@cCT2Index,@lSeeAll,.T.)
                EndIF
            Else
                cFilter:= AddKeyFields(@cCT2Index,@lSeeAll,.T.)
            ENDIF
        
            U_CT102CFilter(@cAlias,@nReg,@nOpc)
        
            SetMBTopFilter( cAlias , cFilter , .T. )
        
            oObjBrow:ResetLen()
            oObjBrow:GoBottom()
            oObjBrow:GoTop()
            oObjBrow:Refresh()
    
        END SEQUENCE

    END SEQUENCE

Return(MbrChgLoop(.F.)) //Considerando que estou utilizando a Opcao de Incluir. Desabilito o Loop

/*
    PROGRAMA: U_CT102BUT.PRG
    Funcao: U_CT102CFilter
    Autor: Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data: 17/09/2012
    Uso: Adicionar opção de Filtro Customizado no menu aRotina do Programa CTBA102
*/
User Function CT102CFilter(cAlias,nReg,nOpc)

    Local cFilter
    Local cCT2Index:= "CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC"
                        
    Local lSeeAll:= .F.
    Local lObjBrw

    Local nCT2Order:= RetOrder("CT2",cCT2Index)

    Local oObjBrow:= GetObjBrow()

    BEGIN SEQUENCE

        cAlias:= "CT2"

        (cAlias)->( dBClearFilter() )
        (cAlias)->( dbSetOrder( nCT2Order ) )
        (cAlias)->( dbGoTop() )
    
        lObjBrw:= ( ValType(oObjBrow)=="O" )

        GetSetMbFilter("")

        IF .NOT.( lObjBrw )
            BREAK
        ENDIF

        SetMBTopFilter( @cAlias , "" )

        #IFNDEF DEBUG
            lSeeAll:= .F.
        #ELSE
            IF (PswAdmin(NIL,NIL,RetCodUsr())==0)
                lSeeAll:= ( aScan( oObjBrow:aColumns , { |o| "Filial" $ o:cHeading } ) > 0 )
            EndIF    
        #ENDIF    

        cFilter:= AddKeyFields(@cCT2Index,@lSeeAll,.F.)

        SetMBTopFilter( @cAlias , @cFilter , .T. )

        oObjBrow:ResetLen()
        oObjBrow:GoBottom()
        oObjBrow:Gotop()
        oObjBrow:Refresh()

    END SEQUENCE

Return( NIL )

/*
    PROGRAMA: U_CT102BUT.PRG
    Funcao: U_CT102BFilter
    Autor: Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data: 17/09/2012
    Uso: Adicionar opção de Filtro Customizado no menu aRotina do Programa CTBA102
*/
Static Function AddKeyFields(cCT2Index,lSeeAll,lChkData)

    Local aCT2Index:= StrTokArr2(SqlOrder(cCT2Index),",")    

    Local cCT2Filial:= xFilial("CT2")
    Local cCT2FilDe:= Space(Len(cCT2Filial))
    Local cCT2FilAte:= Replicate("Z",Len(cCT2Filial))
    Local cIndexFilter:= ""

    Local lChkInterval:= .F.

    Local nField
    Local nFields:= Len(aCT2Index)

    DEFAULT lSeeAll:= .F.
    DEFAULT lChkData:= .F.

    For nField:= 1 To nFields
        cField:= AllTrim(aCT2Index[nField])
        cIndexFilter += "("
        cIndexFilter += cField
        IF ( cField == "CT2_FILIAL" )
            IF ( lSeeAll )
                cIndexFilter += " BETWEEN '"+cCT2FilDe+"' AND '"+cCT2FilAte+"'"
            Else
                cIndexFilter += "="
                cIndexFilter += "'"+cCT2Filial+"'"
            EndIF    
        ElseIF ( ( cField == "CT2_DATA" ) .and. ( lChkData ) )
            lChkInterval:= ( .NOT.(Type("cCT102dIni")=="C") .or. Empty(cCT102dIni) )
            IF .NOT.( lChkInterval )
                lChkInterval:= ( .NOT.(Type("cCT102dFim")=="C") .or. Empty(cCT102dFim) )
            EndIF
            IF ( lChkInterval )
                ChkInterval(.F.)
            EndIF
            IF ( cCT102dIni == cCT102dFim )
                cIndexFilter += "='"+cCT102dIni+"'"
            Else
                cIndexFilter += " BETWEEN '"+cCT102dIni+"' AND '"+cCT102dFim+"'"
            EndIF    
        Else
            cIndexFilter += "="
            cIndexFilter += cField
        EndIF
        cIndexFilter += ")"
        cIndexFilter += " AND "
    Next nField
    cIndexFilter += " ( D_E_L_E_T_=' ')"

Return(cIndexFilter)

/*
    Programa: U_CT102BUT.PRG
    Funcao: GetSetMbFilter
    Autor: Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data: 18/09/2012
    Uso: GetSet do Filtro da mBrowse
*/
Static Function GetSetMbFilter( cExprFilTop )

    Local bError:= { || &(cError) }
    Local bErrorBlock:= ErrorBlock( bError )

    Local cError:= "(__cSvTopFilter:='',__cTopRealFilter:='',__cFiltroPadrao:='')"
    Local cLastFilter

    Static _cStkLstFilter

    cLastFilter:= _cStkLstFilter
    _cStkLstFilter:= cExprFilTop

    BEGIN SEQUENCE
        VerSenha(.T.)
    END SEQUENCE
    ErrorBlock(bErrorBlock)

Return( cLastFilter )

/*
    Programa: U_CT102BUT.PRG
    Funcao: ChkInterval
    Autor: Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data: 18/09/2012
    Uso: Limitar o Intervalo de Filtro ao Parametro De/Ate
*/
Static Function ChkInterval(lShow)

    Local cPerg:= "CT102BUTFB"

    Local cDataIni
    Local cDataFim

    Local dTmp
    Local dMaxDe
    Local dMaxAte

    Local dDataIni
    Local dDataFim

    Local lOK:= .F.

    Local nMVCT102FB:= GetNewPar("MV_CT102FB",1)

    BEGIN SEQUENCE

        DEFAULT lShow:= .T.

        lOK:= ValidPerg(@cPerg,@lShow)

        IF .NOT.( lShow )
            lOK:= .T.
        EndIF    

        IF .NOT.( lOK )
            BREAK
        EndIF

        dDataIni:= MV_PAR01
        dDataFim:= MV_PAR02

        IF ( dDataIni > dDataFim )
            dTmp:= dDataIni
            dDataIni:= dDataFim
            dDataFim:= dTmp
        EndIF

        IF .NOT.( Type("dDataBase") == "D" )
            Private dDataBase:= MsDate()
        EndIF

        dMaxDe:= Max(dDataIni,MonthSub(dDataBase,nMVCT102FB))
        dMaxAte:= Min(dDataFim,MonthSum(dDataBase,nMVCT102FB))

        IF ( ( dDataIni > dMaxAte ) .or. ( dDataIni < dMaxDe ) )
            dDataIni:= dMaxDe
        EndIF

        IF ( ( dDataFim > dMaxAte ) .or. ( dDataFim < dMaxDe ) )
            dDataFim:= dMaxAte
        EndIF

        cDataIni:= DtoS(dDataIni)
        cDataFim:= DtoS(dDataFim)

        _SetOwnerPrvt("cCT102dIni",cDataIni)
        _SetOwnerPrvt("cCT102dFim",cDataFim)

    END SEQUENCE

Return( lOK )

/*
    Programa: U_CT102BUT.PRG
    Funcao: ValidPerg
    Autor: Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data: 18/09/2012
    Uso: Limitar o Intervalo de Filtro ao Parametro De/Ate
*/
Static Function ValidPerg(cPerg,lShow)

    Local aPerg:= Array(0)
    Local aGrpSXG


    Local cOrdem:= Replicate("0", Len( SX1->X1_ORDEM ) )
    Local cGRPSXG:= ""

    Local cX1Tipo
    Local cPicSXG

    Local nTamSXG:= 0
    Local nDecSXG:= 0

    cPerg:= Padr( cPerg , Len( SX1->X1_GRUPO ) )

    cOrdem:= __Soma1( cOrdem )
    cGRPSXG:= ""
    aGRPSXG:= SXGSize(cGRPSXG,X3Tamanho("CT2_DATA"),X3Decimal("CT2_DATA"),X3Picture("CT2_DATA"))
    nTamSXG:= aGRPSXG[1]
    nDecSXG:= aGRPSXG[2]
    cPicSXG:= aGRPSXG[3]
    cX1Tipo:= X3Tipo( "CT2_DATA")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Data De ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"Data De ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"Data De ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CH1")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","NAOVAZIO()")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR01")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)
    
    
    cOrdem:= __Soma1( cOrdem )
    cGRPSXG:= ""
    aGRPSXG:= SXGSize(cGRPSXG,X3Tamanho("CT2_DATA"),X3Decimal("CT2_DATA"),X3Picture("CT2_DATA"))
    nTamSXG:= aGRPSXG[1]
    nDecSXG:= aGRPSXG[2]
    cPicSXG:= aGRPSXG[3]
    cX1Tipo:= X3Tipo( "CT2_DATA")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Data Ate ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"Data Ate ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"Data Ate ?")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CH2")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","NAOVAZIO()")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR02")
    AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
    AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

    PutSX1(@cPerg,@aPerg)

    DEFAULT lShow:= .T.

Return( Pergunte( cPerg , lShow ) )

/*
    Programa: U_CT102BUT.PRG
    Funcao: PutSX1
    Autor: Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data: 18/09/2012
    Uso: Gravar as Perguntas no Dicionario de Perguntas
*/
Static Function PutSX1(cPerg,aPerg)
Return(StaticCall(NDJLIB001,PutSX1,@cPerg,@aPerg))

/*
    Programa: U_CT102BUT.PRG
    Funcao: AddPerg
    Autor: Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data: 18/09/2012
    Uso: Adicionar um novo item de pergunta
*/
Static Function AddPerg(aPerg,cGrupo,cOrdem,cField,uCNT) 
Return(StaticCall(NDJLIB001,AddPerg,@aPerg,@cGrupo,@cOrdem,@cField,@uCNT))

/*
    Programa: U_CT102BUT.PRG
    Funcao: X3_TIPO
    Autor: Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data: 18/09/2012
    Uso: Obter o X3_TIPO do campo
*/
Static Function X3Tipo( cField )
Return(StaticCall(NDJLIB001,X3Tipo,cField))

/*
    Programa: U_CT102BUT.PRG
    Funcao: X3_TAMANHO
    Autor: Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data: 18/09/2012
    Uso: Obter o X3Tamanho do campo
*/
Static Function X3Tamanho(cField)
Return(StaticCall(NDJLIB001,X3Tamanho,cField))

/*
    Programa: U_CT102BUT.PRG
    Funcao: X3Decimal
    Autor: Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data: 18/09/2012
    Uso: Obter o X3_DECIMAL do campo
*/
Static Function X3Decimal(cField)
Return(StaticCall(NDJLIB001,X3Decimal,cField))

/*
    Programa: U_CT102BUT.PRG
    Funcao: X3Picture
    Autor: Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data: 18/09/2012
    Uso: Obter o X3_PICTURE do campo
*/
Static Function X3Picture(cField)
Return(StaticCall(NDJLIB001,X3Picture,cField))

/*
    Programa: U_CT102BUT.PRG
    Funcao: SXGSize
    Autor: Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data: 18/09/2012
    Uso: Obter informacoes do SXG para o campo
*/
Static Function SXGSize(cGRPSXG,nSize,nDec,cPicture)
Return(StaticCall(NDJLIB001,SXGSize,@cGRPSXG,@nSize,@nDec,@cPicture))
