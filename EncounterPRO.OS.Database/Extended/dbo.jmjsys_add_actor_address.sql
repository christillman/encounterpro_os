DROP PROCEDURE [jmjsys_add_actor_address]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [jmjsys_add_actor_address] (
	@ps_actor_id uniqueidentifier,
	@ps_description VARCHAR(40) = NULL,
	@ps_address1 varchar(40) = NULL,
	@ps_address2 varchar(40) = NULL,
	@ps_city varchar(40) = NULL,
	@ps_state varchar(2) = NULL,
	@ps_zip varchar(10) = NULL,
	@ps_country varchar(2) = NULL	
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
	FROM jmjtech.EproUpdates_Testing.dbo.c_Actor_Address
	WHERE description = @ps_description
	AND address_line_1 = @ps_address1
	AND address_line_2 = @ps_address2
	AND city = @ps_city
	AND state = @ps_state
	AND zip = @ps_zip
	AND country = @ps_country
	AND c_actor_id = @ps_actor_id

	IF @ll_count <= 0 
	BEGIN

	INSERT INTO jmjtech.EproUpdates_Testing.dbo.c_Actor_Address(
		c_actor_id,
		description,
		address_line_1,
		address_line_2,
		city,
		state,
		zip,
		country
		) 
	VALUES (
		@ps_actor_id,
		@ps_description,
		@ps_address1,
		@ps_address2,
		@ps_city,
		@ps_state,
		@ps_zip,
		@ps_country
		)

	END
END
ELSE
BEGIN
	SELECT @ll_count = count(*)
	FROM jmjtech.EproUpdates.dbo.c_Actor_Address
	WHERE description = @ps_description
	AND address_line_1 = @ps_address1
	AND address_line_2 = @ps_address2
	AND city = @ps_city
	AND state = @ps_state
	AND zip = @ps_zip
	AND country = @ps_country
	AND c_actor_id = @ps_actor_id

	IF @ll_count <= 0 
	BEGIN

	INSERT INTO jmjtech.EproUpdates.dbo.c_Actor_Address(
		c_actor_id,
		description,
		address_line_1,
		address_line_2,
		city,
		state,
		zip,
		country
		) 
	VALUES (
		@ps_actor_id,
		@ps_description,
		@ps_address1,
		@ps_address2,
		@ps_city,
		@ps_state,
		@ps_zip,
		@ps_country
		)

	END
END

GO
GRANT EXECUTE ON [jmjsys_add_actor_address] TO [cprsystem] AS [dbo]
GO
