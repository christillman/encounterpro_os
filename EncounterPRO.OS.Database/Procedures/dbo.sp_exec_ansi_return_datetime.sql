
Print 'Drop Procedure [dbo].[sp_exec_ansi_return_datetime]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_exec_ansi_return_datetime]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_exec_ansi_return_datetime]
GO

Print 'Create Procedure [dbo].[sp_exec_ansi_return_datetime]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
create procedure sp_exec_ansi_return_datetime (@ps_sql varchar(4000))
AS BEGIN
-- wrapper to allow dynamic sql execution from powerbuilder
declare @sql nvarchar(4000)

set @sql = @ps_sql
exec sp_executesql @sql
--declare @dummy datetime = '2023-01-01'
--select @dummy

END
/*
exec sp_exec_ansi 'select 4 from c_1_record'
*/
GO

GRANT EXECUTE ON dbo.sp_exec_ansi_return_datetime TO cprsystem