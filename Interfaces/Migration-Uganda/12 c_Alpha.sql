

DECLARE crs_form CURSOR FOR 
	SELECT [GENERIC NAME OF DRUG], [NDA REGISTRATION NUMBER]
	from [dbo].[UgandaApr2022]
	where [GENERIC NAME OF DRUG] like '% / %'

DECLARE @form_no_df varchar(1000), @ingr_from_form varchar(100)	
	
DECLARE @generic_rxcui varchar(30), @ingr varchar(1000), @form varchar(1000)
DECLARE @df varchar(100), @form_alpha varchar(1000), @ps varchar(1000)
OPEN crs_form
FETCH NEXT FROM crs_form INTO @ingr, @generic_rxcui
	
WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @form_alpha = ''
		DECLARE crs_piece CURSOR FOR 
			SELECT substr FROM dbo.fn_split(@ingr, ' / ')
			ORDER BY substr
		OPEN crs_piece
		FETCH NEXT FROM crs_piece INTO @ingr_from_form
		
		WHILE @@FETCH_STATUS = 0
			BEGIN
			IF @form_alpha != '' SET @form_alpha = @form_alpha + ' / '
			SET @form_alpha = @form_alpha + @ingr_from_form
			FETCH NEXT FROM crs_piece INTO @ingr_from_form
			END
		CLOSE crs_piece
		DEALLOCATE crs_piece

		IF @form_alpha != @ingr
			print @generic_rxcui + ', ' + @ingr + ', ' + @form_alpha
		FETCH NEXT FROM crs_form INTO @ingr, @generic_rxcui
	END

CLOSE crs_form
DEALLOCATE crs_form
