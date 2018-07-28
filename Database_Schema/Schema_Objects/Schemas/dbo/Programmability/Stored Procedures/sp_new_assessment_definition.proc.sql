CREATE PROCEDURE sp_new_assessment_definition (
	--@ps_assessment_id varchar(24) OUTPUT,
	@ps_assessment_type varchar(24),
	@ps_icd_9_code varchar(12),
	@ps_assessment_category_id varchar(24),
	@ps_description varchar(80),
	@ps_location_domain varchar(12) = NULL,
	@ps_auto_close char(1),
	@pi_auto_close_interval_amount smallint = NULL,
	@ps_auto_close_interval_unit varchar(24) = NULL,
	@pl_risk_level integer = NULL,
	@pl_complexity integer = NULL,
	@ps_long_description text = NULL )
AS

DECLARE @ll_key_value integer
	, @ls_assessment_id varchar(24)

EXECUTE sp_new_assessment
	@ps_assessment_type = @ps_assessment_type,
	@ps_icd_9_code = @ps_icd_9_code,
	@ps_assessment_category_id = @ps_assessment_category_id,
	@ps_description = @ps_description,
	@ps_location_domain = @ps_location_domain,
	@ps_auto_close = @ps_auto_close,
	@pi_auto_close_interval_amount = @pi_auto_close_interval_amount,
	@ps_auto_close_interval_unit = @ps_auto_close_interval_unit,
	@pl_risk_level = @pl_risk_level,
	@pl_complexity = @pl_complexity,
	@ps_long_description = @ps_long_description,
	@ps_assessment_id = @ls_assessment_id OUTPUT


SELECT @ls_assessment_id AS assessment_id

