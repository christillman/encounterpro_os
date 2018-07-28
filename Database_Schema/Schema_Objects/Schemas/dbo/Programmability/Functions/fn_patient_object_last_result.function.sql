CREATE FUNCTION fn_patient_object_last_result (
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(24),
	@pl_object_key int,
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
	result_unit varchar(12) NULL,
	result varchar(80) NOT NULL,
	abnormal_flag char(1) NULL,
	result_amount_flag char(1) NULL,
	print_result_flag char(1) NULL,
	print_result_separator varchar(8) NULL,
	unit_preference varchar(24) NULL,
	display_mask varchar(40)
	)
AS

BEGIN

DECLARE @ll_encounter_id int,
		@ll_treatment_id int

IF @ps_context_object = 'Encounter'
	SET @ll_encounter_id = @pl_object_key
ELSE
	SET @ll_encounter_id = NULL

IF @ps_context_object = 'Treatment'
	SET @ll_treatment_id = @pl_object_key
ELSE
	SET @ll_treatment_id = NULL

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
	result_unit,
	result,
	abnormal_flag,
	result_amount_flag,
	print_result_flag,
	print_result_separator,
	unit_preference,
	display_mask )
SELECT 	TOP 1 p.cpr_id,
	p.observation_sequence,
	p.location_result_sequence ,
	p.treatment_id ,
	p.observation_id ,
	p.encounter_id ,
	p.result_sequence ,
	p.location ,
	p.result_date_time ,
	p.result_value ,
	p.result_unit ,
	p.result ,
	p.abnormal_flag ,
	c.result_amount_flag ,
	c.print_result_flag ,
	c.print_result_separator ,
	c.unit_preference ,
	c.display_mask
FROM p_Observation_Result p
	LEFT OUTER JOIN c_Observation_Result c
	ON p.observation_id = c.observation_id
	AND p.result_sequence = c.result_sequence
WHERE p.cpr_id = @ps_cpr_id
AND p.observation_id = @ps_observation_id
AND p.result_sequence = @pi_result_sequence
AND p.current_flag = 'Y'
AND (@ll_encounter_id IS NULL OR p.encounter_id = @ll_encounter_id)
AND (@ll_treatment_id IS NULL OR p.treatment_id = @ll_treatment_id)
ORDER BY p.result_date_time DESC

RETURN
END

