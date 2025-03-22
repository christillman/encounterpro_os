
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_Drug_Administration]
Print 'Drop Table [dbo].[c_Drug_Administration]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Drug_Administration]') AND [type]='U'))
DROP TABLE [dbo].[c_Drug_Administration]
GO
-- Create Table [dbo].[c_Drug_Administration]
Print 'Create Table [dbo].[c_Drug_Administration]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[c_Drug_Administration] (
		[drug_id]                     [varchar](24) NOT NULL,
		[administration_sequence]     [smallint] NOT NULL,
		[administer_frequency]        [varchar](12) NULL,
		[administer_unit]             [varchar](12) NULL,
		[administer_amount]           [real] NULL,
		[mult_by_what]                [varchar](12) NULL,
		[calc_per]                    [varchar](12) NULL,
		[description]                 [varchar](40) NULL,
		[special_instructions]        [varchar](160) NULL,
	[form_rxcui] [varchar](20) NULL

) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Drug_Administration]
	ADD
	CONSTRAINT [PK_c_Drug_Administration_1__10]
	PRIMARY KEY
	CLUSTERED
	([drug_id], [administration_sequence])
	WITH FILLFACTOR=100
	ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[c_Drug_Administration] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Drug_Administration] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Drug_Administration] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Drug_Administration] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Drug_Administration] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Drug_Administration] SET (LOCK_ESCALATION = TABLE)
GO

