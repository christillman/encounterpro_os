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

-- Drop Function [dbo].[fn_components]
Print 'Drop Function [dbo].[fn_components]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_components]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_components]
GO

-- Create Function [dbo].[fn_components]
Print 'Create Function [dbo].[fn_components]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_components ()

RETURNS @components TABLE (
	[component_id] [varchar](24) NOT NULL,
	[component_type] [varchar](24) NOT NULL,
	[system_id] [varchar](24) NULL,
	[system_type] [varchar](24) NULL,
	[system_category] [varchar](40) NULL,
	[component_install_type] [varchar](24) NULL,
	[component] [varchar](24) NOT NULL,
	[component_base_class] [varchar](128) NULL,
	[component_wrapper_class] [varchar](255) NULL,
	[description] [varchar](80) NULL,
	[license_data] [varchar](2000) NULL,
	[license_status] [varchar](24) NOT NULL ,
	[license_expiration_date] [datetime] NULL,
	[normal_version] [int] NULL,
	[normal_version_name] [varchar] (64) NULL,
	[testing_version] [int] NULL,
	[testing_version_name] [varchar] (64) NULL,
	[testing_started] [datetime] NULL,
	[testing_expiration] [datetime] NULL,
	[latest_production_version] [int] NULL,
	[latest_production_version_name] [varchar] (64) NULL,
	[latest_beta_version] [int] NULL,
	[latest_beta_version_name] [varchar] (64) NULL,
	[latest_testing_version] [int] NULL,
	[latest_testing_version_name] [varchar] (64) NULL,
	[id] [uniqueidentifier] NOT NULL ,
	[status] [varchar](12) NOT NULL ,
	[owner_id] [int] NULL,
	[created] [datetime] NOT NULL ,
	[last_updated] [datetime] NULL
	)
AS

BEGIN

DECLARE @ls_database_mode varchar(16),
		@li_beta_flag smallint,
		@ls_component_trial_mode_duration varchar(255)

SELECT @ls_database_mode = database_mode,
		@li_beta_flag = beta_flag
FROM c_Database_Status

IF @ls_database_mode = 'Testing'
	SET @li_beta_flag = 1

INSERT INTO @components (
	component_id
	,component_type
	,system_id
	,system_type
	,system_category
	,component_install_type
	,component
	,component_base_class
	,component_wrapper_class
	,description
	,license_data
	,license_status
	,license_expiration_date
	,normal_version
	,normal_version_name
	,testing_version
	,testing_version_name
	,id
	,status
	,owner_id
	,created
	,last_updated )
SELECT d.component_id
		,d.component_type
		,d.system_id
		,d.system_type
		,d.system_category
		,d.component_install_type
		,d.component
		,t.base_class
		,t.component_wrapper_class
		,d.description
		,d.license_data
		,d.license_status
		,d.license_expiration_date
		,d.normal_version
		,v1.compile_name
		,d.testing_version
		,v2.compile_name
		,d.id
		,d.status
		,d.owner_id
		,d.created
		,d.last_updated
FROM dbo.c_Component_Definition d
	INNER JOIN c_Component_Type t
	ON d.component_type = t.component_type
	LEFT OUTER JOIN c_Component_Version v1
	ON d.component_id = v1.component_id
	AND d.normal_version = v1.version
	LEFT OUTER JOIN c_Component_Version v2
	ON d.component_id = v2.component_id
	AND d.testing_version = v2.version

INSERT INTO @components (
	component_id
	,component_type
	,system_id
	,system_type
	,system_category
	,component_install_type
	,component
	,component_base_class
	,component_wrapper_class
	,description
	,license_data
	,license_status
	,license_expiration_date
	,normal_version
	,normal_version_name
	,testing_version
	,testing_version_name
	,id
	,status
	,owner_id
	,created
	,last_updated )
SELECT r.component_id
	,r.component_type
	,system_id = NULL
	,system_type = NULL
	,system_category = NULL
	,component_install_type = 'NA'
	,r.component
	,t.base_class
	,t.component_wrapper_class
	,r.description
	,r.license_data
	,r.license_status
	,r.license_expiration_date
	,normal_version = 0
	,normal_version_name = 'NA'
	,testing_version = 0
	,testing_version_name = 'NA'
	,r.id
	,r.status
	,owner_id = 0
	,r.created
	,last_updated = NULL
FROM dbo.c_Component_Registry r
	INNER JOIN c_Component_Type t
	ON r.component_type = t.component_type
WHERE NOT EXISTS (
	SELECT 1
	FROM @components x
	WHERE r.component_id = x.component_id)


-------------------------------------------------------
-- Populate latest_production_version
-------------------------------------------------------
UPDATE c
SET latest_production_version = x.latest_production_version
FROM @components c
	INNER JOIN (SELECT component_id, latest_production_version = max(version)
				FROM c_component_version
				WHERE release_status = 'Production'
				GROUP BY component_id) x
	ON c.component_id = x.component_id

UPDATE c
SET latest_production_version_name = v.compile_name
FROM @components c
	INNER JOIN c_component_version v
	ON c.component_id = v.component_id
	AND c.latest_production_version = v.version

-------------------------------------------------------
-- Populate latest_beta_version
-------------------------------------------------------
IF @li_beta_flag <> 0
	BEGIN
	UPDATE c
	SET latest_beta_version = x.latest_beta_version
	FROM @components c
		INNER JOIN (SELECT component_id, latest_beta_version = max(version)
					FROM c_component_version
					WHERE release_status = 'Beta'
					GROUP BY component_id) x
		ON c.component_id = x.component_id

	UPDATE c
	SET latest_beta_version_name = v.compile_name
	FROM @components c
		INNER JOIN c_component_version v
		ON c.component_id = v.component_id
		AND c.latest_beta_version = v.version
	END

-------------------------------------------------------
-- Populate latest_testing_version
-------------------------------------------------------
IF @ls_database_mode = 'Testing'
	BEGIN
	UPDATE c
	SET latest_testing_version = x.latest_testing_version
	FROM @components c
		INNER JOIN (SELECT component_id, latest_testing_version = max(version)
					FROM c_component_version
					WHERE release_status = 'Testing'
					GROUP BY component_id) x
		ON c.component_id = x.component_id

	UPDATE c
	SET latest_testing_version_name = v.compile_name
	FROM @components c
		INNER JOIN c_component_version v
		ON c.component_id = v.component_id
		AND c.latest_testing_version = v.version
	END

SET @ls_component_trial_mode_duration = dbo.fn_get_preference('SYSTEM', 'Component Trial Mode Duration', NULL, NULL)
IF @ls_component_trial_mode_duration IS NULL
	SET @ls_component_trial_mode_duration = '1 DAY'

UPDATE c
SET testing_started = x.testing_started,
	testing_expiration = dbo.fn_date_add_interval_string(x.testing_started, @ls_component_trial_mode_duration)
FROM @components c
	INNER JOIN (SELECT component_id, version, max(operation_date_time) as testing_started
				FROM c_component_log
				WHERE operation = 'Trial Started'
				GROUP BY component_id, version) x
	ON c.component_id = x.component_id
	AND c.testing_version = x.version

-- Clear out the trials that either don't have an expiration or have already expired
UPDATE c
SET testing_version = NULL,
	testing_version_name = NULL,
	testing_started = NULL,
	testing_expiration = NULL
FROM @components c
WHERE testing_started IS NULL
OR testing_expiration IS NULL
OR testing_expiration < dbo.get_client_datetime()

RETURN

END

GO
GRANT SELECT
	ON [dbo].[fn_components]
	TO [cprsystem]
GO

