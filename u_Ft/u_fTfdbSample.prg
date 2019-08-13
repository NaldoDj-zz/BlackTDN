#include "totvs.ch"
#include "tbiconn.ch"
//-------------------------------------------------------------------------------
    /*/
        Funcao:FTFdbSample
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:01/05/2011
        Descricao:Exemplo de Uso da Classe fTdb
    /*/
//-------------------------------------------------------------------------------
User Function FTFdbSample()

    Local aCab
    Local aDet

    Local cFile:="FTFSample.csv"    //Deve estar em \system\

    aFile:=FileToArr(@cFile)
    aCab:=aFile[1]
    aDet:=aFile[2]

Return({aCab,aDet})

//-------------------------------------------------------------------------------
    /*/
        Funcao:FileToArr
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:01/05/2011
        Descricao:Exemplo de Uso da Classe fT
    /*/
//-------------------------------------------------------------------------------
Static Function FileToArr(cFile)
    Local aCab:={}
    Local aDet:={}

    Local cLine:=""
    Local cToken:=Chr(255)
    Local cRddName:="TOPCONN" //"DBFCDXADS"

    Local lPrepEnv:=(!(cRddName=="DBFCDXADS") .and. (Select("SM0")=="0"))

    Local ofTdb:=fTdb():New()

    IF (lPrepEnv)
        PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
    EndIF

        BEGIN SEQUENCE
    
            ofTdb:ft_fSetRddName(cRddName)
            
            IF (ofTdb:ft_fUse(cFile)<=0)
                ofTdb:ft_fUse()
                BREAK
            EndIF
    
            While !(ofTdb:ft_fEof())
                IncProc()
                cLine:=ofTdb:ft_fReadLn()
                ConOut(cLine)
                cLine:=StrTran(cLine,'""','" "')    //Carrego um espaço em branco
                cLine:=StrTran(cLine,'","',cToken)  //Defino o Separador
                cLine:=StrTran(cLine,'"',"")        //Retiro as Aspas 
                IF (ofTdb:ft_fRecno()==1)
                    aCab:=StrTokArr2(cLine,cToken)   //A primeira Linha contem o Cabeçalho dos campos
                Else
                    aAdd(aDet,StrTokArr2(cLine,cToken))  //As demais linhas sao os Detalhes
                EndIF
                cLine:="" 
                ofTdb:ft_fSkip()
            End While
    
            ofTdb:ft_fUse()
    
        END SEQUENCE

    IF (lPrepEnv)
        RESET ENVIRONMENT
    EndIF

Return({aCab,aDet})
