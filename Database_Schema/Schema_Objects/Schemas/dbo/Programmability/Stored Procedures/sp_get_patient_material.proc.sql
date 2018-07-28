CREATE PROCEDURE dbo.sp_get_patient_material(@pi_material_id integer)
AS

	SELECT m.title,
			c.material_category_id,
			c.description 
	FROM c_patient_material m
		LEFT OUTER JOIN c_patient_material_category c
		ON m.category = c.material_category_id
	WHERE m.material_id = @pi_material_id


