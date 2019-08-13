#include "ndj.ch"

Static oNDJLIB014

CLASS NDJLIB014

    DATA cClassName
    
    METHOD NEW() CONSTRUCTOR
    METHOD ClassName()
    
    METHOD UsrRetName(cUserID)
    METHOD UsrFullName(cUserID)
    METHOD GrpRetName(cGroupID)
    METHOD UsrExist(cUserID)
    METHOD UsrRetMail(cUserID)
    METHOD WF4Mail(cMail)
    METHOD RetCodUsr()
    METHOD InGrpAdmin(lFinal,cFinalMsg)
    METHOD UserNRetID(cUsrName)
    METHOD UserExist(cUsrName,lChkBlock)
    METHOD ULGDecrypt(cUserLG,nRet)
    
ENDCLASS

User Function DJLIB014()
    DEFAULT oNDJLIB014:=NDJLIB014():New()
Return(oNDJLIB014)

METHOD NEW() CLASS NDJLIB014
    self:ClassName()
RETURN(self)

METHOD ClassName() CLASS NDJLIB014
    self:cClassName:="NDJLIB014"
RETURN(self:cClassName)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:UsrRetName
        Autor:Marinaldo de Jesus
        Data:08/11/2005
        Descricao:Retorna o Nome do Usuario
        Sintaxe:<Vide Parametros Formais>
    /*/
//------------------------------------------------------------------------------------------------
METHOD UsrRetName(cUserID) CLASS NDJLIB014
RETURN(UsrRetName(@cUserID))
Static Function UsrRetName(cUserID)

    Local cUserName
    
    DEFAULT cUserID:=RetCodUsr()
    
    PswOrder(1)
    IF (;
            !Empty(cUserID);
            .and.;
            PswSeek(cUserID);
   )    
        cUserName:=PswRet(1)[1][2]
    Else
        cUserName:=SPACE(15)
    EndIf
    
    IF (cUserID=="******")
        cUserName:="All"
    EndIf

Return(cUserName)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:UsrFullName
        Autor:Marinaldo de Jesus
        Data:08/11/2005
        Descricao:Retorna o Full Name do Usuario
        Sintaxe:<Vide Parametros Formais>
    /*/
//------------------------------------------------------------------------------------------------
METHOD UsrFullName(cUserID) CLASS NDJLIB014
RETURN(UsrFullName(@cUserID))
Static Function UsrFullName(cUserID)
    
    Local cFullName
    
    DEFAULT cUserID:=RetCodUsr()
    
    PswOrder(1)
    IF (;
            !Empty(cUserID);
            .and.;
            PswSeek(cUserID);
   )    
        cFullName:=PswRet(1)[1][4]
    Else
        cFullName:=SPACE(15)
    EndIf
    
    IF (cUserID=="******")
        cFullName:="All"
    EndIf

Return(cFullName)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:GrpRetName
        Autor:Marinaldo de Jesus
        Data:08/11/2005
        Descricao:Retorna o Nome do Grupo
        Sintaxe:<Vide Parametros Formais>
    /*/
//------------------------------------------------------------------------------------------------
METHOD GrpRetName(cGroupID) CLASS NDJLIB014
RETURN(GrpRetName(@cGroupID))
Static Function GrpRetName(cGroupID)

    Local cGroupName
    
    PswOrder(1)
    IF PswSeek(cCodGrup,.F.)
        cGroupName:=PswRet(1)[1][1][2]
    Else
        cGroupName:=Space(15)
    EndIf
    
    IF (cGroupID=="******")
        cGroupName:="All"
    EndIF

Return(cGroupName)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:UsrExist
        Autor:Marinaldo de Jesus
        Data:08/11/2005
        Descricao:Verifica se Usuario Existe
        Sintaxe:<Vide Parametros Formais>
    /*/
//------------------------------------------------------------------------------------------------
METHOD UsrExist(cUserID) CLASS NDJLIB014
RETURN(UsrExist(@cUserID))
Static Function UsrExist(cUserID)

    Local lRet:=.F.
    
    DEFAULT cUserID:=RetCodUsr()
    
    PswOrder(1)
    lRet:=PswSeek(cUserID)
    
Return(lRet)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:UsrRetMail
        Autor:Marinaldo de Jesus
        Data:08/11/2005
        Descricao:Retorna e-mail do Usuario
        Sintaxe:<Vide Parametros Formais>
    /*/
//------------------------------------------------------------------------------------------------
METHOD UsrRetMail(cUserID) CLASS NDJLIB014
RETURN(UsrRetMail(@cUserID))
Static Function UsrRetMail(cUserID) 

    Local aUsrMail
    Local cUsrMail:=""

    Local nBL
    Local nEL

    DEFAULT cUserID:=RetCodUsr()

    PswOrder(1)
    IF (;
            !Empty(cUserID);
            .and.;
            PswSeek(cUserID);
   )
        cUsrMail:=PswRet(1)[1][14]
        aUsrMail:=StrTokArr2(cUsrMail,";")
        cUsrMail:=""
        nEL:=Len(aUsrMail)
        For nBL:=1 To nEL
            //Verifica e-mail Substituto
            cUsrMail+=WF4Mail(aUsrMail[nBL])
            IF (nBL<nEL)
                cUsrMail+=";"
            EndIF
        Next nBL
    EndIF

Return(cUsrMail)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:WF4Mail
        Autor:Marinaldo de Jesus
        Data:05/07/2011
        Descricao:Verifica e-mail Substituto
        Sintaxe:<Vide Parametros Formais>
    /*/
//------------------------------------------------------------------------------------------------
METHOD WF4Mail(cMail) CLASS NDJLIB014
RETURN(WF4Mail(@cMail))
Static Function WF4Mail(cMail)

    Local cWF4Mail:=cMail
    Local cWF4Filial:=xFilial("WF4")

    Local cWF4KSeek
    Local cMailSubst

    Local dDate:=MsDate()

    Local nZ4De:=GetSx3Cache("WF4_DE","X3_TAMANHO")
    Local nWF4Order:=RetOrder("WF4","WF4_FILIAL+WF4_DE")

    DEFAULT cWF4Mail:=""

    BEGIN SEQUENCE

        WF4->(dbSetOrder(nWF4Order))
        cWF4Mail:=Padr(Upper(AllTrim(cWF4Mail)),nZ4De)
        cWF4KSeek:=cWF4Filial
        cWF4KSeek+=cWF4Mail
        IF WF4->(dbSeek(cWF4KSeek,.F.))
            While WF4->(!Eof() .and. (WF4_FILIAL+WF4_DE==cWF4KSeek))
                IF WF4->(dDate>=WF4_DTINI .and. dDate<=WF4_DTFIM)
                    cMailSubst:=AllTrim(WF4->WF4_PARA)
                    IF !Empty(cMailSubst)
                        cWF4Mail:=cMailSubst
                        BREAK
                    EndIF
                EndIF
                WF4->(dbSkip())
            End While    
        EndIF

    END SEQUENCE

    cWF4Mail:=Lower(AllTrim(cWF4Mail))

Return(cWF4Mail)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:RetCodUsr
        Autor:Marinaldo de Jesus
        Data:08/11/2005
        Descricao:Retorna ID do Usuario
        Sintaxe:<Vide Parametros Formais>
    /*/
//------------------------------------------------------------------------------------------------
METHOD RetCodUsr() CLASS NDJLIB014
RETURN(RetCodUsr())
Static Function RetCodUsr()

    Local cUserId
    
    Begin Sequence
    
        IF  (Type("__cUserId")=="C")
            cUserId:=__cUserId
            IF !Empty(cUserId)
                Break
            EndIF
        Else
            cUserId:=Space(6)
        EndIF    
    
        IF !(Type("cUsuario")=="C")
            Break
        EndIF
    
        PswOrder(2)
        IF !(PswSeek(SubStr(cUsuario,7,15)))
            Break
        EndIF
        
        cUserId:=PswRet(1)[1][1]
    
    End Sequence

Return(cUserId)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:InGrpAdmin
        Autor:Marinaldo de Jesus
        Data:08/11/2005
        Descricao:Verifica se Usuario Faz Parte do Grupo de Administradores
        Sintaxe:<Vide Parametros Formais>
    /*/
//------------------------------------------------------------------------------------------------
METHOD InGrpAdmin(lFinal,cFinalMsg) CLASS NDJLIB014
RETURN(InGrpAdmin(@lFinal,@cFinalMsg))
Static Function InGrpAdmin(lFinal,cFinalMsg)

    Local lIsGrpAdmin:=(PswUsrGrp(RetCodUsr(),"000000") .or. (RetCodUsr()=="000000"))
    
    Local bError
    Local bErrorBlock

    IF .NOT.(lIsGrpAdmin) 
        bError:={|e|BREAK(e)}
        bErrorBlock:=ErrorBlock(bError)
        BEGIN SEQUENCE
            lIsGrpAdmin:=FWIsAdmin(RetCodUsr())
        RECOVER
            lIsGrpAdmin:=.F.
        END SEQUENCE
        ErrorBlock(bErrorBlock)
    EndIF    
    
    DEFAULT lFinal:=.T.
    DEFAULT cFinalMsg:="Apenas Adminisrtradores Podem Executar Essa Rotina"
    
    IF (;
            !(lIsGrpAdmin);
            .and.;
            (lFinal);
   )    
        Final(cFinalMsg)
    EndIF

Return(lIsGrpAdmin)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:UserNRetID
        Autor:Marinaldo de Jesus
        Data:02/04/2011
        Descricao:Retorna o ID do Usuario de Acordo com o Nome (login)
        Sintaxe:<Vide Parametros Formais>
    /*/
//------------------------------------------------------------------------------------------------
METHOD UserNRetID(cUsrName) CLASS NDJLIB014
RETURN(UserNRetID(@cUsrName))
Static Function UserNRetID(cUsrName)

    Local cUserID:=""

    BEGIN SEQUENCE

        IF !(UserExist(cUsrName))
            BREAK
        EndIF

        cUserID:=PswRet(1)[1][1]
    
    END SEQUENCE
    
    PswOrder(1)

Return(cUserID) 

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:UserExist
        Autor:Marinaldo de Jesus
        Data:02/04/2011
        Descricao:Verifica se o Usuario Existe
        Sintaxe:<Vide Parametros Formais>
    /*/
//------------------------------------------------------------------------------------------------
METHOD UserExist(cUsrName,lChkBlock) CLASS NDJLIB014
RETURN(UserExist(@cUsrName,@lChkBlock))
Static Function UserExist(cUsrName,lChkBlock)
    
    Local lUserExist:=.F.
    Local lIsBlocked:=.F.

    PswOrder(2)

    lUserExist:=PswSeek(cUsrName)
    
    IF (lUserExist)
        DEFAULT lChkBlock:=.T.
        IF (lChkBlock)
            lIsBlocked:=PswRet(1)[1][17]
            lUserExist:=!(lIsBlocked)
        EndIF
    EndIF
    
    PswOrder(1)

Return(lUserExist)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:ULGDecrypt
        Autor:Marinaldo de Jesus
        Data:25/10/2010
        Descricao:Retorna Conteudo dos campos UserLG Descriptografados
        Sintaxe:<Vide Parametros Formais>
    /*/
//------------------------------------------------------------------------------------------------
METHOD ULGDecrypt(cUserLG,nRet) CLASS NDJLIB014
RETURN(ULGDecrypt(@cUserLG,@nRet))
Static Function ULGDecrypt(cUserLG,nRet)

    Local cLG:=Embaralha(cUserLG,1)
    Local cUser:=SubStr(cLG,1,15)
    Local cData:=SubStr(cLG,16)
    Local dData:=Ctod("01/01/96","DDMMYY")+Load2In4(cData)
    
    Local uRet

    DEFAULT nRet:=1
    
    DO CASE
    CASE (nRet==1)
        uRet:={cUser,dData}
    CASE (nRet==2)
        uRet:=cUser
    CASE (nRet==3)
        uRet:=dData
    ENDCASE    

Return(uRet)
