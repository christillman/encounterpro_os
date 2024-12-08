
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_Config_Object_Type]
Print 'Drop Table [dbo].[c_Config_Object_Type]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Config_Object_Type]') AND [type]='U'))
DROP TABLE [dbo].[c_Config_Object_Type]
GO
-- Create Table [dbo].[c_Config_Object_Type]
Print 'Create Table [dbo].[c_Config_Object_Type]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[c_Config_Object_Type] (
		[config_object_type]          [varchar](24) NOT NULL,
		[description]                 [varchar](80) NOT NULL,
		[base_table]                  [varchar](64) NOT NULL,
		[config_object_key]           [varchar](64) NOT NULL,
		[config_object_prefix]        [varchar](8) NOT NULL,
		[creator_xml_script_guid]     [uniqueidentifier] NULL,
		[creator_xml_script_id]       [int] NULL,
		[version_control]             [bit] NOT NULL,
		[created]                     [datetime] NOT NULL,
		[created_by]                  [varchar](24) NOT NULL,
		[configuration_service]       [varchar](24) NULL,
		[object_encoding_method]      [varchar](12) NULL,
		[auto_install_flag]           [bit] NOT NULL,
		[concurrent_install_flag]     [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Config_Object_Type]
	ADD
	CONSTRAINT [PK_c_Config_Object_Type]
	PRIMARY KEY
	CLUSTERED
	([config_object_type])
	WITH FILLFACTOR=70
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Config_Object_Type]
	ADD
	CONSTRAINT [DF__c_Config___auto___7581E3D7]
	DEFAULT ((1)) FOR [auto_install_flag]
GO
ALTER TABLE [dbo].[c_Config_Object_Type]
	ADD
	CONSTRAINT [DF__c_Config___concu__76760810]
	DEFAULT ((1)) FOR [concurrent_install_flag]
GO
ALTER TABLE [dbo].[c_Config_Object_Type]
	ADD
	CONSTRAINT [DF_c_Config_Object_Type_created]
	DEFAULT (dbo.get_client_datetime()) FOR [created]
GO
GRANT INSERT ON [dbo].[c_Config_Object_Type] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Config_Object_Type] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Config_Object_Type] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Config_Object_Type] SET (LOCK_ESCALATION = TABLE)
GO

