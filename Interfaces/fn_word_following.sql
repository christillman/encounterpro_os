SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

DROP FUNCTION [dbo].[fn_word_following]
GO

CREATE FUNCTION [dbo].[fn_word_following] (@descr varchar(255), @term varchar(255))

RETURNS varchar(255)

AS
BEGIN
	--DECLARE @descr varchar(255)
	--DECLARE @term varchar(255)
	--SET @term = 'joint'
	--SET @descr= 'Sprain of the superior tibiofibular joint and ligament, unspecified knee, initial encounter'
	DECLARE @ls_word_following varchar(255)
	DECLARE @idx_end_of_term int 
	DECLARE @idx_space int
	DECLARE @idx_comma int

	-- if term is at end or not found, return ''
	IF charindex(@term,@descr) = 0 OR charindex(@term,@descr) + len(@term) >= len(@descr)
		RETURN ''

	SET @idx_end_of_term = charindex(@term,@descr) + len(rtrim(@term))
	
	-- first check for comma following @term
	IF substring(@descr, @idx_end_of_term, 2) = ', '
		begin
			SET @ls_word_following = substring(@descr, @idx_end_of_term + 2, len(@descr))
			SET @idx_space = charindex(' ', @ls_word_following)
			SET @idx_comma = charindex(',', @ls_word_following)
			IF @idx_comma > 0 AND @idx_comma < @idx_space
				SET @idx_space = @idx_comma
			IF @idx_space = 0 
				RETURN @ls_word_following
			RETURN substring(@ls_word_following, 1, @idx_space - 1)
		end

	IF substring(@descr, @idx_end_of_term, 1) = ' '
		begin
			SET @ls_word_following = substring(@descr, @idx_end_of_term + 1, len(@descr))
			SET @idx_space = charindex(' ', @ls_word_following)
			SET @idx_comma = charindex(',', @ls_word_following)
			IF @idx_comma > 0 AND @idx_comma < @idx_space
				SET @idx_space = @idx_comma
			IF @idx_space = 0 
				RETURN @ls_word_following
			RETURN substring(@ls_word_following, 1, @idx_space - 1)
		end

	RETURN ''

END

GO

GRANT EXECUTE ON [dbo].[fn_word_following] TO [cprsystem] AS [dbo]
GO


