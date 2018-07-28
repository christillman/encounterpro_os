CREATE PROCEDURE dbo.component_install_component (
	@ps_component_xml varchar(max)
	)
AS
--
-- Returns:
-- -1 An error occured
--

DECLARE @ll_error int,
		@ll_rowcount int,
		@lx_xml xml,
		@ll_doc int


DECLARE @Component_Definition TABLE (
	[component_id] [varchar](24) NOT NULL,
	[component_type] [varchar](24) NOT NULL,
	[system_id] [varchar](24) NOT NULL,
	[system_type] [varchar](24) NOT NULL,
	[system_category] [varchar](40) NOT NULL,
	[component_install_type] [varchar](24) NULL,
	[component] [varchar](24) NOT NULL,
	[description] [varchar](80) NULL,
	[normal_version] [int] NULL,
	[testing_version] [int] NULL,
	[id] [uniqueidentifier] NOT NULL ,
	[status] [varchar](12) NOT NULL ,
	[owner_id] [int] NULL
	)

DECLARE @Component_Version TABLE (
	[component_id] [varchar](24) NOT NULL,
	[version] [int] NOT NULL ,
	[description] [varchar](80) NOT NULL,
	[version_description] [text] NULL,
	[component_type] [varchar](24) NOT NULL,
	[component_class] [varchar](128) NULL,
	[component_location] [varchar](255) NULL,
	[component_data] [varchar](255) NULL,
	[status] [varchar](12) NOT NULL ,
	[status_date_time] [datetime] NOT NULL,
	[release_status] [varchar](12) NULL ,
	[release_status_date_time] [datetime] NULL,
	[installer] [varchar](24) NOT NULL ,
	[objectdata] [varbinary] (max) NULL,
	[independence] [varchar](24) NOT NULL ,
	[system_id] [nvarchar](24) NOT NULL ,
	[build] [int] NOT NULL ,
	[build_name] [nvarchar](64) NOT NULL ,
	[compile] [int] NOT NULL ,
	[compile_name] [nvarchar](64) NOT NULL ,
	[test_begin_date] [datetime] NULL,
	[beta_begin_date] [datetime] NULL,
	[release_date] [datetime] NULL,
	[build_status] [varchar](12) NOT NULL ,
	[notes] [text] NULL,
	[min_build] [int] NOT NULL,
	[min_modification_level] [int] NOT NULL,
	[max_modification_level] [int] NULL,
	[owner_id] [int] NOT NULL ,
	[id] [uniqueidentifier] NOT NULL
	)

--------------------------------------------------------------------------
-- First load the XML data into temp tables and validate
--------------------------------------------------------------------------

SET @lx_xml = CAST(@ps_component_xml AS xml)

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

EXEC sp_xml_preparedocument @ll_doc OUTPUT, @lx_xml

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	RETURN -1
	END


INSERT INTO @Component_Definition (
	component_id
	,component_type
	,system_id
	,system_type
	,system_category
	,component_install_type
	,component
	,description
	,normal_version
	,testing_version
	,id
	,status
	,owner_id)
SELECT 	component_id
	,component_type
	,system_id
	,system_type
	,system_category
	,component_install_type
	,component
	,description
	,normal_version
	,testing_version
	,id
	,status
	,owner_id
FROM   OPENXML (@ll_doc, '/EncounterPROComponent/ComponentDefinition',2)
		WITH (	component_id varchar(24) ,
				component_type varchar(24) ,
				system_id varchar(24) ,
				system_type varchar(24) ,
				system_category varchar(40) ,
				component_install_type varchar(24) ,
				component varchar(24) ,
				description varchar(80) ,
				normal_version int ,
				testing_version int ,
				id uniqueidentifier  ,
				status varchar(12)  ,
				owner_id int 
				)

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	RETURN -1
	END

IF @ll_rowcount = 0
	BEGIN
	RAISERROR ('No Component Definition found in XML',16,-1)
	RETURN -1
	END

IF @ll_rowcount > 1
	BEGIN
	RAISERROR ('Multiple Component Definitions found in XML',16,-1)
	RETURN -1
	END


INSERT INTO @Component_Version (
	component_id
	,version
	,description
	,version_description
	,component_type
	,component_class
	,component_location
	,component_data
	,status
	,status_date_time
	,release_status
	,release_status_date_time
	,installer
	,objectdata
	,independence
	,system_id
	,build
	,build_name
	,compile
	,compile_name
	,test_begin_date
	,beta_begin_date
	,release_date
	,build_status
	,notes
	,min_build
	,min_modification_level
	,max_modification_level
	,owner_id
	,id)
SELECT component_id
	,version
	,description
	,version_description
	,component_type
	,component_class
	,component_location
	,component_data
	,status
	,status_date_time
	,release_status
	,release_status_date_time
	,installer
	,objectdata = cast(N'' as xml).value('xs:base64Binary(sql:column("objectdata"))', 'varbinary(max)')
	,independence
	,system_id
	,build
	,build_name
	,compile
	,compile_name
	,test_begin_date
	,beta_begin_date
	,release_date
	,build_status
	,notes
	,min_build
	,min_modification_level
	,max_modification_level
	,owner_id
	,id
FROM   OPENXML (@ll_doc, '/EncounterPROComponent/ComponentVersion',2)
		WITH (	component_id varchar(24) ,
				version int  ,
				description varchar(80) ,
				version_description text ,
				component_type varchar(24) ,
				component_class varchar(128) ,
				component_location varchar(255) ,
				component_data varchar(255) ,
				status varchar(12)  ,
				status_date_time datetime ,
				release_status varchar(12)  ,
				release_status_date_time datetime ,
				installer varchar(24)  ,
				objectdata varchar(max) ,
				independence varchar(24)  ,
				system_id nvarchar(24)  ,
				build int  ,
				build_name nvarchar(64)  ,
				compile int  ,
				compile_name nvarchar(64)  ,
				test_begin_date datetime ,
				beta_begin_date datetime ,
				release_date datetime ,
				build_status varchar(12)  ,
				notes text ,
				min_build int ,
				min_modification_level int ,
				max_modification_level int ,
				owner_id int  ,
				id uniqueidentifier 
				)

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	RETURN -1
	END

IF @ll_rowcount = 0
	BEGIN
	RAISERROR ('No Component Version found in XML',16,-1)
	RETURN -1
	END


--------------------------------------------------------------------------
-- Now load the component into the EncounterPRO tables
--------------------------------------------------------------------------

BEGIN TRANSACTION

UPDATE d
SET	component_id = x.component_id
	,component_type = x.component_type
	,system_id = x.system_id
	,system_type = x.system_type
	,system_category = x.system_category
	,component_install_type = x.component_install_type
	,component = x.component
	,description = x.description
	,normal_version = x.normal_version
	,testing_version = x.testing_version
	,id = x.id
	,status = x.status
	,owner_id = x.owner_id
	,last_updated = getdate()
FROM dbo.c_Component_Definition d
	INNER JOIN @Component_Definition x
	ON d.component_id = x.component_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @ll_rowcount = 0
	BEGIN
	INSERT INTO dbo.c_Component_Definition (
		component_id
		,component_type
		,system_id
		,system_type
		,system_category
		,component_install_type
		,component
		,description
		,normal_version
		,testing_version
		,id
		,status
		,owner_id
		,last_updated)
	SELECT component_id
		,component_type
		,system_id
		,system_type
		,system_category
		,component_install_type
		,component
		,description
		,normal_version
		,testing_version
		,id
		,status
		,owner_id
		,last_updated = getdate()
	FROM @Component_Definition

	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
		END
	END

UPDATE v
SET component_id = x.component_id
	,version = x.version
	,description = x.description
	,version_description = x.version_description
	,component_type = x.component_type
	,component_class = x.component_class
	,component_location = x.component_location
	,component_data = x.component_data
	,status = x.status
	,status_date_time = x.status_date_time
	,release_status = x.release_status
	,release_status_date_time = x.release_status_date_time
	,installer = x.installer
	,objectdata = x.objectdata
	,independence = x.independence
	,system_id = x.system_id
	,build = x.build
	,build_name = x.build_name
	,compile = x.compile
	,compile_name = x.compile_name
	,test_begin_date = x.test_begin_date
	,beta_begin_date = x.beta_begin_date
	,release_date = x.release_date
	,build_status = x.build_status
	,notes = x.notes
	,min_build = x.min_build
	,min_modification_level = x.min_modification_level
	,max_modification_level = x.max_modification_level
	,owner_id = x.owner_id
	,last_updated = getdate()
	,id = x.id
FROM dbo.c_Component_Version v
	INNER JOIN @Component_Version x
	ON v.component_id = x.component_id
	AND v.version = x.version

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

INSERT INTO dbo.c_Component_Version
	(component_id
	,version
	,description
	,version_description
	,component_type
	,component_class
	,component_location
	,component_data
	,status
	,status_date_time
	,release_status
	,release_status_date_time
	,installer
	,objectdata
	,independence
	,system_id
	,build
	,build_name
	,compile
	,compile_name
	,test_begin_date
	,beta_begin_date
	,release_date
	,build_status
	,notes
	,min_build
	,min_modification_level
	,max_modification_level
	,owner_id
	,created
	,created_by
	,last_updated
	,id)
SELECT component_id
	,version
	,description
	,version_description
	,component_type
	,component_class
	,component_location
	,component_data
	,status
	,status_date_time
	,release_status
	,release_status_date_time
	,installer
	,objectdata
	,independence
	,system_id
	,build
	,build_name
	,compile
	,compile_name
	,test_begin_date
	,beta_begin_date
	,release_date
	,build_status
	,notes
	,min_build
	,min_modification_level
	,max_modification_level
	,owner_id
	,created = getdate()
	,created_by = dbo.fn_current_epro_user()
	,last_updated = getdate()
	,id
FROM @Component_Version x
WHERE NOT EXISTS (
	SELECT 1
	FROM dbo.c_Component_Version v
	WHERE x.component_id = v.component_id
	AND x.version = v.version
	)

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

COMMIT TRANSACTION

EXEC sp_xml_removedocument @ll_doc

RETURN 1

