CREATE FUNCTION fn_cdc_growth_weight_vs_length (
	@ps_growth_class varchar(24),
	@pdt_date_of_birth datetime,
	@pdt_date_of_measure datetime,
	@ps_sex char(1),
	@ld_weight decimal,
	@ls_weight_unit varchar(24),
	@ld_height decimal,
	@ls_height_unit varchar(24)
	)

RETURNS decimal
AS

BEGIN

DECLARE @ld_percentile decimal



RETURN @ld_percentile
END

