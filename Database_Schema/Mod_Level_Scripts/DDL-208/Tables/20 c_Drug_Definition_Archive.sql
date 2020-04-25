-- Don't want to drop, once created ... permanent archive
IF (NOT EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Drug_Definition_Archive]') AND [type]='U'))

CREATE TABLE [dbo].[c_Drug_Definition_Archive](
	[drug_id] [varchar](24) NOT NULL,
	[drug_type] [varchar](24) NULL,
	[common_name] [varchar](80) NULL,
	[generic_name] [varchar](500) NULL,
	[controlled_substance_flag] [char](1) NULL,
	[default_duration_amount] [real] NULL,
	[default_duration_unit] [varchar](16) NULL,
	[default_duration_prn] [varchar](32) NULL,
	[max_dose_per_day] [real] NULL,
	[max_dose_unit] [varchar](12) NULL,
	[status] [varchar](12) NULL,
	[last_updated] datetime NOT NULL,
	[owner_id] [int] NOT NULL,
	[patient_reference_material_id] [int] NULL,
	[provider_reference_material_id] [int] NULL,
	[dea_schedule] [varchar](6) NOT NULL,
	[dea_number] [varchar](18) NULL,
	[dea_narcotic_status] [varchar](20) NULL,
	[procedure_id] [varchar](24) NULL,
	[reference_ndc_code] [varchar](24) NULL,
	[fda_generic_available] [smallint] NULL,
	[available_strengths] [varchar](80) NULL,
	[is_generic] [bit] NULL
	)
GO

GRANT DELETE, INSERT, SELECT, UPDATE ON c_Drug_Definition_Archive TO [cprsystem] AS [dbo]
GO

IF (NOT EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Drug_Package_Archive]') AND [type]='U'))

CREATE TABLE [dbo].[c_Drug_Package_Archive](
	[drug_id] [varchar](24) NOT NULL,
	[package_id] [varchar](24) NOT NULL,
	[sort_order] [smallint] NULL,
	[prescription_flag] [varchar](1) NULL,
	[default_dispense_amount] [real] NULL,
	[default_dispense_unit] [varchar](12) NULL,
	[take_as_directed] [char](1) NULL,
	[hcpcs_procedure_id] [varchar](24) NULL
) 

GO

GRANT DELETE, INSERT, SELECT, UPDATE ON c_Drug_Package_Archive TO [cprsystem] AS [dbo]
GO


IF (NOT EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Package_Archive]') AND [type]='U'))

CREATE TABLE [dbo].[c_Package_Archive](
	[package_id] [varchar](24) NOT NULL,
	[administer_method] [varchar](12) NULL,
	[description] [varchar](80) NULL,
	[administer_unit] [varchar](12) NULL,
	[dose_unit] [varchar](12) NULL,
	[administer_per_dose] [real] NULL,
	[dosage_form] [varchar](24) NULL,
	[dose_amount] [real] NULL,
    [status] varchar(12) NOT NULL
)
GO

GRANT DELETE, INSERT, SELECT, UPDATE ON c_Package_Archive TO [cprsystem] AS [dbo]
GO
