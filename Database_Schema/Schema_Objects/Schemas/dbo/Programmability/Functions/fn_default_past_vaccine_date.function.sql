CREATE FUNCTION fn_default_past_vaccine_date (
	@ps_cpr_id varchar(12),
	@pdt_today datetime)

RETURNS datetime
AS

BEGIN

DECLARE @ldt_vaccine_datetime datetime,
		@ldt_today datetime,
		@ll_treatment_id int

SET @ldt_today = dbo.fn_date_truncate(@pdt_today, 'DAY')

-- Get the last past vaccine recorded today
SELECT @ll_treatment_id = max(treatment_id)
FROM p_Treatment_Item
WHERE cpr_id = @ps_cpr_id
AND treatment_type = 'IMMUNIZATION'
AND created >= @ldt_today
AND begin_date < @ldt_today

IF @ll_treatment_id > 0
	SELECT @ldt_vaccine_datetime = begin_date
	FROM p_Treatment_Item
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @ll_treatment_id
ELSE
	SET @ldt_vaccine_datetime = @ldt_today

RETURN @ldt_vaccine_datetime
END

