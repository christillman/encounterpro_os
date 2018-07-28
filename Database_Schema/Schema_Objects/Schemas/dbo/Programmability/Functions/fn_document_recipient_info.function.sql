CREATE FUNCTION fn_document_recipient_info (
	@ps_ordered_for varchar(24),
	@ps_cpr_id varchar(12) = NULL,
	@pl_encounter_id int = NULL)

RETURNS @recipient TABLE (
	user_id varchar(24) NOT NULL,
	actor_class varchar(24) NOT NULL,
	actor_id int NULL,
	cpr_id varchar(24) NULL
	)
AS
BEGIN

DECLARE @ll_error int,
	@ll_rowcount int,
	@ll_ordered_for_actor_id int,
	@ls_ordered_for_actor_class varchar(24),
	@ls_ordered_for_user_id varchar(24),
	@ls_ordered_for_cpr_id varchar(12)

SELECT @ll_ordered_for_actor_id = actor_id,
		@ls_ordered_for_actor_class = actor_class
FROM c_User
WHERE user_id = @ps_ordered_for

SELECT @ll_error = @@ERROR,
	@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN

-- If the ordered_for wasn't a user then see if it's an actor_class
IF @ll_rowcount = 0
	BEGIN
	SELECT @ll_ordered_for_actor_id = NULL,
			@ls_ordered_for_actor_class = actor_class
	FROM c_Actor_Class
	WHERE actor_class = @ps_ordered_for

	SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		RETURN

	IF @ll_rowcount = 0
		BEGIN
		SET @ll_ordered_for_actor_id = NULL
		SET @ls_ordered_for_actor_class = NULL
		END
	END

-- If the ordered_for_actor_class is "Special" 
IF @ls_ordered_for_actor_class = 'Special'
	BEGIN
	SET @ls_ordered_for_user_id = dbo.fn_special_user_resolution(@ps_ordered_for, @ps_cpr_id, @pl_encounter_id)
	IF @ls_ordered_for_user_id IS NULL
		SET @ls_ordered_for_user_id = @ps_ordered_for
	END
ELSE IF @ps_ordered_for = '#PATIENT'
	BEGIN
	-- Since the special user #PATIENT still has an actor_class 'Patient', we need to check specifically for it
	SET @ll_ordered_for_actor_id = NULL
	SET @ls_ordered_for_user_id = '##' + @ps_cpr_id
	SET @ls_ordered_for_actor_class = 'Patient'
	SET @ls_ordered_for_cpr_id = @ps_cpr_id
	END
ELSE
	SET @ls_ordered_for_user_id = @ps_ordered_for


-- If the ordered_for_user_id looks like a patient, then get the ordered_for_cpr_id
IF LEFT(@ls_ordered_for_user_id, 2) = '##' -- Patient
	BEGIN
	SET @ll_ordered_for_actor_id = NULL
	SET @ls_ordered_for_actor_class = 'Patient'
	SET @ls_ordered_for_cpr_id = SUBSTRING(@ls_ordered_for_user_id, 3, 12)
	END
ELSE IF @ls_ordered_for_user_id <> @ps_ordered_for
	BEGIN
	-- The ordered_for_user_id has been resolved to something other than @ps_ordered_for, so reselect the actor class
	SELECT @ll_ordered_for_actor_id = actor_id,
			@ls_ordered_for_actor_class = actor_class
	FROM c_User
	WHERE user_id = @ls_ordered_for_user_id

	SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		RETURN
	END

IF @ls_ordered_for_user_id IS NOT NULL
	INSERT INTO @recipient (
		user_id ,
		actor_class ,
		actor_id ,
		cpr_id)
	VALUES (
		@ls_ordered_for_user_id,
		@ls_ordered_for_actor_class,
		@ll_ordered_for_actor_id,
		@ls_ordered_for_cpr_id
		)

RETURN
END
