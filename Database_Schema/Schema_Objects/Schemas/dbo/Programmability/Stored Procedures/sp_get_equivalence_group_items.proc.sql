CREATE PROCEDURE sp_get_equivalence_group_items
	(
	@pl_equivalence_group_id int)
AS


SELECT CAST(object_id AS varchar(40)) as object_id ,
		object_key ,
		description ,
		CAST(0 AS int) as selected_flag
FROM c_Equivalence
WHERE equivalence_group_id = @pl_equivalence_group_id

RETURN
	
