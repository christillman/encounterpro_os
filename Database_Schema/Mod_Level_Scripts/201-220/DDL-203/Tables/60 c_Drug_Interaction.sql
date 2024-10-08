
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Drug_Interaction]') AND [type]='U'))
	DROP TABLE [dbo].[c_Drug_Interaction]
GO

IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Drug_Interaction_Class]') AND [type]='U'))
	DROP TABLE [dbo].[c_Drug_Interaction_Class]
GO

CREATE TABLE c_Drug_Interaction (
	interaction_name varchar(80),
	object_drug_class varchar(40),
	precipitant_drug_class varchar(40), 
	alert_level varchar(24),
	interaction_type varchar(40),
	interaction_severity varchar(40),
	interaction_probability varchar(40),
	interaction_symptoms varchar(500),
	evidence_provider_material_id int,
	risk_factor_provider_material_id int,
	mitigating_factor_provider_material_id int
	)

CREATE TABLE c_Drug_Interaction_Class (
	drug_class varchar(40),
	drug_id varchar(24),
	generic_rxcui varchar(10),
	generic_drug_name varchar(500),
	qualifier varchar(80)
	)



-- Also program check for "Therapeutic duplication" with two drugs of the same class 
-- Abatacept with tumor necrosis factor (TNF) inhibitor
-- Abatacept with interleukin-1 receptor antagonist
-- Natalizumab with immunosuppressant
-- Pentostatin with ﬂudarabine




