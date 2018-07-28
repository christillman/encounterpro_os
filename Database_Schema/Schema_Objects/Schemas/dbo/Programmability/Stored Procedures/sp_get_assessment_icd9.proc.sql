CREATE PROCEDURE sp_get_assessment_icd9 (
	@ps_cpr_id varchar(12),
	@ps_assessment_id varchar(24)
	--, @ps_insurance_id varchar(24) OUTPUT,
	--@ps_icd_9_code varchar(12) OUTPUT
	)
AS
DECLARE @li_authority_sequence smallint
	, @ls_insurance_id varchar(24)
	, @ls_icd_9_code varchar(12)
	, @ls_asst_description varchar(80)
	
SELECT @ls_insurance_id = NULL,
	@ls_icd_9_code = NULL
-- Assume that minimal sequence number is primary insurance carrier
SELECT @li_authority_sequence = min(authority_sequence)
FROM p_Patient_Authority WITH (NOLOCK)
WHERE cpr_id = @ps_cpr_id
IF @li_authority_sequence IS NOT NULL
	SELECT @ls_insurance_id = i.authority_id,
		@ls_icd_9_code = i.icd_9_code
	FROM c_Assessment_Coding i, p_Patient_Authority pi WITH (NOLOCK)
	WHERE pi.cpr_id = @ps_cpr_id
	AND pi.authority_sequence = @li_authority_sequence
	AND i.assessment_id = @ps_assessment_id
	AND pi.authority_id = i.authority_id
IF @ls_insurance_id IS NULL
	SELECT @ls_icd_9_code = icd_9_code,@ls_asst_description=description
	FROM c_Assessment_Definition
	WHERE assessment_id = @ps_assessment_id

SELECT @ls_insurance_id AS insurance_id, @ls_icd_9_code AS icd_9_code,@ls_asst_description as asst_description

