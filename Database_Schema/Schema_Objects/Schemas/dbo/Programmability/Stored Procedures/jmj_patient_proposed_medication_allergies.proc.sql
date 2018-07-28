CREATE PROCEDURE dbo.jmj_patient_proposed_medication_allergies (
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
		contraindication_type varchar(24) NULL,
		icon varchar(128) NULL,
		severity int NULL,
		short_description varchar(255) NULL,
		long_description text NULL,
		contraindication_warning text NULL,
		contraindication_references text NULL,
		drug_id varchar(24) NULL,
		allergy_assessment_id varchar(24) NULL,
		allergy_description varchar(80) NULL,
		drug_common_name varchar(40))


INSERT INTO @treatmentlist (
		definition_id,
		treatment_type,
		treatment_key,
		treatment_description,
		contraindication_type ,
		icon ,
		severity ,
		short_description ,
		drug_id,
		allergy_assessment_id,
		allergy_description,
		drug_common_name)
SELECT	d.definition_id,
		d.treatment_type,
		d.treatment_key,
		d.treatment_description,
		'Drug Allergy',
		'bitmap_drug_allergy.bmp',
		3,
		'This patient has an allergy (' + p.assessment + ') which may cause an adverse reaction to ' + dd.common_name,
		dd.drug_id,
		a.assessment_id,
		p.assessment,
		dd.common_name
FROM u_assessment_treat_definition d
	INNER JOIN c_Allergy_Drug ad
	ON ad.drug_id = d.treatment_key
	INNER JOIN p_Assessment p
	ON p.cpr_id = @ps_cpr_id
	AND p.assessment_id = ad.assessment_id
	AND ISNULL(p.assessment_status, 'OPEN') = 'OPEN'
	INNER JOIN c_Assessment_Definition a
	ON a.assessment_id = ad.assessment_id
	INNER JOIN c_Drug_Definition dd
	ON d.treatment_key = dd.drug_id
WHERE d.user_id = @ps_user_id
AND d.assessment_id = @ps_assessment_id
AND d.treatment_description IS NOT NULL
AND treatment_type IN ('MEDICATION', 'OFFICEMED')



SELECT	definition_id,
		treatment_type ,
		treatment_key ,
		treatment_description ,
		contraindication_type ,
		icon ,
		severity ,
		short_description ,
		long_description ,
		contraindication_warning ,
		contraindication_references ,
		drug_id ,
		allergy_assessment_id ,
		allergy_description,
		drug_common_name
FROM @treatmentlist



