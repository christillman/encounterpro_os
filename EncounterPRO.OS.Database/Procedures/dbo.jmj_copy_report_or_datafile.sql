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

-- Drop Procedure [dbo].[jmj_copy_report_or_datafile]
Print 'Drop Procedure [dbo].[jmj_copy_report_or_datafile]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_copy_report_or_datafile]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_copy_report_or_datafile]
GO

-- Create Procedure [dbo].[jmj_copy_report_or_datafile]
Print 'Create Procedure [dbo].[jmj_copy_report_or_datafile]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_copy_report_or_datafile (
	@ps_copy_from_report_id varchar(40) ,
	@ps_new_description varchar(80) ,
	@ps_created_by varchar(24) ,
	@ps_report_id varchar(40) OUTPUT )
AS

DECLARE @ll_return int ,
		@ls_report_type varchar(24) ,
		@ls_report_category varchar(24),
		@ls_component_id varchar(24) ,
		@ls_machine_component_id varchar(24),
		@ls_created_by varchar(24) ,
		@ll_owner_id int ,
		@ls_status varchar(12) ,
		@ll_sts int,
		@ll_attribute_sequence int,
		@ls_attribute varchar(64),
		@ls_value varchar(255),
		@ll_referenced_display_script_id int,
		@ll_new_display_script_id int,
		@lid_referenced_parent_config_object_id uniqueidentifier,
		@ls_config_object_type varchar(24),
		@ll_error int,
		@ll_rowcount int

SET @ll_return = 1

DECLARE @lui_from_report_id uniqueidentifier,
		@lui_new_report_id uniqueidentifier

SET @lui_from_report_id = CAST(@ps_copy_from_report_id AS uniqueidentifier)


SELECT @ll_owner_id = customer_id
FROM c_Database_Status

-- This is put in to let PowerBuilder think the proc works
IF @ps_copy_from_report_id = '0'
	RETURN 1

SELECT	@ls_report_type = report_type,
		@ls_report_category = report_category,
		@ls_component_id = component_id,
		@ls_machine_component_id = machine_component_id,
		@ls_config_object_type = config_object_type
FROM c_Report_Definition
WHERE report_id = @lui_from_report_id

IF @ls_config_object_type = 'Datafile'
	BEGIN
	EXECUTE @ll_sts = jmj_new_datafile
			@ps_description = @ps_new_description,
			@ps_context_object = @ls_report_type,
			@ps_component_id = @ls_component_id,
			@ps_created_by = @ps_created_by,
			@ps_status = 'OK',
			@ps_report_id = @ps_report_id OUTPUT

	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		RETURN -1


	IF @ll_sts <= 0
		RETURN -1
	END
ELSE
	BEGIN
	EXECUTE @ll_sts = jmj_new_report
			@ps_description = @ps_new_description,
			@ps_report_type = @ls_report_type,
			@ps_report_category = @ls_report_category,
			@ps_component_id = @ls_component_id,
			@ps_machine_component_id = @ls_machine_component_id,
			@ps_created_by = @ps_created_by,
			@pl_owner_id = @ll_owner_id,
			@ps_status = 'OK',
			@pl_version = 1 ,
			@ps_report_id = @ps_report_id OUTPUT

	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		RETURN -1


	IF @ll_sts <= 0
		RETURN -1
	END

SET @lui_new_report_id = CAST(@ps_report_id AS uniqueidentifier)

-- Move the long description
UPDATE r
SET long_description = r2.long_description
FROM c_Report_Definition r
	CROSS JOIN c_Report_Definition r2
WHERE r.report_id = @lui_new_report_id
AND r2.report_id = @lui_from_report_id



-- Now copy the attributes

INSERT INTO c_Report_Attribute (
	report_id,
	attribute,
	value,
	component_attribute,
	objectdata,
	component_id)
SELECT @lui_new_report_id,
	attribute,
	value,
	component_attribute,
	objectdata,
	component_id
FROM c_Report_Attribute
WHERE report_id = @lui_from_report_id

INSERT INTO o_Report_Attribute (
	report_id,
	office_id,
	attribute,
	value)
SELECT @lui_new_report_id,
	office_id,
	attribute,
	value
FROM o_Report_Attribute
WHERE report_id = @lui_from_report_id

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
	query )
SELECT @lui_new_report_id,
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
	query 
FROM c_Component_Param
WHERE id = @lui_from_report_id

INSERT INTO o_Report_Printer (
	report_id,
	office_id,
	computer_id,
	room_id,
	printer,
	sort_sequence)
SELECT @lui_new_report_id,
	office_id,
	computer_id,
	room_id,
	printer,
	sort_sequence
FROM o_Report_Printer
WHERE report_id = @lui_from_report_id


-- Now recursively get all the display scripts referenced by this display script
-- which do not already have the same parent config object
DECLARE lc_DisplayScript CURSOR LOCAL FAST_FORWARD FOR
	SELECT a.attribute_sequence, a.attribute, a.value
	FROM c_Report_Attribute a
	WHERE a.report_id = @lui_new_report_id
	AND (a.attribute LIKE '%display_script_id'
		OR a.attribute LIKE '%xml_script_id')
	AND ISNUMERIC(a.value) = 1

OPEN lc_DisplayScript

FETCH lc_DisplayScript INTO @ll_attribute_sequence, @ls_attribute, @ls_value 

WHILE @@FETCH_STATUS = 0
	BEGIN
	SET @ll_referenced_display_script_id = CAST(@ls_value AS int)

	SELECT @lid_referenced_parent_config_object_id = d.parent_config_object_id
	FROM c_Display_Script d
	WHERE d.display_script_id = @ll_referenced_display_script_id
	
	IF (@lui_new_report_id <> @lid_referenced_parent_config_object_id)
		OR (@lid_referenced_parent_config_object_id IS NULL)
		BEGIN
		-- Make a copy of each nested display script
		EXECUTE @ll_new_display_script_id = sp_local_copy_display_script
						@pl_display_script_id = @ll_referenced_display_script_id ,
						@ps_new_parent_config_object_id = @lui_new_report_id
		IF @ll_new_display_script_id > 0
			BEGIN
			-- Update the attribute value in our new display script to point to the nested display script
			UPDATE a
			SET value = CAST(@ll_new_display_script_id AS varchar(255)) 
			FROM c_Report_Attribute a
			WHERE a.report_id = @lui_new_report_id
			AND a.attribute_sequence = @ll_attribute_sequence
			END
		END
	FETCH lc_DisplayScript INTO @ll_attribute_sequence, @ls_attribute, @ls_value 
	END

CLOSE lc_DisplayScript
DEALLOCATE lc_DisplayScript

-- Create the version record
EXECUTE config_create_object_version
	@pui_config_object_id = @ps_report_id ,
	@ps_config_object_type = @ls_config_object_type ,
	@ps_context_object = @ls_report_type,
	@pl_owner_id = @ll_owner_id ,
	@ps_description = @ps_new_description ,
	@ps_config_object_category = NULL ,
	@pl_version = 1 ,
	@pi_objectdata = NULL ,
	@ps_created_by = @ps_created_by 

RETURN @ll_return

GO
GRANT EXECUTE
	ON [dbo].[jmj_copy_report_or_datafile]
	TO [cprsystem]
GO

