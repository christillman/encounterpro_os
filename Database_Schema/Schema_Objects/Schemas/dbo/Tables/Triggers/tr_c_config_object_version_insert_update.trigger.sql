CREATE TRIGGER tr_c_config_object_version_insert_update ON dbo.c_config_object_version
FOR INSERT, UPDATE
AS

DECLARE @lui_config_object_id uniqueidentifier,
		@ll_latest_version int,
		@ll_installed_version int,
		@ls_status varchar(12),
		@ll_owner_id int,
		@ll_customer_id int

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

DECLARE lc_objects CURSOR LOCAL FAST_FORWARD FOR
	SELECT DISTINCT config_object_id
	FROM inserted

OPEN lc_objects

FETCH lc_objects INTO @lui_config_object_id

WHILE @@FETCH_STATUS = 0
	BEGIN
	SELECT @ll_latest_version = MAX(version)
	FROM c_config_object_version
	WHERE config_object_id = @lui_config_object_id
	AND status <> 'Cancelled'

	SELECT @ll_installed_version = installed_version,
			@ll_owner_id = owner_id
	FROM c_config_object
	WHERE config_object_id = @lui_config_object_id

	IF @ll_latest_version IS NULL
		BEGIN
		UPDATE o
		SET latest_version = NULL,
			latest_version_date = NULL,
			latest_version_status = NULL,
			checked_out_by = NULL,
			checked_out_date_time = NULL,
			checked_out_from_version = NULL
		FROM c_config_object o
		WHERE config_object_id = @lui_config_object_id
		END
	ELSE
		BEGIN
		UPDATE o
		SET latest_version = v.version,
			latest_version_date = v.status_date_time,
			latest_version_status = v.status
		FROM c_config_object o
			INNER JOIN c_config_object_version v
			ON o.config_object_id = v.config_object_id
		WHERE v.config_object_id = @lui_config_object_id
		AND v.version = @ll_latest_version

		SELECT @ls_status = status
		FROM c_config_object_version
		WHERE config_object_id = @lui_config_object_id
		AND version = @ll_latest_version

		IF @ls_status = 'CheckedOut'
			BEGIN
			UPDATE o
			SET checked_out_by = v.checked_out_by,
				checked_out_date_time = v.status_date_time,
				checked_out_from_version = v.created_from_version
			FROM c_config_object o
				INNER JOIN c_config_object_version v
				ON o.config_object_id = v.config_object_id
			WHERE v.config_object_id = @lui_config_object_id
			AND v.version = @ll_latest_version

			-- The checked out version is always the installed version
			SET @ll_installed_version = @ll_latest_version
			END
		ELSE
			BEGIN
			UPDATE o
			SET checked_out_by = NULL,
				checked_out_date_time = NULL,
				checked_out_from_version = NULL
			FROM c_config_object o
			WHERE config_object_id = @lui_config_object_id

			-- If the object is locally owned then the latest version is the installed version
			IF @ll_owner_id = @ll_customer_id AND @ll_installed_version IS NULL
				SET @ll_installed_version = @ll_latest_version
			END
		END

		UPDATE o
		SET installed_version = v.version,
			installed_version_date = v.status_date_time,
			installed_version_status = v.status
		FROM c_config_object o
			INNER JOIN c_config_object_version v
			ON o.config_object_id = v.config_object_id
		WHERE v.config_object_id = @lui_config_object_id
		AND v.version = @ll_installed_version

		FETCH lc_objects INTO @lui_config_object_id
	END

CLOSE lc_objects
DEALLOCATE lc_objects



