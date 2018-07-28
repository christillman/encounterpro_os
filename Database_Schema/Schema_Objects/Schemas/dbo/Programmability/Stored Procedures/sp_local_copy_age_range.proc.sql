CREATE PROCEDURE sp_local_copy_age_range (
	@pl_age_range_id int,
	@ps_new_id varchar(40) = NULL,
	@ps_new_description varchar(80) = NULL )
AS

-- This stored procedure creates a local copy of the specified age_range and returns the new age_range_id
DECLARE @ll_new_age_range_id int,
	@ll_customer_id int,
	@ll_owner_id int,
	@lid_id uniqueidentifier,
	@lid_new_id uniqueidentifier,
	@ll_count int,
	@ll_error int

IF @ps_new_id IS NULL OR LEN(@ps_new_id) < 30
	SET @lid_new_id = newid()
ELSE
	SET @lid_new_id = CAST(@ps_new_id AS uniqueidentifier)

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

SELECT @ll_owner_id = owner_id,
		@lid_id = id,
		@ps_new_description = COALESCE(@ps_new_description, description)
FROM c_age_range
WHERE age_range_id = @pl_age_range_id

IF @@ROWCOUNT <> 1
	BEGIN
	RAISERROR ('No such age_range (%d)',16,-1, @pl_age_range_id)
	RETURN -1
	END

-- If the new age_range is a local version of the old age_range, then make sure the old age_range isn't already locally owned
IF @lid_id = @lid_new_id AND @ll_owner_id = @ll_customer_id
	BEGIN
	RAISERROR ('age_range is already locally owned (%d)',16,-1, @pl_age_range_id)
	RETURN -1
	END

-- Make sure there aren't any other age_ranges out there with this id and owner combo
SELECT @ll_count = count(*)
FROM c_age_range
WHERE id = @lid_new_id
AND owner_id = @ll_customer_id

IF @ll_count > 0
	BEGIN
	RAISERROR ('Locally owned age_range already exists (%d)',16,-1, @pl_age_range_id)
	RETURN -1
	END

BEGIN TRANSACTION

INSERT INTO [dbo].[c_Age_Range]
           ([age_range_category]
           ,[description]
           ,[age_from]
           ,[age_from_unit]
           ,[age_to]
           ,[age_to_unit]
           ,[sort_sequence]
           ,[owner_id]
           ,[status]
           ,[last_updated]
           ,[id])
SELECT [age_range_category]
           ,[description]
           ,[age_from]
           ,[age_from_unit]
           ,[age_to]
           ,[age_to_unit]
           ,[sort_sequence]
           ,@ll_customer_id
           ,[status]
           ,getdate()
			,@lid_new_id
FROM c_Age_Range
WHERE age_range_id = @pl_age_range_id

SELECT @ll_error = @@ERROR,
		@ll_count = @@ROWCOUNT

IF @ll_error <> 0
	RETURN

SET @ll_new_age_range_id = SCOPE_IDENTITY()

EXECUTE jmj_modify_age_range_references
	@pl_from_age_range_id = @pl_age_range_id,
	@pl_to_age_range_id = @ll_new_age_range_id

SELECT @ll_error = @@ERROR,
		@ll_count = @@ROWCOUNT

IF @ll_error <> 0
	RETURN


COMMIT TRANSACTION

RETURN @ll_new_age_range_id

