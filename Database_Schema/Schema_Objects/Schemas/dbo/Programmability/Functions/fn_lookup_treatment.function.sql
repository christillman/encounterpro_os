CREATE FUNCTION fn_lookup_treatment (
	@ps_cpr_id varchar(12),
	@ps_id_domain varchar(40),
	@ps_id varchar(40) )

RETURNS int

AS
BEGIN

DECLARE @ll_treatment_id int

-- Check for hard-coded id_domains
IF @ps_id_domain IN ('jmj_treatment_id', 'treatment_id')
	SELECT @ll_treatment_id = min(treatment_id)
	FROM p_Treatment_Item
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = CAST(@ps_id AS int)
ELSE IF @ps_id_domain = 'jmj_guid'
	SELECT @ll_treatment_id = min(treatment_id)
	FROM p_Treatment_Item
	WHERE cpr_id = @ps_cpr_id
	AND CAST(id AS varchar(40)) = @ps_id
ELSE
	SELECT @ll_treatment_id = min(treatment_id)
	FROM p_Treatment_Progress
	WHERE cpr_id = @ps_cpr_id
	AND progress_type = 'ID'
	AND progress_key = @ps_id_domain
	AND progress_value = @ps_id
	AND current_flag = 'Y'

RETURN @ll_treatment_id

END

