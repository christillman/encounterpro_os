CREATE PROCEDURE sp_get_treatment_followup_workplan_items (
	@ps_cpr_id varchar(12),
	@pl_treatment_id int,
	@ps_workplan_type varchar(12))
AS

DECLARE @ll_patient_workplan_id int

SELECT @ll_patient_workplan_id = min(patient_workplan_id)
FROM p_Patient_Wp
WHERE cpr_id = @ps_cpr_id
AND treatment_id = @pl_treatment_id
AND workplan_type = @ps_workplan_type
IF @@rowcount <> 1
	BEGIN
	RAISERROR ('No such followup workplan (%d)',16,-1, @pl_treatment_id)
	ROLLBACK TRANSACTION
	RETURN
	END
SELECT p_Patient_Wp_Item.patient_workplan_item_id,p_Patient_Wp_Item.description,c_Treatment_Type.button
FROM p_Patient_Wp_Item,c_Treatment_Type
WHERE p_Patient_Wp_Item.Ordered_Treatment_Type = c_Treatment_Type.treatment_type
AND p_Patient_Wp_Item.cpr_id = @ps_cpr_id
AND p_Patient_Wp_Item.patient_workplan_id = @ll_patient_workplan_id
AND p_patient_Wp_Item.item_type = 'Treatment'


