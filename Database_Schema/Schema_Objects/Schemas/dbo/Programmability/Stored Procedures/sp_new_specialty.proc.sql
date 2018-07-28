CREATE PROCEDURE sp_new_specialty (
		@ps_specialty_id varchar(24) OUTPUT,
		@ps_description varchar(80),
		@pl_owner_id int,
		@ps_status varchar(12) = 'OK' )
AS

DECLARE @ls_specialty_key varchar(24),
		@ll_tries int

-- If a candidate key was supplied then see if it exists
IF @ps_specialty_id IS NOT NULL
	BEGIN
	IF EXISTS(SELECT 1 FROM c_Specialty WHERE specialty_id = @ps_specialty_id)
		RETURN 1
	END

-- If we get here, make sure we have a description
IF @ps_description IS NULL
	BEGIN
	RAISERROR ('Specialty description cannot be null',16,-1)
	ROLLBACK TRANSACTION
	RETURN 0
	END

IF @pl_owner_id IS NULL
	SELECT @pl_owner_id = customer_id
	FROM c_Database_Status

IF @ps_status = ''
	SET @ps_status = 'OK'

IF @ps_status IS NULL
	IF @pl_owner_id = 0
		SET @ps_status = 'OK'
	ELSE
		SET @ps_status = 'NA'

-- See if a specialty with the same description already exists
SELECT @ps_specialty_id = max(specialty_id)
FROM c_Specialty c
WHERE description = @ps_description

IF @ps_specialty_id IS NULL
	BEGIN
	-- Set our template either from the passed in key or from the description
	IF @ps_specialty_id IS NULL
		SET @ls_specialty_key = CAST(@ps_description AS varchar(24))
	ELSE
		SET @ls_specialty_key = @ps_specialty_id
	
	-- Initialize our candidate key from the template
	SET @ps_specialty_id = @ls_specialty_key
	
	SET @ll_tries = 0
	
	WHILE EXISTS(SELECT 1 FROM c_Specialty WHERE specialty_id = @ps_specialty_id)
		BEGIN
		SET @ll_tries = @ll_tries + 1
		IF @ll_tries >= 1000
			BEGIN
			SET @ps_specialty_id = NULL
			RETURN 0
			END
		
		SET @ps_specialty_id = CAST(@ls_specialty_key AS varchar(21)) + CAST(@ll_tries AS varchar(3))
		END

	-- If we get here then we have a specialty_id which does not exist in the c_Specialty table
	
	INSERT INTO c_Specialty (
		specialty_id,
		description,
		id,
		owner_id,
		last_updated,
		status)
	VALUES (
		@ps_specialty_id,
		@ps_description,
		newid(),
		@pl_owner_id,
		getdate(),
		@ps_status)
	
	END

RETURN 1

