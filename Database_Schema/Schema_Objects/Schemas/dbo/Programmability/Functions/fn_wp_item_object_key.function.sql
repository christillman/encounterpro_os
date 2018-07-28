CREATE FUNCTION fn_wp_item_object_key (
	@pl_patient_workplan_item_id int)

RETURNS int

AS
BEGIN
DECLARE @ls_context_object varchar(24),
		@ll_object_key int

SELECT @ls_context_object = MAX(CAST(a.value as varchar(24)))
FROM p_Patient_WP_Item_Attribute a
WHERE a.patient_workplan_item_id = @pl_patient_workplan_item_id
AND a.attribute = 'context_object'

IF @ls_context_object = 'Encounter'
	SELECT @ll_object_key = encounter_id
	FROM p_Patient_WP_Item
	WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

IF @ls_context_object = 'Assessment'
	SELECT @ll_object_key = CAST(value as int)
	FROM p_Patient_WP_Item_Attribute
	WHERE patient_workplan_item_id = @pl_patient_workplan_item_id
	AND attribute = 'problem_id'
	AND ISNUMERIC(value) = 1

IF @ls_context_object = 'Treatment'
	SELECT @ll_object_key = treatment_id
	FROM p_Patient_WP_Item
	WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

IF @ls_context_object = 'Attachment'
	SELECT @ll_object_key = CAST(value as int)
	FROM p_Patient_WP_Item_Attribute
	WHERE patient_workplan_item_id = @pl_patient_workplan_item_id
	AND attribute = 'problem_id'
	AND ISNUMERIC(value) = 1


RETURN @ll_object_key 

END
