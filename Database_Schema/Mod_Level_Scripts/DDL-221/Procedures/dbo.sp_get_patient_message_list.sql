
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_patient_message_list]
Print 'Drop Procedure [dbo].[sp_get_patient_message_list]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_patient_message_list]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_patient_message_list]
GO

-- Create Procedure [dbo].[sp_get_patient_message_list]
Print 'Create Procedure [dbo].[sp_get_patient_message_list]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_patient_message_list (
	@ps_cpr_id varchar(12) )
AS

SELECT distinct patient_workplan_item_id
INTO #tmp_patient_msgs
FROM p_Patient_WP_Item WITH (NOLOCK)
WHERE ordered_service = 'MESSAGE'
AND cpr_id = @ps_cpr_id

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
	f.user_short_name as from_user,
	f.color as from_user_color,
	t.user_short_name as to_user,
	t.color as to_user_color,
	selected_flag=0
FROM 	p_Patient_WP_Item i WITH (NOLOCK)
	JOIN #tmp_patient_msgs ON i.patient_workplan_item_id = #tmp_patient_msgs.patient_workplan_item_id
	JOIN c_User f WITH (NOLOCK) ON i.ordered_by = f.user_id
	JOIN c_User t WITH (NOLOCK) ON i.ordered_for = t.user_id
	CROSS JOIN o_Service s WITH (NOLOCK)
WHERE s.service = 'MESSAGE'


DROP TABLE #tmp_patient_msgs

GO
GRANT EXECUTE
	ON [dbo].[sp_get_patient_message_list]
	TO [cprsystem]
GO

