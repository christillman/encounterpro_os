DROP PROCEDURE [jmjsys_sync_cached_preferences]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [jmjsys_sync_cached_preferences]
AS

DECLARE @ls_preference_id varchar(40),
	@ls_preference_value varchar(255),
	@ll_error int

-- Put a marker in the log
PRINT 'Special Sync Starting: Cached Preferences   ' + CAST(dbo.get_client_datetime() AS varchar(20))

DECLARE lc_prefs CURSOR LOCAL FAST_FORWARD FOR
	SELECT preference_id
	FROM c_Preference
	WHERE universal_flag = 'C'

OPEN lc_prefs

FETCH lc_prefs INTO @ls_preference_id

WHILE @@FETCH_STATUS = 0
	BEGIN
	SET @ls_preference_value = dbo.fn_get_universal_preference(@ls_preference_id)

	IF @ls_preference_value IS NOT NULL
		BEGIN
		-- We got a value from the Epro Server so cache it locally
		EXECUTE sp_set_preference
			@ps_preference_level = 'Global',
			@ps_preference_key = 'Global',
			@ps_preference_id = @ls_preference_id,
			@ps_preference_value = @ls_preference_value
		
		END

	FETCH lc_prefs INTO @ls_preference_id
	END

CLOSE lc_prefs
DEALLOCATE lc_prefs


-- Put a marker in the log
PRINT 'Special Sync Successful: Cached Preferences   ' + CAST(dbo.get_client_datetime() AS varchar(20))


RETURN 1

GO
