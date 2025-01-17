﻿
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_treatment_auto_perform_services]
Print 'Drop Procedure [dbo].[sp_treatment_auto_perform_services]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_treatment_auto_perform_services]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_treatment_auto_perform_services]
GO

-- Create Procedure [dbo].[sp_treatment_auto_perform_services]
Print 'Create Procedure [dbo].[sp_treatment_auto_perform_services]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE dbo.sp_treatment_auto_perform_services (
	@ps_cpr_id varchar(24),
	@pl_treatment_id integer,
	@ps_user_id varchar(24) = NULL)
AS

DECLARE @ls_role_id varchar(24)

-- The @ps_user_id param can be a [user_id] or a role_id
IF @ps_user_id LIKE '!%'
	SELECT @ls_role_id = @ps_user_id
ELSE
	SELECT @ls_role_id = NULL

SELECT min(p_patient_wp_item.patient_workplan_item_id) as workplan_item_id
FROM p_patient_wp
JOIN p_patient_wp_item ON p_patient_wp.patient_workplan_id = p_patient_wp_item.patient_workplan_id
WHERE p_patient_wp_item.active_service_flag = 'Y'
AND p_patient_wp_item.auto_perform_flag = 'Y'
AND p_patient_wp.cpr_id = @ps_cpr_id
AND p_patient_wp.treatment_id = @pl_treatment_id
AND (@ps_user_id IS NULL
	OR p_patient_wp_item.owned_by IS NULL
	OR p_patient_wp_item.owned_by = @ps_user_id
	OR p_patient_wp_item.owned_by = @ls_role_id
	OR p_patient_wp_item.owned_by IN (
				SELECT role_id
			    FROM c_User_Role
			    WHERE [user_id] = @ps_user_id))

GO
GRANT EXECUTE
	ON [dbo].[sp_treatment_auto_perform_services]
	TO [cprsystem]
GO

