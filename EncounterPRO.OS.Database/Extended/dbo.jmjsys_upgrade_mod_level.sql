DROP PROCEDURE [jmjsys_upgrade_mod_level]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [jmjsys_upgrade_mod_level]
	@pl_modification_level int = NULL
AS

DECLARE @ll_error int,
		@ll_rowcount int,
		@ll_current_modification_level int,
		@ll_target_modification_level int,
		@ls_available_version varchar(24),
		@ll_available_modification_level int,
		@ls_tablename varchar(64)

SELECT @ll_current_modification_level = modification_level
FROM c_Database_Status


IF @pl_modification_level IS NULL
	SET @ll_target_modification_level = @ll_current_modification_level
ELSE
	BEGIN
	SELECT @ls_available_version = RIGHT(available_version, 3)
	FROM c_Database_System
	WHERE system_id = 'Database'

	IF ISNUMERIC(@ls_available_version) = 1
		SET @ll_available_modification_level = CAST(@ls_available_version AS int)
	ELSE
		BEGIN
		RAISERROR ('Unable to determine the available mod level',16,-1)
		RETURN -1
		END

	IF @pl_modification_level > @ll_available_modification_level
		BEGIN
		RAISERROR ('Requested Mod Level (%d) is not available', 16, -1, @pl_modification_level)
		RETURN -1
		END

	IF @pl_modification_level < @ll_current_modification_level
		BEGIN
		RAISERROR ('Requested Mod Level (%d) is less than the current mod level (%d)', 16, -1, @pl_modification_level, @ll_current_modification_level)
		RETURN -1
		END

	IF @pl_modification_level > @ll_current_modification_level + 1
		BEGIN
		RAISERROR ('Requested Mod Level (%d) is too high.  Mod levels may not be skipped.', 16, -1, @pl_modification_level, @ll_current_modification_level)
		RETURN -1
		END

	SET @ll_target_modification_level = @pl_modification_level
	END

DECLARE lc_newtables CURSOR LOCAL FAST_FORWARD FOR
	SELECT tablename
	FROM c_Database_Table t
	WHERE NOT EXISTS (
		SELECT 1
		FROM sys.objects x
		WHERE t.tablename = x.name
		AND x.type IN ('U', 'V')
		)

OPEN lc_newtables

FETCH lc_newtables INTO @ls_tablename

WHILE @@FETCH_STATUS = 0
	BEGIN
	EXECUTE jmjsys_upgrade_table
		@ps_tablename = @ls_tablename,
		@pl_modification_level = @ll_target_modification_level

	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		RETURN -1

	FETCH lc_newtables INTO @ls_tablename
	END

CLOSE lc_newtables
DEALLOCATE lc_newtables


EXECUTE jmjsys_set_table_columns @ps_which_table = '%', @pl_modification_level = @pl_modification_level

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

RETURN 1

GO
