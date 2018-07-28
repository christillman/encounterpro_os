CREATE PROCEDURE dbo.jmj_patient_current_medications (
	@ps_cpr_id varchar(12),
	@pl_code_owner_id int)
AS

DECLARE @treatmentlist TABLE (
		treatment_type varchar(24) NOT NULL,
		treatment_key varchar(64) NULL,
		treatment_description varchar(255) NOT NULL,
		drug_id varchar(24) NULL,
		package_id varchar(24) NULL,
		dosage_form varchar(24) NULL,
		drug_code varchar(80) NULL,
		drug_package_code varchar(80) NULL,
		drug_dosage_form_code varchar(80) NULL)


INSERT INTO @treatmentlist (
		treatment_type,
		treatment_key,
		treatment_description,
		drug_id,
		package_id)
SELECT	t.treatment_type,
		t.drug_id,
		t.treatment_description,
		t.drug_id,
		t.package_id
FROM p_Treatment_Item t
WHERE t.cpr_id = @ps_cpr_id
AND treatment_type = 'MEDICATION'
AND open_flag = 'Y'
AND treatment_description IS NOT NULL

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
SET dosage_form = p.dosage_form
FROM @treatmentlist t
	INNER JOIN c_Package p
	ON t.package_id = p.package_id

UPDATE t
SET drug_dosage_form_code = x.code
FROM @treatmentlist t
	INNER JOIN c_XML_Code x
	ON x.epro_id = t.dosage_form
	AND x.epro_domain = 'dosage_form'
	AND x.owner_id = @pl_code_owner_id
	AND x.code_domain = 'med_dosage_form_abbr'


SELECT	treatment_type ,
		treatment_key ,
		treatment_description ,
		drug_id ,
		package_id ,
		dosage_form ,
		drug_code ,
		drug_package_code ,
		drug_dosage_form_code
FROM @treatmentlist



