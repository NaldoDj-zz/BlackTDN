/*
    *Harbour Project source code:
    *TDecode class
*/

#include "ndj.ch"

CLASS TDecode FROM LongClassName

    METHOD New() CONSTRUCTOR

    METHOD Decode(cString)
    METHOD Encode(cString)

    METHOD Encode64(cData)
    METHOD Decode64(cData)

    METHOD EncodeUTF8(cData)
    METHOD DecodeUTF8(cData)

    METHOD MD5(cData,nEncrypt)
    
    METHOD Embaralha(cData,nOption)

    METHOD ClassName()

    CLASSDATA cCharPos      HIDDEN
    CLASSDATA cClassName    HIDDEN

ENDCLASS

User Function TDecode()
Return(TDecode():New())

METHOD New() CLASS TDecode
    self:ClassName()
    self:cCharPos:="0123456789abcdef"
return Self

METHOD ClassName() CLASS TDecode
    self:cClassName:="TDECODE"
Return(self:cClassName)

METHOD Decode(cString) CLASS TDecode

    LOCAL cRet:=""
    LOCAL nChars,nDec,i,cChar
    LOCAL nPos1,nPos2

    i=1
    nChars=Len(cString)

    While i<(nChars+1)
       cChar=SubStr(cString,i,1)
       if cChar=="+"
          cRet+=" "
       elseif cChar=="%"
          cChar:=lower(SubStr(cString,i+1,2))
          nPos1:=AT(Left(cChar,1),self:cCharPos)-1
          nPos2:=AT(Right(cChar,1),self:cCharPos)-1
          nDec:=(nPos1*16)+nPos2
          cRet+=CHR(nDec)
          i+=2
       else
          cRet+=cChar
       endif
       i++
    End While
    
Return(cRet)

METHOD Encode(cString) CLASS TDecode

    LOCAL cRet:=""
    LOCAL nChars,nChar,i,cChar
    
    i:=1
    nChars=Len(cString)
    
    While i<(nChars+1)
       cChar=SubStr(cString,i,1)
       if cChar==" "
          cRet+="+"
       Elseif cChar>="a" .And. cChar<="z"
          cRet+=cChar
       Elseif cChar>="A" .And. cChar<="Z"
          cRet+=cChar
       Elseif cChar>="0" .And. cChar<="9"
          cRet+=cChar
       Else
          nChar=Asc(cChar)
          cRet+="%"+SubStr(self:cCharPos,Int(nChar/16)+1,1)+SubStr(self:cCharPos,nChar-Int(nChar/16)*16+1,1)
       EndIf
       i++
    End While

Return(cRet)

METHOD Encode64(cData) CLASS TDecode
Return(Encode64(cData))

METHOD Decode64(cData) CLASS TDecode
Return(Decode64(cData))

METHOD EncodeUTF8(cData) CLASS TDecode
Return(EncodeUTF8(cData))

METHOD DecodeUTF8(cData) CLASS TDecode
Return(DecodeUTF8(cData))

METHOD MD5(cData,nEncrypt) CLASS TDecode
    DEFAULT nEncrypt:=0 //1-Encrypt
Return(MD5(cData,nEncrypt))

METHOD Embaralha(cData,nOption) CLASS TDecode
    DEFAULT nOption:=0
Return(Embaralha(cData,nOption))
