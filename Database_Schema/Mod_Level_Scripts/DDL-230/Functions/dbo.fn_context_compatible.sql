
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_context_compatible]
Print 'Drop Function [dbo].[fn_context_compatible]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_context_compatible]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_context_compatible]
GO

-- Create Function [dbo].[fn_context_compatible]
Print 'Create Function [dbo].[fn_context_compatible]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_context_compatible (
	@ps_existing_context varchar(12),
	@ps_new_context varchar(12) )

RETURNS bit

AS
BEGIN
DECLARE @li_compatible bit

SET @li_compatible = 0

-- If the two contexts are the same then they're compatible
IF @ps_existing_context = @ps_new_context
	SET @li_compatible = 1

-- The general context is compatible with everything
IF @ps_new_context = 'General'
	SET @li_compatible = 1

-- If the existing context isn't general then it's always compatible with 'Patient'
IF @ps_existing_context <> 'General' AND @ps_new_context = 'Patient'
	SET @li_compatible = 1


RETURN @li_compatible 

END

GO
GRANT EXECUTE
	ON [dbo].[fn_context_compatible]
	TO [cprsystem]
GO

