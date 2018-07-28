CREATE FUNCTION fn_date_add_interval (
	@pdt_date datetime,
	@pl_interval_amount int,
	@ps_interval_unit varchar(24))

RETURNS datetime

AS
BEGIN

DECLARE @ldt_new_date datetime

IF @pl_interval_amount IS NULL
	SET @ldt_new_date = @pdt_date
ELSE
	SET @ldt_new_date = CASE LEFT(@ps_interval_unit, 3)
				WHEN 'YEA' THEN dateadd(year, @pl_interval_amount, @pdt_date)
				WHEN 'MON' THEN dateadd(month, @pl_interval_amount, @pdt_date)
				WHEN 'WEE' THEN dateadd(week, @pl_interval_amount, @pdt_date)
				WHEN 'DAY' THEN dateadd(day, @pl_interval_amount, @pdt_date)
				WHEN 'HOU' THEN dateadd(hour, @pl_interval_amount, @pdt_date)
				WHEN 'MIN' THEN dateadd(minute, @pl_interval_amount, @pdt_date)
				WHEN 'SEC' THEN dateadd(second, @pl_interval_amount, @pdt_date)
				ELSE @pdt_date
				END

RETURN @ldt_new_date 

END
