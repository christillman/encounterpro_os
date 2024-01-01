
Print 'Drop Function [dbo].[fn_ingredients]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_ingredients]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION dbo.fn_ingredients
go
Print 'Create Function [dbo].[fn_ingredients]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_ingredients (@drug_description varchar(1000))
RETURNS varchar(1000)
AS BEGIN
	declare @last_digit_pos integer, @num_rev integer, @num_rev2 integer, @first_digit_pos integer
	declare @next_ingr_pos integer
	declare @ingredient varchar(100)
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
		SET @next_ingr_pos = 0
		SET @num_rev = charindex(' ', reverse(@to_parse), len(@to_parse) - @last_digit_pos + 1)
		SET @num_rev2 = charindex('/', reverse(@to_parse), len(@to_parse) - @last_digit_pos + 1)
		-- Could be slash or space; pick the closest one
		IF @num_rev2 > 0 AND (@num_rev2 < @num_rev OR @num_rev = 0)
			SET @num_rev = @num_rev2
		-- +1 to adjust for the subtraction, + 1 to go past the space/slash to the first digit
		SET @first_digit_pos = len(@to_parse) - @num_rev + 1 + 1
		IF @num_rev > 0 AND substring(@to_parse,@first_digit_pos,1) between '0' and '9'
			BEGIN
			IF @first_digit_pos > 1 
				BEGIN
				SET @ingredient = rtrim(left(@to_parse, @first_digit_pos - 1))

				-- get the position of the next space-slash separator, for the beginning of the next ingredient
				SET @next_ingr_pos = patindex('% / %', @to_parse)
				IF @next_ingr_pos > 0
					SET @ingredient = @ingredient + ' / '

				END
			END
		ELSE
			BEGIN
				-- No delimiters found before the digit. In this case it must be part of the name
				SET @ingredient = rtrim(left(@to_parse, @last_digit_pos))
				SET @next_ingr_pos = patindex('% / %', @to_parse)
				IF @next_ingr_pos > 0
					SET @ingredient = @ingredient + ' / '
			END
		SET @to_return = @to_return + @ingredient
		-- For the next one, move past the end of the previous last digit to the following space / slash
		IF @next_ingr_pos > 0
			SET @to_parse = substring(@to_parse, @next_ingr_pos + 3, 1000)
		ELSE
			SET @to_parse = ''
		SET @last_digit_pos = patindex('%[0-9][ /]%', @to_parse)
	END

	RETURN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
		@to_return + @to_parse, ' CREAM',''),
		' CAPSULES',''),
		' GEL',''),
		' INFUSION',''),
		' INTRAVENOUS',''),
		' TABLETS',''),
		' TABLET',''),
		' Variable Concentration Multi-Use Injectable Solution','')
END

go
/* test
select form_descr, dbo.fn_ingredients(form_descr) as sort_expression
from c_Drug_Formulation
where form_descr like 'cyproterone acetate%' or form_descr like 'bleph%' 
order by dbo.fn_ingredients(form_descr)
select dbo.fn_ingredients('methylPREDNISolone sodium succinate 2 GM Injection')
select dbo.fn_ingredients('ferrous fumarate 300 MG / folic acid 2.5 MG / vitamin B6 10 MG / vitamin B12 50 MCG / vitamin C 100 MG Oral Capsule')
*/


GRANT EXECUTE ON dbo.fn_ingredients TO cprsystem