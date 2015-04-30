#INCLUDE "NDJ.CH"
/*/
    Funcao:ReadStackParameters
    Autor:Marinaldo de Jesus
    Data:19/01/2011
    Uso:Retornar informacoes de Variaveis da Pilha de Chamadas
    Sintaxe:StaticCall(NDJLIB006,ReadStackParameters,cStack,cParameter,cScope,cModule,aStackParameters)
/*/
Static Function ReadStackParameters(cStack,cParameter,cScope,cModule,aStackParameters)

    Local bAscan

    Local lScope
    Local lModule

    Local nStack
    Local nParameter
    
    Local uValue

    BEGIN SEQUENCE

        DEFAULT aStackParameters:=GetStackParameters()
        
        IF Empty(aStackParameters)
            BREAK
        EndIF
        
        lModule:=.NOT.(Empty(cModule))

        IF (lModule)
            bAscan:={|x|(x[1]==cStack).and.(cModule$x[2])}
        Else
            bAscan:={|x|(x[1]==cStack)}
        EndIF    
        
        nStack:=aScan(aStackParameters,bAscan)
        IF (nStack==0)
            BREAK
        EndIF

        lScope:=.NOT.(Empty(cScope))

        IF (lScope)
            bAscan:={|x|(x[STACK_INDEX_PARAMETER]==cParameter).and.(x[STACK_INDEX_SCOPE]==cScope)}
        Else
            bAscan:={|x|(x[STACK_INDEX_PARAMETER]==cParameter)}
        EndIF

        nParameter:=aScan(aStackParameters[nStack][3],bAscan)
        IF (nParameter==0)
            BREAK
        EndIF

        uValue:=aStackParameters[nStack][3][nParameter][STACK_INDEX_VALUE]

    END SEQUENCE

Return(uValue)

/*/
    Funcao:GetStackParameters
    Autor:Marinaldo de Jesus
    Data:19/01/2011
    Uso:Obtem Array com a Pilha de Chamadas que sera usado pela ReadStackParameters
    Sintaxe:StaticCall(NDJLIB006,GetStackParameters)
/*/
Static Function GetStackParameters()

    Local aStackEnv
    Local aStackParameters:=Array(0)

    Local cCRLF:=CRLF
    
    Local cStack
    Local cModule
    Local cStackEnv
    Local cSub5StackEnv
    Local cUpperStackEnv
    
    Local lIscBlock
    
    Local nStack
    Local nIndexEnv
    Local nStackEnv

    Local oException
    
    TRYEXCEPTION

        UserException("IGetStackParameters")

    CATCHEXCEPTION USING oException

        cStackEnv:=oException:ErrorEnv

        IF .NOT.(;
                    (Chr(10)$cStackEnv);
                    .and.;
                    (Chr(13)$cStackEnv);
            )    
            cStackEnv:=StrTran(cStackEnv,"  ",cCRLF)
            cStackEnv:=StrTran(cStackEnv,"STACK ",cCRLF+"STACK ")
        EndIF
        
        aStackEnv:=StrTokArr(cStackEnv,cCRLF)

        cStackEnv:=NIL

        nIndexEnv:=0
        nStackEnv:=Len(aStackEnv)
        
        While ((++nIndexEnv)<=nStackEnv)

            cUpperStackEnv:=Upper(AllTrim(aStackEnv[nIndexEnv]))
            cSub5StackEnv:=SubStr(cUpperStackEnv,1,5)
            
            IF ("PUBLIC"$cUpperStackEnv)

                IF ("PUBLICAS"==cUpperStackEnv)
                    Loop
                EndIF

                nStack:=aScan(aStackParameters,{|x|(x[1]=="PUBLIC")}) 
            
                IF (nStack==0)
                    aAdd(aStackParameters,{"PUBLIC","",Array(0)})
                    nStack:=Len(aStackParameters)
                EndIF

                cStackEnv:=aStackEnv[nIndexEnv] 
                AddStackParameters(@aStackParameters,@nStack,@cStackEnv)

            ElseIF ("STACK"==cSub5StackEnv)
                
                cStackEnv:=AllTrim(StrTran(aStackEnv[nIndexEnv],"STACK",""))
                
                lIscBlock:=(("{"$cStackEnv).and.("}"$cStackEnv).and.("|"$cStackEnv))
                
                IF (lIscBlock)
                    cStack:=SubStr(cStackEnv,AT("{",cStackEnv),RAT("}",cStackEnv))
                Else
                    cStack:=SubStr(cStackEnv,1,AT("(",cStackEnv)-1)
                EndIF    
                
                cModule:=StrTran(cStackEnv,cStack,"")

                nStack:=aScan(aStackParameters,{|x|(x[1]==cStack)}) 

                IF (nStack==0)
                    aAdd(aStackParameters,{cStack,cModule,Array(0)})
                    nStack:=Len(aStackParameters)
                EndIF
                
                IF (++nIndexEnv >nStackEnv)
                    Exit                    
                EndIF    
        
                cUpperStackEnv:=Upper(AllTrim(aStackEnv[nIndexEnv]))
                cSub5StackEnv:=SubStr(cUpperStackEnv,1,5)

                While (;
                            ((nIndexEnv)<=nStackEnv);
                            .and.;
                            .NOT.("STACK"==cSub5StackEnv);
                            .and.;
                            .NOT.("FILES"==cSub5StackEnv);
                            .and.;  
                            .NOT.("FIELD"==cSub5StackEnv);
                      )
 
                    cStackEnv:=aStackEnv[nIndexEnv] 

                    IF (++nIndexEnv >nStackEnv)
                        Exit
                    EndIF
                                
                    cUpperStackEnv:=Upper(AllTrim(aStackEnv[nIndexEnv]))
                    cSub5StackEnv:=SubStr(cUpperStackEnv,1,5)
 
                       While (;
                                ((nIndexEnv)<=nStackEnv);
                                .and.;
                                   .NOT.("STACK"==cSub5StackEnv);
                                   .and.;
                                   .NOT.("FILES"==cSub5StackEnv);
                                   .and.;
                                   .NOT.("PARAM"==cSub5StackEnv);
                                   .and.;  
                                .NOT.("FIELD"==cSub5StackEnv);
                                .and.;
                                .NOT.("LOCAL"==cSub5StackEnv);
                                   .and.;
                                   .NOT.("PRIVATE"==SubStr(cUpperStackEnv,1,7));
                       )
                                                        
                        cStackEnv +=aStackEnv[nIndexEnv]
                                                    
                        IF (++nIndexEnv >nStackEnv)
                            Exit
                        EndIF    

                        cUpperStackEnv:=Upper(AllTrim(aStackEnv[nIndexEnv]))
                        cSub5StackEnv:=SubStr(cUpperStackEnv,1,5)
                        
                    End While
                    
                    --nIndexEnv

                    AddStackParameters(@aStackParameters,@nStack,@cStackEnv)

                    IF (++nIndexEnv >nStackEnv)
                        Exit
                    EndIF    

                    cUpperStackEnv:=Upper(AllTrim(aStackEnv[nIndexEnv]))
                    cSub5StackEnv:=SubStr(cUpperStackEnv,1,5)

                   End While

                   --nIndexEnv

            ElseIF ("FILES"==cSub5StackEnv)
            
                Exit

            EndIF
                
        End While

    ENDEXCEPTION

Return(aStackParameters)

/*/
    Funcao:AddStackParameters
    Autor:Marinaldo de Jesus
    Data:19/01/2011
    Uso:Carregar os Valores da Pilha de Chamadas
    Sintaxe:AddStackParameters(aStackParameters,nStack,cStackEnv)
/*/
Static Function AddStackParameters(aStackParameters,nStack,cStackEnv)

    Local aScope
    Local aTokens:=StrTokArr(cStackEnv,":")
    Local aDateFormat
    
    Local cType
    Local cScope
    Local cParameter
    Local cDateFormat:=Set(4)

    Local dDate

    Local nToken
    Local nTokens:=Len(aTokens)
    Local nParameter
    Local nDateFormat

    Local uValue

    IF (nTokens>=1)
        aScope:=StrTokArr(aTokens[1]," ")
        IF (Len(aScope)>=1)
            cScope:=Upper(AllTrim(aScope[1]))
        Else
            cScope:="UNDEFINED"
        EndIF
    Else
        cScope:="UNDEFINED"
    EndIF    

    IF (nTokens>=2)
        cStackEnv:=aTokens[2]
           cParameter:=AllTrim(SubStr(cStackEnv,1,AT("(",cStackEnv)-1))
           cType:=SubStr(cStackEnv,AT("(",cStackEnv)+1,1)
       Else
           cParameter:="NULL"
           cType:="U"
       EndIF    

    IF (nTokens>=3)
        uValue:=aTokens[3]
        IF (nTokens >3)
            nToken:=3
            While ((++nToken)<=nTokens)
                uValue +=aTokens[nToken]
            End While
        EndIF
    Else
        uValue:=NIL
    EndIF    

    TRYEXCEPTION

        IF (cScope$"PUBLIC/PRIVATE")

            uValue:=&(cParameter)

        Else

            Do Case
                Case (cType=="C")
                    //...
                Case (cType=="N")
                    uValue:=Val(uValue)
                Case (cType=="D")
                    dDate:=Ctod(uValue)
                    IF Empty(dDate)
                        aDateFormat:={"yyyy/mm/dd","yyyy-mm-dd","mm/dd/yyyy","mm-dd-yyyy","dd/mm/yyyy","dd-mm-yyyy"}
                        For nDateFormat:=1 To Len(aDateFormat)
                            Set(4,aDateFormat[nDateFormat])
                            dDate:=Ctod(uValue)
                            IF .NOT.(Empty(dDate))
                                Exit
                            EndIF
                        Next nDateFormat
                    EndIF    
                    uValue:=dDate
                Case (cType=="L")
                    uValue:=&(uValue)
                Case (cType=="B")
                    uValue:=&(uValue)
                Case (cType=="A")
                    uValue:={}
                Case (cType$"U/O")
                    uValue:=NIL
            OtherWise
                uValue:=NIL    
            End Case 

        EndIF
            
    CATCHEXCEPTION

        Do Case
            Case (cType=="C")
                uValue:=""
            Case (cType=="N")
                uValue:=0
            Case (cType=="D")
                dDate:=Ctod("")
            Case (cType=="L")
                uValue:=.F.
            Case (cType=="B")
                uValue:={||.F.}
            Case (cType=="A")
                uValue:={}
            Case (cType$"U/O")
                uValue:=NIL
        OtherWise
            uValue:=NIL    
        End Case     

    ENDEXCEPTION                    

    aAdd(aStackParameters[nStack][3],Array(STACK_INDEX_ELEMENTS))

    nParameter:=Len(aStackParameters[nStack][3])

    aStackParameters[nStack][3][nParameter][STACK_INDEX_PARAMETER]:=cParameter
    aStackParameters[nStack][3][nParameter][STACK_INDEX_SCOPE]:=cScope
    aStackParameters[nStack][3][nParameter][STACK_INDEX_TYPE]:=cType
    aStackParameters[nStack][3][nParameter][STACK_INDEX_VALUE]:=uValue

    Set(4,cDateFormat)

Return(NIL)

Static Function __Dummy(lRecursa)
    Local oException
    TRYEXCEPTION
        lRecursa:=.F.
        IF .NOT.(lRecursa)
            BREAK
        EndIF
        ReadStackParameters()
        lRecursa:=__Dummy(.F.)
        SYMBOL_UNUSED(__cCRLF)
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return(lRecursa)