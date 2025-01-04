
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_config_object_description]
Print 'Drop Function [dbo].[fn_config_object_description]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_config_object_description]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_config_object_description]
GO

-- Create Function [dbo].[fn_config_object_description]
Print 'Create Function [dbo].[fn_config_object_description]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_config_object_description (
	@pui_config_object_id uniqueidentifier)

RETURNS varchar(80)

AS
BEGIN

DECLARE @ls_description varchar(80)

IF @pui_config_object_id IS NOT NULL
	BEGIN
	SELECT @ls_description = object_type_prefix + ': ' + description
	FROM dbo.fn_object_info(@pui_config_object_id)
	END

RETURN @ls_description
END
GO
GRANT EXECUTE
	ON [dbo].[fn_config_object_description]
	TO [cprsystem]
GO

