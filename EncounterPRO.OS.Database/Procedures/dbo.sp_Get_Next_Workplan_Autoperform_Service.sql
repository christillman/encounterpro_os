
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_Get_Next_Workplan_Autoperform_Service]
Print 'Drop Procedure [dbo].[sp_Get_Next_Workplan_Autoperform_Service]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_Get_Next_Workplan_Autoperform_Service]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_Get_Next_Workplan_Autoperform_Service]
GO

-- Create Procedure [dbo].[sp_Get_Next_Workplan_Autoperform_Service]
Print 'Create Procedure [dbo].[sp_Get_Next_Workplan_Autoperform_Service]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_Get_Next_Workplan_Autoperform_Service
	@ps_cpr_id varchar(12),
	@pl_patient_workplan_id int,
	@ps_user_id varchar(24) = NULL,
	@pl_patient_workplan_item_id int OUTPUT
AS

DECLARE @li_step_number smallint,
	@ls_role_id varchar(24)

-- The @ps_user_id param can be a user_id, a user_role, or a patient
-- First check for a patient
IF @ps_cpr_id LIKE '!%'
	SELECT @ls_role_id = @ps_cpr_id
ELSE
	SELECT @ls_role_id = NULL


SELECT @li_step_number = min(step_number)
FROM p_Patient_WP_Item
WHERE cpr_id = @ps_cpr_id
AND patient_workplan_id = @pl_patient_workplan_id
AND item_type = 'Service'
AND active_service_flag = 'Y'
AND auto_perform_flag = 'Y'
AND (@ps_user_id IS NULL
	OR owned_by = @ps_user_id
	OR owned_by = @ls_role_id
	OR owned_by IN (SELECT role_id
			    FROM c_User_Role
			    WHERE [user_id] = @ps_cpr_id))

IF @li_step_number IS NULL
	SELECT @pl_patient_workplan_item_id = NULL
ELSE
	SELECT @pl_patient_workplan_item_id = min(patient_workplan_item_id)
	FROM p_Patient_WP_Item
	WHERE cpr_id = @ps_cpr_id
	AND patient_workplan_id = @pl_patient_workplan_id
	AND step_number = @li_step_number
	AND item_type = 'Service'
	AND active_service_flag = 'Y'
	AND auto_perform_flag = 'Y'
	AND (@ps_user_id IS NULL
		OR owned_by = @ps_user_id
		OR owned_by = @ls_role_id
		OR owned_by IN (SELECT role_id
				    FROM c_User_Role
				    WHERE [user_id] = @ps_cpr_id))

GO
GRANT EXECUTE
	ON [dbo].[sp_Get_Next_Workplan_Autoperform_Service]
	TO [cprsystem]
GO

