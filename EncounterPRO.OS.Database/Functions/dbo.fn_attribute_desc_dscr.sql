
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_attribute_desc_dscr]
Print 'Drop Function [dbo].[fn_attribute_desc_dscr]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_attribute_desc_dscr]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_attribute_desc_dscr]
GO

-- Create Function [dbo].[fn_attribute_desc_dscr]
Print 'Create Function [dbo].[fn_attribute_desc_dscr]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_attribute_desc_dscr (@ps_value varchar(255))

RETURNS varchar(255)

AS
BEGIN
	DECLARE @ls_description varchar(255)
	SELECT @ls_description = display_script
	FROM c_Display_Script
	WHERE display_script_id = CAST(@ps_value as integer)
	
	IF @@ROWCOUNT <> 1
		SET @ls_description = @ps_value

	RETURN @ls_description
END