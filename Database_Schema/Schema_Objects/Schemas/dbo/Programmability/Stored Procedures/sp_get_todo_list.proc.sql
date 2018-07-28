CREATE PROCEDURE sp_get_todo_list
(
	@ps_user_id varchar(24),
	@ps_service varchar(24) = '%',
	@pc_in_office_flag char(1) = '%',
	@pc_active_service_flag char(1) = 'Y' 
)
AS
IF @ps_service IS NULL
	SELECT @ps_service = '%'

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
	dbo.fn_pretty_name
		(
			p.last_name,
			p.first_name,
			p.middle_name,
			p.name_suffix,
			p.name_prefix,
			p.degree
		) AS patient_name
FROM p_Patient_WP_Item i WITH (NOLOCK)
INNER JOIN o_Service s WITH (NOLOCK)
ON i.ordered_service = s.service
INNER JOIN c_User u WITH (NOLOCK)
ON i.ordered_by = u.user_id
LEFT OUTER JOIN p_patient p
ON i.cpr_id = p.cpr_id
WHERE
	i.owned_by = @ps_user_id
AND 	i.active_service_flag = @pc_active_service_flag
AND 	i.in_office_flag LIKE @pc_in_office_flag
AND 	i.ordered_service LIKE @ps_service
AND 	i.ordered_service <> 'MESSAGE'


