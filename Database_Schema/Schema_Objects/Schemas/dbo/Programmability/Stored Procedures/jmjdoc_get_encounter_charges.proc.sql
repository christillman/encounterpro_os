CREATE  PROCEDURE jmjdoc_get_encounter_charges (
	@ps_cpr_id varchar(24),
	@pl_encounter_id int
)

AS

-- Extract the charges associated with a given encounter

SELECT cpr_id as cprid,
       encounter_id as encounterid,
	treatment_id as treatmentid,
	c.procedure_id as procedureid,
	c.cpt_code as cptcode,
	c.modifier as modifier,
	c.other_modifiers as othermodifiers,
	c.units as units,
	c.charge as charge,
	null as unitsbilled,
	null as chargebilled,
	c.units_recovered as unitsrecovered,
	c.charge_recovered as chargerecovered,
	c.encounter_charge_id as chargeid
FROM p_encounter_charge c
	INNER JOIN c_Procedure p
	ON c.procedure_id = p.procedure_id
	INNER JOIN c_Procedure_type pt
	ON c.procedure_type = pt.procedure_type
WHERE c.bill_flag = 'Y'
AND c.cpr_id = @ps_cpr_id
AND c.encounter_id = @pl_encounter_id
ORDER BY pt.sort_sequence

