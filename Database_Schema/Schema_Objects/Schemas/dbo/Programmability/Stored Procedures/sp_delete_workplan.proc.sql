CREATE PROCEDURE sp_delete_workplan
	@pl_workplan_id int
AS

declare @ll_count int
	, @ls_referenced_table varchar(30)

SELECT @ls_referenced_table = NULL

SELECT @ll_count = count(*)
FROM c_Workplan_Item
WHERE item_type = 'workplan'
and ordered_workplan_id = @pl_workplan_id
IF @ll_count > 0 
	BEGIN
	SELECT @ls_referenced_table = 'C_Workplan_Item'
	--RETURN
	END

SELECT @ll_count = count(*)
FROM c_Menu_Item_Attribute
WHERE attribute = 'workplan_id'
and value = @pl_workplan_id
IF @ll_count > 0 
	BEGIN
	SELECT @ls_referenced_table = 'C_Menu_Item_Attribute'
	--RETURN 
	END

SELECT @ll_count = count(*)
FROM c_Treatment_Type
WHERE workplan_id = @pl_workplan_id
IF @ll_count > 0 
	BEGIN
	SELECT @ls_referenced_table = 'C_Treatment_Type'
	--RETURN 
	END

SELECT @ll_count = count(*)
FROM c_Treatment_Type_Workplan
WHERE workplan_id = @pl_workplan_id
IF @ll_count > 0 
	BEGIN
	SELECT @ls_referenced_table = 'C_Treatment_Type_Workplan'
	--RETURN 
	END

SELECT @ll_count = count(*)
FROM c_Workplan_Selection
WHERE workplan_id = @pl_workplan_id
IF @ll_count > 0 
	BEGIN
	SELECT @ls_referenced_table = 'C_Workplan_Selection'
	--RETURN  
	END

-- If there's no reference for this workplan
-- then delete them.

--delete_workplan:

IF @ls_referenced_table IS NULL
	BEGIN
	DELETE
	FROM c_Workplan
	WHERE workplan_id = @pl_workplan_id

	DELETE 
	FROM c_Workplan_Item
	WHERE workplan_id = @pl_workplan_id

	DELETE
	FROM c_Workplan_Item_Attribute
	WHERE workplan_id = @pl_workplan_id
	END
SELECT @ls_referenced_table AS referenced_table


