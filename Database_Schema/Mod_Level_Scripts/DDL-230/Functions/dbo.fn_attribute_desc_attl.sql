
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_attribute_desc_attl]
Print 'Drop Function [dbo].[fn_attribute_desc_attl]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_attribute_desc_attl]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_attribute_desc_attl]
GO

-- Create Function [dbo].[fn_attribute_desc_attl]
Print 'Create Function [dbo].[fn_attribute_desc_attl]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_attribute_desc_attl (@ps_value varchar(255))

RETURNS varchar(255)

AS
BEGIN
	DECLARE @ls_description varchar(255)
	SELECT @ls_description = '\\' + attachment_server + '\' + attachment_share
	FROM c_Attachment_Location
	WHERE attachment_location_id = CAST(@ps_value as integer)
	
	IF @ls_description IS NULL
		SET @ls_description = @ps_value

	RETURN @ls_description
END


GO
GRANT EXECUTE ON [dbo].[fn_attribute_desc_attl] TO [cprsystem]
GO
