#INCLUDE "NDJ.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT103IPC º Autor ³ Jose Carlos Noronhaº Data ³  19/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                                                            º±±
±±º          ³ Ponto de Entrada na rotina de documento de entrada, gerado º±±
±±º          ³ a partir do pedido de compras [F5], para preencher campos  º±±
±±º          ³ especificos.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
User Function MT103IPC

Local aArea            := GetArea()
Local aSZ0Area        := SZ0->( GetArea() )

Local cSZ0Filial    := xFilial( "SZ0" )
Local cSC1Filial    := xFilial( "SC1" )
Local cSZ0KeySeek

Local lLinkSZ0

Local nSZ0Order    := RetOrder( "SZ0" , "Z0_FILIAL+Z0_ALIAS+Z0_XFILIAL+Z0_PROJETO+Z0_REVISAO+Z0_TAREFA+Z0_NUM+Z0_ITEM+Z0_ITEMGRD+Z0_ORCAME+Z0_XCODOR+Z0_XCODSBM+Z0_SEQUEN" )

_nItem := ParamIxb[1]                                                         
IF (;
        ( ValType( _nItem ) == "N" );
        .and.;
        ( _nItem > 0 );
        .and.;
        ( Type( "aCols"  ) == "A" );
        .and.;
        ( _nItem <= Len( aCols  ) );
    )

    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XEQUIPA"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]     := SC7->C7_XEQUIPA
    EndIF    

    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XCLIORG"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]     := SC7->C7_XCLIORG
    EndIF    
    
    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XCONTAT"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]     := SC7->C7_XCONTAT
    EndIF    
    
    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XENDER"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]     := SC7->C7_XENDER
    EndIF    
    
    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XCODSBM"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]     := SC7->C7_XCODSBM
    EndIF    
    
    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XSBM"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]     := SC7->C7_XSBM
    EndIF    
    
    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XLOJAIN"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]     := SC7->C7_XLOJAIN
    EndIF    
    
    nPosA                       := aScan(aHeader,{|x| Alltrim(x[2])="D1_XRESPON"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]     := SC7->C7_XRESPON
    EndIF    
    
    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XCLIINS"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]     := SC7->C7_XCLIINS
    EndIF    
    
    // 29/10/2010 - Novos Campos
    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XGARA"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]     := SC7->C7_XGARA
    EndIF    
    
    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XMODALI"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]     := SC7->C7_XMODALI
    EndIF    
    
    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XNUMPRO"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]     := SC7->C7_XNUMPRO
    EndIF    
    
    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XPROP1"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]     := SC7->C7_XPROP1
    EndIF    
    
    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XMODELO"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]    := SC7->C7_XMODELO
    EndIF    
    
    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XMARCA"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]    := SC7->C7_XMARCA
    EndIF    
    
    // 01/11/2010 - Novo Campo
    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XPROJET"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]    := SC7->C7_XPROJET
    EndIF

    // 22/11/2010 - Novos Campos
    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XSZ2COD"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]    := SC7->C7_XSZ2COD
    EndIF

    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XSSBM"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]    := SC7->C7_XSBM
    EndIF

    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XCODOR"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]    := SC7->C7_XCODOR
    EndIF

    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XNUMSC"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]    := SC7->C7_NUMSC
    EndIF

    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XITEMSC"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]    := SC7->C7_ITEMSC
    EndIF

    // 23/11/2010 - Novo Campo
    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_CC"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]    := SC7->C7_CC
    EndIF

    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_CLVL"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]    := SC7->C7_CLVL
    EndIF

    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_ITEMCTA"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]    := SC7->C7_ITEMCTA
    EndIF

    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XINCHRS"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]    := Time()
    EndIF

    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XTAREFA"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]    := SC7->C7_XTAREFA
    EndIF

    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_CODORCA"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]    := SC7->C7_CODORCA
    EndIF

    // 06/12/2010 - Noronha - Campo do usuario para atesto
    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XUSER"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]    := SC7->C7_USER
    EndIF

    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XSEQUEN"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]    := SC7->C7_SEQUEN
    EndIF

    // 13/12/2010 - Noronha - Campo do usuario para atesto
    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XCODGE"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]    := Posicione("AF8",1,xFilial("AF8")+SC7->C7_XPROJET,"AF8_XCODGE")
    EndIF

    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XREVIS"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]    := SC7->C7_XREVIS
    EndIF

    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XCODGE"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]    := SC7->C7_XCODGE
    EndIF

    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_XVISCTB"})
    IF ( nPosA > 0 )
        aCols[_nItem][nPosA]    := SC7->C7_XVISCTB
    EndIF

    nPosA                        := aScan(aHeader,{|x| Alltrim(x[2])="D1_Z0LINKD"})
    IF ( nPosA > 0 )

        SZ0->( dbSetOrder( nSZ0Order ) )

        cSZ0KeySeek    := cSZ0Filial                                            //Z0_FILIAL
        cSZ0KeySeek    += "SC1"                                                //Z0_ALIAS
        cSZ0KeySeek    += cSC1Filial                                            //Z0_XFILIAL
        cSZ0KeySeek    += SC7->C7_XPROJET                                        //Z0_PROJETO
        cSZ0KeySeek    += SC7->C7_XREVIS                                         //Z0_REVISAO
        cSZ0KeySeek    += SC7->C7_XTAREFA                                        //Z0_TAREFA
        cSZ0KeySeek    += SC7->C7_NUMSC                                        //Z0_NUM
        cSZ0KeySeek    += SC7->C7_ITEMSC                                        //Z0_ITEM
        cSZ0KeySeek    += SC7->C7_ITEMGRD                                        //Z0_ITEMGRD
        cSZ0KeySeek    += SC7->C7_CODORCA                                        //Z0_ORCAME
        cSZ0KeySeek    += SC7->C7_XCODOR                                        //Z0_XCODOR
        cSZ0KeySeek    += SC7->C7_XCODSBM                                        //Z0_XCODSBM
        cSZ0KeySeek    += Space( GetSx3Cache( "Z0_SEQUEN" , "X3_TAMANHO" ) )    //Z0_SEQUEN

        lLinkSZ0    := SZ0->( dbSeek( cSZ0KeySeek , .F. ) )

        IF !( lLinkSZ0 )

            cSZ0KeySeek    := cSZ0Filial                                        //Z0_FILIAL
            cSZ0KeySeek    += "SC7"                                            //Z0_ALIAS
            cSZ0KeySeek    += SZ7->C7_FILIAL                                    //Z0_XFILIAL
            cSZ0KeySeek    += SC7->C7_XPROJET                                    //Z0_PROJETO
            cSZ0KeySeek    += SC7->C7_XREVIS                                     //Z0_REVISAO
            cSZ0KeySeek    += SC7->C7_XTAREFA                                    //Z0_TAREFA
            cSZ0KeySeek    += SC7->C7_NUMSC                                    //Z0_NUM
            cSZ0KeySeek    += SC7->C7_ITEMSC                                    //Z0_ITEM
            cSZ0KeySeek    += SC7->C7_ITEMGRD                                    //Z0_ITEMGRD
            cSZ0KeySeek    += SC7->C7_CODORCA                                    //Z0_ORCAME
            cSZ0KeySeek    += SC7->C7_XCODOR                                    //Z0_XCODOR
            cSZ0KeySeek    += SC7->C7_XCODSBM                                    //Z0_XCODSBM
            cSZ0KeySeek    += SC7->C7_SEQUEN                                    //Z0_SEQUEN

            lLinkSZ0    := SZ0->( dbSeek( cSZ0KeySeek , .F. ) )

        EndIF

        IF ( lLinkSZ0 )
            aCols[_nItem][nPosA]    := lLinkSZ0
        EndIF

    EndIF

EndIF

RestArea( aSZ0Area )
RestArea( aArea )

Return( nil )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        __cCRLF        := NIL    
        lRecursa    := __Dummy( .F. )
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
