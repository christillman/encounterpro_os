
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_config_object_context_object]
Print 'Drop Function [dbo].[fn_config_object_context_object]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_config_object_context_object]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_config_object_context_object]
GO

-- Create Function [dbo].[fn_config_object_context_object]
Print 'Create Function [dbo].[fn_config_object_context_object]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_config_object_context_object (
	@pui_config_object_id uniqueidentifier)

RETURNS varchar(24)

AS
BEGIN

DECLARE @ls_context_object varchar(24) = NULL

-- First see if it's in the c_Config_Object table
SELECT @ls_context_object = context_object
FROM c_Config_Object
WHERE config_object_id = @pui_config_object_id

IF @ls_context_object IS NOT NULL
	RETURN @ls_context_object

-- See if it's a report
SELECT @ls_context_object = report_type
FROM c_Report_Definition
WHERE report_id = @pui_config_object_id

IF @ls_context_object IS NOT NULL
	RETURN @ls_context_object

RETURN @ls_context_object
END
GO
GRANT EXECUTE
	ON [dbo].[fn_config_object_context_object]
	TO [cprsystem]
GO

