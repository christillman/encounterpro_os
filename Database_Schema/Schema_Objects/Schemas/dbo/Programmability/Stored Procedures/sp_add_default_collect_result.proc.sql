CREATE PROCEDURE sp_add_default_collect_result (
	@ps_observation_id varchar(24),
	@pi_result_sequence smallint OUTPUT )
AS
-- Check to see if there is already a COLLECT result
SELECT @pi_result_sequence = min(result_sequence)
FROM c_Observation_Result
WHERE observation_id = @ps_observation_id
AND result_type = 'COLLECT'
-- If not, then add one
IF @pi_result_sequence IS NULL
	BEGIN
	SELECT @pi_result_sequence = max(result_sequence)
	FROM c_Observation_Result
	WHERE observation_id = @ps_observation_id
	IF @pi_result_sequence IS NULL
		SELECT @pi_result_sequence = 1
	ELSE
		SELECT @pi_result_sequence = @pi_result_sequence + 1
	INSERT INTO c_Observation_Result (
		observation_id,
		result_sequence,
		result_type,
		result,
		result_amount_flag,
		severity,
		abnormal_flag,
		sort_sequence,
		status )
	VALUES (
		@ps_observation_id,
		@pi_result_sequence,
		'COLLECT',
		'Collected',
		'N',
		0,
		'N',
		0,
		'OK' )
	END

