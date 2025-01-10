
-- Drop Function [dbo].[fn_excl_injury_intent]
Print 'Drop Function [dbo].[fn_excl_injury_intent]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_excl_injury_intent]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_excl_injury_intent]
GO

-- Create Function [dbo].[fn_excl_injury_intent]
Print 'Create Function [dbo].[fn_excl_injury_intent]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [fn_excl_injury_intent] (
	@descr varchar(500)
	)

RETURNS varchar(500)

AS
BEGIN

-- Cut off the annoying repeated injury blame categories when trying to parse assessment descriptions

-- Note will only apply to T assessments, in other cases not quite so repetitive

DECLARE @suffix varchar(90)
DECLARE @start_suffix integer
DECLARE @descr_no_enc_type varchar(500)

-- Note, dbo.fn_excl_enc_type must be applied first, these "intents" precede the encounter type.
-- So do that here (don't require nesting of the two functions)
SET @descr_no_enc_type = dbo.fn_excl_enc_type(@descr)

SET @start_suffix = charindex(', accidental (unintentional)', @descr_no_enc_type, 1)
IF @start_suffix > 0 
	RETURN substring(@descr_no_enc_type, 1, @start_suffix - 1)

SET @start_suffix = charindex(', intentional self-harm', @descr_no_enc_type, 1)
IF @start_suffix > 0 
	RETURN substring(@descr_no_enc_type, 1, @start_suffix - 1)

SET @start_suffix = charindex(', undetermined', @descr_no_enc_type, 1)
IF @start_suffix > 0 
	RETURN substring(@descr_no_enc_type, 1, @start_suffix - 1)

SET @start_suffix = charindex(', assault', @descr_no_enc_type, 1)
IF @start_suffix > 0 
	RETURN substring(@descr_no_enc_type, 1, @start_suffix - 1)

RETURN @descr_no_enc_type

END

GO
GRANT EXECUTE ON [dbo].[fn_excl_injury_intent] TO [cprsystem]
GO

