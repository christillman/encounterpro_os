CREATE PROCEDURE sp_get_sent_message_list (
	@ps_user_id varchar(24) )
AS

DECLARE @ldt_sent_since datetime,
	@ls_sent_since varchar(64),
	@li_sent_since_amount smallint,
	@ls_sent_since_unit varchar(12),
	@li_space smallint

SET @ls_sent_since = dbo.fn_get_preference (
	'PREFERENCES',
	'sent_items_display_since',
	@ps_user_id,
	NULL )

IF @ls_sent_since IS NULL
	SET @ldt_sent_since = CONVERT(datetime, '1/1/1900')
ELSE
	BEGIN
	SET @li_space = CHARINDEX(' ', @ls_sent_since)
	SET @li_sent_since_amount = CONVERT(smallint, LEFT(@ls_sent_since, @li_space - 1))
	SET @ls_sent_since_unit = SUBSTRING(@ls_sent_since, @li_space + 1, 1)
	SET @ldt_sent_since =  CASE @ls_sent_since_unit
								WHEN 'Y' THEN dateadd(year, -@li_sent_since_amount, getdate())
								WHEN 'M' THEN dateadd(month, -@li_sent_since_amount, getdate())
								WHEN 'D' THEN dateadd(day, -@li_sent_since_amount, getdate())
								END
	END
	

SELECT i.ordered_for,
	i.patient_workplan_item_id,
	i.ordered_service,
	s.description as service_description,
	s.button as service_button,
	s.icon as service_icon,
	i.ordered_by,
	i.description,
	i.dispatch_date,
	i.begin_date,
	i.end_date,
	i.status,
	i.folder,
	u.user_short_name as to_user,
	u.color as to_user_color,
	p.cpr_id,
	COALESCE(p.first_name + ' ', '') + COALESCE(p.last_name, '') as patient_name,
	selected_flag=0
FROM p_Patient_WP_Item i WITH (NOLOCK)
	INNER JOIN o_Service s WITH (NOLOCK)
	ON i.ordered_service = s.service
	INNER JOIN c_User u WITH (NOLOCK)
	ON i.ordered_for = u.user_id
	LEFT OUTER JOIN p_Patient p WITH (NOLOCK)
	ON i.cpr_id = p.cpr_id
WHERE i.ordered_by = @ps_user_id
AND i.ordered_service = 'MESSAGE'
AND dispatch_date > @ldt_sent_since
AND i.dispatched_patient_workplan_item_id IS NULL

