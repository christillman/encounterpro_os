--EncounterPRO Open Source Project
--
--Copyright 2010-2011 The EncounterPRO Foundation, Inc.
--
--This program is free software: you can redistribute it and/or modify it under the terms of 
--the GNU Affero General Public License as published by the Free Software Foundation, either 
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Affero General Public License for more details.
--
--You should have received a copy of the GNU Affero General Public License along with this 
--program. If not, see http://www.gnu.org/licenses.
--
--EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero 
--General Public License version 3, or any later version. As such, linking the Project 
--statically or dynamically with other components is making a combined work based on the 
--Project. Thus, the terms and conditions of the GNU Affero General Public License version 3, 
--or any later version, cover the whole combination.
--
--However, as an additional permission, the copyright holders of EncounterPRO Open Source 
--Project give you permission to link the Project with independent components, regardless of 
--the license terms of these independent components, provided that all of the following are true:
--
--1. All access from the independent component to persisted data which resides
--   inside any EncounterPRO Open Source data store (e.g. SQL Server database) 
--   be made through a publically available database driver (e.g. ODBC, SQL 
--   Native Client, etc) or through a service which itself is part of The Project.
--2. The independent component does not create or rely on any code or data 
--   structures within the EncounterPRO Open Source data store unless such 
--   code or data structures, and all code and data structures referred to 
--   by such code or data structures, are themselves part of The Project.
--3. The independent component either a) runs locally on the user's computer,
--   or b) is linked to at runtime by The Project’s Component Manager object 
--   which in turn is called by code which itself is part of The Project.
--
--An independent component is a component which is not derived from or based on the Project.
--If you modify the Project, you may extend this additional permission to your version of 
--the Project, but you are not obligated to do so. If you do not wish to do so, delete this 
--additional permission statement from your version.
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

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
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE dbo.config_import_object (
	@px_objectdata xml
	)
AS
--
-- Returns:
-- -1 An error occured
--

DECLARE @ll_error int,
		@ll_rowcount int,
		@lx_xml xml,
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
	[long_description] [text] NULL,
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
	[version_description] [text] NULL,
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

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
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
					long_description text ,
					config_object_category varchar(80) ,
					owner_id int  ,
					owner_description varchar(80) ,
					created datetime  ,
					created_by varchar(24) ,
					status varchar(12)  ,
					copyright_status varchar(24)  ,
					copyable bit  
			)

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
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
					version_description text ,
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

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
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

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

SET @ls_config_object_id = CAST(@lui_config_object_id AS varchar(40))

SELECT @ls_existing_config_object_type = config_object_type,
		@ll_existing_owner_id = owner_id
FROM c_Config_Object
WHERE config_object_id = @lui_config_object_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

IF @ll_rowcount = 1
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
	
	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
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

	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
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
	
	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
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

	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
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

