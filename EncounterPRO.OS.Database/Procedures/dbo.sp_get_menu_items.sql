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

