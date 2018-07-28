CREATE PROCEDURE sp_count_who_came_office (
	@ps_office_id varchar(4),
	@pdt_date datetime,
	@pi_count smallint OUTPUT )
AS
DECLARE @ldt_today datetime,
	@ldt_tomorrow datetime

SELECT @ldt_today = convert(datetime, convert(varchar(10),@pdt_date, 101))

SELECT @ldt_tomorrow = DATEADD(day, 1, @ldt_today)

SELECT @pi_count = count(*)
FROM p_Patient_Encounter WITH (NOLOCK, INDEX (idx_encounter_date) )
WHERE encounter_date >= @ldt_today
AND encounter_date < @ldt_tomorrow
AND encounter_status = 'CLOSED'
AND ISNULL(patient_location, '<Null>') <> 'REMOTE'
AND office_id = @ps_office_id

