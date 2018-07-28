CREATE PROCEDURE jmj_get_database_reset_scripts (
	@pl_db_major_release int,
	@ps_db_database_version varchar(4),
	@pl_db_modification_level int)

AS

DECLARE @latest_scripts TABLE (
	[script_id] [int] NOT NULL ,
	[script_type] [varchar] (24) NOT NULL ,
	[system_id] [varchar] (24) NULL ,
	[major_release] [int] NOT NULL ,
	[database_version] [varchar] (4) NOT NULL ,
	[script_name] [varchar] (255) NOT NULL ,
	[description] [varchar] (255) NOT NULL ,
	[db_script] [text] NULL ,
	[last_executed] [datetime] NULL ,
	[last_completion_status] [varchar] (12) NULL ,
	[status] [varchar] (12) NOT NULL ,
	[id] [uniqueidentifier] NOT NULL ,
	[modification_level] [int] NULL ,
	[sort_sequence] [int] NULL ,
	[comment] [text] NULL,
	[allow_users] [bit] NOT NULL )


DECLARE @ll_major_release int,
		@ls_database_version varchar(4),
		@ll_modification_level int,
		@ls_database_reset_system_id varchar(24),
		@ls_database_reset_script_type varchar(24)

SET @ls_database_reset_system_id = 'Database Reset'
SET @ls_database_reset_script_type = 'Database Reset'
 
SELECT	@ll_major_release = major_release,
		@ls_database_version = database_version,
		@ll_modification_level = modification_level
FROM dbo.fn_latest_system_version_for_db_version (	@ls_database_reset_system_id,
													@pl_db_major_release ,
													@ps_db_database_version ,
													@pl_db_modification_level )


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
FROM dbo.fn_latest_scripts(@ls_database_reset_script_type,
	@ll_major_release ,
	@ls_database_version ,
	@ll_modification_level ) s

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
FROM dbo.fn_latest_scripts('Hotfix',
							@pl_db_major_release ,
							@ps_db_database_version ,
							NULL) s

-- Now add the latest specific object scripts
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
FROM dbo.fn_latest_scripts('Database View',
							@pl_db_major_release ,
							@ps_db_database_version ,
							@pl_db_modification_level) s

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
FROM dbo.fn_latest_scripts('Database Function',
							@pl_db_major_release ,
							@ps_db_database_version ,
							@pl_db_modification_level) s

-- Now add the latest specific object scripts
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
FROM dbo.fn_latest_scripts('Database Procedure',
							@pl_db_major_release ,
							@ps_db_database_version ,
							@pl_db_modification_level) s


-- Make sure all the columns exist
--EXECUTE jmjsys_set_table_columns '%'

-- Make sure all the defaults exist
--EXECUTE jmjsys_set_table_defaults '%'


SELECT 	[script_id] ,
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
	[allow_users]
FROM @latest_scripts

