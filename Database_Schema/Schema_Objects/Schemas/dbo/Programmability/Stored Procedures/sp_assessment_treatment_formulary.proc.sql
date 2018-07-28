CREATE PROCEDURE sp_assessment_treatment_formulary (
	@ps_cpr_id varchar(12),
	@ps_assessment_id varchar(24) )
AS

DECLARE @ls_icd_9_code varchar(12),
	@ls_authority_id varchar(24)

SELECT @ls_icd_9_code = icd_9_code
FROM c_Assessment_Definition
WHERE assessment_id = @ps_assessment_id

SELECT @ls_authority_id = authority_id
FROM p_Patient_Authority
WHERE cpr_id = @ps_cpr_id
AND authority_sequence = 1

SELECT DISTINCT af.treatment_type,
	af.treatment_key, 
	f.formulary_code, 
	f.formulary_type, 
	f.title, 
	f.description,
	f.button,
	f.icon,
	f.negative_flag,
	f.sort_sequence
FROM c_Authority_Formulary af, 
	c_Formulary f
WHERE af.formulary_code = f.formulary_code
AND af.authority_id = @ls_authority_id
AND @ls_icd_9_code LIKE (af.icd_9_code + '%')

