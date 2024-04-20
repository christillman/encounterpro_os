
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_day_from_datetime]
Print 'Drop Function [dbo].[fn_day_from_datetime]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_day_from_datetime]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_day_from_datetime]
GO

-- Create Function [dbo].[fn_day_from_datetime]
Print 'Create Function [dbo].[fn_day_from_datetime]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_day_from_datetime (
	@pdt_datetime datetime )

RETURNS datetime

AS
BEGIN
DECLARE @ldt_day_only datetime

SET @ldt_day_only = CAST(convert(varchar(10),@pdt_datetime, 101) AS datetime) 

RETURN @ldt_day_only 

END
GO
GRANT EXECUTE
	ON [dbo].[fn_day_from_datetime]
	TO [public]
GO

