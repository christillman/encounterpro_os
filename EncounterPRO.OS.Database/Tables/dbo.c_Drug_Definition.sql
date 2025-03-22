
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_Drug_Definition]
Print 'Drop Table [dbo].[c_Drug_Definition]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Drug_Definition]') AND [type]='U'))
DROP TABLE [dbo].[c_Drug_Definition]
GO
-- Create Table [dbo].[c_Drug_Definition]
Print 'Create Table [dbo].[c_Drug_Definition]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[c_Drug_Definition] (
		[drug_id]                            [varchar](24) NOT NULL,
		[drug_type]                          [varchar](24) NULL,
	[common_name] [varchar](80) NULL,
	[generic_name] [varchar](500) NULL,
		[controlled_substance_flag]          [char](1) NULL,
		[default_duration_amount]            [real] NULL,
		[default_duration_unit]              [varchar](16) NULL,
		[default_duration_prn]               [varchar](32) NULL,
		[max_dose_per_day]                   [real] NULL,
		[max_dose_unit]                      [varchar](12) NULL,
		[status]                             [varchar](12) NULL,
		[id]                                 [uniqueidentifier] NOT NULL,
		[last_updated]                       [datetime] NOT NULL,
		[owner_id]                           [int] NOT NULL,
		[patient_reference_material_id]      [int] NULL,
		[provider_reference_material_id]     [int] NULL,
		[dea_schedule]                       [varchar](6) NOT NULL,
		[dea_number]                         [varchar](18) NULL,
		[dea_narcotic_status]                [varchar](20) NULL,
		[procedure_id]                       [varchar](24) NULL,
		[reference_ndc_code]                 [varchar](24) NULL,
	[fda_generic_available] [smallint] NULL,
	[available_strengths] [varchar](80) NULL,
	[is_generic] [bit] NULL,
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Drug_Definition]
	ADD
	CONSTRAINT [PK_c_Drug_Definition_1__10]
	PRIMARY KEY
	CLUSTERED
	([drug_id])
	WITH FILLFACTOR=100
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Drug_Definition]
	ADD
	CONSTRAINT [DF__c_Drug__last___5BC83AC2]
	DEFAULT (dbo.get_client_datetime()) FOR [last_updated]
GO
ALTER TABLE [dbo].[c_Drug_Definition]
	ADD
	CONSTRAINT [DF__c_Drug_dea_schedule_5]
	DEFAULT ('NA') FOR [dea_schedule]
GO
ALTER TABLE [dbo].[c_Drug_Definition]
	ADD
	CONSTRAINT [DF__c_Drug_Defin__id__3631FF56]
	DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[c_Drug_Definition]
	ADD
	CONSTRAINT [DF__c_Drug_owner__4E6E3FA4]
	DEFAULT ([dbo].[fn_customer_id]()) FOR [owner_id]
GO
ALTER TABLE [dbo].[c_Drug_Definition]
	ADD
	CONSTRAINT [DF_c_Drug_Def_status_1__13]
	DEFAULT ('OK') FOR [status]
GO
ALTER TABLE [dbo].[c_Drug_Definition]
	ADD
	CONSTRAINT [DF_c_Drug_Definition_drug_type]
	DEFAULT ('Single Drug') FOR [drug_type]
GO
GRANT DELETE ON [dbo].[c_Drug_Definition] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Drug_Definition] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Drug_Definition] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Drug_Definition] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Drug_Definition] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Drug_Definition] SET (LOCK_ESCALATION = TABLE)
GO

