
DROP TABLE c_Formulation_Alpha
GO
CREATE TABLE c_Formulation_Alpha (form_rxcui varchar(30), alpha_descr varchar(1000))

DECLARE crs_form CURSOR FOR 
	SELECT g.generic_name, f.form_rxcui, f.form_descr
	from c_Drug_Generic g
	join c_Drug_Formulation f ON f.ingr_rxcui = g.generic_rxcui
	where g.generic_name like '% / %'
	and f.form_descr like '% / %'

DECLARE @form_no_df varchar(1000), @ingr_from_form varchar(100)	
	
DECLARE @form_rxcui varchar(30), @ingr varchar(1000), @form varchar(1000)
DECLARE @df varchar(100), @form_alpha varchar(1000), @ps varchar(1000)
OPEN crs_form
FETCH NEXT FROM crs_form INTO @ingr, @form_rxcui, @form
	
WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @df = dbo.fn_formulation_dosage_form_desc(@form_rxcui)
		SET @form_no_df = LEFT(@form,charindex(@df,@form) - 1)
		SET @ps = SUBSTRING(@form,charindex(@df,@form),1000)
		SET @form_alpha = ''
		DECLARE crs_piece CURSOR FOR 
			SELECT substr FROM dbo.fn_split(@form_no_df, ' / ')
			ORDER BY substr
		OPEN crs_piece
		FETCH NEXT FROM crs_piece INTO @ingr_from_form -- using @form_no_df
		
		WHILE @@FETCH_STATUS = 0
			BEGIN
			IF @form_alpha != '' SET @form_alpha = @form_alpha + ' / '
			SET @form_alpha = @form_alpha + @ingr_from_form
			FETCH NEXT FROM crs_piece INTO @ingr_from_form
			END
		CLOSE crs_piece
		DEALLOCATE crs_piece

		INSERT INTO c_Formulation_Alpha
		VALUES (@form_rxcui, @form_alpha + ' ' + @ps)
		FETCH NEXT FROM crs_form INTO @ingr,  @form_rxcui, @form
	END

CLOSE crs_form
DEALLOCATE crs_form

DELETE a
FROM c_Formulation_Alpha a
join c_Drug_Formulation f ON f.form_rxcui = a.form_rxcui
WHERE len(a.alpha_descr) != len(f.form_descr)
OR a.alpha_descr IS NULL
OR a.alpha_descr = f.form_descr

select a.alpha_descr, f.form_descr 
from c_Formulation_Alpha a
join c_Drug_Formulation f ON f.form_rxcui = a.form_rxcui

