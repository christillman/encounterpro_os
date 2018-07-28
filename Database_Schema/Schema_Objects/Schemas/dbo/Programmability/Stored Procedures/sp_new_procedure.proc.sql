CREATE PROCEDURE sp_new_procedure (
	@ps_procedure_type varchar(12),
	@ps_cpt_code varchar(24),
	@pdc_charge decimal = NULL,
	@ps_procedure_category_id varchar(24),
	@ps_description varchar(80),
	@ps_service varchar(24) = NULL,
	@ps_vaccine_id varchar(24) = NULL,
	@pr_units float,
	@ps_modifier varchar(2) = NULL,
	@ps_other_modifiers varchar(12) = NULL,
	@ps_billing_id varchar(24) = NULL,
	@ps_location_domain varchar(12) = NULL,
	@pi_risk_level integer = NULL,
	@ps_default_bill_flag char(1) = NULL,
	@ps_long_description text = NULL,
	@ps_default_location varchar(24)= NULL,
	@ps_bill_assessment_id varchar(24) = NULL,
	@ps_well_encounter_flag char(1) = NULL
	)
AS

DECLARE @ls_procedure_id varchar(24)

EXECUTE sp_new_procedure_record
		@ps_procedure_id = @ls_procedure_id OUTPUT,
		@ps_procedure_type = @ps_procedure_type,
		@ps_cpt_code = @ps_cpt_code,
		@pdc_charge = @pdc_charge,
		@ps_procedure_category_id = @ps_procedure_category_id,
		@ps_description = @ps_description,
		@ps_service = @ps_service,
		@ps_vaccine_id = @ps_vaccine_id,
		@pr_units = @pr_units,
		@ps_modifier = @ps_modifier,
		@ps_other_modifiers = @ps_other_modifiers,
		@ps_billing_id = @ps_billing_id,
		@ps_location_domain = @ps_location_domain,
		@pi_risk_level = @pi_risk_level,
		@ps_default_bill_flag = @ps_default_bill_flag,
		@ps_long_description = @ps_long_description,
		@ps_default_location = @ps_default_location,
		@ps_bill_assessment_id = @ps_bill_assessment_id,
		@ps_well_encounter_flag = @ps_well_encounter_flag
		

SELECT @ls_procedure_id AS procedure_id

