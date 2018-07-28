CREATE PROCEDURE sp_authority_treatment_formulary (
	@ps_cpr_id varchar(12),
	@pl_treatment_id int ,
	@ps_authority_id varchar(24) )
AS

DECLARE @ls_treatment_key varchar(40),
		@ls_treatment_type varchar(24)

SELECT @ls_treatment_type = treatment_type,
	@ls_treatment_key = dbo.fn_treatment_key(cpr_id, treatment_id)
FROM p_Treatment_Item
WHERE cpr_id = @ps_cpr_id
AND treatment_id = @pl_treatment_id

DECLARE @assessments TABLE (
	icd_9_code varchar(12) )

INSERT INTO @assessments (
	icd_9_code )
SELECT DISTINCT ad.icd_9_code
FROM p_Assessment a
	INNER JOIN p_Assessment_Treatment t
	ON a.cpr_id = t.cpr_id
	AND a.problem_id = t.problem_id
	INNER JOIN c_Assessment_Definition ad
	ON a.assessment_id = ad.assessment_id
WHERE t.cpr_id = @ps_cpr_id
AND t.treatment_id = @pl_treatment_id

SELECT DISTINCT 
	pa.authority_type,
	pa.authority_id,
	pa.authority_sequence,
	af.authority_formulary_id,
	af.authority_formulary_sequence,
	af.icd_9_code,
	f.formulary_code, 
	f.formulary_type, 
	f.title, 
	f.description,
	f.button,
	f.icon,
	f.negative_flag,
	f.sort_sequence
FROM p_Patient_Authority pa
	INNER JOIN c_Authority_Formulary af
	ON af.authority_id = pa.authority_id
	INNER JOIN c_Formulary f
	ON af.formulary_code = f.formulary_code
WHERE pa.cpr_id = @ps_cpr_id
AND af.treatment_type = @ls_treatment_type
AND af.treatment_key = @ls_treatment_key
AND (af.icd_9_code IS NULL
	OR EXISTS(
			SELECT aa.icd_9_code
			FROM @assessments aa
			WHERE aa.icd_9_code LIKE (af.icd_9_code + '%') ) )

