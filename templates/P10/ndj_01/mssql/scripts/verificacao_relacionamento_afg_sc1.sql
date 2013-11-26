SELECT
		SC1_T.R_E_C_N_O_ ,
		SC1_T.SC1_PMS,
		SC1_T.SC1_AFG
FROM
	(
		SELECT
			SC1.R_E_C_N_O_,
			(
				CASE
					(
						SELECT
							SC1_RESULT.RESULT
						FROM
							(
								SELECT
									0 AS RESULT
								FROM
									(
										SELECT
											*
										FROM
											SC1010 SC1_A 
										WHERE
											SC1_A.D_E_L_E_T_ <> '*'
										AND
											SC1_A.C1_FILIAL = '  '
										AND
											SC1_A.R_E_C_N_O_ = SC1.R_E_C_N_O_
									) SC1_0
								WHERE
									SC1_0.D_E_L_E_T_ <> '*'
								AND
									SC1_0.C1_FILIAL = '  '
								AND
									(
										SC1_0.C1_PROJET = SC1_0.C1_XPROJET
										AND
										SC1_0.C1_REVISA = SC1_0.C1_XREVISA
										AND
										SC1_0.C1_TAREFA = SC1_0.C1_XTAREFA
									)
							UNION
								SELECT	
									1 AS RESULT
								FROM
									(
										SELECT
											*
										FROM
											SC1010 SC1_B
										WHERE
											SC1_B.D_E_L_E_T_ <> '*'
										AND
											SC1_B.C1_FILIAL = '  '
										AND
											SC1_B.R_E_C_N_O_ = SC1.R_E_C_N_O_
									) SC1_1
								WHERE
									SC1_1.D_E_L_E_T_ <> '*'
								AND
									SC1_1.C1_FILIAL = '  '
								AND
									(
										SC1_1.C1_PROJET <> SC1_1.C1_XPROJET
										OR
										SC1_1.C1_REVISA <> SC1_1.C1_XREVISA
										OR
										SC1_1.C1_TAREFA <> SC1_1.C1_XTAREFA
									)
							) SC1_RESULT
						WHERE
							SC1_RESULT.RESULT = 1
					)
					WHEN
						1
					THEN
						'.T.'
					ELSE
						'.F.'
					END
				) AS SC1_PMS,
				(
					CASE
					(
						SELECT
							SC1_AFG_RESULT.RESULT
						FROM
							(
						SELECT 
							0 AS RESULT
						FROM
									(
										SELECT
											*
										FROM
											SC1010 SC1_C
										WHERE
											SC1_C.D_E_L_E_T_ <> '*'
										AND
											SC1_C.C1_FILIAL = '  '
										AND
											SC1_C.R_E_C_N_O_ = SC1.R_E_C_N_O_
									) SC1_3
						WHERE
							SC1_3.D_E_L_E_T_ <> '*'
						AND
							SC1_3.C1_FILIAL = '  '
						AND
						EXISTS(
							SELECT
								1
							FROM
								AFG010 AFG
							WHERE							
								AFG.D_E_L_E_T_ <> '*'
							AND
								AFG.AFG_FILIAL = '  '
							AND
								AFG.AFG_PROJET = SC1_3.C1_XPROJET
							AND	
								AFG.AFG_REVISA = SC1_3.C1_XREVISA
							AND
								AFG.AFG_TAREFA = SC1_3.C1_XTAREFA
							AND	
								AFG.AFG_NUMSC = SC1_3.C1_NUM
							AND
								AFG.AFG_ITEMSC = SC1_3.C1_ITEM
						)
					UNION
SELECT 
							1 AS RESULT
						FROM
									(
										SELECT
											*
										FROM
											SC1010 SC1_C
										WHERE
											SC1_C.D_E_L_E_T_ <> '*'
										AND
											SC1_C.C1_FILIAL = '  '
										AND
											SC1_C.R_E_C_N_O_ = SC1.R_E_C_N_O_
									) SC1_4
						WHERE
							SC1_4.D_E_L_E_T_ <> '*'
						AND
							SC1_4.C1_FILIAL = '  '
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
								AFG.AFG_PROJET = SC1_4.C1_XPROJET
							AND	
								AFG.AFG_REVISA = SC1_4.C1_XREVISA
							AND
								AFG.AFG_TAREFA = SC1_4.C1_XTAREFA
							AND	
								AFG.AFG_NUMSC = SC1_4.C1_NUM
							AND
								AFG.AFG_ITEMSC = SC1_4.C1_ITEM						) 
					) SC1_AFG_RESULT
					WHERE
						SC1_AFG_RESULT.RESULT = 1
					)
					WHEN
						1
					THEN
						'.T.'
					ELSE
						'.F.'
					END
				) AS SC1_AFG
		FROM
			SC1010 SC1 ) SC1_T
WHERE
	(
		( SC1_T.SC1_PMS = '.T.' )
		OR
		( SC1_T.SC1_AFG = '.T.' )
	)