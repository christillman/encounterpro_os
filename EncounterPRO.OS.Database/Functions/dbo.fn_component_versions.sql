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
	[version_description] [text] NULL,
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
	[notes] [text] NULL,
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

