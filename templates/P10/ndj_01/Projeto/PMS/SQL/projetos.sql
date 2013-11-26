SELECT AF8_PROJET 
      ,AF8_REVISA 
      ,AF8_DESCRI
      ,AF8_XCODOR 
      ,AF1_DESCRI 
      ,AF1_ORCAME
      ,AF1_XCODOR       
      ,AF8_XDORIG
      ,AF8_XCODTE
      ,AF8_XTEMA
      ,AF8_XCODTA
      ,AF8_XDESTA
      ,AF8_XCODIN
      ,AF1_XIND
      ,AF1_XINDS
      ,AF8_XCODSP
      ,AF8_XSPON
      ,AF8_XCODGE
      ,AF8_XGER
      ,AF1_XDIR   
      ,AF1_XUNIOR 
      ,AF8_XCODSP
      ,AF8_XSPON  
      ,AF1_XGER   
      ,AF1_XDESTA 
      ,AF1_XMACRO 
      ,AF1_XIND   
      ,AF1_XINDS  
      ,AF1_XTEMA  
      ,AF1_XDESC  
      ,AF1_XDPROG 
      ,AF1_XDATIN 
      ,AF1_XDATFI 
      ,AF1_FASE   
      ,AF1_XSTATU 
      ,AF1_XPRIO  

  FROM AF1010 AS AF1 
       LEFT JOIN
       AF8010 AS AF8 ON AF8.AF8_ORCAME = AF1.AF1_ORCAME AND 
                        AF8.AF8_XCODOR = AF1.AF1_XCODOR                                                

 WHERE AF1.D_E_L_E_T_ = ''
   AND AF8.D_E_L_E_T_ = ''  
   AND AF8.AF8_FASE   = '03'         
   