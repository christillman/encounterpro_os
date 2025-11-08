
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_lookup_user_billingid]
Print 'Drop Function [dbo].[fn_lookup_user_billingid]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_lookup_user_billingid]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_lookup_user_billingid]
GO

-- Create Function [dbo].[fn_lookup_user_billingid]
Print 'Create Function [dbo].[fn_lookup_user_billingid]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.fn_lookup_user_billingid (
	@ps_office_id varchar(4),
	@ps_id varchar(255))

RETURNS varchar(255)

AS
BEGIN

DECLARE @ls_external_id varchar(24)

SELECT @ls_external_id = external_id
FROM b_Provider_Translation
WHERE office_id = @ps_office_id
AND epro_id = @ps_id

RETURN @ls_external_id

END

GO
GRANT EXECUTE
	ON [dbo].[fn_lookup_user_billingid]
	TO [cprsystem]
GO

