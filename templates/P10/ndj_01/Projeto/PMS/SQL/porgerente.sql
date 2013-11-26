
SELECT AF8_XCODGE,
       AF8_XGER            
       
  FROM AF1010 AS AF1,  
       AF8010 AS AF8
       
 WHERE AF1.D_E_L_E_T_ = ''
   AND AF8.D_E_L_E_T_ = ''  
   AND AF8.AF8_FASE   = '03'   
   AND AF8.AF8_ORCAME = AF1.AF1_ORCAME
   @USERID

GROUP BY AF8_XCODGE,
         AF8_XGER            
       
ORDER BY AF8_XGER


