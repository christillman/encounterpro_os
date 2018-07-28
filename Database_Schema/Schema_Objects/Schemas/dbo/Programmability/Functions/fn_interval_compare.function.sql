CREATE FUNCTION fn_interval_compare (
	@pl_interval_amount int,
	@ps_interval_unit varchar(24),
	@pdt_begin_date datetime,
	@pdt_end_date datetime)

RETURNS int

AS
BEGIN

DECLARE @ll_result int,
		@ldt_interval_end datetime

-- Clear out any time values
SET @pdt_begin_date = convert(datetime, convert(varchar,@pdt_begin_date, 112))
SET @pdt_end_date = convert(datetime, convert(varchar,@pdt_end_date, 112))

SET @ldt_interval_end = dbo.fn_date_add_interval(@pdt_begin_date, @pl_interval_amount, @ps_interval_unit)

IF @pdt_end_date < @ldt_interval_end
	SET @ll_result = -1

IF @pdt_end_date = @ldt_interval_end
	SET @ll_result = 0

IF @pdt_end_date > @ldt_interval_end
	SET @ll_result = 1



RETURN @ll_result 

END
