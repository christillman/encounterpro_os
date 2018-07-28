CREATE PROCEDURE config_object_versions (
	@ps_config_object_id varchar(40) ,
	@ps_min_release_status varchar(12) = 'Production',
	@ps_list_type varchar(12) = 'All')
AS
-- ps_list_type =	"Upgrade" - show only versions greater than the installed version
--						"Revert" - show only versions less than the installed version
--						"All" - show all versions



DECLARE @lui_config_object_id uniqueidentifier,
		@ll_max_release_status_number int,
		@ll_installed_version int,
		@ll_min_version int,
		@ll_max_version int,
		@ll_owner_id int,
		@ll_customer_id int

DECLARE @object TABLE (
	[version] [int] NOT NULL ,
	[version_description] [text] NULL ,
	[release_status] [varchar] (24) NOT NULL ,
	[release_status_date_time] [datetime] NULL ,
	[downloaded] [int] NOT NULL DEFAULT (0) )

DECLARE @release_status TABLE (
	[release_status] [varchar] (12) NOT NULL )

IF @ps_config_object_id IS NULL OR @ps_config_object_id = ''
	RETURN 0

SET @lui_config_object_id = CAST(@ps_config_object_id AS uniqueidentifier)

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

SELECT @ll_installed_version = installed_version,
		@ll_owner_id = owner_id
FROM c_Config_Object
WHERE config_object_id = @lui_config_object_id

IF @ll_installed_version IS NULL AND @ps_list_type IN ('Upgrade', 'Revert')
	BEGIN
	SET @ll_min_version = NULL
	SET @ll_max_version = NULL
	END
ELSE IF @ps_list_type = 'Upgrade'
	BEGIN
	SET @ll_min_version = @ll_installed_version + 1
	SET @ll_max_version = 999999
	END
ELSE IF @ps_list_type = 'Revert'
	BEGIN
	SET @ll_min_version = 0
	SET @ll_max_version = @ll_installed_version - 1
	END
ELSE
	BEGIN
	SET @ll_min_version = 0
	SET @ll_max_version = 999999
	END


-- Set up the list of release status' that we want
SET @ll_max_release_status_number = 1

INSERT INTO @release_status (release_status)
VALUES ('Production')

INSERT INTO @release_status (release_status)
VALUES ('Shareware')

IF @ps_min_release_status IN ('Beta', 'Testing')
	BEGIN
	SET @ll_max_release_status_number = 2
	
	INSERT INTO @release_status (release_status)
	VALUES ('Beta')
	END

IF @ps_min_release_status = 'Testing'
	BEGIN
	SET @ll_max_release_status_number = 3
	
	INSERT INTO @release_status (release_status)
	VALUES ('Testing')
	END


INSERT INTO @object (
	version ,
	version_description ,
	release_status ,
	release_status_date_time ,
	downloaded )
SELECT version ,
	version_description ,
	release_status ,
	release_status_date_time ,
	1
FROM c_Config_Object_Version
WHERE config_object_id = @lui_config_object_id
AND release_status IN (SELECT release_status FROM @release_status)
AND version >= @ll_min_version
AND version <= @ll_max_version


INSERT INTO @object (
	version ,
	version_description ,
	release_status ,
	release_status_date_time )
SELECT version ,
	version_description ,
	release_status ,
	release_status_date_time 
FROM jmjtech.EproUpdates.dbo.c_Config_Object_Version lv
WHERE config_object_id = @lui_config_object_id
AND release_status_number <= @ll_max_release_status_number
AND status = 'OK'
AND version >= @ll_min_version
AND version <= @ll_max_version
AND NOT EXISTS (
	SELECT 1
	FROM @object o
	WHERE o.version = lv.version )

SELECT version ,
	version_description ,
	release_status ,
	release_status_date_time ,
	downloaded ,
	selected_flag=0 ,
	local_owner_flag = CASE WHEN @ll_customer_id = @ll_owner_id THEN 1 ELSE 0 END
FROM @object

RETURN 1

