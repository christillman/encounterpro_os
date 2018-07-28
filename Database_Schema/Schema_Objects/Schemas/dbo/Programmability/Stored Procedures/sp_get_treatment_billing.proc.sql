CREATE PROCEDURE sp_get_treatment_billing (
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
	ac.bill_flag,
	c.bill_flag,
	p.description
FROM p_Encounter_Assessment_Charge ac
	INNER JOIN p_Encounter_Charge c
	ON ac.cpr_id = c.cpr_id
	AND ac.encounter_id = c.encounter_id
	AND ac.encounter_charge_id = c.encounter_charge_id
	INNER JOIN c_Procedure p
	ON c.procedure_id = p.procedure_id
	LEFT OUTER JOIN c_Procedure_type t
	ON c.procedure_type = t.procedure_type
WHERE ac.cpr_id = @ps_cpr_id
AND ac.encounter_id = @pl_encounter_id
AND ac.problem_id = @pl_problem_id
ORDER BY t.sort_sequence

