
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_attribute_desc_obs]
Print 'Drop Function [dbo].[fn_attribute_desc_obs]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_attribute_desc_obs]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_attribute_desc_obs]
GO

-- Create Function [dbo].[fn_attribute_desc_obs]
Print 'Create Function [dbo].[fn_attribute_desc_obs]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_attribute_desc_obs (@ps_value varchar(255))

RETURNS varchar(255)

AS
BEGIN
	DECLARE @ls_description varchar(255)
	SELECT @ls_description = description
	FROM c_Observation
	WHERE observation_id = @ps_value
	
	IF @ls_description IS NULL
		SET @ls_description = @ps_value

	RETURN @ls_description
END


GO
GRANT EXECUTE ON [dbo].[fn_attribute_desc_obs] TO [cprsystem]
GO
