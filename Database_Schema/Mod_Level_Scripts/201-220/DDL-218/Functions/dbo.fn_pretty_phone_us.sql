

SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_pretty_phone_us]
Print 'Drop Function [dbo].[fn_pretty_phone_us]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_pretty_phone_us]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_pretty_phone_us]
GO

-- Create Function [dbo].[fn_pretty_phone_us]
Print 'Create Function [dbo].[fn_pretty_phone_us]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_pretty_phone_us (
	@ps_phone_number varchar(32)
	)
RETURNS varchar(32)

AS
BEGIN

-- The original pretty_phone code, to be used when patient country is U.S.

DECLARE @ls_pretty_phone varchar(32),
		@ls_char char(1),
		@ll_charnum int,
		@ls_digits varchar(15),
		@ls_area varchar(6),
		@ls_number varchar(8),
		@ls_rest varchar(32)

SET @ll_charnum = 0
SET @ls_digits = ''
SET @ls_rest = ''

WHILE @ll_charnum < LEN(@ps_phone_number)
	BEGIN
	SET @ll_charnum = @ll_charnum + 1
	SET @ls_char = SUBSTRING(@ps_phone_number, @ll_charnum, 1)
	
	-- After we have all 10 digits plus punctuation, or when we hit an 'x', just tack the rest on verbatim		
	IF LEN(@ls_digits) = 10 OR @ls_char = 'x'
		BEGIN
		SET @ls_rest = SUBSTRING(@ps_phone_number, @ll_charnum, LEN(@ps_phone_number))
		BREAK
		END

	-- If we have a digit, then add it to the digits variable
	IF @ls_char >= '0' AND @ls_char <= '9'
		SET @ls_digits = @ls_digits + @ls_char
	END

IF LEN(@ls_digits) = 0
	BEGIN
	SET @ls_area = ''
	SET @ls_number = ''
	END
ELSE IF LEN(@ls_digits) <= 7
	BEGIN
	SET @ls_area = ''
	SET @ls_number = SUBSTRING(@ls_digits, 1, 3) + '-' + SUBSTRING(@ls_digits, 4, 4)
	END
ELSE
	BEGIN
	SET @ls_area = '(' + LEFT(@ls_digits, 3) + ') '
	SET @ls_number = SUBSTRING(@ls_digits, 4, 3) + '-' + SUBSTRING(@ls_digits, 7, 4)
	END

SET @ls_pretty_phone = RTRIM(@ls_area + @ls_number + ' ' + @ls_rest)

IF LEN(@ls_pretty_phone) = 0
	SET @ls_pretty_phone = NULL

RETURN @ls_pretty_phone

END

GO
GRANT EXECUTE ON [dbo].[fn_pretty_phone_us] TO [cprsystem]
GO

