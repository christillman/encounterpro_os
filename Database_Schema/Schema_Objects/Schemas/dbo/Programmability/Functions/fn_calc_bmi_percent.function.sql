CREATE FUNCTION fn_calc_bmi_percent (
	@dec_bmi decimal(15,7)
	,@l1 decimal(9,7)
	,@m1 decimal(9,7)
	,@s1 decimal(9,7)
	,@ld_age decimal(9,3)
	,@ld_months1 decimal(9,3)
	,@ld_months2 decimal(9,3)
	,@l2 decimal(9,7)
	,@m2 decimal(9,2)
	,@s2 decimal(9,2)
	)
RETURNS decimal(19,3)

AS
BEGIN

DECLARE @b1 decimal(9,8),@b2 decimal(9,8),@b3 decimal(9,8),@b4 decimal(9,8),@b5 decimal(9,8)
DECLARE @ab decimal(9,8)
DECLARE @z  decimal(19,9)
DECLARE @k  decimal(19,9)
DECLARE @temp decimal(19,9)
DECLARE @ld_percentile1 decimal(19,9)
DECLARE @ld_percentile2 decimal(19,9)
DECLARE @ld_percentile_interpolated decimal(19,9)
Declare @calc_percent decimal(19,3)

SET @b1 = 0.31938153
SET @b2 = -0.356563782
SET @b3 = 1.781477937
SET @b4 = -1.821255978
SET @b5 = 1.330274429
SET @ab = 0.2316419

-- Find Z value
Set @z = (Power((@dec_bmi/@m1),@l1)) - 1
Set @z = @z/(@l1*@s1)

-- Find Percentile from Z value
Set @k = 1 / (1 + @ab * Abs(@z))
Set @temp = @b1 * @k + @b2 * Power(@k, 2) + @b3 * Power(@k,3) + @b4 * Power(@k,4) + @b5 * Power(@k,5)
Set @temp = 1 - (1 / SQRT(2 * PI())) * Exp(-Power((Abs(@z)),2) / 2) * @temp

If @z > 0 
BEGIN
	Set @ld_percentile1 =  @temp
END	
Else
BEGIN
	Set @ld_percentile1 =  1 - @temp
End 

if @ld_age = @ld_months1 
BEGIN
	Set @ld_percentile_interpolated = @ld_percentile1
END
else
BEGIN
	Set @z = (Power((@dec_bmi/@m2), @l2)) - 1
	Set @z = @z/(@l2*@s2)
	
-- Find Percentile from Z value
	Set @k = 1 / (1 + @ab * Abs(@z))
	Set @temp = @b1 * @k + @b2 * Power(@k, 2) + @b3 * Power(@k,3) + @b4 * Power(@k,4) + @b5 * Power(@k,5)
	Set @temp = 1 - (1 / SQRT(2 * PI())) * Exp(-Power((Abs(@z)),2) / 2) * @temp

	If @z > 0 
	BEGIN
		Set @ld_percentile2 =  @temp
	END
	Else
	BEGIN
		Set @ld_percentile2 =  1 - @temp
	End
	Set @ld_percentile_interpolated = @ld_percentile1 + ((@ld_age - @ld_months1) * (@ld_percentile2 - @ld_percentile1) / (@ld_months2 - @ld_months1) )
END

if @ld_percentile_interpolated IS NOT NULL 
BEGIN
	SET @calc_percent = Round((@ld_percentile_interpolated * 100),3)
END
RETURN @calc_percent

END


