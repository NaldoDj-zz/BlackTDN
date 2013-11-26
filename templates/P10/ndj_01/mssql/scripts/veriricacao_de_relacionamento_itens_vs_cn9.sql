-- Verifica os Relacionamentos da CNC com a CN9
SELECT
	COUNT(1) CNQ
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
	

-- Verifica os Relacionamentos da CNC com a CNB
SELECT
	COUNT(*) CNC
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

-- Verifica os Relacionamentos da CNB com a CN9
SELECT
	COUNT(*) CNB
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

-- Verifica os Relacionamentos da CNA com a CN9
SELECT
	COUNT(*) CNA
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

-- Verifica os Relacionamentos da CND com a CN9
SELECT
	COUNT(*) CND
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

-- Verifica os Relacionamentos da CNF com a CN9
SELECT
	COUNT(*) CNF
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
	
-- Verifica os Relacionamentos da CNN com a CN9
SELECT
	COUNT(*) CNN
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
	
-- Verifica os Relacionamentos da CNQ com a CN9
SELECT
	COUNT(*) CNQ
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