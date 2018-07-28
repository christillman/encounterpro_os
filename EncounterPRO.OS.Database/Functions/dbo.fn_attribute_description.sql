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

-- Drop Function [dbo].[fn_attribute_description]
Print 'Drop Function [dbo].[fn_attribute_description]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_attribute_description]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_attribute_description]
GO

-- Create Function [dbo].[fn_attribute_description]
Print 'Create Function [dbo].[fn_attribute_description]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_attribute_description (
	@ps_attribute varchar(40),
	@ps_value varchar(255) )

RETURNS varchar(255)

AS
BEGIN
DECLARE @ls_description varchar(255),
		@ls_preference_id varchar(255)

IF @ps_value IS NULL OR @ps_value = ''
	BEGIN
	SET @ls_description = NULL
	RETURN @ls_description
	END

SET @ls_description = @ps_value


IF @ps_value LIKE '\%General%' ESCAPE '\'
	BEGIN
	SET @ls_preference_id = SUBSTRING(@ps_value, 10, LEN(@ps_value) - 10)

	SELECT @ls_description = description
	FROM c_Preference
	WHERE preference_id = @ls_preference_id
	
	IF @@ROWCOUNT <> 1
		SET @ls_description = @ps_value

	RETURN @ls_description
	END

IF @ps_attribute LIKE '%observation_id'
	BEGIN
	SELECT @ls_description = description
	FROM c_Observation
	WHERE observation_id = @ps_value
	
	IF @@ROWCOUNT <> 1
		SET @ls_description = @ps_value
	END

IF @ps_attribute LIKE '%procedure_id'
	BEGIN
	SELECT @ls_description = description
	FROM c_Procedure
	WHERE procedure_id = @ps_value
	
	IF @@ROWCOUNT <> 1
		SET @ls_description = @ps_value
	END

IF @ps_attribute LIKE '%assessment_id'
	BEGIN
	SELECT @ls_description = description
	FROM c_Assessment_Definition
	WHERE assessment_id = @ps_value
	
	IF @@ROWCOUNT <> 1
		SET @ls_description = @ps_value
	END

IF @ps_attribute LIKE '%property_id'
	BEGIN
	SELECT @ls_description = description
	FROM c_Property
	WHERE property_id = CAST(@ps_value as integer)
	
	IF @@ROWCOUNT <> 1
		SET @ls_description = @ps_value
	END

IF @ps_attribute LIKE '%display_script_id' OR @ps_attribute LIKE '%xml_script_id'
	BEGIN
	SELECT @ls_description = display_script
	FROM c_Display_Script
	WHERE display_script_id = CAST(@ps_value as integer)
	
	IF @@ROWCOUNT <> 1
		SET @ls_description = @ps_value
	END

IF @ps_attribute LIKE '%service'
	BEGIN
	SELECT @ls_description = description
	FROM o_Service
	WHERE service = @ps_value
	
	IF @@ROWCOUNT <> 1
		SET @ls_description = @ps_value
	END

IF @ps_attribute LIKE '%treatment_type'
	BEGIN
	SELECT @ls_description = description
	FROM c_Treatment_Type
	WHERE treatment_type = @ps_value
	
	IF @@ROWCOUNT <> 1
		SET @ls_description = @ps_value
	END

IF @ps_attribute LIKE '%assessment_type'
	BEGIN
	SELECT @ls_description = description
	FROM c_Assessment_Type
	WHERE assessment_type = @ps_value
	
	IF @@ROWCOUNT <> 1
		SET @ls_description = @ps_value
	END

IF @ps_attribute LIKE '%unit_id'
	BEGIN
	SELECT @ls_description = description
	FROM c_Unit
	WHERE unit_id = @ps_value
	
	IF @@ROWCOUNT <> 1
		SET @ls_description = @ps_value
	END

IF @ps_attribute LIKE '%user_id' 
		OR @ps_attribute LIKE '%approved_by' 
		OR @ps_attribute LIKE '%ordered_by'
		OR @ps_attribute LIKE '%ordered_for'
		OR @ps_attribute LIKE '%completed_by'
	BEGIN
	IF LEFT(@ps_value, 1) = '!'
		SELECT @ls_description = role_name
		FROM c_role
		WHERE role_id = @ps_value
	ELSE
		SELECT @ls_description = user_full_name
		FROM c_User
		WHERE user_id = @ps_value
	
	IF @@ROWCOUNT <> 1
		SET @ls_description = @ps_value
	END

IF @ps_attribute LIKE '%report_id'
	BEGIN
	SELECT @ls_description = description
	FROM c_Report_Definition
	WHERE report_id = @ps_value
	
	IF @@ROWCOUNT <> 1
		SET @ls_description = @ps_value
	END

IF @ps_attribute LIKE '%office_id'
	BEGIN
	SELECT @ls_description = description
	FROM c_Office
	WHERE office_id = @ps_value
	
	IF @@ROWCOUNT <> 1
		SET @ls_description = @ps_value
	END

IF @ps_attribute LIKE '%room_id'
	BEGIN 
	SELECT @ls_description = room_name
	FROM o_Rooms
	WHERE room_id = @ps_value
	
	IF @@ROWCOUNT <> 1
		SET @ls_description = @ps_value
	END

IF @ps_attribute LIKE '%component_id'
	BEGIN 
	SELECT @ls_description = description
	FROM c_Component_Registry
	WHERE component_id = @ps_value
	
	IF @@ROWCOUNT <> 1
		SET @ls_description = @ps_value
	END

IF @ps_attribute LIKE '%material_id'
	BEGIN 
	SELECT @ls_description = title
	FROM c_Patient_Material
	WHERE material_id = CAST(@ps_value as integer)
	
	IF @@ROWCOUNT <> 1
		SET @ls_description = @ps_value
	END

IF @ps_attribute LIKE '%attachment_location_id'
	BEGIN 
	SELECT @ls_description = '\\' + attachment_server + '\' + attachment_share
	FROM c_Attachment_Location
	WHERE attachment_location_id = CAST(@ps_value as integer)
	
	IF @@ROWCOUNT <> 1
		SET @ls_description = @ps_value
	END

RETURN @ls_description 

END
GO
GRANT EXECUTE
	ON [dbo].[fn_attribute_description]
	TO [cprsystem]
GO

