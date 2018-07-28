CREATE PROCEDURE jmj_encounter_charges (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer
	)
AS


SELECT	problem_id ,
	assessment_sequence ,
	assessment_id ,
	assessment_description ,
	icd_9_code ,
	encounter_charge_id ,
	treatment_id ,
	procedure_type ,
	procedure_id ,
	procedure_description ,
	charge ,
	cpt_code ,
	units ,
	posted ,
	modifier ,
	other_modifiers ,
	last_updated ,
	last_updated_by ,
	last_updated_name ,
	units_recovered ,
	charge_recovered ,
	assessment_bill_flag ,
	charge_bill_flag ,
	assessment_charge_bill_flag ,
	procedure_type_sort_sequence ,
	charge_sort_sequence ,
	assessment_sort_sequence ,
	selected_flag = 0
FROM dbo.fn_encounter_charges(@ps_cpr_id, @pl_encounter_id)

