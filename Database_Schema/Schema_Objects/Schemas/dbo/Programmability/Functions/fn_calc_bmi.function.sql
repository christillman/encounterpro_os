CREATE FUNCTION fn_calc_bmi (
	@ps_cpr_id varchar(12)
	)
RETURNS decimal(9,3)

AS
BEGIN

DECLARE @ld_bmi decimal(9,3)

SET @ld_bmi = NULL

SELECT TOP 1 @ld_bmi = bmi
FROM dbo.fn_patient_bmi(@ps_cpr_id)
ORDER BY result_day desc


RETURN @ld_bmi

END


