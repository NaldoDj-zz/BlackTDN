#include "totvs.ch"

Static oNDJLIB037

CLASS NDJLIB037

    DATA cClassName

    METHOD NEW() CONSTRUCTOR
    METHOD ClassName()

    METHOD RoundingDistribute(nParts,nValParts,lHoursDistribute,nDec)

ENDCLASS

User Function DJLIB037()
    DEFAULT oNDJLIB037:=NDJLIB037():New()
RETURN(oNDJLIB037)

METHOD NEW() CLASS NDJLIB037
    self:ClassName()
RETURN(self)

METHOD ClassName() CLASS NDJLIB037
    self:cClassName:="NDJLIB037"
RETURN(self:cClassName)

//--------------------------------------------------------------------------------------------------------------
    /*/
        Funcao:RoundingDistribute
        Autor:Marinaldo de Jesus (BlackTDN:http://www.blacktdn.com.br)
        Data:29/09/2016
        Descricao:Distribuir Arrendondamento entre nPartes
        Sintaxe:StaticCall(NDJLIB037,RoundingDistribute,nParts,nValParts,lHoursDistribute,nDec))
    /*/
//--------------------------------------------------------------------------------------------------------------
METHOD RoundingDistribute(nParts,nValParts,lHoursDistribute,nDec) CLASS NDJLIB037
RETURN(RoundingDistribute(@nParts,@nValParts,@lHoursDistribute,@nDec))
Static Function RoundingDistribute(nParts,nValParts,lHoursDistribute,nDec)

    Local aDistribution:={}
    Local nDistribution:=0
    Local nAux:=0

    Local bTot
    Local bPlus
    Local bRemaining
    Local nRemaining
    Local nFatRemaining
    Local nMinRemaining

    DEFAULT nParts:=1
    DEFAULT nValParts:=0
    DEFAULT lHoursDistribute:=.T.

    aDistribution:=Array(nParts)
    aFill(aDistribution,nDistribution)

    DEFAULT nDec:=2
    nFatRemaining:=Val("1"+Replicate("0",nDec))
    nMinRemaining:=(1/nFatRemaining)

    IF (;
            (nParts==1);
            .or.;
            ((nDistribution:=__NoRound((nValParts/nParts),nDec))==0);
    )
        aDistribution[nParts]:=nValParts
    Else
        aFill(aDistribution,nDistribution)
        IF (lHoursDistribute)
            bTot:={|x|(nAux:=SomaHoras(nAux,x))}
            bPlus:={|x,y|(aDistribution[y]:=SomaHoras(aDistribution[y],nDistribution))}
            bRemaining:={||(nRemaining:=SubHoras(nValParts,nAux))}
        Else
            bTot:={|x|(nAux+=x)}
            bPlus:={|x,y|(aDistribution[y]+=nDistribution)}
            bRemaining:={||(nRemaining:=(nValParts-nAux))}
        EndIF
        While (.NOT.(aEval(aDistribution,bTot),(nAux==nValParts)))
            IF (Eval(bRemaining)<=nMinRemaining)
                IF (lHoursDistribute)
                    aDistribution[nParts]:=SomaHoras(aDistribution[nParts],nRemaining)
                Else
                    aDistribution[nParts]+=nRemaining
                EndIF
                Exit
            Else
                nDistribution:=Round((nRemaining/nParts),nDec)
                aEval(@aDistribution,bPlus)
                IF ((nDistribution*nParts)>nRemaining)
                    IF (lHoursDistribute)
                        aDistribution[nParts]:=SubHoras(aDistribution[nParts],nDistribution)
                    Else
                        aDistribution[nParts]-=nDistribution
                    EndIF
                EndIF
            EndIF
            nAux:=0
        End While
    EndIF

Return(aDistribution)

#include "tryexception.ch"
