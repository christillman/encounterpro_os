
Print 'Drop Procedure [dbo].[sp_exec_ansi_return_number]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_exec_ansi_return_number]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_exec_ansi_return_number]
GO

Print 'Create Procedure [dbo].[sp_exec_ansi_return_number]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
create procedure sp_exec_ansi_return_number (@ps_sql nvarchar(max))
AS BEGIN
-- wrapper to allow dynamic sql execution from powerbuilder
declare @sql nvarchar(max)

set @sql = @ps_sql
exec sp_executesql @sql

END
/*
exec sp_exec_ansi 'select 4 from c_1_record'
*/
GO

GRANT EXECUTE ON dbo.sp_exec_ansi_return_number TO cprsystem