 #IFNDEF _PRVTAPON_CH

	#DEFINE _PRVTAPON_CH

    #INCLUDE "AMARC.CH"
    
    #DEFINE _AMARC_CODE_CHECK         	"Njc2NTUxNjgwODM="
    #DEFINE _AMARC_CODE_CHECK_LN	  	"ODg0OTAwMTc3MDA="
    #DEFINE _AMARC_CODE_CHECK_VM	  	"OTg2MzYwNTc3ODc="
    #DEFINE _AMARC_FIELD_CHECK        	"Q1JJQUNf"
    #DEFINE _AMARC_TABLE              	"QVNS"
    #DEFINE _AMARC_TABLE_CHK_FIELD    	(EnCode64(Embaralha((Embaralha(Decode64(_AMARC_TABLE),0))->(FieldGet(FieldPos(Embaralha(Decode64(_AMARC_FIELD_CHECK),0)))),1))==_AMARC_CODE_CHECK)
    #DEFINE _AMARC_TABLE_CHK_FIELD_LN	(EnCode64(Embaralha((Embaralha(Decode64(_AMARC_TABLE),0))->(FieldGet(FieldPos(Embaralha(Decode64(_AMARC_FIELD_CHECK),0)))),1))==_AMARC_CODE_CHECK_LN)
    #DEFINE _AMARC_TABLE_CHK_FIELD_VM	(EnCode64(Embaralha((Embaralha(Decode64(_AMARC_TABLE),0))->(FieldGet(FieldPos(Embaralha(Decode64(_AMARC_FIELD_CHECK),0)))),1))==_AMARC_CODE_CHECK_VM)

#ENDIF