CREATE PROCEDURE sp_new_drug_result_set (
	@ps_drug_type varchar(24),
	@ps_common_name varchar(40),
	@ps_generic_name varchar(80),
	@ps_controlled_substance_flag char(1),
	@pr_default_duration_amount real,
	@ps_default_duration_unit varchar(12),
	@ps_default_duration_prn varchar(32),
	@pr_max_dose_per_day real,
	@ps_max_dose_unit varchar(12) )
AS

DECLARE @ls_drug_id varchar(24)

EXECUTE sp_new_drug_definition
	@ps_drug_type = @ps_drug_type,
	@ps_common_name = @ps_common_name,
	@ps_generic_name = @ps_generic_name,
	@ps_controlled_substance_flag = @ps_controlled_substance_flag,
	@pr_default_duration_amount = @pr_default_duration_amount,
	@ps_default_duration_unit = @ps_default_duration_unit,
	@ps_default_duration_prn = @ps_default_duration_prn,
	@pr_max_dose_per_day = @pr_max_dose_per_day,
	@ps_max_dose_unit = @ps_max_dose_unit,
	@ps_drug_id = @ls_drug_id OUTPUT

SELECT @ls_drug_id as drug_id
FROM c_1_Record

