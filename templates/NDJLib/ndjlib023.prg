#include "ndj.ch"

Static __nSDCount:=0

Static oNDJLIB023

CLASS NDJLIB023

    METHOD NEW() CONSTRUCTOR

    METHOD GETALLDATA()
    METHOD GETDATA()
    METHOD SENDDATA(cDest,Data)
    METHOD STATIONNAME(cSetName,lZCount)
    METHOD COMMPATH(cSetPath)
    
ENDCLASS

User Function DJLIB023()
    DEFAULT oNDJLIB023:=NDJLIB023():New()
Return(oNDJLIB023)

METHOD NEW() CLASS NDJLIB023
RETURN(self)

//------------------------------------------------------------------------------------------------
    /*/
        Function:GetAllData
        Autor:Marinaldo de Jesus
        Data:04/12/2011
        Descricao:Comunicacao de Dados baseada na Original GetData de Roberto Lopez
        Sintaxe:GetAllData()
    /*/
//------------------------------------------------------------------------------------------------
METHOD GETALLDATA() CLASS NDJLIB023
RETURN(GetAllData())
Static Function GetAllData()

    Local aPackets:=Array(0)

    Local uPacket

    While .not.((uPacket:=GetData())==NIL)
        aAdd(aPackets,uPacket)
    End While

Return(aPackets)

//------------------------------------------------------------------------------------------------
    /*/
        Function:GetData()
        Autor:Marinaldo de Jesus
        Data:04/12/2011
        Descricao:Comunicacao de Dados baseada na Original GetData de Roberto Lopez
        Sintaxe:GetData()

        MINIGUI-Harbour Win32 GUI library Demo
        Copyright 2002 Roberto Lopez<harbourminigui@gmail.com>
        http://harbourminigui.googlepages.com/

    /*/
//------------------------------------------------------------------------------------------------
METHOD GETDATA() CLASS NDJLIB023
RETURN(GetData())
Static Function GetData()

   Local PacketNames[aDir(_HMG_CommPath+_HMG_StationName+'.*')]
   Local i,Rows,Cols,RetVal:=Nil,aItem,aTemp:={},r,c
   Local DataValue,DataType,DataLength,Packet
   Local bd:=Set(_SET_DATEFORMAT)

   SET DATE TO ANSI

   aDir(_HMG_CommPath+_HMG_StationName+'.*',PacketNames)

   BEGIN SEQUENCE

      IF .not.(Len(PacketNames)>0)
            BREAK
      EndIF
    
      Packet:=ftDB():New() 
      IF .not.(Packet:ft_fUse(_HMG_CommPath+PacketNames[1])>0)
            Packet:ft_fUse()
            BREAK
      EndIF
      
      Packet:ft_fGotop()

      Rows:=Val(SubStr(Packet:ft_fReadLn(),11,99))
      Packet:ft_fSkip()
      Cols:=Val(SubStr(Packet:ft_fReadLn(),11,99))
      
      Packet:ft_fSkip()

      Do Case

         // Single Data
         Case Rows==0 .And. Cols==0

            DataType:=SubStr(Packet:ft_fReadLn(),12,1)
            DataLength:=Val(SubStr(Packet:ft_fReadLn(),14,99))
            
            Packet:ft_fSkip()

            DataValue:=Packet:ft_fReadLn()

            Do Case
               Case DataType=='C'
                  RetVal:=Left(DataValue,DataLength)
               Case DataType=='N'
                  RetVal:=Val(DataValue)
               Case DataType=='D'
                  RetVal:=CTOD(DataValue)
               Case DataType=='L'
                  RetVal:=(Alltrim(DataValue)=='T')
            End Case

         // One Dimension Array Data
         Case Rows!=0 .And. Cols==0

            i:=3
            lCount:=Packet:ft_fRecCount()

            Do While i<lCount
            
               Packet:ft_fGoTo(i)

               DataType:=SubStr(Packet:ft_fReadLn(),12,1)
               DataLength:=Val(SubStr(Packet:ft_fReadLn(),14,99))

               i++
               
               Packet:ft_fGoTo(i)

               DataValue:=Packet:ft_fReadLn()

               Do Case
                  Case DataType=='C'
                     aItem:=Left(DataValue,DataLength)
                  Case DataType=='N'
                     aItem:=Val(DataValue)
                  Case DataType=='D'
                     aItem:=CTOD(DataValue)
                  Case DataType=='L'
                     aItem:=(Alltrim(DataValue)=='T')
               End Case

               aAdd(aTemp,aItem)

               i++

            EndDo

            RetVal:=aTemp

         // Two Dimension Array Data
         Case Rows!=0 .And. Cols!=0

            i:=3

            aTemp:=Array(Rows,Cols)

            r:=1
            c:=1
            lCount:=Packet:ft_fRecCount()

            Do While i<lCount

               Packet:ft_fGoTo(i)

               DataType:=SubStr(Packet:ft_fReadLn(),12,1)
               DataLength:=Val(SubStr(Packet:ft_fReadLn(),14,99))

               i++

               Packet:ft_fGoTo(i)
               
               DataValue:=Packet:ft_fReadLn()

               Do Case
                  Case DataType=='C'
                     aItem:=Left(DataValue,DataLength)
                  Case DataType=='N'
                     aItem:=Val(DataValue)
                  Case DataType=='D'
                     aItem:=CTOD(DataValue)
                  Case DataType=='L'
                     aItem:=(Alltrim(DataValue)=='T')
               End Case

               aTemp[r][c]:=aItem

               c++
               if c>Cols
                  r++
                  c:=1
               EndIf

               i++

            EndDo

            RetVal:=aTemp

         End Case
         
         Packet:ft_fUse()

         Delete File(_HMG_CommPath+PacketNames[1])
  
      END SEQUENCE

      Set(_SET_DATEFORMAT,bd)

Return(RetVal)

//------------------------------------------------------------------------------------------------
    /*/
        Function:SendData()
        Autor:Marinaldo de Jesus
        Data:04/12/2011
        Descricao:Comunicacao de Dados baseada na Original GetData de Roberto Lopez
        Sintaxe:SendData(cDest,Data)

        MINIGUI-Harbour Win32 GUI library Demo
        Copyright 2002 Roberto Lopez<harbourminigui@gmail.com>
        http://harbourminigui.googlepages.com/

    /*/
//------------------------------------------------------------------------------------------------
METHOD SENDDATA(cDest,Data) CLASS NDJLIB023
RETURN(SendData(@cDest,@Data))
Static Function SendData(cDest,Data)

   Local cData,i,j
   Local pData,cLen,cType:=ValType(Data),FileName,Rows,Cols,fHandle

   _HMG_SendDataCount++

   FileName:=_HMG_CommPath+cDest+'.'+_HMG_StationName+'.'+Alltrim(Str(_HMG_SendDataCount))
   While File(FileName)
      _HMG_SendDataCount++
      FileName:=_HMG_CommPath+cDest+'.'+_HMG_StationName+'.'+Alltrim(Str(_HMG_SendDataCount))
   End While

   BEGIN SEQUENCE   

       fHandle:=fCreate(FileName)
       
       IF (fHandle<0)
          BREAK
       EndIF

       If cType=='A'
    
          If ValType(Data[1])!='A'
    
             cData:='#DataRows='+Alltrim(Str(Len(Data)))+__cCRLF
             fWrite(fHandle,cData)
             cData:='#DataCols=0'+__cCRLF
             fWrite(fHandle,cData)

             For i:=1 To Len(Data)
    
                cType:=ValType(Data[i])
    
                If cType=='D'
                   pData:=alltrim(str(year(data[i])))+'.'+alltrim(str(month(data[i])))+'.'+alltrim(str(day(data[i])))
                   cLen:=Alltrim(Str(Len(pData)))
                ElseIf cType=='L'
                   pData:=iif(Data[i]==.t.,'T','F')
                   cLen:=Alltrim(Str(Len(pData)))
                ElseIf cType=='N'
                   pData:=str(Data[i])
                   cLen:=Alltrim(Str(Len(pData)))
                ElseIf cType=='C'
                   pData:=Data[i]
                   cLen:=Alltrim(Str(Len(pData)))
                Else
                   MsgMiniGuiError('SendData:Type Not Supported.')
                EndIf
    
                cData:='#DataBlock='+cType+','+cLen+__cCRLF
                fWrite(fHandle,cData)
                cData:=pData+__cCRLF
                fWrite(fHandle,cData)
    
             Next i

          Else
    
             Rows:=Len(Data)
             Cols:=Len(Data[1])
    
             cData:='#DataRows='+Alltrim(Str(Rows))+__cCRLF
             fWrite(fHandle,cData)
             cData:='#DataCols='+Alltrim(Str(Cols))+__cCRLF
             fWrite(fHandle,cData)
    
             For i:=1 To Rows
    
                For j:=1 To Cols
    
                   cType:=ValType(Data[i][j])
    
                   If cType=='D'
                      pData:=alltrim(str(year(data[i][j])))+'.'+alltrim(str(month(data[i][j])))+'.'+alltrim(str(day(data[i][j])))
                      cLen:=Alltrim(Str(Len(pData)))
                   ElseIf cType=='L'
                      pData:=iif(Data[i][j]==.t.,'T','F')
                      cLen:=Alltrim(Str(Len(pData)))
                   ElseIf cType=='N'
                      pData:=str(Data[i][j])
                      cLen:=Alltrim(Str(Len(pData)))
                   ElseIf cType=='C'
                      pData:=Data[i][j]
                      cLen:=Alltrim(Str(Len(pData)))
                   Else
                      MsgMiniGuiError('SendData:Type Not Supported.')
                   EndIf
    
                   cData:='#DataBlock='+cType+','+cLen+__cCRLF
                   fWrite(fHandle,cData)
                   cData:=pData+__cCRLF
                   fWrite(fHandle,cData)
    
                Next j
             Next i
    
          EndIf
    
       Else
       
          If cType=='D'
             pData:=alltrim(str(year(data)))+'.'+alltrim(str(month(data)))+'.'+alltrim(str(day(data)))
             cLen:=Alltrim(Str(Len(pData)))
          ElseIf cType=='L'
             pData:=iif(Data==.t.,'T','F')
             cLen:=Alltrim(Str(Len(pData)))
          ElseIf cType=='N'
             pData:=str(Data)
             cLen:=Alltrim(Str(Len(pData)))
          ElseIf cType=='C'
             pData:=Data
             cLen:=Alltrim(Str(Len(pData)))
          Else
             MsgMiniGuiError('SendData:Type Not Supported.')
          EndIf
    
          cData:='#DataRows=0'+__cCRLF
          fWrite(fHandle,cData)
          cData:='#DataCols=0'+__cCRLF
          fWrite(fHandle,cData)
    
          cData:='#DataBlock='+cType+','+cLen+__cCRLF
          fWrite(fHandle,cData)
          cData:=pData+__cCRLF
          fWrite(fHandle,cData)
    
       EndIf

       fClose(fHandle)

   END SEQUENCE

Return Nil

//------------------------------------------------------------------------------------------------
    /*/
        Function:StationName
        Autor:Marinaldo de Jesus
        Data:04/12/2011
        Descricao:Define o Nome da Estacao para uso das funcoes de Comunicacao de Dados baseada na Original GetData de Roberto Lopez
        Sintaxe:StationName(cSetName,lZCount)
    /*/
//------------------------------------------------------------------------------------------------
METHOD STATIONNAME(cSetName,lZCount) CLASS NDJLIB023
RETURN(StationName(@cSetName,@lZCount))
Static Function StationName(cSetName,lZCount)
    
    Local cGetName
    
    Static __cStName
    Static __cLStName

    __cLStName:=__cStName
    
    IF (;
            (ValType(cSetName)=="C");
            .and.;
            .not.(Empty(cSetName));
    )
        __cStName:=cSetName
    EndIF

    IF Empty(__cStName)
        __cStName:=ComputerName()
    EndIF    

    DEFAULT lZCount:=.F.
    IF (;
            .not.(__cLStName==__cStName);
            .or.;
            (lZCount);
    )    
        SDataCount(0) 
    EndIF

    cGetName:=__cStName

Return(cGetName)

//------------------------------------------------------------------------------------------------
    /*/
        Function:CommPath
        Autor:Marinaldo de Jesus
        Data:04/12/2011
        Descricao:O Path para gravacao dos dados usado nas funcoes de Comunicacao de Dados baseada na Original GetData de Roberto Lopez
        Sintaxe:CommPath(cSetPath)
    /*/
//------------------------------------------------------------------------------------------------
METHOD COMMPATH(cSetPath) CLASS NDJLIB023
RETURN(CommPath(@cSetPath))
Static Function CommPath(cSetPath)
    
    Local cGetPath
    
    Static __cCommPath
    
    IF (;
            (ValType(cSetPath)=="C");
            .and.;
            .not.(Empty(cSetPath));
    )
        __cCommPath:=cSetPath
    Else
        DEFAULT __cCommPath:=GetPvProfString(GetEnvServer(),"CommPath","",GetSrvIniName())
    EndIF

    IF Empty(__cCommPath)
        __cCommPath:=GetSrvProfString("RootPath","")
    EndIF    

    __cCommPath:=Lower(AllTrim(__cCommPath))
    IF .not.(SubStr(__cCommPath,-1)=="\")
        __cCommPath+="\"
    EndIF
    
    cGetPath:=__cCommPath

Return(cGetPath)

//------------------------------------------------------------------------------------------------
    /*/
        Function:SDataCount
        Autor:Marinaldo de Jesus
        Data:04/12/2011
        Descricao:Contador para o Numero de arquivos em uso nas funcoes de Comunicacao de Dados baseada na Original GetData de Roberto Lopez
        Sintaxe:SDataCount(nSet) 
    /*/
//------------------------------------------------------------------------------------------------
Static Function SDataCount(nSet) 
    IF (ValType(nSet)=="N")
        __nSDCount:=nSet
    EndIF    
Return(__nSDCount)
