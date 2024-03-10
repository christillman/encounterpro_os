
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

-- We need to put these in separate calls, so the optimizer in copmat level 150 doesn't run out of memory

IF @ps_attribute LIKE '%observation_id'
	SET @ls_description = dbo.fn_attribute_desc_obs(@ps_value)

IF @ps_attribute LIKE '%procedure_id'
	SET @ls_description = dbo.fn_attribute_desc_proc(@ps_value)

IF @ps_attribute LIKE '%assessment_id'
	SET @ls_description = dbo.fn_attribute_desc_assm(@ps_value)

IF @ps_attribute LIKE '%property_id'
	SET @ls_description = dbo.fn_attribute_desc_prop(@ps_value)

IF @ps_attribute LIKE '%display_script_id' OR @ps_attribute LIKE '%xml_script_id'
	SET @ls_description = dbo.fn_attribute_desc_dscr(@ps_value)

IF @ps_attribute LIKE '%service'
	SET @ls_description = dbo.fn_attribute_desc_serv(@ps_value)

IF @ps_attribute LIKE '%treatment_type'
	SET @ls_description = dbo.fn_attribute_desc_trtt(@ps_value)

IF @ps_attribute LIKE '%assessment_type'
	SET @ls_description = dbo.fn_attribute_desc_asst(@ps_value)

IF @ps_attribute LIKE '%unit_id'
	SET @ls_description = dbo.fn_attribute_desc_unit(@ps_value)

IF @ps_attribute LIKE '%user_id' 
	SET @ls_description = dbo.fn_attribute_desc_rusr(@ps_value)

IF @ps_attribute LIKE '%report_id'
	SET @ls_description = dbo.fn_attribute_desc_rpt(@ps_value)

IF @ps_attribute LIKE '%office_id'
	SET @ls_description = dbo.fn_attribute_desc_ofc(@ps_value)

IF @ps_attribute LIKE '%room_id'
	SET @ls_description = dbo.fn_attribute_desc_room(@ps_value)
		
IF @ps_attribute LIKE '%component_id'
	SET @ls_description = dbo.fn_attribute_desc_comp(@ps_value)

IF @ps_attribute LIKE '%material_id'
	SET @ls_description = dbo.fn_attribute_desc_pmat(@ps_value)
	
IF @ps_attribute LIKE '%attachment_location_id'
	SET @ls_description = dbo.fn_attribute_desc_attl(@ps_value)
	
RETURN @ls_description 

END
GO
GRANT EXECUTE
	ON [dbo].[fn_attribute_description]
	TO [cprsystem]
GO

