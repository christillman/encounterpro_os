
Print 'Drop Function [dbo].[fn_strength_sort]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_strength_sort]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION dbo.fn_strength_sort
go
Print 'Create Function [dbo].[fn_strength_sort]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_strength_sort (@drug_description varchar(1000))
RETURNS varchar(1000)
AS BEGIN
	declare @last_digit_pos integer, @num_rev integer, @num_rev2 integer, @first_digit_pos integer
	declare @strength_str varchar(30)
	declare @to_return varchar(1000), @to_parse varchar(1000)

	-- space is usually after the last digit, but also allow slash for e.g. 
	SET @last_digit_pos = patindex('%[0-9][ /]%', @drug_description)
	IF @last_digit_pos = 0
		RETURN @drug_description

	SET @to_return = ''
	SET @to_parse = @drug_description

	WHILE @last_digit_pos > 0
		BEGIN
		-- find the space prior to the digits, + 1 to get past the space/slash to the final digit
		SET @num_rev = charindex(' ', reverse(@to_parse), len(@to_parse) - @last_digit_pos + 1)
		SET @num_rev2 = charindex('/', reverse(@to_parse), len(@to_parse) - @last_digit_pos + 1)
		-- Could be slash or space; pick the closest one
		IF @num_rev2 > 0 AND (@num_rev2 < @num_rev OR @num_rev = 0)
			SET @num_rev = @num_rev2
		IF @num_rev > 0
			BEGIN
			-- +1 to adjust for the subtraction, + 1 to go past the space/slash to the first digit
			SET @first_digit_pos = len(@to_parse) - @num_rev + 1 + 1
			IF @first_digit_pos > 1
				BEGIN

				-- get the numbers, from the first digit to the last digit inclusive
				SET @strength_str = substring(@to_parse, @first_digit_pos, @last_digit_pos - @first_digit_pos + 1)

				IF isnumeric(@strength_str) = 1
					BEGIN

					-- Add leading zeroes to integer part	
					IF charindex('.', @strength_str) = 0 
						SET @strength_str = RIGHT ('0000000000'+@strength_str,10)
					ELSE
						SET @strength_str = RIGHT ('0000000000'+ LEFT(@strength_str,charindex('.', @strength_str) - 1), 10)
							+ SUBSTRING(@strength_str,charindex('.', @strength_str), 1000)
					-- Add trailing zeroes
					IF charindex('.', @strength_str) = 0 
						SET @strength_str = @strength_str + '.00000'
					ELSE
						SET @strength_str = LEFT(@strength_str+'00000',16)

					END
				END
			END
		ELSE
			BEGIN
			-- No delimiters found before the digit. In this case 
			SET @first_digit_pos = @last_digit_pos + 1
			SET @strength_str = ''
			END
		-- @first_digit_pos is the first digit, so get to char before it to include the space but no digits
		SET @to_return = @to_return + @strength_str + left(@to_parse, @first_digit_pos - 1)
		-- For the next one, move past the end of the previous last digit to the following space / slash
		SET @to_parse = substring(@to_parse, @last_digit_pos + 1, 1000)
		SET @last_digit_pos = patindex('%[0-9][ /]%', @to_parse)
	END

	RETURN @to_return + @to_parse
END

go
/* test
select form_descr, dbo.fn_strength_sort(form_descr) as sort_expression
from c_Drug_Formulation
where form_descr like 'cyproterone acetate%' '%aceta%' or form_descr like 'bleph%' 
order by dbo.fn_strength_sort(form_descr)
*/


GRANT EXECUTE ON dbo.fn_strength_sort TO cprsystem