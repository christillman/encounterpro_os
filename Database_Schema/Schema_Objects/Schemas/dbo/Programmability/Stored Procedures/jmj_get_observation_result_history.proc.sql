CREATE PROCEDURE jmj_get_observation_result_history (
	@ps_cpr_id varchar(12),
	@ps_observation_id varchar(24),
	@pi_result_sequence smallint )
AS

SELECT r.observation_sequence,
	r.location_result_sequence,
	r.result,
	r.result_date_time,
	r.location,
	r.result_value,
	r.result_unit,
	r.abnormal_flag,
	c.result_amount_flag,
	c.print_result_flag,
	c.print_result_separator,
	c.unit_preference,
	c.display_mask,
	l.description as location_description
FROM p_Observation_Result r WITH (NOLOCK)
	INNER JOIN c_Observation_Result c WITH (NOLOCK)
	ON r.observation_id = c.observation_id
	AND r.result_sequence = c.result_sequence
	LEFT OUTER JOIN c_Location l
	ON r.location = l.location
WHERE r.cpr_id = @ps_cpr_id
AND r.observation_id = @ps_observation_id
AND r.result_sequence = @pi_result_sequence

