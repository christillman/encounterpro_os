
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[config_import_object]
Print 'Drop Procedure [dbo].[config_import_object]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[config_import_object]') AND [type]='P'))
DROP PROCEDURE [dbo].[config_import_object]
GO

-- Create Procedure [dbo].[config_import_object]
Print 'Create Procedure [dbo].[config_import_object]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.config_import_object (
	@px_objectdata xml
	)
AS
--
-- Returns:
-- -1 An error occured
--

DECLARE @lx_xml xml,
		@lui_config_object_id uniqueidentifier ,
		@ls_config_object_id varchar(40) ,
		@ls_config_object_type varchar(24) ,
		@ll_owner_id int ,
		@ll_doc int,
		@ls_existing_config_object_type varchar(24) ,
		@ll_existing_owner_id int ,
		@ll_version int

DECLARE @config_object TABLE (
	[config_object_id] [uniqueidentifier] NOT NULL,
	[config_object_type] [varchar](24) NOT NULL,
	[context_object] [varchar](24) NOT NULL,
	[description] [varchar](80) NOT NULL,
	[long_description] [nvarchar](max) NULL,
	[config_object_category] [varchar](80) NULL,
	[owner_id] [int] NOT NULL ,
	[owner_description] [varchar](80) NOT NULL,
	[created] [datetime] NOT NULL ,
	[created_by] [varchar](24) NOT NULL,
	[status] [varchar](12) NOT NULL ,
	[copyright_status] [varchar](24) NOT NULL ,
	[copyable] [bit] NOT NULL 
	)

DECLARE @version TABLE (
	[config_object_id] [uniqueidentifier] NOT NULL,
	[version] [int] NOT NULL ,
	[description] [varchar](80) NOT NULL,
	[version_description] [nvarchar](max) NULL,
	[config_object_type] [varchar](24) NOT NULL,
	[owner_id] [int] NOT NULL ,
	[created] [datetime] NOT NULL ,
	[created_by] [varchar](24) NOT NULL,
	[created_from_version] [int] NULL,
	[status] [varchar](12) NOT NULL ,
	[status_date_time] [datetime] NOT NULL,
	[release_status] [varchar](12) NULL,
	[release_status_date_time] [datetime] NULL,
	[object_encoding_method] [varchar](12) NULL
	)


EXEC sp_xml_preparedocument @ll_doc OUTPUT, @px_objectdata

IF @@ERROR <> 0
	RETURN -1

INSERT INTO @config_object (
	[config_object_id] ,
	[config_object_type] ,
	[context_object] ,
	[description] ,
	[long_description] ,
	[config_object_category] ,
	[owner_id] ,
	[owner_description] ,
	[created] ,
	[created_by] ,
	[status] ,
	[copyright_status] ,
	[copyable] )
SELECT [config_object_id] ,
	[config_object_type] ,
	[context_object] ,
	[description] ,
	[long_description] ,
	[config_object_category] ,
	[owner_id] ,
	[owner_description] ,
	[created] ,
	[created_by] ,
	[status] ,
	[copyright_status] ,
	[copyable]
FROM   OPENXML (@ll_doc, '/EPConfigObjects/ConfigObject',1)
		WITH (		config_object_id uniqueidentifier ,
					config_object_type varchar(24) ,
					context_object varchar(24) ,
					description varchar(80) ,
					long_description varchar(max) ,
					config_object_category varchar(80) ,
					owner_id int  ,
					owner_description varchar(80) ,
					created datetime  ,
					created_by varchar(24) ,
					status varchar(12)  ,
					copyright_status varchar(24)  ,
					copyable bit  
			)

IF @@ERROR <> 0
	RETURN -1

INSERT INTO @version (
	[config_object_id] ,
	[version] ,
	[description] ,
	[version_description] ,
	[config_object_type] ,
	[owner_id] ,
	[created] ,
	[created_by] ,
	[created_from_version] ,
	[status] ,
	[status_date_time] ,
	[release_status] ,
	[release_status_date_time] ,
	[object_encoding_method] )
SELECT 	[config_object_id] ,
	[version] ,
	[description] ,
	[version_description] ,
	[config_object_type] ,
	[owner_id] ,
	[created] ,
	[created_by] ,
	[created_from_version] ,
	[status] ,
	[status_date_time] ,
	[release_status] ,
	[release_status_date_time] ,
	[object_encoding_method]
FROM   OPENXML (@ll_doc, '/EPConfigObjects/ConfigObjectVersion',1)
		WITH (		config_object_id uniqueidentifier ,
					version int  ,
					description varchar(80) ,
					version_description varchar(max) ,
					config_object_type varchar(24) ,
					owner_id int  ,
					created datetime  ,
					created_by varchar(24) ,
					created_from_version int ,
					status varchar(12)  ,
					status_date_time datetime ,
					release_status varchar(12) ,
					release_status_date_time datetime ,
					object_encoding_method varchar(12) 
			)

IF @@ERROR <> 0
	RETURN -1

IF (SELECT count(*) FROM @config_object) <> 1
	BEGIN
	RAISERROR ('The document contains multiple ConfigObject records',16,-1)
	RETURN -1
	END

IF (SELECT count(*) FROM @version) <> 1
	BEGIN
	RAISERROR ('The document contains multiple ConfigObjectVersion records',16,-1)
	RETURN -1
	END

-- Make sure the config objects are registered
SELECT @lui_config_object_id = config_object_id,
		@ls_config_object_type = config_object_type,
		@ll_owner_id = owner_id
FROM @config_object

IF @@ERROR <> 0
	RETURN -1

SET @ls_config_object_id = CAST(@lui_config_object_id AS varchar(40))

SELECT @ls_existing_config_object_type = config_object_type,
		@ll_existing_owner_id = owner_id
FROM c_Config_Object
WHERE config_object_id = @lui_config_object_id

IF @@ERROR <> 0
	RETURN -1

IF @ll_existing_owner_id IS NOT NULL
	BEGIN
	IF @ls_existing_config_object_type <> @ls_config_object_type
		BEGIN
		RAISERROR ('The document already exists but is of the wrong type (%s, %s, %s)',16,-1, @ls_config_object_id, @ls_config_object_type, @ls_existing_config_object_type)
		RETURN -1
		END
	
	IF @ll_existing_owner_id <> @ll_owner_id
		BEGIN
		RAISERROR ('The document already exists but has the wrong owner (%s, %d, %d)',16,-1, @ls_config_object_id, @ll_owner_id, @ll_existing_owner_id)
		RETURN -1
		END

	UPDATE c
	SET context_object = x.context_object,
		description = x.description,
		long_description = x.long_description,
		config_object_category = x.config_object_category,
		copyright_status = x.copyright_status,
		copyable = x.copyable
	FROM c_Config_Object c
		INNER JOIN @config_object x
		ON c.config_object_id = x.config_object_id
	
	IF @@ERROR <> 0
		RETURN -1
	END
ELSE
	BEGIN
	INSERT INTO c_Config_Object (
		[config_object_id] ,
		[config_object_type] ,
		[context_object] ,
		[description] ,
		[long_description] ,
		[config_object_category] ,
		[owner_id] ,
		[owner_description] ,
		[created] ,
		[created_by] ,
		[status] ,
		[copyright_status] ,
		[copyable] )
	SELECT [config_object_id] ,
		[config_object_type] ,
		[context_object] ,
		[description] ,
		[long_description] ,
		[config_object_category] ,
		[owner_id] ,
		[owner_description] ,
		[created] ,
		[created_by] ,
		[status] ,
		[copyright_status] ,
		[copyable]
	FROM @config_object

	IF @@ERROR <> 0
		RETURN -1
	END

SELECT @ll_version = version
FROM @version

IF EXISTS(SELECT 1 FROM c_Config_Object_Version WHERE config_object_id = @lui_config_object_id AND version = @ll_version)
	BEGIN
	UPDATE v
	SET	description = x.description,
		version_description = x.version_description,
		config_object_type = x.config_object_type,
		owner_id = x.owner_id,
		created_from_version = x.created_from_version,
		release_status = x.release_status,
		release_status_date_time = x.release_status_date_time,
		object_encoding_method = x.object_encoding_method
	FROM c_Config_Object_Version v
		INNER JOIN @version x
		ON v.config_object_id = x.config_object_id
		AND v.version = x.version
	
	IF @@ERROR <> 0
		RETURN -1
	END
ELSE
	BEGIN
	INSERT INTO c_Config_Object_Version (
		[config_object_id] ,
		[version] ,
		[description] ,
		[version_description] ,
		[config_object_type] ,
		[owner_id] ,
		[created] ,
		[created_by] ,
		[created_from_version] ,
		[status] ,
		[status_date_time] ,
		[release_status] ,
		[release_status_date_time] ,
		[object_encoding_method] )
	SELECT 	[config_object_id] ,
		[version] ,
		[description] ,
		[version_description] ,
		[config_object_type] ,
		[owner_id] ,
		[created] ,
		[created_by] ,
		[created_from_version] ,
		[status] ,
		[status_date_time] ,
		[release_status] ,
		[release_status_date_time] ,
		[object_encoding_method]
	FROM @version

	IF @@ERROR <> 0
		RETURN -1
	END

UPDATE c_Config_Object_Version
SET objectdata = CAST(@px_objectdata AS varbinary(max))

EXEC sp_xml_removedocument @ll_doc

RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[config_import_object]
	TO [cprsystem]
GO

