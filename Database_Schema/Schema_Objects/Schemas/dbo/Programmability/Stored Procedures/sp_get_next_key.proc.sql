CREATE PROCEDURE sp_get_next_key (
	@ps_cpr_id varchar(12),
	@ps_key_id varchar(24),
	@pl_key_value int OUTPUT )
AS
DECLARE @ll_last_key int,
	@ll_increment int
IF upper(@ps_key_id) = 'PROBLEM_ID'
	BEGIN
	   SELECT @ll_last_key = max(problem_id)
	   FROM p_Assessment
	  WHERE cpr_id = @ps_cpr_id

	  IF @ll_last_key IS NULL 
	      SELECT @ll_last_key = 0
	  SELECT @pl_key_value = @ll_last_key + 1
	END
ELSE
	BEGIN
	UPDATE p_Lastkey
	SET last_key = last_key + increment
	WHERE cpr_id = @ps_cpr_id
	AND key_id = @ps_key_id
	IF @@ROWCOUNT = 0
		BEGIN
		SELECT	@ll_last_key = last_key,
			@ll_increment = increment
		FROM	p_Lastkey
		WHERE	cpr_id = '!TEMPLATE'
		AND	key_id = @ps_key_id
		IF @@ROWCOUNT = 0
			SELECT	@ll_last_key = 1,
				@ll_increment = 1
		INSERT INTO p_Lastkey
			(
			cpr_id,
			key_id,
			last_key,
			increment
			)
		VALUES
			(
			@ps_cpr_id,
			@ps_key_id,
			@ll_last_key,
			@ll_increment
			)
		END
	SELECT @pl_key_value = last_key
	FROM p_Lastkey
	WHERE cpr_id = @ps_cpr_id
	AND key_id = @ps_key_id
	END

RETURN @pl_key_value

