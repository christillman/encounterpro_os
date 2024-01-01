
Print 'Drop Function [dbo].[fn_ingredient_strength]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_ingredient_strength]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION dbo.fn_ingredient_strength
go
Print 'Create Function [dbo].[fn_ingredient_strength]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_ingredient_strength (@ps_drug_description varchar(1000))
RETURNS @t TABLE(ingredient varchar(1000), strength varchar(1000))
AS BEGIN
	-- assume only one drug in input string, no dosage form so just "ingredient strength"
	declare @last_digit_pos integer, @first_digit_pos integer

	IF @ps_drug_description IS NULL
		RETURN

	-- space will normally be after the last digit, before the units
	SET @last_digit_pos = patindex('%[0-9][ /]%', @ps_drug_description)
	
	IF @last_digit_pos = 0
		BEGIN
		-- But might be at the end of the string
		SET @last_digit_pos = patindex('%[0-9]', @ps_drug_description)
		END

	IF @last_digit_pos = 0
		BEGIN
		-- No digits found
		INSERT INTO @t VALUES (
			LOWER(@ps_drug_description), 
			NULL
			)
		RETURN
		END

	-- find the space or slash prior to the digits
	SET @first_digit_pos = patindex('%[ /][0-9]%', @ps_drug_description) + 1
	IF @first_digit_pos > 1
		INSERT INTO @t VALUES (
			RTRIM(substring(@ps_drug_description, 1, @first_digit_pos - 1)),
			-- get the numbers and units, from the first digit
			RTRIM(substring(@ps_drug_description, @first_digit_pos, 1000))
		)
	ELSE
		INSERT INTO @t VALUES (
			LOWER(@ps_drug_description), 
			NULL
			)
	RETURN
END

go
/* test
select * from dbo.fn_ingredient_strength ('methylPREDNISolone sodium succinate 2 GM')
select * from dbo.fn_ingredient_strength ('meningococcal polysaccharide vaccine, groups A, C, Y and W-135 combined (MPSV4) Injectable Solution')
select * from dbo.fn_ingredient_strength ('pneumococcal 23-valent polysaccharide vaccine (PPSV23)')
select * from dbo.fn_ingredient_strength ('mycobacterium bovis BCG (Bacillus Calmette-Guerin), danish strain 1331, live attenuated Injectable Suspension')
select * from dbo.fn_ingredient_strength ('budesonide/formoterol fumarate 80/4.5 MCG/INHAL Metered Dose Inhaler, 120 Actuations')
select * from dbo.fn_ingredient_strength ('methylPREDNISolone sodium succinate 2 GM')
*/
