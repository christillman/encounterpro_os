

IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[p_Propensity]') AND [type]='U'))
	DROP TABLE [dbo].[p_Propensity]
GO

CREATE TABLE p_Propensity (
	patient_id varchar(24) NOT NULL, 
	propensity varchar(40) NOT NULL, 
	propensity_type varchar(24) NOT NULL,
	substance varchar(40),
	substance_type varchar(24),
	certainty varchar(24),
	criticality varchar(24),
	status varchar(10)  
	)

GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON [p_Propensity] TO [cprsystem]


IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[p_Adverse_Reaction]') AND [type]='U'))
	DROP TABLE [dbo].[p_Adverse_Reaction]
GO

CREATE TABLE p_Adverse_Reaction (
	patient_id varchar(24) NOT NULL, 
	substance varchar(40) NOT NULL,
	manifestation varchar(40),
	severity varchar(24),
	exposure_type varchar(24),
	observation_method varchar(24)  
	)

GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON [p_Adverse_Reaction] TO [cprsystem]


IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[p_Adverse_Sensitivity_Test]') AND [type]='U'))
	DROP TABLE [dbo].[p_Adverse_Sensitivity_Test]
GO


CREATE TABLE p_Adverse_Sensitivity_Test (
	patient_id varchar(24) NOT NULL, 
	substance varchar(40) NOT NULL,
	test_performed varchar(250),
	test_result varchar(250)
	)

GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON [p_Adverse_Sensitivity_Test] TO [cprsystem]


IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Allergen]') AND [type]='U'))
	DROP TABLE [dbo].[c_Allergen]
GO

CREATE TABLE c_Allergen (
	substance varchar(80),
	substance_type varchar(24),
	related_drug_id varchar(24),
	related_generic_rxcui varchar(10),
	old_assessment_id varchar(24)
	)

GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON [c_Allergen] TO [cprsystem]


IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Allergen_Drug_Class]') AND [type]='U'))
	DROP TABLE [dbo].[c_Allergen_Drug_Class]
GO

CREATE TABLE c_Allergen_Drug_Class (
	rxcui varchar(10),
	name varchar(80)
	)

GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON [c_Allergen_Drug_Class] TO [cprsystem]

IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Allergen_Drug]') AND [type]='U'))
	DROP TABLE [dbo].[c_Allergen_Drug]
GO

CREATE TABLE c_Allergen_Drug (
	generic_rxcui varchar(10),
	generic_name varchar(80),
	drug_class_rxcui varchar(10),
	drug_id varchar(24)
	)

GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON [c_Allergen_Drug] TO [cprsystem]

IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Adverse_Reaction_Drug_Class]') AND [type]='U'))
	DROP TABLE [dbo].[c_Adverse_Reaction_Drug_Class]
GO

CREATE TABLE c_Adverse_Reaction_Drug_Class (
	rxcui varchar(10),
	name varchar(80)
	)

GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON [c_Adverse_Reaction_Drug_Class] TO [cprsystem]

IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Adverse_Reaction_Drug]') AND [type]='U'))
	DROP TABLE [dbo].[c_Adverse_Reaction_Drug]
GO

CREATE TABLE c_Adverse_Reaction_Drug (
	generic_rxcui varchar(10),
	generic_name varchar(80),
	drug_class_rxcui varchar(10),
	drug_id varchar(24)
	)

GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON [c_Adverse_Reaction_Drug] TO [cprsystem]
