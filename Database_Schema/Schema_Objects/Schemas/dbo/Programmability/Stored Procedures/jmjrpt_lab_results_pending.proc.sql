


CREATE PROCEDURE jmjrpt_lab_results_pending 
AS

SELECT DISTINCT
	p.billing_id,
	p.last_name, 
	p.first_name, 
	p.date_of_birth, 
	t.treatment_description, 
	t.begin_date,
	t.ordered_by,
	CASE WHEN EXISTS(SELECT 1 FROM p_Observation_Result r WHERE r.cpr_id = t.cpr_id and r.treatment_id = t.treatment_id and r.abnormal_flag = 'Y') THEN 'Y' ELSE '' END as ABN,
	tp.progress_value as Status
FROM p_Patient p
	INNER JOIN p_Treatment_Progress tp
	ON p.cpr_id = tp.cpr_id
	INNER JOIN p_Treatment_Item t
	ON tp.cpr_id = t.cpr_id
	AND tp.treatment_id = t.treatment_id
WHERE tp.Progress_type = 'LabResults'
AND tp.progress_key = 'Status'
AND p.last_name NOT IN ('UNI', 'UNIT', 'TEST', 'Patient')
AND t.open_flag = 'Y'
ORDER BY p.billing_id