CREATE FUNCTION fn_workplan_item_attribute_value (
	@pl_patient_workplan_item_id int,
	@ps_attribute varchar(64))

RETURNS varchar(255)

AS
BEGIN

DECLARE @ll_attribute_sequence int,
		@ls_value varchar(255)

SELECT @ll_attribute_sequence = max(attribute_sequence)
FROM p_Patient_WP_Item_Attribute
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id
AND attribute = @ps_attribute


IF @ll_attribute_sequence IS NOT NULL
	SELECT @ls_value = value 
	FROM p_Patient_WP_Item_Attribute
	WHERE patient_workplan_item_id = @pl_patient_workplan_item_id
	AND attribute_sequence = @ll_attribute_sequence

RETURN @ls_value
END

