#include "totvs.ch"
#include "tbiconn.ch"
#include "dbstruct.ch"
#include "tryexception.ch"       

Static _cSM0F3Ret

//------------------------------------------------------------------------------------------------------
    /*
        Programa:SRD2RHS.PRW
        Funcao:U_SRD2RHS()
        Autor:Marinaldo de Jesus [BlackTDN:(http://blacktdn.com.br/)]
        Data:22/01/2015
        Uso:Popular a Tabela RHS (Histórico de Plano de Saúde) com os dados da tabela SRD
        Tabelas:RHS(R/W),SM0(R),SRA(R),SRD(R),RHK(R),RHL(R),RHM(R) 
        Campos:RHS(*)
    */
//------------------------------------------------------------------------------------------------------
User Function SRD2RHS()

	Local cTitle:=OemToAnsi("Atualização Histórico Plano de Saúde/Odontológico (RHS) : [AJUSTE DIRF ANUAL]")
	Local cModName:="SIGAGPE"
	
	Local bExec:={||SRD2RHS(cTitle)}
	
	Local lMenu:=.F.
	Local lSchedule:=.F.

	Local bWindowInit
	Local lMainWnd

    Private lPrepEnv:=.NOT.(Type("cEmpAnt")=="C")

	BEGIN SEQUENCE

	    //------------------------------------------------------------------------------------------------------
	        //Verifica se Devera abrir o arquivo de Empresas
	    //------------------------------------------------------------------------------------------------------
	    IF (lPrepEnv)
		    //------------------------------------------------------------------------------------------------------
		        //Tenta abrir a tabela de Empresas
		    //------------------------------------------------------------------------------------------------------
			MsAguarde({||lSM0Open:=MyOpenSM0(.T.)},"Abrindo Cadastro de Empresas","Aguarde...")
		    //------------------------------------------------------------------------------------------------------
		        //Se não consegiu...
		    //------------------------------------------------------------------------------------------------------
		   	IF .NOT.(lSM0Open)
			    //------------------------------------------------------------------------------------------------------
			        //...Abandona
			    //------------------------------------------------------------------------------------------------------
	    		BREAK
	    	EndIF
	    EndIF	

		DEFAULT cTitle:=OemToAnsi("Atualização Histórico Plano de Saúde/Odontológico (RHS)")
		DEFAULT bExec:={||SRD2RHS(cTitle)}
		DEFAULT lMenu:=.F.
		DEFAULT lSchedule:=.F.

		__SetCentury("on")

		lMainWnd:=(Type("oMainWnd")=="O")
		lSchedule:=IF(lMainWnd,.F.,lSchedule)

		IF (;
				.NOT.(lMainWnd);
				.and.;
				.NOT.(lSchedule);
			)	

			Private oMainWnd
			Private oMsgItem0
			Private oMsgItem1
			Private oMsgItem2
			Private oMsgItem3
			Private oMsgItem4
		
			MsApp():New(cModName)
			oApp:CreateEnv()

			bWindowInit:=bExec
	        
			DEFINE WINDOW oMainWnd FROM 001,001 TO 400,500 TITLE OemToAnsi(cTitle)

				oMainWnd:oMsgBar:=TMsgBar():New(oMainWnd,Space(2)+OemToAnsi(GetVersao()),.F.,.F.,.F.,.F.,RGB(116,116,116),,,.F.,"fw_rodape_logo")
				oApp:oMainWnd:=oMainWnd
				
				IF (Type("oApp:lShortCut")=="L")
					oApp:lShortCut:=.F.
				EndIF	
				
				oApp:lFlat:=.F.
				
				IF (Type("oApp:lMenu")=="L")
					oApp:lMenu:=lMenu
				Else
					lMenu:=.F.
				EndIF	
				
				DEFINE MSGITEM oMsgItem0 OF oMainWnd:oMsgBar PROMPT ""             SIZE 100 ACTION GetSDIInfo()
				DEFINE MSGITEM oMsgItem1 OF oMainWnd:oMsgBar PROMPT oApp:dDataBase SIZE 100 ACTION GetSDIInfo()
				DEFINE MSGITEM oMsgItem2 OF oMainWnd:oMsgBar PROMPT ""	           SIZE 100 ACTION GetSDIInfo()
				DEFINE MSGITEM oMsgItem3 OF oMainWnd:oMsgBar PROMPT ""	           SIZE 100 ACTION GetSDIInfo()
				DEFINE MSGITEM oMsgItem4 OF oMainWnd:oMsgBar PROMPT "Ambiente"     SIZE 100 ACTION GetSDIInfo()

		 	ACTIVATE WINDOW oMainWnd MAXIMIZED ON INIT (Eval(bWindowInit),oMainWnd:End())

		 	Break

		EndIF

		IF (;
				.NOT.(lMainWnd);
				.or.;
				.NOT.(lSchedule);
			)	
			Break
		EndIF

		Eval(bExec)

	END SEQUENCE

Return(NIL)

//------------------------------------------------------------------------------------------------------
    /*
        Programa:SRD2RHS.PRW
        Funcao:SRD2RHS()
        Autor:Marinaldo de Jesus [BlackTDN:(http://blacktdn.com.br/)]
        Data:22/01/2015
        Uso:Popular a Tabela RHS (Histórico de Plano de Saúde) com os dados da tabela SRD
        Tabelas:RHS(R/W),SM0(R),SRA(R),SRD(R),RHK(R),RHL(R),RHM(R) 
        Campos:RHS(*)
    */
//------------------------------------------------------------------------------------------------------
Static Procedure SRD2RHS(cTitle)

    Local aSM0Area
    Local aTSM0Area
    Local aEmpresas
    
    Local bExec
    
    Local cEmp
    Local cFil
    Local cLogT
    Local cAlias
    Local cEmpresas
    Local cSvEmpAnt
    Local cSvFilAnt
    
    Local lSM0Open:=.F.
    
    Local nEmpresa
    Local nEmpresas
    Local nRecCount:=0
    
    Local oLog

    //------------------------------------------------------------------------------------------------
        //Define Objeto que conterá o Retorno da ParamBox
    //------------------------------------------------------------------------------------------------
    Local oPergunte:=tHash():New()

    Local oProcess
    Local oException     
    
    //------------------------------------------------------------------------------------------------------
        //Informa a funcao de Execucao interna qual sera o nome atribuido ao processo
    //------------------------------------------------------------------------------------------------------
    Private cCadastro:=cTitle

    //------------------------------------------------------------------------------------------------------
        //Salva Empresa/Filial Corrente
    //------------------------------------------------------------------------------------------------------
    IF .NOT.(lPrepEnv)
    	cSvEmpAnt:=cEmpAnt
    	cSvFilAnt:=cFilAnt
    EndIF 	
    
    BEGIN SEQUENCE 

	    //------------------------------------------------------------------------------------------------------
	        //Se não confirmar as perguntas....
	    //------------------------------------------------------------------------------------------------------
		IF .NOT.(Pergunte(@oPergunte))
		    //------------------------------------------------------------------------------------------------------
		        //Aborta o Processo
		    //------------------------------------------------------------------------------------------------------
			BREAK
    	EndIF
	    
	    //------------------------------------------------------------------------------------------------------
	        //Salva ambiente para Tabela de Empresas
	    //------------------------------------------------------------------------------------------------------
	    IF (Select("SM0")>0)
	        aSM0Area:=SM0->(GetArea())
	    EndIF

	    //------------------------------------------------------------------------------------------------------
	        //Seleciona As Empresas a serem Processadas
	    //------------------------------------------------------------------------------------------------------
		cEmpresas:=SM0Opcoes()
		aEmpresas:=_StrToKArr(cEmpresas,",")

	    //------------------------------------------------------------------------------------------------------
	        //Processa para Todas as Empresas Selecionadas
	    //------------------------------------------------------------------------------------------------------
	    nEmpresas:=Len(aEmpresas)
	    For nEmpresa:=1 To nEmpresas
	    
		    //------------------------------------------------------------------------------------------------------
		        //Instancia um novo Objeto do Tipo tLogReport
		    //------------------------------------------------------------------------------------------------------
		    oLog:=tLogReport():New()
	        //------------------------------------------------------------------------------------------------
	            //Inicializa Hash que armazenara informações de LOG
	        //------------------------------------------------------------------------------------------------
	        oLog:AddGroup("INCLUSÃO")
	        oLog:AddGroup("ALTERAÇÃO")
	
		    //------------------------------------------------------------------------------------------------------
		        //Obtem a Empresa
		    //------------------------------------------------------------------------------------------------------
	    	cEmp:=aEmpresas[nEmpresa]
	    	IF .NOT.(SM0->(dbSeek(cEmp,.F.)))
	    		Loop	    		
	    	EndIF
		    //------------------------------------------------------------------------------------------------------
		        //Obtem a Filial
		    //------------------------------------------------------------------------------------------------------
	    	cFil:=SM0->M0_CODFIL
	
	        //------------------------------------------------------------------------------------------------------
	            //Redefine o modo de Consumo de Lincença
	        //------------------------------------------------------------------------------------------------------
	        RPCSetType(3)
	
	        //------------------------------------------------------------------------------------------------------
	            //PREPARA AMBIENTE PARA EXECUÇÃO
	        //------------------------------------------------------------------------------------------------------
	        IF (lPrepEnv)
	        	PREPARE ENVIRONMENT EMPRESA (cEmp) FILIAL (cFil) MODULO "GPE" TABLES "RHS","SRA","SRD","RHK","RHL","RHM" 
	        EndIF
	        
	            //------------------------------------------------------------------------------------------------------
	                //Redefine o modo Blind
	            //------------------------------------------------------------------------------------------------------
	            IF IsBlind()
	                __cInternet:=NIL
	            EndIF           
	
	            //------------------------------------------------------------------------------------------------------
	                //Define Bloco de Codigo para a Execucao do Processo de Importacao
	            //------------------------------------------------------------------------------------------------------
	            bExec:={|lEnd,oProcess|ProcRedefine(@oProcess,NIL,0,450,450,.T.,.T.),oProcess:SetRegua1(@nRecCount),SRD2RHSProc(@oProcess,@oLog,@oPergunte)}
	
	            //------------------------------------------------------------------------------------------------------
	                //Garante o Posicionamento da tabela SM0
	            //------------------------------------------------------------------------------------------------------
	            SM0->(dbSetOrder(1))
	            SM0->(MsSeek(cEmp+cFil,.F.))
	            aTSM0Area:=SM0->(GetArea())
	
	            //-------------------------------------------------------------------------------------
	                //Obtem o total de registros a serem processados
	            //-------------------------------------------------------------------------------------
	            dbSelectArea("SM0")
	            COUNT TO nRecCount FOR SM0->M0_CODIGO=cEmpAnt WHILE SM0->M0_CODIGO=cEmpAnt REST
	            
	            //-------------------------------------------------------------------------------------
	                //Garante Posicionamento na SM0 depois do comando Count
	            //-------------------------------------------------------------------------------------
	            RestArea(aTSM0Area)
	            
	            //------------------------------------------------------------------------------------------------------
	                //Instancia um novo objeto para o controle de Processamento visual
	            //------------------------------------------------------------------------------------------------------
	            oProcess:=MsNewProcess():New(bExec,OemToAnsi("Importação de Dados para RHS"),"Importando...",.T.)
	
	            //------------------------------------------------------------------------------------------------------
	                //Ativa e executa o processo
	            //------------------------------------------------------------------------------------------------------
	            oProcess:Activate()            
	                                    
	            //------------------------------------------------------------------------------------------------------
	                //No retorno do processo, se interface nao tiver sido finalizada ...
	            //------------------------------------------------------------------------------------------------------
	            IF .NOT.(oProcess:lEnd)
	                //------------------------------------------------------------------------------------------------------
	                    //...Finaliza-a
	                //------------------------------------------------------------------------------------------------------
	                oProcess:oDlg:End()
	            EndIF
	            
	            //------------------------------------------------------------------------------------------------------
	                //Se o objeto nao foi finalizado...
	            //------------------------------------------------------------------------------------------------------
	            IF (ValType(oProcess)=="O")
	                //------------------------------------------------------------------------------------------------------
	                    //...Finaliza-o
	                //------------------------------------------------------------------------------------------------------
	                oProcess:=FreeObj(oProcess)
	            EndIF
	                    
	            //------------------------------------------------------------------------------------------------
	                //Se existirem informações de LOG...
	            //------------------------------------------------------------------------------------------------
				cLogT:="LOG: "+cCadastro
	           	TRY EXCEPTION
	           		oLog:PrintDialog(cLogT)
	            CATCH EXCEPTION
	            	ApMsgAlert(CaptureError())
	   			END EXCEPTION
	            oLog:=oLog:FreeObj()
	
	        //------------------------------------------------------------------------------------------------------
	            //Libera o Ambiente
	        //------------------------------------------------------------------------------------------------------
	        IF (lPrepEnv)
	        	RESET ENVIRONMENT
	        EndIF

		    //------------------------------------------------------------------------------------------------------
		        //Verifica se Devera abrir o arquivo de Empresas
		    //------------------------------------------------------------------------------------------------------
		    IF (lPrepEnv)
			    //------------------------------------------------------------------------------------------------------
			        //Tenta abrir a tabela de Empresas
			    //------------------------------------------------------------------------------------------------------
				MsAguarde({||lSM0Open:=MyOpenSM0(.T.)},"Abrindo Cadastro de Empresas","Aguarde...")
			    //------------------------------------------------------------------------------------------------------
			        //Se não consegiu...
			    //------------------------------------------------------------------------------------------------------
			   	IF .NOT.(lSM0Open)
				    //------------------------------------------------------------------------------------------------------
				        //...Abandona
				    //------------------------------------------------------------------------------------------------------
		    		BREAK
		    	EndIF
		    EndIF
		    
		Next nEmpresa      
	        	
    
    END SEQUENCE
    
    //------------------------------------------------------------------------------------------------------
        //Restauras ambiente para Tabela de Empresas
    //------------------------------------------------------------------------------------------------------
    IF .NOT.(Empty(aSM0Area))
        RestArea(aSM0Area)
    EndIF

    //------------------------------------------------------------------------------------------------------
        //Restaura Empresa/Filial Corrente
    //------------------------------------------------------------------------------------------------------
    IF .NOT.(lPrepEnv)
    	cEmpAnt:=cSvEmpAnt
    	cFilAnt:=cSvFilAnt
    EndIF 	
    
Return(NIL)

Return

//------------------------------------------------------------------------------------------------------
    /*
        Programa:SRD2RHS.PRW
        Função:SRD2RHSProc()
        Autor:Marinaldo de Jesus [BlackTDN:(http://blacktdn.com.br/)]
        Data:22/01/2015
        Uso:Popular a Tabela RHS (Histórico de Plano de Saúde) com os dados da tabela SRD
    */
//------------------------------------------------------------------------------------------------------
Static Procedure SRD2RHSProc(oProcess,oLog,oPergunte)

    Local cEmp:=cEmpAnt
    Local cFil:=cFilAnt
    Local cYear:=oPergunte:Get("Competência")

    //------------------------------------------------------------------------------------------------------
        //Obtem um Alias válido para EmbeddedSQL
    //------------------------------------------------------------------------------------------------------
    Local cAlias:=GetNextAlias()
    
    //------------------------------------------------------------------------------------------------------
        //Salva o Conteúdo de cFilAnt
    //------------------------------------------------------------------------------------------------------
    Local cSvFilAnt:=cFilAnt
    
    Local nRecCount
    
    //------------------------------------------------------------------------------------------------------
        //Processa para Todas as Filiais
    //------------------------------------------------------------------------------------------------------
    While SM0->(.NOT.(Eof()).and.M0_CODIGO==cEmp)
        //------------------------------------------------------------------------------------------------------
            //Incrementa Regua de Processamento
        //------------------------------------------------------------------------------------------------------
        SM0->(oProcess:IncRegua1("["+M0_CODIGO+"]["+M0_CODFIL+"]["+M0_FILIAL+"]"))
        //------------------------------------------------------------------------------------------------------
            //Redefine a Filial Corrente
        //------------------------------------------------------------------------------------------------------
        cFil:=SM0->M0_CODFIL
        RpcSetEnv(cEmp,cFil)
        //------------------------------------------------------------------------------------------------------
            //Redefine o modo de Consumo de Lincença
        //------------------------------------------------------------------------------------------------------
        RPCSetType(3)
        //------------------------------------------------------------------------------------------------------
            //Redefine cFilAnt
        //------------------------------------------------------------------------------------------------------
        cFil:=SM0->M0_CODFIL
        cFilAnt:=cFil
        //------------------------------------------------------------------------------------------------------
            //Obtem os Dados para Processamento
        //------------------------------------------------------------------------------------------------------
        MsAguarde({||nRecCount:=QueryView(@cAlias,@cYear)},"Obtendo dados no SGBD","Aguarde...")
        //------------------------------------------------------------------------------------------------------
            //Verifica se Existem Itens a serem processados
        //------------------------------------------------------------------------------------------------------
        IF (nRecCount>0)
            //------------------------------------------------------------------------------------------------------
                //Define o Valor para a 2 Regua de Processamento
            //------------------------------------------------------------------------------------------------------
            oProcess:SetRegua2(nRecCount)
            //------------------------------------------------------------------------------------------------------
                //Processa a Atualização
            //------------------------------------------------------------------------------------------------------
            UPDSRD2RHS(@cAlias,@oProcess,@oLog)
        EndIF
        //------------------------------------------------------------------------------------------------------
            //Proxima Filial
        //------------------------------------------------------------------------------------------------------
        SM0->(dbSkip())
    End While

    //------------------------------------------------------------------------------------------------------
        //Restaura o Conteúdo de cFilAnt
    //------------------------------------------------------------------------------------------------------
    cFil:=cSvFilAnt
    //------------------------------------------------------------------------------------------------------
        //Reseta o Ambiente
    //------------------------------------------------------------------------------------------------------
    RpcSetEnv(cEmp,cFil)
    //------------------------------------------------------------------------------------------------------
        //Restaura o Conteúdo de cFilAnt
    //------------------------------------------------------------------------------------------------------
    cFilAnt:=cFil
    //------------------------------------------------------------------------------------------------------
        //Garante o Posicionamento no Cadastro de Empresas
    //------------------------------------------------------------------------------------------------------
    SM0->(MsSeek(cEmp+cFil,.F.))
  
Return 

//------------------------------------------------------------------------------------------------------
    /*
        Programa:SRD2RHS.PRW
        Função:UPDSRD2RHS()
        Autor:Marinaldo de Jesus [BlackTDN:(http://blacktdn.com.br/)]
        Data:22/01/2015
        Uso:Popular a Tabela RHS (Histórico de Plano de Saúde) com os dados da tabela SRD
    */
//------------------------------------------------------------------------------------------------------
Static Procedure UPDSRD2RHS(cAlias,oProcess,oLog)
    
    //------------------------------------------------------------------------------------------------------
        //Obtem a estrutura da Tabela de Origem dos Dados
    //------------------------------------------------------------------------------------------------------
    Local aFSource:=(cAlias)->(dbStruct())
    //------------------------------------------------------------------------------------------------------
        //Obtem a estrutura da Tabela de Destino dos Dados
    //------------------------------------------------------------------------------------------------------
    Local aFTarget:=RHS->(dbStruct())
    Local aIFields:=Array(0)
    Local aRHSKeyExp
    
    Local cField
    Local cFType 
    Local cRANome     
    //------------------------------------------------------------------------------------------------------
        //Obtem a Expressao da Chave de Indice para a tabela RHS
    //------------------------------------------------------------------------------------------------------
    Local cRHSKeyExp:="RHS_FILIAL+RHS_MAT+RHS_COMPPG+RHS_ORIGEM+RHS_CODIGO+RHS_TPLAN+RHS_TPFORN+RHS_CODFOR+RHS_TPPLAN+RHS_PLANO+RHS_PD"
    Local cRHSKeyVal
    Local cRHSKeySeek
    
    Local nField
    Local nFields:=Len(aFSource)
    Local nKFields
    Local nATFieldS
    Local nATFieldT

    //------------------------------------------------------------------------------------------------------
        //Obtem a Ordem a ser utilizada na Pesquisa da Tabela SRA
    //------------------------------------------------------------------------------------------------------
    Local nSRAOrder:=RetOrder("SRA","RA_FILIAL+RA_MAT")
    
    //------------------------------------------------------------------------------------------------------
        //Obtem a Ordem a ser utilizada na Pesquisa da tabela RHS
    //------------------------------------------------------------------------------------------------------
    Local nRHSOrder:=RetOrder("RHS",cRHSKeyExp)
    
    Local lFound
    Local lAddNew
    
    Local xValue
    
    //------------------------------------------------------------------------------------------------------
        //Obtem os Campos para composição da Chave de Pesquisa
    //------------------------------------------------------------------------------------------------------
    aRHSKeyExp:=StrToKArr(cRHSKeyExp,"+")
    nKFields:=Len(aRHSKeyExp)

    //------------------------------------------------------------------------------------------------------
        //Obtem a Relação entre os Campos de Origem e Destino
    //------------------------------------------------------------------------------------------------------
    For nField:=1 To nFields
        //------------------------------------------------------------------------------------------------------
            //Obtem a posição do Campo de Origem
        //------------------------------------------------------------------------------------------------------
        nATFieldS:=nField
        //------------------------------------------------------------------------------------------------------
            //Obtem a posição do Campo de Destino
        //------------------------------------------------------------------------------------------------------
        cField:=aFSource[nField][DBS_NAME]
        nATFieldT:=aScan(aFTarget,{|aField|(aField[DBS_NAME]==cField)})
        //------------------------------------------------------------------------------------------------------
            //Se encontrou o Campo nas Duas Tabelas...
        //------------------------------------------------------------------------------------------------------
        IF ((nATFieldS>0).and.(nATFieldT>0))
            //------------------------------------------------------------------------------------------------------
                //...Adiciona-os para que sejam utilizados durante o processo de atualização
            //------------------------------------------------------------------------------------------------------
            aAdd(aIFields,{nATFieldS,nATFieldT})
        EndIF    
    Next nField
    
    //------------------------------------------------------------------------------------------------------
        //Obtem a quantidade de Campos a serem atualizados conforme Relacionamento
    //------------------------------------------------------------------------------------------------------
    nFields:=Len(aIFields)

    //------------------------------------------------------------------------------------------------------
        //Se ocorreu, ao menos um, relacionamento...
    //------------------------------------------------------------------------------------------------------
    IF (nFields>0)
        //------------------------------------------------------------------------------------------------------
            //Seta a Ordem para Pesquisa dos Dados
        //------------------------------------------------------------------------------------------------------
        RHS->(dbSetOrder(nRHSOrder))    
        //------------------------------------------------------------------------------------------------------
            //...Processa todos os registros
        //------------------------------------------------------------------------------------------------------
        While (cAlias)->(.NOT.(Eof()))
            //------------------------------------------------------------------------------------------------------
                //Obtem o Nome do Funcionario
            //------------------------------------------------------------------------------------------------------
            cRANome:=(cAlias)->(Posicione("SRA",nSRAOrder,RHS_FILIAL+RHS_MAT,"RA_NOME"))
            //------------------------------------------------------------------------------------------------------
                //Obtem o Valor para Pesquisa
            //------------------------------------------------------------------------------------------------------
            cRHSKeyVal:=""
            For nField:=1 To nKFields
                cField:=aRHSKeyExp[nField]
                xValue:=(cAlias)->(&cField)
                cFType:=ValType(xValue)
                DO CASE
                    CASE (cFType=="D")
                        xValue:=DtoS(xValue)
                    OTHERWISE
                        xValue:=cValToChar(xValue)
                END CASE        
                cRHSKeyVal+=xValue
            Next nField        
            //------------------------------------------------------------------------------------------------------
                //Define a chave para Pesquisa 
            //------------------------------------------------------------------------------------------------------
            cRHSKeySeek:=cRHSKeyVal
            //------------------------------------------------------------------------------------------------------
                //Verifica se o Registro existe
            //------------------------------------------------------------------------------------------------------
            lFound:=RHS->(dbSeek(cRHSKeySeek,.F.))
            //------------------------------------------------------------------------------------------------------
                //Se não existir chave correspondente, Define a Adição de uma nova
            //------------------------------------------------------------------------------------------------------
            lAddNew:=.NOT.(lFound)
            //------------------------------------------------------------------------------------------------------
                //Inicia a Transação
            //------------------------------------------------------------------------------------------------------
            BEGIN TRANSACTION
                //------------------------------------------------------------------------------------------------------
                    //Tenta Obter o Lock do Registro
                //------------------------------------------------------------------------------------------------------
                IF RHS->(RecLock("RHS",lAddNew))
                    //------------------------------------------------------------------------------------------------------
                        //Atualiza os Campos da tabela RHS
                    //------------------------------------------------------------------------------------------------------
                    For nField:=1 To nFields
                        //------------------------------------------------------------------------------------------------------
                            //Obtem a Posição do Campo de Origem
                        //------------------------------------------------------------------------------------------------------
                        nATFieldS:=aIFields[nField][1]
                        //------------------------------------------------------------------------------------------------------
                            //Obtem a Posição do Campo de Destino
                        //------------------------------------------------------------------------------------------------------
                        nATFieldT:=aIFields[nField][2]
                        //------------------------------------------------------------------------------------------------------
                            //Obtem Valor do Campo na Origem
                        //------------------------------------------------------------------------------------------------------
                        xValue:=(cAlias)->(FieldGet(nATFieldS))
                        //------------------------------------------------------------------------------------------------------
                            //Atualiza Campo correspondente no Destino
                        //------------------------------------------------------------------------------------------------------
                        RHS->(FieldPut(nATFieldT,xValue))
                    Next nField
                    //------------------------------------------------------------------------------------------------------
                        //Libera o Lock do Registro
                    //------------------------------------------------------------------------------------------------------
                    RHS->(MsUnLock())
                    //-------------------------------------------------------------------------------------
                        //...Define o Grupo do LOG
                    //-------------------------------------------------------------------------------------
                    cLogT:=IF(lAddNew,"INCLUSÃO","ALTERAÇÃO")
                    //-------------------------------------------------------------------------------------
                        //...Adiciona informação ao LOG
                    //-------------------------------------------------------------------------------------
                    (cAlias)->(oLog:AddDetail(cLogT,"Filial:["+RHS_FILIAL+"] Matricula:["+RHS_MAT+"] Nome:["+cRANome+"] Registro:["+Transform(RHS->(RecNo()),"999999999999999999")+"]"))
                EndIF     
            END TRANSACTION
            //------------------------------------------------------------------------------------------------------
                //Incrementa Regua de Processamento
            //------------------------------------------------------------------------------------------------------
            oProcess:IncRegua2("["+RHS_MAT+"]["+cRANome+"]")
            //------------------------------------------------------------------------------------------------------
                //Proximo registro
            //------------------------------------------------------------------------------------------------------
            (cAlias)->(dbSkip())
        End While
    EndIF        

Return

//------------------------------------------------------------------------------------------------------
    /*
        Programa:SRD2RHS.PRW
        Função:QueryView()
        Autor:Marinaldo de Jesus [BlackTDN:(http://blacktdn.com.br/)]
        Data:22/01/2015
        Uso:Popular a Tabela RHS (Histórico de Plano de Saúde) com os dados da tabela SRD
    */
//------------------------------------------------------------------------------------------------------
Static Function QueryView(cAlias,cYear)

    Local cExpYear:=(cYear+"%")
    
    Local nRecCount:=0
    
    Local oException
    
    DEFAULT cAlias:=GetNextAlias()

    //-------------------------------------------------------------------------------------
        //Garante que o Alias, para EmbeddedSQL, não esteja em uso
    //-------------------------------------------------------------------------------------
    IF (Select(cAlias)>0)
        (cAlias)->(dbCloseArea())
    EndIF
    
    //-------------------------------------------------------------------------------------
        //Prepara cExpYear para EmbeddedSQL
    //-------------------------------------------------------------------------------------
    cExpYear:="%'"+cExpYear+"'%"
    
    TRY EXCEPTION

        //-------------------------------------------------------------------------------------
            //Elabora View, usando EmbeddedSQL, com os dados a serem processados
        //-------------------------------------------------------------------------------------
        BEGINSQL ALIAS cAlias
            
            %noParser%
            
            COLUMN RHS_DATA     AS DATE
            COLUMN RHS_DATPGT   AS DATE
            
            SELECT   SRD.RD_FILIAL  AS RHS_FILIAL
                    ,SRD.RD_MAT     AS RHS_MAT
                    ,SRD.RD_DATPGT  AS RHS_DATA
                    ,'1'            AS RHS_ORIGEM
                    ,' '            AS RHS_CODIGO 
                    ,'1'            AS RHS_TPLAN        
                    ,RHK.RHK_TPFORN AS RHS_TPFORN
                    ,RHK.RHK_CODFOR AS RHS_CODFOR
                    ,RHK.RHK_TPPLAN AS RHS_TPPLAN
                    ,RHK.RHK_PLANO  AS RHS_PLANO
                    ,SRD.RD_PD      AS RHS_PD 
                    ,SRD.RD_VALOR   AS RHS_VLRFUN
                    ,0              AS RHS_VLREMP        
                    ,SRD.RD_DATARQ  AS RHS_COMPPG
                    ,SRD.RD_DATPGT  AS RHS_DATPGT
                    ,''             AS RHS_DTHRGR
                    ,'1'            AS RHS_TIPO 
            FROM %table:SRD% SRD 
            LEFT OUTER JOIN %table:SRA% SRA ON (
                                                    SRA.D_E_L_E_T_=SRD.D_E_L_E_T_ 
                                                AND SRA.RA_FILIAL=SRD.RD_FILIAL 
                                                AND SRA.RA_MAT=SRD.RD_MAT
            )
            RIGHT OUTER JOIN %table:RHK% RHK ON ( 
                                                    RHK.D_E_L_E_T_=SRD.D_E_L_E_T_ 
                                                AND RHK.RHK_FILIAL=SRD.RD_FILIAL
                                                AND RHK.RHK_MAT=SRD.RD_MAT
                                                AND SRD.RD_PD=RHK.RHK_PD
                                                AND SRD.RD_DATARQ>=RHK.RHK_PERINI
                                                AND (
                                                        CASE RHK.RHK_PERFIM
                                                        WHEN ' '
                                                        THEN 1
                                                        ELSE (
                                                                CASE WHEN (SRD.RD_DATARQ<=RHK.RHK_PERFIM) 
                                                                THEN 1 
                                                                ELSE 0 
                                                                END
                                                        )        
                                                        END                                                     
                                                )=1
            )
            WHERE SRD.%notDel%
              AND SRD.RD_FILIAL=%xFilial:SRD%
              AND SRD.RD_DATARQ LIKE %exp:cExpYear% 
              AND NOT EXISTS(
                                SELECT 1 
                                  FROM %table:RHS% RHS 
                                 WHERE RHS.D_E_L_E_T_=SRD.D_E_L_E_T_
                                   AND RHS.RHS_MAT=SRD.RD_MAT 
                                   AND RHS.RHS_FILIAL=SRD.RD_FILIAL
                                   AND RHS.RHS_COMPPG=SRD.RD_DATARQ
                                   AND RHS.RHS_PD=SRD.RD_PD
                                   AND RHS.RHS_ORIGEM='1'
            )   
            UNION ALL                    
            SELECT   SRD.RD_FILIAL  AS RHS_FILIAL
                    ,SRD.RD_MAT     AS RHS_MAT
                    ,SRD.RD_DATPGT  AS RHS_DATA
                    ,'2'            AS RHS_ORIGEM
                    ,RHL.RHL_CODIGO AS RHS_CODIGO 
                    ,'1'            AS RHS_TPLAN    
                    ,RHL.RHL_TPFORN AS RHS_TPFORN
                    ,RHL.RHL_CODFOR AS RHS_CODFOR
                    ,RHL.RHL_TPPLAN AS RHS_TPPLAN
                    ,RHL.RHL_PLANO  AS RHS_PLANO
                    ,SRD.RD_PD      AS RHS_PD 
                    ,(
                        CASE SRD.RD_PD 
                        WHEN RHK.RHK_PD
                        THEN SRD.RD_VALOR 
                        ELSE (
                                SRD.RD_VALOR / NULLIF((
                                                    SELECT COUNT(1) AS QTD 
                                                      FROM %table:RHM% RHM_C
                                                     WHERE RHM_C.D_E_L_E_T_=SRD.D_E_L_E_T_ 
                                                       AND RHM_C.RHM_FILIAL=SRD.RD_FILIAL
                                                       AND RHM_C.RHM_MAT=SRD.RD_MAT
                                ),0)
                        ) 
                        END
                    )               AS RHS_VLRFUN
                    ,0              AS RHS_VLREMP
                    ,SRD.RD_DATARQ  AS RHS_COMPPG
                    ,SRD.RD_DATPGT  AS RHS_DATPGT
                    ,''             AS RHS_DTHRGR
                    ,'1'            AS RHS_TIPO 
            FROM %table:SRD% SRD 
            LEFT OUTER JOIN %table:SRA% SRA ON (
                                                    SRA.D_E_L_E_T_=SRD.D_E_L_E_T_ 
                                                AND SRA.RA_FILIAL=SRD.RD_FILIAL 
                                                AND SRA.RA_MAT=SRD.RD_MAT  
            )
            RIGHT OUTER JOIN %table:RHK% RHK ON ( 
                                                    RHK.D_E_L_E_T_=SRD.D_E_L_E_T_ 
                                                AND RHK.RHK_FILIAL=SRD.RD_FILIAL
                                                AND RHK.RHK_MAT=SRD.RD_MAT
                                                AND SRD.RD_PD=RHK.RHK_PDDAGR
                                                AND SRD.RD_DATARQ>=RHK.RHK_PERINI
                                                AND (
                                                        CASE RHK.RHK_PERFIM
                                                        WHEN ' '
                                                        THEN 1
                                                        ELSE (
                                                                CASE WHEN (SRD.RD_DATARQ<=RHK.RHK_PERFIM) 
                                                                THEN 1 
                                                                ELSE 0 
                                                                END
                                                        )        
                                                        END                                                     
                                                )=1                                                
            )
            RIGHT OUTER JOIN %table:RHL% RHL ON ( 
                                                    RHL.D_E_L_E_T_=SRD.D_E_L_E_T_ 
                                                AND RHL.RHL_FILIAL=SRD.RD_FILIAL
                                                AND RHL.RHL_MAT=SRD.RD_MAT
                                                AND SRD.RD_DATARQ>=RHL.RHL_PERINI
                                                AND (
                                                        CASE RHL.RHL_PERFIM
                                                        WHEN ' '
                                                        THEN 1
                                                        ELSE (
                                                                CASE WHEN (SRD.RD_DATARQ<=RHL.RHL_PERFIM) 
                                                                THEN 1 
                                                                ELSE 0 
                                                                END
                                                        )        
                                                        END                                                     
                                                )=1
            )
            WHERE SRD.%notDel%
              AND SRD.RD_FILIAL=%xFilial:SRD%
              AND SRD.RD_DATARQ LIKE %exp:cExpYear% 
              AND NOT EXISTS(
                                SELECT 1 
                                  FROM %table:RHS% RHS 
                                 WHERE RHS.D_E_L_E_T_=SRD.D_E_L_E_T_
                                   AND RHS.RHS_MAT=SRD.RD_MAT 
                                   AND RHS.RHS_FILIAL=SRD.RD_FILIAL
                                   AND RHS.RHS_COMPPG=SRD.RD_DATARQ
                                   AND RHS.RHS_PD=SRD.RD_PD
                                   AND RHS.RHS_ORIGEM='2'
              ) 
            UNION ALL
            SELECT   SRD.RD_FILIAL  AS RHS_FILIAL
                    ,SRD.RD_MAT     AS RHS_MAT
                    ,SRD.RD_DATPGT  AS RHS_DATA
                    ,'3'            AS RHS_ORIGEM
                    ,RHM.RHM_CODIGO AS RHS_CODIGO
                    ,'1'            AS RHS_TPLAN        
                    ,RHM.RHM_TPFORN AS RHS_TPFORN
                    ,RHM.RHM_CODFOR AS RHS_CODFOR
                    ,RHM.RHM_TPPLAN AS RHS_TPPLAN
                    ,RHM.RHM_PLANO  AS RHS_PLANO
                    ,SRD.RD_PD      AS RHS_PD 
                    ,(
                        CASE SRD.RD_PD 
                        WHEN RHK.RHK_PD
                        THEN SRD.RD_VALOR 
                        ELSE (
                                SRD.RD_VALOR / NULLIF((
                                                    SELECT COUNT(1) AS QTD 
                                                      FROM %table:RHM% RHM_C 
                                                     WHERE RHM_C.D_E_L_E_T_=SRD.D_E_L_E_T_ 
                                                       AND RHM_C.RHM_FILIAL=SRD.RD_FILIAL
                                                       AND RHM_C.RHM_MAT=SRD.RD_MAT
                                ),0)
                        ) 
                        END
                    )               AS RHS_VLRFUN 
                    ,0              AS RHS_VLREMP        
                    ,SRD.RD_DATARQ  AS RHS_COMPPG
                    ,SRD.RD_DATPGT  AS RHS_DATPGT
                    ,''             AS RHS_DTHRGR
                    ,'1'            AS RHS_TIPO 
            FROM %table:SRD% SRD 
            LEFT OUTER JOIN %table:SRA% SRA ON (
                                                    SRA.D_E_L_E_T_=SRD.D_E_L_E_T_ 
                                                AND SRA.RA_FILIAL=SRD.RD_FILIAL 
                                                AND SRA.RA_MAT=SRD.RD_MAT  
            )
            RIGHT OUTER JOIN %table:RHK% RHK ON ( 
                                                    RHK.D_E_L_E_T_=SRD.D_E_L_E_T_ 
                                                AND RHK.RHK_FILIAL=SRD.RD_FILIAL
                                                AND RHK.RHK_MAT=SRD.RD_MAT
                                                AND SRD.RD_PD=RHK.RHK_PDDAGR
                                                AND SRD.RD_DATARQ>=RHK.RHK_PERINI
                                                AND (
                                                        CASE RHK.RHK_PERFIM
                                                        WHEN ' '
                                                        THEN 1
                                                        ELSE (
                                                                CASE WHEN (SRD.RD_DATARQ<=RHK.RHK_PERFIM) 
                                                                THEN 1 
                                                                ELSE 0 
                                                                END
                                                        )        
                                                        END                                                     
                                                )=1
            )
            RIGHT OUTER JOIN %table:RHM% RHM ON ( 
                                                    RHM.D_E_L_E_T_=SRD.D_E_L_E_T_ 
                                                AND RHM.RHM_FILIAL=SRD.RD_FILIAL
                                                AND RHM.RHM_MAT=SRD.RD_MAT
                                                AND SRD.RD_DATARQ>=RHM.RHM_PERINI
                                                AND (
                                                        CASE RHM.RHM_PERFIM
                                                        WHEN ' '
                                                        THEN 1
                                                        ELSE (
                                                                CASE WHEN (SRD.RD_DATARQ<=RHM.RHM_PERFIM) 
                                                                THEN 1 
                                                                ELSE 0 
                                                                END
                                                        )        
                                                        END                                                     
                                                )=1
            )
            WHERE SRD.%notDel%
              AND SRD.RD_FILIAL=%xFilial:SRD%
              AND SRD.RD_DATARQ LIKE %exp:cExpYear% 
              AND NOT EXISTS(
                                SELECT 1 
                                  FROM %table:RHS% RHS 
                                 WHERE RHS.D_E_L_E_T_=SRD.D_E_L_E_T_
                                   AND RHS.RHS_MAT=SRD.RD_MAT 
                                   AND RHS.RHS_FILIAL=SRD.RD_FILIAL
                                   AND RHS.RHS_COMPPG=SRD.RD_DATARQ
                                   AND RHS.RHS_PD=SRD.RD_PD
                                   AND RHS.RHS_ORIGEM='3'
              )             
            ORDER BY SRD.RD_FILIAL 
                    ,SRD.RD_MAT 
                    ,SRD.RD_DATARQ
                    ,SRD.RD_DATPGT
                    
        ENDSQL
        
        //-------------------------------------------------------------------------------------
            //Salva Query Statement
        //-------------------------------------------------------------------------------------
        IF .NOT.(IsBlind())
            MemoWrite(GetTempPath()+"QueryView_srd2rhs.sql",GetLastQuery()[2])
        EndIF

        //-------------------------------------------------------------------------------------
            //Garante que a Area de Trabalho será a da View
        //-------------------------------------------------------------------------------------
        dbSelectArea(cAlias)
        
        //-------------------------------------------------------------------------------------
            //Obtem o total de registros a serem processados
        //-------------------------------------------------------------------------------------
        COUNT TO nRecCount
        
        //-------------------------------------------------------------------------------------
            //Remonta a View
        //-------------------------------------------------------------------------------------
        (cAlias)->(dbGoTop())
    
    CATCH EXCEPTION USING oException

        //-------------------------------------------------------------------------------------
            //Salva o Erro
        //-------------------------------------------------------------------------------------
        IF (ValType(oException)=="O")
            IF .NOT.(IsBlind())
                MemoWrite(GetTempPath()+"QueryView_srd2rhs.sql",GetLastQuery()[2])
                MemoWrite(GetTempPath()+"QueryView_srd2rhs.err",CaptureError())
            EndIF
        EndIF

    END EXCEPTION
  
Return(nRecCount)

//------------------------------------------------------------------------------------------------------
    /*
        Programa:SRD2RHS.PRW
        Funcao:ProcRedefine
        Autor:Marinaldo de Jesus [BlackTDN:(http://blacktdn.com.br/)]
        Data:22/01/2015
    */
//------------------------------------------------------------------------------------------------------
Static Function ProcRedefine(oProcess,oFont,nLeft,nWidth,nCTLFLeft,lODlgF,lODlgW)
    Local aClassData
    Local laMeter
    Local nObj
    Local nMeter
    Local nMeters
    Local lProcRedefine:=.F.
    IF (ValType(oProcess)=="O")
        aClassData:=ClassDataArr(oProcess)
        laMeter:=(aScan(aClassData,{|e|e[1]=="AMETER"})>0)
        IF (laMeter)
            DEFAULT oFont:=TFont():New("Lucida Console",NIL,12,NIL,.T.)
            DEFAULT nLeft:=40
            DEFAULT nWidth:=95
            nMeters:=Len(oProcess:aMeter)
            For nMeter:=1 To nMeters
                For nObj:=1 To 2
                    oProcess:aMeter[nMeter][nObj]:oFont:=oFont
                    oProcess:aMeter[nMeter][nObj]:nWidth+=nWidth
                    oProcess:aMeter[nMeter][nObj]:nLeft-=nLeft
                Next nObj
            Next nMeter
        Else
            DEFAULT oFont:=TFont():New("Lucida Console",NIL,18,NIL,.T.)
            DEFAULT lODlgF:=.T.
            DEFAULT lODlgW:=.F.
            DEFAULT nLeft:=100
            DEFAULT nWidth:=200
            DEFAULT nCTLFLeft:=IF(lODlgW,nWidth,nWidth/2)
            IF (lODlgF)
                oProcess:oDlg:oFont:=oFont
            EndIF
            IF (lODlgW)
                oProcess:oDlg:nWidth+=nWidth
                oProcess:oDlg:nLeft-=(nWidth/2)
            EndIF
            oProcess:oMsg1:oFont:=oFont
            oProcess:oMsg2:oFont:=oFont
            oProcess:oMsg1:nLeft-=nLeft
            oProcess:oMsg1:nWidth+=nWidth
            oProcess:oMsg2:nLeft-=nLeft
            oProcess:oMsg2:nWidth+=nWidth
            oProcess:oMeter1:nWidth+=nWidth
            oProcess:oMeter1:nLeft-=nLeft
            oProcess:oMeter2:nWidth+=nWidth
            oProcess:oMeter2:nLeft-=nLeft
            IF (ValType(oProcess:oDlg:oCTLFocus)=="O")
                oProcess:oDlg:oCTLFocus:nLeft+=nCTLFLeft
            EndIF
            oProcess:oDlg:Refresh(.T.)
        EndIF
        lProcRedefine:=.T.
    EndIF
Return(lProcRedefine)

//-------------------------------------------------------------------------------------
    /*
        Programa:SRD2RHS.PRW
        Funcao:MyOpenSM0()
        Autor:Marinaldo de Jesus [BlackTDN:(http://blacktdn.com.br/)]
        Data:29/01/2015
        Desc.:Abrir a tabela de Cadastro de Empresas
    */
//-------------------------------------------------------------------------------------
Static Function MyOpenSM0(lShared)

    Local aRDDs:=Array(0)
    
    Local cMsgStop
    
    Local lOpenned:=.F.
    
    Local nLoop:=0
    
    Local nRDD
    Local nRDDS
    
    DEFAULT lShared:=.T.
        
    IF (Type("__LocalDriver")=="C")
        aAdd(aRDDs,__LocalDriver)
    EndIF    

    aAdd(aRDDs,"DBFCDXAX")
    aAdd(aRDDs,"DBFCDXADS")
    aAdd(aRDDs,"CTREECDX")
    aAdd(aRDDs,"BTVCDX")

    nRDDs:=Len(aRDDs)
    
    For nLoop:=1 To 20
        For nRDD:=1 To nRDDS
            cRDD:=aRDDs[nRDD]
            TRY EXCEPTION
                dbUseArea(.T.,cRDD,"SIGAMAT.EMP","SM0",lShared,.F.)
                lOpenned:=(Select("SM0")>0)
                IF (lOpenned)
                    SM0->(dbSetIndex("SIGAMAT.IND"))
                    EXIT
                EndIF
            CATCH EXCEPTION
                lOpenned:=.F.
            END EXCEPTION
        Next nRDD
        IF (lOpenned)
            EXIT
        EndIF
        Sleep(500)
    Next nLoop
    
    IF .NOT.(lOpenned)
    	cMsgStop:="Não foi possível a abertura da tabela "
        cMsgStop+=IF(lShared,"de empresas (SM0).","de empresas (SM0) de forma exclusiva.")
        MsgStop(cMsgStop,"ATENÇÃO")
    EndIF
    
Return(lOpenned)

//-------------------------------------------------------------------------------------
    /*
        Programa:SRD2RHS.PRW
        Funcao:SM0Opcoes()
        Autor:Marinaldo de Jesus [BlackTDN:(http://blacktdn.com.br/)]
        Data:29/01/2015
        Desc.:Programa para retornar Consulta Padrao "Específica" baseada em f_Opcoes
    */
//-------------------------------------------------------------------------------------
Static Function SM0Opcoes()

    //------------------------------------------------------------------------------------------------
        // Salva os Dados de Entrada que serao restaurados antes do Retorno do Procedimento
    //------------------------------------------------------------------------------------------------
    Local aArea:=GetArea()

    Local aOpcoes:=Array(0)

    //------------------------------------------------------------------------------------------------
        // Define o Titulo para f_Opcoes
    //------------------------------------------------------------------------------------------------
    Local cTitulo:=OemToAnsi("Consulta de Empresas")

    Local cSM0Cod:=""

    Local cF3Ret:=""
    Local cToken:=","
    Local cOpcoes:=""
    Local cCodRet:=""

    Local nD
    Local nJ

    //------------------------------------------------------------------------------------------------
        //Obtemo Tamanho da chave
    //------------------------------------------------------------------------------------------------
    Local nTamKey:=Len(SM0->M0_CODIGO)
    //------------------------------------------------------------------------------------------------
        //Calcula o Máximo de Elementos a serem Selecionados de Acordo com o Tamanho da Chave+Separador
    //------------------------------------------------------------------------------------------------
    Local nElemRet:=0
    //------------------------------------------------------------------------------------------------
        //Obtem a Ordem para Pesquisa dos Registros na SM0
    //------------------------------------------------------------------------------------------------
    Local nSM0Order:=1//M0_CODIGO+M0_CODFIL

    Local uVarRet                     

    //------------------------------------------------------------------------------------------------
        //Obtem o conteúdo do campo utilizado na Consulta Padrao Customizada
    //------------------------------------------------------------------------------------------------
    DEFAULT _cSM0F3Ret:=""

    //------------------------------------------------------------------------------------------------
        //Remove o Separador
    //------------------------------------------------------------------------------------------------
    uVarRet:=StrTran(_cSM0F3Ret,cToken,"")

    //------------------------------------------------------------------------------------------------
        //Define a Ordem para Pesquisa na Tabela SM0
    //------------------------------------------------------------------------------------------------
    SM0->(dbSetOrder(nSM0Order))
    SM0->(dbGoTop())

    //------------------------------------------------------------------------------------------------
        //Carrega as Opcoes para Consulta (Codigo e Nome)
    //------------------------------------------------------------------------------------------------
    While SM0->(.NOT.(Eof()))
        //------------------------------------------------------------------------------------------------
            //Verifica se elemento é Exclusivo
        //------------------------------------------------------------------------------------------------
        IF SM0->(UniqueKey({"M0_CODIGO"}))
		    //------------------------------------------------------------------------------------------------
		        //Calcula o Máximo de Elementos a serem Selecionados
		    //------------------------------------------------------------------------------------------------
            ++nElemRet
		    //------------------------------------------------------------------------------------------------
		        //Adiciona os Elementos para Selecao: Codigo+Descrição
		    //------------------------------------------------------------------------------------------------
            SM0->(aAdd(aOpcoes,M0_CODIGO+"-"+M0_NOME))
		    //------------------------------------------------------------------------------------------------
		        //Concatena as Chaves
		    //------------------------------------------------------------------------------------------------
            cOpcoes+=SM0->M0_CODIGO
        EndIF    
        //------------------------------------------------------------------------------------------------
            //Próximo Registro
        //------------------------------------------------------------------------------------------------
		SM0->(dbSkip())
    End While

    //------------------------------------------------------------------------------------------------
        //Executa f_Opcoes para Selecionar ou Mostrar os Registros Selecionados
    //------------------------------------------------------------------------------------------------
    IF f_Opcoes(    @uVarRet    ,;  //Variavel de Retorno
                    cTitulo     ,;  //Titulo da Coluna com as opcoes
                    @aOpcoes    ,;  //Opcoes de Escolha (Array de Opcoes)
                    @cOpcoes    ,;  //String de Opcoes para Retorno
                    NIL         ,;  //Nao Utilizado
                    NIL         ,;  //Nao Utilizado
                    .F.         ,;  //Se a Selecao sera de apenas 1 Elemento por vez
                    nTamKey     ,;  //Tamanho da Chave
                    nElemRet    ,;  //No maximo de elementos na variavel de retorno
                    .T.         ,;  //Inclui Botoes para Selecao de Multiplos Itens
                    .F.         ,;  //Se as opcoes serao montadas a partir de ComboBox de Campo ( X3_CBOX )
                    NIL         ,;  //Qual o Campo para a Montagem do aOpcoes
                    .F.         ,;  //Nao Permite a Ordenacao
                    .F.         ,;  //Nao Permite a Pesquisa
                    .F.         ,;  //Forca o Retorno Como Array
                    NIL	         ;  //Consulta F3
                  )
        //------------------------------------------------------------------------------------------------
            //Ajusta o Retorno caso exista o separador
        //------------------------------------------------------------------------------------------------
        IF (cToken$cOpcoes)
            aOpcoes:=_StrToKArr(uVarRet,cToken)
            uVarRet:=""
            aEval(aOpcoes,{uVarRet+=PadR(e,nTamKey)})
        EndIF
        //------------------------------------------------------------------------------------------------
            //Analisa o Retorno
        //------------------------------------------------------------------------------------------------
        nJ:=Len(uVarRet)
        For nD:=1 To nJ Step nTamKey
            //------------------------------------------------------------------------------------------------
                //Obtem o Codigo de Retorno Baseado no Tamanho da Chave
            //------------------------------------------------------------------------------------------------
             cCodRet:=SubStr(uVarRet,nD,nTamKey)
            //------------------------------------------------------------------------------------------------
                //Normaliza
            //------------------------------------------------------------------------------------------------
            cF3Ret+=PadR(cCodRet,nTamKey)
            //------------------------------------------------------------------------------------------------
                //Define o Retorno com o separador ","
            //------------------------------------------------------------------------------------------------
            IF (nD<nJ)
                cF3Ret+=cToken
            EndIF
        Next nD
    Else
        //------------------------------------------------------------------------------------------------
            //Se nao confirmou a f_Opcoes retorna o Conteudo de entrada
        //------------------------------------------------------------------------------------------------
        cF3Ret:=uVarRet
    EndIF

    //------------------------------------------------------------------------------------------------
        //Alimenta a variável Static para uso no Retorno da Consulta Padrao.
    //------------------------------------------------------------------------------------------------
    _cSM0F3Ret:=cF3Ret

    //------------------------------------------------------------------------------------------------
        //Restaura os Dados de Entrada
    //------------------------------------------------------------------------------------------------
    RestArea(aArea)

Return(cF3Ret)

//-------------------------------------------------------------------------------------
    /*
        Programa:SRD2RHS.PRW
        Funcao:_StrToKArr()
        Autor:Marinaldo de Jesus [BlackTDN:(http://blacktdn.com.br/)]
        Data:30/12/2014
        Desc.:Autorização para emissão de DOC/TED
        Uso:Impressão do Relatório Autorização para emissão de DOC/TED
    */
//-------------------------------------------------------------------------------------
Static Function _StrToKArr(cStr,cToken)
    Local cDToken
    DEFAULT cStr:=""
    DEFAULT cToken:=","
    cDToken:=(cToken+cToken)
    While (cDToken$cStr)
        cStr:=StrTran(cStr,cDToken,cToken+" "+cToken)
    End While
Return(StrToKArr(cStr,cToken))

//------------------------------------------------------------------------------------------------
    /*
        Programa:SRD2RHS.PRW
        Funcao:Pergunte()
        Autor:Marinaldo de Jesus [BlackTDN:(http://blacktdn.com.br/)]
        Data:29/01/2015
        Descricao:Parametros para seleção
    */
//------------------------------------------------------------------------------------------------
Static Function Pergunte(oPergunte)

    //------------------------------------------------------------------------------------------------
    Local aPBoxPrm:=Array(0)
    Local aPBoxRet:=Array(0)

    //------------------------------------------------------------------------------------------------
    
    Local cPBoxTit:=OemToAnsi("Informe os parâmetros")
    
    //------------------------------------------------------------------------------------------------

    Local cSizeYear

    //------------------------------------------------------------------------------------------------

    Local lParamBox:=.F.

    //------------------------------------------------------------------------------------------------

    Local nPBox

    //------------------------------------------------------------------------------------------------

    Local nSizeYear:=4

    //------------------------------------------------------------------------------------------------

    Local nGSizeYear:=nSizeYear+100

    //------------------------------------------------------------------------------------------------
    cSizeYear:=Space(nSizeYear)

    //------------------------------------------------------------------------------------------------
        //Carrega as Perguntas do Programa
    //------------------------------------------------------------------------------------------------
    aAdd(aPBoxPrm,Array(9))
    nPBox:=Len(aPBoxPrm)
    //01----------------------------------------------------------------------------------------------
    aPBoxPrm[nPBox][1]:=1               //[1]:1 - MsGet
    aPBoxPrm[nPBox][2]:="Competência"   //[2]:Descricao
    aPBoxPrm[nPBox][3]:=cSizeYear       //[3]:String contendo o inicializador do campo
    aPBoxPrm[nPBox][4]:="9999"			//[4]:String contendo a Picture do campo
    aPBoxPrm[nPBox][5]:="NaoVazio()"    //[5]:String contendo a validacao
    aPBoxPrm[nPBox][6]:=""		        //[6]:Consulta F3
    aPBoxPrm[nPBox][7]:="AllWaysTrue()" //[7]:String contendo a validacao When
    aPBoxPrm[nPBox][8]:=nGSizeYear      //[8]:Tamanho do MsGet
    aPBoxPrm[nPBox][9]:=.T.             //[9]:Flag .T./.F. Parametro Obrigatorio ?
    //------------------------------------------------------------------------------------------------
    aAdd(aPBoxPrm,Array(9))
    nPBox:=Len(aPBoxPrm)

    //------------------------------------------------------------------------------------------------
        //Carrega a Interface com o usuário
        //Parambox(aParametros,@cTitle,@aRet,[bOk],[aButtons],[lCentered],[nPosX],[nPosy],[oDlgWizard],[cLoad],[lCanSave],[lUserSave])
    //------------------------------------------------------------------------------------------------
    While (.NOT.(lParamBox:=ParamBox(@aPBoxPrm,@cPBoxTit,@aPBoxRet,NIL,NIL,.T.,NIL,NIL,NIL,NIL,.T.,.T.)))
        //------------------------------------------------------------------------------------------------
            //...Verifica se Deseja "Abortar" a Geração e...
        //------------------------------------------------------------------------------------------------
        lParamBox:=MsgYesNo("Deseja Abortar a Importação?","Atenção!")
        //------------------------------------------------------------------------------------------------
            //...Se optou por "Abortar" ...
        //------------------------------------------------------------------------------------------------
        IF (lParamBox)
            //------------------------------------------------------------------------------------------------
                //...Inverte o Estado de lParamBox ...
            //------------------------------------------------------------------------------------------------
            lParamBox:=.F.
            //------------------------------------------------------------------------------------------------
                //...Abandona.
            //------------------------------------------------------------------------------------------------
            EXIT
        EndIF
    End While

    //------------------------------------------------------------------------------------------------
        //Se confirmou ParamBox...
    //------------------------------------------------------------------------------------------------
    IF (lParamBox)
        //------------------------------------------------------------------------------------------------
            //...Processa cada elemento e...
        //------------------------------------------------------------------------------------------------
        For nPBox:=1 To Len(aPBoxPrm)
            //------------------------------------------------------------------------------------------------
                //...Carrega os Parâmetros/Conteúdos em oPergunte
            //------------------------------------------------------------------------------------------------
            oPergunte:Set(aPBoxPrm[nPBox][2],aPBoxRet[nPBox])
        Next nPBox
    EndIF

//------------------------------------------------------------------------------------------------
    //Retorna .T. se confirmou ParamBox, caso contrário: .F.
//------------------------------------------------------------------------------------------------
Return(lParamBox)