
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_Assessment_Definition]
Print 'Drop Table [dbo].[c_Assessment_Definition]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Assessment_Definition]') AND [type]='U'))
DROP TABLE [dbo].[c_Assessment_Definition]
GO
-- Create Table [dbo].[c_Assessment_Definition]
Print 'Create Table [dbo].[c_Assessment_Definition]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[c_Assessment_Definition] (
		[assessment_id]                           [varchar](24) NOT NULL,
		[assessment_type]                         [varchar](24) NULL,
		[assessment_category_id]                  [varchar](24) NULL,
		[description]                             [varchar](80) NULL,
		[long_description]                        [nvarchar](max) NULL,
		[location_domain]                         [varchar](12) NULL,
		[icd_9_code]                              [varchar](12) NULL,
		[billing_code]                            [int] NULL,
		[billing_id]                              [varchar](24) NULL,
		[risk_level]                              [int] NULL,
		[complexity]                              [int] NULL,
		[status]                                  [varchar](12) NULL,
		[auto_close]                              [char](1) NULL,
		[auto_close_interval_amount]              [smallint] NULL,
		[auto_close_interval_unit]                [varchar](24) NULL,
		[id]                                      [uniqueidentifier] NOT NULL,
		[owner_id]                                [int] NOT NULL,
		[last_updated]                            [datetime] NOT NULL,
		[definition]                              [varchar](80) NULL,
		[original_icd_9_code]                     [varchar](12) NULL,
		[acuteness]                               [varchar](24) NULL,
		[patient_reference_material_id]           [int] NULL,
		[provider_reference_material_id]          [int] NULL,
		[clinically_relevant_interval_amount]     [int] NULL,
		[clinically_relevant_interval_unit]       [varchar](24) NULL,
		[icd10_code]                               [varchar](12) NULL,
		[source]                               [varchar](12) NULL,
		[icd10_who_code]                               [varchar](12) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Assessment_Definition]
	ADD
	CONSTRAINT [PK_c_Assessment_Definition_40]
	PRIMARY KEY
	CLUSTERED
	([assessment_id])
	WITH FILLFACTOR=90
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Assessment_Definition]
	ADD
	CONSTRAINT [DF__c_Assessm__last___5BC83AC2]
	DEFAULT (dbo.get_client_datetime()) FOR [last_updated]
GO
ALTER TABLE [dbo].[c_Assessment_Definition]
	ADD
	CONSTRAINT [DF__c_Assessm__owner__4E6E3FA4]
	DEFAULT ((-1)) FOR [owner_id]
GO
ALTER TABLE [dbo].[c_Assessment_Definition]
	ADD
	CONSTRAINT [DF__c_Assessm__statu__240AC428]
	DEFAULT ('OK') FOR [status]
GO
ALTER TABLE [dbo].[c_Assessment_Definition]
	ADD
	CONSTRAINT [DF__c_Assessment__id__24FEE861]
	DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[c_Assessment_Definition]
	ADD
	CONSTRAINT [DF__c_Assessment_def_acuteness]
	DEFAULT ('Acute') FOR [acuteness]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_c_Assessment_Definition_id]
	ON [dbo].[c_Assessment_Definition] ([id], [owner_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[c_Assessment_Definition] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Assessment_Definition] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Assessment_Definition] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Assessment_Definition] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Assessment_Definition] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Assessment_Definition] SET (LOCK_ESCALATION = TABLE)
GO

