CREATE PROCEDURE sp_set_menu
	(
	@pl_menu_id integer,
	@ps_description varchar(80),
	@ps_specialty_id varchar(24) = NULL,
	@ps_context_object varchar(24) = NULL,
	@pl_rtn_menu_id int OUTPUT
	)
AS

DECLARE @ll_menu_id int

-- If the record doesn't exist then create it
IF @pl_menu_id IS NULL
	BEGIN
	INSERT INTO c_Menu (
		description,
		specialty_id,
		context_object
		)
	VALUES (
		@ps_description,
		@ps_specialty_id,
		@ps_context_object
		)
	
	SELECT @ll_menu_id = @@IDENTITY
	END
ELSE
	BEGIN
	UPDATE c_Menu
	SET description = @ps_description,
	specialty_id = @ps_specialty_id,
	context_object = @ps_context_object
	WHERE menu_id = @pl_menu_id

	SELECT @ll_menu_id = @pl_menu_id
	END

SELECT @pl_rtn_menu_id = @ll_menu_id

