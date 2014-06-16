#include "totvs.ch"
Static __aF3Ret
/*
    Programa    : f3f_Opcoes
    Funcao      : f3fOpcSX5
    Data        : 16/06/2014
    Autor       : Marinaldo de Jesus ( http://www.blacktdn.com.br )
    Descricao   : Programa para retornar Consulta Padrao "Específica" baseada em f_Opcoes
    Uso         : Consulta F3 (%F3SIT) para as situacoes da Folha de Pagamento
    Sintaxe     : StaticCall(F3F_OPCOES,f3fOpcSX5,cTabela,nSize,cF3,cF3Name)
*/
Static Function f3fOpcSX5(cTabela,nSize,cF3,cF3Name)
    
    //------------------------------------------------------------------------------------------------
    // Salva os Dados de Entrada que serao restaurados antes do Retorno do Procedimento
    Local aArea    := GetArea()
    Local aAreaSX5 := SX5->(GetArea())

    Local aOpcoes  := Array(0)

    Local cKey
    Local cDes

    //------------------------------------------------------------------------------------------------
    // Obtem um alias válido par uso
    Local cAlias   := GetNextAlias()

    Local cTitulo  := ""
    Local cOpcoes  := ""

    //------------------------------------------------------------------------------------------------
    // Obtem a Variavel de Memória que será utilizada como Referencia à Consulta
    Local cReadVar := ReadVar()
    
    Local nCnt     := 0
    
    Local nRecno
    Local nF3Ret
    Local nTamKey
    Local nElemRet

    //------------------------------------------------------------------------------------------------
    // Obtem a Ordem para a tabela SX5
    Local nSX5Order := RetOrder("SX5","X5_FILIAL+X5_TABELA+X5_CHAVE")

    Local uVarRet

    //------------------------------------------------------------------------------------------------
    // Obtem o conteúdo do campo utilizado na Consulta Padrao Customizada
    uVarRet := GetMemVar(cReadVar)

    //------------------------------------------------------------------------------------------------
    // Valor padrão para Tamanho do Campo
    DEFAULT nSize := Len(uVarRet)

    //------------------------------------------------------------------------------------------------
    // Obtem o conteúdo do campo utilizado na Consulta Padrao Customizada
    nTamKey    := nSize
    
    //------------------------------------------------------------------------------------------------
    // Verifica o Máximo de Elementos para Retorno/Seleção
    nElemRet    := Int(Len(uVarRet)/nTamKey)
    
    //------------------------------------------------------------------------------------------------
    // Obtem a Descrição, conforme tabela
    SX5->(dbSetOrder(nSX5Order))
    IF SX5->(dbSeek(xFilial("SX5")+"00"+cTabela))
        cTitulo := SX5->(X5Descri())
    EndIF
    
    //------------------------------------------------------------------------------------------------
    // Seleciona os Registros
    BEGINSQL ALIAS cAlias
        COLUMN R_E_C_N_O_ AS NUMERIC(16,0)
        SELECT SX5.R_E_C_N_O_
          FROM %table:SX5% SX5
         WHERE SX5.%notDel%
           AND SX5.X5_FILIAL=%xFilial:SX5%
           AND SX5.X5_TABELA=%exp:cTabela% 
    ENDSQL
    
    //------------------------------------------------------------------------------------------------
    // Obtem a Chave e Descricao
    While (cAlias)->(.NOT.(Eof()))
        nRecno := (cAlias)->R_E_C_N_O_    
        SX5->(dbGoto(nRecno))
        cKey := SX5->(Left(X5_CHAVE,nTamKey))
        cDes := SX5->(Alltrim(X5Descri()))
        aAdd(aOpcoes,cKey+" - "+cDes)
        cOpcoes += cKey
        ++nCnt
        (cAlias)->(dbSkip())
    End While
    
    //------------------------------------------------------------------------------------------------
    // Libera o Alias da Memoria
    (cAlias)->(dbCloseArea())

    //------------------------------------------------------------------------------------------------
    // Redefine o Máximo de Elementos para Retorno/Seleção
    nElemRet    := Min(nCnt,nElemRet)

    //------------------------------------------------------------------------------------------------
    // Executa f_Opcoes para Selecionar ou Mostrar os Registros Selecionados
    IF f_Opcoes(    @uVarRet    ,;    //Variavel de Retorno
                    cTitulo     ,;    //Titulo da Coluna com as opcoes
                    @aOpcoes    ,;    //Opcoes de Escolha (Array de Opcoes)
                    @cOpcoes    ,;    //String de Opcoes para Retorno
                    NIL         ,;    //Nao Utilizado
                    NIL         ,;    //Nao Utilizado
                    .F.         ,;    //Se a Selecao sera de apenas 1 Elemento por vez
                    nTamKey     ,;    //Tamanho da Chave
                    nElemRet    ,;    //No maximo de elementos na variavel de retorno
                    .T.         ,;    //Inclui Botoes para Selecao de Multiplos Itens
                    .F.         ,;    //Se as opcoes serao montadas a partir de ComboBox de Campo ( X3_CBOX )
                    NIL         ,;    //Qual o Campo para a Montagem do aOpcoes
                    .F.         ,;    //Nao Permite a Ordenacao
                    .F.         ,;    //Nao Permite a Pesquisa    
                    .F.         ,;    //Forca o Retorno Como Array
                    cF3          ;    //Consulta F3    
                  )
        //------------------------------------------------------------------------------------------------
        // Atualiza a Variável de Retorno
        cF3Ret    := uVarRet
        //------------------------------------------------------------------------------------------------
        // Atualiza a Variável de Memória com o Conteúdo do Retorno
        SetMemVar(cReadVar,cF3Ret)
        //------------------------------------------------------------------------------------------------
        // Força a atualização dos Componentes (Provavelmente não irá funcionar). A solução. ENTER
        SysRefresh(.T.)
    Else
        //------------------------------------------------------------------------------------------------
        // Se nao confirmou a f_Opcoes retorna o Conteudo de entrada
        cF3Ret    := uVarRet
    EndIF
    
    //------------------------------------------------------------------------------------------------
    // Alimenta a variável Static para uso no Retorno da Consulta Padrao.
    DEFAULT __aF3Ret := Array(0)
    nF3Ret := aScan(__aF3Ret,{|e|e[1]==cF3Name})
    IF (nF3Ret==0)
        aAdd(__aF3Ret,{cF3Name,NIL})
        nF3Ret    := Len(__aF3Ret)
    EndIF
    __aF3Ret[nF3Ret][2] := cF3Ret
    
    //------------------------------------------------------------------------------------------------
    // Restaura os Dados de Entrada
    RestArea(aAreaSX5)
    RestArea(aArea)

Return(cF3Ret)

/*
    Programa    : f3f_Opcoes
    Funcao      : f3fOpcSitF
    Data        : 16/06/2014
    Autor       : Marinaldo de Jesus ( http://www.blacktdn.com.br )
    Descricao   : Programa para retornar Consulta Padrao "Específica" baseada em f_Opcoes
    Uso         : Consulta F3 (%F3SIT) para as situacoes da Folha de Pagamento
    Sintaxe     : StaticCall(F3F_OPCOES,f3fOpcSitF)
*/
Static Function f3fOpcSitF()
Return(f3fOpcSX5("31",1,"31","%F3SIT"))

/*
    Programa    : f3f_Opcoes
    Funcao      : f3fOpcCatF
    Data        : 16/06/2014
    Autor       : Marinaldo de Jesus ( http://www.blacktdn.com.br )
    Descricao   : Programa para retornar Consulta Padrao "Específica" baseada em f_Opcoes
    Uso         : Consulta F3 (%F3CAT) para as Categoria da Folha de Pagamento
    Sintaxe     : StaticCall(F3F_OPCOES,f3fOpcCatF)
*/
Static Function f3fOpcCatF()
Return(f3fOpcSX5("28",1,"28","%F3CAT"))

/*
    Programa    : f3f_Opcoes
    Funcao      : f3fOpcRetD
    Data        : 10/06/2014
    Autor       : Marinaldo de Jesus
    Descricao   : Retornar a ultima opção selecionada na Contulda Customizada
    Uso         : Retorno da Consulta F3
    Sintaxe     : StaticCall(F3F_OPCOES,f3fOpcRetD,cF3Name)
*/
Static Function f3fOpcRetD(cF3Name)
    Local uF3Ret
    Local nF3Ret
    IF(__aF3Ret==NIL)
        __aF3Ret := Array(0)
    EndIF   
    nF3Ret := aScan(__aF3Ret,{|e|e[1]==cF3Name})
    IF (nF3Ret>0)
        cF3Ret    := __aF3Ret[nF3Ret][2]
        aSize(aDel(__aF3Ret,nF3Ret),Len(__aF3Ret)-1)
    Else
        //------------------------------------------------------------------------------------------------
        // TODO : Testar a Falha no Retorno da Consulta.
        uF3Ret    := &(ReadVar())
    EndIF
Return(uF3Ret)