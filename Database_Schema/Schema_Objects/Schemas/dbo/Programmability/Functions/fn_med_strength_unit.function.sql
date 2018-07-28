CREATE FUNCTION fn_med_strength_unit (
	@ps_administer_unit varchar(12),
	@pr_dose_amount real,
	@ps_dose_unit varchar(12)
	 )

RETURNS varchar(15)

AS
BEGIN
DECLARE @ls_med_strength_unit varchar(15),
		@ls_administer_unit_code varchar(15),
		@ls_dose_unit_code varchar(15)

-- Convert the admin unit.  Use the jmj value if no code lookup is found
SET @ls_administer_unit_code = dbo.fn_lookup_code('unit_id', @ps_administer_unit, 'med_strength_uom', 108)
IF @ls_administer_unit_code IS NULL
	SET @ls_administer_unit_code = @ps_administer_unit

-- Convert the dose unit.  Use the jmj value if no code lookup is found
SET @ls_dose_unit_code = dbo.fn_lookup_code('unit_id', @ps_dose_unit, 'med_strength_uom', 108)
IF @ls_dose_unit_code IS NULL
	SET @ls_dose_unit_code = @ps_dose_unit

-- By default, the strength unit is the admin unit
SET @ls_med_strength_unit = @ls_administer_unit_code

-- Build the composite unit of measure if the dose amount isn't 1
IF @pr_dose_amount <> 1
	SET @ls_med_strength_unit = @ls_med_strength_unit + '/' + CONVERT(varchar(8), @pr_dose_amount) + ' ' + @ls_dose_unit_code

RETURN @ls_med_strength_unit 

END
