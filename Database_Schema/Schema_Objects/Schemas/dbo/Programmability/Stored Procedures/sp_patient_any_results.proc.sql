CREATE PROCEDURE sp_patient_any_results (
	@ps_cpr_id varchar(12),
	@pl_observation_sequence int,
	@ps_result_type varchar(12) = NULL,
	@ps_abnormal_flag char(1) = 'N')
AS
DECLARE @lb_any_results int,
	@ls_result_type varchar(12),
	@ls_abnormal_flag char(1)

IF @ps_abnormal_flag = 'Y'
	SET @ls_abnormal_flag = 'Y'
ELSE
	SET @ls_abnormal_flag = '%'

IF @ps_result_type IS NULL
	SET @ls_result_type = '%'
ELSE
	SET @ls_result_type = @ps_result_type

SET @lb_any_results = 0
-- First see if there are any results for this observation_sequence

SELECT @lb_any_results = 1
FROM c_1_Record
WHERE EXISTS (
	SELECT cpr_id
	FROM p_Observation_Result
	WHERE cpr_id = @ps_cpr_id
	AND observation_sequence = @pl_observation_sequence
	AND current_flag = 'Y'
	AND ISNULL(result_type, 'PERFORM') LIKE @ls_result_type
	AND ISNULL(abnormal_flag, 'N') LIKE @ls_abnormal_flag )

IF @lb_any_results = 1
	RETURN 1

-- Comments are counted as abnormal perform results
IF ('PERFORM' LIKE @ls_result_type)
	BEGIN
	SELECT @lb_any_results = 1
	FROM c_1_Record
	WHERE EXISTS (
		SELECT cpr_id
		FROM p_Observation_Comment
		WHERE cpr_id = @ps_cpr_id
		AND observation_sequence = @pl_observation_sequence
		AND current_flag = 'Y' )

	IF @lb_any_results = 1
		RETURN 1
	END
	
DECLARE @ll_child_observation_sequence int

-- First recursively call this stored procedure for each child observation
DECLARE lc_children CURSOR LOCAL FAST_FORWARD FOR
	SELECT observation_sequence
	FROM p_Observation
	WHERE cpr_id = @ps_cpr_id
	AND parent_observation_sequence = @pl_observation_sequence

OPEN lc_children

FETCH lc_children INTO @ll_child_observation_sequence
WHILE @@FETCH_STATUS = 0
	BEGIN
	EXECUTE @lb_any_results = sp_patient_any_results
									@ps_cpr_id = @ps_cpr_id,
									@pl_observation_sequence = @ll_child_observation_sequence,
									@ps_result_type = @ps_result_type,
									@ps_abnormal_flag = @ps_abnormal_flag
	
	IF @lb_any_results = 1
		RETURN 1

	FETCH lc_children INTO @ll_child_observation_sequence
	END

RETURN 0

