
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_Encounter_Auto_Perform_Services]
Print 'Drop Procedure [dbo].[sp_Encounter_Auto_Perform_Services]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_Encounter_Auto_Perform_Services]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_Encounter_Auto_Perform_Services]
GO

-- Create Procedure [dbo].[sp_Encounter_Auto_Perform_Services]
Print 'Create Procedure [dbo].[sp_Encounter_Auto_Perform_Services]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_Encounter_Auto_Perform_Services
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@ps_in_office_flag char(1),
	@ps_user_id varchar(24)
AS

DECLARE @ls_role_id varchar(24)

-- The @ps_user_id param can be a [user_id] or a role_id
IF @ps_user_id LIKE '!%'
	SELECT @ls_role_id = @ps_user_id
ELSE
	SELECT @ls_role_id = NULL


SELECT patient_workplan_id,
	patient_workplan_item_id,
	priority,
	ordered_for,
	step_flag,
	step_number,
	item_number
FROM p_Patient_WP_Item
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id
AND item_type = 'Service'
AND auto_perform_flag = 'Y'
AND in_office_flag = @ps_in_office_flag
AND active_service_flag = 'Y'
AND (@ps_user_id IS NULL
	OR owned_by IS NULL
	OR owned_by = @ps_user_id
	OR owned_by = @ls_role_id
	OR owned_by IN (SELECT role_id
			    FROM c_User_Role
			    WHERE [user_id] = @ps_user_id))

GO
GRANT EXECUTE
	ON [dbo].[sp_Encounter_Auto_Perform_Services]
	TO [cprsystem]
GO

