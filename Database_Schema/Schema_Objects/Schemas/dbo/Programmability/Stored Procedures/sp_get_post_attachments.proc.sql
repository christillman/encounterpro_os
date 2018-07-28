CREATE PROCEDURE sp_get_post_attachments (
	@ps_cpr_id varchar(12),
	@ps_treatment_list_id varchar(24))
AS
SELECT	p_Treatment_Item.treatment_type,
	p_Treatment_Item.open_encounter_id,
	p_Treatment_Item.treatment_id, 	p_Patient_Encounter.encounter_date,
	p_Treatment_Item.treatment_description,
	c_Treatment_Type.attachment_folder
FROM p_Treatment_Item,
	p_Patient_Encounter,
	c_Treatment_Type_list,
	c_Treatment_Type
WHERE p_Treatment_Item.cpr_id = @ps_cpr_id
AND p_Patient_Encounter.cpr_id = @ps_cpr_id
AND p_Treatment_Item.open_encounter_id = p_Patient_Encounter.encounter_id
AND (p_Treatment_Item.treatment_status IS NULL
OR p_Treatment_Item.treatment_status NOT IN ('CLOSED','MODIFIED','CANCELLED') )
AND p_Treatment_Item.treatment_type = c_Treatment_Type_List.treatment_type
AND c_Treatment_Type.treatment_type = c_Treatment_Type_List.treatment_type
AND c_Treatment_Type_list.treatment_list_id = @ps_treatment_list_id


