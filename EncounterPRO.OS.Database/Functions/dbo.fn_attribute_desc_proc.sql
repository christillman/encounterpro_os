
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_attribute_desc_proc]
Print 'Drop Function [dbo].[fn_attribute_desc_proc]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_attribute_desc_proc]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_attribute_desc_proc]
GO

-- Create Function [dbo].[fn_attribute_desc_proc]
Print 'Create Function [dbo].[fn_attribute_desc_proc]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.fn_attribute_desc_proc (@ps_value varchar(255))

RETURNS varchar(255)

AS
BEGIN
	DECLARE @ls_description varchar(255)
	SELECT @ls_description = description
	FROM c_Procedure
	WHERE procedure_id = @ps_value
	
	IF @@ROWCOUNT <> 1
		SET @ls_description = @ps_value

	RETURN @ls_description
END

GO
GRANT EXECUTE ON [dbo].[fn_attribute_desc_proc] TO [cprsystem]
GO
