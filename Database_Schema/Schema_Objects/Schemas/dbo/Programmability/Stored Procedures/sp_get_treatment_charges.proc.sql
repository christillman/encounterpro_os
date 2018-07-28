CREATE PROCEDURE sp_get_treatment_charges (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@pl_treatment_id integer )
AS

SELECT	c.encounter_charge_id,
	c.procedure_type,
	c.treatment_id,
	c.treatment_billing_id,
	c.procedure_id,
	c.charge,
	c.bill_flag,
	p.description,
	c.cpt_code,
	c.units,
	c.modifier,
	c.other_modifiers,
	c.last_updated,
	c.last_updated_by,
	c.posted,
	t.sort_sequence as procedure_type_sort_sequence
FROM p_Encounter_Charge c
	INNER JOIN c_Procedure p
	ON c.procedure_id = p.procedure_id
	LEFT OUTER JOIN c_Procedure_type t
	ON c.procedure_type = t.procedure_type
WHERE c.cpr_id = @ps_cpr_id
AND c.encounter_id = @pl_encounter_id
AND c.treatment_id = @pl_treatment_id

