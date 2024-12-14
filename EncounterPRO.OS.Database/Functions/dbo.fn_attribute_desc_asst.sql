
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_attribute_desc_asst]
Print 'Drop Function [dbo].[fn_attribute_desc_asst]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_attribute_desc_asst]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_attribute_desc_asst]
GO

-- Create Function [dbo].[fn_attribute_desc_asst]
Print 'Create Function [dbo].[fn_attribute_desc_asst]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.fn_attribute_desc_asst (@ps_value varchar(255))

RETURNS varchar(255)

AS
BEGIN
	DECLARE @ls_description varchar(255)
	SELECT @ls_description = description
	FROM c_Assessment_Type
	WHERE assessment_type = @ps_value
	
	IF @@ROWCOUNT <> 1
		SET @ls_description = @ps_value

	RETURN @ls_description
END


GO
GRANT EXECUTE ON [dbo].[fn_attribute_desc_asst] TO [cprsystem]
GO
