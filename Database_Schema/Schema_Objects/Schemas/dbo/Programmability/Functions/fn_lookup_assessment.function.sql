CREATE FUNCTION fn_lookup_assessment (
	@ps_cpr_id varchar(12),
	@ps_id_domain varchar(40),
	@ps_id varchar(40) )

RETURNS int

AS
BEGIN

DECLARE @ls_cpr_id varchar(12),
		@ll_problem_id int

SET @ll_problem_id = NULL

-- Check for hard-coded id_domains
IF @ps_id_domain IN ('jmj_problem_id', 'problem_id')
	SELECT @ll_problem_id = max(problem_id)
	FROM p_assessment
	WHERE cpr_id = @ps_cpr_id
	AND problem_id = CAST(@ps_id AS int)
ELSE IF @ps_id_domain = 'jmj_guid'
	SELECT @ll_problem_id = max(problem_id)
	FROM p_assessment
	WHERE cpr_id = @ps_cpr_id
	AND CAST(id AS varchar(40)) = @ps_id
ELSE
	SELECT @ll_problem_id = min(problem_id)
	FROM p_Assessment_Progress
	WHERE cpr_id = @ps_cpr_id
	AND progress_type = 'ID'
	AND progress_key = @ps_id_domain
	AND progress_value = @ps_id
	AND current_flag = 'Y'

RETURN @ll_problem_id

END

