Print 'Drop Function dbo.fn_first_words'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'dbo.fn_first_words') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION IF EXISTS dbo.fn_first_words
go
Print 'Create Function dbo.fn_first_words'
GO

CREATE FUNCTION dbo.fn_first_words (@description varchar(1000), @num_words integer)
RETURNS varchar(1000)
AS BEGIN
	DECLARE @target varchar(1000)
	DECLARE @start_pos integer
	SET @target = @description

	-- First trim off anything in square brackets at the end, 
	-- this can be a brand name in RxNORM descriptions.
	SET @start_pos = charindex('[ ',reverse(@target))
	IF @start_pos > 0
		SET @target = left(@target, len(@target) - @start_pos - 1)

	-- Also trim off anything after a comma at the end, 
	-- these are modifiers such as ", Reformulated Apr 2012" and ", as calcium carbonate and magnesium chloride"
	SET @start_pos = charindex(' ,',reverse(@target))
	IF @start_pos > 0 AND (
		right(@target, @start_pos + 1) LIKE ', Reformulated%'
		OR right(@target, @start_pos + 1) LIKE ', as %'
		OR right(@target, @start_pos + 1) LIKE ', % Actuat%'
		OR right(@target, @start_pos + 1) LIKE ', % Activations%'
		OR right(@target, @start_pos + 1) LIKE ', % Blisters%'
		OR right(@target, @start_pos + 1) LIKE ', Abuse-Deterrent%'
		)
		SET @target = left(@target, len(@target) - @start_pos - 1)

	SET @start_pos = 1
	WHILE @num_words > 0 AND @start_pos > 0
		BEGIN
		SET @start_pos = charindex(' ',@target,@start_pos + 1)
		SET @num_words = @num_words - 1
		END

	IF @start_pos = 0
		RETURN @description

	SET @target = left(@target, @start_pos - 1)
	-- If the first word of the candidate return ise 
	-- just on symbol (usually % or right-paren) 
	-- then eliminate the first word
	IF substring(@target, 2, 1) = ' ' 
		RETURN substring(@target, 3, 1000)

	RETURN @target
END

-- select dbo.fn_first_words ('one two three four five [extrawords]', 2)

GO
GRANT EXECUTE ON [dbo].[fn_first_words] TO [cprsystem]
GO
