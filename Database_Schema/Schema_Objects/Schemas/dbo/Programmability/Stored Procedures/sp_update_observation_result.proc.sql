CREATE PROCEDURE sp_update_observation_result (
	@ps_observation_id varchar(24),
	@pi_result_sequence smallint,
	@ps_result_unit varchar(12) = 'NA',
	@ps_result_amount_flag char(1) = 'N',
	@ps_print_result_flag char(1) = NULL,
	@ps_specimen_type varchar(24) = NULL,
	@ps_abnormal_flag char(1) = 'N',
	@pi_severity smallint = 0,
	@ps_external_source varchar(24) = NULL,
	@pl_property_id int = NULL,
	@ps_service varchar(24) = NULL,
	@ps_unit_preference varchar(24) = NULL,
	@ps_status varchar(12) ='OK')
AS
UPDATE c_Observation_Result
SET	result_unit = @ps_result_unit,
	result_amount_flag = @ps_result_amount_flag,
	print_result_flag = COALESCE(@ps_print_result_flag, print_result_flag),
	specimen_type = @ps_specimen_type,
	abnormal_flag = @ps_abnormal_flag,
	severity = @pi_severity,
	external_source = @ps_external_source,
	property_id = @pl_property_id,
	service = @ps_service,
	unit_preference = @ps_unit_preference,
	status = @ps_status
WHERE observation_id = @ps_observation_id
AND result_sequence = @pi_result_sequence

