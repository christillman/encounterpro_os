CREATE PROCEDURE sp_new_drug (
	@ps_drug_id varchar(24),
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

-- Fix bug in EncounterPRO
IF @ps_drug_type IN ('Simple Drug', 'Drug')
	SET @ps_drug_type = 'Single Drug'

INSERT INTO c_Drug_Definition (
	drug_id,
	drug_type,
	common_name,
	generic_name,
	controlled_substance_flag,
	default_duration_amount,
	default_duration_unit,
	default_duration_prn,
	max_dose_per_day,
	max_dose_unit )
VALUES (
	@ps_drug_id,
	@ps_drug_type,
	@ps_common_name,
	@ps_generic_name,
	@ps_controlled_substance_flag,
	@pr_default_duration_amount,
	@ps_default_duration_unit,
	@ps_default_duration_prn,
	@pr_max_dose_per_day,
	@ps_max_dose_unit )

