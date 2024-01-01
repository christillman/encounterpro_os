
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_count_room_status]
Print 'Drop Procedure [dbo].[sp_count_room_status]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_count_room_status]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_count_room_status]
GO

-- Create Procedure [dbo].[sp_count_room_status]
Print 'Create Procedure [dbo].[sp_count_room_status]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_count_room_status (
	@ps_room_id varchar(12),
	@pl_patient_count int OUTPUT )
AS
SELECT @pl_patient_count = count(distinct e.cpr_id)
FROM	p_Patient_WP w WITH (NOLOCK)
		JOIN p_Patient_WP_Item i WITH (NOLOCK) ON w.cpr_id = i.cpr_id
			AND w.patient_workplan_id = i.patient_workplan_id
		JOIN p_Patient_Encounter e WITH (NOLOCK) ON w.cpr_id = e.cpr_id
			AND w.encounter_id = e.encounter_id
WHERE i.active_service_flag = 'Y'
AND	i.item_type = 'Service'
AND	w.status = 'Current'
AND	w.in_office_flag = 'Y'
AND	i.in_office_flag = 'Y'
AND	e.encounter_status = 'OPEN'
AND	e.patient_location = @ps_room_id

GO
GRANT EXECUTE
	ON [dbo].[sp_count_room_status]
	TO [cprsystem]
GO

