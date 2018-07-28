CREATE FUNCTION fn_age_months (
	@pdt_date_of_birth datetime,
	@pdt_current_date datetime)

RETURNS varchar(12)

AS
BEGIN
DECLARE @ll_age_months int,
		@ll_year1 int,
		@ll_month1 int,
		@ll_day1 int,
		@ll_year2 int,
		@ll_month2 int,
		@ll_day2 int,
		@ll_months int


-- Don't do negative ages
if @pdt_current_date < @pdt_date_of_birth
	RETURN 0

-- Get the month and day values
SET @ll_year1 = DATEPART(year, @pdt_date_of_birth)
SET @ll_month1 = DATEPART(month, @pdt_date_of_birth)
SET @ll_day1 = DATEPART(day, @pdt_date_of_birth)

SET @ll_year2 = DATEPART(year, @pdt_current_date)
SET @ll_month2 = DATEPART(month, @pdt_current_date)
SET @ll_day2 = DATEPART(day, @pdt_current_date)

-- Start by multiplying the year difference by 12
SET @ll_months = (@ll_year2 - @ll_year1) * 12

-- The add (or subtract) the month difference
SET @ll_months = @ll_months + (@ll_month2 - @ll_month1)

-- Finally, check to see if the last month counts
-- If we haven't reached the birth day yet, then subtract one month
IF @ll_day2 < @ll_day1
	SET @ll_months = @ll_months - 1

RETURN @ll_months

END

