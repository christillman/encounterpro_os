﻿--EncounterPRO Open Source Project
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

-- Drop Function [dbo].[fn_object_info]
Print 'Drop Function [dbo].[fn_object_info]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_object_info]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_object_info]
GO

-- Create Function [dbo].[fn_object_info]
Print 'Create Function [dbo].[fn_object_info]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_object_info (
	@pui_config_object_id uniqueidentifier = NULL)

RETURNS @objectinfo TABLE (
	id uniqueidentifier NOT NULL,
	object_class varchar(12) NOT NULL,
	object_type varchar(24) NOT NULL,
	description varchar(80) NOT NULL,
	object_type_prefix varchar(8) NOT NULL,
	owner_id int NOT NULL,
	status varchar(12) NOT NULL,
	base_table varchar(64) NOT NULL,
	base_table_key varchar(64) NOT NULL
)

AS
BEGIN

IF @pui_config_object_id IS NULL
	BEGIN
	-- When called with NULL we want all the config objects
	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.report_id,
		'Config',
		'Report',
		COALESCE(o.description, '<No Description>'),
		t.config_object_prefix,
		o.owner_id,
		COALESCE(o.status, 'NA'),
		t.base_table,
		t.config_object_key
	FROM c_Report_Definition o
		CROSS JOIN c_Config_Object_Type t
	WHERE t.config_object_type = 'Report'

	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Config',
		'Service',
		COALESCE(o.description, '<No Description>'),
		t.config_object_prefix,
		o.owner_id,
		COALESCE(o.status, 'NA'),
		t.base_table,
		t.config_object_key
	FROM o_Service o
		CROSS JOIN c_Config_Object_Type t
	WHERE t.config_object_type = 'Service'

	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Config',
		'RTF Script',
		o.context_object + ' ' + o.display_script,
		t.config_object_prefix,
		o.owner_id,
		COALESCE(o.status, 'NA'),
		t.base_table,
		t.config_object_key
	FROM c_Display_Script o
		CROSS JOIN c_Config_Object_Type t
	WHERE o.script_type = 'RTF'
	AND t.config_object_type = 'RTF Script'

	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Config',
		'XML Script',
		COALESCE(o.description, '<No Description>'),
		t.config_object_prefix,
		o.owner_id,
		o.status,
		t.base_table,
		t.config_object_key
	FROM c_Display_Script o
		CROSS JOIN c_Config_Object_Type t
	WHERE o.script_type = 'XML Creator'
	AND t.config_object_type = 'XML Script'

	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Config',
		'Encounter Type',
		COALESCE(o.description, '<No Description>'),
		t.config_object_prefix,
		o.owner_id,
		COALESCE(o.status, 'NA'),
		t.base_table,
		t.config_object_key
	FROM c_Encounter_Type o
		CROSS JOIN c_Config_Object_Type t
	WHERE t.config_object_type = 'Encounter Type'

	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Config',
		'File',
		COALESCE(o.title, '<No Description>'),
		t.config_object_prefix,
		o.owner_id,
		COALESCE(o.status, 'NA'),
		t.base_table,
		t.config_object_key
	FROM c_Patient_Material o
		CROSS JOIN c_Config_Object_Type t
	WHERE t.config_object_type = 'File'


	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Config',
		'Menu',
		COALESCE(o.description, '<No Description>'),
		t.config_object_prefix,
		o.owner_id,
		COALESCE(o.status, 'NA'),
		t.base_table,
		t.config_object_key
	FROM c_Menu o
		CROSS JOIN c_Config_Object_Type t
	WHERE t.config_object_type = 'Menu'


	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Config',
		'Menu Item',
		COALESCE(o.button_title, '<No Description>'),
		t.config_object_prefix,
		m.owner_id,
		COALESCE(m.status, 'NA'),
		t.base_table,
		t.config_object_key
	FROM c_Menu_Item o
		INNER JOIN c_Menu m
		ON o.menu_id = m.menu_id
		CROSS JOIN c_Config_Object_Type t
	WHERE t.config_object_type = 'Menu Item'


	/*
	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Config',
		'Observation',
		COALESCE(o.description, '<No Description>'),
		t.config_object_prefix,
		o.owner_id,
		COALESCE(o.status, 'NA'),
		t.base_table,
		t.config_object_key
	FROM c_Observation o
		CROSS JOIN c_Config_Object_Type t
	WHERE t.config_object_type = 'Observation'

	*/

	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Config',
		'Property',
		COALESCE(o.description, '<No Description>'),
		t.config_object_prefix,
		o.owner_id,
		COALESCE(o.status, 'NA'),
		t.base_table,
		t.config_object_key
	FROM c_Property o
		CROSS JOIN c_Config_Object_Type t
	WHERE t.config_object_type = 'Property'

	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Config',
		'Treatment Type',
		COALESCE(o.description, '<No Description>'),
		t.config_object_prefix,
		o.owner_id,
		COALESCE(o.status, 'NA'),
		t.base_table,
		t.config_object_key
	FROM c_Treatment_Type o
		CROSS JOIN c_Config_Object_Type t
	WHERE t.config_object_type = 'Treatment Type'

	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Config',
		'Interface',
		COALESCE(o.description, '<No Description>'),
		t.config_object_prefix,
		o.owner_id,
		COALESCE(o.status, 'NA'),
		t.base_table,
		t.config_object_key
	FROM c_Component_Interface o
		CROSS JOIN c_Config_Object_Type t
		CROSS JOIN c_Database_Status s
	WHERE t.config_object_type = 'Interface'
	AND o.subscriber_owner_id = s.customer_id

	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Config',
		'Workplan',
		COALESCE(o.description, '<No Description>'),
		t.config_object_prefix,
		o.owner_id,
		COALESCE(o.status, 'NA'),
		t.base_table,
		t.config_object_key
	FROM c_Workplan o
		CROSS JOIN c_Config_Object_Type t
	WHERE t.config_object_type = 'Workplan'

	-- Treat the display/XML script commands as components

	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Component',
		o.script_type,
		o.context_object + ' ' + COALESCE(o.description, '<No Description>'),
		LEFT(o.script_type, 3) + 'Cmd',
		0,
		'OK',
		'c_Display_Command_Definition',
		'context_object|display_command'
	FROM c_Display_Command_Definition o

	-- Add the chart page components
	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT d.id,
		'Component',
		'Chart Page',
		COALESCE(d.description, '<No Description>'),
		'ChrtPg',
		0,
		COALESCE(d.status, 'NA'),
		'c_Chart_Page_Definition',
		'page_class'
	FROM c_Chart_Page_Definition d

	-- Finally add all the actual components from c_Component_Registry
	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Component',
		o.component_type,
		COALESCE(o.description, '<No Description>'),
		'Cmp',
		ISNULL(o.owner_id, 0),
		COALESCE(o.status, 'NA'),
		'c_Component_Registry',
		'component_id'
	FROM dbo.fn_components() o
	END
ELSE
	BEGIN
	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.config_object_id,
		'Config',
		o.config_object_type,
		o.description,
		t.config_object_prefix,
		o.owner_id,
		o.status,
		t.base_table,
		t.config_object_key
	FROM c_Config_Object o
		INNER JOIN c_Config_Object_Type t
		ON o.config_object_type = t.config_object_type
	WHERE o.config_object_id = @pui_config_object_id

	IF @@ROWCOUNT > 0
		RETURN

	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.report_id,
		'Config',
		'Report',
		COALESCE(o.description, '<No Description>'),
		t.config_object_prefix,
		o.owner_id,
		COALESCE(o.status, 'NA'),
		t.base_table,
		t.config_object_key
	FROM c_Report_Definition o
		CROSS JOIN c_Config_Object_Type t
	WHERE report_id = @pui_config_object_id
	AND t.config_object_type = 'Report'

	IF @@ROWCOUNT > 0
		RETURN

	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Config',
		'Service',
		COALESCE(o.description, '<No Description>'),
		t.config_object_prefix,
		o.owner_id,
		COALESCE(o.status, 'NA'),
		t.base_table,
		t.config_object_key
	FROM o_Service o
		CROSS JOIN c_Config_Object_Type t
	WHERE id = @pui_config_object_id
	AND t.config_object_type = 'Service'

	IF @@ROWCOUNT > 0
		RETURN

	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Config',
		'RTF Script',
		o.context_object + ' ' + o.display_script,
		t.config_object_prefix,
		o.owner_id,
		COALESCE(o.status, 'NA'),
		t.base_table,
		t.config_object_key
	FROM c_Display_Script o
		CROSS JOIN c_Config_Object_Type t
	WHERE id = @pui_config_object_id
	AND o.script_type = 'RTF'
	AND t.config_object_type = 'RTF Script'

	IF @@ROWCOUNT > 0
		RETURN

	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Config',
		'XML Script',
		COALESCE(o.description, '<No Description>'),
		t.config_object_prefix,
		o.owner_id,
		o.status,
		t.base_table,
		t.config_object_key
	FROM c_Display_Script o
		CROSS JOIN c_Config_Object_Type t
	WHERE id = @pui_config_object_id
	AND o.script_type = 'XML Creator'
	AND t.config_object_type = 'XML Script'

	IF @@ROWCOUNT > 0
		RETURN

	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Config',
		'Encounter Type',
		COALESCE(o.description, '<No Description>'),
		t.config_object_prefix,
		o.owner_id,
		COALESCE(o.status, 'NA'),
		t.base_table,
		t.config_object_key
	FROM c_Encounter_Type o
		CROSS JOIN c_Config_Object_Type t
	WHERE id = @pui_config_object_id
	AND t.config_object_type = 'Encounter Type'

	IF @@ROWCOUNT > 0
		RETURN

	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Config',
		'File',
		COALESCE(o.title, '<No Description>'),
		t.config_object_prefix,
		o.owner_id,
		COALESCE(o.status, 'NA'),
		t.base_table,
		t.config_object_key
	FROM c_Patient_Material o
		CROSS JOIN c_Config_Object_Type t
	WHERE id = @pui_config_object_id
	AND t.config_object_type = 'File'

	IF @@ROWCOUNT > 0
		RETURN


	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Config',
		'Menu',
		COALESCE(o.description, '<No Description>'),
		t.config_object_prefix,
		o.owner_id,
		COALESCE(o.status, 'NA'),
		t.base_table,
		t.config_object_key
	FROM c_Menu o
		CROSS JOIN c_Config_Object_Type t
	WHERE id = @pui_config_object_id
	AND t.config_object_type = 'Menu'

	IF @@ROWCOUNT > 0
		RETURN


	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Config',
		'Menu Item',
		COALESCE(o.button_title, '<No Description>'),
		t.config_object_prefix,
		m.owner_id,
		COALESCE(m.status, 'NA'),
		t.base_table,
		t.config_object_key
	FROM c_Menu_Item o
		INNER JOIN c_Menu m
		ON o.menu_id = m.menu_id
		CROSS JOIN c_Config_Object_Type t
	WHERE o.id = @pui_config_object_id
	AND t.config_object_type = 'Menu Item'

	IF @@ROWCOUNT > 0
		RETURN

	/*
	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Config',
		'Observation',
		COALESCE(o.description, '<No Description>'),
		t.config_object_prefix,
		o.owner_id,
		COALESCE(o.status, 'NA'),
		t.base_table,
		t.config_object_key
	FROM c_Observation o
		CROSS JOIN c_Config_Object_Type t
	WHERE id = @pui_config_object_id
	AND t.config_object_type = 'Observation'

	IF @@ROWCOUNT > 0
		RETURN
	*/

	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Config',
		'Property',
		COALESCE(o.description, '<No Description>'),
		t.config_object_prefix,
		o.owner_id,
		COALESCE(o.status, 'NA'),
		t.base_table,
		t.config_object_key
	FROM c_Property o
		CROSS JOIN c_Config_Object_Type t
	WHERE id = @pui_config_object_id
	AND t.config_object_type = 'Property'

	IF @@ROWCOUNT > 0
		RETURN

	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Config',
		'Treatment Type',
		COALESCE(o.description, '<No Description>'),
		t.config_object_prefix,
		o.owner_id,
		COALESCE(o.status, 'NA'),
		t.base_table,
		t.config_object_key
	FROM c_Treatment_Type o
		CROSS JOIN c_Config_Object_Type t
	WHERE id = @pui_config_object_id
	AND t.config_object_type = 'Treatment Type'

	IF @@ROWCOUNT > 0
		RETURN

	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Config',
		'Interface',
		COALESCE(o.description, '<No Description>'),
		t.config_object_prefix,
		o.owner_id,
		COALESCE(o.status, 'NA'),
		t.base_table,
		t.config_object_key
	FROM c_Component_Interface o
		CROSS JOIN c_Config_Object_Type t
		CROSS JOIN c_Database_Status s
	WHERE o.id = @pui_config_object_id
	AND t.config_object_type = 'Interface'
	AND o.subscriber_owner_id = s.customer_id

	IF @@ROWCOUNT > 0
		RETURN

	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Config',
		'Workplan',
		COALESCE(o.description, '<No Description>'),
		t.config_object_prefix,
		o.owner_id,
		COALESCE(o.status, 'NA'),
		t.base_table,
		t.config_object_key
	FROM c_Workplan o
		CROSS JOIN c_Config_Object_Type t
	WHERE id = @pui_config_object_id
	AND t.config_object_type = 'Workplan'

	IF @@ROWCOUNT > 0
		RETURN

	-- Treat the display/XML script commands as components

	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Component',
		o.script_type,
		o.context_object + ' ' + COALESCE(o.description, '<No Description>'),
		LEFT(o.script_type, 3) + 'Cmd',
		0,
		'OK',
		'c_Display_Command_Definition',
		'context_object|display_command'
	FROM c_Display_Command_Definition o
	WHERE id = @pui_config_object_id

	IF @@ROWCOUNT > 0
		RETURN

	-- Add the chart page components
	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT d.id,
		'Component',
		'Chart Page',
		COALESCE(d.description, '<No Description>'),
		'ChrtPg',
		0,
		COALESCE(d.status, 'NA'),
		'c_Chart_Page_Definition',
		'page_class'
	FROM c_Chart_Page_Definition d
	WHERE id = @pui_config_object_id

	IF @@ROWCOUNT > 0
		RETURN

	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT o.id,
		'Component',
		o.component_type,
		COALESCE(o.description, '<No Description>'),
		'Cmp',
		ISNULL(o.owner_id, 0),
		COALESCE(o.status, 'NA'),
		'c_Component_Registry',
		'component_id'
	FROM dbo.fn_components() o
	WHERE id = @pui_config_object_id

	IF @@ROWCOUNT > 0
		RETURN

	INSERT INTO @objectinfo (
		id ,
		object_class ,
		object_type ,
		description ,
		object_type_prefix ,
		owner_id ,
		status,
		base_table,
		base_table_key)
	SELECT CAST(o.domain_item AS uniqueidentifier),
		'BuiltIn',
		'Wizard',
		COALESCE(o.domain_item_description, '<No Description>'),
		t.config_object_prefix,
		0,
		'OK',
		t.base_table,
		t.config_object_key
	FROM c_Domain o
		CROSS JOIN c_Config_Object_Type t
	WHERE domain_id = 'Builtin Wizard'
	AND CAST(o.domain_item AS uniqueidentifier) = @pui_config_object_id
	AND t.config_object_type = 'Wizard'

	IF @@ROWCOUNT > 0
		RETURN

	END

RETURN
END
GO
GRANT SELECT
	ON [dbo].[fn_object_info]
	TO [cprsystem]
GO
