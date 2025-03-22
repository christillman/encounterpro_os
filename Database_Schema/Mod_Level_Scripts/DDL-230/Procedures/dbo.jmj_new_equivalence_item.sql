
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_new_equivalence_item]
Print 'Drop Procedure [dbo].[jmj_new_equivalence_item]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_new_equivalence_item]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_new_equivalence_item]
GO

-- Create Procedure [dbo].[jmj_new_equivalence_item]
Print 'Create Procedure [dbo].[jmj_new_equivalence_item]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmj_new_equivalence_item (
	@pl_equivalence_group_id int ,
	@ps_object_id varchar(40) = NULL,
	@ps_object_key varchar(64),
	@ps_created_by varchar(24) )
AS

DECLARE @ls_object_type varchar(24),
		@ls_item_object_type varchar(24),
		@lu_object_id uniqueidentifier,
		@ll_old_equivalence_group_id int,
		@ll_count int,
		@ls_object_id varchar(40)

SELECT @ls_object_type = object_type
FROM c_Equivalence_Group
WHERE equivalence_group_id = @pl_equivalence_group_id

IF @ls_object_type IS NULL
	BEGIN
	RAISERROR ('Equivalence Group ID Not Found (%d)', 16, 1, @pl_equivalence_group_id)
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @ps_object_key IS NULL
	BEGIN
	RAISERROR ('object_key cannot be null', 16, 1)
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @ps_object_id IS NULL
	SET @lu_object_id = dbo.fn_object_id_from_key(@ls_object_type, @ps_object_key)
ELSE
	SET @lu_object_id = CAST(@ps_object_id AS uniqueidentifier)

SELECT @ll_old_equivalence_group_id = equivalence_group_id,
		@ls_item_object_type = object_type
FROM c_Equivalence
WHERE object_id = @lu_object_id

IF @ls_item_object_type IS NULL 
	BEGIN
	SET @ls_object_id = CAST(@lu_object_id AS varchar(40))
	RAISERROR ('object not found (%s)', 16, 1, @ls_object_id)
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @ls_item_object_type <> @ls_object_type
	BEGIN
	RAISERROR ('Item object_type doesn''t match equivalence group object_type (%s, %d)', 16, 1, @ps_object_key, @pl_equivalence_group_id)
	ROLLBACK TRANSACTION
	RETURN -1
	END
ELSE
	BEGIN
	IF @ll_old_equivalence_group_id IS NULL OR @ll_old_equivalence_group_id <> @pl_equivalence_group_id
		BEGIN

		-- If the object is already a member of a different group, that the two groups are equivalent, so let's merge them
		IF @ll_old_equivalence_group_id > 0
			BEGIN
			BEGIN TRANSACTION
			UPDATE c_Equivalence
			SET equivalence_group_id = @pl_equivalence_group_id
			WHERE equivalence_group_id = @ll_old_equivalence_group_id

			DELETE FROM c_Equivalence_Group
			WHERE equivalence_group_id = @ll_old_equivalence_group_id
			COMMIT TRANSACTION
			END
		ELSE
			UPDATE c_Equivalence
			SET equivalence_group_id = @pl_equivalence_group_id
			WHERE object_id = @lu_object_id
		END	
	END


GO
GRANT EXECUTE
	ON [dbo].[jmj_new_equivalence_item]
	TO [cprsystem]
GO

