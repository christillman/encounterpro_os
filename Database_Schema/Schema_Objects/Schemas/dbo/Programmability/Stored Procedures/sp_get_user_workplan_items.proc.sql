CREATE PROCEDURE sp_get_user_workplan_items
	@ps_user_id varchar(24),
	@ps_in_office_flag char(1) = '%',
	@pdt_not_started_since datetime = NULL
AS

-- If a not-started-since time is not specified, then
-- use "5 minutes ago" as a default
IF @pdt_not_started_since IS NULL
	BEGIN
	SET @pdt_not_started_since = DATEADD(minute, -5, getdate())
	END

SELECT i.ordered_for,
	i.patient_workplan_item_id,
	i.ordered_service,
	s.description as service_description,
	s.icon as service_icon,
	s.visible_flag,
	i.ordered_by,
	i.description,
	i.dispatch_date,
	i.begin_date,
	i.end_date,
	i.status,
	i.retries,
	selected_flag=0
FROM p_Patient_WP_Item i WITH (NOLOCK)
	, o_Service s WITH (NOLOCK)
WHERE i.owned_by = @ps_user_id
AND i.active_service_flag = 'Y'
AND i.ordered_service = s.service
AND i.in_office_flag LIKE @ps_in_office_flag
AND ((begin_date IS NULL) OR (begin_date < @pdt_not_started_since))

