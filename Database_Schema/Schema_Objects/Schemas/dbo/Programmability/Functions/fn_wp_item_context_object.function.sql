CREATE FUNCTION fn_wp_item_context_object (
	@pl_patient_workplan_item_id int)

RETURNS varchar(24)

AS
BEGIN
DECLARE @ls_context_object varchar(24)

SELECT @ls_context_object = MAX(CAST(a.value as varchar(24)))
FROM p_Patient_WP_Item_Attribute a
WHERE a.patient_workplan_item_id = @pl_patient_workplan_item_id
AND a.attribute = 'context_object'

RETURN @ls_context_object 

END
