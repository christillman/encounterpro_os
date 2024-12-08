DROP PROCEDURE [jmjsys_add_actor_progress]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [jmjsys_add_actor_progress] (
	@ps_actor_id uniqueidentifier,
	@ps_progress_type VARCHAR(24),
	@ps_progress_key varchar(80) = NULL,
	@ps_progress text = NULL
	)	
AS

SET NOCOUNT ON

DECLARE @ll_length int,
	@ls_database_mode varchar(12)

-- Get the database mode to decide whether to insert them into testing or production
SELECT @ls_database_mode = max(database_mode)
FROM c_Database_Status

IF @ls_database_mode IS NULL OR @ls_database_mode = 'Testing'
BEGIN
	-- First add the progress record.  If the length of @ps_progress is <= 40 then
	-- store the value in [progress_value].  Otherwise store it in [progress].
	SET @ll_length = LEN(CONVERT(varchar(50), @ps_progress))

	IF @ll_length <= 40
	BEGIN
		INSERT INTO jmjtech.EproUpdates_Testing.dbo.c_Actor_Progress(
		c_actor_id,
		progress_type,
		progress_key,
		progress_value,
		progress_date_time,
		progress_user_id,
		created_by
		) 
		VALUES (
		@ps_actor_id,
		@ps_progress_type,
		@ps_progress_key,
		@ps_progress,
		dbo.get_client_datetime(),
		'#SYSTEM',
		'#SYSTEM'
		)
	END
	ELSE
	BEGIN
		INSERT INTO jmjtech.EproUpdates_Testing.dbo.c_Actor_Progress(
		c_actor_id,
		progress_type,
		progress_key,
		progress,
		progress_date_time,
		progress_user_id,
		created_by
		) 
		VALUES (
		@ps_actor_id,
		@ps_progress_type,
		@ps_progress_key,
		@ps_progress,
		dbo.get_client_datetime(),
		'#SYSTEM',
		'#SYSTEM'
		)

	END
END
ELSE
BEGIN
	-- First add the progress record.  If the length of @ps_progress is <= 40 then
	-- store the value in [progress_value].  Otherwise store it in [progress].
	SET @ll_length = LEN(CONVERT(varchar(50), @ps_progress))

	IF @ll_length <= 40
	BEGIN
		INSERT INTO jmjtech.EproUpdates.dbo.c_Actor_Progress(
		c_actor_id,
		progress_type,
		progress_key,
		progress_value,
		progress_date_time,
		progress_user_id,
		created_by
		) 
		VALUES (
		@ps_actor_id,
		@ps_progress_type,
		@ps_progress_key,
		@ps_progress,
		dbo.get_client_datetime(),
		'#SYSTEM',
		'#SYSTEM'
		)
	END
	ELSE
	BEGIN
		INSERT INTO jmjtech.EproUpdates.dbo.c_Actor_Progress(
		c_actor_id,
		progress_type,
		progress_key,
		progress,
		progress_date_time,
		progress_user_id,
		created_by
		) 
		VALUES (
		@ps_actor_id,
		@ps_progress_type,
		@ps_progress_key,
		@ps_progress,
		dbo.get_client_datetime(),
		'#SYSTEM',
		'#SYSTEM'
		)

	END
END

GO
GRANT EXECUTE ON [jmjsys_add_actor_progress] TO [cprsystem] AS [dbo]
GO
