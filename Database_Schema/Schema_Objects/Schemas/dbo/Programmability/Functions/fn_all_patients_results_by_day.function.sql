CREATE FUNCTION fn_all_patients_results_by_day (
	@ps_observation_id varchar(24),
	@pi_result_sequence smallint)

RETURNS @patient_results TABLE (
	cpr_id varchar(12) NOT NULL,
	observation_sequence int NOT NULL,
	location_result_sequence int NOT NULL,
	observation_id varchar(24) NOT NULL,
	treatment_id int NULL,
	encounter_id int NULL,
	result_sequence smallint NOT NULL,
	location varchar(24) NOT NULL,
	result_date_time datetime NOT NULL,
	result_day datetime NOT NULL,
	result_type varchar(12) NOT NULL,
	result varchar(80) NOT NULL,
	result_value varchar(40) NULL,
	result_unit varchar(12) NULL,
	abnormal_flag char(1) NULL)
AS

BEGIN


DECLARE @tmp_results_all TABLE (
	cpr_id varchar(12) NOT NULL,
	observation_sequence int NOT NULL,
	location_result_sequence int NOT NULL,
	observation_id varchar(24) NOT NULL,
	treatment_id int NULL,
	encounter_id int NULL,
	result_sequence smallint NOT NULL,
	location varchar(24) NOT NULL,
	result_date_time datetime NOT NULL,
	result_day datetime NOT NULL,
	result_type varchar(12) NOT NULL,
	result varchar(80) NOT NULL,
	result_value varchar(40) NULL,
	result_unit varchar(12) NULL,
	abnormal_flag char(1) NULL)

-- Get all the max result per day
-- If the result sequence is null then get the latest result regardless of result sequence
IF @pi_result_sequence IS NULL
	BEGIN
	INSERT INTO @tmp_results_all (
		cpr_id,
		observation_sequence,
		location_result_sequence ,
		treatment_id ,
		observation_id,
		encounter_id,
		result_sequence ,
		location ,
		result_date_time ,
		result_day ,
		result_type ,
		result ,
		result_value ,
		result_unit ,
		abnormal_flag)
	SELECT 
		r.cpr_id,
		r.observation_sequence,
		r.location_result_sequence ,
		r.treatment_id ,
		r.observation_id ,
		r.encounter_id ,
		r.result_sequence ,
		r.location ,
		r.result_date_time ,
		convert(datetime, convert(varchar, r.result_date_time, 112)) ,
		r.result_type ,
		r.result ,
		r.result_value ,
		r.result_unit ,
		r.abnormal_flag
	FROM p_Observation_Result r WITH (NOLOCK)
		INNER JOIN dbo.fn_equivalent_observations(@ps_observation_id) q
		ON r.observation_id = q.observation_id
	WHERE r.result_date_time IS NOT NULL
	AND r.current_flag = 'Y'
	END
ELSE
	BEGIN
	INSERT INTO @tmp_results_all (
		cpr_id,
		observation_sequence,
		location_result_sequence ,
		treatment_id ,
		observation_id,
		encounter_id,
		result_sequence ,
		location ,
		result_date_time ,
		result_day ,
		result_type ,
		result ,
		result_value ,
		result_unit ,
		abnormal_flag)
	SELECT 
		r.cpr_id,
		r.observation_sequence,
		r.location_result_sequence ,
		r.treatment_id ,
		r.observation_id ,
		r.encounter_id ,
		r.result_sequence ,
		r.location ,
		r.result_date_time ,
		convert(datetime, convert(varchar, r.result_date_time, 112)) ,
		r.result_type ,
		r.result ,
		r.result_value ,
		r.result_unit ,
		r.abnormal_flag
	FROM p_Observation_Result r WITH (NOLOCK)
		INNER JOIN dbo.fn_equivalent_observation_results(@ps_observation_id, @pi_result_sequence) q
		ON r.observation_id = q.observation_id
		AND r.result_sequence = q.result_sequence
	WHERE r.result_date_time IS NOT NULL
	AND r.current_flag = 'Y'
	END


-- Get the final list of non-deleted results
INSERT INTO @patient_results (
	cpr_id,
	observation_sequence,
	location_result_sequence ,
	treatment_id ,
	observation_id,
	encounter_id,
	result_sequence ,
	location ,
	result_date_time ,
	result_day ,
	result_type ,
	result ,
	result_value ,
	result_unit ,
	abnormal_flag)
SELECT 	r.cpr_id,
	r.observation_sequence,
	r.location_result_sequence ,
	r.treatment_id ,
	r.observation_id ,
	r.encounter_id ,
	r.result_sequence ,
	r.location ,
	r.result_date_time ,
	t.result_day ,
	r.result_type ,
	r.result ,
	r.result_value ,
	r.result_unit ,
	r.abnormal_flag
FROM @tmp_results_all r 
	INNER JOIN (SELECT cpr_id,
					result_day,
					max(location_result_sequence) as location_result_sequence
				FROM @tmp_results_all
				GROUP BY cpr_id, result_day) t
	ON r.location_result_sequence = t.location_result_sequence

RETURN
END

