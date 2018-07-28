CREATE PROCEDURE sp_get_treatment_assessments (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@pl_encounter_charge_id integer)
AS
SELECT a.problem_id,
	assessment_sequence = a.assessment_sequence,
	a.assessment_billing_id,
	a.bill_flag,
	ac.bill_flag
FROM p_Encounter_Assessment_Charge ac
	INNER JOIN p_Encounter_Assessment a
	ON ac.cpr_id = a.cpr_id
	AND ac.encounter_id = a.encounter_id
	AND ac.problem_id = a.problem_id
WHERE ac.cpr_id = @ps_cpr_id
AND ac.encounter_id = @pl_encounter_id
AND ac.encounter_charge_id = @pl_encounter_charge_id
ORDER BY a.assessment_sequence, a.problem_id

