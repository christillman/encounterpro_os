CREATE PROCEDURE sp_drug_efficacy AS

SELECT DISTINCT t.cpr_id, t.treatment_id, t.drug_id, t.begin_date, a.problem_id, a.assessment_id
INTO #med_instances
FROM p_Treatment_Item t, p_Assessment_Treatment x, p_Assessment a
WHERE x.cpr_id = t.cpr_id
AND x.treatment_id = t.treatment_id
AND x.cpr_id = a.cpr_id
AND x.problem_id = a.problem_id
AND t.treatment_type = 'MEDICATION'
AND t.drug_id IS NOT NULL

SELECT DISTINCT m.cpr_id, m.treatment_id, m.drug_id, m.begin_date, m.problem_id, m.assessment_id, count(*) as redrugs
INTO #med_instances_redrug
FROM #med_instances m, p_Assessment_Treatment x, p_Treatment_Item t
WHERE x.cpr_id = t.cpr_id
AND x.treatment_id = t.treatment_id
AND x.cpr_id = m.cpr_id
AND x.problem_id = m.problem_id
AND t.treatment_type = 'MEDICATION'
AND t.drug_id IS NOT NULL
AND t.begin_date > m.begin_date
GROUP BY m.cpr_id, m.treatment_id, m.drug_id, m.begin_date, m.problem_id, m.assessment_id

SELECT assessment_id, drug_id, CONVERT(numeric, count(*)) as total_instances
INTO #efficacy_total
FROM #med_instances
GROUP BY assessment_id, drug_id

SELECT assessment_id, drug_id, CONVERT(numeric, count(*)) as redrugs
INTO #efficacy_redrugs
FROM #med_instances_redrug
GROUP BY assessment_id, drug_id

SELECT m.assessment_id,
	m.drug_id,
	CASE WHEN r.redrugs IS NULL THEN CONVERT(numeric, 100) ELSE 100.0 - (100.0 * r.redrugs / m.total_instances) END as rating
INTO #efficacy
FROM #efficacy_total as m INNER JOIN #efficacy_redrugs as r
	ON m.assessment_id = r.assessment_id
	AND m.drug_id = r.drug_id
WHERE m.total_instances >= 50

UPDATE r_Assessment_Treatment_Efficacy
SET rating = NULL

UPDATE r_Assessment_Treatment_Efficacy
SET rating = e.rating
FROM #efficacy e
WHERE r_Assessment_Treatment_Efficacy.assessment_id = e.assessment_id
AND r_Assessment_Treatment_Efficacy.treatment_type = 'MEDICATION'
AND r_Assessment_Treatment_Efficacy.treatment_key = e.drug_id

INSERT INTO r_Assessment_Treatment_Efficacy (
	assessment_id,
	treatment_type,
	treatment_key,
	rating)
SELECT assessment_id,
	'MEDICATION',
	drug_id,
	rating
FROM #efficacy e
WHERE NOT EXISTS (
	SELECT *
	FROM r_Assessment_Treatment_Efficacy r
	WHERE r.assessment_id = e.assessment_id
	AND r.treatment_type = 'MEDICATION'
	AND r.treatment_key = e.drug_id )

