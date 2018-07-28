CREATE TRIGGER tr_o_preferences_script ON dbo.o_Preferences
FOR INSERT, UPDATE
AS
BEGIN

DECLARE @ls_preference_type varchar(24),
		@ls_preference_id varchar(40),
		@ls_change_script nvarchar(4000)

DECLARE lc_changes CURSOR LOCAL FAST_FORWARD FOR
	SELECT DISTINCT i.preference_type, i.preference_id
	FROM inserted i

OPEN lc_changes

FETCH lc_changes INTO @ls_preference_type, @ls_preference_id

WHILE @@FETCH_STATUS = 0
	BEGIN
	SELECT @ls_change_script = CAST(change_script AS nvarchar(4000))
	FROM c_Preference
	WHERE preference_type = @ls_preference_type
	AND preference_id = @ls_preference_id

	IF LEN(@ls_change_script) > 0
		EXECUTE (@ls_change_script)

	FETCH lc_changes INTO @ls_preference_type, @ls_preference_id
	END

CLOSE lc_changes
DEALLOCATE lc_changes

END
