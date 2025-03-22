
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_Drug_Package]
Print 'Drop Table [dbo].[c_Drug_Package]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Drug_Package]') AND [type]='U'))
DROP TABLE [dbo].[c_Drug_Package]
GO
-- Create Table [dbo].[c_Drug_Package]
Print 'Create Table [dbo].[c_Drug_Package]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[c_Drug_Package] (
		[drug_id]                     [varchar](24) NOT NULL,
		[package_id]                  [varchar](24) NOT NULL,
		[sort_order]                  [smallint] NULL,
		[prescription_flag]           [varchar](1) NULL,
		[default_dispense_amount]     [real] NULL,
		[default_dispense_unit]       [varchar](15) NULL,
		[take_as_directed]            [char](1) NULL,
		[hcpcs_procedure_id]          [varchar](24) NULL,
	[form_rxcui] [varchar](20) NULL,
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Drug_Package]
	ADD
	CONSTRAINT [PK_c_Drug_Package_1__10]
	PRIMARY KEY
	CLUSTERED
	([drug_id], [package_id])
	WITH FILLFACTOR=100
	ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[c_Drug_Package] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Drug_Package] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Drug_Package] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Drug_Package] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Drug_Package] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Drug_Package] SET (LOCK_ESCALATION = TABLE)
GO

