
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_lookup_user]
Print 'Drop Function [dbo].[fn_lookup_user]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_lookup_user]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_lookup_user]
GO

-- Create Function [dbo].[fn_lookup_user]
Print 'Create Function [dbo].[fn_lookup_user]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.fn_lookup_user (
	@ps_office_id varchar(4),
	@ps_id varchar(255))

RETURNS varchar(255)

AS
BEGIN

DECLARE @ls_epro_id varchar(255)

SELECT @ls_epro_id = epro_id
FROM b_Provider_Translation
WHERE office_id = @ps_office_id
AND external_id = @ps_id

RETURN @ls_epro_id

END

GO
GRANT EXECUTE
	ON [dbo].[fn_lookup_user]
	TO [cprsystem]
GO

