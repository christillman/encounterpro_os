
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_patient_todo_list]
Print 'Drop Procedure [dbo].[sp_get_patient_todo_list]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_patient_todo_list]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_patient_todo_list]
GO

-- Create Procedure [dbo].[sp_get_patient_todo_list]
Print 'Create Procedure [dbo].[sp_get_patient_todo_list]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_patient_todo_list (
	@ps_cpr_id varchar(24),
	@ps_service varchar(24) = '%',
	@pc_finished_items char(1) = 'N' )
AS
IF @ps_service IS NULL
	SELECT @ps_service = '%'

IF @pc_finished_items = 'N'
BEGIN
SELECT i.ordered_for,
	i.patient_workplan_item_id,
	i.ordered_service,
	s.description as service_description,
	s.icon as service_icon,
	i.ordered_by,
	i.description,
	i.dispatch_date,
	i.begin_date,
	i.end_date,
	i.status,
	u.user_short_name,
	u.color,
	selected_flag=0
FROM 	p_Patient_WP_Item i WITH (NOLOCK)
	JOIN o_Service s WITH (NOLOCK) ON i.ordered_service = s.service
	JOIN c_User u WITH (NOLOCK) ON i.ordered_for = u.user_id
WHERE i.cpr_id= @ps_cpr_id
AND i.active_service_flag = 'Y'
AND i.ordered_service like @ps_service
AND i.ordered_service <> 'MESSAGE'
AND NOT EXISTS (
	SELECT patient_workplan_item_id
	FROM o_User_Service_Lock WITH (NOLOCK)
	WHERE patient_workplan_item_id = i.patient_workplan_item_id
	)
END

ELSE
BEGIN
SELECT i.ordered_for,
	i.patient_workplan_item_id,
	i.ordered_service,
	s.description as service_description,
	s.icon as service_icon,
	i.ordered_by,
	i.description,
	i.dispatch_date,
	i.begin_date,
	i.end_date,
	i.status,
	u.user_short_name,
	u.color,
	selected_flag=0
FROM 	p_Patient_WP_Item i WITH (NOLOCK)
	JOIN o_Service s WITH (NOLOCK) ON i.ordered_service = s.service
	JOIN c_User u WITH (NOLOCK) ON i.ordered_for = u.user_id
WHERE i.cpr_id= @ps_cpr_id
AND i.status = 'COMPLETED'
AND i.ordered_service like @ps_service
AND i.ordered_service <> 'MESSAGE'

END

GO
GRANT EXECUTE
	ON [dbo].[sp_get_patient_todo_list]
	TO [cprsystem]
GO

