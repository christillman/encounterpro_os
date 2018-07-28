CREATE FUNCTION fn_cdc_growth_head_circumference (
	@ps_growth_class varchar(24),
	@pdt_date_of_birth datetime,
	@pdt_date_of_measure datetime,
	@ps_sex char(1),
	@ld_head_circumference decimal,
	@ls_head_circumference_unit varchar(24)
	)

RETURNS decimal(18, 6)
AS

BEGIN

DECLARE @ld_percentile decimal



RETURN @ld_percentile
END

