#include "rwmake.ch"   
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MT110LOK บ Autor ณ Jose Carlos Noronhaบ Data ณ  22/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de entrada executado na solicitacao de compras para  นฑฑ
ฑฑ             preencher automaticamente a linha do item da SC.           นฑฑ
ฑฑ                                                                        นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function MT110LOK

Local nX

lRet := .T.

If Funname() = "MATA110"
    If Type("N") <> "U"
        nUsado := Len(aHeader)
        If Len(aCols) >= 1 .AND. lCopItSC1 = .T. .AND. (IIF(ALTERA,IIF( N=Len(aCols),.T.,.F.),.T.)) .AND. Acols[N,nUsado+1] = .F.
            cMensagem := "Deseja copiar os dados para os proximos itens da solicita็ใo de compras? "
            lCopItSC1 := MsgYesNo(cMensagem)
            nCopias   := 3
            nIt       := N
            nSeq      := val(GdFieldget("C1_ITEM"))
            nPos      := Len(aCols)
            For nx:= 1 To nCopias
                nSeq++
                nPos++
                cSeq = StrZero(nSeq,4)
                AADD(aCols, Aclone(aCols[nIt]))
                GdFieldPut("C1_ITEM",cSeq,nPos)
            Next nx    
            lCopItSC1 := .F.
        Endif    
    Endif
Endif

Return(lRet)
