
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_local_copy_menu]
Print 'Drop Procedure [dbo].[sp_local_copy_menu]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_local_copy_menu]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_local_copy_menu]
GO

-- Create Procedure [dbo].[sp_local_copy_menu]
Print 'Create Procedure [dbo].[sp_local_copy_menu]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_local_copy_menu (
	@pl_menu_id int,
	@ps_new_id varchar(40) = NULL,
	@ps_new_description varchar(80) = NULL )
AS

-- This stored procedure creates a local copy of the specified menu and returns the new menu_id
DECLARE @ll_new_menu_id int,
	@ll_customer_id int,
	@ll_owner_id int,
	@lid_id uniqueidentifier,
	@ll_menu_item_id int,
	@ll_new_menu_item_id int,
	@lid_new_id uniqueidentifier,
	@li_count smallint

IF @ps_new_id IS NULL
	SET @lid_new_id = newid()
ELSE
	SET @lid_new_id = CAST(@ps_new_id AS uniqueidentifier)

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

SELECT @ll_owner_id = owner_id,
		@lid_id = id,
		@ps_new_description = COALESCE(@ps_new_description, description)
FROM c_menu
WHERE menu_id = @pl_menu_id

IF @ll_owner_id IS NULL
	BEGIN
	RAISERROR ('No such menu (%d)',16,-1, @pl_menu_id)
	ROLLBACK TRANSACTION
	RETURN -1
	END

-- If the new menu is a local version of the old menu, then make sure the old menu isn't already locally owned
IF @lid_id = @lid_new_id AND @ll_owner_id = @ll_customer_id
	BEGIN
	RAISERROR ('menu is already locally owned (%d)',16,-1, @pl_menu_id)
	ROLLBACK TRANSACTION
	RETURN -1
	END

-- Make sure there aren't any other menus out there with this id and owner combo
SELECT @li_count = count(*)
FROM c_menu
WHERE id = @lid_new_id
AND owner_id = @ll_customer_id

IF @li_count > 0
	BEGIN
	RAISERROR ('Locally owned menu already exists (%d)',16,-1, @pl_menu_id)
	ROLLBACK TRANSACTION
	RETURN -1
	END

BEGIN TRANSACTION

INSERT INTO c_menu (
	description,
	sort_sequence,
	specialty_id,
	context_object,
	menu_category,
	owner_id,
	last_updated,
	id,
	status)
SELECT @ps_new_description,
	sort_sequence,
	specialty_id,
	context_object,
	menu_category,
	@ll_customer_id,
	dbo.get_client_datetime(),
	@lid_new_id,
	'OK'
FROM c_menu
WHERE menu_id = @pl_menu_id

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

SET @ll_new_menu_id = SCOPE_IDENTITY()

IF @ll_new_menu_id <= 0 OR @ll_new_menu_id IS NULL
	RETURN -1

-- Disable any other copies of this menu
UPDATE c_menu
SET status = 'NA'
WHERE id = @lid_new_id
AND menu_id <> @ll_new_menu_id

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

-- Now copy all the menu details

DECLARE lc_menu_item CURSOR LOCAL FAST_FORWARD FOR
	SELECT menu_item_id
	FROM c_menu_Item
	WHERE menu_id = @pl_menu_id

OPEN lc_menu_item

FETCH lc_menu_item INTO @ll_menu_item_id

WHILE @@FETCH_STATUS = 0
	BEGIN

	INSERT INTO c_menu_Item (
		[menu_id] ,
		[menu_item_type] ,
		[menu_item] ,
		[button_title] ,
		[button_help] ,
		[button] ,
		[sort_sequence] )
	SELECT @ll_new_menu_id ,
		[menu_item_type] ,
		[menu_item] ,
		[button_title] ,
		[button_help] ,
		[button] ,
		[sort_sequence]
	FROM c_menu_Item
	WHERE menu_id = @pl_menu_id
	AND menu_item_id = @ll_menu_item_id

	IF @@ERROR <> 0
		BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
		END
	
	SET @ll_new_menu_item_id = SCOPE_IDENTITY()

	INSERT INTO c_menu_Item_Attribute (
		[menu_id] ,
		[menu_item_id] ,
		[attribute],
		[value] )
	SELECT @ll_new_menu_id ,
		@ll_new_menu_item_id ,
		[attribute],
		[value] 
	FROM c_menu_Item_Attribute
	WHERE menu_id = @pl_menu_id
	AND menu_item_id = @ll_menu_item_id

	IF @@ERROR <> 0
		BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
		END
	
	FETCH lc_menu_item INTO @ll_menu_item_id
	END

CLOSE lc_menu_item
DEALLOCATE lc_menu_item

COMMIT TRANSACTION

RETURN @ll_new_menu_id

GO
GRANT EXECUTE
	ON [dbo].[sp_local_copy_menu]
	TO [cprsystem]
GO

