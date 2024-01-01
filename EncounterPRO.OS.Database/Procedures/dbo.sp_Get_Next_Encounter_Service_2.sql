
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_Get_Next_Encounter_Service_2]
Print 'Drop Procedure [dbo].[sp_Get_Next_Encounter_Service_2]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_Get_Next_Encounter_Service_2]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_Get_Next_Encounter_Service_2]
GO

-- Create Procedure [dbo].[sp_Get_Next_Encounter_Service_2]
Print 'Create Procedure [dbo].[sp_Get_Next_Encounter_Service_2]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_Get_Next_Encounter_Service_2
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@ps_user_id varchar(24) = NULL,
	@ps_auto_perform_flag char(1) = '%',
	@ps_in_office_flag char(1) = '%',
	@pl_patient_workplan_item_id int OUTPUT
AS

DECLARE @li_step_number smallint,
		@li_count smallint

SELECT @li_step_number = min(i.step_number),
	@li_count = count(*)
FROM p_Patient_WP_Item i
JOIN p_Patient_WP w ON w.patient_workplan_id = i.patient_workplan_id
WHERE w.cpr_id = @ps_cpr_id
AND w.encounter_id = @pl_encounter_id
AND i.cpr_id = @ps_cpr_id
AND i.item_type = 'Service'
AND i.auto_perform_flag LIKE @ps_auto_perform_flag
AND i.active_service_flag = 'Y'
AND i.in_office_flag LIKE @ps_in_office_flag
AND (@ps_user_id IS NULL
	OR i.owned_by IS NULL
	OR i.owned_by = @ps_user_id
	OR EXISTS (
		SELECT r.user_id
		FROM c_User_Role r
		WHERE r.role_id = i.owned_by
		AND r.user_id = @ps_user_id) )

IF @li_step_number IS NULL AND @li_count = 0
	SET @pl_patient_workplan_item_id = NULL
ELSE
	BEGIN
	IF @li_step_number IS NULL
		SELECT @pl_patient_workplan_item_id = min(i.patient_workplan_item_id)
		FROM p_Patient_WP_Item i
		JOIN p_Patient_WP w ON w.patient_workplan_id = i.patient_workplan_id
		WHERE w.cpr_id = @ps_cpr_id
		AND w.encounter_id = @pl_encounter_id
		AND i.cpr_id = @ps_cpr_id
		AND i.item_type = 'Service'
		AND i.auto_perform_flag LIKE @ps_auto_perform_flag
		AND i.active_service_flag = 'Y'
		AND i.in_office_flag LIKE @ps_in_office_flag
		AND (@ps_user_id IS NULL
			OR i.owned_by IS NULL
			OR i.owned_by = @ps_user_id
			OR EXISTS (
				SELECT r.user_id
				FROM c_User_Role r
				WHERE r.role_id = i.owned_by
				AND r.user_id = @ps_user_id) )
	ELSE
		SELECT @pl_patient_workplan_item_id = min(i.patient_workplan_item_id)
		FROM p_Patient_WP_Item i
		JOIN p_Patient_WP w ON w.patient_workplan_id = i.patient_workplan_id
		WHERE w.cpr_id = @ps_cpr_id
		AND w.encounter_id = @pl_encounter_id
		AND i.cpr_id = @ps_cpr_id
		AND i.step_number = @li_step_number
		AND i.item_type = 'Service'
		AND i.auto_perform_flag LIKE @ps_auto_perform_flag
		AND i.active_service_flag = 'Y'
		AND i.in_office_flag LIKE @ps_in_office_flag
		AND (@ps_user_id IS NULL
			OR i.owned_by IS NULL
			OR i.owned_by = @ps_user_id
			OR EXISTS (
				SELECT r.user_id
				FROM c_User_Role r
				WHERE r.role_id = i.owned_by
				AND r.user_id = @ps_user_id) )
	END


GO
GRANT EXECUTE
	ON [dbo].[sp_Get_Next_Encounter_Service_2]
	TO [cprsystem]
GO

