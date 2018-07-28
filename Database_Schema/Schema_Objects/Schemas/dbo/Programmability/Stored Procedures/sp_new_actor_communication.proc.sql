CREATE PROCEDURE sp_new_actor_communication (
	@pl_actor_id int,
	@ps_communication_type varchar(24) = NULL,
	@ps_communication_value varchar(80) = NULL,
	@ps_note varchar(80) = NULL,
	@ps_created_by varchar(24),
	@ps_communication_name varchar(24) = NULL )
AS

DECLARE @ll_owner_id int,
		@ll_count int

SELECT @ll_owner_id = customer_id
FROM c_Database_Status

-- The caller must specify an actor class
IF @pl_actor_id IS NULL
	BEGIN
	RAISERROR ('No actor_id specified',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END

-- Check to see if we have enough information
IF @ps_communication_type IS NULL
	BEGIN
	RAISERROR ('No communication type specified',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END

IF @ps_communication_name IS NULL
	SET @ps_communication_name = @ps_communication_type


SELECT @ll_count = count(*)
FROM c_Actor_communication
WHERE actor_id = @pl_actor_id
AND communication_type = @ps_communication_type
AND communication_name = @ps_communication_name
AND ISNULL(communication_value, 'NULL') = ISNULL(@ps_communication_value, 'NULL')
AND	ISNULL(note, 'NULL') = ISNULL(@ps_note, 'NULL')
AND status = 'OK'

IF @ll_count > 0
	RETURN
		

INSERT INTO c_Actor_communication (
		actor_id,
		communication_name,
		communication_type,
		communication_value ,
		note ,
		status ,
		created_by )
VALUES (@pl_actor_id,
		@ps_communication_name,
		@ps_communication_type,
		@ps_communication_value ,
		@ps_note ,
		'OK' ,
		@ps_created_by )


