
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[config_checkin]
Print 'Drop Procedure [dbo].[config_checkin]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[config_checkin]') AND [type]='P'))
DROP PROCEDURE [dbo].[config_checkin]
GO

-- Create Procedure [dbo].[config_checkin]
Print 'Create Procedure [dbo].[config_checkin]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE config_checkin (
	@pui_config_object_id varchar(40) ,
	@ps_version_description varchar(max) = NULL ,
	@pi_objectdata image ,
	@ps_checked_out_by varchar(24) )
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


DECLARE @ll_latest_version int,
		@ll_last_version int,
		@ll_owner_id int,
		@ll_customer_id int,
		@ll_last_version_status varchar(12),
		@ls_last_checked_out_by varchar(24),
		@ls_user_full_name varchar(64),
		@ls_checkedin_status varchar(12),
		@ldt_checkin_datetime datetime,
		@lui_config_object_id uniqueidentifier,
		@ls_object_encoding_method varchar(12)

SET @lui_config_object_id = CAST(@pui_config_object_id AS uniqueidentifier)
SET @ls_checkedin_status = 'CheckedIn'

SELECT @ll_latest_version = latest_version,
		@ll_owner_id = owner_id
FROM c_Config_Object
WHERE config_object_id = @lui_config_object_id

IF @ll_owner_id IS NULL
	RETURN -99

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

-- If the config object is not owned by the local database, then return an error
IF @ll_owner_id <> @ll_customer_id
	BEGIN
	RAISERROR ('The specified config object is not locally owned',16,-1)
	RETURN -2
	END

SELECT @ll_last_version = max(version)
FROM c_Config_Object_Version
WHERE config_object_id = @lui_config_object_id

IF @@ERROR <> 0
	RETURN -1

IF @ll_last_version IS NULL
	BEGIN
	RAISERROR ('The specified config object does not have a version record',16,-1)
	RETURN -3
	END

SELECT @ll_last_version_status = v.status,
		@ls_last_checked_out_by = v.created_by,
		@ls_object_encoding_method = coalesce(v.object_encoding_method, t.object_encoding_method)
FROM c_Config_Object_Version v
	INNER JOIN c_Config_Object_Type t
	ON v.config_object_type = t.config_object_type
WHERE v.config_object_id = @lui_config_object_id
AND v.version = @ll_last_version

IF @@ERROR <> 0
	RETURN -1

IF @ll_last_version_status <> 'CheckedOut'
	BEGIN
	RAISERROR ('The specified config object is not checked out',16,-1)
	RETURN -4
	END


-- If we get here then we're ready to update the version record

SET @ldt_checkin_datetime = dbo.get_client_datetime()

UPDATE v
SET objectdata = CASE @ls_object_encoding_method WHEN 'None' THEN v.objectdata ELSE @pi_objectdata END,
	status = @ls_checkedin_status,
	status_date_time = @ldt_checkin_datetime,
	checked_in = @ldt_checkin_datetime
FROM c_Config_Object_Version v
WHERE config_object_id = @lui_config_object_id
AND version = @ll_last_version

IF @@ERROR <> 0
	RETURN -1

IF @ps_version_description IS NOT NULL
	UPDATE v
	SET version_description = @ps_version_description
	FROM c_Config_Object_Version v
	WHERE config_object_id = @lui_config_object_id
	AND version = @ll_last_version

IF @@ERROR <> 0
	RETURN -1

-- We know what the installed version is here, so update those fields in the parent object record
UPDATE o
SET installed_version = v.version,
	installed_version_date = v.status_date_time,
	installed_version_status = v.status
FROM c_Config_Object o
	INNER JOIN c_Config_Object_Version v
	ON o.config_object_id = v.config_object_id
WHERE o.config_object_id = @lui_config_object_id
AND v.version = @ll_last_version

IF @@ERROR <> 0
	RETURN -1


RETURN @ll_last_version

GO
GRANT EXECUTE
	ON [dbo].[config_checkin]
	TO [cprsystem]
GO

