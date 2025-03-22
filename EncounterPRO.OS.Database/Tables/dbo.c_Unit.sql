
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_Unit]
Print 'Drop Table [dbo].[c_Unit]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Unit]') AND [type]='U'))
DROP TABLE [dbo].[c_Unit]
GO
-- Create Table [dbo].[c_Unit]
Print 'Create Table [dbo].[c_Unit]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[c_Unit] (
		[unit_id]                       [varchar](30) NOT NULL,
		[description]                   [varchar](40) NULL,
		[unit_type]                     [varchar](12) NULL,
		[pretty_fraction]               [varchar](12) NULL,
		[plural_flag]                   [varchar](1) NULL,
		[print_unit]                    [char](1) NULL,
		[abbreviation]                  [varchar](8) NULL,
		[id]                            [uniqueidentifier] NOT NULL,
		[display_mask]                  [varchar](40) NULL,
		[prefix]                        [varchar](12) NULL,
		[major_unit_display_suffix]     [varchar](24) NULL,
		[minor_unit_display_suffix]     [varchar](24) NULL,
		[major_unit_input_suffixes]     [varchar](24) NULL,
		[minor_unit_input_suffixes]     [varchar](24) NULL,
		[multiplier]                    [int] NULL,
		[display_minor_units]           [char](1) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Unit]
	ADD
	CONSTRAINT [PK_c_Unit_1__10]
	PRIMARY KEY
	CLUSTERED
	([unit_id])
	WITH FILLFACTOR=100
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Unit]
	ADD
	CONSTRAINT [DF__c_Unit__id__1A1FD08D]
	DEFAULT (newid()) FOR [id]
GO
GRANT DELETE ON [dbo].[c_Unit] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Unit] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Unit] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Unit] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Unit] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Unit] SET (LOCK_ESCALATION = TABLE)
GO

