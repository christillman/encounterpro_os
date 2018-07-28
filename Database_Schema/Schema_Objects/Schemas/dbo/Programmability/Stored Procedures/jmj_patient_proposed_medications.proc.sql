CREATE PROCEDURE dbo.jmj_patient_proposed_medications (
	@ps_cpr_id varchar(12),
	@ps_assessment_id varchar(24),
	@ps_user_id varchar(24),
	@pl_care_plan_id int = 0,
	@pl_code_owner_id int)
AS

DECLARE @treatmentlist TABLE (
		definition_id int NOT NULL,
		treatment_type varchar(24) NOT NULL,
		treatment_key varchar(64) NULL,
		treatment_description varchar(255) NOT NULL,
		drug_id varchar(24) NULL,
		package_id varchar(24) NULL,
		dosage_form varchar(24) NULL,
		drug_code varchar(80) NULL,
		drug_package_code varchar(80) NULL,
		drug_dosage_form_code varchar(80) NULL,
		drug_common_name varchar(40))


INSERT INTO @treatmentlist (
		definition_id,
		treatment_type,
		treatment_key,
		treatment_description,
		drug_id)
SELECT	d.definition_id,
		d.treatment_type,
		d.treatment_key,
		d.treatment_description,
		d.treatment_key
FROM u_assessment_treat_definition d
WHERE d.user_id = @ps_user_id
AND d.assessment_id = @ps_assessment_id
AND d.treatment_description IS NOT NULL
AND treatment_type IN ('MEDICATION', 'OFFICEMED')

UPDATE t
SET package_id = CAST(a.value AS varchar(24))
FROM @treatmentlist t
	INNER JOIN u_assessment_treat_def_attrib a
	ON t.definition_id = a.definition_id
	AND a.attribute = 'package_id'

UPDATE t
SET dosage_form = p.dosage_form
FROM @treatmentlist t
	INNER JOIN c_Package p
	ON t.package_id = p.package_id

UPDATE t
SET dosage_form = CAST(a.value AS varchar(24))
FROM @treatmentlist t
	INNER JOIN u_assessment_treat_def_attrib a
	ON t.definition_id = a.definition_id
	AND a.attribute = 'dosage_form'
WHERE t.dosage_form IS NULL


UPDATE t
SET drug_code = x.code
FROM @treatmentlist t
	INNER JOIN c_XML_Code x
	ON x.epro_id = t.drug_id
	AND x.epro_domain = 'drug_id'
	AND x.owner_id = @pl_code_owner_id
	AND x.code_domain = 'med_name_id'
WHERE t.drug_id IS NOT NULL

UPDATE t
SET drug_package_code = x.code
FROM @treatmentlist t
	INNER JOIN c_XML_Code x
	ON x.epro_id = t.drug_id + '|' + t.package_id
	AND x.epro_domain = 'drug_id|package_id'
	AND x.owner_id = @pl_code_owner_id
	AND x.code_domain = 'med_id'


UPDATE t
SET drug_dosage_form_code = x.code
FROM @treatmentlist t
	INNER JOIN c_XML_Code x
	ON x.epro_id = t.dosage_form
	AND x.epro_domain = 'dosage_form'
	AND x.owner_id = @pl_code_owner_id
	AND x.code_domain = 'med_dosage_form_abbr'

UPDATE t
SET drug_common_name = d.common_name
FROM @treatmentlist t
	INNER JOIN c_Drug_Definition d
	ON t.drug_id = d.drug_id

SELECT	definition_id,
		treatment_type ,
		treatment_key ,
		treatment_description ,
		drug_id ,
		package_id ,
		dosage_form ,
		drug_code ,
		drug_package_code ,
		drug_dosage_form_code,
		drug_common_name
FROM @treatmentlist



