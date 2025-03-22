
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[config_cancel_checkout]
Print 'Drop Procedure [dbo].[config_cancel_checkout]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[config_cancel_checkout]') AND [type]='P'))
DROP PROCEDURE [dbo].[config_cancel_checkout]
GO

-- Create Procedure [dbo].[config_cancel_checkout]
Print 'Create Procedure [dbo].[config_cancel_checkout]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE config_cancel_checkout (
	@pui_config_object_id uniqueidentifier ,
	@ps_checked_out_by varchar(24) = NULL)
AS
-- Make sure config object is not already checked out.  If not then assign new version number.
-- If a record does not already exist in c_Config_Object, then return -99
--
-- Returns:
-- -1 An error occured
-- -2 The specified config object is not locally owned
-- -3 The specified config object does not have a version record
-- -4 The specified config object is not checked out
-- -5 The specified config object is checked out by someone else (%s)
-- -99 The specified config object does not exist
--


DECLARE @ll_installed_version int,
		@ll_previous_version int,
		@ll_owner_id int,
		@ll_customer_id int,
		@ll_installed_version_status varchar(12),
		@ls_installed_version_checked_out_by varchar(24),
		@ls_user_full_name varchar(64),
		@ls_config_object_id varchar(40),
		@ls_from_value varchar(80)

SET @ls_config_object_id = CAST(@pui_config_object_id AS varchar(40))

SELECT @ll_installed_version = installed_version,
		@ll_owner_id = owner_id
FROM c_Config_Object
WHERE config_object_id = @pui_config_object_id

IF @@ERROR <> 0
	RETURN -1

IF @ll_owner_id IS NULL
	BEGIN
	RAISERROR ('The specified config object does not exists (%s)',16,-1, @ls_config_object_id)
	RETURN -99
	END

IF @ll_installed_version IS NULL
	BEGIN
	RAISERROR ('The specified config object does not have an installed version)',16,-1, @ls_config_object_id)
	RETURN -1
	END

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

-- If the config object is not owned by the local database, then return an error
IF @ll_owner_id <> @ll_customer_id
	BEGIN
	RAISERROR ('The specified config object is not locally owned (%s)',16,-1, @ls_config_object_id)
	RETURN -2
	END

SELECT @ll_previous_version = created_from_version,
		@ll_installed_version_status = status,
		@ls_installed_version_checked_out_by = created_by
FROM c_Config_Object_Version
WHERE config_object_id = @pui_config_object_id
AND version = @ll_installed_version

IF @@ERROR <> 0
	RETURN -1

IF @ll_installed_version_status IS NULL
	BEGIN
	RAISERROR ('The specified config object installed version does not have a version record (%s, %d)',16,-1, @ls_config_object_id, @ll_installed_version)
	RETURN -3
	END

IF @ll_previous_version IS NULL 
	BEGIN
	SELECT @ll_previous_version = max(version)
	FROM c_Config_Object_Version
	WHERE config_object_id = @pui_config_object_id
	AND status = 'CheckedIn'
	AND version < @ll_installed_version

	IF @@ERROR <> 0
		RETURN -1

	IF @ll_previous_version IS NULL
		BEGIN
		RAISERROR ('Unable to determine previous version (%s, %d)',16,-1, @ls_config_object_id, @ll_installed_version)
		RETURN -1
		END
	END


IF @ll_installed_version_status <> 'CheckedOut'
	BEGIN
	RAISERROR ('The specified config object is not checked out',16,-1)
	RETURN -4
	END

-- If we get here then we're ready to cancel the checkout
BEGIN TRANSACTION

DELETE v
FROM c_Config_Object_Version v
WHERE v.config_object_id = @pui_config_object_id
AND v.version = @ll_installed_version

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE c
SET installed_version = NULL,
	installed_version_date = NULL,
	installed_version_status = NULL
FROM c_Config_Object c
WHERE c.config_object_id = @pui_config_object_id

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

SET @ls_from_value = CAST(@ll_installed_version AS varchar(80))

EXECUTE config_log
	@pui_config_object_id = @pui_config_object_id ,
	@ps_operation = 'Cancel Checkout' ,
	@ps_property = 'installed_version',
	@ps_from_value = @ls_from_value ,
	@ps_to_value = NULL


COMMIT TRANSACTION

RETURN @ll_previous_version

GO
GRANT EXECUTE
	ON [dbo].[config_cancel_checkout]
	TO [cprsystem]
GO

