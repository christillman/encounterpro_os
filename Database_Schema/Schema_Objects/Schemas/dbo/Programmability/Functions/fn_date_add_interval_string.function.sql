CREATE FUNCTION dbo.fn_date_add_interval_string (
	@pdt_date datetime,
	@ls_interval_string varchar(255)
	)

RETURNS datetime

AS
BEGIN

DECLARE @ldt_new_date datetime,
		@ls_interval_amount varchar(20),
		@ll_interval_amount int,
		@ls_interval_unit varchar(24)

IF CHARINDEX(' ', @ls_interval_string) <= 0
	RETURN @pdt_date

SET @ls_interval_amount = SUBSTRING(@ls_interval_string, 1, CHARINDEX(' ', @ls_interval_string) - 1)
IF LEN(@ls_interval_amount) <= 0
	RETURN @pdt_date
IF ISNUMERIC(@ls_interval_amount) <> 1
	RETURN @pdt_date

SET @ll_interval_amount = CAST(@ls_interval_amount AS INT)

SET @ls_interval_unit = LTRIM(RTRIM(SUBSTRING(@ls_interval_string, CHARINDEX(' ', @ls_interval_string) + 1, 255)))
IF LEN(@ls_interval_unit) <= 0
	RETURN @pdt_date

SET @ldt_new_date = dbo.fn_date_add_interval(@pdt_date, @ll_interval_amount, @ls_interval_unit)

RETURN @ldt_new_date 

END
