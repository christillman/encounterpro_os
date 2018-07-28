CREATE PROCEDURE sp_set_menu_item
	(
	@pl_menu_id integer,
	@pl_menu_item_id int = NULL,
	@ps_menu_item_type varchar(24),
	@ps_menu_item varchar(24),
	@ps_button_title varchar(40),
	@ps_button_help varchar(255),
	@ps_button varchar(128),
	@pl_sort_sequence int,
	@pl_rtn_menu_item_id int OUTPUT
	)
AS

DECLARE @ll_menu_item_id int

-- If the record doesn't exist then create it
IF @pl_menu_item_id IS NULL
	BEGIN
	INSERT INTO c_Menu_Item (
		menu_id,
		menu_item_type,
		menu_item,
		button_title,
		button_help,
		button,
		sort_sequence)
	VALUES (
		@pl_menu_id,
		@ps_menu_item_type,
		@ps_menu_item,
		@ps_button_title,
		@ps_button_help,
		@ps_button,
		@pl_sort_sequence)
	
	SELECT @ll_menu_item_id = @@IDENTITY
	END
ELSE
	BEGIN
	UPDATE c_Menu_Item
	SET button_title = @ps_button_title,
	button_help = @ps_button_help,
	button = @ps_button,
	sort_sequence = @pl_sort_sequence
	WHERE menu_id = @pl_menu_id
	AND menu_item_id = @pl_menu_item_id

	SELECT @ll_menu_item_id = @pl_menu_item_id
	END

SELECT @pl_rtn_menu_item_id = @ll_menu_item_id

