

SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_pretty_phone]
Print 'Drop Function [dbo].[fn_pretty_phone]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_pretty_phone]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_pretty_phone]
GO

-- Create Function [dbo].[fn_pretty_phone]
Print 'Create Function [dbo].[fn_pretty_phone]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_pretty_phone (
	@ps_phone_number varchar(32))

RETURNS varchar(32)

AS
BEGIN

-- Strip extraneous characters, just keep the digits for international phone numbers
-- NB Country code prefix is separately handled in [dbo].[p_patient_list_item]
RETURN REPLACE(REPLACE(REPLACE(REPLACE(@ps_phone_number, '-', ''), '(', ''), ')', ''), ' ', '')

END

GO
GO
GRANT EXECUTE ON [dbo].[fn_pretty_phone] TO [cprsystem]
GO

