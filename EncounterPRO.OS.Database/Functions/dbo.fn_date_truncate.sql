
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_date_truncate]
Print 'Drop Function [dbo].[fn_date_truncate]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_date_truncate]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_date_truncate]
GO

-- Create Function [dbo].[fn_date_truncate]
Print 'Create Function [dbo].[fn_date_truncate]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_date_truncate (
	@pdt_datetime datetime,
	@ps_truncate_unit varchar(24) )
RETURNS datetime

AS
BEGIN

DECLARE @ldt_truncated datetime,
		@ll_dow int

IF @ps_truncate_unit = 'YEAR'
	BEGIN
	SET @ldt_truncated = DATEADD(YEAR, DATEDIFF(YEAR, 0, CAST(@pdt_datetime AS DATETIME2(0))), 0)
	END

IF @ps_truncate_unit = 'MONTH'
	BEGIN
	SET @ldt_truncated = DATEADD(MONTH, DATEDIFF(MONTH, 0, CAST(@pdt_datetime AS DATETIME2(0))), 0)
	END

IF @ps_truncate_unit = 'WEEK'
	BEGIN
	SET @ll_dow = DATEPART(dw, @pdt_datetime) - 1
	SET @ldt_truncated = convert(datetime, convert(varchar,@pdt_datetime, 112))
	SET @ldt_truncated = DATEADD(d, -@ll_dow, @ldt_truncated)
	END

IF @ps_truncate_unit = 'DAY'
	BEGIN
	SET @ldt_truncated = DATEADD(day, DATEDIFF(day, 0, CAST(@pdt_datetime AS DATETIME2(0))), 0)
	END

IF @ps_truncate_unit = 'HOUR'
	BEGIN
	SET @ldt_truncated = DATEADD(HOUR, DATEDIFF(HOUR, 0, CAST(@pdt_datetime AS DATETIME2(0))), 0)
	END

IF @ps_truncate_unit = 'MINUTE'
	BEGIN
	SET @ldt_truncated = DATEADD(MINUTE, DATEDIFF(MINUTE, 0, CAST(@pdt_datetime AS DATETIME2(0))), 0)
	END

RETURN @ldt_truncated

END


GO
GRANT EXECUTE
	ON [dbo].[fn_date_truncate]
	TO [cprsystem]
GO

