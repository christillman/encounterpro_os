CREATE FUNCTION fn_pretty_age (
	@pdt_date_of_birth datetime,
	@pdt_current_date datetime)

RETURNS varchar(12)

AS
BEGIN
DECLARE @ls_pretty_age varchar(12),
		@ll_age int,
		@ll_months int

SET @ll_months = dbo.fn_age_months(@pdt_date_of_birth, @pdt_current_date)

IF @ll_months >= 36
	BEGIN
	-- Show years
	SET @ls_pretty_age = CAST((@ll_months / 12) AS varchar(8)) + ' Years'
	END
ELSE IF DATEADD(week, 8, @pdt_date_of_birth) < @pdt_current_date
	BEGIN
	-- Show months
	SET @ls_pretty_age = CAST(@ll_months AS varchar(8)) + ' Months'
	END
ELSE IF DATEADD(day, 7, @pdt_date_of_birth) < @pdt_current_date
	BEGIN
	-- Show weeks
	SET @ll_age = DATEDIFF(week, @pdt_date_of_birth, @pdt_current_date)
	SET @ls_pretty_age = CAST(@ll_age AS varchar(8)) + ' Week'
	IF @ll_age <> 1
		SET @ls_pretty_age = @ls_pretty_age + 's'
	END
ELSE
	BEGIN
	-- Show days
	SET @ll_age = DATEDIFF(day, @pdt_date_of_birth, @pdt_current_date)
	SET @ls_pretty_age = CAST(@ll_age AS varchar(8)) + ' Day'
	IF @ll_age <> 1
		SET @ls_pretty_age = @ls_pretty_age + 's'
	END

RETURN @ls_pretty_age 

END

