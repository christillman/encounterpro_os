
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_attribute_value_substitute]
Print 'Drop Function [dbo].[fn_attribute_value_substitute]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_attribute_value_substitute]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_attribute_value_substitute]
GO

-- Create Function [dbo].[fn_attribute_value_substitute]
Print 'Create Function [dbo].[fn_attribute_value_substitute]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_attribute_value_substitute (
	@ps_value varchar(255),
	@ps_user_id varchar(24) )

RETURNS varchar(255)

AS
BEGIN
DECLARE @ls_new_value varchar(255),
		@ls_token varchar(40),
		@ll_charindex int,
		@ls_context_object varchar(24),
		@ls_temp varchar(255)

IF LEFT(@ps_value, 1) = '%' AND RIGHT(@ps_value, 1) = '%' AND LEN(@ps_value) > 2
	BEGIN
	SET @ls_temp = SUBSTRING(@ps_value, 2, LEN(@ps_value) - 2)
	SET @ll_charindex = CHARINDEX(' ', @ls_temp)
	IF @ll_charindex > 0
		BEGIN
		SET @ls_context_object = LEFT(@ls_temp, @ll_charindex - 1)
		IF @ls_context_object IN ('General', 'Patient', 'Encounter', 'Assessment', 'Treatment', 'Observation', 'Attachment')
			SET @ls_token = RIGHT(@ls_temp, len(@ls_temp) - @ll_charindex)
		ELSE
			SET @ls_token = LEFT(@ls_temp, 40)
			SET @ls_context_object = 'General'
		END
	ELSE
		BEGIN
		SET @ls_token = LEFT(@ls_temp, 40)
		SET @ls_context_object = 'General'
		END
	
	IF @ls_context_object = 'General'
		SET @ls_new_value = dbo.fn_get_preference('PROPERTY', @ls_token, @ps_user_id, DEFAULT)
	END
ELSE
	SET @ls_new_value = @ps_value


RETURN @ls_new_value 

END
GO
GRANT EXECUTE
	ON [dbo].[fn_attribute_value_substitute]
	TO [cprsystem]
GO

