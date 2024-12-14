
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_attribute_desc_rusr]
Print 'Drop Function [dbo].[fn_attribute_desc_rusr]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_attribute_desc_rusr]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_attribute_desc_rusr]
GO

-- Create Function [dbo].[fn_attribute_desc_rusr]
Print 'Create Function [dbo].[fn_attribute_desc_rusr]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.fn_attribute_desc_rusr (@ps_value varchar(255))

RETURNS varchar(255)

AS
BEGIN
	DECLARE @ls_description varchar(255)
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

	RETURN @ls_description
END

GO
GRANT EXECUTE ON [dbo].[fn_attribute_desc_rusr] TO [cprsystem]
GO
