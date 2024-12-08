
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_Authority_Formulary]
Print 'Drop Table [dbo].[c_Authority_Formulary]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Authority_Formulary]') AND [type]='U'))
DROP TABLE [dbo].[c_Authority_Formulary]
GO
-- Create Table [dbo].[c_Authority_Formulary]
Print 'Create Table [dbo].[c_Authority_Formulary]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[c_Authority_Formulary] (
		[authority_formulary_id]           [int] IDENTITY(1, 1) NOT NULL,
		[authority_id]                     [varchar](24) NOT NULL,
		[authority_formulary_sequence]     [int] NOT NULL,
		[icd_9_code] [varchar](12) NULL,
		[treatment_type]                   [varchar](24) NOT NULL,
		[treatment_key]                    [varchar](40) NOT NULL,
		[formulary_code]                   [varchar](24) NOT NULL,
		[icd10_code]                       [varchar](12) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Authority_Formulary]
	ADD
	CONSTRAINT [PK_c_Authority_Formulary]
	PRIMARY KEY
	CLUSTERED
	([authority_id], [authority_formulary_id])
	WITH FILLFACTOR=100
	ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_authority_formulary_sequence]
	ON [dbo].[c_Authority_Formulary] ([authority_formulary_sequence])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 100) ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[c_Authority_Formulary] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Authority_Formulary] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Authority_Formulary] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Authority_Formulary] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Authority_Formulary] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Authority_Formulary] SET (LOCK_ESCALATION = TABLE)
GO

