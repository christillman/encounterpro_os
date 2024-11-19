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

-- Drop Function [dbo].[fn_latest_scripts]
Print 'Drop Function [dbo].[fn_latest_scripts]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_latest_scripts]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_latest_scripts]
GO

-- Create Function [dbo].[fn_latest_scripts]
Print 'Create Function [dbo].[fn_latest_scripts]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_latest_scripts (
	@ps_script_type varchar(24),
	@pl_major_release int,
	@ps_database_version varchar(4),
	@pl_modification_level int)

RETURNS @latest_scripts TABLE (
	[script_id] [int] NOT NULL ,
	[script_type] [varchar] (24) NOT NULL ,
	[system_id] [varchar] (24) NULL ,
	[major_release] [int] NOT NULL ,
	[database_version] [varchar] (4) NOT NULL ,
	[script_name] [varchar] (255) NOT NULL ,
	[description] [varchar] (255) NOT NULL ,
	[db_script] [nvarchar](max) NULL ,
	[last_executed] [datetime] NULL ,
	[last_completion_status] [varchar] (12) NULL ,
	[status] [varchar] (12) NOT NULL ,
	[id] [uniqueidentifier] NOT NULL ,
	[modification_level] [int] NULL ,
	[sort_sequence] [int] NULL ,
	[comment] [nvarchar](max) NULL,
	[allow_users] [bit] NOT NULL )

AS

BEGIN

DECLARE @ls_system_id varchar(24),
		@li_current_only_flag smallint,
		@ls_maintenance_mode varchar(24),
		@ls_maintenance_group varchar(24),
		@ll_db_modification_level int,
		@ll_latest_modification_level int

-- First get the info about this script_type
SELECT @ls_system_id = system_id,
		@li_current_only_flag = current_only_flag,
		@ls_maintenance_mode = maintenance_mode,
		@ls_maintenance_group = maintenance_group
FROM c_Database_Script_Type
WHERE script_type = @ps_script_type

IF @@ROWCOUNT = 0
	BEGIN
	SET @li_current_only_flag = 0
	SET	@ls_maintenance_mode = 'Standard'
	SET	@ls_maintenance_group = NULL
	SET @ls_system_id = CASE @ps_script_type
						WHEN 'Config' THEN 'Config'
						WHEN 'Hotfix' THEN 'Hotfix'
						WHEN 'Migration24' THEN 'Migration24'
						WHEN 'Migration24 Prep' THEN 'Migration24'
						WHEN 'Reports' THEN 'Reports'
						WHEN 'Utility' THEN 'Utility'
						WHEN 'Database' THEN 'Database'
						WHEN 'Constraint' THEN 'Database'
						WHEN 'TableCreate' THEN 'Database' 
						ELSE NULL END
	END

-- Get info about the current database status
SELECT @pl_major_release = ISNULL(@pl_major_release, major_release),
	@ps_database_version = ISNULL(@ps_database_version, database_version),
	@ll_db_modification_level = modification_level
FROM c_Database_Status

-- If the mod level is not specified, then fugure out the latest one
-- which is OK for this DB mod level
IF @pl_modification_level IS NULL
	SET @pl_modification_level = dbo.fn_latest_system_version(@ls_system_id, @pl_major_release, @ps_database_version, @ll_db_modification_level)

IF @li_current_only_flag = 0
	BEGIN

	-- Declare the table to hold the scripts
	DECLARE @scripts TABLE (
		script_name varchar(255) NOT NULL,
		modification_level int NULL,
		script_id int NULL )

	-- Get a list of the distinct scripts
	INSERT INTO @scripts (
		script_name )	
	SELECT DISTINCT script_name
	FROM c_database_script
	WHERE script_type = @ps_script_type
	AND major_release = @pl_major_release
	AND database_version = @ps_database_version
	AND modification_level <= @pl_modification_level
	AND status = 'OK'

	IF @ls_system_id = 'Database'
		UPDATE s
		SET modification_level = x.modification_level
		FROM @scripts s
			INNER JOIN (SELECT s.script_name, modification_level = max(s.modification_level)
						FROM c_Database_Script s
						WHERE s.script_type = @ps_script_type
						AND s.major_release = @pl_major_release
						AND s.database_version = @ps_database_version
						AND s.modification_level <= @pl_modification_level
						AND s.status = 'OK'
						GROUP BY script_name) x
			ON s.script_name = x.script_name
	ELSE
		UPDATE s
		SET modification_level = x.modification_level
		FROM @scripts s
			INNER JOIN (SELECT s.script_name, modification_level = max(s.modification_level)
						FROM c_Database_Script s
							INNER JOIN c_Database_Modification_Dependancy d
							ON s.system_id = d.system_id
							AND s.major_release = d.major_release
							AND s.database_version = d.database_version
							AND s.modification_level = d.modification_level
						WHERE s.script_type = @ps_script_type
						AND s.major_release = @pl_major_release
						AND s.database_version = @ps_database_version
						AND s.modification_level <= @pl_modification_level
						AND s.status = 'OK'
						AND d.min_database_modification_level <= @ll_db_modification_level
						AND ISNULL(d.max_database_modification_level, @ll_db_modification_level) >= @ll_db_modification_level
						GROUP BY script_name) x
			ON s.script_name = x.script_name

	UPDATE s
	SET script_id = x.script_id
	FROM @scripts s
		INNER JOIN (SELECT script_name, modification_level, script_id = max(script_id)
					FROM c_Database_Script
					WHERE script_type = @ps_script_type
					AND major_release = @pl_major_release
					AND database_version = @ps_database_version
					AND status = 'OK'
					GROUP BY script_name, modification_level) x
		ON s.script_name = x.script_name
		AND s.modification_level = x.modification_level


	INSERT INTO @latest_scripts (
		[script_id] ,
		[script_type] ,
		[system_id] ,
		[major_release] ,
		[database_version] ,
		[script_name] ,
		[description] ,
		[db_script] ,
		[last_executed] ,
		[last_completion_status] ,
		[status] ,
		[id] ,
		[modification_level] ,
		[sort_sequence] ,
		[comment],
		[allow_users] )
	SELECT s.script_id ,
		s.script_type ,
		s.system_id ,
		s.major_release ,
		s.database_version ,
		s.script_name ,
		s.description ,
		s.db_script ,
		s.last_executed ,
		s.last_completion_status ,
		s.status ,
		s.id ,
		s.modification_level ,
		s.sort_sequence ,
		s.comment,
		s.allow_users
	FROM c_Database_Script s
		INNER JOIN @scripts x
		ON s.script_id = x.script_id

	END
ELSE
	BEGIN
	-- Determine the latest mod level for this system that is legal under the
	-- current database mod level
	
	IF @ls_system_id = 'Database'
		SET @ll_latest_modification_level = @ll_db_modification_level
	ELSE
		SELECT @ll_latest_modification_level = max(modification_level)
		FROM c_Database_Modification_Dependancy
		WHERE system_id = @ls_system_id
		AND major_release = @pl_major_release
		AND database_version = @ps_database_version
		AND min_database_modification_level <= @ll_db_modification_level
		AND ISNULL(max_database_modification_level, @ll_db_modification_level) >= @ll_db_modification_level
	
	INSERT INTO @latest_scripts (
		[script_id] ,
		[script_type] ,
		[system_id] ,
		[major_release] ,
		[database_version] ,
		[script_name] ,
		[description] ,
		[db_script] ,
		[last_executed] ,
		[last_completion_status] ,
		[status] ,
		[id] ,
		[modification_level] ,
		[sort_sequence] ,
		[comment],
		[allow_users] )
	SELECT [script_id] ,
		[script_type] ,
		[system_id] ,
		[major_release] ,
		[database_version] ,
		[script_name] ,
		[description] ,
		[db_script] ,
		[last_executed] ,
		[last_completion_status] ,
		[status] ,
		[id] ,
		[modification_level] ,
		[sort_sequence] ,
		[comment] ,
		[allow_users]
	FROM c_Database_Script
	WHERE script_type = @ps_script_type
	AND major_release = @pl_major_release
	AND database_version = @ps_database_version
	AND modification_level = @ll_latest_modification_level
	AND status = 'OK'
	END


RETURN
END

GO
GRANT SELECT
	ON [dbo].[fn_latest_scripts]
	TO [cprsystem]
GO

