CREATE PROCEDURE sp_get_encounter_charges (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@pl_problem_id integer )
AS
SELECT	c.encounter_charge_id,
	c.procedure_type,
	c.treatment_id,
	c.treatment_billing_id,
	c.procedure_id,
	c.charge,
	ac.bill_flag as assessment_charge_bill_flag,
	c.bill_flag as charge_bill_flag,
	p.description,
	c.cpt_code,
	c.units,
	c.modifier,
	c.other_modifiers,
	c.last_updated,
	c.last_updated_by,
	c.posted,
	billing_sequence = COALESCE(ac.billing_sequence, a.assessment_sequence)
FROM p_Encounter_Charge c
	INNER JOIN c_Procedure p
	ON c.procedure_id = p.procedure_id
	INNER JOIN p_Encounter_Assessment_Charge ac
	ON c.cpr_id = ac.cpr_id
	AND c.encounter_id = ac.encounter_id
	AND c.encounter_charge_id = ac.encounter_charge_id
	INNER JOIN p_Encounter_Assessment a
	ON ac.cpr_id = a.cpr_id
	AND ac.encounter_id = a.encounter_id
	AND ac.problem_id = a.problem_id
	LEFT OUTER JOIN c_Procedure_type t
	ON c.procedure_type = t.procedure_type
WHERE c.cpr_id = @ps_cpr_id
AND c.encounter_id = @pl_encounter_id
AND ac.problem_id = @pl_problem_id
AND c.bill_flag IN ('Y', 'N')
ORDER BY t.sort_sequence

