CREATE PROCEDURE jmj_delete_equivalence_item (
	@pl_equivalence_group_id int ,
	@ps_object_id varchar(40) = NULL,
	@ps_object_key varchar(24) = NULL,
	@ps_created_by varchar(24) )
AS

DECLARE @ls_object_type varchar(32),
		@lu_object_id uniqueidentifier,
		@ll_other_equivalence_group_id int

IF @ps_object_key IS NULL
	BEGIN
	RAISERROR ('object_key cannot be null', 16, 1)
	ROLLBACK TRANSACTION
	RETURN -1
	END

SELECT @ls_object_type = object_type
FROM c_Equivalence_Group
WHERE equivalence_group_id = @pl_equivalence_group_id

IF @@ROWCOUNT = 0
	BEGIN
	RAISERROR ('Equivalence Group ID Not Found', 16, 1)
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE c_Equivalence
SET equivalence_group_id = NULL,
	primary_flag = 'N'
WHERE object_type = @ls_object_type
AND object_key = @ps_object_key


