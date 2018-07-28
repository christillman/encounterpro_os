CREATE FUNCTION fn_cdc_growth_bmi (
	@ps_growth_class varchar(24),
	@pdt_date_of_birth datetime,
	@pdt_date_of_measure datetime,
	@ps_sex char(1),
	@ld_weight decimal(18, 6),
	@ls_weight_unit varchar(24),
	@ld_height decimal(18, 6),
	@ls_height_unit varchar(24)
	)

RETURNS decimal(18, 6)
AS

BEGIN

DECLARE @ld_percentile decimal(18, 6),
		@ld_weight_kg decimal(18, 6),
		@ld_height_cm decimal(18, 6),
		@ld_bmi decimal(18, 6),
		@ld_x decimal(18, 6),
		@ld_l decimal(18, 6),
		@ld_m decimal(18, 6),
		@ld_s decimal(18, 6),
		@ld_age decimal(18, 6),
		@ld_months1 decimal(18, 6),
		@ld_percentile1 decimal(18, 6),
		@ld_months2 decimal(18, 6),
		@ld_percentile2 decimal(18, 6),
		@li_sex smallint,
		@ll_days int,
		@ld_current_age_months decimal(18, 6)

SET @ld_percentile = NULL

IF @ps_sex = 'M'
	SET @li_sex = 1
ELSE
	SET @li_sex = 2

SET @ll_days = DATEDIFF(day, @pdt_date_of_birth, @pdt_date_of_measure)
SET @ld_current_age_months = CAST(@ll_days AS decimal(18, 6)) / 30.42

-- Make sure the weight is in KG
SET @ld_weight_kg = dbo.fn_convert_units(@ld_weight, @ls_weight_unit, 'KG')
IF @ld_weight_kg IS NULL OR @ld_weight_kg <= 0
	RETURN @ld_percentile

-- Make sure the height is in CM
SET @ld_height_cm = dbo.fn_convert_units(@ld_height, @ls_height_unit, 'CM')
IF @ld_height_cm IS NULL OR @ld_height_cm <= 0
	RETURN @ld_percentile

-- Calculate the BMI
SET @ld_bmi = 10000 * @ld_weight_kg / POWER(@ld_height_cm, 2)
IF @ld_bmi IS NULL OR @ld_bmi <= 0
	RETURN @ld_percentile


--Find the "Under" and "Over" months
SELECT @ld_months1 = max(months)
FROM c_CDC_BMIAge
WHERE sex = @li_sex
AND months <= @ld_current_age_months

SELECT @ld_months2 = min(months)
FROM c_CDC_BMIAge
WHERE sex = @li_sex
AND months >= @ld_current_age_months

-- If we don't have an under or over then return NULL
IF @ld_months1 IS NULL AND @ld_months2 IS NULL
	RETURN @ld_percentile

-- If we only have and "Over" then use it for both
IF @ld_months1 IS NULL AND @ld_months2 IS NOT NULL
	SET @ld_months1 = @ld_months2

-- If we only have and "Under" then use it for both
IF @ld_months1 IS NOT NULL AND @ld_months2 IS NULL
	SET @ld_months2 = @ld_months1

-- Get the LMS values for the "Under" month
SELECT 	@ld_l = l,
		@ld_m = m,
		@ld_s = s
FROM c_CDC_BMIAge
WHERE sex = @li_sex
AND months = @ld_months1

-- Get the percentile for the "Under" month
SET @ld_percentile1 = dbo.fn_cdc_lms_calc(@ld_bmi, @ld_l, @ld_m, @ld_s)

-- If  the "Under" is the same as the "Over" then we're done
IF @ld_months1 = @ld_months2
	RETURN @ld_percentile1

-- Get the LMS values for the "Over" month
SELECT 	@ld_l = l,
		@ld_m = m,
		@ld_s = s
FROM c_CDC_BMIAge
WHERE sex = @li_sex
AND months = @ld_months2

-- Get the percentile for the "Over" month
SET @ld_percentile2 = dbo.fn_cdc_lms_calc(@ld_bmi, @ld_l, @ld_m, @ld_s)

-- Interpolate between the "Over" and "Under"
SET @ld_percentile = dbo.fn_cdc_interpolate_percentile(@ld_current_age_months, @ld_months1, @ld_percentile1, @ld_months2, @ld_percentile2)

RETURN @ld_percentile
END

