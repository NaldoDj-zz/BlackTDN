#include "ndj.ch"
Static __oTimeCalc:=tNDJTimeCalc():New()

Static oNDJLIB030

CLASS NDJLIB030

    DATA cClassName
    
    METHOD NEW() CONSTRUCTOR
    METHOD ClassName()

    METHOD HMSToTime(nHours,nMinuts,nSeconds)
    METHOD SecsToHMS(nSecsToHMS,nHours,nMinuts,nSeconds,cRet)
    METHOD SecsToTime(nSecs)
    METHOD TimeToSecs(cTime)
    METHOD TimeToSeconds(cTime)
    METHOD SecsToHrs(nSeconds)
    METHOD HrsToSecs(nHours)
    METHOD SecsToMin(nSeconds)
    METHOD MinToSecs(nMinuts)
    METHOD IncTime(cTime,nIncHours,nIncMinuts,nIncSeconds)
    METHOD DecTime(cTime,nDecHours,nDecMinuts,nDecSeconds)
    METHOD Time2NextDay(cTime,dDate)
    METHOD ExtractTime(cTime,nHours,nMinuts,nSeconds,cRet)
    METHOD AverageTime(cTime,nDividendo,lMiliSecs)
    
ENDCLASS

User Function DJLIB030()
    DEFAULT oNDJLIB030:=NDJLIB030():New()
Return(oNDJLIB030)

METHOD NEW() CLASS NDJLIB030
    self:ClassName()
RETURN(self)

METHOD ClassName() CLASS NDJLIB030
    self:cClassName:="NDJLIB030"
RETURN(self:cClassName)

//------------------------------------------------------------------------------------------------
    /*
        Funcao:HMSToTime
        Autor:Marinaldo de Jesus
        Data:20/04/2012
        Descricao:Transformar Valores de Horas,Minutos e Segundos em String no Padrao "HH:MM:SS"
        Sintaxe:HmsToTime([<nHours>],[<nMinuts>],[<nSeconds>])
        Parametros:nHours->Valor das Horas
                   nMinuts->Valor dos Minutos
                   nSeconds->Valor dos Segundos
    */                  
//------------------------------------------------------------------------------------------------
METHOD HMSToTime(nHours,nMinuts,nSeconds) CLASS NDJLIB030
RETURN(HMSToTime(@nHours,@nMinuts,@nSeconds))
Static Function HMSToTime(nHours,nMinuts,nSeconds)
Return(__oTimeCalc:HMSToTime(@nHours,@nMinuts,@nSeconds))

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:SecsToHMS
        Autor:Marinaldo de Jesus
        Data:20/04/2012
        Descricao:Converte Segundos para Horas,Minutos e Segundos
        Sintaxe:SecsToHMS(nSecsToHMS,@nHours,@nMinuts,@nSeconds)
        Parametros:nSecsToHMS->Numero de Segundos que sera convertidos
                   nHours->Valor das Horas
                   nMinuts->Valor dos Minutos
                   nSeconds->Valor dos Segundos
                   cRet->Tipo do Retorno Desejado:"H" ou "h"->nHours
                                                  "M" ou "m"->nMinuts
                                                  "S" ou "s"->nSedonds
    */ 
//------------------------------------------------------------------------------------------------                                                         
METHOD SecsToHMS(nSecsToHMS,nHours,nMinuts,nSeconds,cRet) CLASS NDJLIB030
RETURN(SecsToHMS(@nSecsToHMS,@nHours,@nMinuts,@nSeconds,@cRet))
Static Function SecsToHMS(nSecsToHMS,nHours,nMinuts,nSeconds,cRet)
Return(__oTimeCalc:SecsToHMS(@nSecsToHMS,@nHours,@nMinuts,@nSeconds,@cRet))

//------------------------------------------------------------------------------------------------ 
    /*
        Funcao:SecsToTime
        Autor:Marinaldo de Jesus
        Data:20/04/2012
        Descricao:Converte Segundos para Horas,Minutos e Segundos retornando a string no formato "HH:MM:SS"
        Sintaxe:SecsToTime(nSecs)
        Parametros:nSeconds->Valor dos Segundos
        Retorno:"HH:MM:SS"
    */
//------------------------------------------------------------------------------------------------     
METHOD SecsToTime(nSecs) CLASS NDJLIB030
RETURN(SecsToTime(@nSecs))
Static Function SecsToTime(nSecs)
Return(__oTimeCalc:SecsToTime(nSecs))

//------------------------------------------------------------------------------------------------ 
    /*
        Funcao:TimeToSecs
        Autor:Marinaldo de Jesus
        Data:20/04/2012
        Descricao:Transformar a Sting Retornada pela Time() em Segundos
        Sintaxe:TimeToSenconds(<cTime>)
        Parametros:cTime->String Contendo as Horas,Minutos e Segundos Retorna da Pela Funcao Time "HH:MM:SS"
        Retorno:Segundos
    */
//------------------------------------------------------------------------------------------------ 
METHOD TimeToSecs(cTime) CLASS NDJLIB030
RETURN(TimeToSecs(@cTime))
Static Function TimeToSecs(cTime)
Return(__oTimeCalc:TimeToSecs(cTime))

//------------------------------------------------------------------------------------------------ 
    /*/
        Funcao:TimeToSeconds
        Autor:Marinaldo de Jesus
        Data:20/04/2012
        Descricao:Transformar a Sting Retornada pela Time() em Segundos
        Sintaxe:TimeToSenconds(<cTime>)
        Parametros:cTime->String Contendo as Horas,Minutos e Segundos Retorna da Pela Funcao Time "HH:MM:SS"
        Retorno:Segundos
        Observacao:Utiliza a Funcao TimeToSecs() para a conversao
    */
//------------------------------------------------------------------------------------------------ 
METHOD TimeToSeconds(cTime) CLASS NDJLIB030
RETURN(TimeToSeconds(@cTime))
Static Function TimeToSeconds(cTime)
Return(__oTimeCalc:TimeToSecs(cTime))

//------------------------------------------------------------------------------------------------ 
    /*/
        Funcao:SecsToHrs
        Autor:Marinaldo de Jesus
        Data:20/04/2012
        Descricao:Converte Segundos para Horas
        Sintaxe:SecsToHrs(nSeconds)
        Parametros:nSeconds->Numero de Segundos que sera convertidos
        Retorno:nHours
    */
//------------------------------------------------------------------------------------------------ 
METHOD SecsToHrs(nSeconds) CLASS NDJLIB030
RETURN(SecsToHrs(@nSeconds))
Static Function SecsToHrs(nSeconds)
Return(__oTimeCalc:SecsToHrs(nSeconds))

//------------------------------------------------------------------------------------------------ 
    /*
        Funcao:HrsToSecs
        Autor:Marinaldo de Jesus
        Data:20/04/2012
        Descricao:Converte Horas para Segundos
        Sintaxe:HrsToSecs(nHours)
        Parametros:nHours->Numero de Horas que sera convertidas
        Retorno:nSeconds
    */
//------------------------------------------------------------------------------------------------ 
METHOD HrsToSecs(nHours) CLASS NDJLIB030
RETURN(HrsToSecs(@nHours))
Static Function HrsToSecs(nHours)
Return(__oTimeCalc:HrsToSecs(@nHours))

//------------------------------------------------------------------------------------------------ 
    /*
        Funcao:SecsToMin
        Autor:Marinaldo de Jesus
        Data:20/04/2012
        Descricao:Converte Segundos para Minutos
        Sintaxe:SecsToMin(nSeconds)
        Parametros:nSeconds->Numero de Segundos que serao convertidos
        Retorno:nMinuts
    */
//------------------------------------------------------------------------------------------------ 
METHOD SecsToMin(nSeconds) CLASS NDJLIB030
RETURN(SecsToMin(@nSeconds))
Static Function SecsToMin(nSeconds)
Return(__oTimeCalc:SecsToMin(nSeconds))

//------------------------------------------------------------------------------------------------ 
    /*
        Funcao:MinToSecs
        Autor:Marinaldo de Jesus
        Data:20/04/2012
        Descricao:Converte Minutos para Segundos
        Sintaxe:MinToSecs(nMinuts)
        Parametros:nMinuts->Numero de Minutos que serao convertidos
        Retorno:nSeconds
    */
//------------------------------------------------------------------------------------------------ 
METHOD MinToSecs(nMinuts) CLASS NDJLIB030
RETURN(MinToSecs(@nMinuts))
Static Function MinToSecs(nMinuts)
Return(__oTimeCalc:MinToSecs(nMinuts))

//------------------------------------------------------------------------------------------------
    /*
        Funcao:IncTime
        Autor:Marinaldo de Jesus
        Data:20/04/2012
        Descricao:Incrementar Valores de Horas,Minutos e Segundos na String cTime
        Retorno:"HH:MM:SS"
    */
//------------------------------------------------------------------------------------------------
METHOD IncTime(cTime,nIncHours,nIncMinuts,nIncSeconds) CLASS NDJLIB030
RETURN(IncTime(@cTime,@nIncHours,@nIncMinuts,@nIncSeconds))
Static Function IncTime(cTime,nIncHours,nIncMinuts,nIncSeconds)
Return(__oTimeCalc:IncTime(@cTime,@nIncHours,@nIncMinuts,@IncSeconds))

//------------------------------------------------------------------------------------------------
    /*
        Funcao:DecTime
        Autor:Marinaldo de Jesus
        Data:20/04/2012
        Descricao:Decrementar Valores de Horas,Minutos e Segundos na String cTime
        Retorno:"HH:MM:SS"
    */
//------------------------------------------------------------------------------------------------
METHOD DecTime(cTime,nDecHours,nDecMinuts,nDecSeconds) CLASS NDJLIB030
RETURN(DecTime(@cTime,@nDecHours,@nDecMinuts,@nDecSeconds))
Static Function DecTime(cTime,nDecHours,nDecMinuts,nDecSeconds)
Return(__oTimeCalc:DecTime(@cTime,@nDecHours,@nDecMinuts,@nDecSeconds))

//------------------------------------------------------------------------------------------------
    /*
        Funcao:Time2NextDay
        Autor:Marinaldo de Jesus
        Data:20/04/2012
        Descricao:Tratar Time e Date no padrao "00:00:00" para Time>="24:00:00"
        Retorno:aTimeTo24Hr
    */
//------------------------------------------------------------------------------------------------
METHOD Time2NextDay(cTime,dDate) CLASS NDJLIB030
RETURN(Time2NextDay(@cTime,@dDate))
Static Function Time2NextDay(cTime,dDate)
Return(__oTimeCalc:Time2NextDay(@cTime,@dDate))

//------------------------------------------------------------------------------------------------
    /*
        Funcao:ExtractTime
        Autor:Marinaldo de Jesus
        Data:20/04/2012
        Descricao:Extrair Valores de Horas,Minutos e Segundos da String cTime
        Sintaxe:ExtractTime(cTime,@nHours,@nMinuts,@nSeconds,cRet)
        Parametros:cTime->String de Horas no padrao "00:00:00"
                      nHours->Valor das Horas
                      nMinuts->Valor dos Minutos
                      nSeconds->Valor dos Segundos
                      cRet->Tipo do Retorno Formal Desejado:"H" ou "h"->nHours
                                                            "M" ou "m"->nMinuts
                                                            "S" ou "s"->nSedonds
        Retorno:nRet
    */
//------------------------------------------------------------------------------------------------
METHOD ExtractTime(cTime,nHours,nMinuts,nSeconds,cRet) CLASS NDJLIB030
RETURN(ExtractTime(@cTime,@nHours,@nMinuts,@nSeconds,@cRet))
Static Function ExtractTime(cTime,nHours,nMinuts,nSeconds,cRet)
Return(__oTimeCalc:ExtractTime(@cTime,@nHours,@nMinuts,@nSeconds,@cRet))

//------------------------------------------------------------------------------------------------
    /*
        Funcao:AverageTime
        Autor:Marinaldo de Jesus
        Data:20/04/2012
        Descricao:Retornar o Tempo Medio
        Retorno:cAverageTime
    */
//------------------------------------------------------------------------------------------------
METHOD AverageTime(cTime,nDividendo,lMiliSecs) CLASS NDJLIB030
RETURN(AverageTime(@cTime,@nDividendo,@lMiliSecs))
Static Function AverageTime(cTime,nDividendo,lMiliSecs)
Return(__oTimeCalc:AverageTime(@cTime,@nDividendo,@lMiliSecs))
