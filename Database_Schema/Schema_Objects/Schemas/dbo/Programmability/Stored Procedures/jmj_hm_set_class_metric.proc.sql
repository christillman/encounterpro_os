CREATE PROCEDURE dbo.jmj_hm_set_class_metric (
	@pl_maintenance_rule_id int,
	@ps_observation_id varchar(24),
	@pi_result_sequence smallint,
	@ps_title varchar(40),
	@ps_description varchar(80),
	@pl_interval int,
	@ps_interval_unit varchar(24),
	@ps_created_by varchar(24))
AS

DECLARE @ll_metric_sequence int

SELECT @ll_metric_sequence = max(metric_sequence)
FROM c_Maintenance_Metric
WHERE maintenance_rule_id = @pl_maintenance_rule_id
AND observation_id = @ps_observation_id
AND result_sequence = @pi_result_sequence

IF @ll_metric_sequence > 0
	UPDATE c_Maintenance_Metric
	SET title = @ps_title,
		description = @ps_description,
		interval = @pl_interval,
		interval_unit = @ps_interval_unit
	WHERE maintenance_rule_id = @pl_maintenance_rule_id
	AND metric_sequence = @ll_metric_sequence
ELSE
	BEGIN
	INSERT INTO c_Maintenance_Metric (
		maintenance_rule_id,
		title,
		description,
		observation_id,
		result_sequence,
		interval,
		interval_unit,
		created_by)
	VALUES (
		@pl_maintenance_rule_id,
		@ps_title,
		@ps_description,
		@ps_observation_id,
		@pi_result_sequence,
		@pl_interval,
		@ps_interval_unit,
		@ps_created_by)

	SET @ll_metric_sequence = SCOPE_IDENTITY()
	END

RETURN @ll_metric_sequence

