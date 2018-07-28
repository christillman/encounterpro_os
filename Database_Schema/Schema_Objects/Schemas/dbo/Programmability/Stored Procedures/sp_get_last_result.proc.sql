CREATE PROCEDURE sp_get_last_result (
	@ps_cpr_id varchar(12),
	@ps_observation_id varchar(24)
	)
AS

DECLARE @ll_location_result_sequence int,
		@ldt_result_date_time datetime

SELECT @ldt_result_date_time = max(result_date_time)
FROM p_Observation_Result (NOLOCK)
WHERE cpr_id = @ps_cpr_id
AND observation_id = @ps_observation_id
AND result_type = 'PERFORM'
AND current_flag = 'Y'

IF @ldt_result_date_time IS NOT NULL
	SELECT @ll_location_result_sequence = max(location_result_sequence)
	FROM p_Observation_Result (NOLOCK)
	WHERE cpr_id = @ps_cpr_id
	AND observation_id = @ps_observation_id
	AND result_type = 'PERFORM'
	AND current_flag = 'Y'
	AND result_date_time = @ldt_result_date_time

SELECT p.location ,
	p.result_sequence ,
	p.observation_sequence ,
	p.result ,
	c.result_amount_flag ,
	p.result_date_time ,
	p.result_value ,
	p.result_unit 
FROM p_Observation_Result p
	INNER JOIN c_Observation_Result c
	ON p.observation_id = c.observation_id
	AND p.result_sequence = c.result_sequence
WHERE p.cpr_id = @ps_cpr_id
AND p.observation_id = @ps_observation_id
AND p.location_result_sequence = @ll_location_result_sequence


