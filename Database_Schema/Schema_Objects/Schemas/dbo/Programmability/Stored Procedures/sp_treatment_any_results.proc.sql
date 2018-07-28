CREATE PROCEDURE sp_treatment_any_results (
	@ps_cpr_id varchar(12),
	@pl_treatment_id int,
	@ps_result_type varchar(12) = NULL)
AS
DECLARE @lb_any_results int

SET @lb_any_results = 0
-- First see if there are any results for this observation_sequence

SELECT @lb_any_results = 1
FROM c_1_Record
WHERE EXISTS (
	SELECT cpr_id
	FROM p_Observation_Result
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @pl_treatment_id
	AND current_flag = 'Y'
	AND (@ps_result_type IS NULL OR @ps_result_type = result_type) )

IF @lb_any_results = 1
	RETURN 1

-- Comments are counted as perform results
IF (@ps_result_type IS NULL OR @ps_result_type = 'PERFORM')
	BEGIN
	SELECT @lb_any_results = 1
	FROM c_1_Record
	WHERE EXISTS (
		SELECT cpr_id
		FROM p_Observation_Comment
		WHERE cpr_id = @ps_cpr_id
		AND treatment_id = @pl_treatment_id
		AND current_flag = 'Y')

	IF @lb_any_results = 1
		RETURN 1
	END
	

RETURN 0

