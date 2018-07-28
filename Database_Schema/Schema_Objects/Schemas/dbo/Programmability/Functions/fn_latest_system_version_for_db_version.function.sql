CREATE FUNCTION fn_latest_system_version_for_db_version (
	@ps_system_id varchar(24),
	@pl_db_major_release int,
	@ps_db_database_version varchar(4),
	@pl_db_modification_level int )

RETURNS @latestversion TABLE (
	[major_release] [int] ,
	[database_version] [varchar] (4) ,
	[modification_level] [int] )

AS

BEGIN

DECLARE @dbversions TABLE (
	[major_release] [int] ,
	[database_version] [varchar] (4) ,
	[modification_level] [int] )

DECLARE @ll_major_release int,
		@ls_database_version varchar(4),
		@ll_modification_level int

-- If nulls were passed in then use the current database version
SELECT @pl_db_major_release = ISNULL(@pl_db_major_release, major_release),
	@ps_db_database_version = ISNULL(@ps_db_database_version, database_version),
	@pl_db_modification_level = ISNULL(@pl_db_modification_level, modification_level)
FROM c_Database_Status

-- First get the max major release
SELECT @ll_major_release = max(major_release)
FROM c_Database_Modification_Dependancy
WHERE system_id = @ps_system_id
AND min_database_modification_level <= @pl_db_modification_level
AND (max_database_modification_level IS NULL OR max_database_modification_level >= @pl_db_modification_level)

-- Then get the max database version (minor release)
IF @ll_major_release IS NOT NULL
	SELECT @ls_database_version = max(database_version)
	FROM c_Database_Modification_Dependancy
	WHERE system_id = @ps_system_id
	AND min_database_modification_level <= @pl_db_modification_level
	AND (max_database_modification_level IS NULL OR max_database_modification_level >= @pl_db_modification_level)
	AND major_release = @ll_major_release

IF @ll_major_release IS NOT NULL 
	AND @ls_database_version IS NOT NULL
	-- Then get the max modification level (extended release)
	SELECT @ll_modification_level = max(modification_level)
	FROM c_Database_Modification_Dependancy
	WHERE system_id = @ps_system_id
	AND min_database_modification_level <= @pl_db_modification_level
	AND (max_database_modification_level IS NULL OR max_database_modification_level >= @pl_db_modification_level)
	AND major_release = @ll_major_release
	AND database_version = @ls_database_version

IF @ll_major_release IS NOT NULL 
	AND @ls_database_version IS NOT NULL 
	AND @ll_modification_level IS NOT NULL
	-- Now get the list of scripts and IDs for this bootstrap release
	INSERT INTO @latestversion (
		[major_release] , 
		[database_version] , 
		[modification_level] )
	VALUES (
		@ll_major_release, 
		@ls_database_version , 
		@ll_modification_level )


RETURN
END

