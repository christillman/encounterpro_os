
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_user_inbox]
Print 'Drop Procedure [dbo].[sp_get_user_inbox]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_user_inbox]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_user_inbox]
GO

-- Create Procedure [dbo].[sp_get_user_inbox]
Print 'Create Procedure [dbo].[sp_get_user_inbox]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_user_inbox (
	@ps_user_id varchar(24) )
AS

SELECT i.cpr_id,
	i.patient_workplan_id,
	i.patient_workplan_item_id,
	w.workplan_type,
	i.in_office_flag,
	i.description,
	i.ordered_service,
	i.ordered_for,
	i.dispatch_date,
	0 as selected_flag
FROM p_Patient_WP w WITH (NOLOCK)
	JOIN p_Patient_WP_item i WITH (NOLOCK) ON w.patient_workplan_id = i.patient_workplan_id
WHERE i.ordered_for = @ps_user_id
AND i.item_type = 'Service'
AND i.active_service_flag = 'Y'

UNION

SELECT i.cpr_id,
	i.patient_workplan_id,
	i.patient_workplan_item_id,
	w.workplan_type,
	i.in_office_flag,
	i.description,
	i.ordered_service,
	i.ordered_for,
	i.dispatch_date,
	0 as selected_flag
FROM p_Patient_WP w WITH (NOLOCK)
	JOIN p_Patient_WP_item i WITH (NOLOCK) ON w.patient_workplan_id = i.patient_workplan_id
	JOIN c_User_Role r WITH (NOLOCK) ON i.ordered_for = r.role_id
WHERE r.user_id = @ps_user_id
AND i.item_type = 'Service'
AND i.active_service_flag = 'Y'

GO
GRANT EXECUTE
	ON [dbo].[sp_get_user_inbox]
	TO [cprsystem]
GO

