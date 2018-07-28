CREATE PROCEDURE sp_new_maintenance_rule (
	@ps_assessment_flag char(1),
	@ps_sex char(1),
	@ps_race varchar(12),
	@pl_age_range_id int,
	@ps_description varchar(80),
	@pl_interval int,
	@ps_interval_unit varchar(24),
	@pl_warning_days int,
	@pl_maintenance_rule_id int OUTPUT )
AS
IF @pl_maintenance_rule_id IS NULL
	INSERT INTO c_Maintenance_Rule (
		assessment_flag,
		sex,
		description,
		age_range_id,
		interval,
		interval_unit,
		warning_days)
	VALUES (
		@ps_assessment_flag,
		@ps_sex,
		@ps_description,
		@pl_age_range_id,
		@pl_interval,
		@ps_interval_unit,
		@pl_warning_days)
	SELECT @pl_maintenance_rule_id = @@IDENTITY
	/*UPDATE c_Maintenance_rule
	SET assessment_flag = @ps_assessment_flag,
		sex = @ps_sex,
		race = @ps_race,
		description = @ps_description,
		interval = @pl_interval,
		interval_unit = @ps_interval_unit,
		warning_days = @pl_warning_days
	WHERE maintenance_rule_id = @pl_maintenance_rule_id*/

