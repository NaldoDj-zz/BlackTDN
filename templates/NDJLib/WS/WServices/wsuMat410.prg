#INCLUDE "NDJ.CH"

#DEFINE STR0001 "Servi&ccedil;o de consulta e atualiza&ccedil;&atilde;o dos pedidos de venda"
#DEFINE STR0002 "M&eacute;todo de Inclus&atilde;o do Pedido de Venda"
#DEFINE STR0003 "M&eacute;todo de Exclus&atilde;o do Pedido de Venda"
#DEFINE STR0004 "M&eacute;todo de Consulta ao Pedido de Venda"
#DEFINE STR0005     "M&eacute;todo de Consulta a Lista de Pedido(s) de Venda(s) Por Per&iacute;odo e CNPJ"
#DEFINE STR0006 "Cliente invalido"
#DEFINE STR0007 "CNPJ invalido"
#DEFINE STR0008 "Problema no Cabecalho do Pedido"
#DEFINE STR0009 "Problema nos Itens do Pedido"
#DEFINE STR0010 "Pedido nao encontrado"
#DEFINE STR0011 "O Pedido de numero: " 
#DEFINE STR0012 "Da Empresa CNPJ/CGC: "
#DEFINE STR0013 "Foi excluido com sucesso"
#DEFINE STR0014 "Liberado"
#DEFINE STR0015 "01 - Bloqueio de Credito por Valor"
#DEFINE STR0016 "04 - Vencto do Limite de Credito - Data de Credito Vencida"
#DEFINE STR0017 "05 - Bloqueio de Credito por Estorno"
#DEFINE STR0018 "06 - Bloqueio de Credito por Risco"
#DEFINE STR0019 "09 - Rejeicao de Credito - Rejeitado Manualmente"
#DEFINE STR0020 "10 - FATURADO"
#DEFINE STR0021 "Liberado"
#DEFINE STR0022 "02 - Bloqueio de Estoque"
#DEFINE STR0023 "03 - Bloqueio Manual de Estoque"
#DEFINE STR0024 "10 - FATURADO"
#DEFINE STR0025 "01 - Bloqueio de Enderecamento do WMS/Somente SB2"
#DEFINE STR0026 "02 - Bloqueio de Enderecamento do WMS"
#DEFINE STR0027 "03 - Bloqueio de WMS - Externo"
#DEFINE STR0028 "05 - Liberacao para Bloqueio 01"
#DEFINE STR0029 "06 - Liberacao para Bloqueio 02"
#DEFINE STR0030 "07 - Liberacao para Bloqueio 03"
#DEFINE STR0031 "Nao Existem Pedidos para o Cliente CNPJ: "
#DEFINE STR0032 "No Periodo Informado: "

WSSTRUCT tStatusPedido
    WSDATA BloqCredito                AS String    OPTIONAL    //C9_BLCRED:
                                                                /*/
                                                                    " "    - Liberado
                                                                    01    - Bloqueio de Credito por Valor 
                                                                    04    - Vencto do Limite de Credito - Data de Credito Vencida
                                                                    05    - Bloqueio de Credito por Estorno
                                                                    06    - Bloqueio de Credito por Risco
                                                                    09    - Rejeicao de Credito - Rejeitado Manualmente
                                                                    10    - FATURADO
                                                                /*/    
    WSDATA BloqEstoque                AS String    OPTIONAL    //C9_BLEST:
                                                                /*/
                                                                    " "    - Liberado
                                                                    02    - Bloqueio de Estoque
                                                                    03    - Bloqueio Manual de Estoque
                                                                    10    - FATURADO
                                                                /*/    
    WSDATA BloqueioWMS                AS String    OPTIONAL    //C9_BLWMS:
                                                                /*/
                                                                    01    - Bloqueio de Enderecamento do WMS/Somente SB2
                                                                    02    - Bloqueio de Enderecamento do WMS
                                                                    03    - Bloqueio de WMS - Externo
                                                                    05    - Liberacao para Bloqueio 01
                                                                    06    - Liberacao para Bloqueio 02
                                                                    07    - Liberacao para Bloqueio 03
                                                                /*/    
ENDWSSTRUCT

WSSTRUCT tAddPedidoDet
    WSDATA ProdutoPedido            AS String     //C6_PRODUTO
    WSDATA QuantidadeProduto        AS Integer    //C6_QTDVEN
ENDWSSTRUCT

WSSTRUCT tAddPedidoCab
    WSDATA CondicaoPagamento        AS String    //C5_CONDPAG
    WSDATA TransportadoraCliente    AS String    //C5_TRANSP
    WSDATA tzItensDoPedido            AS Array Of tAddPedidoDet
ENDWSSTRUCT
           
WSSTRUCT tGetPedidoDet
    WSDATA Armazem                    AS String    //C6_LOCAL
    WSDATA Bloqueio                    AS String    //C6_BLQ
    WSDATA DataUltimoFaturamento    AS Date        //C6_DATFAT
    WSDATA DescricaoProduto            AS String    //C6_DESCRI
    WSDATA CFOP                        AS String    //C6_CF
    WSDATA ItemPedido                AS String    //C6_ITEM
    WSDATA NotaFiscal                AS String    //C6_NOTA
    WSDATA PrecoVendaProduto        AS Float    //C6_PRCVEN
    WSDATA ProdutoPedido            AS String    //C6_PRODUTO
    WSDATA QuantidadeEntregue        AS Integer    //C6_QTDENT
    WSDATA QuantidadeLiberada        AS Integer    //C6_QTDLIB
    WSDATA QuantidadeProduto        AS Integer    //C6_QTDVEN
    WSDATA SerieNF                    AS String    //C6_SERIE
    WSDATA TipoDeEntradaSaida        AS String    //C6_TES
    WSDATA UnidadeMedida            AS String    //C6_UM
    WSDATA tzStatusPedido            AS tStatusPedido OPTIONAL
    WSDATA ValorTotalDoProduto        AS Float    //C6_VALOR
ENDWSSTRUCT

WSSTRUCT tGetPedidoCab
    WSDATA NumPedidoVenda            AS String    //C5_NUM
    WSDATA TipoDePedido                AS String    //C5_TIPO
    WSDATA CodCliente                AS String    //C5_CLIENTE
    WSDATA CodLojaCliente            AS String    //C5_LOJACLI
    WSDATA CodClienteEntrega        AS String    //C5_CLIENT
    WSDATA CodLojaEntrega            AS String    //C5_LOJAENT
    WSDATA CondicaoPagamento        AS String    //C5_CONDPAG
    WSDATA EmissaoPedido            AS Date        //C5_EMISSAO
    WSDATA IssIncluidoPreco            AS String    //C5_INCISS
    WSDATA MoedaDoPedido            AS Integer    //C5_MOEDA
    WSDATA NomeDoCliente            AS String    //C5_NOMECLI
    WSDATA TipoDeCliente            AS String    //C5_TIPOCLI
    WSDATA TipoDeFrete                AS String    //C5_TPFRETE
    WSDATA TipoDeLiberacaoPedido    AS String    //C5_TIPLIB
    WSDATA TransportadoraCliente    AS String    //C5_TRANSP
    WSDATA tzItensDoPedido            AS Array Of tGetPedidoDet
    WSDATA tzValorTotalDoPedido        AS Float
ENDWSSTRUCT

WSSERVICE uMATA410 DESCRIPTION STR0001 NAMESPACE "http://www.blacktdn.com.br"  //"Serviço de consulta e atualização dos pedidos de venda"

    WSDATA CNPJ                     AS String
    WSDATA dIniConsulta                AS Date OPTIONAL
    WSDATA dFimConsulta                AS Date OPTIONAL
    WSDATA NumeroDoPedido            AS String
    WSDATA tAddPedido                AS tAddPedidoCab
    WSDATA tGetPedido                AS tGetPedidoCab
    WSDATA tGetPedidoKey            AS Array OF tGetPedidoCab
    WSDATA WsStrDel                    AS String

    WSMETHOD AddPedidoPeca            DESCRIPTION STR0002    //"Método de inclusão do pedido de venda"
    WSMETHOD DelPedidoPeca            DESCRIPTION STR0003    //"Método de exclusão do pedido de venda"
     WSMETHOD GetPedidoPeca            DESCRIPTION STR0004    //"Método de Consulta ao pedido de venda"
    WSMETHOD GetPedidoKeyPeca        DESCRIPTION STR0005    //"Método de Consulta a Lista de pedido(s) de venda(s) Por Período e CNPJ"

ENDWSSERVICE

WSMETHOD AddPedidoPeca WSRECEIVE CNPJ, tAddPedido WSSEND NumeroDoPedido WSSERVICE uMATA410

    Local aCab                := Array(0)    
    Local aItens            := Array(0)    
    Local aErros             := Array(0)    
    
    Local cStrErro             := ""    
    Local cSC5Filial        := ""
    Local cSA1Filial        := ""
    Local cNumPedido        := NIL
    Local cLojaCliente        := ""
    Local cCodigoCliente    := ""
    Local cTipoCliente        := ""
    
    Local lReturn            := .T.    
    
    Local nErro                := 0    
    Local nErros            := 0
    Local lAddNew            := .T.
    
    PRIVATE lMsErroAuto        := .F.    
    PRIVATE lAutoErrNoFile    := .T.    
    
    BEGIN SEQUENCE
        
        IF Empty(::CNPJ)
            lReturn := .F.
            SetSoapFault( ProcName() , STR0006 ) //"Cliente invÁlido"
            BREAK
        EndIF
        
        ::CNPJ                 := UnMaskCNPJ( ::CNPJ )
        
        cSA1Filial            := xFilial( "SA1" )
        
        SA1->( dbSetOrder( RetOrder( "SA1" , "A1_FILIAL+A1_CGC" ) ) )
        IF SA1->( .NOT.( dbSeek( cSA1Filial + ::CNPJ , .F. ) ) )
            lReturn := .F.
            SetSoapFault( ProcName() , STR0007 + " " + cSA1Filial + TransForm( ::CNPJ , GetSx3Cache( "A1_CGC" , "X3_PICTURE" ) )  ) //"CNPJ invÁlido"
            BREAK
        EndIF
    
        SA1->( dbSetOrder( RetOrder( "SA1" , "A1_FILIAL+A1_COD+A1_LOJA" ) ) )
    
        cLojaCliente        := SA1->A1_LOJA
        cCodigoCliente        := SA1->A1_COD
        cTipoCliente        := SA1->A1_TIPO    
    
        SC5->( dbSetOrder( RetOrder( "SC5" , "C5_FILIAL+C5_NUM" ) ) )
    
        cSC5Filial    := xFilial( "SC5" )
        cNumPedido    := ::tGetPedido:NumPedidoVenda
        
        IF .NOT.( Empty( cNumPedido ) )
            SC5->( dbSetOrder( RetOrder( "SC5" , "C5_FILIAL+C5_NUM" ) ) )
            lAddNew := SC5->(.NOT.(dbSeek(cSC5Filial+cNumPedido,.F.)))
        EndIF

        IF ( lAddNew )
            cNumPedido    := NIL
            SC5->(dbGoto(0))
        EndIF    
        
        lReturn := PutPvHeader(::tAddPedido,@aCab,@cCodigoCliente,@cLojaCliente,@cTipoCliente,@cNumPedido)
        IF .NOT.( lReturn )
            SetSoapFault( ProcName() , STR0008 ) //"Problema no Cabeçalho do Pedido"
            BREAK
        EndIF
    
        lReturn := PutPvItem(@::tAddPedido,@::tAddPedido:tzItensDoPedido,@aItens)
        IF .NOT.( lReturn )
            SetSoapFault( ProcName() , STR0009 ) //"Problema nos Itens do Pedido"
            BREAK
        EndIF
    
        MATA410(@aCab,@aItens,IF(lAddNew,3,4))
    
        IF ( lMsErroAuto )
            aErros     := GetAutoGRLog()
            nErros    := Len( aErros )
            For nErro := 1 To nErros
                cStrErro += ( aErros[ nErro ] + __cCRLF )
            Next nErros
            SetSoapFault( ProcName() , cStrErro )
            lReturn := .F.
            BREAK
        EndIF
    
        ::NumeroDoPedido := SC5->C5_NUM
    
    END SEQUENCE

Return( lReturn )

Static Function PutPvHeader(oObj,aCab,cCodigoCliente,cLojaCliente,cTipoCliente,cNumPedido)

    Local lReturn    := .T.
    
    aAdd( aCab , { "C5_NUM"        , cNumPedido                    , NIL } )
    aAdd( aCab , { "C5_EMISSAO"    , dDataBase                        , NIL } )
    aAdd( aCab , { "C5_TIPO"    , "N"                            , NIL } )
    aAdd( aCab , { "C5_CLIENTE"    , cCodigoCliente                , NIL } )
    aAdd( aCab , { "C5_LOJACLI"    , cLojaCliente                    , NIL } )
    aAdd( aCab , { "C5_CLIENT"    , cCodigoCliente                , NIL } )
    aAdd( aCab , { "C5_LOJAENT"    , cLojaCliente                      , NIL } )
    aAdd( aCab , { "C5_TRANSP"    , oObj:TransportadoraCliente    , NIL } )
    aAdd( aCab , { "C5_TIPOCLI"    , cTipoCliente                    , NIL } )
    aAdd( aCab , { "C5_CONDPAG"    , oObj:CondicaoPagamento        , NIL } )    
    
    SA1->( dbSetOrder( RetOrder( "SA1" , "A1_FILIAL+A1_COD+A1_LOJA" ) ) )
    IF SA1->( dbSeek( xFilial( "SA1" ) + cCodigoCliente + cLojaCliente , .F. ) )
        IF .NOT.Empty( SA1->A1_TABELA )
             aAdd( aCab , { "C5_TABELA" , SA1->A1_TABELA , NIL } )
        Else
            aAdd( aCab , { "C5_TABELA" , NIL             , NIL } )
        EndIF
        IF .NOT.(Empty(SA1->A1_DESC))
            aAdd( aCab , { "C5_DESC1"    , SA1->A1_DESC  , NIL } )
        Else
            aAdd( aCab , { "C5_DESC1"    , 0                , NIL } )
        EndIF    
    EndIF    
    
    aAdd( aCab , { "C5_DESC2"    , 0     , NIL } )
    aAdd( aCab , { "C5_DESC3"    , 0     , NIL } )
    aAdd( aCab , { "C5_DESC4"    , 0     , NIL } )
    aAdd( aCab , { "C5_DESCONT"    , 0     , NIL } )
    aAdd( aCab , { "C5_PDESCAB"    , 0     , NIL } )
    aAdd( aCab , { "C5_BANCO"    , NIL     , NIL } )
    aAdd( aCab , { "C5_DESCFI"    , 0     , NIL } )
    aAdd( aCab , { "C5_ACRSFIN"    , 0     , NIL } )
    aAdd( aCab , { "C5_COTACAO"    , NIL     , NIL } )
    aAdd( aCab , { "C5_TPFRETE"    , "F"     , NIL } )
    aAdd( aCab , { "C5_FRETE"    , NIL     , NIL } )
    aAdd( aCab , { "C5_SEGURO"    , NIL     , NIL } )                   
    aAdd( aCab , { "C5_DESPESA"    , NIL     , NIL } )
    aAdd( aCab , { "C5_FRETAUT"    , NIL     , NIL } )
    aAdd( aCab , { "C5_REAJUST"    , NIL     , NIL } )
    aAdd( aCab , { "C5_MOEDA"    , 1     , NIL } )
    aAdd( aCab , { "C5_PESOL"    , NIL     , NIL } )
    aAdd( aCab , { "C5_PBRUTO"    , NIL     , NIL } )
    aAdd( aCab , { "C5_REDESP"    , ""     , NIL } )
    aAdd( aCab , { "C5_MENNOTA"    , NIL     , NIL } )
    aAdd( aCab , { "C5_MENPAD"    , NIL     , NIL } )
    aAdd( aCab , { "C5_INCISS"    , "N"     , NIL } )
    aAdd( aCab , { "C5_TIPLIB"    , "1"     , NIL } )
    
    aAdd( aCab , { "C5_X_CTCLI" , "IMP"    , NIL } ) 
    aAdd( aCab , { "C5_TIPPROD" , "8"    , NIL } ) 
    aAdd( aCab , { "C5_GARANTI" , "N"   , NIL } ) 
    
    aCab := WsAutoOpc( aCab )
    
Return( lReturn )

Static Function PutPvItem(oObjSC5,oObjSC6,aItens)

    Local aItem          := Array(0)                
    
    Local cItemSeq        := Replicate("0",GetSx3Cache("C6_ITEM","X3_TAMANHO"))
    
    Local lReturn       := .T.
    
    Local nItem            := 0
    Local nItens        := 0
    
    nItens := Len( oObjSC6 )
    For nItem := 1 To nItens
    
        aSize(aItem,0)

        cItemSeq := IF(Empty(oObjSC6[nItem]:ItemPedido),__Soma1(cItemSeq),oObjSC6[nItem]:ItemPedido)
    
        aAdd( aItem , { "C6_ITEM"        , cItemSeq                                        , NIL } )
        aAdd( aItem , { "C6_PRODUTO"    , oObjSC6[nItem]:ProdutoPedido                    , NIL } )
        aAdd( aItem , { "C6_UM"            , NIL                                            , NIL } )
        aAdd( aItem , { "C6_SEGUM"        , NIL                                            , NIL } )
        aAdd( aItem , { "C6_QTDVEN"        , oObjSC6[nItem]:QuantidadeProduto                , NIL } )
        aAdd( aItem , { "C6_UNSVEN"        , NIL                                            , NIL } )
        aAdd( aItem , { "C6_PRUNIT"        , NIL                                            , NIL } )
        aAdd( aItem , { "C6_PRCVEN"        , NIL                                            , NIL } )
        aAdd( aItem , { "C6_VALOR"        , NIL                                            , NIL } )
        aAdd( aItem , { "C6_QTDLIB"        , NIL                                            , NIL } )
        aAdd( aItem , { "C6_QTDLIB2"    , NIL                                            , NIL } )
        aAdd( aItem , { "C6_OPER"        , NIL                                            , NIL } )
        aAdd( aItem , { "C6_CF"            , NIL                                               , NIL } )
        aAdd( aItem , { "C6_LOCAL"        , NIL                                            , NIL } )
        aAdd( aItem , { "C6_DESCONT"    , NIL                                            , NIL } )
        aAdd( aItem , { "C6_VALDESC"    , NIL                                            , NIL } )
        aAdd( aItem , { "C6_ENTREG"        , NIL                                            , NIL } )
        aAdd( aItem , { "C6_PEDCLI"        , NIL                                            , NIL } )
        aAdd( aItem , { "C6_DESCRI"        , NIL                                            , NIL } )
        aAdd( aItem , { "C6_NFORI"        , NIL                                            , NIL } )
        aAdd( aItem , { "C6_SERIORI"    , NIL                                            , NIL } )
        aAdd( aItem , { "C6_ITEMORI"    , NIL                                            , NIL } )
        aAdd( aItem , { "C6_LOTECTL"    , NIL                                            , NIL } )
        aAdd( aItem , { "C6_NUMLOTE"    , NIL                                            , NIL } )
        aAdd( aItem , { "C6_LOCALIZ"    , NIL                                            , NIL } )
        aAdd( aItem , { "C6_NUMSERI"    , NIL                                            , NIL } )
        aAdd( aItem , { "C6_CODFAB"        , NIL                                            , NIL } )
        aAdd( aItem , { "C6_LOJAFA"        , NIL                                            , NIL } )  
        aAdd( aItem , { "C6_X_TPOP"        , "001"                                            , NIL } )
        aAdd( aItem , { "C6_CLASFIS"    , "110"                                            , NIL } )
        aAdd( aItem , { "C6_CHASSI"        , "CERAMICA"                                    , NIL } )
    
        aItem := WsAutoOpc( aItem , .T. )
        aAdd( aItens , aClone( aItem ) )
    
    Next nItem

Return ( lReturn )

WSMETHOD DelPedidoPeca WSRECEIVE CNPJ, NumeroDoPedido WSSEND WsStrDel WSSERVICE uMATA410

    Local aCab                := Array(0)
    Local aItens            := Array(0)
    Local aErros            := Array(0)
    
    Local cStrErro          := ""
    Local cSA1Filial        := ""
    
    Local lReturn            := .T.
    
    Local nErro             := 0
    Local nErros            := 0
    
    PRIVATE lMsErroAuto    := .F.
    PRIVATE lAutoErrNoFile := .T.
    
    BEGIN SEQUENCE
    
        IF Empty(::CNPJ)
            lReturn := .F.
            SetSoapFault( ProcName() , STR0006 ) //""Cliente invÁlido"
            BREAK
        EndIF
    
        ::CNPJ                 := UnMaskCNPJ( ::CNPJ )
        cSA1Filial            := xFilial( "SA1" )
        
        SA1->( dbSetOrder( RetOrder( "SA1" , "A1_FILIAL+A1_CGC" ) ) )
        IF SA1->( .NOT.(dbSeek( cSA1Filial + ::CNPJ , .F. ) ) )
            lReturn := .F.
            SetSoapFault( ProcName() , STR0007 + " " + cSA1Filial + TransForm( ::CNPJ , GetSx3Cache( "A1_CGC" , "X3_PICTURE" ) )  ) //"CNPJ invÁlido"
            BREAK
        EndIF
    
        aAdd( aCab , { "C5_NUM" , ::NumeroDoPedido , NIL } )
    
        MATA410(@aCab,@aItens,5)
        IF ( lMsErroAuto )
            aErros    := GetAutoGRLog()
            nErros    := Len( aErros )
            For nErro := 1 To nErros
                cStrErro += ( aErros[nErro] + __cCRLF )
            Next nErro
            SetSoapFault( ProcName() ,  cStrErro )
            lReturn := .F.
            BREAK
        EndIF
        
        SC5->( dbSetOrder( RetOrder( "SC5" , "C5_FILIAL+C5_NUM" ) ) )
        IF SC5->( dbSeek( xFilial( "SC5" ) + ::NumeroDoPedido , .F. ) )
            lReturn := .F.
            BREAK
        EndIF
        
        ::WsStrDel := STR0011 + ::NumeroDoPedido                                                 //"O Pedido de número: "
        ::WsStrDel += " " 
        ::WsStrDel += STR0012 + TransForm( ::CNPJ , GetSx3Cache( "A1_CGC" , "X3_PICTURE" ) )    //"Da Empresa CNPJ/CGC : "
        ::WsStrDel += " " 
        ::WsStrDel += STR0013                        //"Foi excluido com sucesso"
    
    END SEQUENCE

Return( lReturn )

WSMETHOD GetPedidoPeca WSRECEIVE CNPJ,NumeroDoPedido WSSEND tGetPedido WSSERVICE uMATA410

    Local cLoja
    Local cCliente
    
    Local cSC5Alias     := "SC5"
    Local cSC6Alias     := "SC6"
    Local cSC5Filial    := ""
    Local cSC6Filial    := ""
    Local cSC9Filial    := ""
    Local cSA1Filial    := ""
    Local cNumPedido    := ::NumeroDoPedido
    
    Local lReturn        := .T.
    
    Local nItem            := 0
    
    #IFDEF TOP
        Local lSC6Query    := .F.
    #ENDIF
    
    cSC5Filial            := xFilial( "SC5" )
    cSC6Filial            := xFilial( "SC6" )
    cSC9Filial            := xFilial( "SC9" )
    cSA1Filial            := xFilial( "SA1" )
    
    BEGIN SEQUENCE
    
        IF Empty(::CNPJ)
            lReturn := .F.
            SetSoapFault( ProcName() , STR0006 ) //""Cliente invÁlido"
            BREAK
        EndIF
    
        ::CNPJ := UnMaskCNPJ( ::CNPJ )
    
        SA1->( dbSetOrder( RetOrder( "SA1" , "A1_FILIAL+A1_CGC" ) ) )
        IF SA1->( .NOT.( dbSeek( cSA1Filial + ::CNPJ , .F. ) ) )
            lReturn := .F.
            SetSoapFault( ProcName() , STR0007 + " " + cSA1Filial + TransForm( ::CNPJ , GetSx3Cache( "A1_CGC" , "X3_PICTURE" ) ) ) //"CNPJ invÁlido"
            BREAK
        EndIF
    
        SA1->( dbSetOrder( RetOrder( "SA1" , "A1_FILIAL+A1_COD+A1_LOJA" ) ) )
    
        cCliente        := SA1->A1_COD 
        cLoja             := SA1->A1_LOJA
    
        IF (;
                Empty( cCliente );
                .and.;
                Empty( cLoja );
            )    
            lReturn := .F.
            SetSoapFault( ProcName() , STR0006 )    //""Cliente invÁlido"
            BREAK
        EndIF
    
        SC5->( dbSetOrder( RetOrder( "SC5" , "C5_FILIAL+C5_NUM" ) ) )
        IF SC5->( .NOT.( dbSeek( cSC5Filial + cNumPedido , .F. ) ) )
            lReturn := .F.
            SetSoapFault( ProcName() , STR0010 )    //"Pedido nao encontrado"
            BREAK
        EndIF
    
        ::tGetPedido     := WsClassNew( "tGetPedidoCab" )
        GetPVHeader( @::tGetPedido , @cSC5Alias )
    
        SC6->( dbSetOrder( RetOrder( "SC6" , "C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO" ) ) )
        #IFDEF TOP
    
            cSC6Alias    := GetNextAlias()
    
            BEGINSQL ALIAS cSC6Alias
                COLUMN C6_DATFAT    AS DATE
                SELECT 
                    SC6.C6_FILIAL,
                    SC6.C6_NUM,
                    SC6.C6_ITEM,
                    SC6.C6_PRODUTO,
                    SC6.C6_DESCRI,
                    SC6.C6_UM,
                    SC6.C6_QTDVEN,
                    SC6.C6_PRCVEN,
                    SC6.C6_VALOR,
                    SC6.C6_TES,
                    SC6.C6_CF,
                    SC6.C6_LOCAL,
                    SC6.C6_QTDLIB,
                    SC6.C6_QTDENT,
                    SC6.C6_SERIE,
                    SC6.C6_NOTA,
                    SC6.C6_DATFAT,
                    SC6.C6_BLQ
                FROM
                    %table:SC6% SC6
                WHERE
                    SC6.%NotDel% AND
                    SC6.C6_FILIAL    = %exp:cSC6Filial% AND
                    SC6.C6_NUM        = %exp:(cNumPedido)%
                ORDER BY
                    SC6.C6_FILIAL,SC6.C6_NUM,SC6.C6_ITEM,SC6.C6_PRODUTO
            ENDSQL
    
            lSC6Query    := ( Select( cSC6Alias ) > 0 )
    
            IF .NOT.( lSC6Query )
                ( cSC6Alias )->( dbSeek( cSC6Filial + cNumPedido , .F. ) )
            EndIF
    
        #ELSE
    
            SC6->( dbSeek( cSC6Filial + cNumPedido , .F. ) )
    
        #ENDIF
    
        ::tGetPedido:tzItensDoPedido        := Array(0)
    
        ::tGetPedido:tzValorTotalDoPedido    := 0
        
        While ( cSC6Alias )->(;
                                .NOT.( Eof() );
                                .and.;
                                ( cSC6Filial == C6_FILIAL );
                                .and.;
                                ( ( cSC5Alias )->C5_NUM == C6_NUM );
                            )    
    
            aAdd( ::tGetPedido:tzItensDoPedido , WSClassNew( "tGetPedidoDet" ) )
            
            GetPVItem( @::tGetPedido:tzItensDoPedido[++nItem] , cSC6Alias )
    
            SC9->( dbSetOrder( RetOrder( "SC9" , "C9_FILIAL+C9_PEDIDO+C9_ITEM" ) ) )
            IF SC9->( dbSeek( cSC9Filial + cNumPedido + ::tGetPedido:tzItensDoPedido[nItem]:ItemPedido , .F. ) )
    
                ::tGetPedido:tzItensDoPedido[nItem]:tzStatusPedido    := WsClassNew( "tStatusPedido" )
    
                Do Case
                    Case Empty( SC9->C9_BLCRED )
                        ::tGetPedido:tzItensDoPedido[nItem]:tzStatusPedido:BloqCredito := STR0014    //"Liberado"
                    Case ( SC9->C9_BLCRED == "01" )                     
                        ::tGetPedido:tzItensDoPedido[nItem]:tzStatusPedido:BloqCredito := STR0015    //"01 - Bloqueio de Credito por Valor"
                    Case ( SC9->C9_BLCRED == "04" )                         
                        ::tGetPedido:tzItensDoPedido[nItem]:tzStatusPedido:BloqCredito := STR0016    //"04 - Vencto do Limite de Credito - Data de Credito Vencida"
                    Case ( SC9->C9_BLCRED == "05" )                         
                        ::tGetPedido:tzItensDoPedido[nItem]:tzStatusPedido:BloqCredito := STR0017    //"05 - Bloqueio de Credito por Estorno"
                    Case ( SC9->C9_BLCRED == "06" )                         
                        ::tGetPedido:tzItensDoPedido[nItem]:tzStatusPedido:BloqCredito := STR0018    //"06 - Bloqueio de Credito por Risco"
                    Case ( SC9->C9_BLCRED == "09" )                         
                        ::tGetPedido:tzItensDoPedido[nItem]:tzStatusPedido:BloqCredito := STR0019    //"09 - Rejeicao de Credito - Regeitado Manualmente"
                    Case ( SC9->C9_BLCRED == "10" )                         
                        ::tGetPedido:tzItensDoPedido[nItem]:tzStatusPedido:BloqCredito := STR0020    //"10 - FATURADO"
                End Case        
                
                Do Case
                    Case Empty( SC9->C9_BLEST )
                        ::tGetPedido:tzItensDoPedido[nItem]:tzStatusPedido:BloqEstoque := STR0021    //"Liberado"
                    Case ( SC9->C9_BLEST == "02" )                     
                        ::tGetPedido:tzItensDoPedido[nItem]:tzStatusPedido:BloqEstoque := STR0022    // "02 - Bloqueio de Estoque"
                    Case ( SC9->C9_BLEST == "03" )                         
                        ::tGetPedido:tzItensDoPedido[nItem]:tzStatusPedido:BloqEstoque := STR0023    // "03 - Bloqueio Manual de Estoque"
                    Case ( SC9->C9_BLEST == "10" )                         
                        ::tGetPedido:tzItensDoPedido[nItem]:tzStatusPedido:BloqEstoque := STR0024    // "10 - FATURADO"
                End Case        
                
                Do Case
                    Case ( SC9->C9_BLEST == "01" )
                        ::tGetPedido:tzItensDoPedido[nItem]:tzStatusPedido:BloqueioWMS := STR0025    //"01 - Bloqueio de Enderecamento do WMS/Somente SB2"
                    Case ( SC9->C9_BLEST == "02" )
                        ::tGetPedido:tzItensDoPedido[nItem]:tzStatusPedido:BloqueioWMS := STR0026    //"02 - Bloqueio de Enderecamento do WMS"
                    Case ( SC9->C9_BLEST == "03" )                         
                        ::tGetPedido:tzItensDoPedido[nItem]:tzStatusPedido:BloqueioWMS := STR0027    //"03 - Bloqueio de WMS - Externo"
                    Case ( SC9->C9_BLEST == "05" )                         
                        ::tGetPedido:tzItensDoPedido[nItem]:tzStatusPedido:BloqueioWMS := STR0028    //"05 - Liberacao para Bloqueio 01"
                    Case ( SC9->C9_BLEST == "06" )                         
                        ::tGetPedido:tzItensDoPedido[nItem]:tzStatusPedido:BloqueioWMS := STR0029    //"06 - Liberacao para Bloqueio 02"
                    Case ( SC9->C9_BLEST == "07" )                         
                        ::tGetPedido:tzItensDoPedido[nItem]:tzStatusPedido:BloqueioWMS := STR0030    //"07 - Liberacao para Bloqueio 03"
                End Case        
            
            EndIF
            
            ::tGetPedido:tzValorTotalDoPedido += ::tGetPedido:tzItensDoPedido[nItem]:ValorTotalDoProduto
    
            ( cSC6Alias )->( dbSkip() )
    
        End While
    
        #IFDEF TOP
            IF ( lSC6Query )
                IF ( Select( cSC6Alias ) > 0 )
                    ( cSC6Alias )->( dbCloseArea() )
                EndIF
                dbSelectArea( "SC6" )
            EndIF
        #ENDIF    
    
    END SEQUENCE
    
Return( lReturn )

Static Function GetPVHeader( oObj , cSC5Alias )

    oObj:NumPedidoVenda            := (cSC5Alias)->C5_NUM
    oObj:TipoDePedido            := (cSC5Alias)->C5_TIPO
    oObj:CodCliente                := (cSC5Alias)->C5_CLIENTE
    oObj:CodLojaCliente            := (cSC5Alias)->C5_LOJACLI
    oObj:CodClienteEntrega        := (cSC5Alias)->C5_CLIENT
    oObj:CodLojaEntrega            := (cSC5Alias)->C5_LOJAENT
    oObj:NomeDoCliente            := (cSC5Alias)->C5_NOMECLI
    oObj:TransportadoraCliente    := (cSC5Alias)->C5_TRANSP
    oObj:TipoDeCliente            := (cSC5Alias)->C5_TIPOCLI
    oObj:CondicaoPagamento        := (cSC5Alias)->C5_CONDPAG
    oObj:EmissaoPedido            := (cSC5Alias)->C5_EMISSAO
    oObj:TipoDeFrete            := (cSC5Alias)->C5_TPFRETE
    oObj:MoedaDoPedido            := (cSC5Alias)->C5_MOEDA
    oObj:IssIncluidoPreco        := (cSC5Alias)->C5_INCISS
    oObj:TipoDeLiberacaoPedido    := (cSC5Alias)->C5_TIPLIB
    
Return( .T. )

Static Function GetPVItem( oObj , cSC6Alias )

    oObj:ItemPedido                := ( cSC6Alias )->C6_ITEM
    oObj:ProdutoPedido            := ( cSC6Alias )->C6_PRODUTO
    oObj:DescricaoProduto        := ( cSC6Alias )->C6_DESCRI
    oObj:UnidadeMedida            := ( cSC6Alias )->C6_UM
    oObj:QuantidadeProduto        := ( cSC6Alias )->C6_QTDVEN
    oObj:PrecoVendaProduto        := ( cSC6Alias )->C6_PRCVEN
    oObj:ValorTotalDoProduto    := ( cSC6Alias )->C6_VALOR
    oObj:TipoDeEntradaSaida        := ( cSC6Alias )->C6_TES
    oObj:CFOP                    := ( cSC6Alias )->C6_CF
    oObj:Armazem                := ( cSC6Alias )->C6_LOCAL
    oObj:QuantidadeLiberada        := ( cSC6Alias )->C6_QTDLIB
    oObj:QuantidadeEntregue        := ( cSC6Alias )->C6_QTDENT
    oObj:SerieNF                := ( cSC6Alias )->C6_SERIE
    oObj:NotaFiscal                := ( cSC6Alias )->C6_NOTA
    oObj:DataUltimoFaturamento    := ( cSC6Alias )->C6_DATFAT
    oObj:Bloqueio                := ( cSC6Alias )->C6_BLQ
    
Return( .T. )

WSMETHOD GetPedidoKeyPeca WSRECEIVE CNPJ, dIniConsulta, dFimConsulta WSSEND tGetPedidoKey WSSERVICE uMATA410
    
    Local cSC5Alias            := "SC5"
    Local cSC6Alias            := "SC6"
    Local cSA1Filial        := ""
    Local cSC5Filial        := ""
    Local cSC6Filial        := ""
    Local cSC9Filial        := ""
    Local cLojaCliente        := ""
    Local cCodigoCliente    := ""
    
    Local dDataAux            := Ctod("//")
    Local dIniConsulta        := Ctod("//")
    Local dFimConsulta        := Ctod("//")
    
    Local lReturn            := .T.
    Local lSetCentury
    
    Local nItemCab            := 0
    Local nItemDet            := 0
    
    #IFDEF TOP
        Local lSC5Query        := .F.
        Local lSC6Query        := .F.
    #ENDIF
    
    SetsDefault()
    lSetCentury                := __SetCentury("on")
    
    cSA1Filial                := xFilial( "SA1" )
    cSC5Filial                := xFilial( "SC5" , cSA1Filial )
    cSC6Filial                := xFilial( "SC6" , cSC5Filial )
    cSC9Filial                := xFilial( "SC9" , cSC6Filial )
    
    BEGIN SEQUENCE
    
        DEFAULT ::dIniConsulta    := FirstDay( dDataBase )
        DEFAULT ::dFimConsulta    := LastDay( dDataBase )
    
        dIniConsulta            := ::dIniConsulta
        dFimConsulta            := ::dFimConsulta
    
        IF (;
                .NOT.( ValType( dIniConsulta ) ==  "D" );
                .or.;
                Empty( dIniConsulta );
            )
            dIniConsulta := FirstDay( dDataBase )
        EndIF        
    
        IF (;
                .NOT.( ValType( dFimConsulta ) ==  "D" );
                .or.;
                Empty( dFimConsulta );
            )
            dFimConsulta := LastDay( dDataBase )
        EndIF
        
        IF ( dFimConsulta < dIniConsulta )
            dDataAux         := dIniConsulta
            dIniConsulta    := dFimConsulta
            dFimConsulta    := dDataAux
        EndIF
    
        IF Empty(::CNPJ)
            lReturn := .F.
            SetSoapFault( ProcName() , STR0006 ) //""Cliente invÁlido"
            BREAK
        EndIF
    
        ::CNPJ := UnMaskCNPJ( ::CNPJ )
    
        SA1->( dbSetOrder( RetOrder( "SA1" , "A1_FILIAL+A1_CGC" ) ) )
        IF SA1->( .NOT.( dbSeek( cSA1Filial + ::CNPJ , .F. ) ) )
            lReturn := .F.
            SetSoapFault( ProcName() , STR0007 + " " + cSA1Filial + TransForm( ::CNPJ , GetSx3Cache( "A1_CGC" , "X3_PICTURE" ) ) ) //"CNPJ invÁlido"
            BREAK
        EndIF
    
        cLojaCliente    := SA1->A1_LOJA
        cCodigoCliente    := SA1->A1_COD 
    
        SC5->( dbSetOrder( RetOrder( "SC5" , "C5_FILIAL+C5_CLIENTE+C5_LOJACLI+C5_NUM" ) ) )
    
        #IFDEF TOP
    
            cSC5Alias    := GetNextAlias()
    
            BEGINSQL ALIAS cSC5Alias
                COLUMN C5_EMISSAO    AS DATE    
                SELECT 
                    SC5.C5_FILIAL,
                    SC5.C5_NUM,
                    SC5.C5_TIPO,
                    SC5.C5_CLIENTE,
                    SC5.C5_CLIENTE,
                    SC5.C5_LOJACLI,
                    SC5.C5_CLIENT,
                    SC5.C5_LOJAENT,
                    SC5.C5_CONDPAG,
                    SC5.C5_EMISSAO,
                    SC5.C5_INCISS,
                    SC5.C5_MOEDA,
                    SC5.C5_NOMECLI,
                    SC5.C5_TIPOCLI,
                    SC5.C5_TPFRETE,
                    SC5.C5_TIPLIB,
                    SC5.C5_TRANSP
                FROM
                    %table:SC5% SC5
                WHERE
                    SC5.%NotDel% AND
                    SC5.C5_FILIAL    = %exp:cSC5Filial% AND
                    SC5.C5_CLIENTE    = %exp:cCodigoCliente% AND
                    SC5.C5_LOJACLI    = %exp:cLojaCliente% AND
                    SC5.C5_EMISSAO    >= %exp:Dtos(dIniConsulta)% AND
                    SC5.C5_EMISSAO    <= %exp:Dtos(dFimConsulta)%
                ORDER BY
                    SC5.C5_FILIAL,SC5.C5_CLIENTE,SC5.C5_LOJACLI,SC5.C5_NUM
            ENDSQL
            
            lSC5Query    := ( Select( cSC5Alias ) > 0 )
    
            IF .NOT.( lSC5Query )
                ( cSC5Alias )->( dbSeek( cSC5Filial + cCodigoCliente + cLojaCliente , .F. ) )
            EndIF
        
        #ELSE
    
            ( cSC5Alias )->( dbSeek( cSC5Filial + cCodigoCliente + cLojaCliente , .F. ) )
    
        #ENDIF
    
        ::tGetPedidoKey    := Array(0)
    
        While ( cSC5Alias )->(;
                                    .NOT.( Eof() );
                                    .and.;
                                    ( C5_FILIAL == cSC5Filial );
                                    .and.;
                                    ( C5_CLIENTE == cCodigoCliente );
                                    .and.;
                                    ( C5_LOJACLI == cLojaCliente );
                                )    
    
            #IFDEF TOP
                IF .NOT.( lSC5Query )        
                    IF ( cSC5Alias )->( C5_EMISSAO < dIniConsulta .or. C5_EMISSAO > dFimConsulta )
                        ( cSC5Alias )->( dbSkip() )
                        Loop
                    EndIF
                EndIF    
            #ELSE
                IF ( cSC5Alias )->( C5_EMISSAO < dIniConsulta .or. C5_EMISSAO > dFimConsulta )
                    ( cSC5Alias )->( dbSkip() )
                    Loop
                EndIF
            #ENDIF    
    
            aAdd( ::tGetPedidoKey , WsClassNew( "tGetPedidoCab" ) )
    
            GetPVHeader( @::tGetPedidoKey[++nItemCab] , @cSC5Alias )
    
            SC6->( dbSetOrder( RetOrder( "SC6" , "C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO" ) ) )
    
            #IFDEF TOP
    
                cSC6Alias    := GetNextAlias()
    
                BEGINSQL ALIAS cSC6Alias
                    COLUMN C6_DATFAT    AS DATE    
                    SELECT 
                        SC6.C6_FILIAL,
                        SC6.C6_NUM,
                        SC6.C6_ITEM,
                        SC6.C6_PRODUTO,
                        SC6.C6_DESCRI,
                        SC6.C6_UM,
                        SC6.C6_QTDVEN,
                        SC6.C6_PRCVEN,
                        SC6.C6_VALOR,
                        SC6.C6_TES,
                        SC6.C6_CF,
                        SC6.C6_LOCAL,
                        SC6.C6_QTDLIB,
                        SC6.C6_QTDENT,
                        SC6.C6_SERIE,
                        SC6.C6_NOTA,
                        SC6.C6_DATFAT,
                        SC6.C6_BLQ
                    FROM
                        %table:SC6% SC6
                    WHERE
                        SC6.%NotDel% AND
                        SC6.C6_FILIAL    = %exp:cSC6Filial% AND
                        SC6.C6_NUM        = %exp:( cSC5Alias )->C5_NUM%
                    ORDER BY
                        SC6.C6_FILIAL,SC6.C6_NUM,SC6.C6_ITEM,SC6.C6_PRODUTO
                ENDSQL
    
                lSC6Query    := ( Select( cSC6Alias ) > 0 )
        
                IF .NOT.( lSC6Query )
                    ( cSC6Alias )->( dbSeek( cSC6Filial + ( cSC5Alias )->C5_NUM , .F. ) )
                EndIF
            
            #ELSE
        
                ( cSC6Alias )->( dbSeek( cSC6Filial + ( cSC5Alias )->C5_NUM , .F. ) )
        
            #ENDIF
    
            ::tGetPedidoKey[nItemCab]:tzItensDoPedido        := Array(0)
        
            ::tGetPedidoKey[nItemCab]:tzValorTotalDoPedido    := 0
            
            nItemDet                                        := 0
    
            While ( cSC6Alias )->(;
                                    .NOT.( Eof() );
                                    .and.;
                                    ( cSC6Filial == C6_FILIAL );
                                    .and.;
                                    ( ( cSC5Alias )->C5_NUM == C6_NUM );
                                )    
        
                aAdd( ::tGetPedidoKey[nItemCab]:tzItensDoPedido , WSClassNew( "tGetPedidoDet" ) )
                
                GetPVItem( @::tGetPedidoKey[nItemCab]:tzItensDoPedido[++nItemDet] , cSC6Alias )
        
                SC9->( dbSetOrder( RetOrder( "SC9" , "C9_FILIAL+C9_PEDIDO+C9_ITEM" ) ) )
                IF SC9->( dbSeek( cSC9Filial + ( cSC5Alias )->C5_NUM + ::tGetPedidoKey[nItemCab]:tzItensDoPedido[nItemDet]:ItemPedido , .F. ) )
        
                    ::tGetPedidoKey[nItemCab]:tzItensDoPedido[nItemDet]:tzStatusPedido    := WsClassNew( "tStatusPedido" )
        
                    Do Case
                        Case Empty( SC9->C9_BLCRED )
                            ::tGetPedidoKey[nItemCab]:tzItensDoPedido[nItemDet]:tzStatusPedido:BloqCredito := STR0014    //"Liberado"
                        Case ( SC9->C9_BLCRED == "01" )                     
                            ::tGetPedidoKey[nItemCab]:tzItensDoPedido[nItemDet]:tzStatusPedido:BloqCredito := STR0015    //"01 - Bloqueio de Credito por Valor"
                        Case ( SC9->C9_BLCRED == "04" )                         
                            ::tGetPedidoKey[nItemCab]:tzItensDoPedido[nItemDet]:tzStatusPedido:BloqCredito := STR0016    //"04 - Vencto do Limite de Credito - Data de Credito Vencida"
                        Case ( SC9->C9_BLCRED == "05" )                         
                            ::tGetPedidoKey[nItemCab]:tzItensDoPedido[nItemDet]:tzStatusPedido:BloqCredito := STR0017    //"05 - Bloqueio de Credito por Estorno"
                        Case ( SC9->C9_BLCRED == "06" )                         
                            ::tGetPedidoKey[nItemCab]:tzItensDoPedido[nItemDet]:tzStatusPedido:BloqCredito := STR0018    //"06 - Bloqueio de Credito por Risco"
                        Case ( SC9->C9_BLCRED == "09" )                         
                            ::tGetPedidoKey[nItemCab]:tzItensDoPedido[nItemDet]:tzStatusPedido:BloqCredito := STR0019    //"09 - Rejeicao de Credito - Regeitado Manualmente"
                        Case ( SC9->C9_BLCRED == "10" )                         
                            ::tGetPedidoKey[nItemCab]:tzItensDoPedido[nItemDet]:tzStatusPedido:BloqCredito := STR0020    //"10 - FATURADO"
                    End Case        
                    
                    Do Case
                        Case Empty( SC9->C9_BLEST )
                            ::tGetPedidoKey[nItemCab]:tzItensDoPedido[nItemDet]:tzStatusPedido:BloqEstoque := STR0021    //"Liberado"
                        Case ( SC9->C9_BLEST == "02" )                     
                            ::tGetPedidoKey[nItemCab]:tzItensDoPedido[nItemDet]:tzStatusPedido:BloqEstoque := STR0022    // "02 - Bloqueio de Estoque"
                        Case ( SC9->C9_BLEST == "03" )                         
                            ::tGetPedidoKey[nItemCab]:tzItensDoPedido[nItemDet]:tzStatusPedido:BloqEstoque := STR0023    // "03 - Bloqueio Manual de Estoque"
                        Case ( SC9->C9_BLEST == "10" )                         
                            ::tGetPedidoKey[nItemCab]:tzItensDoPedido[nItemDet]:tzStatusPedido:BloqEstoque := STR0024    // "10 - FATURADO"
                    End Case        
                    
                    Do Case
                        Case ( SC9->C9_BLEST == "01" )
                            ::tGetPedidoKey[nItemCab]:tzItensDoPedido[nItemDet]:tzStatusPedido:BloqueioWMS := STR0025    //"01 - Bloqueio de Enderecamento do WMS/Somente SB2"
                        Case ( SC9->C9_BLEST == "02" )
                            ::tGetPedidoKey[nItemCab]:tzItensDoPedido[nItemDet]:tzStatusPedido:BloqueioWMS := STR0026    //"02 - Bloqueio de Enderecamento do WMS"
                        Case ( SC9->C9_BLEST == "03" )                         
                            ::tGetPedidoKey[nItemCab]:tzItensDoPedido[nItemDet]:tzStatusPedido:BloqueioWMS := STR0027    //"03 - Bloqueio de WMS - Externo"
                        Case ( SC9->C9_BLEST == "05" )                         
                            ::tGetPedidoKey[nItemCab]:tzItensDoPedido[nItemDet]:tzStatusPedido:BloqueioWMS := STR0028    //"05 - Liberacao para Bloqueio 01"
                        Case ( SC9->C9_BLEST == "06" )                         
                            ::tGetPedidoKey[nItemCab]:tzItensDoPedido[nItemDet]:tzStatusPedido:BloqueioWMS := STR0029    //"06 - Liberacao para Bloqueio 02"
                        Case ( SC9->C9_BLEST == "07" )                         
                            ::tGetPedidoKey[nItemCab]:tzItensDoPedido[nItemDet]:tzStatusPedido:BloqueioWMS := STR0030    //"07 - Liberacao para Bloqueio 03"
                    End Case        
                
                EndIF
                
                ::tGetPedidoKey[nItemCab]:tzValorTotalDoPedido += ::tGetPedidoKey[nItemCab]:tzItensDoPedido[nItemDet]:ValorTotalDoProduto
        
                ( cSC6Alias )->( dbSkip() )
        
            End While
        
            #IFDEF TOP
                IF ( lSC6Query )
                    IF ( Select( cSC6Alias ) > 0 )
                        ( cSC6Alias )->( dbCloseArea() )
                    EndIF
                    dbSelectArea( "SC6" )
                EndIF
            #ENDIF    
    
            ( cSC5Alias )->( dbSkip() )
    
        End While
    
        IF ( lSC5Query )
            IF ( Select( cSC5Alias ) > 0 )
                ( cSC5Alias )->( dbCloseArea() )
                dbSelectArea( "SC5" )
            EndIF
        EndIF
    
        IF Empty( ::tGetPedidoKey )
            SetSoapFault( ProcName() ,;
                                                STR0031;    //"Não Existem Pedidos para o Cliente CNPJ: "
                                                +;
                                                TransForm( ::CNPJ , GetSx3Cache( "A1_CGC" , "X3_PICTURE" ) );
                                                +;
                                                " ";
                                                +;
                                                STR0032;    //"No Período Informado: "
                                                +;
                                                Dtoc( dIniConsulta , "DDMMYYYY" );
                                                +;
                                                " - ";
                                                +;
                                                Dtoc( dFimConsulta , "DDMMYYYY" );
                             ) 
            lReturn := .F.
            BREAK
        EndIF
        
    END SEQUENCE
    
    IF .NOT.( lSetCentury )
        __SetCentury("off")
    EndIF

Return( lReturn )

Static Function UnMaskCNPJ( cCNPJ )

    Local cCNPJClear := cCNPJ
    
    BEGIN SEQUENCE
        
        IF Empty( cCNPJClear )
            BREAK
        EndIF
    
        cCNPJClear := StrTran( cCNPJClear , "." , "" )
        cCNPJClear := StrTran( cCNPJClear , "/" , "" )
        cCNPJClear := StrTran( cCNPJClear , "-" , "" )
        
        cCNPJClear := AllTrim( cCNPJClear )
    
    END SEQUENCE
    
Return( cCNPJClear )
