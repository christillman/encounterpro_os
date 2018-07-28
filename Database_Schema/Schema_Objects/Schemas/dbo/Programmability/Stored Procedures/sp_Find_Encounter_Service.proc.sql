CREATE PROCEDURE sp_Find_Encounter_Service
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@ps_service varchar(24),
	@pl_patient_workplan_item_id int OUTPUT
AS

DECLARE @li_step_number smallint



SELECT @li_step_number = min(i.step_number)
FROM 	p_Patient_WP_Item i WITH (NOLOCK)
	, p_Patient_WP w WITH (NOLOCK)
WHERE w.cpr_id = @ps_cpr_id
AND w.encounter_id = @pl_encounter_id
AND i.cpr_id = @ps_cpr_id
AND w.patient_workplan_id = i.patient_workplan_id
AND i.item_type = 'Service'
AND i.ordered_service = @ps_service
AND i.active_service_flag = 'Y'

IF @li_step_number IS NULL
	SELECT @pl_patient_workplan_item_id = NULL
ELSE
	SELECT @pl_patient_workplan_item_id = i.patient_workplan_item_id
	FROM 	p_Patient_WP_Item i WITH (NOLOCK)
		, p_Patient_WP w WITH (NOLOCK)
	WHERE w.cpr_id = @ps_cpr_id
	AND w.encounter_id = @pl_encounter_id
	AND i.cpr_id = @ps_cpr_id
	AND w.patient_workplan_id = i.patient_workplan_id
	AND i.step_number = @li_step_number
	AND i.item_type = 'Service'
	AND i.ordered_service = @ps_service
	AND i.active_service_flag = 'Y'



