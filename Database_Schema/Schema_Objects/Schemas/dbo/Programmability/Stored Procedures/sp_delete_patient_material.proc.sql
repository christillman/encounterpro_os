CREATE PROCEDURE sp_delete_patient_material (
	@pl_material_id int )
AS
Update c_Patient_Material
Set status = 'NA'
Where material_id = @pl_material_id

DELETE FROM u_Top_20
WHERE item_id = Convert(varchar(64),@pl_material_id)
DELETE FROM u_Assessment_Treat_definition
WHERE EXISTS (
	SELECT definition_id
	FROM u_Assessment_treat_def_attrib
	WHERE attribute = 'material_id'
	AND value = convert(varchar(255),@pl_material_id)
	AND u_assessment_treat_def_attrib.definition_id = u_assessment_treat_definition.definition_id
	)


