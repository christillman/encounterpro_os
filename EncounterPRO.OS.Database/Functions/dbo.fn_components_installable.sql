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

-- Drop Function [dbo].[fn_components_installable]
Print 'Drop Function [dbo].[fn_components_installable]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_components_installable]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_components_installable]
GO

-- Create Function [dbo].[fn_components_installable]
Print 'Create Function [dbo].[fn_components_installable]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_components_installable (
	@pl_computer_id int
	)

RETURNS @components TABLE (
	[component_id] [varchar](24) NOT NULL,
	[component_type] [varchar](24) NOT NULL,
	[component_install_type] [varchar](24) NULL,
	[component] [varchar](24) NOT NULL,
	[component_base_class] [varchar](128) NULL,
	[component_wrapper_class] [varchar](255) NULL,
	[description] [varchar](80) NULL,
	[license_data] [varchar](2000) NULL,
	[license_status] [varchar](24) NOT NULL ,
	[license_expiration_date] [datetime] NULL,
	[normal_or_testing] [char] (1) NOT NULL,
	[version] [int] NULL,
	[version_name] [varchar] (64) NULL,
	[component_class] [varchar](128) NULL,
	[component_location] [varchar](255) NULL,
	[component_data] [varchar](255) NULL,
	[release_status] [varchar] (12) NULL ,
	[release_status_date_time] [datetime] NULL ,
	[installer] [varchar] (24) NOT NULL ,
	[independence] [varchar] (24) NOT NULL ,
	[id] [uniqueidentifier] NOT NULL ,
	[status] [varchar](12) NOT NULL ,
	[owner_id] [int] NULL,
	[created] [datetime] NOT NULL ,
	[last_updated] [datetime] NULL
	)
AS

BEGIN

DECLARE @ls_computer_id varchar(40),
		@ls_component_trial_mode varchar(255)

SET @ls_computer_id = CAST(@pl_computer_id AS varchar(40))

SET @ls_component_trial_mode = dbo.fn_get_specific_preference('SYSTEM', 'Computer', @ls_computer_id, 'Component Trial Mode')
IF LEFT(@ls_component_trial_mode, 1) IN ('T', 'Y')
	BEGIN
	INSERT INTO @components (
		component_id
		,component_type
		,component_install_type
		,component
		,component_base_class
		,component_wrapper_class
		,description
		,license_data
		,license_status
		,license_expiration_date
		,normal_or_testing
		,version
		,version_name
		,component_class
		,component_location
		,component_data
		,release_status
		,release_status_date_time
		,installer
		,independence
		,id
		,status
		,owner_id
		,created
		,last_updated )
	SELECT d.component_id
			,d.component_type
			,d.component_install_type
			,d.component
			,t.base_class
			,t.component_wrapper_class
			,d.description
			,d.license_data
			,d.license_status
			,d.license_expiration_date
			,'T'
			,v.version
			,v.compile_name
			,v.component_class
			,v.component_location
			,v.component_data
			,v.release_status
			,v.release_status_date_time
			,v.installer
			,v.independence
			,d.id
			,d.status
			,d.owner_id
			,d.created
			,d.last_updated
	FROM dbo.c_Component_Definition d
		INNER JOIN c_Component_Type t
		ON d.component_type = t.component_type
		INNER JOIN c_Component_Version v
		ON d.component_id = v.component_id
		AND d.testing_version = v.version
	WHERE v.independence IN ('Single', 'Multi')
	END

INSERT INTO @components (
	component_id
	,component_type
	,component_install_type
	,component
	,component_base_class
	,component_wrapper_class
	,description
	,license_data
	,license_status
	,license_expiration_date
	,normal_or_testing
	,version
	,version_name
	,component_class
	,component_location
	,component_data
	,release_status
	,release_status_date_time
	,installer
	,independence
	,id
	,status
	,owner_id
	,created
	,last_updated )
SELECT d.component_id
		,d.component_type
		,d.component_install_type
		,d.component
		,t.base_class
		,t.component_wrapper_class
		,d.description
		,d.license_data
		,d.license_status
		,d.license_expiration_date
		,'N'
		,v.version
		,v.compile_name
		,v.component_class
		,v.component_location
		,v.component_data
		,v.release_status
		,v.release_status_date_time
		,v.installer
		,v.independence
		,d.id
		,d.status
		,d.owner_id
		,d.created
		,d.last_updated
FROM dbo.c_Component_Definition d
	INNER JOIN c_Component_Type t
	ON d.component_type = t.component_type
	INNER JOIN c_Component_Version v
	ON d.component_id = v.component_id
	AND d.normal_version = v.version
WHERE v.independence IN ('Single', 'Multi')
AND NOT EXISTS (
	SELECT 1
	FROM @components x
	WHERE x.component_id = d.component_id)


RETURN

END

GO
GRANT SELECT
	ON [dbo].[fn_components_installable]
	TO [cprsystem]
GO

