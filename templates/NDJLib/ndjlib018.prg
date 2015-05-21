#include "fileio.ch"
#include "tbiconn.ch"
#include "protheus.ch"
//------------------------------------------------------------------------------------------------
    /*/
        CLASS:fTdb
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:01/05/2011
        Descricao:Alternativa aas funcoes tipo FT_F* devido as limitacoes apontadas em (http://tdn.totvs.com.br/kbm#9734)
        Sintaxe:ftdb():New():Objeto do Tipo ufT
    /*/
//------------------------------------------------------------------------------------------------
CLASS fTdb FROM ufT

    DATA cDbFile
    DATA cDbAlias
    DATA cRDDName
    
    DATA cClassName

    METHOD New() CONSTRUCTOR
    METHOD ClassName()

    METHOD ft_fUse(cFile)
    METHOD ft_fOpen(cFile)
    METHOD ft_fClose()
    
    METHOD ft_fAlias()
    
    METHOD ft_fExists(cFile)
    
    METHOD ft_fRecno()
    METHOD ft_fSkip(nSkipper)
    METHOD ft_fGoTo(nGoTo)
    METHOD ft_fGoTop()
    METHOD ft_fGoBottom()
    METHOD ft_fLastRec()
    METHOD ft_fRecCount()

    METHOD ft_fEof()
    METHOD ft_fBof()

    METHOD ft_fReadLn()
    METHOD ft_fReadLine()
    
    METHOD ft_fError(cError)

    METHOD ft_fSetCRLF(cCRLF)
    METHOD ft_fSetRddName(cRddName)
    METHOD ft_fSetBufferSize(nBufferSize)

ENDCLASS

User Function ftdb()
Return(ftdb():New())

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:New
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:01/05/2011
        Descricao:CONSTRUCTOR
        Sintaxe:ftdb():New():Object do Tipo fT                
    /*/
//------------------------------------------------------------------------------------------------
METHOD New() CLASS fTdb

    _Super:New()
    self:ClassName()

    self:cDbFile:=""
    self:cDbAlias:=""

    self:ft_fSetRddName()

Return(self)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:ClassName
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:01/05/2011
        Descricao:Retornar o Nome da Classe
        Sintaxe:ftdb():ClassName():Retorna o Nome da Classe
    /*/
//------------------------------------------------------------------------------------------------
METHOD ClassName() CLASS fTdb
    self:cClassName:=(_Super:ClassName()+"DB")
Return(self:cClassName)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:ft_fUse
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:01/05/2011
        Descricao:Abrir o Arquivo Passado como Parametro
        Sintaxe:ftdb():ft_fUse(cFile):nfHandle (nfHandle>0 True,False)
    /*/
//------------------------------------------------------------------------------------------------
METHOD ft_fUse(cFile) CLASS fTdb

    TRYEXCEPTION

        IF .NOT.(self:ft_fExists(cFile))
            BREAK
        EndIF

        self:ft_fOpen(cFile)
    
    CATCHEXCEPTION

        self:ft_fClose()

    ENDEXCEPTION

Return(self:nfHandle)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:ft_fOpen
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:01/05/2011
        Descricao:Abrir o Arquivo Passado como Parametro
        Sintaxe:ftdb():ft_fOpen(cFile):nfHandle (nfHandle>0 True,False)
    /*/
//------------------------------------------------------------------------------------------------
METHOD ft_fOpen(cFile) CLASS fTdb

    Local adbStruct:={{"LINE","M",80,0}}
    
    Local lNewArea:=.T.
    Local lShared:=.T.
    Local lReadOnly:=.F.
    Local lHelp:=.F.
    Local lQuit:=.F.

    TRYEXCEPTION

        IF !(self:ft_fExists(cFile))
            BREAK
        EndIF

        self:cFile:=cFile
        self:nfHandle:=fOpen(self:cFile,FO_READ)
        
        IF (self:nfHandle<=0)
            BREAK
        EndIF
        
        self:cDbFile:=CriaTrab(NIL,.F.)
        While MsFile(self:cDbFile,NIL,self:cRddName)
            self:cDbFile:=CriaTrab(NIL,.F.)
        End While
        
        self:cDbFile+=IF((self:cRddName=="TOPCONN"),"",GetDbExtension())

        IF !(MsCreate(self:cDbFile,adbStruct,self:cRddName))
            BREAK
        EndIF

        self:cDbAlias:=GetNextAlias()
        
        IF .NOT.(MsOpEndbf(@lNewArea,self:cRddName,self:cDbFile,self:cDbAlias,@lShared,@lReadOnly,@lHelp,@lQuit))
            BREAK
        EndIF

        self:nFileSize:=fSeek(self:nfHandle,0,FS_END)

        fSeek(self:nfHandle,0,FS_SET)

        self:nFileSize:=ReadFile(self:cDbAlias,@self:nfHandle,@self:nBufferSize,@self:nFileSize,@self:cCRLF)

        self:ft_fGoTop()

    CATCHEXCEPTION
    
        self:ft_fClose()
    
    ENDEXCEPTION

Return(self:nfHandle)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:ReadFile
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:01/05/2011
        Descricao:Percorre o Arquivo a ser lido e alimento o Array aLines
        Sintaxe:ReadFile(cAlias,nfHandle,nBufferSize,nFileSize,cCRLF):nLines Read
    /*/
//------------------------------------------------------------------------------------------------
Static Function ReadFile(cAlias,nfHandle,nBufferSize,nFileSize,cCRLF)
    
    Local cLine
    Local cBuffer

    Local nLines:=0
    Local nAtPlus:=(len(cCRLF) -1)
    Local nBytesRead:=0

    fSeek(nfHandle,0)

    cBuffer:=""
    while (nBytesRead<=nFileSize)
        cBuffer+=fReadStr(@nfHandle,@nBufferSize)
        nBytesRead+=nBufferSize
        while (cCRLF$cBuffer)
++nLines
            cLine:=subStr(cBuffer,1,(at(cCRLF,cBuffer)+nAtPlus))
            cBuffer:=subStr(cBuffer,len(cLine)+1)
            cLine:=strTran(cLine,cCRLF,"")
            (cAlias)->(dbAppend(.T.))
            (cAlias)->(FieldPut(1,cLine))
            cLine:=""
        end while
    end while

    if .not.(empty(cBuffer))
++nLines
        (cAlias)->(dbAppend(.T.))
        (cAlias)->(FieldPut(1,cBuffer))
        cBuffer:=""
    endif

Return(nLines)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:ft_fClose
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:01/05/2011
        Descricao:Fechar o Arquivo aberto pela ft_fOpen ou ft_fUse
        Sintaxe:ftdb():ft_fClose():NIL
    /*/
//------------------------------------------------------------------------------------------------
METHOD ft_fClose() CLASS fTdb

    Local cMemoFile
    
    _Super:ft_fClose()

    IF (Select(self:cDbAlias)>0)
        (self:cDbAlias)->(dbCloseArea())
    EndIF

    IF MsFile(self:cDbFile,NIL,self:cRddName)
        MsErase(self:cDbFile,NIL,self:cRddName)
    EndIF
    
    cMemoFile:=(FileNoExt(self:cDbFile)+".fpt")
    
    IF File(cMemoFile)
        fErase(cMemoFile)
    EndIF

    self:cDbFile:=""
    self:cDbAlias:=""

Return(NIL)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:ft_fAlias
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:01/05/2011
        Descricao:Retornar o Nome do Arquivo Atualmente Aberto
        Sintaxe:ftdb():ft_fAlias():cFile
    /*/
//------------------------------------------------------------------------------------------------
METHOD ft_fAlias() CLASS fTdb
Return(self:cDbAlias)

/*/
    METHOD:ft_fExists
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:01/05/2011
    Descricao:Verifica se o Arquivo Existe
    Sintaxe:ftdb():ft_fExists(cFile):lExists
/*/
METHOD ft_fExists(cFile) CLASS fTdb
Return(_Super:ft_fExists(cFile))

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:ft_fRecno
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:01/05/2011
        Descricao:Retorna o Recno Atual
        Sintaxe:ftdb():ft_fRecno():nRecno
    /*/
//------------------------------------------------------------------------------------------------
METHOD ft_fRecno() CLASS fTdb
    self:nRecno:=(self:cDbAlias)->(Recno())
Return(self:nRecno)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:ft_fSkip
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:01/05/2011
        Descricao:Salta n Posicoes 
        Sintaxe:ftdb():ft_fSkip(nSkipper):nRecno
    /*/
//------------------------------------------------------------------------------------------------
METHOD ft_fSkip(nSkipper) CLASS fTdb
    DEFAULT nSkipper:=1
    (self:cDbAlias)->(dbSkip(nSkipper))
    self:nRecno:=self:ft_fRecno()
Return(self:nRecno)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:ft_fGoTo
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:01/05/2011
        Descricao:Salta para o Registro informando em nGoto
        Sintaxe:ftdb():ft_fGoTo(nGoTo):nRecno
    /*/
//------------------------------------------------------------------------------------------------
METHOD ft_fGoTo(nGoTo) CLASS fTdb
    (self:cDbAlias)->(dbGoto(nGoTo))
    self:nRecno:=self:ft_fRecno()
Return(self:nRecno)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:ft_fGoTop
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:01/05/2011
        Descricao:Salta para o Inicio do Arquivo
        Sintaxe:ftdb():ft_fGoTo(nGoTo):nRecno
    /*/
//------------------------------------------------------------------------------------------------
METHOD ft_fGoTop() CLASS fTdb
    (self:cDbAlias)->(dbGoTop())
    self:nRecno:=self:ft_fRecno()
Return(self:nRecno)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:ft_fGoBottom
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:01/05/2011
        Descricao:Salta para o Final do Arquivo
        Sintaxe:ftdb():ft_fGoBottom():nRecno
    /*/
//------------------------------------------------------------------------------------------------
METHOD ft_fGoBottom() CLASS fTdb
    (self:cDbAlias)->(dbGoBottom())
    self:nRecno:=self:ft_fRecno()
Return(self:nRecno)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:ft_fLastRec
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:01/05/2011
        Descricao:Retorna o Numero de Registro do Arquivo
        Sintaxe:ftdb():ft_fLastRec():nRecCount
    /*/
//------------------------------------------------------------------------------------------------
METHOD ft_fLastRec() CLASS fTdb
Return((self:cDbAlias)->(LastRec()))

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:ft_fRecCount
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:01/05/2011
        Descricao:Retorna o Numero de Registro do Arquivo
        Sintaxe:ftdb():ft_fRecCount():nRecCount
    /*/
//------------------------------------------------------------------------------------------------
METHOD ft_fRecCount() CLASS fTdb
Return((self:cDbAlias)->(RecCount()))

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:ft_fEof
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:01/05/2011
        Descricao:Verifica se Atingiu o Final do Arquivo
        Sintaxe:ftdb():ft_fEof():lEof
    /*/
//------------------------------------------------------------------------------------------------
METHOD ft_fEof() CLASS fTdb
Return((self:cDbAlias)->(Eof()))

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:ft_fBof
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:01/05/2011
        Descricao:Verifica se Atingiu o Inicio do Arquivo
        Sintaxe:ftdb():ft_fBof():lBof
    /*/
//------------------------------------------------------------------------------------------------
METHOD ft_fBof() CLASS fTdb
Return((self:cDbAlias)->(Bof()))

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:ft_fReadLine
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:01/05/2011
        Descricao:Le a Linha do Registro Atualmente Posicionado
        Sintaxe:ftdb():ft_fReadLine():cLine
    /*/
//------------------------------------------------------------------------------------------------
METHOD ft_fReadLine() CLASS fTdb

    TRYEXCEPTION

        self:nLastRecno:=self:nRecno
        self:cLine:=(self:cDbAlias)->(FieldGet(1))

    CATCHEXCEPTION

        self:cLine:=""

    ENDEXCEPTION

Return(self:cLine)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:ft_fReadLn
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:01/05/2011
        Descricao:Le a Linha do Registro Atualmente Posicionado
        Sintaxe:ftdb():ft_fReadLn():cLine
    /*/
//------------------------------------------------------------------------------------------------
METHOD ft_fReadLn() CLASS fTdb
Return(self:ft_fReadLine())

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:ft_fError
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:01/05/2011
        Descricao:Retorna o Ultimo erro ocorrido
        Sintaxe:ftdb():ft_fError(@cError):nDosError
    /*/
//------------------------------------------------------------------------------------------------
METHOD ft_fError(cError) CLASS fTdb
    cError:=CaptureError()
Return(fError())

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:ft_fSetBufferSize
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:01/05/2011
        Descricao:Redefine nBufferSize
        Sintaxe:ftdb():ft_fSetBufferSize(nBufferSize):nLastBufferSize
    /*/
//------------------------------------------------------------------------------------------------
METHOD ft_fSetBufferSize(nBufferSize) CLASS fTdb
Return(_Super:ft_fSetBufferSize(@nBufferSize))

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:ft_fSetCRLF
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data:01/05/2011
        Descricao:Redefine cCRLF
        Sintaxe:ftdb():ft_fSetCRLF(cCRLF):nLastCRLF
    /*/
//------------------------------------------------------------------------------------------------
METHOD ft_fSetCRLF(cCRLF) CLASS fTdb
Return(_Super:ft_fSetCRLF(@cCRLF))

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:ft_fSetRddName
        Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]`
        Data:01/05/2011
        Descricao:Redefine cRddName
        Sintaxe:ftdb():ft_fSetRddName(cRddName):cLastRddName
    /*/
//------------------------------------------------------------------------------------------------
METHOD ft_fSetRddName(cRddName) CLASS fTdb
    Local cLastRddName:=self:cRddName
    DEFAULT cRddName:="DBFCDXADS"
    self:cRddName:=Upper(cRddName)
Return(cLastRddName)

#include "tryexception.ch"
