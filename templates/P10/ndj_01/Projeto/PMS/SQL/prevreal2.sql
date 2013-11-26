SELECT '''' + AF8_PROJET                  'Id Projeto'  ,
       '''' + AF8_REVISA                  'Revisao Projeto',
       AF1_DESCRI                         'Nome da Acao',       
       '''' + AF1_ORCAME                  'Id Orcamento',
       '''' + AF1_XCODOR                  'Origem de Recurso',       
       AF1_XDORIG                         'Desc. Origem',       
       ROW_NUMBER() OVER( ORDER BY AF8_PROJET, AF8_REVISA, AF8_XCODOR, AF1_ORCAME, AF1_XCODOR ) 'Item',
       AF1_XDIR                           'Diretoria',
       AF1_XUNIOR                         'Unidade Organ.',     
       AF1_XSPON                          'Sponsor',
       AF1_XGER                           'Gerente',     
       AF1_XDESTA                         'Tipo de Acao', 
       AF1_XMACRO                         'Macroprocesso',  
       AF1_XIND                           'Indicador 1',
       AF1_XINDS                          'Indicador 2',
       AF1_XPMORG                         'Macroprocesso Interno',      
       AF1_XTEMA                          'Tema Estategico',
       AF1_XDESC                          'Objetivo Estrategico',   
       AF1_XDPROG                         'Programa',   	      	   
       PREVPJ                             'PREVISTO - Contratos de Prestação de Serviços',
       REALPJ                             'REALIZADO - Contratos de Prestação de Serviços',
       PREVPF                             'PREVISTO - Pessoal PJ',              
       REALPF                             'REALIZADO - Pessoal PJ',        
       PREVPPF                            'PREVISTO - Pessoal PF',   	   
       REALPPF                            'REALIZADO - Pessoal PF',   	         
       PREVPESSOAL                        'PREVISTO - Pessoal CLT',
       REALPESSOAL                        'REALIZADO - Pessoal CLT',
       PREVCUSTEIO                        'PREVISTO - Operacional Administrativo',
       REALCUSTEIO                        'REALIZADO - Operacional Administrativo',
       PREVCAPITAL                        'PREVISTO - Capital',
       REALCAPITAL                        'REALIZADO - Capital',
       PREVVIAGEM                         'PREVISTO - Viagem',
       REALVIAGEM                         'REALIZADO - Viagem',
       PREVTOTORC                         'Total PREVISTO',
       REALTOTORC                         'Total REALIZADO',
       AJCTOT                             'Total Apontamento Direto',       
       CONVERT( VARCHAR, CONVERT( DATETIME, CONVERT( VARCHAR, AF1_XDATIN ) ), 103 )                        'Data Inicial',
       CONVERT( VARCHAR, CONVERT( DATETIME, CONVERT( VARCHAR, AF1_XDATFI ) ), 103 )                        'Data Final',
       DESCSTATUS                         'Status',
       AF1_FASE                           'Fase',
       DESCFASE                           'Descricao da Fase',       
       AF1_XPRIO                          'Prioridade'	

FROM 
(

SELECT AF1.AF1_ORCAME,
       AF8.AF8_PROJET,
       AF8.AF8_REVISA,
       AF8.AF8_XCODOR,       
       AF1.AF1_DESCRI,
       AF1.AF1_XCODOR,
       AF1.AF1_XDORIG,
   	   AF1.AF1_XDIR,
   	   AF1.AF1_XUNIOR,
   	   AF1.AF1_XSPON,
   	   AF1.AF1_XGER,
   	   AF1.AF1_XDESTA,
  	   AF1.AF1_XMACRO,  	   
   	   AF1.AF1_XIND,
   	   AF1.AF1_XINDS,
   	   AF1.AF1_XPMORG,
   	   AF1.AF1_XTEMA,
   	   AF1.AF1_XDESC,
   	   AF1.AF1_XDPROG,

      ISNULL( ( SELECT CONVERT( MONEY, SUM( AF4_VALOR ), 2 )
				  FROM AF4010 AS AF4
				 WHERE AF4.D_E_L_E_T_ = ''
				   AND AF4.AF4_ORCAME = AF1.AF1_ORCAME 
				   AND AF4.AF4_XCODOR = AF1.AF1_XCODOR
				   AND AF4.AF4_TIPOD IN ( 'SJ', 'MO' )
				GROUP BY AF4.AF4_ORCAME, AF4.AF4_XCODOR ), 0 ) AS 'PREVPJ',
				
      ISNULL( ( SELECT CONVERT( MONEY, ( SD1TOTAL ), 2 )
                  FROM ( SELECT SD1.D1_XPROJET, SD1.D1_XREVIS, SD1.D1_XCODOR, SUM( SD1.D1_TOTAL ) AS SD1TOTAL
						   FROM SD1010 AS SD1 
						  WHERE SD1.D_E_L_E_T_  = '' 
							AND SD1.D1_TES     <> ''
							AND SD1.D1_XPROJET  = AF8.AF8_PROJET 
							AND SD1.D1_XREVIS   = AF8.AF8_REVISA            
							AND SD1.D1_XCODOR   = AF8.AF8_XCODOR										
 							AND SD1.D1_XCODSBM IN ( 'SJ', 'MO' )
						 GROUP BY SD1.D1_XPROJET, SD1.D1_XREVIS, SD1.D1_XCODOR ) AS SD1T1 ), 0 ) AS 'REALPJ',
                 
      ISNULL( ( SELECT CONVERT( MONEY, SUM( AF4_VALOR ), 2 )
				  FROM AF4010 AS AF4
				 WHERE AF4.D_E_L_E_T_ = ''
				   AND AF4.AF4_ORCAME = AF1.AF1_ORCAME 
				   AND AF4.AF4_XCODOR = AF1.AF1_XCODOR
				   AND AF4.AF4_TIPOD IN ( 'SF' )
				GROUP BY AF4.AF4_ORCAME, AF4.AF4_XCODOR ), 0 ) AS 'PREVPF',

      ISNULL( ( SELECT CONVERT( MONEY, ( SD1TOTAL ), 2 )
                  FROM ( SELECT SD1.D1_XPROJET, SD1.D1_XREVIS,  SD1.D1_XCODOR, SUM( SD1.D1_TOTAL ) AS SD1TOTAL
						   FROM SD1010 AS SD1 
						  WHERE SD1.D_E_L_E_T_  = '' 
							AND SD1.D1_TES     <> ''
							AND SD1.D1_XPROJET  = AF8.AF8_PROJET 
							AND SD1.D1_XREVIS   = AF8.AF8_REVISA            
							AND SD1.D1_XCODOR   = AF8.AF8_XCODOR							
 							AND SD1.D1_XCODSBM IN ( 'SF' )
						 GROUP BY SD1.D1_XPROJET, SD1.D1_XREVIS, SD1.D1_XCODOR ) AS SD1T2 ), 0 ) AS 'REALPF',

      CONVERT( MONEY, ISNULL( NULL, 0 ), 2 )      AS 'PREVPPF',
      CONVERT( MONEY, ISNULL( NULL, 0 ), 2 )      AS 'REALPPF',
      
      ISNULL( ( SELECT CONVERT( MONEY, SUM( AF4_VALOR ), 2 )
				  FROM AF4010 AS AF4
				 WHERE AF4.D_E_L_E_T_ = ''
				   AND AF4.AF4_ORCAME = AF1.AF1_ORCAME 
				   AND AF4.AF4_XCODOR = AF1.AF1_XCODOR
				   AND AF4.AF4_TIPOD IN ( 'PE' )
				GROUP BY AF4.AF4_ORCAME, AF4.AF4_XCODOR ), 0 ) AS 'PREVPESSOAL',

      ISNULL( ( SELECT CONVERT( MONEY, ( SD1TOTAL ), 2 )
                  FROM ( SELECT SD1.D1_XPROJET, SD1.D1_XREVIS, SD1.D1_XCODOR, SUM( SD1.D1_TOTAL ) AS SD1TOTAL
						   FROM SD1010 AS SD1 
						  WHERE SD1.D_E_L_E_T_  = '' 
							AND SD1.D1_TES     <> ''
							AND SD1.D1_XPROJET  = AF8.AF8_PROJET 
							AND SD1.D1_XREVIS   = AF8.AF8_REVISA            
							AND SD1.D1_XCODOR   = AF8.AF8_XCODOR							
 							AND SD1.D1_XCODSBM IN ( 'PE' )
						 GROUP BY SD1.D1_XPROJET, SD1.D1_XREVIS, SD1.D1_XCODOR ) AS SD1T3 ), 0 ) AS 'REALPESSOAL',

      ISNULL( ( SELECT CONVERT( MONEY, SUM( AF4_VALOR ), 2 )
				  FROM AF4010 AS AF4
				 WHERE AF4.D_E_L_E_T_ = ''
				   AND AF4.AF4_ORCAME = AF1.AF1_ORCAME 
				   AND AF4.AF4_XCODOR = AF1.AF1_XCODOR
				   AND AF4.AF4_TIPOD IN ( 'OA' )
				GROUP BY AF4.AF4_ORCAME, AF4.AF4_XCODOR ), 0 ) AS 'PREVCUSTEIO',

      ISNULL( ( SELECT CONVERT( MONEY, ( SD1TOTAL ), 2 )
                  FROM ( SELECT SD1.D1_XPROJET, SD1.D1_XREVIS, SD1.D1_XCODOR, SUM( SD1.D1_TOTAL ) AS SD1TOTAL
						   FROM SD1010 AS SD1 
						  WHERE SD1.D_E_L_E_T_  = '' 
							AND SD1.D1_TES     <> ''
							AND SD1.D1_XPROJET  = AF8.AF8_PROJET 
							AND SD1.D1_XREVIS   = AF8.AF8_REVISA           
							AND SD1.D1_XCODOR   = AF8.AF8_XCODOR																									 
 							AND SD1.D1_XCODSBM IN ( 'OA' )
						 GROUP BY SD1.D1_XPROJET, SD1.D1_XREVIS, SD1.D1_XCODOR ) AS SD1T4 ), 0 ) AS 'REALCUSTEIO',

      ISNULL( ( SELECT CONVERT( MONEY, SUM( AF4_VALOR ), 2 )
				  FROM AF4010 AS AF4
				 WHERE AF4.D_E_L_E_T_ = ''
				   AND AF4.AF4_ORCAME = AF1.AF1_ORCAME 
				   AND AF4.AF4_XCODOR = AF1.AF1_XCODOR
				   AND AF4.AF4_TIPOD IN ( 'MU', 'HW', 'MA', 'SW', 'BO' )
				GROUP BY AF4.AF4_ORCAME, AF4.AF4_XCODOR ), 0 ) AS 'PREVCAPITAL',

      ISNULL( ( SELECT CONVERT( MONEY, ( SD1TOTAL ), 2 )
                  FROM ( SELECT SD1.D1_XPROJET, SD1.D1_XREVIS, SD1.D1_XCODOR, SUM( SD1.D1_TOTAL ) AS SD1TOTAL
						   FROM SD1010 AS SD1 
						  WHERE SD1.D_E_L_E_T_  = '' 
							AND SD1.D1_TES     <> ''
							AND SD1.D1_XPROJET  = AF8.AF8_PROJET 
							AND SD1.D1_XREVIS   = AF8.AF8_REVISA            
							AND SD1.D1_XCODOR   = AF8.AF8_XCODOR											
 							AND SD1.D1_XCODSBM IN ( 'MU', 'HW', 'MA', 'SW', 'BO' )
						 GROUP BY SD1.D1_XPROJET, SD1.D1_XREVIS, SD1.D1_XCODOR ) AS SD1T5 ), 0 ) AS 'REALCAPITAL',

      ISNULL( ( SELECT CONVERT( MONEY, SUM( AF4_VALOR ), 2 )
				  FROM AF4010 AS AF4
				 WHERE AF4.D_E_L_E_T_ = ''
				   AND AF4.AF4_ORCAME = AF1.AF1_ORCAME 
				   AND AF4.AF4_XCODOR = AF1.AF1_XCODOR
				   AND AF4.AF4_TIPOD IN ( 'VI', 'VN' )
				GROUP BY AF4.AF4_ORCAME, AF4.AF4_XCODOR ), 0 ) AS 'PREVVIAGEM',

      ISNULL( ( SELECT CONVERT( MONEY, ( SD1TOTAL ), 2 )
                  FROM ( SELECT SD1.D1_XPROJET, SD1.D1_XREVIS, SD1.D1_XCODOR, SUM( SD1.D1_TOTAL ) AS SD1TOTAL
						   FROM SD1010 AS SD1 
						  WHERE SD1.D_E_L_E_T_  = '' 
							AND SD1.D1_TES     <> ''
							AND SD1.D1_XPROJET  = AF8.AF8_PROJET 
							AND SD1.D1_XREVIS   = AF8.AF8_REVISA           
							AND SD1.D1_XCODOR   = AF8.AF8_XCODOR														 
 							AND SD1.D1_XCODSBM IN ( 'VI', 'VN' )
						 GROUP BY SD1.D1_XPROJET, SD1.D1_XREVIS, SD1.D1_XCODOR ) AS SD1T6 ), 0 ) AS 'REALVIAGEM',

      ISNULL( ( SELECT CONVERT( MONEY, SUM( AF4_VALOR ), 2 )
				  FROM AF4010 AS AF4
				 WHERE AF4.D_E_L_E_T_ = ''
				   AND AF4.AF4_ORCAME = AF1.AF1_ORCAME 
				   AND AF4.AF4_XCODOR = AF1.AF1_XCODOR
				GROUP BY AF4.AF4_ORCAME, AF4.AF4_XCODOR ), 0 ) AS 'PREVTOTORC',

      ISNULL( ( SELECT CONVERT( MONEY, ( SD1TOTAL ), 2 )
                  FROM ( SELECT SD1.D1_XPROJET, SD1.D1_XREVIS, SD1.D1_XCODOR, SUM( SD1.D1_TOTAL ) AS SD1TOTAL
						   FROM SD1010 AS SD1 
						  WHERE SD1.D_E_L_E_T_  = '' 
							AND SD1.D1_TES     <> ''
							AND SD1.D1_XPROJET  = AF8.AF8_PROJET 
							AND SD1.D1_XREVIS   = AF8.AF8_REVISA            
							AND SD1.D1_XCODOR   = AF8.AF8_XCODOR
						 GROUP BY SD1.D1_XPROJET, SD1.D1_XREVIS, SD1.D1_XCODOR ) AS SD1T7 ), 0 ) AS 'REALTOTORC',
						 
      ISNULL( ( SELECT CONVERT( MONEY, ( AJCTOTAL ), 2 )
				  FROM ( SELECT AJC.AJC_PROJET, AJC.AJC_REVISA, SUM( AJC.AJC_CUSTO1 ) AS AJCTOTAL
						   FROM AJC010 AS AJC 
						  WHERE AJC.D_E_L_E_T_  = '' 
							AND AJC.AJC_PROJET = AF8.AF8_PROJET 
							AND AJC.AJC_REVISA = AF8.AF8_REVISA            
						 GROUP BY AJC.AJC_PROJET, AJC.AJC_REVISA ) AS AJCT ), 0 ) AS 'AJCTOT',

	   AF1.AF1_XDATIN                               ,
       AF1.AF1_XDATFI                               ,
       ( CASE AF1.AF1_XSTATU 
              WHEN '1' THEN 'NOVO' 
                       ELSE 'EM CURSO' END ) DESCSTATUS, 
       AF1.AF1_FASE,
       ( SELECT AE9.AE9_DESCRI 
           FROM AE9010 AS AE9 
          WHERE AE9.AE9_COD = AF1.AF1_FASE ) DESCFASE,       
       AF1.AF1_XPRIO
       
  FROM AF1010 AS AF1 
       LEFT JOIN
       AF8010 AS AF8 ON AF8.AF8_ORCAME = AF1.AF1_ORCAME AND 
                        AF8.AF8_XCODOR = AF1.AF1_XCODOR
                                                
 WHERE AF1.D_E_L_E_T_ = ''
   AND AF8.D_E_L_E_T_ = ''  
   
) 
AS PREVREAL3
  
ORDER BY AF8_PROJET, AF8_REVISA, AF8_XCODOR
