-- deleta os itens sem Relacionamentos da CNC com a CN9
DELETE 
FROM
	CNC010
WHERE
	NOT EXISTS
	(
		SELECT
			1
		FROM
			CN9010
		WHERE
			CN9_NUMERO = CNC_NUMERO
	)
	

-- deleta os itens sem Relacionamentos da CNC com a CNB
DELETE 
FROM
	CNC010
WHERE
	NOT EXISTS
	(
		SELECT
			1
		FROM
			CNB010
		WHERE
			CNB_CONTRA = CNC_NUMERO
	)

-- deleta os itens sem Relacionamentos da CNB com a CN9
DELETE 
FROM
	CNB010
WHERE
	NOT EXISTS
	(
		SELECT
			1
		FROM
			CN9010
		WHERE
			CNB_CONTRA = CN9_NUMERO
	)

-- deleta os itens sem Relacionamentos da CNA com a CN9
DELETE 
FROM
	CNA010
WHERE
	NOT EXISTS
	(
		SELECT
			1
		FROM
			CN9010
		WHERE
			CNA_CONTRA = CN9_NUMERO
	)	

-- deleta os itens sem Relacionamentos da CND com a CN9
DELETE 
FROM
	CND010
WHERE
	NOT EXISTS
	(
		SELECT
			1
		FROM
			CN9010
		WHERE
			CND_CONTRA = CN9_NUMERO
	)	

-- deleta os itens sem Relacionamentos da CNF com a CN9
DELETE 
FROM
	CNF010
WHERE
	NOT EXISTS
	(
		SELECT
			1
		FROM
			CN9010
		WHERE
			CNF_CONTRA = CN9_NUMERO
	)	
	
-- deleta os itens sem Relacionamentos da CNN com a CN9
DELETE 
FROM
	CNN010
WHERE
	NOT EXISTS
	(
		SELECT
			1
		FROM
			CN9010
		WHERE
			CNN_CONTRA = CN9_NUMERO
	)
	
-- deleta os itens sem Relacionamentos da CNQ com a CN9
DELETE 
FROM
	CNQ010
WHERE
	NOT EXISTS
	(
		SELECT
			1
		FROM
			CN9010
		WHERE
			CNQ_CONTRA = CN9_NUMERO
	)