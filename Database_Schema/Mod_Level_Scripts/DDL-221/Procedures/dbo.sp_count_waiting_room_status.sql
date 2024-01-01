
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_count_waiting_room_status]
Print 'Drop Procedure [dbo].[sp_count_waiting_room_status]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_count_waiting_room_status]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_count_waiting_room_status]
GO

-- Create Procedure [dbo].[sp_count_waiting_room_status]
Print 'Create Procedure [dbo].[sp_count_waiting_room_status]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_count_waiting_room_status (
	@ps_office_id varchar(4),
	@pi_waiting_count smallint OUTPUT )
AS
SELECT @pi_waiting_count = count(p_Patient_Encounter.encounter_id)
FROM	p_Patient_WP WITH (NOLOCK)
		JOIN p_Patient_WP_Item WITH (NOLOCK) ON p_Patient_WP.cpr_id = p_Patient_WP_Item.cpr_id
			AND p_Patient_WP.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
		JOIN p_Patient_Encounter WITH (NOLOCK) ON p_Patient_WP.cpr_id = p_Patient_Encounter.cpr_id
			AND p_Patient_WP.encounter_id = p_Patient_Encounter.encounter_id
WHERE p_Patient_WP_Item.ordered_service = 'GET_PATIENT'
AND p_Patient_WP_Item.item_type = 'Service'
AND p_Patient_WP_Item.active_service_flag = 'Y'
AND p_Patient_WP.workplan_type = 'Patient'
AND p_Patient_WP.in_office_flag = 'Y'
AND p_Patient_WP.status = 'Current'
AND p_Patient_Encounter.office_id = @ps_office_id
AND p_Patient_Encounter.encounter_status = 'OPEN'

GO
GRANT EXECUTE
	ON [dbo].[sp_count_waiting_room_status]
	TO [cprsystem]
GO

