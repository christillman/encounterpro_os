IF  EXISTS (SELECT * FROM sys.objects 
where object_id = OBJECT_ID(N'fn_ingredient_list') AND type in (N'TF'))
DROP FUNCTION dbo.fn_ingredient_list
GO

-- Must be at least 90 (SQL 2005) to use CROSS APPLY with column name
-- ALTER DATABASE EncounterPro_OS SET COMPATIBILITY_LEVEL = 100
GO

CREATE FUNCTION dbo.fn_ingredient_list (@form_descr varchar(1000))
RETURNS @t TABLE(sort_order int NOT NULL IDENTITY(1,1), ingredient varchar(1000), strength varchar(1000), dosage_form varchar(1000))
AS 
BEGIN
	declare @last_digit_pos integer, @num_rev integer, @num_rev2 integer, @first_digit_pos integer
	declare @next_ingr_pos integer
	declare @ingredient varchar(100), @strg varchar(100)
	declare @dosage_form varchar(1000), @to_parse varchar(1000)

	SET @dosage_form = dbo.fn_std_dosage_form_descr (@form_descr)
	IF @dosage_form IS NULL
		SET @to_parse = @form_descr
	ELSE
		SET @to_parse = REPLACE(@form_descr, ' ' + @dosage_form,'')

	INSERT INTO @t (ingredient, strength, dosage_form)
	select ingredient, strength, @dosage_form
	from dbo.fn_split(@to_parse, ' / ')
	cross apply dbo.fn_ingredient_strength (substr) 

	RETURN
END
/*

select * from dbo.fn_ingredient_list('acetaminophen 325 MG / phenylephrine HCl 5 MG Oral Tablet')
select f.form_rxcui, f.form_descr
from c_Drug_Formulation f
where f.form_rxcui = '1001409'

select * from dbo.fn_ingredient_list('betamethasone sodium phosphate / betamethasone acetate 6 MG/ML Injectable Suspension')

select * from dbo.fn_ingredient_list('acetaminophen 650 MG / dextromethorphan HBr 30 MG / doxylamine succinate 12.5 MG in 30 mL Oral Solution')

select * from dbo.fn_ingredient_list('calcium 250 MG / vitamin D2 125 UNT Oral Tablet, as calcium carbonate')

*/
