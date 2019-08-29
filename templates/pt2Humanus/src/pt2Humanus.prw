#include "totvs.ch"
#include "tbiconn.ch"
#xtranslate NToS([<n,...>]) => LTrim(Str([<n>]))
#define N_INCREMENT 1000
/*
    Programa:pt2Humanus.prw
    Autor: Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:09/12/2015
    Descricao: Migracao de Dados RH Protheus para SAP Humanus (LAYOUT Sistema Humanus:HISTFIN)
    Sintaxe:u_2Humanus
    Restricao:DB2
*/
user function 2Humanus()

    local cAlias:=GetNextAlias()

    local bM:={||lDBFFile:=MsgNoYes("Deseja Gerar Arquivo DBF para Conferencia dos dados Gerados em TXT?",cTitle)}
    local bQ:={||MsAguarde({||nTRecNo:=queryView(@cAlias,@cYear)},cProcT,cProcQ+cYear)}
    local bP:={||oProcess:Activate()}

    local bProc:={||Eval(bM),Eval(bQ),Eval(bP)}
    local bExec:={|lEnd,oProcess|ProcRedefine(@oProcess,NIL,0,425,425,.T.,.T.),copyTo(@oProcess,@cAlias,@nTRecNo,@lDBFFile,@cYear)}
    local bonWInit:={||Eval(bProc),oMainWnd:End()}

    local cFile
    local cTitle:="PT2Humanus"
    local cProcT:=cTitle+": Aguarde"
    local cProcD:="Criando Arquivo(s)"
    local cProcQ:="Obtendo Dados no SGBD: "

    local cYear

    local lJOB:=MsgNoYes("Executar o Programa em JOB (sem interface)",cTitle)
    local lDBFFile:=.F.

    local nTRecNo:=0

    local oProcess:=if(.not.(lJOB),MsNewProcess():New(bExec,cProcT,cProcD,.T.),NIL)

    Private oMainWnd

    PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
        SetsDefault()
        __SetCentury("ON")
        if .not.(lJOB)
            SetBlind(.F.)
            DEFINE WINDOW oMainWnd FROM 000,000 TO 000,000 TITLE cTitle
                cYear:=Year2Humanus()
            ACTIVATE WINDOW oMainWnd MAXIMIZED ON INIT Eval(bonWInit)
        else
            SetBlind(.F.)
            cYear:=Year2Humanus()
            SetBlind(.T.)
            Eval(bM)
            nTRecNo:=queryView(@cAlias,@cYear)
            copyTo(@oProcess,@cAlias,@nTRecNo,@lDBFFile,@cYear)
            SetBlind(.F.)
            MsgInfo("Final da Exportacao de Dados.: "+cYear,cTitle)
        endif
        (cAlias)->(dbCloseArea())
        dbSelectArea("SM0")
    RESET ENVIRONMENT

return(NIL)

static procedure copyTo(oProcess,cAlias,nTRecNo,lDBFFile,cYear)

    local aFiles
    local adbStruct:=if(lDBFFile,(cAlias)->(dbStruct()),NIL)
    local aPT2Humanus:={;
                            {"Codigo da Empresa                           ","EMPRESA"   ,"C",  1, 3,0,{|e|PaDR(e,3)}       },;//01
                            {"Numero da Filial                            ","FILIAL"    ,"N",  4, 4,0,{|e|Str(Val(e),4,0)} },;//02
                            {"Numero da Matricula                         ","MATRICULA" ,"N",  8,10,0,{|e|Str(Val(e),10,0)}},;//03
                            {"Numero do Registro                          ","REGISTRO"  ,"N", 18,10,0,{|e|Str(Val(e),10,0)}},;//04
                            {"Tipo de Pessoa                              ","T_PESSOA"  ,"C", 28, 2,0,{|e|PaDR(e,2)}       },;//05
                            {"Tipo de Folha                               ","T_FOLHA"   ,"C", 30, 4,0,{|e|PaDR(e,4)}       },;//06
                            {"Tipo de Folha Sec.                          ","T_FOLHAS"  ,"C", 34, 4,0,{|e|PaDR(e,4)}       },;//07
                            {"Competencia                                 ","COMPETENC" ,"N", 38, 6,0,{|e|Str(Val(e),6,0)} },;//08
                            {"Inicio da Vigencia                          ","D_INIVIG"  ,"D", 44,10,0,{|e|DtoC(e)}         },;//09
                            {"Fim da Vigencia                             ","D_FNIVIG"  ,"D", 54,10,0,{|e|DtoC(e)}         },;//10
                            {"Caracter. Folha                             ","C_FOLHA"   ,"N", 64, 2,0,{|e|Str(Val(e),2,0)} },;//11
                            {"Codigo da Rubrica                           ","RUBRICA"   ,"N", 66, 3,0,{|e|Str(Val(e),3,0)} },;//12
                            {"Referencia                                  ","Q_REFER"   ,"N", 69,12,2,{|e|Str(e,12,2)}     },;//13
                            {"Valor                                       ","VALOR"     ,"N", 83,12,2,{|e|Str(e,12,2)}     },;//14
                            {"Data de Pagamento                           ","D_PAGTO"   ,"D", 97,10,0,{|e|DtoC(e)}         },;//15
                            {"Nro. Dep. IRRF                              ","DEPIR"     ,"N",107, 2,0,{|e|Str(Val(e),2,0)} },;//16
                            {"Nro. Dep. SF                                ","DEPSF"     ,"N",109, 2,0,{|e|Str(Val(e),2,0)} },;//17
                            {"Cod. Lotacao                                ","LOTACAO"   ,"C",111,17,0,{|e|PaDR(e,17)}      },;//18
                            {"Codigo Empresa Anterior                     ","EMPANT"    ,"C",128, 3,0,{|e|PaDR(e,3)}       },;//19
                            {"Numero da Filial Anterior                   ","FILANT"    ,"N",131, 4,0,{|e|Str(Val(e),4,0)} },;//20
                            {"Data Inicio de Vigencia da Folha Original   ","D_INIVIGO" ,"D",135,10,0,{|e|DtoC(e)}         },;//21
                            {"Codigo da Folha Apropriadora                ","C_FOLAPRO" ,"C",145, 4,0,{|e|PaDR(e,4)}       },;//22
                            {"Cod. do Cargo                               ","CARGO"     ,"C",149, 8,0,{|e|PaDR(e,8)}       },;//23
                            {"Cod. da Tabela Salarial                     ","TABSAL"    ,"C",157, 8,0,{|e|PaDR(e,8)}       },;//24
                            {"Data de Vig. da Tab. Salarial               ","D_TABSAL"  ,"D",165,10,0,{|e|DtoC(e)}         },;//25
                            {"Horas Fisicas Mes                           ","H_MES"     ,"N",175, 3,2,{|e|Str(e,6,2)}      },;//26
                            {"Horas - Dia                                 ","H_DIA"     ,"N",180, 2,4,{|e|Str(e,6,4)}      },;//27
                            {"Branco                                      ","BRANCO_1"  ,"C",186, 2,0,{|e|PaDR(e,2)}       },;//28
                            {"Branco                                      ","BRANCO_2"  ,"C",188, 2,0,{|e|PaDR(e,2)}       },;//29
                            {"Cod. do Horario                             ","C_HOR"     ,"C",190, 8,0,{|e|PaDR(e,8)}       },;//30
                            {"Nivel Salarial                              ","NIV_SAL"   ,"N",198, 4,0,{|e|Str(Val(e),4,0)} },;//31
                            {"Valor do Salario                            ","V_SALARIO" ,"N",202,10,2,{|e|Str(e,10,2)}     },;//32
                            {"Tipo de Salario                             ","T_SALARIO" ,"C",214, 1,0,{|e|PaDR(e,1)}       },;//33
                            {"Cod. de Recebimento                         ","C_RECEBE"  ,"C",215, 1,0,{|e|PaDR(e,1)}       },;//34
                            {"Cod. de Mao de Obra                         ","C_MOBRA"   ,"C",216, 2,0,{|e|PaDR(e,2)}       },;//35
                            {"Cod. da GRPS                                ","C_GRPS"    ,"N",218, 4,0,{|e|Str(Val(e),4,0)} },;//36
                            {"Cod. do Sindicato                           ","SINDICATO" ,"C",222, 3,0,{|e|PaDR(e,3)}       },;//37
                            {"Nome do Funcionario                         ","NOME_FUN"  ,"C",225,70,0,{|e|PaDR(e,70)}      },;//38
                            {"Data de Inicio para ATS                     ","D_ATS"     ,"D",295,10,0,{|e|DtoC(e)}         },;//39
                            {"Codigo do Time                              ","C_TIME"    ,"C",305,17,0,{|e|PaDR(e,17)}      },;//40
                            {"ultima Situacao                             ","ULT_SIT"   ,"C",322, 2,0,{|e|PaDR(e,2)}       },;//41
                            {"eSocial - Indicador de Multiplos Vinculos   ","ES_I_MVINC","N",324, 5,0,{|e|Str(Val(e),5,0)} },;//42
                            {"eSocial - Indicador de Simples              ","ES_I_SIMPL","N",329, 5,0,{|e|Str(Val(e),5,0)} },;//43
                            {"eSocial - Cod. Categoria                    ","ES_COD_CAT","C",334, 3,0,{|e|PaDR(e,3)}       },;//44
                            {"eSocial - Grau de Exposicao                 ","ES_G_EXPO" ,"N",337, 5,0,{|e|Str(Val(e),5,0)} },;//45
                            {"eSocial - Tipo de Inscricao                 ","ES_TP_INSC","N",342, 5,0,{|e|Str(Val(e),5,0)} },;//46
                            {"eSocial - Nro. de Inscricao                 ","ES_NR_INSC","C",347,20,0,{|e|PaDR(e,20)}      },;//47
                            {"eSocial - Competencia Original              ","ES_CMP_ORI","N",367,10,0,{|e|Str(Val(e),10,0)}},;//48
                            {"eSocial - Inicio de Vigencia Original       ","ES_I_VIG_O","D",377,10,0,{|e|DtoC(e)}         },;//49
                            {"eSocial - Fim de Vigencia Original          ","ES_F_VIG_O","D",387,10,0,{|e|DtoC(e)}         },;//50
                            {"Codigo de Empresa Original                  ","ES_EMP_O"  ,"C",397, 3,0,{|e|PaDR(e,3)}       },;//51
                            {"eSocial - Nro. de Filial Original           ","ES_FIL_O"  ,"N",400, 5,0,{|e|Str(Val(e),4,0)} },;//52
                            {"eSocial - Cod. Lotacao Original             ","ES_COD_L_O","C",405,17,0,{|e|PaDR(e,17)}      },;//53
                            {"eSocial - GPS Original                      ","ES_GPS_ORI","N",422, 5,0,{|e|Str(Val(e),5,0)} },;//54
                            {"eSocial - Cod. Categoria Original           ","ES_CAT_ORI","C",427, 3,0,{|e|PaDR(e,3)}       },;//55
                            {"eSocial - Cod. Cargo Original               ","ES_CRG_ORI","C",430, 8,0,{|e|PaDR(e,8)}       },;//56
                            {"eSocial - Matricula Original                ","ES_MAT_ORI","N",438,10,0,{|e|Str(Val(e),10,0)}},;//57
                            {"eSocial - Indicador de Multiplos Vinculos Or","ES_I_MV_OR","N",448, 5,0,{|e|Str(Val(e),5,0)} },;//58
                            {"eSocial - Indicador de Simples Original     ","ES_I_SIM_O","N",453, 5,0,{|e|Str(Val(e),5,0)} },;//59
                            {"eSocial - Grau de Exposicao Original        ","ES_G_EXP_O","N",458, 5,0,{|e|Str(Val(e),5,0)} },;//60
                            {"eSocial - Tipo de Inscricao Original        ","ES_TP_IN_O","N",463, 5,0,{|e|Str(Val(e),5,0)} },;//61
                            {"eSocial - Nro. de Inscricao Original        ","ES_NR_IN_O","C",468,20,0,{|e|PaDR(e,20)}      }; //62
    }

    local bDBFCopy:={||__CopyFile(cFileDBF,cTempPath+cFNameDBF)}
    local bTXTCopy:={||__CopyFile(cFileTXT,cTempPath+cFNameTXT)}

    local cDir:="\pt2Humanus\"
    local cRDD:="DBFCDXADS"
    local cCRLF:=CRLF
    local cFile
    local cBuffer
    local cDBFAlias:=GetNextAlias()
    local cTempPath:=GetTempPath()

    local cFileDBF:=(cDir+"pt2humanus_"+cYear+"_"+DtoS(Date())+"_"+StrTran(Time(),":","")+".dbf")
    local cFileTXT:=StrTran(cFileDBF,".dbf",".txt")

    local cFNameDBF
    local cFNameTXT

    local cTRecNo:=StrZero(nTRecNo,10)

    local cIncRegua1
    local cIncRegua2

    local cProgress1:="UNION"
    local cEvalProg1
    local cD1IncRegua
    local cE1IncRegua
    local cP1IncRegua

    local lLock
    local lFirst:=.T.
    local lShared:=.F.
    local lTSetReg2:=.F.
    local loProcess:=(ValType(oProcess)=="O")

    local nFile
    local nhFile
    local nFiles
    local nRecNo:=0
    local nField
    local nFields:=Len(aPT2Humanus)
    local nAttempts
    local nTIncReg1
    local nTSetReg1
    local nTIncReg2

    local oRTime:=if(loProcess,tRemaining():New(),NIL)
    local oProgress1:=if(loProcess,tSProgress():New(),NIL)
    local oProgress2:=if(loProcess,tSProgress():New(),NIL)

    local uCnt

    begin sequence

        if .not.(lIsDir("\pt2Humanus\"))
            MakeDir("\pt2Humanus\")
        endif

        nFiles:=aDir(cDir+"pt2humanus_"+cYear+"*.*",@aFiles)
        for nFile:=1 To nFiles
            cFile:=(cDir+aFiles[nFile])
            fErase(cFile)
        next nFile

        nhFile:=fCreate(cFileTXT)

        dbSelectArea(cAlias)

        if (lDBFFile).and.(.not.(File(cFileDBF)))
            dbCreate(cFileDBF,adbStruct,cRDD)
            nAttempts:=0
            while (NetErr())
                Sleep(300)
                IF (++nAttempts>10)
                    break
                EndIF
                dbCreate(cFileDBF,adbStruct,cRDD)
            end while
        endif

        if (lDBFFile)
            dbUseArea(.T.,cRDD,cFileDBF,cDBFAlias,lShared,.F.)
        endif

        if (loProcess)
            nTIncReg1:=Min(nTRecNo,N_INCREMENT)
            nTSetReg1:=nTRecNo
            nTSetReg1-=if(nTIncReg1>=Min(nTRecNo,N_INCREMENT),nTIncReg1,if(nTSetReg1>=100,100,if(nTSetReg1>=10,10,if(nTSetReg1>=5,5,1))))
            oRTime:SetRemaining(nTRecNo)
            oProcess:SetRegua1(nTIncReg1)
            oProgress1:SetProgress(Replicate(Chr(149)+";",25))
        endif

        while (cAlias)->(.not.(Eof()))
            ++nRecNo
            if (loProcess)
                lTSetReg2:=((--nTIncReg1)==0)
                lTSetReg2:=(lTSetReg2).or.(;
                                                (nTSetReg1<=Min(nTRecNo,N_INCREMENT));
                                                .and.;
                                                if(nTSetReg1>=100,(nTSetReg1%100==0),if(nTSetReg1>=10,(nTSetReg1%10==0),if(nTSetReg1>=5,(nTIncReg1%5==0),.T.)));
                )
                if (lTSetReg2)
                    nTIncReg1:=if(nTSetReg1>=N_INCREMENT,Min(nTRecNo,N_INCREMENT),if(nTSetReg1>=100,100,if(nTSetReg1>=10,10,if(nTSetReg1>=5,5,1))))
                    nTSetReg1-=if(nTIncReg1>=Min(nTRecNo,N_INCREMENT),nTIncReg1,if(nTSetReg1>=100,100,if(nTSetReg1>=10,10,if(nTSetReg1>=5,5,1))))
                    oProcess:SetRegua1(nTIncReg1)
                endif
            endif
            cBuffer:=""
            if (lDBFFile)
                (cDBFAlias)->(dbAppend(.T.))
                lLock:=(cDBFAlias)->(rLock())
                if .not.(lLock)
                    (cAlias)->(dbSkip())
                    if (loProcess)
                        cEvalProg1:=oProgress1:Eval(cProgress1)
                        cIncRegua1:="["+cEvalProg1+"]"
                        cD1IncRegua:=if(((lFirst).or.(lTSetReg2)),"["+DtoC(oRTime:GetdEndTime())+"]",cD1IncRegua)
                        cIncRegua1+=cD1IncRegua
                        cE1IncRegua:=if(((lFirst).or.(lTSetReg2)),"["+oRTime:GetcEndTime()+"]|["+oRTime:GetcAverageTime()+"]",cE1IncRegua)
                        cIncRegua1+=cE1IncRegua
                        cP1IncRegua:=if(((lFirst).or.(lTSetReg2)),"["+NToS(((nRecNo/nTRecNo)*100))+"(%)]",cP1IncRegua)
                        cIncRegua1+=cP1IncRegua
                        oProcess:IncRegua1(cIncRegua1)
                        if (oProcess:lEnd)
                            break
                        endif
                        lFirst:=.F.
                    endif
                    loop
                endif
            endif
            if (loProcess)
                nTIncReg2:=Min(nFields,10)
                oProcess:SetRegua2(0)
            endif
            for nField:=1 to nFields
                uCnt:=(cAlias)->(FieldGet(nField))
                if (lDBFFile)
                    (cDBFAlias)->(FieldPut(nField,uCnt))
                endif
                cBuffer+=Eval(aPT2Humanus[nField][7],uCnt)
                if (nField<nFields)
                    cBuffer+=";"
                endif
                if (loProcess)
                    if (lTSetReg2).and.((--nTIncReg2)==0)
                        nTIncReg2:=Min(nFields,10)
                        cIncRegua2:="[Year: "+cYear+"][RecNo: "+StrZero(nRecNo,10)+"/"+cTRecNo+"]["+oProgress2:Eval()+"]"
                        oRTime:Calcule(.F.)
                        oProcess:IncRegua2(cIncRegua2)
                        if (oProcess:lEnd)
                            break
                        endif
                    endif
                endif
            next nField
            if (lDBFFile)
                (cDBFAlias)->(dbUnLock())
            endif
            (cAlias)->(dbSkip())
            cBuffer+=cCRLF
            fWrite(nhFile,cBuffer)
            if (loProcess)
                cEvalProg1:=if(((lFirst).or.(lTSetReg2)),oProgress1:Eval(cProgress1),cEvalProg1)
                cIncRegua1:="["+cEvalProg1+"]"
                cD1IncRegua:=if(((lFirst).or.(lTSetReg2)),"["+DtoC(oRTime:GetdEndTime())+"]",cD1IncRegua)
                cIncRegua1+=cD1IncRegua
                cE1IncRegua:=if(((lFirst).or.(lTSetReg2)),"["+oRTime:GetcEndTime()+"]|["+oRTime:GetcAverageTime()+"]",cE1IncRegua)
                cIncRegua1+=cE1IncRegua
                cP1IncRegua:=if(((lFirst).or.(lTSetReg2)),"["+NToS(((nRecNo/nTRecNo)*100))+"(%)]",cP1IncRegua)
                cIncRegua1+=cP1IncRegua
                oProcess:IncRegua1(cIncRegua1)
                if (oProcess:lEnd)
                    break
                endif
                oRTime:Calcule(.T.)
                lFirst:=.F.
             endif
        end while

        fClose(nhFile)

        if (lDBFFile)
            (cDBFAlias)->(dbCloseArea())
            cFNameDBF:=RetFileName(cFileDBF)+".dbf"
            if (loProcess)
                MsAguarde(bDBFCopy,"Copiando Arquivo. Aguarde...",cFNameDBF)
            else
                Eval(bDBFCopy)
            endif
        endif

        cFNameTXT:=RetFileName(cFileTXT)+".txt"
        if (loProcess)
            MsAguarde(bTXTCopy,"Copiando Arquivo. Aguarde...",cFNameTXT)
        else
            Eval(bTXTCopy)
        endif

        dbSelectArea(cAlias)

    end sequence

return

static function queryView(cAlias,cYear)

    local cAliasTmp
    local cLastQuery
    local cLastQCount

    local nTRecNo:=0

    BEGINSQL ALIAS cAlias

        %noParser%
        COLUMN D_INIVIG     AS DATE
        COLUMN D_FNIVIG     AS DATE
        COLUMN D_PAGTO      AS DATE
        COLUMN D_INIVIGO    AS DATE
        COLUMN D_TABSAL     AS DATE
        COLUMN D_ATS        AS DATE
        COLUMN ES_I_VIG_O   AS DATE
        COLUMN ES_F_VIG_O   AS DATE
        COLUMN Q_REFER      AS NUMERIC(12,2)
        COLUMN VALOR        AS NUMERIC(12,2)
        COLUMN H_MES        AS NUMERIC(6,2)
        COLUMN H_DIA        AS NUMERIC(6,4)
        COLUMN V_SALARIO    AS NUMERIC(12,2)

        SELECT h.* FROM (
                SELECT   '001'                           AS EMPRESA
                        ,'00'||SRD.RD_FILIAL             AS FILIAL
                        ,'00'||SRD.RD_MAT                AS MATRICULA
                        ,'00'||SRD.RD_MAT                AS REGISTRO
                        ,(
                            CASE SRA.RA_CATFUNC
                                WHEN 'A' THEN 'AU'
                                WHEN 'E' THEN 'ES'
                                WHEN 'G' THEN 'ES'
                                WHEN 'H' THEN 'HM'
                                WHEN 'S' THEN 'HS'
                                WHEN 'M' THEN 'MM'
                                WHEN 'P' THEN 'PL'
                                ELSE 'MM'
                             END
                        )                               AS T_PESSOA
                        ,(
                            CASE SRD.RD_MES
                                WHEN '13' THEN '0702'
                                ELSE (
                                        CASE SRA.RA_CATFUNC
                                            WHEN 'A' THEN '0111'
                                            WHEN 'E' THEN '0501'
                                            WHEN 'G' THEN '0501'
                                            WHEN 'H' THEN '0121'
                                            WHEN 'S' THEN '0211'
                                            WHEN 'M' THEN '0111'
                                            WHEN 'P' THEN '0506'
                                            ELSE '0111'
                                        END
                                )
                            END
                        )                               AS T_FOLHA
                       ,(
                            CASE SRD.RD_MES
                                WHEN '13' THEN '0702'
                                ELSE (
                                        CASE SRA.RA_CATFUNC
                                            WHEN 'A' THEN '0111'
                                            WHEN 'E' THEN '0501'
                                            WHEN 'G' THEN '0501'
                                            WHEN 'H' THEN '0121'
                                            WHEN 'S' THEN '0211'
                                            WHEN 'M' THEN '0111'
                                            WHEN 'P' THEN '0506'
                                            ELSE '0111'
                                        END
                                )
                            END
                        )                               AS T_FOLHAS
                        ,SRD.RD_DATARQ                  AS COMPETENC
                       ,(
                            CASE SRD.RD_MES
                                WHEN '13' THEN SUBSTR(SRD.RD_DATARQ,1,4)||'1201'
                                ELSE SRD.RD_DATARQ||'01'
                            END
                        )                                AS D_INIVIG
                       ,(
                            CASE SRD.RD_MES
                                WHEN '13' THEN SUBSTR(SRD.RD_DATARQ,1,4)||'1231'
                                WHEN '01' THEN SRD.RD_DATARQ||'31'
                                WHEN '02' THEN SRD.RD_DATARQ||'28'
                                WHEN '03' THEN SRD.RD_DATARQ||'31'
                                WHEN '04' THEN SRD.RD_DATARQ||'30'
                                WHEN '05' THEN SRD.RD_DATARQ||'31'
                                WHEN '06' THEN SRD.RD_DATARQ||'30'
                                WHEN '07' THEN SRD.RD_DATARQ||'31'
                                WHEN '08' THEN SRD.RD_DATARQ||'31'
                                WHEN '09' THEN SRD.RD_DATARQ||'30'
                                WHEN '10' THEN SRD.RD_DATARQ||'31'
                                WHEN '11' THEN SRD.RD_DATARQ||'30'
                                WHEN '12' THEN SRD.RD_DATARQ||'31'
                            END
                        )                                AS D_FNIVIG
                        ,'0 '                            AS C_FOLHA
                        ,SRD.RD_PD                       AS RUBRICA
                        ,SRD.RD_HORAS                    AS Q_REFER
                        ,SRD.RD_VALOR                    AS VALOR
                        ,SRD.RD_DATPGT                   AS D_PAGTO
                       ,(
                            CASE SRA.RA_DEPIR
                                WHEN ' ' THEN '0'
                                ELSE SRA.RA_DEPIR
                            END
                        )                                 AS DEPIR
                       ,(
                            CASE SRA.RA_DEPSF
                                WHEN ' ' THEN '0'
                                ELSE SRA.RA_DEPSF
                            END
                        )                                AS DEPSF
                        ,SRD.RD_CC                       AS LOTACAO
                        ,'001'                           AS EMPANT
                        ,'00'||SRD.RD_FILIAL             AS FILANT
                       ,(
                            CASE SRD.RD_MES
                                WHEN '13' THEN SUBSTR(SRD.RD_DATARQ,1,4)||'1201'
                                ELSE SRD.RD_DATARQ||'01'
                            END
                        )                                AS D_INIVIGO
                        ,'    '                         AS C_FOLAPRO
                        ,' '                            AS CARGO
                        ,' '                            AS TABSAL
                        ,' '                            AS D_TABSAL
                        ,SRA.RA_HRSMES                  AS H_MES
                        ,SRA.RA_HRSEMAN/5               AS H_DIA
                        ,'  '                           AS BRANCO_1
                        ,'  '                           AS BRANCO_2
                        ,'        '                     AS C_HOR
                        ,'    '                         AS NIV_SAL
                        ,SRA.RA_SALARIO                 AS V_SALARIO
                        ,' '                            AS T_SALARIO
                        ,' '                            AS C_RECEBE
                        ,' '                            AS C_MOBRA
                        ,' '                            AS C_GRPS
                        ,SRA.RA_SINDICA                 AS SINDICATO
                        ,SRA.RA_NOME                    AS NOME_FUN
                        ,' '                            AS D_ATS
                        ,' '                            AS C_TIME
                        ,' '                            AS ULT_SIT
                        ,' '                            AS ES_I_MVINC
                        ,' '                            AS ES_I_SIMPL
                        ,' '                            AS ES_COD_CAT
                        ,' '                            AS ES_G_EXPO
                        ,' '                            AS ES_TP_INSC
                        ,' '                            AS ES_NR_INSC
                        ,'0'                            AS ES_CMP_ORI
                        ,' '                            AS ES_I_VIG_O
                        ,' '                            AS ES_F_VIG_O
                        ,'001'                          AS ES_EMP_O
                        ,'00'||SRD.RD_FILIAL            AS ES_FIL_O
                        ,SRD.RD_CC                      AS ES_COD_L_O
                        ,' '                            AS ES_GPS_ORI
                        ,' '                            AS ES_CAT_ORI
                        ,' '                            AS ES_CRG_ORI
                        ,SRA.RA_MAT                     AS ES_MAT_ORI
                        ,' '                            AS ES_I_MV_OR
                        ,' '                            AS ES_I_SIM_O
                        ,' '                            AS ES_G_EXP_O
                        ,' '                            AS ES_TP_IN_O
                        ,' '                            AS ES_NR_IN_O
                FROM SRD010 SRD
                    ,SRA010 SRA
                WHERE SRD.D_E_L_E_T_=' '
                      AND SRD.D_E_L_E_T_=SRA.D_E_L_E_T_
                      AND SRD.RD_FILIAL=SRA.RA_FILIAL
                      AND SRD.RD_MAT=SRA.RA_MAT
                      AND SUBSTR(SRD.RD_DATARQ,1,4)=%exp:cYear%
                UNION ALL
                SELECT  '001'                           AS EMPRESA
                        ,'00'||SRR.RR_FILIAL            AS FILIAL
                        ,'00'||SRR.RR_MAT               AS MATRICULA
                        ,'00'||SRR.RR_MAT               AS REGISTRO
                        ,(
                            CASE SRA.RA_CATFUNC
                                WHEN 'A' THEN 'AU'
                                WHEN 'E' THEN 'ES'
                                WHEN 'G' THEN 'ES'
                                WHEN 'H' THEN 'HM'
                                WHEN 'S' THEN 'HS'
                                WHEN 'M' THEN 'MM'
                                WHEN 'P' THEN 'PL'
                                ELSE 'MM'
                             END
                        )                               AS T_PESSOA
                        ,'0301'                         AS T_FOLHA
                        ,'0301'                         AS T_FOLHAS
                        ,SUBSTR(SRR.RR_DATA,1,6)        AS COMPETENC
                        ,SUBSTR(SRR.RR_DATA,1,6)||'01'  AS D_INIVIG
                       ,(
                            CASE SUBSTR(SRR.RR_DATA,5,2)
                                WHEN '13' THEN SUBSTR(SRR.RR_DATA,1,6)||'31'
                                WHEN '01' THEN SUBSTR(SRR.RR_DATA,1,6)||'31'
                                WHEN '02' THEN SUBSTR(SRR.RR_DATA,1,6)||'28'
                                WHEN '03' THEN SUBSTR(SRR.RR_DATA,1,6)||'31'
                                WHEN '04' THEN SUBSTR(SRR.RR_DATA,1,6)||'30'
                                WHEN '05' THEN SUBSTR(SRR.RR_DATA,1,6)||'31'
                                WHEN '06' THEN SUBSTR(SRR.RR_DATA,1,6)||'30'
                                WHEN '07' THEN SUBSTR(SRR.RR_DATA,1,6)||'31'
                                WHEN '08' THEN SUBSTR(SRR.RR_DATA,1,6)||'31'
                                WHEN '09' THEN SUBSTR(SRR.RR_DATA,1,6)||'30'
                                WHEN '10' THEN SUBSTR(SRR.RR_DATA,1,6)||'31'
                                WHEN '11' THEN SUBSTR(SRR.RR_DATA,1,6)||'30'
                                WHEN '12' THEN SUBSTR(SRR.RR_DATA,1,6)||'31'
                            END
                        )                                AS D_FNIVIG
                        ,'3 '                            AS C_FOLHA
                        ,SRR.RR_PD                       AS RUBRICA
                        ,SRR.RR_HORAS                    AS Q_REFER
                        ,SRR.RR_VALOR                    AS VALOR
                        ,SRR.RR_DATA                     AS D_PAGTO
                       ,(
                            CASE SRA.RA_DEPIR
                                WHEN ' ' THEN '0'
                                ELSE SRA.RA_DEPIR
                            END
                        )                                 AS DEPIR
                       ,(
                            CASE SRA.RA_DEPSF
                                WHEN ' ' THEN '0'
                                ELSE SRA.RA_DEPSF
                            END
                        )                                AS DEPSF
                        ,SRR.RR_CC                       AS LOTACAO
                        ,'001'                           AS EMPANT
                        ,'00'||SRR.RR_FILIAL             AS FILANT
                        ,SUBSTR(SRR.RR_DATA,1,6)||'01'   AS D_INIVIGO
                        ,'    '                          AS C_FOLAPRO
                        ,' '                             AS CARGO
                        ,' '                             AS TABSAL
                        ,' '                             AS D_TABSAL
                        ,SRA.RA_HRSMES                   AS H_MES
                        ,SRA.RA_HRSEMAN/5                AS H_DIA
                        ,'  '                            AS BRANCO_1
                        ,'  '                            AS BRANCO_2
                        ,'        '                      AS C_HOR
                        ,'    '                          AS NIV_SAL
                        ,SRA.RA_SALARIO                  AS V_SALARIO
                        ,' '                             AS T_SALARIO
                        ,' '                             AS C_RECEBE
                        ,' '                             AS C_MOBRA
                        ,' '                             AS C_GRPS
                        ,SRA.RA_SINDICA                  AS SINDICATO
                        ,SRA.RA_NOME                     AS NOME_FUN
                        ,' '                             AS D_ATS
                        ,' '                             AS C_TIME
                        ,' '                             AS ULT_SIT
                        ,' '                             AS ES_I_MVINC
                        ,' '                             AS ES_I_SIMPL
                        ,' '                             AS ES_COD_CAT
                        ,' '                             AS ES_G_EXPO
                        ,' '                             AS ES_TP_INSC
                        ,' '                             AS ES_NR_INSC
                        ,'0'                             AS ES_CMP_ORI
                        ,' '                             AS ES_I_VIG_O
                        ,' '                             AS ES_F_VIG_O
                        ,'001'                           AS ES_EMP_O
                        ,'00'||SRR.RR_FILIAL             AS ES_FIL_O
                        ,SRR.RR_CC                       AS ES_COD_L_O
                        ,' '                             AS ES_GPS_ORI
                        ,' '                             AS ES_CAT_ORI
                        ,' '                             AS ES_CRG_ORI
                        ,SRA.RA_MAT                      AS ES_MAT_ORI
                        ,' '                             AS ES_I_MV_OR
                        ,' '                             AS ES_I_SIM_O
                        ,' '                             AS ES_G_EXP_O
                        ,' '                             AS ES_TP_IN_O
                        ,' '                             AS ES_NR_IN_O
                FROM SRR010 SRR
                    ,SRA010 SRA
                WHERE SRR.D_E_L_E_T_=' '
                      AND SRR.RR_TIPO3='F'
                      AND SRR.D_E_L_E_T_=SRA.D_E_L_E_T_
                      AND SRR.RR_FILIAL=SRA.RA_FILIAL
                      AND SRR.RR_MAT=SRA.RA_MAT
                      AND SUBSTR(SRR.RR_DATA,1,4)=%exp:cYear%
                UNION ALL
                SELECT  '001'                           AS EMPRESA
                        ,'00'||SRR.RR_FILIAL            AS FILIAL
                        ,'00'||SRR.RR_MAT               AS MATRICULA
                        ,'00'||SRR.RR_MAT               AS REGISTRO
                        ,(
                            CASE SRA.RA_CATFUNC
                                WHEN 'A' THEN 'AU'
                                WHEN 'E' THEN 'ES'
                                WHEN 'G' THEN 'ES'
                                WHEN 'H' THEN 'HM'
                                WHEN 'S' THEN 'HS'
                                WHEN 'M' THEN 'MM'
                                WHEN 'P' THEN 'PL'
                                ELSE 'MM'
                             END
                        )                               AS T_PESSOA
                        ,'0401'                         AS T_FOLHA
                        ,'0401'                         AS T_FOLHAS
                        ,SUBSTR(SRR.RR_DATA,1,6)        AS COMPETENC
                        ,SUBSTR(SRR.RR_DATA,1,6)||'01'  AS D_INIVIG
                       ,(
                            CASE SUBSTR(SRR.RR_DATA,5,2)
                                WHEN '13' THEN SUBSTR(SRR.RR_DATA,1,6)||'31'
                                WHEN '01' THEN SUBSTR(SRR.RR_DATA,1,6)||'31'
                                WHEN '02' THEN SUBSTR(SRR.RR_DATA,1,6)||'28'
                                WHEN '03' THEN SUBSTR(SRR.RR_DATA,1,6)||'31'
                                WHEN '04' THEN SUBSTR(SRR.RR_DATA,1,6)||'30'
                                WHEN '05' THEN SUBSTR(SRR.RR_DATA,1,6)||'31'
                                WHEN '06' THEN SUBSTR(SRR.RR_DATA,1,6)||'30'
                                WHEN '07' THEN SUBSTR(SRR.RR_DATA,1,6)||'31'
                                WHEN '08' THEN SUBSTR(SRR.RR_DATA,1,6)||'31'
                                WHEN '09' THEN SUBSTR(SRR.RR_DATA,1,6)||'30'
                                WHEN '10' THEN SUBSTR(SRR.RR_DATA,1,6)||'31'
                                WHEN '11' THEN SUBSTR(SRR.RR_DATA,1,6)||'30'
                                WHEN '12' THEN SUBSTR(SRR.RR_DATA,1,6)||'31'
                            END
                        )                                AS D_FNIVIG
                        ,'0 '                            AS C_FOLHA
                        ,SRR.RR_PD                       AS RUBRICA
                        ,SRR.RR_HORAS                    AS Q_REFER
                        ,SRR.RR_VALOR                    AS VALOR
                        ,SRR.RR_DATA                     AS D_PAGTO
                       ,(
                            CASE SRA.RA_DEPIR
                                WHEN ' ' THEN '0'
                                ELSE SRA.RA_DEPIR
                            END
                        )                                 AS DEPIR
                       ,(
                            CASE SRA.RA_DEPSF
                                WHEN ' ' THEN '0'
                                ELSE SRA.RA_DEPSF
                            END
                        )                                AS DEPSF
                        ,SRR.RR_CC                       AS LOTACAO
                        ,'001'                           AS EMPANT
                        ,'00'||SRR.RR_FILIAL             AS FILANT
                        ,SUBSTR(SRR.RR_DATA,1,6)||'01'   AS D_INIVIGO
                        ,'    '                          AS C_FOLAPRO
                        ,' '                             AS CARGO
                        ,' '                             AS TABSAL
                        ,' '                             AS D_TABSAL
                        ,SRA.RA_HRSMES                   AS H_MES
                        ,SRA.RA_HRSEMAN/5                AS H_DIA
                        ,'  '                            AS BRANCO_1
                        ,'  '                            AS BRANCO_2
                        ,'        '                      AS C_HOR
                        ,'    '                          AS NIV_SAL
                        ,SRA.RA_SALARIO                  AS V_SALARIO
                        ,' '                             AS T_SALARIO
                        ,' '                             AS C_RECEBE
                        ,' '                             AS C_MOBRA
                        ,' '                             AS C_GRPS
                        ,SRA.RA_SINDICA                  AS SINDICATO
                        ,SRA.RA_NOME                     AS NOME_FUN
                        ,' '                             AS D_ATS
                        ,' '                             AS C_TIME
                        ,' '                             AS ULT_SIT
                        ,' '                             AS ES_I_MVINC
                        ,' '                             AS ES_I_SIMPL
                        ,' '                             AS ES_COD_CAT
                        ,' '                             AS ES_G_EXPO
                        ,' '                             AS ES_TP_INSC
                        ,' '                             AS ES_NR_INSC
                        ,'0'                             AS ES_CMP_ORI
                        ,' '                             AS ES_I_VIG_O
                        ,' '                             AS ES_F_VIG_O
                        ,'001'                           AS ES_EMP_O
                        ,'00'||SRR.RR_FILIAL             AS ES_FIL_O
                        ,SRR.RR_CC                       AS ES_COD_L_O
                        ,' '                             AS ES_GPS_ORI
                        ,' '                             AS ES_CAT_ORI
                        ,' '                             AS ES_CRG_ORI
                        ,SRA.RA_MAT                      AS ES_MAT_ORI
                        ,' '                             AS ES_I_MV_OR
                        ,' '                             AS ES_I_SIM_O
                        ,' '                             AS ES_G_EXP_O
                        ,' '                             AS ES_TP_IN_O
                        ,' '                             AS ES_NR_IN_O
                FROM SRR010 SRR
                    ,SRA010 SRA
                WHERE SRR.D_E_L_E_T_=' '
                      AND SRR.RR_TIPO3='R'
                      AND SRR.D_E_L_E_T_=SRA.D_E_L_E_T_
                      AND SRR.RR_FILIAL=SRA.RA_FILIAL
                      AND SRR.RR_MAT=SRA.RA_MAT
                      AND SUBSTR(SRR.RR_DATA,1,4)=%exp:cYear%
        ) h
        WHERE SUBSTR(h.COMPETENC,1,4)=%exp:cYear%
        ORDER BY h.EMPRESA
                 ,h.FILIAL
                 ,h.MATRICULA
                 ,h.COMPETENC
                 ,h.T_FOLHA
                 ,h.C_FOLHA
                 ,h.RUBRICA

    ENDSQL

    cLastQuery:=GetLastQuery()[2]
    cLastQCount:=("%"+cLastQuery+"%")
    
    cAliasTmp:=GetNextAlias()
    BEGINSQL ALIAS cAliasTmp
        SELECT COUNT(*) AS NTRECNO
          FROM (%exp:cLastQCount%)
    ENDSQL

    nTRecNo:=(cAliasTmp)->NTRECNO
    (cAliasTmp)->(dbCloseArea())

    dbSelectArea(cAlias)


return(nTRecNo)

static function ProcRedefine(oProcess,oFont,nLeft,nWidth,nCTLFLeft,lODlgF,lODlgW)
    local aClassData
    local laMeter
    local nObj
    local nMeter
    local nMeters
    local lProcRedefine:=.F.
    if (valType(oProcess)=="O")
        aClassData:=ClassDataArr(oProcess,.T.)
        laMeter:=(aScan(aClassData,{|e|e[1]=="AMETER"})>0)
        if (laMeter)
            DEFAULT oFont:=TFont():New("Lucida Console",NIL,12,NIL,.T.)
            DEFAULT nLeft:=40
            DEFAULT nWidth:=80
            nMeters:=Len(oProcess:aMeter)
            For nMeter:=1 To nMeters
                For nObj:=1 To 2
                    oProcess:aMeter[nMeter][nObj]:oFont:=oFont
                    oProcess:aMeter[nMeter][nObj]:nWidth+=nWidth
                    oProcess:aMeter[nMeter][nObj]:nLeft-=nLeft
                Next nObj
            Next nMeter
        else
            DEFAULT oFont:=TFont():New("Lucida Console",NIL,16,NIL,.T.)
            DEFAULT lODlgF:=.T.
            DEFAULT lODlgW:=.F.
            DEFAULT nLeft:=100
            DEFAULT nWidth:=200
            DEFAULT nCTLFLeft:=if(lODlgW,nWidth,nWidth/2)
            if (lODlgF)
                oProcess:oDlg:oFont:=oFont
            endif
            if (lODlgW)
                oProcess:oDlg:nWidth+=nWidth
                oProcess:oDlg:nLeft-=(nWidth/2)
            endif
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
            if (valType(oProcess:oDlg:oCTLFocus)=="O")
                oProcess:oDlg:oCTLFocus:nLeft+=nCTLFLeft
            endif
            oProcess:oDlg:Refresh(.T.)
            oProcess:oDlg:SetFocus()
        endif
        lProcRedefine:=.T.
    endif
return(lProcRedefine)

static procedure SetBlind(lIsBlind)
    DEFAULT lIsBlind:= .F.
    if ( lIsBlind )
        __cINTERNET:="AUTOMATICO"
    else
        __cINTERNET:=NIL
    endif
    if (Type("oApp")=="O")
        oApp:lIsBlind:=lIsBlind
        oApp:cInternet:=__cINTERNET
    endif
    __cBinder:=__cINTERNET
return

static function Year2Humanus()

    local cYear:=Year2Str(MsDate())

    local oDlg
    local oYear
    local oFont

    DEFINE FONT oFont NAME "Courier New" SIZE 18,25 BOLD
    DEFINE MSDIALOG oDlg FROM  000,000 TO 150,250 TITLE OemToAnsi("Informe o Ano da Exportacao") OF oMainWnd STYLE DS_MODALFRAME STATUS PIXEL
        @ 025,015 MSGET oYear VAR cYear SIZE 100,030 OF oDlg PIXEL WHEN .T. VALID YearOk(@cYear) CENTERED FONT oFont
        oDlg:lEscClose:=.F.//Nao permite sair ao se pressionar a tecla ESC.
        oDlg:oFont:=oFont
    ACTIVATE MSDIALOG oDlg CENTERED ON INIT ButtonBar(@oDlg,@cYear) VALID YearOk(@cYear)

return(cYear)

static procedure ButtonBar(oDlg,cYear)

    local bButtonOK:={||if(YearOk(@cYear),oDlg:End(),MsgAlert("Informe um Ano Valido!","PT2Humanus"))}

    local oButtonBar

    local oButtonOK

    DEFINE BUTTONBAR oButtonBar SIZE 025,025 3D TOP OF oDlg

    DEFINE BUTTON oButtonOK RESOURCE "OK" OF oButtonBar GROUP ACTION Eval(bButtonOK) TOOLTIP OemToAnsi('Ok...<Ctrl-O>')
    oButtonOK:cTitle:=OemToAnsi("OK")
    oDlg:bSet15:=oButtonOK:bAction
    SetKey(15,oDlg:bSet15)

    oButtonBar:bRClicked:={||AllwaysTrue()}

return

static function YearOk(cYear)
return(.not.(Empty(cYear)).and.(Val(cYear)>0))
