CREATE PROCEDURE sp_get_checkin_errors (
	@pdt_date datetime
)
AS

DECLARE	 @ldt_today datetime
	,@ldt_tomorrow datetime

SET @ldt_today = convert(datetime, convert(varchar,@pdt_date, 112))

SET @ldt_tomorrow = DATEADD(day, 1, @ldt_today)

SELECT DISTINCT
	p.billing_id,
	p.last_name,
	p.first_name,
	p.date_of_birth,
	l.comments
FROM o_Message_Log l
INNER JOIN p_Patient p WITH (NOLOCK)
ON p.cpr_id = l.cpr_id
WHERE l.message_date_time >= @ldt_today
AND l.message_date_time < @ldt_tomorrow
AND l.comments is not NULL


