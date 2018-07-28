CREATE PROCEDURE jmj_copy_object_params (
	@ps_from_id varchar(40) ,
	@pl_from_param_sequence int = NULL ,
	@ps_to_id varchar(40) ,
	@ps_param_mode varchar(12) = NULL,
	@ps_created_by varchar(24) )
AS

DECLARE @lui_from_id uniqueidentifier ,
		@lui_to_id uniqueidentifier,
		@ll_sort_sequence int

SET @lui_from_id = CAST(@ps_from_id AS uniqueidentifier)
SET @lui_to_id = CAST(@ps_to_id AS uniqueidentifier)

IF @pl_from_param_sequence IS NULL
	BEGIN
	DELETE
	FROM c_Component_Param
	WHERE id = @lui_to_id
	AND (@ps_param_mode IS NULL OR param_mode = @ps_param_mode)

	INSERT INTO c_Component_Param (
		id,
		param_class,
		param_mode,
		sort_sequence,
		param_title,
		token1,
		token2,
		token3,
		token4,
		initial1,
		initial2,
		initial3,
		initial4,
		required_flag,
		helptext,
		query,
		min_build )
	SELECT @lui_to_id,
		param_class,
		param_mode,
		sort_sequence,
		param_title,
		token1,
		token2,
		token3,
		token4,
		initial1,
		initial2,
		initial3,
		initial4,
		required_flag,
		helptext,
		query,
		min_build
	FROM c_Component_Param
	WHERE id = @lui_from_id
	AND (@ps_param_mode IS NULL OR param_mode = @ps_param_mode)
	END
ELSE
	BEGIN
	SELECT @ll_sort_sequence = max(sort_sequence)
	FROM c_Component_Param
	WHERE id = @lui_to_id
	AND (@ps_param_mode IS NULL OR param_mode = @ps_param_mode)

	IF @ll_sort_sequence IS NULL
		SET @ll_sort_sequence = 1
	ELSE
		SET @ll_sort_sequence = @ll_sort_sequence + 1

	INSERT INTO c_Component_Param (
		id,
		param_class,
		param_mode,
		sort_sequence,
		param_title,
		token1,
		token2,
		token3,
		token4,
		initial1,
		initial2,
		initial3,
		initial4,
		required_flag,
		helptext,
		query,
		min_build )
	SELECT @lui_to_id,
		param_class,
		param_mode,
		@ll_sort_sequence,
		param_title,
		token1,
		token2,
		token3,
		token4,
		initial1,
		initial2,
		initial3,
		initial4,
		required_flag,
		helptext,
		query,
		min_build
	FROM c_Component_Param
	WHERE id = @lui_from_id
	AND param_sequence = @pl_from_param_sequence
	END

