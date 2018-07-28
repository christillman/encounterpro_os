CREATE PROCEDURE sp_material_search (
	@ps_material_category_id int = NULL,
	@ps_description varchar(80) = NULL,
	@ps_specialty_id varchar(24) = NULL,
	@ps_status varchar(12) = NULL )
AS

IF @ps_status IS NULL
	SELECT @ps_status = 'OK'

IF @ps_description IS NULL
	SELECT @ps_description = '%'

SELECT a.material_id,
	a.category,
	a.title as description ,
	a.status,
	'b_new18.bmp' as icon,
	selected_flag=0,
	a.extension
FROM c_Patient_Material a
WHERE a.status like @ps_status
AND a.title like @ps_description
AND (@ps_material_category_id IS NULL OR @ps_material_category_id = a.category)


