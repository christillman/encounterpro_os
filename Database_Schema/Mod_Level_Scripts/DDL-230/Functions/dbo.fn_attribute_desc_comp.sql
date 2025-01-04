
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_attribute_desc_comp]
Print 'Drop Function [dbo].[fn_attribute_desc_comp]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_attribute_desc_comp]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_attribute_desc_comp]
GO

-- Create Function [dbo].[fn_attribute_desc_comp]
Print 'Create Function [dbo].[fn_attribute_desc_comp]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_attribute_desc_comp (@ps_value varchar(255))

RETURNS varchar(255)

AS
BEGIN
	DECLARE @ls_description varchar(255)
	SELECT @ls_description = description
	FROM c_Component_Registry
	WHERE component_id = @ps_value
	
	IF @ls_description IS NULL
		SET @ls_description = @ps_value

	RETURN @ls_description
END


GO
GRANT EXECUTE ON [dbo].[fn_attribute_desc_comp] TO [cprsystem]
GO
