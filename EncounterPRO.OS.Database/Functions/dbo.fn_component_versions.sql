
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_component_versions]
Print 'Drop Function [dbo].[fn_component_versions]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_component_versions]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_component_versions]
GO

-- Create Function [dbo].[fn_component_versions]
Print 'Create Function [dbo].[fn_component_versions]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_component_versions (
	@ps_component_id varchar(24)
	)

RETURNS @versions TABLE (
	[component_id] [varchar](24) NOT NULL,
	[version_name] [varchar](64) NOT NULL,
	[version] [int] NOT NULL ,
	[description] [varchar](80) NOT NULL,
	[version_description] [nvarchar](max) NULL,
	[component_type] [varchar](24) NOT NULL,
	[component_class] [varchar](128) NULL,
	[component_location] [varchar](255) NULL,
	[component_data] [varchar](255) NULL,
	[status] [varchar](12) NOT NULL ,
	[status_date_time] [datetime] NULL,
	[release_status] [varchar](12) NULL ,
	[release_status_date_time] [datetime] NULL,
	[installer] [varchar](24) NULL ,
	[independence] [varchar](24) NULL ,
	[system_id] [nvarchar](24) NULL ,
	[build] [int] NULL ,
	[build_name] [nvarchar](64) NULL ,
	[compile] [int] NULL ,
	[compile_name] [nvarchar](64) NULL ,
	[test_begin_date] [datetime] NULL,
	[beta_begin_date] [datetime] NULL,
	[release_date] [datetime] NULL,
	[build_status] [varchar](12) NULL ,
	[notes] [nvarchar](max) NULL,
	[min_build] [int] NULL,
	[min_modification_level] [int] NULL,
	[max_modification_level] [int] NULL,
	[owner_id] [int] NOT NULL ,
	[owner_description] [varchar] (80) NOT NULL ,
	[created] [datetime] NULL ,
	[created_by] [varchar](24) NULL,
	[last_updated] [datetime] NULL ,
	[id] [uniqueidentifier] NOT NULL
	)
AS

BEGIN

DECLARE @ll_normal_version int,
		@ll_error int,
		@ll_rowcount int

SELECT @ll_normal_version = normal_version
FROM dbo.fn_components()
WHERE component_id = @ps_component_id


INSERT INTO @versions (
	component_id
	,version_name
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
	,owner_description
	,created
	,created_by
	,last_updated
	,id )
SELECT component_id
		,compile_name
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
		,dbo.fn_owner_description(owner_id)
		,created
		,created_by
		,last_updated
		,id
FROM c_Component_Version
WHERE component_id = @ps_component_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

-- Add the "Default" version record
INSERT INTO @versions (
	component_id
	,version_name
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
	,owner_description
	,created
	,created_by
	,last_updated
	,id )
SELECT component_id
		,'Default'
		,0
		,description
		,version_description = CAST(NULL AS varchar(24))
		,component_type
		,component_class
		,component_location
		,component_data
		,status
		,status_date_time = 	CAST(NULL AS datetime)
		,release_status = CAST(NULL AS varchar(24))
		,release_status_date_time = 	CAST(NULL AS datetime)
		,installer = CAST(NULL AS varchar(24))
		,independence = 'Integrated'
		,system_id = CAST(NULL AS varchar(24))
		,build = CAST(NULL AS int)
		,build_name = CAST(NULL AS varchar(24))
		,compile = CAST(NULL AS int)
		,compile_name = CAST(NULL AS varchar(24))
		,test_begin_date = 	CAST(NULL AS datetime)
		,beta_begin_date = 	CAST(NULL AS datetime)
		,release_date = 	CAST(NULL AS datetime)
		,build_status = CAST(NULL AS varchar(24))
		,notes = CAST(NULL AS varchar(24))
		,min_build = CAST(NULL AS int)
		,min_modification_level = CAST(NULL AS int)
		,max_modification_level = CAST(NULL AS int)
		,owner_id = 0
		,dbo.fn_owner_description(0)
		,created = 	CAST(NULL AS datetime)
		,created_by = CAST(NULL AS varchar(24))
		,last_updated = 	CAST(NULL AS datetime)
		,id
FROM c_Component_Registry
WHERE component_id = @ps_component_id

RETURN

END

GO
GRANT SELECT
	ON [dbo].[fn_component_versions]
	TO [cprsystem]
GO

