CREATE PROCEDURE sp_new_menu_item
	(
	@pl_menu_id int,
	@ps_menu_item_type varchar(80),
	@ps_menu_item varchar(24),
	@ps_button_title varchar(40),
	@ps_button_help varchar(255),
	@ps_button varchar(128),
	@pi_sort_sequence smallint
	)
AS

DECLARE @ll_menu_item_id int

INSERT INTO c_Menu_Item (
	menu_id,
	menu_item_type ,
	menu_item ,
	button_title ,
	button_help ,
	button ,
	sort_sequence 
	)
VALUES (
	@pl_menu_id,
	@ps_menu_item_type ,
	@ps_menu_item ,
	@ps_button_title ,
	@ps_button_help ,
	@ps_button ,
	@pi_sort_sequence 
	)

SELECT @ll_menu_item_id = @@IDENTITY

RETURN @ll_menu_item_id

