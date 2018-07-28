/****** Object:  View dbo.v_Diagnosed_Patients    Script Date: 7/25/2000 8:42:39 AM ******/
CREATE VIEW v_Diagnosed_Patients
AS
SELECT DISTINCT
	p.cpr_id,
	p.date_of_birth,
	p.sex,
	a.problem_id,
	d.description as assessment,
	a.open_encounter_id as encounter_id,
	a.begin_date AS item_date
FROM p_Patient p, p_Assessment a, c_Assessment_Definition d
WHERE p.cpr_id = a.cpr_id
AND a.assessment_id = d.assessment_id
