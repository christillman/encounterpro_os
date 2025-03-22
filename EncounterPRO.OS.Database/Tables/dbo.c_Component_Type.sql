
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_Component_Type]
Print 'Drop Table [dbo].[c_Component_Type]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Component_Type]') AND [type]='U'))
DROP TABLE [dbo].[c_Component_Type]
GO
-- Create Table [dbo].[c_Component_Type]
Print 'Create Table [dbo].[c_Component_Type]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[c_Component_Type] (
		[component_type]              [varchar](24) NOT NULL,
		[description]                 [varchar](80) NULL,
		[base_class]                  [varchar](128) NULL,
		[component_wrapper_class]     [varchar](255) NULL,
		[status]                      [varchar](12) NOT NULL,
		[component_selection]         [varchar](24) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Component_Type]
	ADD
	CONSTRAINT [PK___1__18]
	PRIMARY KEY
	CLUSTERED
	([component_type])
	WITH FILLFACTOR=100
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Component_Type]
	ADD
	CONSTRAINT [DF_c_Component_Type_component_selection]
	DEFAULT ('Any') FOR [component_selection]
GO
ALTER TABLE [dbo].[c_Component_Type]
	ADD
	CONSTRAINT [DF_c_Component_Type_status]
	DEFAULT ('OK') FOR [status]
GO
GRANT DELETE ON [dbo].[c_Component_Type] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Component_Type] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Component_Type] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Component_Type] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Component_Type] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Component_Type] SET (LOCK_ESCALATION = TABLE)
GO

