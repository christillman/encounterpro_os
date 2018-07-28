CREATE PROCEDURE sp_new_observation_result (
	@ps_observation_id varchar(24),
	@ps_result_type varchar(12) = 'PERFORM',
	@ps_result_unit varchar(12) = 'NA',
	@ps_result varchar(80),
	@ps_result_amount_flag char(1) = 'N',
	@ps_print_result_flag char(1) = NULL,
	@ps_specimen_type varchar(24) = NULL ,
	@ps_abnormal_flag char(1) = 'N',
	@pi_severity smallint = 0,
	@ps_external_source varchar(24) = NULL,
	@pl_property_id int = NULL,
	@ps_service varchar(24) = NULL,
	@ps_unit_preference varchar(24) = NULL,
	@ps_status varchar(12) ='OK',
	@pi_result_sequence smallint OUTPUT )
AS

DECLARE @li_sort_sequence smallint

-- First see if the result already exists
SELECT	@pi_result_sequence = max(result_sequence)
FROM c_Observation_Result
WHERE observation_id = @ps_observation_id
AND result_type = @ps_result_type
AND result = @ps_result
AND result_amount_flag = @ps_result_amount_flag

IF @ps_print_result_flag IS NULL
	SET @ps_print_result_flag = CASE @ps_result_type WHEN 'COLLECT' THEN 'N' ELSE 'Y' END

IF @pi_result_sequence IS NULL
	BEGIN
	-- Add the result

	SELECT	@pi_result_sequence = max(result_sequence)
	FROM c_Observation_Result
	WHERE observation_id = @ps_observation_id

	SELECT	@li_sort_sequence = max(sort_sequence)
	FROM c_Observation_Result
	WHERE observation_id = @ps_observation_id

	IF @pi_result_sequence is null
		SET @pi_result_sequence = 1
	ELSE
		SET @pi_result_sequence = @pi_result_sequence + 1

	IF @li_sort_sequence is null
		SET @li_sort_sequence = 1
	ELSE
		SET @li_sort_sequence = @li_sort_sequence + 1

	INSERT INTO c_Observation_Result (
		observation_id,
		result_sequence,
		result_type,
		result_unit,
		result,
		result_amount_flag,
		print_result_flag,
		specimen_type,
		abnormal_flag,
		severity,
		external_source,
		property_id,
		service,
		unit_preference,
		sort_sequence,
		status )
	VALUES (
		@ps_observation_id,
		@pi_result_sequence,
		@ps_result_type,
		@ps_result_unit,
		@ps_result,
		@ps_result_amount_flag,
		@ps_print_result_flag,
		@ps_specimen_type,
		@ps_abnormal_flag,
		@pi_severity,
		@ps_external_source,
		@pl_property_id,
		@ps_service,
		@ps_unit_preference,
		@li_sort_sequence,
		@ps_status )
	END
ELSE
	BEGIN
	
	UPDATE c_Observation_Result
	SET result_unit = CASE @ps_status WHEN 'OK' THEN @ps_result_unit ELSE COALESCE(result_unit, @ps_result_unit) END,
		print_result_flag = CASE @ps_status WHEN 'OK' THEN @ps_print_result_flag ELSE COALESCE(print_result_flag, @ps_print_result_flag) END,
		specimen_type = CASE @ps_status WHEN 'OK' THEN @ps_specimen_type ELSE COALESCE(specimen_type, @ps_specimen_type) END,
		abnormal_flag = CASE @ps_status WHEN 'OK' THEN @ps_abnormal_flag ELSE COALESCE(abnormal_flag, @ps_abnormal_flag) END,
		severity = CASE @ps_status WHEN 'OK' THEN @pi_severity ELSE COALESCE(severity, @pi_severity) END,
		external_source = CASE @ps_status WHEN 'OK' THEN @ps_external_source ELSE COALESCE(external_source, @ps_external_source) END,
		property_id = CASE @ps_status WHEN 'OK' THEN @pl_property_id ELSE COALESCE(property_id, @pl_property_id) END,
		service = CASE @ps_status WHEN 'OK' THEN @ps_service ELSE COALESCE(service, @ps_service) END,
		unit_preference = CASE @ps_status WHEN 'OK' THEN @ps_unit_preference ELSE COALESCE(unit_preference, @ps_unit_preference) END,
		status = CASE @ps_status WHEN 'OK' THEN @ps_status ELSE COALESCE(status, @ps_status) END
	WHERE observation_id = @ps_observation_id
	AND result_sequence = @pi_result_sequence
	
	END

