--EncounterPRO Open Source Project
--
--Copyright 2010-2011 The EncounterPRO Foundation, Inc.
--
--This program is free software: you can redistribute it and/or modify it under the terms of 
--the GNU Affero General Public License as published by the Free Software Foundation, either 
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Affero General Public License for more details.
--
--You should have received a copy of the GNU Affero General Public License along with this 
--program. If not, see http://www.gnu.org/licenses.
--
--EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero 
--General Public License version 3, or any later version. As such, linking the Project 
--statically or dynamically with other components is making a combined work based on the 
--Project. Thus, the terms and conditions of the GNU Affero General Public License version 3, 
--or any later version, cover the whole combination.
--
--However, as an additional permission, the copyright holders of EncounterPRO Open Source 
--Project give you permission to link the Project with independent components, regardless of 
--the license terms of these independent components, provided that all of the following are true:
--
--1. All access from the independent component to persisted data which resides
--   inside any EncounterPRO Open Source data store (e.g. SQL Server database) 
--   be made through a publically available database driver (e.g. ODBC, SQL 
--   Native Client, etc) or through a service which itself is part of The Project.
--2. The independent component does not create or rely on any code or data 
--   structures within the EncounterPRO Open Source data store unless such 
--   code or data structures, and all code and data structures referred to 
--   by such code or data structures, are themselves part of The Project.
--3. The independent component either a) runs locally on the user's computer,
--   or b) is linked to at runtime by The Project’s Component Manager object 
--   which in turn is called by code which itself is part of The Project.
--
--An independent component is a component which is not derived from or based on the Project.
--If you modify the Project, you may extend this additional permission to your version of 
--the Project, but you are not obligated to do so. If you do not wish to do so, delete this 
--additional permission statement from your version.
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_local_copy_display_script]
Print 'Drop Procedure [dbo].[sp_local_copy_display_script]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_local_copy_display_script]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_local_copy_display_script]
GO

-- Create Procedure [dbo].[sp_local_copy_display_script]
Print 'Create Procedure [dbo].[sp_local_copy_display_script]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_local_copy_display_script (
	@pl_display_script_id int,
	@ps_new_id varchar(40) = NULL,
	@ps_new_description varchar(80) = NULL,
	@ps_new_parent_config_object_id varchar(38) = NULL )
AS

-- This stored procedure creates a local copy of the specified display_script and returns the new display_script_id
DECLARE @ll_new_display_script_id int,
	@ll_customer_id int,
	@ll_owner_id int,
	@lid_id uniqueidentifier,
	@lid_old_parent_config_object_id uniqueidentifier,
	@ll_display_command_id int,
	@ll_attribute_sequence int,
	@ll_new_display_command_id int,
	@li_count smallint,
	@ll_nested_display_script_id int,
	@ll_new_nested_display_script_id int,
	@lid_nested_parent_config_object_id uniqueidentifier,
	@ls_attribute varchar(40),
	@ls_value varchar(255),
	@ls_context_object varchar(24),
	@lid_new_parent_config_object_id uniqueidentifier,
	@lid_new_id uniqueidentifier

IF @ps_new_id IS NULL
	SET @lid_new_id = newid()
ELSE
	SET @lid_new_id = CAST(@ps_new_id AS uniqueidentifier)

IF @ps_new_parent_config_object_id IS NULL OR @ps_new_parent_config_object_id = ''
	SET @lid_new_parent_config_object_id = NULL
ELSE
	SET @lid_new_parent_config_object_id = CAST(@ps_new_parent_config_object_id AS uniqueidentifier)

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

SELECT @ll_owner_id = owner_id,
		@lid_id = id,
		@ps_new_description = COALESCE(@ps_new_description, description),
		@ls_context_object = context_object,
		@lid_old_parent_config_object_id = parent_config_object_id
FROM c_display_script
WHERE display_script_id = @pl_display_script_id

IF @@ROWCOUNT <> 1
	BEGIN
	RAISERROR ('No such display_script (%d)',16,-1, @pl_display_script_id)
	ROLLBACK TRANSACTION
	RETURN -1
	END

-- If the new display_script is a local version of the old display_script, then make sure the old display_script isn't already locally owned
IF @lid_id = @lid_new_id AND @ll_owner_id = @ll_customer_id
	BEGIN
	RAISERROR ('display_script is already locally owned (%d)',16,-1, @pl_display_script_id)
	ROLLBACK TRANSACTION
	RETURN -1
	END

-- Make sure there aren't any other display_scripts out there with this id and owner combo
SELECT @li_count = count(*)
FROM c_display_script
WHERE id = @lid_new_id
AND owner_id = @ll_customer_id

IF @li_count > 0
	BEGIN
	RAISERROR ('Locally owned display_script already exists (%d)',16,-1, @pl_display_script_id)
	ROLLBACK TRANSACTION
	RETURN -1
	END

BEGIN TRANSACTION

INSERT INTO c_display_script (
	script_type,
	context_object,
	display_script,
	description,
	example,
	owner_id,
	last_updated,
	updated_by,
	id,
	status,
	original_id,
	parent_config_object_id)
SELECT
	script_type,
	context_object,
	display_script,
	@ps_new_description,
	example,
	@ll_customer_id,
	dbo.get_client_datetime(),
	updated_by,
	@lid_new_id,
	'OK',
	@lid_id,
	@lid_new_parent_config_object_id
FROM c_display_script
WHERE display_script_id = @pl_display_script_id

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

SET @ll_new_display_script_id = SCOPE_IDENTITY()

IF @ll_new_display_script_id <= 0 OR @ll_new_display_script_id IS NULL
	RETURN -1

-- Disable any other copies of this display_script
UPDATE c_display_script
SET status = 'NA'
WHERE id = @lid_new_id
AND display_script_id <> @ll_new_display_script_id

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

-- Now copy all the display_script details

DECLARE lc_Display_Script_Command CURSOR LOCAL FAST_FORWARD FOR
	SELECT display_command_id
	FROM c_Display_Script_Command
	WHERE display_script_id = @pl_display_script_id

OPEN lc_Display_Script_Command

FETCH lc_Display_Script_Command INTO @ll_display_command_id

WHILE @@FETCH_STATUS = 0
	BEGIN

	INSERT INTO c_Display_Script_Command (
		[display_script_id] ,
		[context_object] ,
		[display_command] ,
		[sort_sequence] ,
		[status] ,
		[id] )
	SELECT @ll_new_display_script_id ,
		[context_object] ,
		[display_command] ,
		[sort_sequence] ,
		[status] ,
		[id]
	FROM c_Display_Script_Command
	WHERE display_script_id = @pl_display_script_id
	AND display_command_id = @ll_display_command_id

	IF @@ERROR <> 0
		BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
		END
	
	SET @ll_new_display_command_id = SCOPE_IDENTITY()

	INSERT INTO c_Display_Script_Cmd_Attribute (
		[display_script_id] ,
		[display_command_id] ,
		[attribute],
		[value],
		[long_value],
		[id] )
	SELECT @ll_new_display_script_id ,
		@ll_new_display_command_id ,
		[attribute],
		[value],
		[long_value],
		[id] 
	FROM c_Display_Script_Cmd_Attribute
	WHERE display_script_id = @pl_display_script_id
	AND display_command_id = @ll_display_command_id

	IF @@ERROR <> 0
		BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
		END
	
	FETCH lc_Display_Script_Command INTO @ll_display_command_id
	END

CLOSE lc_Display_Script_Command
DEALLOCATE lc_Display_Script_Command


-- Now recursively get all the display scripts referenced by this display script
-- which do not already have the same parent config object
DECLARE lc_NestedScript CURSOR LOCAL FAST_FORWARD FOR
	SELECT a.display_command_id, a.attribute_sequence, a.attribute, a.value
	FROM c_Display_Script_Cmd_Attribute a
	WHERE a.display_script_id = @ll_new_display_script_id
	AND (a.attribute LIKE '%display_script_id'
		OR a.attribute LIKE '%xml_script_id')
	AND ISNUMERIC(a.value) = 1

OPEN lc_NestedScript

FETCH lc_NestedScript INTO @ll_display_command_id, @ll_attribute_sequence, @ls_attribute, @ls_value 

WHILE @@FETCH_STATUS = 0
	BEGIN
	SET @ll_nested_display_script_id = CAST(@ls_value AS int)

	SELECT @lid_nested_parent_config_object_id = d.parent_config_object_id
	FROM c_Display_Script d
	WHERE d.display_script_id = @ll_nested_display_script_id
	
	IF (@lid_new_parent_config_object_id <> @lid_nested_parent_config_object_id)
		OR (@lid_new_parent_config_object_id IS NULL AND @lid_nested_parent_config_object_id IS NOT NULL)
		OR (@lid_new_parent_config_object_id IS NOT NULL AND @lid_nested_parent_config_object_id IS NULL)
		BEGIN
		-- Make a copy of each nested display script
		EXECUTE @ll_new_nested_display_script_id = sp_local_copy_display_script
															@pl_display_script_id = @ll_nested_display_script_id ,
															@ps_new_parent_config_object_id = @ps_new_parent_config_object_id
		IF @ll_new_nested_display_script_id > 0
			BEGIN
			-- Update the attribute value in our new display script to point to the nested display script
			UPDATE a
			SET value = CAST(@ll_new_nested_display_script_id AS varchar(255)) 
			FROM c_Display_Script_Cmd_Attribute a
			WHERE display_script_id = @ll_new_display_script_id
			AND display_command_id = @ll_display_command_id
			AND attribute_sequence = @ll_attribute_sequence
			END
		END
	FETCH lc_NestedScript INTO @ll_display_command_id, @ll_attribute_sequence, @ls_attribute, @ls_value 
	END

CLOSE lc_NestedScript
DEALLOCATE lc_NestedScript

COMMIT TRANSACTION

-- If the original display script is on a short list, then put the copy on an equivalent short list
IF @lid_old_parent_config_object_id IS NOT NULL AND @lid_new_parent_config_object_id IS NOT NULL
	BEGIN
	INSERT INTO u_Top_20 (
		user_id,
		top_20_code,
		item_text,
		item_id3,
		sort_sequence)
	SELECT u20.user_id,
			top_20_code = 'DISPLAY_SCRIPT|' + @ls_context_object + '|' + CAST(@lid_new_parent_config_object_id AS varchar(36)),
			u20.item_text,
			u20.item_id3,
			u20.sort_sequence
	FROM u_top_20 u20
	WHERE top_20_code = 'DISPLAY_SCRIPT|' + @ls_context_object + '|' + CAST(@lid_old_parent_config_object_id AS varchar(36))
	END

RETURN @ll_new_display_script_id

GO
GRANT EXECUTE
	ON [dbo].[sp_local_copy_display_script]
	TO [cprsystem]
GO

