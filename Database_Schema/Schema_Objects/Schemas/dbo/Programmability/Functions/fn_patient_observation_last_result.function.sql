CREATE FUNCTION fn_patient_observation_last_result (
	@ps_cpr_id varchar(12),
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
	result_value varchar(40) NULL,
	result_unit varchar(12) NULL)
AS

BEGIN


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
	result_value ,
	result_unit )
SELECT 	TOP 1 cpr_id,
	observation_sequence,
	location_result_sequence ,
	treatment_id ,
	observation_id ,
	encounter_id ,
	result_sequence ,
	location ,
	result_date_time ,
	result_value ,
	result_unit 
FROM p_Observation_Result
WHERE cpr_id = @ps_cpr_id
AND observation_id = @ps_observation_id
AND result_sequence = @pi_result_sequence
AND current_flag = 'Y'
ORDER BY result_date_time DESC

RETURN
END

