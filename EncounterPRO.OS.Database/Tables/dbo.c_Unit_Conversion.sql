
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_Unit_Conversion]
Print 'Drop Table [dbo].[c_Unit_Conversion]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Unit_Conversion]') AND [type]='U'))
DROP TABLE [dbo].[c_Unit_Conversion]
GO
-- Create Table [dbo].[c_Unit_Conversion]
Print 'Create Table [dbo].[c_Unit_Conversion]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[c_Unit_Conversion] (
		[unit_from]                 [varchar](30) NOT NULL,
		[unit_to]                   [varchar](30) NOT NULL,
		[conversion_factor]         [real] NULL,
		[conversion_difference]     [real] NULL,
		[unit_from_metric_flag]     [char](1) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Unit_Conversion]
	ADD
	CONSTRAINT [PK_c_Unit_Conversion_1__10]
	PRIMARY KEY
	CLUSTERED
	([unit_from], [unit_to])
	WITH FILLFACTOR=100
	ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[c_Unit_Conversion] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Unit_Conversion] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Unit_Conversion] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Unit_Conversion] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Unit_Conversion] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Unit_Conversion] SET (LOCK_ESCALATION = TABLE)
GO

