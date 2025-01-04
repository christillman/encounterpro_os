
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
CREATE FUNCTION dbo.fn_latest_scripts (
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

IF @ls_system_id IS NULL
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
GRANT SELECT ON [dbo].[fn_latest_scripts] TO [cprsystem]
GO

