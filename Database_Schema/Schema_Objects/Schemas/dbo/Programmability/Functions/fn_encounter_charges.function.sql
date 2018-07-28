CREATE FUNCTION fn_encounter_charges (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int
	)

RETURNS @charges TABLE (
	[problem_id] [int] NOT NULL,
	[assessment_sequence] [smallint] NULL,
	[assessment_id] [varchar](24) NULL,
	[assessment_description] varchar(80) NULL,
	[icd_9_code] [varchar](12) NULL,
	[encounter_charge_id] [int] NULL,
	[treatment_id] [int] NULL,
	[procedure_type] [varchar](12) NOT NULL,
	[procedure_id] [varchar](24) NOT NULL,
	[procedure_description] varchar(80) NULL,
	[charge] [money] NULL,
	[cpt_code] [varchar](24) NULL,
	[units] [int] NULL,
	[posted] [char](1) NOT NULL ,
	[modifier] [varchar](2) NULL,
	[other_modifiers] [varchar](12) NULL,
	[last_updated] [datetime] NULL,
	[last_updated_by] [varchar](24) NULL,
	[last_updated_name] [varchar] (64) NULL,
	[units_recovered] [int] NULL,
	[charge_recovered] [money] NULL,
	[assessment_bill_flag] [char] (1) NOT NULL,
	[charge_bill_flag] [char] (1) NOT NULL,
	[assessment_charge_bill_flag] [char] (1) NOT NULL,
	[procedure_type_sort_sequence] [int] NULL,
	[charge_sort_sequence] [int] NULL,
	[assessment_sort_sequence] [int] NULL
	)
AS

BEGIN


INSERT INTO @charges (
	problem_id ,
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
	assessment_sort_sequence )
SELECT a.problem_id,
	a.assessment_sequence,
	a.assessment_id,
	assessment = COALESCE(pa.assessment, ad.description),
	icd_9_code = COALESCE(a.icd_9_code, ad.icd_9_code),
	c.encounter_charge_id,
	c.treatment_id,
	c.procedure_type,
	c.procedure_id,
	p.description,
	c.charge,
	cpt_code = COALESCE(c.cpt_code, p.cpt_code),
	c.units,
	c.posted,
	c.modifier,
	c.other_modifiers,
	c.last_updated,
	c.last_updated_by,
	last_updated_name = u.user_full_name,
	c.units_recovered ,
	c.charge_recovered ,
	assessment_bill_flag = a.bill_flag,
	charge_bill_flag = c.bill_flag,
	assessment_charge_bill_flag = ac.bill_flag,
	t.sort_sequence ,
	COALESCE(c.sort_sequence, c.encounter_charge_id) ,
	assessment_sort_sequence = COALESCE(ac.billing_sequence, a.assessment_sequence)
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
	INNER JOIN c_Assessment_Definition ad
	ON ad.assessment_id = a.assessment_id
	LEFT OUTER JOIN p_Assessment pa
	ON ac.cpr_id = pa.cpr_id
	AND ac.problem_id = pa.problem_id
	AND pa.current_flag = 'Y'
	LEFT OUTER JOIN c_Procedure_type t
	ON c.procedure_type = t.procedure_type
	LEFT OUTER JOIN c_User u
	ON u.user_id = c.last_updated_by
WHERE c.cpr_id = @ps_cpr_id
AND c.encounter_id = @pl_encounter_id
AND a.bill_flag = 'Y'
AND c.bill_flag = 'Y'
AND ac.bill_flag = 'Y'


INSERT INTO @charges (
	problem_id ,
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
	assessment_sort_sequence )
SELECT a.problem_id,
	a.assessment_sequence,
	a.assessment_id,
	pa.assessment ,
	icd_9_code = COALESCE(a.icd_9_code, ad.icd_9_code),
	NULL,
	NULL,
	'UNASSOCIATED',
	'UNASSOCIATED',
	'Diagnoses With No Charges',
	NULL,
	NULL,
	1,
	'N',
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	assessment_bill_flag = a.bill_flag,
	'Y',
	'Y',
	999999999,
	999999999,
	assessment_sort_sequence = a.assessment_sequence
FROM p_Encounter_Assessment a
	INNER JOIN p_Assessment pa
	ON a.cpr_id = pa.cpr_id
	AND a.problem_id = pa.problem_id
	AND pa.current_flag = 'Y'
	INNER JOIN c_Assessment_Definition ad
	ON ad.assessment_id = a.assessment_id
WHERE a.cpr_id = @ps_cpr_id
AND a.encounter_id = @pl_encounter_id
AND ISNULL(pa.assessment_status, 'OPEN') <> 'CANCELLED'
AND a.bill_flag = 'Y'
AND a.problem_id NOT IN (
	SELECT DISTINCT problem_id
	FROM @charges
	WHERE problem_id IS NOT NULL )

INSERT INTO @charges (
	problem_id ,
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
	assessment_sort_sequence )
SELECT 0,
	NULL,
	NULL,
	'Not Billed' ,
	NULL,
	c.encounter_charge_id,
	c.treatment_id,
	c.procedure_type,
	c.procedure_id,
	p.description,
	c.charge,
	cpt_code = COALESCE(c.cpt_code, p.cpt_code),
	c.units,
	c.posted,
	c.modifier,
	c.other_modifiers,
	c.last_updated,
	c.last_updated_by,
	last_updated_name = u.user_full_name,
	c.units_recovered ,
	c.charge_recovered ,
	assessment_bill_flag = 'Y',
	charge_bill_flag = c.bill_flag,
	assessment_charge_bill_flag = 'Y',
	t.sort_sequence ,
	c.sort_sequence ,
	NULL
FROM p_Encounter_Charge c
	INNER JOIN c_Procedure p
	ON c.procedure_id = p.procedure_id
	LEFT OUTER JOIN c_Procedure_type t
	ON c.procedure_type = t.procedure_type
	LEFT OUTER JOIN c_User u
	ON u.user_id = c.last_updated_by
WHERE c.cpr_id = @ps_cpr_id
AND c.encounter_id = @pl_encounter_id
AND c.bill_flag = 'Y'
AND c.encounter_charge_id NOT IN (
	SELECT DISTINCT encounter_charge_id
	FROM @charges
	WHERE encounter_charge_id IS NOT NULL )

RETURN
END

