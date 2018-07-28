CREATE FUNCTION fn_string_to_identifier (
	@ps_string varchar(128))

RETURNS varchar(128)

AS
BEGIN
DECLARE @ls_identifier varchar(128),
		@ls_char char(1),
		@ll_char int

SET @ll_char = 1
SET @ls_identifier = ''

WHILE @ll_char > 0 and @ll_char <= LEN(@ps_string)
	BEGIN
	
	SET @ls_char = SUBSTRING(@ps_string, @ll_char, 1)
	
	IF @ls_char NOT LIKE '[a-z]'
		AND @ls_char NOT LIKE '[A-Z]'
		AND @ls_char NOT LIKE '[0-9]'
		AND @ls_char NOT LIKE '[.$~]'
			SET @ls_identifier = @ls_identifier + '_'
	ELSE
			SET @ls_identifier = @ls_identifier + @ls_char
			
	SET @ll_char = @ll_char + 1
	END

IF @ls_identifier = ''
	SET @ls_identifier = NULL

RETURN @ls_identifier 

END

