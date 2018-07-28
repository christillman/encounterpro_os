CREATE FUNCTION fn_cdc_lms_calc (
	@pd_x decimal(18, 6),
	@pd_l decimal(18, 6),
	@pd_m decimal(18, 6),
	@pd_s decimal(18, 6)
	)

RETURNS decimal(18, 6)
AS

BEGIN
/*
Passed In Params
pd_x = measurement (metric)
pd_l = L value from CDC table
pd_m = M value from CDC table
pd_s = S value from CDC table
*/

DECLARE @z decimal(18, 6),
		@b1 decimal(18, 6),
		@b2 decimal(18, 6),
		@b3 decimal(18, 6),
		@b4 decimal(18, 6),
		@b5 decimal(18, 6),
		@ab decimal(18, 6),
		@k decimal(18, 6),
		@temp decimal(18, 6)

set @b1 = 0.31938153
set @b2 = -0.356563782
set @b3 = 1.781477937
set @b4 = -1.821255978
set @b5 = 1.330274429
set @ab = 0.2316419

-- Find Z value
IF @pd_l = 0
	BEGIN
	set @z = LOG(@pd_x / @pd_m) / @pd_s
	END
ELSE
	BEGIN
	set @z = POWER((@pd_x / @pd_m), @pd_l) - 1
	set @z = @z / (@pd_l * @pd_s)
	END

-- Find Percentile from Z value
set @k = 1 / (1 + @ab * ABS(@z))
set @temp = (@b1 * @k) + (@b2 * POWER(@k, 2)) + (@b3 * POWER(@k, 3)) + (@b4 * POWER(@k, 4)) + (@b5 * POWER(@k, 5))
set @temp = 1 - ((1 / SQRT(2 * Pi())) * EXP(-POWER(ABS(@z), 2) / 2) * @temp )


IF @z > 0
	return @temp

return (1 - @temp)

END

