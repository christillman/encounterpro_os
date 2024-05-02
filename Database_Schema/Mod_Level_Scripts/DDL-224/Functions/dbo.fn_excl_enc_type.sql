DROP FUNCTION [fn_excl_enc_type]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [fn_excl_enc_type] (
	@descr varchar(500)
	)

RETURNS varchar(500)

AS
BEGIN

-- Cut off the annoying repeated encounter types when trying to parse assessment descriptions

DECLARE @suffix varchar(90)
DECLARE @start_suffix integer

SET @start_suffix = charindex(', sequela', @descr, 1)
IF @start_suffix > 0 
	RETURN substring(@descr, 1, @start_suffix - 1)

SET @start_suffix = charindex(', initial encounter', @descr, 1)
IF @start_suffix > 0 
	RETURN substring(@descr, 1, @start_suffix - 1)

SET @start_suffix = charindex(', subsequent encounter', @descr, 1)
IF @start_suffix > 0 
	RETURN substring(@descr, 1, @start_suffix - 1)

RETURN @descr

END

GO
GRANT EXECUTE ON [dbo].[fn_excl_enc_type] TO [cprsystem]
GO
