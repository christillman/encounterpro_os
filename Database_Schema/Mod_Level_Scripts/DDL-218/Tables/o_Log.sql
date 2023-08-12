


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER TABLE [dbo].[o_Log] DROP CONSTRAINT IF EXISTS [DF__o_Log__id__6FD627B4]
GO

ALTER TABLE [dbo].[o_Log] DROP COLUMN IF EXISTS [id]
GO

ALTER TABLE [dbo].[o_Log] DROP COLUMN IF EXISTS [caused_by_id]
GO

if not exists (select * from sys.columns 
	where object_id = object_id('o_Log') 
	and name = 'progress_seconds')
ALTER TABLE [dbo].[o_Log] ADD progress_seconds numeric(18,4) NULL
GO

ALTER TABLE [dbo].[o_Log] ALTER COLUMN caller varchar(255) NULL
GO

ALTER TABLE [dbo].[o_Log] ALTER COLUMN script varchar(255) NULL
GO

ALTER TABLE [dbo].[o_Log] ALTER COLUMN computername varchar(255) NULL
GO

ALTER TABLE [dbo].[o_Log] ALTER COLUMN windows_logon_id varchar(255) NULL
GO

ALTER TABLE [dbo].[o_Log] ALTER COLUMN cpr_id varchar(255) NULL
GO

ALTER TABLE [dbo].[o_Log] ALTER COLUMN program varchar(255) NULL
GO

ALTER TABLE [dbo].[o_Log] ALTER COLUMN cleared_by varchar(255) NULL
GO

ALTER TABLE [dbo].[o_Log] ALTER COLUMN sql_version varchar(255) NULL
GO

-- Because o_LOg is used in the upgrade process, we need to close out 
-- the transaction now and begin a new one

commit transaction
begin transaction


