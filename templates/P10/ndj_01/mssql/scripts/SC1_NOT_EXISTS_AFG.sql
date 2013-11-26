						SELECT 
							1
						FROM
							SC1010 SC1
						WHERE
							SC1.D_E_L_E_T_ <> '*'
						AND
							SC1.C1_FILIAL = '  '
						AND
						NOT EXISTS(
							SELECT
								1
							FROM
								AFG010 AFG
							WHERE							
								AFG.D_E_L_E_T_ <> '*'
							AND
								AFG.AFG_FILIAL = '  '
							AND
								AFG.AFG_PROJET = SC1.C1_XPROJET
							AND	
								AFG.AFG_REVISA = SC1.C1_XREVISA
							AND
								AFG.AFG_TAREFA = SC1.C1_XTAREFA
							AND	
								AFG.AFG_NUMSC = SC1.C1_NUM
							AND
								AFG.AFG_ITEMSC = SC1.C1_ITEM
)