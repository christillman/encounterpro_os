
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_Package]
Print 'Drop Table [dbo].[c_Package]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Package]') AND [type]='U'))
DROP TABLE [dbo].[c_Package]
GO
-- Create Table [dbo].[c_Package]
Print 'Create Table [dbo].[c_Package]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[c_Package] (
		[package_id]              [varchar](24) NOT NULL,
		[administer_method]       [varchar](30) NULL,
		[description]             [varchar](600) NULL,
		[administer_unit]         [varchar](20) NULL,
		[dose_unit]               [varchar](20) NULL,
		[administer_per_dose]     [real] NULL,
		[dosage_form]             [varchar](24) NULL,
		[dose_amount]             [real] NULL,
		[status]                  [varchar](12) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Package]
	ADD
	CONSTRAINT [PK_c_Package_21]
	PRIMARY KEY
	CLUSTERED
	([package_id])
	WITH FILLFACTOR=100
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Package]
	ADD
	CONSTRAINT [DF__c_Package_status_40]
	DEFAULT ('OK') FOR [status]
GO
GRANT DELETE ON [dbo].[c_Package] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Package] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Package] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Package] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Package] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Package] SET (LOCK_ESCALATION = TABLE)
GO

