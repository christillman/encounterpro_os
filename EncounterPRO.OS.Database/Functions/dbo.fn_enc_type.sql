DROP FUNCTION [fn_enc_type]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [fn_enc_type] (
	@descr varchar(500)
	)

RETURNS varchar(90)

AS
BEGIN

-- Return the annoying repeated encounter type used in an assessment description

DECLARE @suffix varchar(90)
DECLARE @start_suffix integer

SET @start_suffix = charindex(', sequela', @descr, 1)
IF @start_suffix > 0 
	RETURN substring(@descr, @start_suffix + 2, 90)

SET @start_suffix = charindex(', initial encounter', @descr, 1)
IF @start_suffix > 0 
	RETURN substring(@descr, @start_suffix + 2, 90)

SET @start_suffix = charindex(', subsequent encounter', @descr, 1)
IF @start_suffix > 0 
	RETURN substring(@descr, @start_suffix + 2, 90)

RETURN @descr

END
GO
GRANT EXECUTE
	ON [dbo].[fn_enc_type]
	TO [cprsystem]