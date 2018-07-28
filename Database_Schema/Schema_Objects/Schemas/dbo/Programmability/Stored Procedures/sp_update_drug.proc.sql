CREATE PROCEDURE sp_update_drug (
	@ps_drug_id varchar(24),
	@ps_drug_type varchar(24) = NULL ,
	@ps_controlled_substance_flag char(1),
	@pr_default_duration_amount real,
	@ps_default_duration_unit varchar(12),
	@ps_default_duration_prn varchar(32),
	@pr_max_dose_per_day real,
	@ps_max_dose_unit varchar(12),
	@ps_drug_common_name varchar(40) )
AS
UPDATE c_Drug_Definition
SET	drug_type = COALESCE(@ps_drug_type, drug_type),
	controlled_substance_flag = COALESCE(@ps_controlled_substance_flag, controlled_substance_flag),
	default_duration_amount = @pr_default_duration_amount,
	default_duration_unit = @ps_default_duration_unit,
	default_duration_prn = @ps_default_duration_prn,
	max_dose_per_day = @pr_max_dose_per_day,
	max_dose_unit = @ps_max_dose_unit,
	common_name = @ps_drug_common_name
WHERE drug_id = @ps_drug_id

