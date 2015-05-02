#include "ndj.ch"
/*/
    Funcao:Scheduler
    Autor:Marinaldo de Jesus 
    Data:28/11/2011
    Descricao:Chamada a Processos Scheduler
    Sintaxe:<Vide Parametros Formais>
/*/
Static Function Scheduler(aParamUser) /*/ Array com dois elementos 1=cEmp (Codigo da Empresa),2=cFil (Codigo da Filial),3=bExec (Bloco a seq Executado)  /*/

    Local aArea:=IF(!Empty(Alias()),GetArea(),NIL)
    Local aMsgErr:={}
    
    Local cLstEmp:="__cLstEmp__"
    
    Local nInitLoop:=1
    
    Local aEmpFil
    Local aModuloReSet
    
    Local bExec
    
    Local cEmp
    Local cFil
    Local cMsgErr
    
    Local lSetCentury
    
    Local nRec
    Local nLoop
    Local nLoops
    
    Local uRet
    
    DEFAULT aParamUser:=Array(03)
    
    SetsDefault()
    lSetCentury:=__SetCentury("on")
    
    aModuloReSet:=SetModulo("SIGACFG","CFG")
    
    IF (Len(aParamUser)>=1)
        cEmp:=aParamUser[1]
    EndIF
    IF (Len(aParamUser)>=2)
        cFil:=aParamUser[2]
    EndIF
    IF (Len(aParamUser)>=3)
        bExec:=aParamUser[3]
    EndIF
    
    DEFAULT bExec:={||.T.}
    
    aEmpFil:=EmpFilArr(.T.)
    
    IF (;
            !Empty(cEmp);
            .and.;
            !Empty(cFil);
)    
        nInitLoop:=aScan(aEmpFil,{|x|((x[1]==cEmp) .and. (x[2]==cFil))})
        IF (nInitLoop>0)
            nLoops:=aScan(aEmpFil,{|x|((x[1]==cEmp) .and. (x[2]<> cFil))},nInitLoop+1)
            IF (nLoops>0)
                --nLoops
            Else
                nLoops:=aScan(aEmpFil,{|x|(x[1]<> cEmp)},nInitLoop+1)
                IF (nLoops>0)
                    --nLoops
                EndIF
            EndIF
            IF (nLoops==0)
                nLoops:=Len(aEmpFil)
            EndIF
        EndIF
    ElseIF (;
                !Empty(cEmp);
                .and.;
                Empty(cFil);
 )
        nInitLoop:=aScan(aEmpFil,{|x|(x[1]==cEmp)})
        IF (nInitLoop>0)
            nLoops:=aScan(aEmpFil,{|x|(x[1]<> cEmp)},nInitLoop+1)
            IF (nLoops>0)
                --nLoops
            EndIF
            IF (nLoops==0)
                nLoops:=Len(aEmpFil)
            EndIF
        EndIF
    Else
        nLoops:=Len(aEmpFil)
    EndIF
    
    nInitLoop:=Max(nInitLoop,1)
    For nLoop:=nInitLoop To nLoops
        cEmp:=aEmpFil[nLoop,01]
        IF !RpcChkSxs(cEmp,@aMsgErr,.F.)
            Loop
        EndIF
        cFil:=aEmpFil[nLoop,02]
        nRec:=aEmpFil[nLoop,03]
        RpcSetType(3)
        PREPARE ENVIRONMENT EMPRESA (cEmp) FILIAL (cFil) MODULO "CFG"
            #IFDEF TOP
                SetTopType("A")
            #ENDIF
            cEmpAnt:=cEmp
            cFilAnt:=cFil
            SM0->(MsGoto(nRec))
            uRet:=Eval(bExec,cEmp,cFil)
        RESET ENVIRONMENT
    Next nLoop
    
    ConOut(CRLF)
    nLoops:=Len(aMsgErr)
    For nLoop:=1 To nLoops
        ConOut(aMsgErr[nLoop,2])
        ConOut(CRLF)
    Next nLoop
    ConOut(CRLF)
    
    ReSetModulo(aModuloReSet)
    
    IF !(lSetCentury)
        __SetCentury("off")
    EndIF
    
    IF !(aArea==NIL)
        RestArea(aArea)
    EndIF

Return(uRet)

/*/
    Funcao:EmpFilArr
    Autor:Marinaldo de Jesus
    Data:28/11/2011
    Descricao:Carrega Informacos do SIGAMAT.EMP
    Sintaxe:<Vide Parametros Formais>
/*/
Static Function EmpFilArr(lUnique)

    Local aEmpFil:={}
    
    Begin Sequence
    
        IF (Select("SM0")==0)
            Private cArqEmp:="sigamat.emp"
            OpenSM0()
        EndIF
    
        IF (Select("SM0")==0)
            Break
        EndIF
    
        DEFAULT lUnique:=.F.
        SM0->(dbGotop())
        While SM0->(!Eof())
            IF SM0->(!deleted())
                IF (;
                        !(lUnique);
                        .or.;
                        (;
                            (lUnique);
                            .and.;
                            (SM0->(UniqueKey("M0_CODIGO","SM0")));
             );
         )        
                    SM0->(aAdd(aEmpFil,{M0_CODIGO,M0_CODFIL,Recno()}))
                EndIF    
            EndIF
            SM0->(dbSkip())
        End While
    
    End Sequence

Return(aEmpFil)

Static Function __Dummy(lRecursa)
    Local oException
    TRYEXCEPTION
        lRecursa:=.F.
        IF !(lRecursa)
            BREAK
        EndIF
        Scheduler()
        EmpFilArr()
        lRecursa:=__Dummy(.F.)
        __cCRLF:=NIL
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return(lRecursa)
