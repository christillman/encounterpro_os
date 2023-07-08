
Print 'Drop Function [dbo].[fn_strength]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_strength]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION dbo.fn_strength
go
Print 'Create Function [dbo].[fn_strength]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_strength (@ps_drug_description varchar(1000))
RETURNS varchar(300)
AS BEGIN
	declare @last_digit_pos integer, @num_rev integer, @past_vit integer, @first_digit_pos integer
	declare @strength_str varchar(30), @units_str varchar(10)
	declare @to_return varchar(1000), @to_parse varchar(1000)

	IF @ps_drug_description IS NULL
		RETURN NULL

	-- look for the space after the last digit 
	SET @last_digit_pos = patindex('%[0-9] %', @ps_drug_description)
	IF @last_digit_pos = 0
		RETURN @ps_drug_description
		
	SET @to_parse = @ps_drug_description

	-- Special consideration to avoid vitamin/coenzyme designations being 
	-- interpreted as strengths
	IF @last_digit_pos - patindex('%vitamin [BDK][0-9]%', @to_parse) IN (9, 10)
			OR @last_digit_pos - patindex('%coenzyme Q10%', @to_parse) = 11
			OR @last_digit_pos - patindex('%omega-3%', @to_parse) = 6
		SET @last_digit_pos = @last_digit_pos 
			+ patindex('%[0-9] %', substring(@to_parse, @last_digit_pos + 1, 1000))

	SET @to_return = ''

	WHILE @last_digit_pos > 0
		BEGIN
		-- To pick up the units, include text up to the (second) space after the last digit
		SET @units_str = ' ' + 
				left( substring(@to_parse, @last_digit_pos + 2, 10) , 
				charindex(' ', substring(@to_parse, @last_digit_pos + 2, 10)) - 1)
		
		-- find the space prior to the digits, + 1 to get past the space/slash to the final digit
		SET @num_rev = charindex(' ', reverse(@to_parse), len(@to_parse) - @last_digit_pos + 2)
		IF @num_rev > 0
			BEGIN
			-- +1 to adjust for the subtraction, + 1 to go past the space/slash to the first digit
			SET @first_digit_pos = len(@to_parse) - @num_rev + 1 + 1
			IF @first_digit_pos > 1
				BEGIN
				-- get the numbers, from the first digit to the last digit inclusive
				SET @strength_str = substring(@to_parse, @first_digit_pos, @last_digit_pos - @first_digit_pos + 1)
								+ @units_str
				END
			END
		ELSE
			BEGIN
			-- No delimiters found before the digit. In this case 
			SET @first_digit_pos = @last_digit_pos + 1
			SET @strength_str = ''
			END
		-- @first_digit_pos is the first digit, so get to char before it to include the space but no digits
		IF Len(@to_return) > 0
			SET @to_return = @to_return + ' / ' 
		SET @to_return = @to_return + @strength_str 
		-- For the next one, move past the end of the previous last digit to the following space / slash
		SET @to_parse = substring(@to_parse, @last_digit_pos + 2, 1000)
		IF @to_parse NOT LIKE '% / %'
			SET @last_digit_pos = 0
		ELSE
			SET @last_digit_pos = patindex('%[0-9] %', @to_parse)

		-- Special consideration to avoid vitamin/coenzyme designations being 
		-- interpreted as strengths
		IF @last_digit_pos - patindex('%vitamin [BDK][0-9]%', @to_parse) IN (9, 10)
				OR @last_digit_pos - patindex('%coenzyme Q10%', @to_parse) = 11
			OR @last_digit_pos - patindex('%omega-3%', @to_parse) = 6
			SET @last_digit_pos = @last_digit_pos 
				+ patindex('%[0-9] %', substring(@to_parse, @last_digit_pos + 1, 1000))

	END

	RETURN @to_return
END

go
/* test
select dbo.fn_strength('Calcium Chloride 0.00232 MEQ/mL / icodextrin 75 mG/mL / Magnesium Chloride 0.000533 MEQ/mL / Sodium Chloride 0.0915 MEQ/mL / Sodium Lactate 0.04 MEQ/mL Injectable Solution [Extraneal]')
select dbo.fn_strength('ascorbic acid 100 mG / biotin 0.3 mG / calcium pantothenate 0.3 mG / ferrous bisglycinate 65 mG / folic acid 1 mG / formic acid 155 mG / iron-dextran complex 65 mG / niacin 25 mG / pyridoxine HCl 30 mG / riboflavin 5 mG / thiamine HCl 5 mG / vitamin B12 0.01 mG Oral Tablet [Irospan Tablet]')
select dbo.fn_strength('dexpanthenol 0.2 mG/mL / magnesium sulfate 0.0467 mG/mL / manganese sulfate 0.0467 mG/mL / niacinamide 0.467 mG/mL / pyridoxine 0.0467 mG/mL / riboflavin 0.04 mG/mL / thiamine 0.0333 mG/mL / vitamin B12 0.000133 mG/mL / zinc sulfate 0.333 mG/mL Oral Solution [Ellis Tonic]')
select dbo.fn_strength('thiamine 0.0333 mG/mL / vitamin B12 0.000133 mG/mL / zinc sulfate 0.333 mG/mL Oral Solution [Ellis Tonic]')
select dbo.fn_strength('folic acid 2.5 mG / vitamin B6 25 mG / vitamin B12 2 mG Oral Tablet')
select dbo.fn_strength('vitamin B12 500 mcG Sublingual Tablet')
select dbo.fn_strength('folic acid 2.2 mG / vitamin B12 1 mG / vitamin B6 25 mG Oral Tablet')
*/

GRANT EXECUTE ON dbo.fn_strength TO cprsystem