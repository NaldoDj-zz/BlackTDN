
SELECT AF8_PROJET,
       AF8_DESCRI,             
       AF8_REVISA,
       AF8_XCODOR,
       AF8_XDORIG,    
       AF8_XCODTE,
       AF8_XTEMA ,
       AF8_XCODTA,
       AF8_XDESTA,
       AF8_XCODIN,
       AF1_XIND  ,
       AF1_XINDS ,
       AF8_XCODSP, 
       AF8_XSPON ,
       AF8_XCODGE,
       AF8_XGER            

  FROM AF1010 AS AF1,  
       AF8010 AS AF8
       
 WHERE AF1.D_E_L_E_T_ = ''
   AND AF8.D_E_L_E_T_ = ''  
   AND AF8.AF8_FASE   = '03'         
   AND AF8.AF8_ORCAME = AF1.AF1_ORCAME
   @USERID

ORDER BY AF8_DESCRI
