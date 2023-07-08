SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

DROP FUNCTION [dbo].[fn_word_preceding]
GO

CREATE FUNCTION [dbo].[fn_word_preceding] (@descr varchar(255), @term varchar(255))

RETURNS varchar(255)

AS
BEGIN
	--DECLARE @descr varchar(255)
	--DECLARE @term varchar(255)
	--SET @term = 'joint'
	--SET @descr= 'Sprain of the superior tibiofibular joint and ligament, unspecified knee, initial encounter'
	DECLARE @ls_word_preceding varchar(255)
	DECLARE @idx_end_of_term int 
	DECLARE @idx_space int
	DECLARE @idx_comma int

	-- if term is at beginning or not found, return ''
	IF charindex(@term,@descr) = 0 OR charindex(@term,ltrim(@descr)) = 1
		RETURN ''

	SET @idx_end_of_term = charindex(@term,@descr) + len(rtrim(@term))
	
	-- first check for comma preceding @term
	IF substring(@descr, charindex(@term,@descr) - 2, 2) = ', '
		begin
			SET @ls_word_preceding = substring(@descr, 1, charindex(@term,@descr) - 3)
			SET @idx_space = charindex(' ', reverse(@ls_word_preceding))
			IF @idx_space = 0 
				RETURN @ls_word_preceding
			RETURN substring(@ls_word_preceding, len(@ls_word_preceding) - @idx_space + 2, len(@ls_word_preceding))
		end

	IF substring(@descr, charindex(@term,@descr) - 1, 1) = ' '
		begin
			SET @ls_word_preceding = substring(@descr, 1, charindex(@term,@descr) - 2)
			SET @idx_space = charindex(' ', reverse(@ls_word_preceding))
			IF @idx_space = 0 
				RETURN @ls_word_preceding
			RETURN substring(@ls_word_preceding, len(@ls_word_preceding) - @idx_space + 2, len(@ls_word_preceding))
		end

	RETURN ''

END

GO

GRANT EXECUTE ON [dbo].[fn_word_preceding] TO [cprsystem] AS [dbo]
GO


