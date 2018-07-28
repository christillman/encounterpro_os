CREATE PROCEDURE sp_new_menu
	(
	@ps_description varchar(80),
	@ps_specialty_id varchar(24) = NULL,
	@ps_context_object varchar(24) = NULL,
	@ps_menu_category varchar(40) = NULL
	)
AS

DECLARE @ll_menu_id int

INSERT INTO c_Menu (
	description,
	specialty_id,
	context_object,
	menu_category
	)
VALUES (
	@ps_description,
	@ps_specialty_id,
	@ps_context_object,
	@ps_menu_category
	)

SET @ll_menu_id = @@IDENTITY

RETURN @ll_menu_id

