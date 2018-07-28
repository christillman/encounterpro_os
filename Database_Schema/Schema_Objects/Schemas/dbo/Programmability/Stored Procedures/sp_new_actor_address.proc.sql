CREATE PROCEDURE sp_new_actor_address (
	@pl_actor_id int,
	@ps_description varchar(40),
	@ps_address_line_1 varchar(40) = NULL,
	@ps_address_line_2 varchar(40) = NULL,
	@ps_city varchar(40) = NULL,
	@ps_state varchar(2) = NULL,
	@ps_zip varchar(10) = NULL,
	@ps_country varchar(2) = NULL,
	@ps_created_by varchar(24) )
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
IF @ps_description IS NULL
	BEGIN
	RAISERROR ('No address description specified',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END

-- Make sure this address represents a change to what we already have
SELECT @ll_count = count(*)
FROM c_Actor_Address
WHERE actor_id = @pl_actor_id
AND description = @ps_description
AND status = 'OK'
AND ISNULL(address_line_1, 'NULL') = ISNULL(@ps_address_line_1, 'NULL')
AND	ISNULL(address_line_2, 'NULL') = ISNULL(@ps_address_line_2, 'NULL')
AND	ISNULL(city, 'NULL') = ISNULL(@ps_city, 'NULL')
AND	ISNULL(state, 'NULL') = ISNULL(@ps_state, 'NULL')
AND	ISNULL(zip, 'NULL') = ISNULL(@ps_zip, 'NULL')
AND	ISNULL(country, 'NULL') = ISNULL(@ps_country, 'NULL')

IF @ll_count > 0
	RETURN

INSERT INTO c_Actor_Address (
		actor_id,
		description,
		address_line_1 ,
		address_line_2 ,
		city ,
		state ,
		zip ,
		country ,
		status ,
		created_by )
VALUES (@pl_actor_id,
		@ps_description,
		@ps_address_line_1 ,
		@ps_address_line_2 ,
		@ps_city ,
		@ps_state ,
		@ps_zip ,
		@ps_country ,
		'OK' ,
		@ps_created_by )


