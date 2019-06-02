
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_menu_items]
Print 'Drop Procedure [dbo].[sp_get_menu_items]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_menu_items]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_menu_items]
GO

-- Create Procedure [dbo].[sp_get_menu_items]
Print 'Create Procedure [dbo].[sp_get_menu_items]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_menu_items (
	@pl_menu_id int )
AS

DECLARE @menuitems TABLE (
	menu_id int NOT NULL,
	menu_item_id int NOT NULL,
	menu_item_type varchar (24)  NOT NULL ,
	menu_item varchar (24)  NOT NULL ,
	context_object varchar(24) NULL ,
	button_title varchar (40)  NULL ,
	button_help varchar (255)  NULL ,
	button varchar (128)  NULL ,
	sort_sequence smallint NULL ,
	selected_flag int NOT NULL DEFAULT (0),
	menu_item_description varchar(80) NULL ,
	auto_close_flag char(1) NULL,
	authorized_user_id varchar(24) NULL,
	id uniqueidentifier NOT NULL)

INSERT INTO @menuitems (
	menu_id ,
	menu_item_id ,
	menu_item_type ,
	menu_item ,
	context_object ,
	button_title ,
	button_help ,
	button ,
	sort_sequence ,
	auto_close_flag,
	authorized_user_id,
	id)
SELECT menu_id ,
	menu_item_id ,
	menu_item_type ,
	menu_item ,
	context_object ,
	button_title ,
	button_help ,
	button ,
	sort_sequence ,
	auto_close_flag ,
	authorized_user_id ,
	id
FROM c_Menu_Item
WHERE menu_id = @pl_menu_id

UPDATE mi
SET menu_item_description = s.description
FROM @menuitems mi
	INNER JOIN o_Service s
	ON mi.menu_item = s.service
WHERE mi.menu_item_type = 'SERVICE'

UPDATE mi
SET menu_item_description = m.description
FROM @menuitems mi
	INNER JOIN c_Menu m
	ON CAST(mi.menu_item AS int) = m.menu_id
WHERE mi.menu_item_type = 'MENU'

UPDATE mi
SET menu_item_description = t.description
FROM @menuitems mi
	INNER JOIN c_Treatment_Type t
	ON mi.menu_item = t.treatment_type
WHERE mi.menu_item_type IN ('TREATMENT', 'TREATMENT_TYPE')

UPDATE mi
SET menu_item_description = l.description
FROM @menuitems mi
	INNER JOIN c_Treatment_Type_List_Def l
	ON mi.menu_item = l.treatment_list_id
WHERE mi.menu_item_type = 'TREATMENT_LIST'

UPDATE @menuitems
SET menu_item_description = menu_item
WHERE menu_item_description IS NULL

SELECT menu_id ,
	menu_item_id ,
	menu_item_type ,
	menu_item ,
	button_title ,
	button_help ,
	button ,
	sort_sequence,
	selected_flag,
	menu_item_description,
	auto_close_flag,
	authorized_user_id,
	context_object,
	id
FROM @menuitems
ORDER BY sort_sequence

GO
GRANT EXECUTE
	ON [dbo].[sp_get_menu_items]
	TO [cprsystem]
GO

