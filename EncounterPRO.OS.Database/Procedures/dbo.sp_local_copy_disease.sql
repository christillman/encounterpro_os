
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_local_copy_disease]
Print 'Drop Procedure [dbo].[sp_local_copy_disease]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_local_copy_disease]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_local_copy_disease]
GO

-- Create Procedure [dbo].[sp_local_copy_disease]
Print 'Create Procedure [dbo].[sp_local_copy_disease]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_local_copy_disease (
	@pl_disease_id int,
	@ps_new_id varchar(40) = NULL,
	@ps_new_description varchar(80) = NULL )
AS

-- This stored procedure creates a local copy of the specified disease and returns the new disease_id
DECLARE @ll_new_disease_id int,
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
FROM c_disease
WHERE disease_id = @pl_disease_id

IF @ll_owner_id IS NULL
	BEGIN
	RAISERROR ('No such disease (%d)',16,-1, @pl_disease_id)
	RETURN -1
	END

-- If the new disease is a local version of the old disease, then make sure the old disease isn't already locally owned
IF @lid_id = @lid_new_id AND @ll_owner_id = @ll_customer_id
	BEGIN
	RAISERROR ('disease is already locally owned (%d)',16,-1, @pl_disease_id)
	RETURN -1
	END

-- Make sure there aren't any other diseases out there with this id and owner combo
SELECT @ll_count = count(*)
FROM c_disease
WHERE id = @lid_new_id
AND owner_id = @ll_customer_id

IF @ll_count > 0
	BEGIN
	RAISERROR ('Locally owned disease already exists (%d)',16,-1, @pl_disease_id)
	RETURN -1
	END

BEGIN TRANSACTION

SELECT @ll_new_disease_id = max(disease_id)
FROM c_disease WITH (UPDLOCK)

IF @ll_new_disease_id >= 1000000
	SET @ll_new_disease_id = @ll_new_disease_id + 1
ELSE
	SET @ll_new_disease_id = 1000000

INSERT INTO [dbo].[c_Disease]
           ([disease_id]
           ,[description]
           ,[display_flag]
           ,[no_vaccine_after_disease]
           ,[sort_sequence]
           ,[status]
           ,[id]
           ,[last_updated]
           ,[owner_id])
SELECT @ll_new_disease_id
           ,[description]
           ,[display_flag]
           ,[no_vaccine_after_disease]
           ,[sort_sequence]
           ,[status]
			,@lid_new_id
           ,dbo.get_client_datetime()
           ,@ll_customer_id
FROM c_disease
WHERE disease_id = @pl_disease_id

IF @@ERROR <> 0
	RETURN


EXECUTE jmj_modify_references
	@pl_reference_id = @pl_disease_id,
	@pl_new_reference_id = @ll_new_disease_id,
	@ps_object_key = 'disease_id'

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END

COMMIT TRANSACTION

RETURN @ll_new_disease_id

GO
GRANT EXECUTE
	ON [dbo].[sp_local_copy_disease]
	TO [cprsystem]
GO

