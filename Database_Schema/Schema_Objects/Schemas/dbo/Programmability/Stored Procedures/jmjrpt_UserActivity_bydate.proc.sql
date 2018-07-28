



CREATE PROCEDURE jmjrpt_UserActivity_bydate (
	@ps_user_id varchar(24),
	@ps_encounter_date varchar(10)
	)
AS

DECLARE @ldt_encounter_date_from datetime,
		@ldt_encounter_date_to datetime

IF ISDATE(@ps_encounter_date) < 1
	RETURN

SET @ldt_encounter_date_from = CAST(@ps_encounter_date AS datetime)
SET @ldt_encounter_date_to = DATEADD(day, 1, @ldt_encounter_date_from)

SELECT	pi.description AS Service,
		dbo.fn_pretty_name(p.last_name
							,p.first_name
							,p.middle_name
							,p.name_suffix
							,p.name_prefix
							,p.degree
							) as patient_name,
		pp.progress_type,
		pp.created
FROM p_Patient_WP_Item_Progress pp (NOLOCK)
	INNER JOIN p_Patient_WP_Item pi
	ON pp.patient_workplan_item_id = pi.patient_workplan_item_id
	INNER JOIN c_user cu (NOLOCK)
	ON pp.user_id = cu.user_id
	INNER JOIN p_Patient p
	ON pp.cpr_id = p.cpr_id
WHERE pp.user_id = @ps_user_id
AND pp.created >= @ldt_encounter_date_from
AND pp.created <= @ldt_encounter_date_to
AND pp.progress_type IN ('STARTED', 'COMPLETED', 'CANCELLED')
ORDER BY pp.created