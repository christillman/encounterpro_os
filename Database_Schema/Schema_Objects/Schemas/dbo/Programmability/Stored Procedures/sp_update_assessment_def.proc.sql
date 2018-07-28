CREATE PROCEDURE sp_update_assessment_def (
	@ps_assessment_id varchar(24),
	@ps_icd_9_code varchar(12),
	@ps_assessment_category_id varchar(24),
	@ps_description varchar(80),
	@ps_location_domain varchar(12),
	@ps_auto_close char(1),
	@pi_auto_close_interval_amount smallint = NULL,
	@ps_auto_close_interval_unit varchar(24) = NULL,
	@pl_risk_level integer = NULL,
	@pl_complexity integer = NULL,
	@ps_long_description text )
AS

UPDATE c_Assessment_Definition
SET	icd_9_code = @ps_icd_9_code,
	description = @ps_description,
	assessment_category_id = @ps_assessment_category_id,
	location_domain = @ps_location_domain,
	auto_close = @ps_auto_close,
	auto_close_interval_amount = COALESCE(@pi_auto_close_interval_amount, auto_close_interval_amount),
	auto_close_interval_unit = COALESCE(@ps_auto_close_interval_unit, auto_close_interval_unit),
	risk_level = COALESCE(@pl_risk_level, risk_level),
	complexity = COALESCE(@pl_complexity, complexity),
	long_description = @ps_long_description
WHERE assessment_id = @ps_assessment_id

UPDATE u_Top_20
SET item_text = @ps_description
WHERE item_id = @ps_assessment_id
AND top_20_code like 'ASS%'


