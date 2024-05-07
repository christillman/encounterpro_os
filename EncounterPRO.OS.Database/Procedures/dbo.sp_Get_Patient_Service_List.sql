
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_Get_Patient_Service_List]
Print 'Drop Procedure [dbo].[sp_Get_Patient_Service_List]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_Get_Patient_Service_List]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_Get_Patient_Service_List]
GO

-- Create Procedure [dbo].[sp_Get_Patient_Service_List]
Print 'Create Procedure [dbo].[sp_Get_Patient_Service_List]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_Get_Patient_Service_List (
	@ps_office_id varchar(4),
	@ps_workplan_type varchar(12),
	@ps_service varchar(24) )
AS

SELECT DISTINCT
	p_Patient_WP_Item.patient_workplan_item_id,
	p_Patient.cpr_id,   
	p_Patient_Encounter.encounter_id,   
	p_Patient_Encounter.attending_doctor,   
	encounter_description = COALESCE(p_Patient_Encounter.encounter_description, c_Encounter_Type.description),  
	minutes=DATEDIFF(minute, p_Patient_WP_Item.dispatch_date, dbo.get_client_datetime()),   
	p_Patient.last_name,
	p_Patient.first_name,
	fullname = p_Patient.first_name + ' '+ p_Patient.last_name,
	selected_flag=0
FROM	p_Patient_WP WITH (NOLOCK)
	JOIN p_Patient_Encounter WITH (NOLOCK) ON p_Patient_WP.cpr_id = p_Patient_Encounter.cpr_id
		AND p_Patient_WP.encounter_id = p_Patient_Encounter.encounter_id
	JOIN c_Encounter_Type WITH (NOLOCK) ON p_Patient_Encounter.encounter_type = c_Encounter_Type.encounter_type
	JOIN p_Patient_WP_Item WITH (NOLOCK) ON p_Patient_WP.cpr_id = p_Patient_WP_Item.cpr_id
		AND p_Patient_WP.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
	JOIN p_Patient WITH (NOLOCK) ON p_Patient_WP.cpr_id = p_Patient.cpr_id
WHERE p_Patient_WP_Item.ordered_service = @ps_service
AND p_Patient_WP_Item.item_type = 'Service'
AND p_Patient_WP_Item.active_service_flag = 'Y'
--AND p_Patient_WP.workplan_type = @ps_workplan_type
AND p_Patient_Encounter.office_id = @ps_office_id


GO
GRANT EXECUTE
	ON [dbo].[sp_Get_Patient_Service_List]
	TO [cprsystem]
GO

