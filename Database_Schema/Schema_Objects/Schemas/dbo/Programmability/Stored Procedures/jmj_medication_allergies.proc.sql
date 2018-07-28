CREATE PROCEDURE dbo.jmj_medication_allergies (
	@ps_cpr_id varchar(12),
	@ps_treatment_type varchar(24),
	@ps_treatment_key varchar(24))
AS

DECLARE @treatmentlist TABLE (
		definition_id int NULL,
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


DECLARE @ls_common_name varchar(40)

SELECT @ls_common_name = common_name
FROM c_Drug_Definition
WHERE drug_id = @ps_treatment_key

INSERT INTO @treatmentlist (
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
SELECT	@ps_treatment_type,
		@ps_treatment_key,
		@ls_common_name,
		'Drug Allergy',
		'bitmap_drug_allergy.bmp',
		3,
		'This patient has an allergy (' + p.assessment + ') which may cause an adverse reaction to ' + @ls_common_name,
		@ps_treatment_key,
		p.assessment_id,
		p.assessment,
		@ls_common_name
FROM p_Assessment p
	INNER JOIN c_Allergy_Drug ad
	ON p.assessment_id = ad.assessment_id
	AND ad.drug_id = @ps_treatment_key
	INNER JOIN c_Assessment_Definition a
	ON a.assessment_id = p.assessment_id
WHERE p.cpr_id = @ps_cpr_id
AND ISNULL(p.assessment_status, 'OPEN') = 'OPEN'
AND @ps_treatment_type IN ('MEDICATION', 'OFFICEMED')



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



