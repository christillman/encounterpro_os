CREATE PROCEDURE sp_get_todo_list_pct_n
(
	@ps_user_id varchar(24),
	@pdt_begin_date datetime = NULL,
	@pdt_end_date datetime = NULL
)
AS

-- This procedure displays all of the IN OFFICE completed services for the given user and date range.

IF @pdt_begin_date IS NULL OR @pdt_end_date IS NULL
	BEGIN
	SET @pdt_end_date = getdate()
	SET @pdt_begin_date = DATEADD(day, -5, @pdt_end_date)
	END

SELECT
	i.owned_by as user_id,
	i.patient_workplan_item_id,
	i.ordered_service,
	s.description as service_description,
	s.icon as service_icon,
	s.visible_flag,
	i.in_office_flag,
	i.ordered_by,
	i.description,
	i.dispatch_date,
	i.begin_date,
	i.end_date,
	i.status,
	i.retries,
	i.escalation_date,
	i.expiration_date,
	u.user_short_name,
	u.color,
	dispatch_minutes = DATEDIFF(minute, i.dispatch_date, getdate()),
	selected_flag=0,
	ISNULL(p.last_name, '') + ', ' + ISNULL(p.first_name, '') + ' ' + ISNULL(p.middle_name, '') AS patient_name,
	r.room_name,
	eu.user_short_name as encounter_owner,
	eu.color as encounter_owner_color,
	i.priority
FROM p_Patient_WP_Item i WITH (NOLOCK)
	INNER JOIN o_Service s WITH (NOLOCK)
	ON i.ordered_service = s.service
	INNER JOIN c_User u WITH (NOLOCK)
	ON i.ordered_by = u.user_id
	INNER JOIN p_patient p
	ON i.cpr_id = p.cpr_id
	INNER LOOP JOIN p_patient_encounter pe
	ON i.cpr_id = pe.cpr_id
	AND i.encounter_id = pe.encounter_id
	LEFT OUTER JOIN c_User eu
	ON pe.attending_doctor = eu.user_id
	LEFT OUTER JOIN o_Rooms r
	ON pe.patient_location = r.room_id
WHERE 	i.owned_by = @ps_user_id
AND		i.dispatch_date >= @pdt_begin_date
AND		i.dispatch_date <= @pdt_end_date
AND 	i.in_office_flag = 'Y'
AND 	i.active_service_flag = 'N'
AND 	(i.owned_by = '!Exception' OR i.ordered_service <> 'MESSAGE')

