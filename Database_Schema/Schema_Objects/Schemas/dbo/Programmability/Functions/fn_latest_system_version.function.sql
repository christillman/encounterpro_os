CREATE FUNCTION fn_latest_system_version (
	@ps_system_id varchar(24),
	@pl_major_release int = NULL,
	@ps_database_version varchar(4) = NULL,
	@pl_db_modification_level int = NULL)

RETURNS int

BEGIN

DECLARE @ll_modification_level int

-- If any peice of the release is missing, then get current db value for all
IF @pl_major_release IS NULL OR @ps_database_version IS NULL OR @pl_db_modification_level IS NULL
	SELECT @pl_major_release = major_release,
		@ps_database_version = database_version,
		@pl_db_modification_level = modification_level
	FROM c_Database_Status

IF @ps_system_id = 'Database'
	SET @ll_modification_level = @pl_db_modification_level
ELSE
	SELECT @ll_modification_level = max(modification_level)
	FROM c_Database_Modification_Dependancy
	WHERE system_id = @ps_system_id
	AND major_release = @pl_major_release
	AND database_version = @ps_database_version
	AND min_database_modification_level <= @pl_db_modification_level
	AND ISNULL(max_database_modification_level, @pl_db_modification_level) >= @pl_db_modification_level


RETURN @ll_modification_level

END

