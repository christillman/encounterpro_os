CREATE PROCEDURE sp_get_child_treatments (
	@pl_treatment_id int )
AS

-- get the child treatments & cpt code (for procedures)
SELECT b.patient_workplan_item_id,
	ordered_treatment_type,
	description = COALESCE(c.description + ': ' + b.description,b.description),
	cpt_code = (SELECT cpt_code FROM c_Procedure WHERE procedure_id = d.value and status = 'OK')
FROM  p_Patient_WP a
	INNER JOIN p_Patient_WP_Item b
	ON a.patient_workplan_id = b.patient_workplan_id
	INNER JOIN c_Treatment_Type c
	ON b.ordered_treatment_type = c.treatment_type
	LEFT OUTER JOIN p_Patient_Wp_Item_Attribute d
	ON b.patient_workplan_item_id = d.patient_workplan_item_id 
WHERE d.attribute = 'procedure_id'
AND b.item_type = 'treatment'
AND a.treatment_id = @pl_treatment_id
Order by b.patient_workplan_item_id


