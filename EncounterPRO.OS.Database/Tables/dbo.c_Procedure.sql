
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_Procedure]
Print 'Drop Table [dbo].[c_Procedure]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Procedure]') AND [type]='U'))
DROP TABLE [dbo].[c_Procedure]
GO
-- Create Table [dbo].[c_Procedure]
Print 'Create Table [dbo].[c_Procedure]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[c_Procedure] (
		[procedure_id]              [varchar](24) NOT NULL,
		[procedure_type]            [varchar](12) NOT NULL,
		[procedure_category_id]     [varchar](24) NULL,
		[description]               [varchar](250) NULL,
		[long_description]          [nvarchar](max) NULL,
		[service]                   [varchar](24) NULL,
		[cpt_code]                  [varchar](24) NULL,
		[modifier]                  [varchar](2) NULL,
		[other_modifiers]           [varchar](12) NULL,
		[units]                     [float] NULL,
		[charge]                    [money] NULL,
		[billing_code]              [int] NULL,
		[billing_id]                [varchar](24) NULL,
		[status]                    [varchar](12) NULL,
		[vaccine_id]                [varchar](24) NULL,
		[default_location]          [varchar](24) NULL,
		[default_bill_flag]         [char](1) NULL,
		[location_domain]           [varchar](24) NULL,
		[risk_level]                [int] NULL,
		[complexity]                [int] NULL,
		[id]                        [uniqueidentifier] NOT NULL,
		[bill_flag]                 [char](1) NOT NULL,
		[owner_id]                  [int] NOT NULL,
		[last_updated]              [datetime] NOT NULL,
		[definition]                [varchar](250) NULL,
		[original_cpt_code]         [varchar](24) NULL,
		[bill_assessment_id]        [varchar](24) NULL,
		[well_encounter_flag]       [char](1) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Procedure]
	ADD
	CONSTRAINT [PK_c_Procedure_40]
	PRIMARY KEY
	CLUSTERED
	([procedure_id])
	WITH FILLFACTOR=90
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Procedure]
	ADD
	CONSTRAINT [DF__c_Procedu__bill___7BDDA294]
	DEFAULT ('Y') FOR [bill_flag]
GO
ALTER TABLE [dbo].[c_Procedure]
	ADD
	CONSTRAINT [DF__c_Procedu__last___5CBC5EFB]
	DEFAULT (dbo.get_client_datetime()) FOR [last_updated]
GO
ALTER TABLE [dbo].[c_Procedure]
	ADD
	CONSTRAINT [DF__c_Procedu__owner__4F6263DD]
	DEFAULT ((-1)) FOR [owner_id]
GO
ALTER TABLE [dbo].[c_Procedure]
	ADD
	CONSTRAINT [DF_c_Procedure_id]
	DEFAULT (newid()) FOR [id]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_c_Procedure_id]
	ON [dbo].[c_Procedure] ([id], [owner_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_c_Procedure_id_cpt_code]
	ON [dbo].[c_Procedure] ([cpt_code])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[c_Procedure] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Procedure] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Procedure] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Procedure] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Procedure] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Procedure] SET (LOCK_ESCALATION = TABLE)
GO

