
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_patient_services]
Print 'Drop Procedure [dbo].[sp_get_patient_services]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_patient_services]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_patient_services]
GO

-- Create Procedure [dbo].[sp_get_patient_services]
Print 'Create Procedure [dbo].[sp_get_patient_services]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_patient_services (
	@ps_cpr_id varchar(12),
	@ps_user_id varchar(24) = NULL)
AS
SELECT i.ordered_service,
	i.description,
	i.owned_by,
	i.patient_workplan_item_id,
	s.button,
	s.description as service_description
FROM	p_Patient_WP_Item i (NOLOCK)
	JOIN o_Service s (NOLOCK) ON i.ordered_service = s.service
WHERE i.cpr_id = @ps_cpr_id
AND	i.active_service_flag = 'Y'
AND	i.item_type = 'Service'
AND	i.in_office_flag = 'Y'
AND	(i.owned_by = @ps_user_id
	OR i.owned_by IN (
				SELECT role_id
				FROM c_User_Role
				WHERE user_id = @ps_user_id) )
AND NOT EXISTS (
		SELECT patient_workplan_item_id
		FROM o_User_Service_Lock l
		WHERE l.patient_workplan_item_id = i.patient_workplan_item_id)

GO
GRANT EXECUTE
	ON [dbo].[sp_get_patient_services]
	TO [cprsystem]
GO

