CREATE FUNCTION fn_date_truncate (
	@pdt_datetime datetime,
	@ps_truncate_unit varchar(24) )
RETURNS datetime

AS
BEGIN

DECLARE @ldt_truncated datetime,
		@ll_dow int


IF @ps_truncate_unit = 'YEAR'
	BEGIN
	SET @ldt_truncated = convert(datetime, convert(varchar(4),@pdt_datetime, 112) + '0101')
	END

IF @ps_truncate_unit = 'MONTH'
	BEGIN
	SET @ldt_truncated = convert(datetime, convert(varchar(6),@pdt_datetime, 112) + '01')
	END

IF @ps_truncate_unit = 'WEEK'
	BEGIN
	SET @ll_dow = DATEPART(dw, @pdt_datetime) - 1
	SET @ldt_truncated = convert(datetime, convert(varchar,@pdt_datetime, 112))
	SET @ldt_truncated = DATEADD(d, -@ll_dow, @ldt_truncated)
	END

IF @ps_truncate_unit = 'DAY'
	BEGIN
	SET @ldt_truncated = convert(datetime, convert(varchar,@pdt_datetime, 112))
	END

IF @ps_truncate_unit = 'HOUR'
	BEGIN
	SET @ldt_truncated = convert(datetime, convert(varchar,@pdt_datetime, 112)) + convert(datetime, convert(varchar(2),@pdt_datetime, 8) + ':00:00')
	END

IF @ps_truncate_unit = 'MINUTE'
	BEGIN
	SET @ldt_truncated = convert(datetime, convert(varchar,@pdt_datetime, 112)) + convert(datetime, convert(varchar(5),@pdt_datetime, 8) + ':00')
	END

RETURN @ldt_truncated

END


