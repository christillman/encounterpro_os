DROP PROCEDURE [jmjsys_add_actor_communication]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [jmjsys_add_actor_communication] (
	@ps_actor_id uniqueidentifier,
	@ps_communication_type VARCHAR(24) = NULL,
	@ps_communication_name varchar(24) = NULL,
	@ps_communication_value varchar(80) = NULL,
	@ps_note varchar(2) = NULL	
	)	
AS

SET NOCOUNT ON

DECLARE @ll_count int,
	@ls_database_mode varchar(12)

-- Get the database mode to decide whether to insert them into testing or production
SELECT @ls_database_mode = max(database_mode)
FROM c_Database_Status

IF @ls_database_mode IS NULL OR @ls_database_mode = 'Testing'
BEGIN

	SELECT @ll_count = count(*)
	FROM jmjtech.EproUpdates_Testing.dbo.c_Actor_Communication
	WHERE communication_type = @ps_communication_type
	AND communication_name = @ps_communication_name
	AND communication_value = @ps_communication_value
	AND note = @ps_note
	AND c_actor_id = @ps_actor_id

	IF @ll_count <= 0 
	BEGIN


	INSERT INTO jmjtech.EproUpdates_Testing.dbo.c_Actor_Communication(
		c_actor_id,
		communication_type,
		communication_name,
		communication_value,
		note
		) 
	VALUES (
		@ps_actor_id,
		@ps_communication_type,
		@ps_communication_name,
		@ps_communication_value,
		@ps_note
		)

	END
END
ELSE
BEGIN

	SELECT @ll_count = count(*)
	FROM jmjtech.EproUpdates.dbo.c_Actor_Communication
	WHERE communication_type = @ps_communication_type
	AND communication_name = @ps_communication_name
	AND communication_value = @ps_communication_value
	AND note = @ps_note
	AND c_actor_id = @ps_actor_id

	IF @ll_count <= 0 
	BEGIN


	INSERT INTO jmjtech.EproUpdates.dbo.c_Actor_Communication(
		c_actor_id,
		communication_type,
		communication_name,
		communication_value,
		note
		) 
	VALUES (
		@ps_actor_id,
		@ps_communication_type,
		@ps_communication_name,
		@ps_communication_value,
		@ps_note
		)

	END
END
GO
GRANT EXECUTE ON [jmjsys_add_actor_communication] TO [cprsystem] AS [dbo]
GO
