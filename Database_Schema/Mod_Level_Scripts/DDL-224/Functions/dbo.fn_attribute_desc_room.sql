
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_attribute_desc_room]
Print 'Drop Function [dbo].[fn_attribute_desc_room]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_attribute_desc_room]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION IF EXISTS [dbo].[fn_attribute_desc_room]
GO

-- Create Function [dbo].[fn_attribute_desc_room]
Print 'Create Function [dbo].[fn_attribute_desc_room]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_attribute_desc_room (@ps_value varchar(255))

RETURNS varchar(255)

AS
BEGIN
	DECLARE @ls_description varchar(255)
	SELECT @ls_description = room_name
	FROM o_Rooms
	WHERE room_id = @ps_value
	
	IF @@ROWCOUNT <> 1
		SET @ls_description = @ps_value

	RETURN @ls_description
END

GO
GRANT EXECUTE ON [dbo].[fn_attribute_desc_room] TO [cprsystem]
GO
