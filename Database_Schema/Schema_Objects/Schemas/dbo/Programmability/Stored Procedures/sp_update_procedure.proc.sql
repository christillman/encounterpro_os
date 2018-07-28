CREATE PROCEDURE sp_update_procedure (
	@ps_procedure_id varchar(24),
	@ps_procedure_type varchar(12),
	@ps_cpt_code varchar(24),
	@psm_charge smallmoney,
	@ps_procedure_category_id varchar(24),
	@ps_description varchar(80),
	@ps_vaccine_id varchar(24),
	@pr_units float,
	@ps_modifier varchar(2) = NULL,
	@ps_other_modifiers varchar(12) = NULL,
	@ps_billing_id varchar(24) = NULL,
	@ps_location_domain varchar(12) = NULL,
	@pi_risk_level integer = NULL,
	@ps_default_bill_flag char(1) = NULL)
AS

IF @ps_default_bill_flag IS NULL
	SET @ps_default_bill_flag = 'Y'

UPDATE c_Procedure
SET	cpt_code = @ps_cpt_code,
	description = @ps_description,
	charge = @psm_charge,
	procedure_category_id = @ps_procedure_category_id,
	vaccine_id = @ps_vaccine_id,
	units = @pr_units,
	modifier = COALESCE(@ps_modifier, modifier),
	other_modifiers = COALESCE(@ps_other_modifiers, other_modifiers),
	billing_id = COALESCE(@ps_billing_id, billing_id),
	location_domain = COALESCE(@ps_location_domain, location_domain),
	risk_level = COALESCE(@pi_risk_level, risk_level),
	default_bill_flag = @ps_default_bill_flag
WHERE procedure_id = @ps_procedure_id

UPDATE u_Assessment_Treat_Definition
SET treatment_description = @ps_description
WHERE EXISTS (
	SELECT u_Assessment_Treat_Def_Attrib.definition_id
	FROM u_Assessment_Treat_Def_Attrib
	WHERE attribute like '%PROCEDURE_ID'
	AND value = @ps_procedure_id
	AND u_Assessment_Treat_Definition.definition_id = u_Assessment_Treat_Def_Attrib.definition_id
	)

UPDATE u_Top_20
SET item_text = @ps_description
WHERE item_id = @ps_procedure_id
AND top_20_code = '%PROCEDURE%'


