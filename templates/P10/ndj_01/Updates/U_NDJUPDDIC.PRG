#INCLUDE "ndj.ch"

#ifdef SPANISH
        #define STR0001 "Atenção"
        #define STR0002 "Nennuma Empresa Selecionada para UPDATE"
        #define STR0003 "Rotina de Update em uso por outro usuario"
        #define STR0004 "Processo de Atualização do Dicionário de Dados/Tabelas."
        #define STR0005 "Deve ser executado em modo EXCLUSIVO."
        #define STR0006 "Recomenda-se BACKUP dos DICIONÁRIOS e BASE DE DADOS"
        #define STR0007 "Na eventual Falha do Processo de UPDATE recomendamos:"
        #define STR0008 "A RESTAURAÇÃO DO BACKUP"
        #define STR0009 "NDJUPDATE :: ATUALIZAÇÃO DE DICIONÁRIOS E TABELAS"
        #define STR0010 "Gerando o Log"
        #define STR0011 "Processo de Atualização Realizado com Sucesso."
        #define STR0012 "Processo de Atualização Finalizado."
        #define STR0013 "Selecione a(s) Empresa(s) Para o Update"
        #define STR0014 "Processando..." 
        #define STR0015 "Simular o Processo?"
        #define STR0016 "Opções para Update"
        #define STR0017 "Comparando: "
        #define STR0018 " com "
        #define STR0019 "Impossivel obter exclusividade no arquivo : "
        #define STR0020 "Problema na abertura do arquivo "
        #define STR0021 "Selecionando Registros"
        #define STR0021 " com "
        #define STR0022 "Campo não Encontrado: "
        #define STR0023 "Campo: "
        #define STR0024 "Conteudo: "
        #define STR0025 "Alterado o Conteudo do Campo: "   
        #define STR0026 "Nao Alterado o Conteudo do Campo: "
        #define STR0027 " de "          
        #define STR0028 " para "
        #define STR0029 "Chave não Encontrada:"   
        #define STR0030 "Adicionado novo registro na Tabela: "
        #define STR0031 "Aguarde"
        #define STR0032 "Atualizando Tabela(s) de Dados: Empresa "
        #define STR0033 " Filial: "
        #define STR0034 "Problema na abertura do arquivo de Empresa"
        #define STR0035 "Log de Atualização"
        #define STR0036 "Processo de Simulação Realizado com Sucesso."
        #define STR0037 "Processo de Simulação Finalizado."
        #define STR0038 "Simulação"
        #define STR0039 "Aguarde..."
        #define STR0040 "Selecione o arquivo de Configuração de Update"
        #define STR0041     "Aplicar o Update?"
        #define STR0042 "Registro:"
        #define STR0043 "Será"
        #define STR0044 "Foi"
        #define STR0045 "Excluido"
        #define STR0046 "Problema no arquivo de Configuração de Update"
        #define STR0047 "Tabelas com alteração na estrutura"
        #define STR0048 "Processo de Update Cancelado pelo Usuario"
        #define STR0049 "Problema na Criacao do Arquivo de Help"
        #define STR0050 "Problema na Abertura do Arquivo de Help"
        #define STR0051 "Atualizando Helps..."
        #define STR0052 "Problema na Configuração do Arquivo de Help" 
        #define STR0053 "Arquivo "
        #define STR0054 " não encontrado"
#else
    #ifdef ENGLISH
        #define STR0001 "Atenção"
        #define STR0002 "Nennuma Empresa Selecionada para UPDATE"
        #define STR0003 "Rotina de Update em uso por outro usuario"
        #define STR0004 "Processo de Atualização do Dicionário de Dados/Tabelas."
        #define STR0005 "Deve ser executado em modo EXCLUSIVO."
        #define STR0006 "Recomenda-se BACKUP dos DICIONÁRIOS e BASE DE DADOS"
        #define STR0007 "Na eventual Falha do Processo de UPDATE recomendamos:"
        #define STR0008 "A RESTAURAÇÃO DO BACKUP"
        #define STR0009 "NDJUPDATE :: ATUALIZAÇÃO DE DICIONÁRIOS E TABELAS"
        #define STR0010 "Gerando o Log"
        #define STR0011 "Processo de Atualização Realizado com Sucesso."
        #define STR0012 "Processo de Atualização Finalizado."
        #define STR0013 "Selecione a(s) Empresa(s) Para o Update"
        #define STR0014 "Processando..." 
        #define STR0015 "Simular o Processo?"
        #define STR0016 "Opções para Update"
        #define STR0017 "Comparando: "
        #define STR0018 " com "
        #define STR0019 "Impossivel obter exclusividade no arquivo : "
        #define STR0020 "Problema na abertura do arquivo "
        #define STR0021 "Selecionando Registros"
        #define STR0021 " com "
        #define STR0022 "Campo não Encontrado: "
        #define STR0023 "Campo: "
        #define STR0024 "Conteudo: "
        #define STR0025 "Alterado o Conteudo do Campo: "   
        #define STR0026 "Nao Alterado o Conteudo do Campo: "
        #define STR0027 " de "          
        #define STR0028 " para "
        #define STR0029 "Chave não Encontrada:"   
        #define STR0030 "Adicionado novo registro na Tabela: "
        #define STR0031 "Aguarde"
        #define STR0032 "Atualizando Tabela(s) de Dados: Empresa "
        #define STR0033 " Filial: "
        #define STR0034 "Problema na abertura do arquivo de Empresa"
        #define STR0035 "Log de Atualização"
        #define STR0036 "Processo de Simulação Realizado com Sucesso."
        #define STR0037 "Processo de Simulação Finalizado."
        #define STR0038 "Simulação"
        #define STR0039 "Aguarde..."
        #define STR0040 "Selecione o arquivo de Configuração de Update"
        #define STR0041    "Aplicar o Update?"
        #define STR0042 "Registro:"
        #define STR0043 "Será"
        #define STR0044 "Foi"
        #define STR0045 "Excluido"
        #define STR0046 "Problema no arquivo de Configuração de Update"
        #define STR0047 "Tabelas com alteração na estrutura"
        #define STR0048 "Processo de Update Cancelado pelo Usuario"
        #define STR0049 "Problema na Criacao do Arquivo de Help"
        #define STR0050 "Problema na Abertura do Arquivo de Help"
        #define STR0051 "Atualizando Helps..." 
        #define STR0052 "Problema na Configuração do Arquivo de Help" 
        #define STR0053 "Arquivo "
        #define STR0054 " não encontrado"
    #else
        #define STR0001 "Atenção"
        #define STR0002 "Nennuma Empresa Selecionada para UPDATE"
        #define STR0003 "Rotina de Update em uso por outro usuario"
        #define STR0004 "Processo de Atualização do Dicionário de Dados/Tabelas."
        #define STR0005 "Deve ser executado em modo EXCLUSIVO."
        #define STR0006 "Recomenda-se BACKUP dos DICIONÁRIOS e BASE DE DADOS"
        #define STR0007 "Na eventual Falha do Processo de UPDATE recomendamos:"
        #define STR0008 "A RESTAURAÇÃO DO BACKUP"
        #define STR0009 "NDJUPDATE :: ATUALIZAÇÃO DE DICIONÁRIOS E TABELAS"
        #define STR0010 "Gerando o Log"
        #define STR0011 "Processo de Atualização Realizado com Sucesso."
        #define STR0012 "Processo de Atualização Finalizado."
        #define STR0013 "Selecione a(s) Empresa(s) Para o Update"
        #define STR0014 "Processando..." 
        #define STR0015 "Simular o Processo?"
        #define STR0016 "Opções para Update"
        #define STR0017 "Comparando: "
        #define STR0018 " com "
        #define STR0019 "Impossivel obter exclusividade no arquivo : "
        #define STR0020 "Problema na abertura do arquivo "
        #define STR0021 "Selecionando Registros"
        #define STR0021 " com "
        #define STR0022 "Campo não Encontrado: "
        #define STR0023 "Campo: "
        #define STR0024 "Conteudo: "
        #define STR0025 "Alterado o Conteudo do Campo: "   
        #define STR0026 "Nao Alterado o Conteudo do Campo: "
        #define STR0027 " de "          
        #define STR0028 " para "
        #define STR0029 "Chave não Encontrada:"   
        #define STR0030 "Adicionado novo registro na Tabela: "
        #define STR0031 "Aguarde"
        #define STR0032 "Atualizando Tabela(s) de Dados: Empresa "
        #define STR0033 " Filial: "
        #define STR0034 "Problema na abertura do arquivo de Empresa"
        #define STR0035 "Log de Atualização"
        #define STR0036 "Processo de Simulação Realizado com Sucesso."
        #define STR0037 "Processo de Simulação Finalizado."
        #define STR0038 "Simulação"
        #define STR0039 "Aguarde..."
        #define STR0040 "Selecione o arquivo de Configuração de Update"
        #define STR0041    "Aplicar o Update?"
        #define STR0042 "Registro:"
        #define STR0043 "Será"
        #define STR0044 "Foi"
        #define STR0045 "Excluido"
        #define STR0046 "Problema no arquivo de Configuração de Update"
        #define STR0047 "Tabelas com alteração na estrutura"
        #define STR0048 "Processo de Update Cancelado pelo Usuario"
        #define STR0049 "Problema na Criacao do Arquivo de Help"
        #define STR0050 "Problema na Abertura do Arquivo de Help"
        #define STR0051 "Atualizando Helps..." 
        #define STR0052 "Problema na Configuração do Arquivo de Help" 
        #define STR0053 "Arquivo "
        #define STR0054 " não encontrado"
    #endif    
#endif

#DEFINE _OPC_cGETFILE ( GETF_ONLYSERVER )

Static __aFCIndex

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³U_NDJUpdDic   ³Autor³Marinaldo de Jesus   ³ Data ³23/02/2012³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Generic Update                                                ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³Generico                                                      ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
User Function NDJUpdDic( cEmpAmb , cFilAmb )

    //"Rotina de Update em uso por outro usuario"###"Atenção"
    Local bExec     := { || IF(;
                                     LockByName( "U_NDJUpdDic" ) .and. MyOpenSM0(.F.),;
                                         (;
                                             NDJUpdDic( @cEmpAmb , @cFilAmb ),    ;
                                             UnLockByName( "U_NDJUpdDic" )        ;
                                         ),;
                                     Final( STR0001 , STR0003 );
                                );
                        }

    Local cEmp      := cEmpAmb
    Local cFil        := cFilAmb

    Local uRet
    
    Local lSkipRecord

    IF MyOpenSm0(.F.)
    
        IF ( cEmp == NIL )
            While SM0->( !Eof() )
                lSkipRecord    := SM0->( Deleted() .or. !UniqueKey( "M0_CODIGO" , "SM0" ) )
                IF ( lSkipRecord )
                    SM0->( dbSkip() )
                    Loop
                EndIF
                cEmp := SM0->M0_CODIGO
                cFil := SM0->M0_CODFIL
                EXIT
            End While
        ElseIF SM0->( dbSeek( cEmp , .F. ) )
            While SM0->( !Eof() )
                lSkipRecord    := SM0->( Deleted() .or. !UniqueKey( "M0_CODIGO" , "SM0" ) )
                IF ( lSkipRecord )
                    SM0->( dbSkip() )
                    Loop
                EndIF
                cFil := SM0->M0_CODFIL
                EXIT
            End While
        Else
            cEmp := NIL
            cFil := NIL
        EndIF

    EndIF

    dbCloseAll()

    IF ( Empty( cEmp ) .or. Empty( cFil ) )
        //"Atenção"###/"Nennuma Empresa Selecionada para UPDATE"
        Final( STR0001 , STR0002 )
    EndIF

    Private cEmpAnt    := cEmp
    Private cFilAnt := cFil
    Private oMainWnd

Return( StaticCall( NDJLIB001 , EvalPrg , @bExec , @cEmp , @cFil , "SIGAESP" , "U_NDJUpdDic" ) )
Static Function NDJUpdDic( cEmpAmb , cFilAmb )

    Local aSay          := {}
    Local aButton       := {}

    Local bExec    
    Local bMakeLog

    Local cDesc1        := STR0004 //"Processo de Atualização do Dicionário de Dados/Tabelas."
    Local cDesc2        := STR0005 //"Deve ser executado em modo EXCLUSIVO."
    Local cDesc3        := STR0006 //"Recomenda-se BACKUP dos DICIONÁRIOS e BASE DE DADOS"
    Local cDesc4        := STR0007 //"Na eventual Falha do Processo de UPDATE recomendamos:"
    Local cDesc5        := STR0008 //"A RESTAURAÇÃO DO BACKUP"
    
    Local lOk           := .F.
    
    Local lAuto           := ( cEmpAmb <> NIL .and. cFilAmb <> NIL )
    
    Private aLog        := Array(0)
    Private aUPDLog        := Array(0)
    Private aLogTitle   := Array(0)

    Private cCadastro    := "NDJUPDATE"
    Private cTitulo       := STR0009 //"NDJUPDATE :: ATUALIZAÇÃO DE DICIONÁRIOS E TABELAS"
    
    Private lSimula        := .F.

    BEGIN SEQUENCE

        aAdd( aLogTitle , "Inicio do Update" )
        aAdd( aUPDLog , { "Data: " + Dtoc(Date()) + " " + "Hora: " + Time() } )
        
        RpcClearEnv() //Aqui proveniente de EvalPrg

        lOk        := MyOpenSm0(.F.)
        bExec    := { || ExecuteFileComp(@cTitulo,@lAuto,@cEmpAmb,@cFilAmb,@lAuto) }

        aAdd( aSay, cDesc1 )
        aAdd( aSay, cDesc2 )
        aAdd( aSay, cDesc3 )
        aAdd( aSay, cDesc4 )
        aAdd( aSay, cDesc5 )

        aAdd(  aButton , {  1, .T. , { || lOk := .T. , FechaBatch() } } )
        aAdd(  aButton , {  2, .T. , { || lOk := .F. , FechaBatch() } } )
        
        IF ( lAuto )
            lOk := .T.
        Else
            FormBatch( cTitulo,  aSay ,  aButton )
        EndIF
        
        IF !( lOk )
            BREAK
        EndIF
        
        lOk := Eval( bExec )

    END SEQUENCE

    aAdd( aLogTitle , "Final do Update" )
    aAdd( aUPDLog , { "Data: " + Dtoc(Date()) + " " + "Hora: " + Time() } )

    IF ( Len( aUPDLog ) > 0 )

        RpcClearEnv()
        MyOpenSm0(.T.)

        cEmpAnt := SM0->M0_CODIGO
        cFilAnt := SM0->M0_CODFIL

        UpdSetEnv( cEmpAnt , cFilAnt )

        TRYEXCEPTION
            bMakeLog     := { || __Execute( "U_UpdMakeLog(@aUPDLog,@aLogTitle,@cTitulo)" , "xxxxxxxxxxxxxxxxxxxx" , "U_UpdMakeLog" , AllTrim(Str(nModulo)) , "" , 1 , .T. ) }
            MsAguarde( bMakeLog , STR0010 ) //"Gerando o Log"
        ENDEXCEPTION

    EndIF

    IF ( lOk )
        IF ( lSimula )
            Final( STR0036 )    //"Processo de Simulação Realizado com Sucesso."
        Else
            Final( STR0011 )    //"Processo de Atualização Realizado com Sucesso."
        EndIF    
    Else
        IF ( lSimula )
            Final( STR0037 )    //"Processo de Simulação Finalizado."
        Else
            Final( STR0012 )    //"Processo de Atualização Finalizado."
        EndIF    
    EndIF    

Return( NIL )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³ExecuteFileComp³Autor³Marinaldo de Jesus  ³ Data ³23/02/2012³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Comparar Conteudo de arquivos                               ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³Generico                                                      ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function ExecuteFileComp(cTitulo,lAuto,cEmpAmb,cFilAmb,lAuto)

    Local aPBoxPar            := {}    
    Local aPBoxRet            := {}

    Local aEmpresas            := {}
    Local aFilesComp        := {}
    Local aHelpSourceFiles    := {}
    Local aHelpTargetFiles    := {}

    Local cINIFile            := cGetFile( ".ini |*.ini " , OemToAnsi( STR0040 ) , NIL , "" , .F. , _OPC_cGETFILE ) //"Selecione o arquivo de Configuração de Update"

    Local lOK                := .F.
    Local lHelpForceUpd        := .F.
    Local lSkipRecord        := .F.
    Local lApplyUpdate        := .F.
    
    Local nPBox                := 0
    Local nBL                := 0
    Local nEL                := 0

    Local oINIFile
    
    BEGIN SEQUENCE
    
        SM0->( dbClearFilter() )
    
        SM0->( dbGoTop() )

        While SM0->( !Eof() )
            lSkipRecord    := SM0->( Deleted() .or. !UniqueKey( "M0_CODIGO" , "SM0" ) )
            IF ( lSkipRecord )
                SM0->( dbSkip() )
                Loop
            EndIF
            cEmpresa := SM0->( M0_CODIGO + " - " + AllTrim( M0_NOME ) + " / " + AllTrim( M0_FILIAL ) )
            IF ( lAuto )
                IF !( SM0->M0_CODIGO == cEmpAmb )
                    SM0->( dbSkip() )
                    Loop
                EndIF
                IF !( SM0->M0_CODFIL == cFilAmb )
                    SM0->( dbSkip() )
                    Loop
                EndIF
            Else
                aAdd( aPBoxPar , Array(6) )
                ++nPBox
                aPBoxPar[nPBox][1]    := 5                                                //[1] : CheckBox ( linha inteira )
                aPBoxPar[nPBox][2]    := SM0->( M0_CODIGO + " - " + M0_NOME ) +"?"        //[2] : Descrição
                aPBoxPar[nPBox][3]    := .F.                                                //[3] : Indicador Lógico contendo o inicial do Check
                aPBoxPar[nPBox][4]    := 150                                                //[4] : Tamanho do Radio
                aPBoxPar[nPBox][5]    := "AllWaysTrue()"                                    //[5] : Validação
                aPBoxPar[nPBox][6]    := .F.                                                //[6] : Flag .T./.F. Parâmetro Obrigatório ?
            EndIF
            SM0->( aAdd( aEmpresas , Recno() ) )
            SM0->( dbSkip() )
        End While
        
        IF !( lAuto )
            IF !( Parambox( @aPBoxPar , STR0013 , @aPBoxRet ) )    //"Selecione a(s) Empresa(s) Para o Update"
                //"Atenção"###"Nennuma Empresa Selecionada para UPDATE"
                Final( STR0001 , STR0002 )
            EndIF
            nEL := Len( aPBoxRet )
            For nBL := 1 To nEL
                IF ( .not. aPBoxRet[ nBL ] )
                    aEmpresas[ nBL ] := 0
                EndIF
            Next nBL
            nBL := 0
            While ( ( nBL := aScan( aEmpresas , 0 ) ) > 0 )
                aDel( aEmpresas , nBL )
                aSize( aEmpresas , --nEL )
            End While
        EndIF

        IF ( Len( aEmpresas ) == 0 )
            //"Atenção"###"Nennuma Empresa Selecionada para UPDATE"
            Final( STR0001 , STR0002 )
        EndIF

        SM0->( MsGoto( aEmpresas[ 1 ] ) )
        cEmpAnt := SM0->M0_CODIGO
        cFilAnt := SM0->M0_CODFIL

        dbCloseAll()

        UpdSetEnv( cEmpAnt , cFilAnt )
        
        lOk        := MyOpenSm0(.F.)  

        aFilesComp    := FilesComp( @cINIFile , @oINIFile , @lApplyUpdate , @aHelpSourceFiles , @aHelpTargetFiles , @lHelpForceUpd )

        IF !( lAuto )

            aSize( aPBoxPar , 0 )
            aSize( aPBoxRet , 0 )

            aAdd( aPBoxPar , Array(6) )
            nPBox := Len(aPBoxPar)
            aPBoxPar[nPBox][1]    := 5                                                //[1] : CheckBox ( linha inteira )
            aPBoxPar[nPBox][2]    := STR0041    //"Aplicar o Update?"                    //[2] : Descrição
            aPBoxPar[nPBox][3]    := lApplyUpdate                                        //[3] : Indicador Lógico contendo o inicial do Check
            aPBoxPar[nPBox][4]    := 150                                                //[4] : Tamanho do Radio
            aPBoxPar[nPBox][5]    := "AllWaysTrue()"                                    //[5] : Validação
            aPBoxPar[nPBox][6]    := .F.                                                //[6] : Flag .T./.F. Parâmetro Obrigatório ?
            
            aAdd( aPBoxPar , Array(6) )
            nPBox := Len(aPBoxPar)
            aPBoxPar[nPBox][1]    := 5                                                //[1] : CheckBox ( linha inteira )
            aPBoxPar[nPBox][2]    := STR0015    //"Simular o Processo?"                    //[2] : Descrição
            aPBoxPar[nPBox][3]    := .T.                                                //[3] : Indicador Lógico contendo o inicial do Check
            aPBoxPar[nPBox][4]    := 150                                                //[4] : Tamanho do Radio
            aPBoxPar[nPBox][5]    := "AllWaysTrue()"                                    //[5] : Validação
            aPBoxPar[nPBox][6]    := .F.                                                //[6] : Flag .T./.F. Parâmetro Obrigatório ?

            IF ( Parambox( @aPBoxPar , STR0016 , @aPBoxRet ) ) //"Opções para Update"
                lApplyUpdate    := aPBoxRet[1]
                lSimula            := aPBoxRet[2]
            Else
                //"Atenção"###"Processo de Update Cancelado pelo Usuario"
                Final( STR0001 , STR0048 )
            EndIF

            IF !( lApplyUpdate )
                lSimula    := .T.    
            EndIF

            IF ( lSimula )
                cTitulo        +=  " (" + STR0038 + ") " //"Simulação"
                cCadastro    +=  " (" + STR0038 + ") " //"Simulação"
            EndIF

        EndIF

        nEL := Len( aFilesComp )
        For nBL := 1 To nEL
            IF ( lOK )
                lOK := CompFiles( @aFilesComp[ nBL ] , .T. , @aEmpresas , @lAuto , ( nBL == 1 ) , @aHelpSourceFiles , @aHelpTargetFiles , @lHelpForceUpd )
            EndIF    
        Next nEL    

        IF ( lOK )
            IF !( lSimula )
                oINIFile:SetPropertyValue( "GENERAL" , "nApplyUpdate" , "0" )
                oINIFile:SaveAs( cINIFile )
            EndIF    
        EndIF

        RpcClearEnv()
    
    END SEQUENCE

Return( lOK )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³GetFCkArr      ³Autor³Marinaldo de Jesus   ³ Data ³26/02/2012³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Array FC                                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³Generico                                                      ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function GetFCkArr()

    IF ( __aFCIndex == NIL )
    
        __aFCIndex    := Array(0)

        aAdd( __aFCIndex , { Lower( "bdbSourceName"            )    , "B" , { || "" }     } )
        aAdd( __aFCIndex , { Lower( "brddSource"             )    , "B" , { || "" }     } )
        aAdd( __aFCIndex , { Lower( "bdbTargetName"            )    , "B" , { || "" }     } )
        aAdd( __aFCIndex , { Lower( "brddTarget"            )    , "B" , { || "" }    } )
        aAdd( __aFCIndex , { Lower( "cIndexKey"                )    , "C" , ""             } )
        aAdd( __aFCIndex , { Lower( "cIndexCond"            )    , "C" , ""             } )
        aAdd( __aFCIndex , { Lower( "bEvalCond"                )    , "B" , { || .T. } } )
        aAdd( __aFCIndex , { Lower( "cFieldDefUpdTable"        )    , "C" , ""             } )
        aAdd( __aFCIndex , { Lower( "aFieldsNotChange"        )    , "A" , Array(0)     } )
        aAdd( __aFCIndex , { Lower( "nSoftSeek"                )    , "N" , 0             } )
        aAdd( __aFCIndex , { Lower( "cHelpField"            )    , "C" , ""             } )
        aAdd( __aFCIndex , { Lower( "cHelpFieldPropri"        )   , "C" , ""             } )
        aAdd( __aFCIndex , { Lower( "bHelpChange"            )    , "B" , { || .F. } } )
        aAdd( __aFCIndex , { Lower( "nAddLogMsg"            )    , "N" , 1             } )
        aAdd( __aFCIndex , { Lower( "nAliasChkFile"            )    , "N" , 0             } )
        aAdd( __aFCIndex , { Lower( "cAliasChkFile"            )    , "C" , ""             } )

    EndIF

Return( __aFCIndex )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³GetFCIndex    ³Autor³Marinaldo de Jesus   ³ Data ³26/02/2012³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Index para FC                                                ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³Generico                                                      ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function GetFCIndex( cKey )

    Local nFCIndex    := 0

    DEFAULT cKey    := ""
    cKey             := Lower( AllTrim( cKey ) )
    nFCIndex        := aScan( GetFCkArr() , { |e| ( e[1] == cKey ) } )

Return( nFCIndex )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³FilesComp     ³Autor³Marinaldo de Jesus   ³ Data ³23/02/2012³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Comparar Conteudo de arquivos                               ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³Generico                                                      ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function FilesComp( cINIFile , oINIFile , lApplyUpdate , aHelpSourceFiles , aHelpTargetFiles , lHelpForceUpd )

    Local adbFiles        := Array(2)
    Local aFilesComp    := Array(2)
    Local aKdbFiles        := { "adbConfig" , "adbTables" }
    Local aGetFCkArr    := GetFCkArr()

    Local cType
    Local cStack        := ProcName()
    Local cdbFile
    Local cFCKeyType
    
    Local nFile            := 0
    Local nFiles        := 0    
    Local ndbFile        := 0
    Local ndbFiles        := 0 
    Local nFilesComp    := 0

    Local nFCKey        := 0
    Local nFCKeys        := 0

    Local lChangeType
    
    Local uProperty

    BEGIN SEQUENCE

        IF !File( cINIFile )
            BREAK
        EndIF

        oINIFile        := U_TFINI( @cINIFile )

        /*   
            Exemplo de Configuracao do arquivo .ini
            
            [GENERAL]
            
            adbConfig            = SIX,SX1,SX2,SX3,SX6,SX7,SX9,SXA,SXB,SXG,SXM,SXO
            adbTables            = SX5
            applyUpdate            = 1
            aHelpSourceFiles    = \ndj_upd\sigahlp.hlp,\ndj_upd\sigahle.hle,\ndj_upd\sigahls.hls
            aHelpTargetFiles    = sigahlp.hlp,sigahle.hle,sigahls.hls  
            nHelpForceUpd        = 0

            adbConfig : [SX3]

            bdbSourceName        = {||"\ndj_upd\sx3esp.dbf"}
            brddSource            = {||"DBFCDXADS"}
            bdbTargetName        = {||"sx3"+cEmpAnt+"0"+GetDbExtension()}
            brddTarget            = {||__LocalDriver}
            cIndexKey            = X3_ARQUIVO+X3_CAMPO
            cIndexCond            =
            bEvalCond            = {||.T.}
            cFieldDefUpdTable    = X3_ARQUIVO;Obrigatorio para o SX3
            aFieldsNotChange    =
            nSoftSeek            = 0
            cHelpField            = X3_CAMPO
            cHelpFieldPropri    = X3_PROPRI
            bHelpChange            = {||X3_PROPRI=="U"} 
            
            adbTables : [SZ0]

            bdbSourceName        = {||"\ndj_upd\sz0esp.dbf"}
            brddSource            = {||"DBFCDXADS"}
            bdbTargetName        = {||"sz0"+cEmpAnt+"0"}
            brddTarget            = {||__cRDD}
            cIndexKey            = Z0_FILIAL+Z0_COD
            cIndexCond            =
            bEvalCond            = {||.T.}
            cFieldDefUpdTable    = 
            aFieldsNotChange    =
            nSoftSeek            = 0
            cHelpField            = 
            cHelpFieldPropri    = 
            bHelpChange            =
            nAddLogMsg            = 0
            nAliasChkFile        = 1
            cAliasChkFile        = "SZ0"

        */        

        nFCKeys     := Len( aGetFCkArr )
        ndbFiles     := Len( adbFiles )
        For ndbFile := 1 To ndbFiles

            adbFiles[ndbFile]    := StrTokArr2( Upper( AllTrim( oINIFile:GetPropertyValue( "GENERAL" , aKdbFiles[ ndbFile ] , "" ) ) ) , "," )
            aFilesComp[ndbFile]    := Array(0)
            
            nFiles                 := Len( adbFiles[ ndbFile ] )
            nFilesComp            := 0

            For nFile := 1 To nFiles

                cdbFile    := adbFiles[ ndbFile ][ nFile ]

                aAdd( aFilesComp[ ndbFile ] , Array( nFCKeys ) )
                ++nFilesComp

                For nFCKey := 1 To nFCKeys
            
                    cFCKey         := aGetFCkArr[nFCKey][1]
                    cType        := aGetFCkArr[nFCKey][2]
                    uProperty    := oINIFile:GetPropertyValue( cdbFile , cFCKey , aGetFCkArr[nFCKey][3] )
                    cFCKeyType    := ValType( uProperty )
                    lChangeType    := !( cFCKeyType == cType )

                    IF ( lChangeType )
                        DO CASE
                        CASE ( cType == "A" )
                            IF ( cFCKeyType == "C" )
                                aFilesComp[ ndbFile ][ nFilesComp ][ nFCKey ] := StrTokArr2( uProperty , "," )
                            Else
                                aFilesComp[ ndbFile ][ nFilesComp ][ nFCKey ] := Array(0)
                            EndIF    
                        CASE ( cType == "N" )
                            IF ( cFCKeyType == "C" )
                                aFilesComp[ ndbFile ][ nFilesComp ][ nFCKey ] := Val( uProperty )
                            ElseIF ( cFCKeyType == "L" )
                                aFilesComp[ ndbFile ][ nFilesComp ][ nFCKey ] := IF( uProperty , 1 , 0 )
                            Else
                                aFilesComp[ ndbFile ][ nFilesComp ][ nFCKey ] := 0
                            EndIF    
                        CASE ( cType == "L" )
                            IF ( cFCKeyType == "C" )
                                aFilesComp[ ndbFile ][ nFilesComp ][ nFCKey ] := Upper( uProperty )
                                IF ( "T" $ uProperty )
                                    aFilesComp[ ndbFile ][ nFilesComp ][ nFCKey ] := .T.
                                ElseIF ( "F" $ uProperty )
                                    aFilesComp[ ndbFile ][ nFilesComp ][ nFCKey ] := .F.
                                Else
                                    aFilesComp[ ndbFile ][ nFilesComp ][ nFCKey ] := !( Val( uProperty ) == 0 )
                                EndIF    
                            ElseIF ( cFCKeyType == "N" )
                                aFilesComp[ ndbFile ][ nFilesComp ][ nFCKey ] := IF( uProperty <> 0 , .T. , .F. )
                            EndIF    
                        CASE ( cType == "B" )
                            IF ( cFCKeyType == "C" )
                                TRYEXCEPTION
                                    aFilesComp[ ndbFile ][ nFilesComp ][ nFCKey ]    := &( uProperty )
                                    cFCKeyType    := ValType( aFilesComp[ ndbFile ][ nFilesComp ][ nFCKey ] )
                                    IF !( cFCKeyType == "B" )
                                        UserException(STR0046)    //"Problema no arquivo de Configuração de Update"
                                    EndIF
                                CATCHEXCEPTION
                                    Final( STR0001 , STR0046 )    //"Problema no arquivo de Configuração de Update"
                                ENDEXCEPTION                                    
                            Else
                                aFilesComp[ ndbFile ][ nFilesComp ][ nFCKey ]    := { || .T. }
                            EndIF
                        OTHERWISE
                            IF ( cFCKeyType == "C" )
                                aFilesComp[ ndbFile ][ nFilesComp ][ nFCKey ]    := uProperty
                            Else
                                aFilesComp[ ndbFile ][ nFilesComp ][ nFCKey ]    := ""
                            EndIF
                        ENDCASE
                    Else
                        aFilesComp[ ndbFile ][ nFilesComp ][ nFCKey ]    := uProperty
                    EndIF    

                Next nFCKey
            
            Next nFile   
        
        Next ndbFile    

        aHelpSourceFiles    := StrTokArr2( Lower( AllTrim( oINIFile:GetPropertyValue( "GENERAL" , "aHelpSourceFiles" , "" ) ) ) , "," )
        aHelpTargetFiles    := StrTokArr2( Lower( AllTrim( oINIFile:GetPropertyValue( "GENERAL" , "aHelpTargetFiles" , "" ) ) ) , "," )
        IF !( Len( aHelpTargetFiles ) == Len( aHelpSourceFiles ) )
            //"Atenção"###"Problema na Configuração do Arquivo de Help"
            Final( STR0001 , STR0052 ) //"Problema na Configuração do Arquivo de Help"
        EndIF
        nFiles := Len( aHelpSourceFiles )
        For nFile := 1 To nFiles
            IF !File( aHelpSourceFile[ nFile ] )
                //"Atenção"###"Arquivo "###" não encontrado"
                Final( STR0001 , STR0053 + aHelpSourceFile[ nFile ] + STR0054 )
            EndIF
        Next nFile
        nFiles := Len( aHelpTargetFiles )
        For nFile := 1 To nFiles
            IF !File( aHelpTargetFiles[ nFile ] )
                //"Atenção"###"Arquivo "###" não encontrado"
                Final( STR0001 , STR0053 + aHelpTargetFiles[ nFile ] + STR0054 )
            EndIF
        Next nFile
        lApplyUpdate        := !( Val( AllTrim( oINIFile:GetPropertyValue( "GENERAL" , "nApplyUpdate"  , "0" ) ) ) == 0 )
        lHelpForceUpd        := !( Val( AllTrim( oINIFile:GetPropertyValue( "GENERAL" , "nHelpForceUpd" , "0" ) ) ) == 0 )

    END SEQUENCE

Return( aFilesComp )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³CompFiles      ³Autor³Marinaldo de Jesus   ³ Data ³23/02/2012³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Comparar Conteudo de arquivos                               ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³Generico                                                      ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function CompFiles( aFilesComp , lShowProc , aRecnos , lAuto , ldbConfig , aHelpSourceFiles , aHelpTargetFiles , lHelpForceUpd )

    Local aUpdTable        := Array(0)
    Local aFieldPos        := Array(0)
    Local aStruHelp
    Local aHelpFile

    Local bCond
    Local bUpdHelp
    Local bMakeLog
    Local bProcess
    
    Local cLog
    Local cLogTitle

    Local cData1File
    Local cData2File
    Local cIndex1File
    Local cIndex2File
    Local cFile1Alias
    Local cFile2Alias
    Local cKeyRelation

    Local cAliasChkFile
    Local cRddFile1
    Local cRddFile2
    Local cCntFile1
    Local cCntFile2
    Local cUpdTable

    Local cSrcHelp
    Local cTrgHelp
    Local cHlpFile
    Local cHelpFile
    Local cHelpAlias

    Local cKey
    Local cLstKey
    Local cProxKey
    Local cPartKey
    Local cKeyPart

    Local cHelpFPropri
    
    Local lLock
    Local lChange
    Local lAllComp
    Local lDeleted

    Local lOK                := .F.
    Local lFound            := .F.
    Local lAliasChkFile            := .F.
    Local lUpdHelp          := .F.
    Local lUpdTable            := .F.
    Local lSoftSeek            := .F.
    Local lAddLogMsg        := .T.
    Local lSetDeleted        := Set( _SET_DELETED , "OFF" )
    Local lFNotChange        := .F.
    Local lHelpFPropri        := .F.
    Local lFieldChange        := .T.
    Local lFldsNotChange    := .F.
    
    Local nEmp
    Local nEmps

    Local nFile
    Local nFiles

    Local nHelp
    Local nHelps

    Local nField
    Local nFields

    Local nPartKey
    Local nUpdHelp
    Local nFieldPos
    Local nUpdTable
    Local nHelpFPropri
    
    Local uCntFile1
    Local uCntFile2
    
    DEFAULT aFilesComp        := {}
    DEFAULT lShowProc        := .F.

    BEGIN SEQUENCE
    
        IF ( lAuto )
            lShowProc        := .F.
        EndIF
        IF ( lShowProc )
            lShowProc        := .F.
            bProcess        := { || lOK := CompFiles( @aFilesComp , @lShowProc , @aRecnos , @lAuto , @ldbConfig , @aHelpSourceFiles , @aHelpTargetFiles , @lHelpForceUpd ) }
            oProcess        := MsNewProcess():New( bProcess , cCadastro , STR0039 , .F. )    //"Aguarde..."
            oProcess:Activate()
            BREAK
        EndIF    

        RpcClearEnv()
        
        lOk     := MyOpenSm0(.F.)
        lChange    := !( lSimula )

        nEmps     := Len( aRecnos )
        nFiles    := Len( aFilesComp )
        nHelps    := Len( aHelpSourceFiles )

        For nEmp := 1 To nEmps

            SM0->( dbGoto( aRecnos[ nEmp ] ) )
            IF SM0->( Eof() .or. Bof() )
                Loop
            EndIF

            cEmpAnt    := SM0->M0_CODIGO
            cFilAnt    := SM0->M0_CODFIL
        
            UpdSetEnv( @cEmpAnt , @cFilAnt )

            dbCloseAll()
         
            Set( _SET_DELETED , "OFF" )

            lOk := MyOpenSm0(.F.)

            IF (;
                    ( lChange );
                    .and.;
                    ( ldbConfig );
                )    
                EraseIndexes()
            EndIF    
    
            IF !( lAuto )
                oProcess:SetRegua1( nFiles )
            EndIF    

            For nFile := 1 To nFiles
                
                cData1File        := Lower( Eval( aFilesComp[ nFile ][ GetFCIndex( "bdbSourceName" ) ] ) )
                cData2File        := Lower( Eval( aFilesComp[ nFile ][ GetFCIndex( "bdbTargetName" ) ] ) )
                cKeyRelation    := aFilesComp[ nFile ][ GetFCIndex( "cIndexKey" ) ]
                cRddFile1        := Eval( aFilesComp[ nFile ][ GetFCIndex( "brddSource" ) ] )
                cRddFile2        := Eval( aFilesComp[ nFile ][ GetFCIndex( "brddTarget" ) ] )
                lUpdTable        := !Empty( aFilesComp[ nFile ][ GetFCIndex( "cFieldDefUpdTable" ) ] )
                lFldsNotChange    := ( ValType( aFilesComp[ nFile ][ GetFCIndex( "aFieldsNotChange" ) ] ) == "A" )
                lSoftSeek        := !( aFilesComp[ nFile ][ GetFCIndex( "nSoftSeek" ) ] == 0 )
                bCond            := aFilesComp[ nFile ][ GetFCIndex( "bEvalCond"  ) ]
                cCondIndex        := aFilesComp[ nFile ][ GetFCIndex( "cIndexCond" ) ]
                lUpdHelp        := !Empty( aFilesComp[ nFile ][ GetFCIndex( "cHelpField" ) ] )
                bUpdHelp        := aFilesComp[ nFile ][ GetFCIndex( "bHelpChange" ) ]
                lHelpFPropri    := !Empty( aFilesComp[ nFile ][ GetFCIndex( "cHelpFieldPropri" ) ] )
                lAddLogMsg        := !( aFilesComp[ nFile ][ GetFCIndex( "nAddLogMsg" ) ] == 0 )
                lAliasChkFile    := !( aFilesComp[ nFile ][ GetFCIndex( "nAliasChkFile" ) ] == 0 )
                cAliasChkFile    := aFilesComp[ nFile ][ GetFCIndex( "cAliasChkFile" ) ]
                IF ( lAliasChkFile )
                    lAliasChkFile := !Empty( cAliasChkFile )
                EndIF

                IF ( cRddFile1 == "TOPCONN" )
                    cData1File    := FileNoExt( cData1File )
                EndIF
                IF ( cRddFile2 == "TOPCONN" )
                    cData2File    := FileNoExt( cData2File )
                EndIF
        
                IF !( MsFile( cData1File , NIL , cRddFile1 ) )
                    Loop
                EndIF

                IF !( MsFile( cData2File , NIL , cRddFile2 ) )
                    IF ( lAliasChkFile )
                        IF !( ChkFile( cAliasChkFile ) )
                            Loop
                        EndIF
                        IF ( Select( cAliasChkFile ) > 0 )
                            ( cAliasChkFile )->( dbCloseArea() )
                        EndIF    
                    Else
                        Loop
                    EndIF
                EndIF
        
                //"Comparando: "###" com "
                IF !( lAuto )
                    oProcess:IncRegua1( STR0017 + cData1File + STR0018 + cData2File )
                EndIF    
        
                cFile1Alias := GetNextAlias()
                IF !(;
                        MsOpenDbf( .T. , cRddFile1 , cData1File , cFile1Alias , !( lChange ) , .F. );
                        .and.;
                        ( Select( cFile1Alias ) > 0 );
                    )
                    IF ( lChange )
                        //"Atenção"###"Impossivel obter exclusividade no arquivo : "
                        Final( STR0001  , STR0019 +  cData1File  )
                    Else
                         //"Atenção"###"Problema na abertura do arquivo "
                         Final( STR0001 , STR0020 )
                    EndIF    
                EndIF
                cIndex1File := ( FileNoExt( cData1File ) + OrdBagExt() )
                ( cFile1Alias )->( IndRegua( @cFile1Alias , @cIndex1File , @cKeyRelation , NIL , @cCondIndex ) )
        
                cFile2Alias := GetNextAlias()
                IF !(;
                        MsOpenDbf( .T. , cRddFile2 , cData2File , cFile2Alias , !( lChange ) , .F. );
                        .and.;
                        ( Select( cFile2Alias ) > 0 );
                    )
                    IF ( lChange )
                        //"Atenção"###"Impossivel obter exclusividade no arquivo : "
                        Final( STR0001  , STR0019 +  cData2File )
                    Else
                        //"Atenção"###"Problema na abertura do arquivo "
                        Final( STR0001 , STR0020 +  cData2File )
                    EndIF    
                EndIF
                cIndex2File := ( FileNoExt( cData2File ) + OrdBagExt() )
                ( cFile2Alias )->( IndRegua( @cFile2Alias , @cIndex2File , @cKeyRelation , NIL , @cCondIndex ) )

                adbStruct    := ( cFile1Alias )->( dbStruct() )
                nFields        := Len( adbStruct )

                //Resolucao de FieldPos
                For nField := 1 To nFields
                    aAdd( aFieldPos , Array(2) )
                    nFieldPos    := ( cFile2Alias )->( FieldPos( adbStruct[ nField ][ DBS_NAME ] ) )
                    aFieldPos[ nField ][ 1 ] := nFieldPos
                    aFieldPos[ nField ][ 2 ] := ( nFieldPos > 0 )
                Next nField        

                IF ( lUpdTable )
                    nUpdTable    := ( cFile1Alias )->( FieldPos( aFilesComp[ nFile ][ GetFCIndex( "cFieldDefUpdTable" ) ] ) )
                EndIF

                IF ( lUpdHelp )

                    nUpdHelp         := ( cFile1Alias )->( FieldPos( aFilesComp[ nFile ][ GetFCIndex( "cHelpField" ) ] ) )
                    lUpdHelp        := ( ( lChange ) .and. ( nUpdHelp > 0 ) )
                    nHelpFPropri    := ( cFile1Alias )->( FieldPos( aFilesComp[ nFile ][ GetFCIndex( "cHelpFieldPropri" ) ] ) )
                    lHelpFPropri    := ( nHelpFPropri > 0 )

                    IF ( lUpdHelp )

                        aStruHelp := Array( 3 , DBS_ALEN )

                        aStruHelp[1][ DBS_NAME ]        := "H_FIELD"
                        aStruHelp[1][ DBS_TYPE ]        := "C"
                        aStruHelp[1][ DBS_LEN  ]        := Len( ( cFile1Alias )->( FieldGet( nUpdHelp ) ) )
                        aStruHelp[1][ DBS_DEC  ]        := 0

                        aStruHelp[2][ DBS_NAME ]        := "H_PROPRI"
                        aStruHelp[2][ DBS_TYPE ]        := "C"
                        IF ( lHelpFPropri )
                            aStruHelp[2][ DBS_LEN  ]    := Len( ( cFile1Alias )->( FieldGet( nHelpFPropri ) ) )
                        Else
                            aStruHelp[2][ DBS_LEN    ]    := 1
                        EndIF    
                        aStruHelp[2][ DBS_DEC          ]    := 0

                        aStruHelp[3][ DBS_NAME ]        := "H_MEMO"
                        aStruHelp[3][ DBS_TYPE ]        := "M"
                        aStruHelp[3][ DBS_LEN  ]        := 10
                        aStruHelp[3][ DBS_DEC  ]        := 0

                        cHelpFile                    := ( CriaTrab( NIL , .F. ) + ".dbf" )
                        IF !( MsCreate( cHelpFile , aStruHelp , "DBFCDXADS" ) )
                            //"Atenção"###"Problema na Criacao do Arquivo de Help"
                            Final( STR0001 , STR0049  ) 
                        EndIF
                        cHelpAlias := GetNextAlias()
                        IF !( MsOpenDbf(.T.,"DBFCDXADS",cHelpFile,cHelpAlias,.T.,.F.,.T.,.F.) )
                            //"Atenção"###"Problema na Abertura do Arquivo de Help"
                            Final( STR0001 , STR0050  ) 
                        EndIF

                    EndIF

                EndIF    

                IF ( lAddLogMsg )
    
                    aSize( aLog , 0 )
                    cLogTitle    := ( cData1File + STR0021 + cData2File ) //" com "
                
                EndIF    
            
                nPartKey := ( At( "+" , cKeyRelation ) - 1 )
                IF ( nPartKey <= 0 )
                    nPartKey := Len( cKeyRelation )
                EndIF    
                cPartKey := SubStr( cKeyRelation , 1 , nPartKey )
        
                DEFAULT bCond := { || .T. }
                
                IF !( lAuto )
                    oProcess:SetRegua2( ( cFile1Alias )->( RecCount() ) )
                EndIF    
        
                ( cFile1Alias )->( dbGotop() )
                While ( cFile1Alias )->( !Eof() )
                    IF !( lAuto )
                        oProcess:IncRegua2(STR0014)    //"Processando..." 
                    EndIF    
                    IF ( cFile1Alias )->( !Eval( bCond ) )
                        ( cFile1Alias )->( dbSkip() )
                        Loop
                    EndIF
                    lLock         := .F.
                    cKey        := ( cFile1Alias )->( &( cKeyRelation ) )
                    cKeyPart    := ( cFile1Alias )->( &( cPartKey ) )
                    lDeleted    := ( cFile1Alias )->( Deleted() )
                    lFound        := ( cFile2Alias )->( dbSeek( cKey , lSoftSeek ) )
                    IF ( ( lFound ) .and. ( lSoftSeek ) )
                        lFound    := ( cFile2Alias )->( &( cKeyRelation ) == cKey )
                        IF !( lFound )
                            While ( cFile2Alias )->( !Eof() .and. &( cPartKey ) == cKeyPart )
                                lFound    := ( cFile2Alias )->( &( cKeyRelation ) == cKey )
                                IF ( lFound )
                                    IF ( cFile2Alias )->( .not. deleted() )
                                        EXIT
                                    EndIF    
                                EndIF
                                ( cFile2Alias )->( dbSkip() )
                            End While
                        EndIF
                    ElseIF ( lSoftSeek )
                        While ( cFile2Alias )->( !Eof() .and. &( cPartKey ) == cKeyPart )
                            lFound    := ( cFile2Alias )->( &( cKeyRelation ) == cKey )
                            IF ( lFound )
                                IF ( cFile2Alias )->( .not. deleted() )
                                    EXIT
                                EndIF    
                            EndIF
                            ( cFile2Alias )->( dbSkip() )
                        End While
                    ElseIF ( cFile2Alias )->( deleted() )
                        While ( cFile2Alias )->( !Eof() .and. ( &( cKeyRelation ) == cKey ) )
                            lFound    := ( cFile2Alias )->( .not. deleted() .and. ( &( cKeyRelation ) == cKey ) )
                            IF ( lFound )
                                EXIT
                            EndIF
                            ( cFile2Alias )->( dbSkip() )
                        End While
                    EndIF
                    IF ( lFound )
                        IF ( lChange )
                            lLock := ( cFile2Alias )->( RecLock( cFile2Alias , .F. )  )
                        EndIF
                        IF ( lDeleted )
                            IF ( lLock )
                                ( cFile2Alias )->( dbDelete() )
                                ( cFile2Alias )->( MsUnLock() )
                                IF ( lUpdHelp )
                                    cHlpFile := RetHlpFile()
                                    For nHelp := 1 To nHelps
                                        SetHlpFile( aHelpSourceFiles[ nHelp ] )
                                        IF ( cHelpAlias )->( RecLock( cHelpAlias , .T. ) )
                                            uCntFile1 := ( cFile1Alias )->( FieldGet( nUpdHelp ) )
                                            ( cHelpAlias )->( FieldPut( 1 , uCntFile1 ) )
                                            ( cHelpAlias )->( FieldPut( 2 , "" ) )
                                            ( cHelpAlias )->( FieldPut( 3 , "" ) )
                                            ( cHelpAlias )->( MsUnLock() )
                                        EndIF
                                    Next nHelp
                                    SetHlpFile( cHlpFile )
                                EndIF        
                            EndIF
                            IF !( cLstKey == cKeyPart )
                                cLstKey := cKeyPart
                                IF ( lAddLogMsg )
                                    IF ( aScan( aLog , { |x| x == cKeyPart } ) == 0 )
                                        aAdd( aLog , cKeyPart )
                                        aAdd( aLog , "" )
                                    EndIF
                                EndIF    
                            EndIF
                            IF ( lAddLogMsg )
                                cLog         := AllTrim( cKey )
                                cLog         += " - "
                                cLog         += STR0042 + " " + Str(Recno()) //"Registro:"
                                cLog         += " "
                                IF ( ( lChange ) .and. ( lLock ) )
                                    cLog    += STR0044 //"Foi"
                                Else
                                    cLog    += STR0043 //"Será"
                                EndIF
                                cLog         += " "
                                cLog         += STR0045 //"Excluido"
                                aAdd( aLog , cLog )
                            EndIF
                            IF ( lUpdTable )
                                cUpdTable := ( cFile1Alias )->( FieldGet( nUpdTable ) )
                                IF ( aSCan( aUpdTable , cUpdTable ) == 0 )
                                    aAdd( aUpdTable , cUpdTable )
                                EndIF
                            EndIF
                            ( cFile1Alias )->( dbSkip() )
                            Loop
                        EndIF
                        For nField := 1 To nFields
                            IF ( aFieldPos[nField][2] )
                                nFieldPos    := aFieldPos[nField][1]
                                uCntFile1    := ( cFile1Alias )->( FieldGet( nField ) )
                                uCntFile2    := ( cFile2Alias )->( FieldGet( nFieldPos ) )
                            Else
                                IF ( lAddLogMsg )
                                    cLog := ( STR0022 + adbStruct[ nField ][ DBS_NAME ] ) //"Campo nao Encontrado: "
                                    IF ( aScan( aLog , { |x| x == cLog } ) == 0 )
                                        aAdd( aLog , cLog )    
                                    EndIF
                                EndIF    
                                Loop
                            EndIF
                            lFNotChange := Compare( uCntFile1 , uCntFile2 )
                            IF ( lUpdHelp )
                                IF ( ( lFNotChange ) .and. !( lHelpForceUpd ) )
                                    Loop
                                EndIF
                                IF ( nUpdHelp == nField )
                                    IF ( cFile1Alias )->( Eval( bUpdHelp ) )
                                        cHlpFile := RetHlpFile()
                                        For nHelp := 1 To nHelps
                                            SetHlpFile( aHelpSourceFiles[ nHelp ] )
                                            IF ( cHelpAlias )->( RecLock( cHelpAlias , .T. ) )
                                                ( cHelpAlias )->( FieldPut( 1 , uCntFile1 ) )
                                                IF ( lHelpFPropri )
                                                    cHelpFPropri := ( cFile1Alias )->( FieldGet( nHelpFPropri ) )
                                                    ( cHelpAlias )->( FieldPut( 2 , cHelpFPropri ) )
                                                EndIF
                                                ( cHelpAlias )->( FieldPut( 3 , Ap5GetHelp(uCntFile1) ) )
                                                ( cHelpAlias )->( MsUnLock() )
                                            EndIF
                                        Next nHelp
                                        SetHlpFile( cHlpFile )
                                    EndIF
                                EndIF
                            EndIF
                            IF ( lFNotChange )
                                Loop
                            EndIF    
                            IF !( cLstKey == cKeyPart )
                                cLstKey := cKeyPart
                                IF ( lAddLogMsg )
                                    IF ( aScan( aLog , { |x| x == cKeyPart } ) == 0 )
                                        aAdd( aLog , cKeyPart )
                                        aAdd( aLog , "" )
                                    EndIF
                                EndIF    
                            EndIF
                            IF ( lAddLogMsg )
                                cCntFile1    := StrTran( AllTrim( AllToChar( uCntFile1 ) ) , " " , "" )
                                cCntFile2    := StrTran( AllTrim( AllToChar( uCntFile2 ) ) , " " , "" )
                                cLog         := AllTrim( cKey )
                                cLog         += "-"
                                cLog         += STR0023 + AllTrim( adbStruct[ nField ][ DBS_NAME ] ) //"Campo: "
                                aAdd( aLog , cLog )
                                cLog         := STR0024 //"Conteudo: "
                                cLog         += cData1File
                                cLog         += " -> "
                                cLog         += cCntFile1
                                aAdd( aLog , cLog )
                                cLog         := STR0024 //"Conteudo: "
                                cLog         += cData2File
                                cLog         += " -> "
                                cLog         += cCntFile2
                                aAdd( aLog , cLog )
                            EndIF
                            IF ( lFldsNotChange )
                                lFieldChange    := ( aScan( aFilesComp[ nFile ][ GetFCIndex( "aFieldsNotChange" ) ] , { |cField| ( Upper( AllTrim( cField ) ) == adbStruct[ nField ][ DBS_NAME ] ) } ) == 0 )
                            EndIF
                            IF !( lLock )
                                Loop
                            EndIF
                            IF ( lFieldChange )
                                ( cFile2Alias )->( FieldPut( nFieldPos , uCntFile1 ) )
                                IF ( lUpdTable )
                                    cUpdTable := ( cFile1Alias )->( FieldGet( nUpdTable ) )
                                    IF ( aSCan( aUpdTable , cUpdTable ) == 0 )
                                        aAdd( aUpdTable , cUpdTable )
                                    EndIF
                                EndIF
                                IF ( lAddLogMsg )
                                    cLog    := STR0025    //"Alterado o Conteudo do Campo: "
                                EndIF    
                            Else
                                IF ( lAddLogMsg )
                                    cLog    := STR0026    //"Nao Alterado o Conteudo do Campo: "
                                EndIF    
                            EndIF    
                            IF ( lAddLogMsg )
                                cLog    += adbStruct[ nField ][ DBS_NAME ]
                                cLog    += STR0027 //" de "
                                cLog    += cCntFile2
                                cLog    += STR0028 //" para "
                                cLog    += cCntFile1
                                aAdd( aLog , cLog )
                            EndIF
                        Next nField
                        IF ( lLock )
                            ( cFile2Alias )->( MsUnLock() )
                        EndIF    
                    ElseIF !( lDeleted )
                        IF !( cLstKey == cKey )
                            cLstKey := cKeyPart
                            IF ( lAddLogMsg )
                                IF ( aScan( aLog , { |x| x == cKeyPart } ) == 0 )
                                    aAdd( aLog , cKeyPart )
                                    aAdd( aLog , "" )
                                EndIF    
                            EndIF    
                        EndIF
                        IF ( lAddLogMsg )
                            cLog := ( STR0029 + cKey ) //"Chave não Encontrada:"
                            aAdd( aLog , cLog )
                        EndIF    
                        IF ( lChange )
                            lLock := ( cFile2Alias )->( RecLock( cFile2Alias , .T. )  )
                        EndIF
                        IF ( lLock )
                            IF ( lAddLogMsg )
                                aAdd( aLog , STR0030 + cData2File ) //"Adicionado novo registro na Tabela: "
                            EndIF    
                            For nField := 1 To nFields
                                IF ( aFieldPos[nField][2] )
                                    nFieldPos    := aFieldPos[nField][1]
                                    uCntFile1    := ( cFile1Alias )->( FieldGet( nField ) )
                                    uCntFile2    := ( cFile2Alias )->( FieldGet( nFieldPos ) )
                                    ( cFile2Alias )->( FieldPut( nFieldPos , uCntFile1 ) )
                                    IF ( lAddLogMsg )
                                        cCntFile1    := StrTran( AllTrim( AllToChar( uCntFile1 ) ) , " " , "" )
                                        cCntFile2    := StrTran( AllTrim( AllToChar( uCntFile2 ) ) , " " , "" )
                                        cLog        := STR0025    //"Alterado o Conteudo do Campo: "
                                        cLog        += adbStruct[ nField ][ DBS_NAME ]
                                        cLog        += STR0027 //" de "
                                        cLog        += cCntFile2
                                        cLog        += STR0028 //" para "
                                        cLog        += cCntFile1
                                        aAdd( aLog , cLog )
                                    EndIF
                                Else
                                    IF ( lAddLogMsg )
                                        cLog := ( STR0022 + adbStruct[ nField ][ DBS_NAME ] ) //"Campo nao Encontrado: "
                                        IF ( aScan( aLog , { |x| x == cLog } ) == 0 )
                                            aAdd( aLog , cLog )    
                                        EndIF
                                    EndIF    
                                EndIF
                                IF ( lUpdHelp )
                                    IF ( nUpdHelp == nField )
                                        IF ( cFile1Alias )->( Eval( bUpdHelp ) )
                                            cHlpFile := RetHlpFile()
                                            For nHelp := 1 To nHelps
                                                SetHlpFile( aHelpSourceFiles[ nHelp ] )
                                                IF ( cHelpAlias )->( RecLock( cHelpAlias , .T. ) )
                                                    ( cHelpAlias )->( FieldPut( 1 , uCntFile1 ) )
                                                    IF ( lHelpFPropri )
                                                        cHelpFPropri := ( cFile1Alias )->( FieldGet( nHelpFPropri ) )
                                                        ( cHelpAlias )->( FieldPut( 2 , cHelpFPropri ) )
                                                    EndIF
                                                    ( cHelpAlias )->( FieldPut( 3 , Ap5GetHelp(uCntFile1) ) )
                                                    ( cHelpAlias )->( MsUnLock() )
                                                EndIF
                                            Next nHelp
                                            SetHlpFile( cHlpFile )
                                        EndIF        
                                    EndIF
                                EndIF
                            Next nField
                            IF ( lAddLogMsg )
                                aAdd( aLog , "" )
                            EndIF    
                            ( cFile2Alias )->( MsUnLock() )
                        EndIF
                        IF ( lUpdTable )
                            cUpdTable := ( cFile1Alias )->( FieldGet( nUpdTable ) )
                            IF ( aSCan( aUpdTable , cUpdTable ) == 0 )
                                aAdd( aUpdTable , cUpdTable )
                            EndIF
                        EndIF
                    EndIF
                    ( cFile1Alias )->( dbSkip() )
                    cProxKey := ( cFile1Alias )->( &( cPartKey ) )
                    IF ( lAddLogMsg )
                        IF !( cProxKey == cKeyPart )
                            IF ( aScan( aLog , { |x| x == cKeyPart } ) > 0 )
                                aAdd( aLog , "" )
                                aAdd( aLog , "" )
                            EndIF
                        EndIF
                    EndIF    
                End While
                
                ( cFile2Alias )->( dbCommit() )

                IF ( lUpdHelp )
                    lUpdHelp := ( !Empty( cHelpAlias ) .and. ( Select( cHelpAlias ) > 0 ) )
                EndIF
                IF ( lUpdHelp )
                    cHlpFile := RetHlpFile()
                    IF !( lAuto )
                        oProcess:SetRegua2( ( cHelpAlias )->( RecCount() ) )
                    EndIF    
                    ( cHelpAlias )->( dbGoTop() )
                    While ( cHelpAlias )->( !Eof() )
                        IF !( lAuto )
                            oProcess:IncRegua2(STR0051)    //"Atualizando Helps..." 
                        EndIF    
                        For nHelp := 1 To nHelps
                            SetHlpFile( aHelpTargetFiles[ nHelp ] )
                            ( cHelpAlias )->( X31UpdHlp(FieldGet(1),FieldGet(3),(FieldGet(2)=="U"),.F.) )
                            ( cHelpAlias )->( dbSkip() )
                        Next nHelp
                    End While
                    SetHlpFile( cHlpFile )
                    ( cHelpAlias )->( dbCloseArea() )
                    IF File( cHelpFile )
                        aHelpFile := Directory( StrTran( cHelpFile , ".dbf" , ".*" ) )
                        aEval( aHelpFile , { |e| fErase( e[1] ) } )
                        aSize( aHelpFile , 0 )
                    EndIF
                EndIF

                IF !Empty( aLog )
                    aAdd( aLogTitle , cLogTitle )
                    aAdd( aUPDLog , aClone( aLog ) )
                    aSize( aLog , 0 ) 
                EndIF
        
                ( cFile1Alias )->( dbCloseArea() )
                IF File( cIndex1File )
                    fErase( cIndex1File )
                EndIF
                ( cFile2Alias )->( dbCloseArea() )
                IF File( cIndex2File )
                    fErase( cIndex2File )
                EndIF
                    
            Next nFile

            aSize( aLog , 0 ) 

            RpcClearEnv()

            IF ( Len( aUpdTable ) > 0 )
                cLogTitle    := STR0047 //"Tabelas com alteração na estrutura"
                aAdd( aLogTitle , cLogTitle )
                aEval( aUpdTable , { |cTable| aAdd( aLog , cTable ) } )
                aAdd( aUPDLog , aClone( aLog ) )
                aSize( aLog , 0 ) 
                IF !( lSimula )
                    //"Aguarde"###"Atualizando Tabela(s) de Dados: Empresa "
                    MsAguarde( { || StartJob("U_RPUpdTable" , GetEnvServer() , .T. , @aUpdTable , @cEmpAnt , @cFilAnt , { || MyOpenSm0(.F.) } ) } , OemToAnsi( STR0031 ) , OemToAnsi( STR0032 + cEmpAnt ) )
                    aSize( aUpdTable , 0 )
                EndIF    
            EndIF

            RpcClearEnv()

            MyOpenSm0(.F.)

        Next nEmp

        MyOpenSm0(.F.)

        IF ( lChange )
            EraseIndexes()
            X31AllSX()
        EndIF    
        
        lOK    := .T.
    
    END SEQUENCE
    
    Set( _SET_DELETED , lSetDeleted )
    
Return( lOK )     

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³MyOpenSM0      ³Autor³Marinaldo de Jesus  ³ Data ³23/02/2012³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Abertura Tabela de Empresas                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³Generico                                                      ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function MyOpenSM0( lShared )

    Local lOpen    := .F.

    Local nBL    := 0
    Local nEL    := 30

    BEGIN SEQUENCE

        IF ( Select("SM0") > 0 )
            SM0->( dbCloseArea() )    
        EndIF
    
        While ( ++nBL <= nEL )
        
            IF ( lShared )
                OpenSm0()
            Else
                OpenSM0Excl()
            EndIF    
            
            lOpen    := ( Select( "SM0" ) > 0 )
            IF ( lOpen )
                BREAK
            EndIF    

            Sleep( 500 )

        End Whilke

        //"Atenção"###"Problema na abertura do arquivo de Empresa"
        Final( STR0001 , STR0034 )

    END SEQUENCE

Return( lOpen )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³UpdMakeLog     ³Autor³Marinaldo de Jesus  ³ Data ³23/02/2012³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Montar o LOG do processo de Update                            ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³Generico                                                      ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
User Function UpdMakeLog(aUPDLog,aLogTitle,cTitulo)
IF IsInCallStack("U_NDJUpdDic")
    Return(MakeLog(@aUPDLog,@aLogTitle,@cTitulo))
Else
    Return(.F.)
EndIF

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³MakeLog        ³Autor³Marinaldo de Jesus  ³ Data ³23/02/2012³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Montar o LOG do processo de Update                            ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³Generico                                                      ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function MakeLog(aUPDLog,aLogTitle,cTitulo)

    aEval( aUPDLog[1]    , { |cLog,nAT| aUPDLog[1][nAT] := OemToAnsi( cLog ) } )
    aEval( aLogTitle      , { |cLog,nAT| aLogTitle[nAT]  := OemToAnsi( cLog ) } )

    fMakeLog(    @aUPDLog,                                ;//Array que contem os Detalhes de Ocorrencia de Log
                @aLogTitle,                                ;//Array que contem os Titulos de Acordo com as Ocorrencias
                NIL,                                    ;//Pergunte a Ser Listado
                .T.,                                    ;//Se Havera "Display" de Tela
                CriaTrab( NIL , .F. ),                    ;//Nome Alternativo do Log
                OemToAnsi( cTitulo + " " + STR0035 ),    ;//Titulo Alternativo do Log ###"Log de Atualização"
                "G",                                    ;//Tamanho Vertical do Relatorio de Log ("P","M","G")
                "L",                                    ;//Orientacao do Relatorio ("P" Retrato ou "L" Paisagem )
                NIL,                                    ;//Array com a Mesma Estrutura do aReturn
                .F.                                        ;//Se deve Manter ( Adicionar ) no Novo Log o Log Anterior
          )

    aSize( aUPDLog , 0 )
    aSize( aLogTitle , 0 )

Return(.T.)

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³EraseIndexes   ³Autor³Marinaldo de Jesus  ³ Data ³23/02/2012³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Apaga os Indices Locais                                        ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³Generico                                                      ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function EraseIndexes()

    Local aFiles
    Local aIndexExt    := { ".cdx" , ".ntx" , ".ndx" , ".mdx"  , ".idx" , IndexExt() , OrdBagExt() }

    Local cFile

    Local nFile
    Local nFiles

    Local nIndex
    Local nIndexes    := Len( aIndexExt )

    For nIndex := 1 To nIndexes
        aFiles := Directory( "*" + aIndexExt[ nIndex ] )
        nFiles := Len( aFiles )
        For nFile := 1 To nFiles
            cFile := aFiles[nFile][1]
            IF ( File( cFile ) )
                fErase( cFile )    
            EndIF
        Next nFiles
    Next nIndex

Return( NIL )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³UpdSetEnv      ³Autor³Marinaldo de Jesus  ³ Data ³23/02/2012³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Preparacao do Ambiente                                        ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³Generico                                                      ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function UpdSetEnv( cEmp , cFil )

    RpcSetType( 3 )
    RpcSetEnv( cEmp , cFil )

    InitPublic()
    SetsDefault()
    SetModulo( "SIGAESP" , "ESP" )

    lMsFinalAuto    := .F.
    lMsHelpAuto        := .F.

    __lPYME         := .F.
    __cInternet        := NIL

    #IFDEF TOP
        TCInternal( 5, "*OFF" ) // Desliga Refresh no Lock do Top
    #ENDIF

Return( NIL )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        lRecursa := __Dummy( .F. )
        SYMBOL_UNUSED( __cCRLF )
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
