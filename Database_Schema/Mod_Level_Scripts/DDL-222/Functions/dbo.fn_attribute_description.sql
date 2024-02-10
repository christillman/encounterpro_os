
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
		WHERE [user_id] = @ps_value
	
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

