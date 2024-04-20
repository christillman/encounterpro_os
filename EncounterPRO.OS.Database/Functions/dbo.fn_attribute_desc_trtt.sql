
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_attribute_desc_trtt]
Print 'Drop Function [dbo].[fn_attribute_desc_trtt]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_attribute_desc_trtt]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_attribute_desc_trtt]
GO

-- Create Function [dbo].[fn_attribute_desc_trtt]
Print 'Create Function [dbo].[fn_attribute_desc_trtt]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_attribute_desc_trtt (@ps_value varchar(255))

RETURNS varchar(255)

AS
BEGIN
	DECLARE @ls_description varchar(255)
	SELECT @ls_description = description
	FROM c_Treatment_Type
	WHERE treatment_type = @ps_value
	
	IF @@ROWCOUNT <> 1
		SET @ls_description = @ps_value

	RETURN @ls_description
END

GO
GRANT EXECUTE ON [dbo].[fn_attribute_desc_trtt] TO [cprsystem]
GO

