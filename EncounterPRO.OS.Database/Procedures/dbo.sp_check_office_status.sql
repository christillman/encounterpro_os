

SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_check_office_status]
Print 'Drop Procedure [dbo].[sp_check_office_status]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_check_office_status]') AND [type]='P'))
DROP PROCEDURE [dbo].sp_check_office_status
GO

-- Create Procedure [dbo].[sp_check_office_status]
Print 'Create Procedure [dbo].[sp_check_office_status]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.sp_check_office_status 
AS

DECLARE @server_start datetime2
SELECT  @server_start = sqlserver_start_time  from sys.dm_os_sys_info

SELECT t.name AS TableName,
	max(IsNull(last_user_update,  @server_start)) as last_updated
FROM sys.tables t 
left join sys.dm_db_index_usage_stats s on OBJECT_NAME(s.OBJECT_ID) = t.name
WHERE t.name in ('o_Rooms','p_Patient_Encounter','p_Patient_WP_Item','o_Active_Services','c_Table_Update')
GROUP BY t.name
ORDER BY t.name

GO
GRANT EXECUTE
	ON [dbo].sp_check_office_status
	TO [cprsystem] AS dbo
GO
-- required to use sys.dm_db_index_usage_stats
GRANT VIEW DATABASE PERFORMANCE STATE TO cprsystem AS dbo
