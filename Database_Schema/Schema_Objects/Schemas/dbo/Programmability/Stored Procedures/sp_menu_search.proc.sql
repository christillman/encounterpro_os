CREATE PROCEDURE sp_menu_search (
	@ps_menu_category varchar(40) = NULL,
	@ps_description varchar(80) = NULL,
	@ps_context_object varchar(24) = NULL,
	@ps_specialty_id varchar(24) = NULL,
	@ps_status varchar(12) = NULL )
AS

IF @ps_status IS NULL
	SET @ps_status = 'OK'

IF @ps_description IS NULL
	SET @ps_description = '%'

IF @ps_menu_category IS NULL
	SET @ps_menu_category = '%'

IF @ps_context_object IS NULL
	SET @ps_context_object = '%'

IF @ps_specialty_id IS NULL
	SET @ps_specialty_id = '%'


SELECT a.menu_id,
		a.context_object,
		a.specialty_id,
		a.description,
		'b_new18.bmp' as icon,
		selected_flag=0
FROM c_Menu a
WHERE a.description LIKE @ps_description
AND ISNULL(a.specialty_id, '<NULL>') LIKE @ps_specialty_id
AND ISNULL(a.context_object, '<NULL>') LIKE @ps_context_object
AND ISNULL(a.menu_category, '<NULL>') LIKE @ps_menu_category
AND a.status = @ps_status


