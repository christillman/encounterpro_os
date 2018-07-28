CREATE FUNCTION fn_cdc_interpolate_percentile (
	@pd_age decimal(18, 6),
	@pd_months1 decimal(18, 6),
	@pd_percentile1 decimal(18, 6),
	@pd_months2 decimal(18, 6),
	@pd_percentile2 decimal(18, 6)
	)

RETURNS decimal(18, 6)
AS

BEGIN

DECLARE @ld_percentile_interpolated decimal(18, 6)

IF @pd_age = @pd_months1
	SET @ld_percentile_interpolated = @pd_percentile1
ELSE
	SET @ld_percentile_interpolated = @pd_percentile1 + ((@pd_age - @pd_months1) * (@pd_percentile2 - @pd_percentile1) / (@pd_months2 - @pd_months1) )

RETURN @ld_percentile_interpolated

END

