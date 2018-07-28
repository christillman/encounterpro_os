CREATE FUNCTION dbo.fn_age_fields (
	@pdt_from_date datetime,
	@pdt_to_date datetime)

RETURNS @age_fields TABLE (
	pretty_age varchar(12) NULL,
	pretty_age_amount int NULL,
	pretty_age_unit varchar(12) NULL,
	age_years int NULL,
	age_months int NULL,
	age_days int NULL,
	age_total_months int NULL,
	age_total_days int NULL
	)
AS
BEGIN
DECLARE @ls_pretty_age varchar(12),
		@ll_pretty_age_amount int,
		@ls_pretty_age_unit varchar(12),
		@ll_age_years int ,
		@ll_age_months int ,
		@ll_age_days int ,
		@ll_age_total_months int ,
		@ll_age_total_days int 

SET @ll_age_total_days = DATEDIFF(day, @pdt_from_date, @pdt_to_date)
SET @ll_age_total_months = dbo.fn_age_months(@pdt_from_date, @pdt_to_date)
SET @ll_age_years = @ll_age_total_months / 12

SET @ll_age_months = @ll_age_total_months - (@ll_age_years * 12)
SET @ll_age_days = DATEDIFF(day, DATEADD(month, @ll_age_total_months, @pdt_from_date), @pdt_to_date)

IF @ll_age_total_months >= 36
	BEGIN
	-- Show years
	SET @ll_pretty_age_amount = @ll_age_years
	SET @ls_pretty_age_unit = 'Year'
	END
ELSE IF @ll_age_total_months >= 2
	BEGIN
	-- Show months
	SET @ll_pretty_age_amount = @ll_age_total_months
	SET @ls_pretty_age_unit = 'Month'
	END
ELSE IF @ll_age_total_days >= 7
	BEGIN
	-- Show weeks
	SET @ll_pretty_age_amount = @ll_age_total_days / 7
	SET @ls_pretty_age_unit = 'Week'
	END
ELSE
	BEGIN
	-- Show days
	SET @ll_pretty_age_amount = @ll_age_total_days
	SET @ls_pretty_age_unit = 'Day'
	END

SET @ls_pretty_age = CAST(@ll_pretty_age_amount AS varchar(8)) + ' ' + @ls_pretty_age_unit
IF @ll_pretty_age_amount <> 1
	SET @ls_pretty_age = @ls_pretty_age + 's'

INSERT INTO @age_fields (
	pretty_age,
	pretty_age_amount,
	pretty_age_unit,
	age_years ,
	age_months ,
	age_days ,
	age_total_months ,
	age_total_days  
	)
VALUES (
	@ls_pretty_age,
	@ll_pretty_age_amount,
	@ls_pretty_age_unit,
	@ll_age_years ,
	@ll_age_months ,
	@ll_age_days ,
	@ll_age_total_months ,
	@ll_age_total_days  
	)


RETURN

END

