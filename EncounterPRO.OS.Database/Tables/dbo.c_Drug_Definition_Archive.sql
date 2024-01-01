IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[c_Drug_Definition_Archive]') AND type in (N'U'))
DROP TABLE [c_Drug_Definition_Archive]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [c_Drug_Definition_Archive](
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
	[last_updated] [datetime] NOT NULL,
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
) ON [PRIMARY]
GO
