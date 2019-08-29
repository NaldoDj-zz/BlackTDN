#INCLUDE "NDJ.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IUSUARIO Autor ³ LAPORTE               º Data ³  22/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ GRAVAÇÃO DA TABELA AJF010 COM O USUARIO QUE TERÁ ACESSO    º±±
±±º          ³ LIBERADO PARA UM DETERMINADO PROJETO                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AF1                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                 
User Function PMA100ALT()

AF8->(DBSETORDER(4))
IF AF8->(DBSEEK(XFILIAL("AF8")+AF1->AF1_ORCAME))
   RecLock("AF8",.F.)
   AF8_XCODTA     :=  AF1_XCODTA  
   AF8_XDESTA     :=  AF1_XDESTA  

   AF8_XCODOR   :=  AF1_XCODOR  
   AF8_XDORIG     :=  AF1_XDORIG  

   AF8_XCODSP   :=  AF1_XCODSP  
   AF8_XSPON      :=  AF1_XSPON

   AF8_XCODGE   :=  AF1_XCODGE  
   AF8_XGER      :=  AF1_XGER  

   AF8_XCODPR   :=  AF1_XCODPR  
   AF8_XDPROG   :=  AF1_XDPROG  

   AF8_XCODDI   :=  AF1_XCODDI  
   AF8_XDIR      :=  AF1_XDIR  

   AF8_XCODOE   :=  AF1_XCODOE  
   AF8_XDESC      :=  AF1_XDESC

   AF8_XCODPM      :=  AF1_XCODPM
   AF8_XPMORG   :=  AF1_XPMORG  

   AF8_XCODIS   :=  AF1_XCODIS  
   AF8_XINDS      :=  AF1_XINDS 

   AF8_XCODTE   :=  AF1_XCODTE  
   AF8_XTEMA      :=  AF1_XTEMA 

   AF8_XCODUN   :=  AF1_XCODUN  
   AF8_XUNIOR   :=  AF1_XUNIOR  

   AF8_XCODMA   :=  AF1_XCODMA  
   AF8_XMACRO   :=  AF1_XMACRO  

   AF8_XCODIN   :=  AF1_XCODIN  
   AF8_XIND      :=  AF1_XIND  

   AF8_XCODUN     :=  AF1_XCODUN  
   AF8_XUNIOR   :=  AF1_XUNIOR  

   MSUNLOCK()  
   
Endif

//ALERT("ORCAMENTO - "+AF1->AF1_ORCAME)
Return .T.

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        lRecursa := __Dummy( .F. )
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
