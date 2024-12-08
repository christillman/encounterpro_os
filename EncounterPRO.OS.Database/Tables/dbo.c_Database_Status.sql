
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Table [dbo].[c_Database_Status]
Print 'Drop Table [dbo].[c_Database_Status]'

ALTER TABLE o_LOG DROP CONSTRAINT DF_o_log_log_date_time_21
DROP FUNCTION dbo.get_client_datetime

IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Database_Status]') AND [type]='U'))
DROP TABLE [dbo].[c_Database_Status]
GO
-- Create Table [dbo].[c_Database_Status]
Print 'Create Table [dbo].[c_Database_Status]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [c_Database_Status](
	[customer_id] [int] NOT NULL,
	[major_release] [int] NOT NULL,
	[database_version] [varchar](4) NOT NULL,
	[database_mode] [varchar](16) NOT NULL,
	[database_status] [varchar](12) NOT NULL,
	[database_id] [uniqueidentifier] NOT NULL,
	[master_configuration_date] [datetime] NULL,
	[modification_level] [int] NULL,
	[last_scripts_update] [datetime] NULL,
	[beta_flag] [bit] NOT NULL,
	[client_link] [varchar](500) NULL,
	[timezone] [varchar](40) NULL,
 CONSTRAINT [PK_c_Database_Status] PRIMARY KEY CLUSTERED 
(
	[customer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT DELETE ON [c_Database_Status] TO [cprsystem] AS [dbo]
GRANT INSERT ON [c_Database_Status] TO [cprsystem] AS [dbo]
GRANT REFERENCES ON [c_Database_Status] TO [cprsystem] AS [dbo]
GRANT SELECT ON [c_Database_Status] TO [cprsystem] AS [dbo]
GRANT UPDATE ON [c_Database_Status] TO [cprsystem] AS [dbo]
GRANT SELECT ON [c_Database_Status] TO [public] AS [dbo]
--GRANT UPDATE ON [c_Database_Status] TO [public] AS [dbo]
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DF_c_db_sts_status]') AND type = 'D')
BEGIN
ALTER TABLE [c_Database_Status] ADD  CONSTRAINT [DF_c_db_sts_status]  DEFAULT ('OK') FOR [database_status]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DF_c_db_sts_id]') AND type = 'D')
BEGIN
ALTER TABLE [c_Database_Status] ADD  CONSTRAINT [DF_c_db_sts_id]  DEFAULT (newid()) FOR [database_id]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DF_c_db_sts_beta_flag]') AND type = 'D')
BEGIN
ALTER TABLE [c_Database_Status] ADD  CONSTRAINT [DF_c_db_sts_beta_flag]  DEFAULT ((0)) FOR [beta_flag]
END

