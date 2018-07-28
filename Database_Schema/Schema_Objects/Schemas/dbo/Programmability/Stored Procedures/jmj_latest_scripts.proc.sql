CREATE PROCEDURE jmj_latest_scripts (
	@ps_script_type varchar(24),
	@pl_major_release int = NULL,
	@ps_database_version varchar(4) = NULL,
	@pl_modification_level int = NULL
	)

AS

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
	selected_flag = 0 ,
	[allow_users]
FROM dbo.fn_latest_scripts(@ps_script_type, @pl_major_release, @ps_database_version, @pl_modification_level)
ORDER BY sort_sequence, modification_level, script_id

