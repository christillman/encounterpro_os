CREATE FUNCTION fn_day_from_datetime (
	@pdt_datetime datetime )

RETURNS datetime

AS
BEGIN
DECLARE @ldt_day_only datetime

SET @ldt_day_only = CAST(convert(varchar(10),@pdt_datetime, 101) AS datetime) 

RETURN @ldt_day_only 

END
