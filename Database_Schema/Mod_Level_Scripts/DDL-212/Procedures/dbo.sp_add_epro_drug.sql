
Print 'Drop Procedure [dbo].[sp_add_epro_drug]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'sp_add_epro_drug') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_add_epro_drug]
GO

Print 'Create Procedure [dbo].[sp_add_epro_drug]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_add_epro_drug (
	@is_rxnorm bit,
	@generic_only bit,
	@country_code varchar(100), -- ('us' for rxnorm drug )
	@country_drug_id varchar(21), -- (rxcui for rxnorm brand ingredient)
	@brand_name_formulation varchar(300),
	@generic_formulation varchar(300),
	@corr_scd_rxcui varchar(20), -- (rxcui for rxnorm generic formulation)
	@active_ingredients varchar(200),
	@drug_type varchar(20) = 'Single Drug',
	@notes varchar(200) = NULL
	)
AS

BEGIN

/*
DECLARE	@is_rxnorm bit = 0
DECLARE	@generic_only bit = 0
DECLARE	@country_code varchar(100) = 'KE' ( 'us' for rxnorm drug )
DECLARE	@country_drug_id varchar(21) = '517' (rxcui for rxnorm brand ingredient)
DECLARE	@brand_name_formulation varchar(300) = 'Aldara 5 % Topical Cream'
DECLARE	@generic_formulation varchar(300) = 'imiquimod 5 % Topical Cream'
DECLARE	@corr_scd_rxcui varchar(20) = 'PSN-310982'
DECLARE	@active_ingredients varchar(200) = 'imiquimod'
*/
DECLARE @new_id int

-- set this before potentially reassigning @country_drug_id
IF @brand_name_formulation LIKE 'No %'
	OR @country_drug_id = '00nobrandfound'
	SET @generic_only = 1
IF @corr_scd_rxcui LIKE 'No %'
	SET @corr_scd_rxcui = NULL
	
IF @country_drug_id IS NULL 
	OR @country_drug_id IN ('00nobrandfound','NO RXCUI', 'No Retention No', 'No Retention Number', 'Not in Retention List')
	BEGIN 
	-- Make up a @country_drug_id
	SELECT @country_drug_id = dbo.fn_next_country_id(@country_code)

	END

DECLARE @brand_form_rxcui varchar(20) = upper(@country_code) + 'B' + @country_drug_id
DECLARE @generic_form_rxcui varchar(20) = upper(@country_code) + 'G' + @country_drug_id
DECLARE @brand_ingr_rxcui varchar(20) = upper(@country_code) + 'BI' + @country_drug_id
DECLARE @generic_ingr_rxcui varchar(20) = upper(@country_code) + 'GI' + @country_drug_id
DECLARE @single_ingredient bit = CASE 
	WHEN @active_ingredients LIKE '% / %'
		OR @generic_formulation LIKE '% / %' THEN 0 
		ELSE 1 END
DECLARE @generic_rxcui varchar(20)
DECLARE @brand_name_rxcui varchar(20)

DECLARE @brand_name_edited varchar(300)
-- DECLARE @generic_name_edited varchar(300)

CREATE TABLE #Drug_Brand (
	brand_name_rxcui varchar(20),
	brand_name varchar(200),
	generic_rxcui varchar(20),
	is_single_ingredient bit,
	valid_in varchar(100),
	drug_id varchar(24)
	)
	
CREATE TABLE #Drug_Generic (
	generic_rxcui varchar(20),
	generic_name varchar(200),
	is_single_ingredient bit,
	valid_in varchar(100),
	drug_id varchar(24)
	)
	
CREATE TABLE #new_form (
	form_rxcui varchar(20),
	form_descr varchar(1000), 
	form_tty varchar(20), 
	ingr_tty varchar(20),
	ingr_rxcui varchar(20),
	valid_in varchar(100),
	generic_form_rxcui varchar(20)
	)
	
CREATE TABLE #new_generic_form (
	form_rxcui varchar(20),
	form_descr varchar(1000), 
	form_tty varchar(20), 
	ingr_tty varchar(20),
	ingr_rxcui varchar(20),
	valid_in varchar(100)
	)

IF @is_rxnorm = 0 
	BEGIN
	-- In case @country_drug_id had to be made up above, use this 
	-- which should be unique to locate the records to delete
	DELETE FROM Kenya_Drugs
	WHERE [SBD_Version] = @brand_name_formulation
	AND [SCD_PSN_Version] = @generic_formulation

	INSERT INTO Kenya_Drugs (
		[Retention_No],
		[SBD_Version],
		[SCD_PSN_Version],
		[Corresponding_RXCUI],
		[Ingredient],
		[generic_only],
		[Notes]
		) VALUES (
		@country_drug_id, 
		@brand_name_formulation, 
		@generic_formulation, 
		@corr_scd_rxcui, 
		@active_ingredients,
		@generic_only,
		@notes
		)

	-- exact wording match for generic
	SELECT @generic_rxcui = generic_rxcui
	FROM c_Drug_Generic g 
	WHERE g.generic_name = @active_ingredients

	-- Generic formulation?
	IF @corr_scd_rxcui IS NULL -- No corresponding rxcui
		OR ( -- there is not already a valid generic pointed to by SCD_Version
			@corr_scd_rxcui IS NOT NULL 
			AND NOT (	left(@corr_scd_rxcui,4) IN ('SCD-','PSN-')
						AND EXISTS (SELECT 1 FROM c_Drug_Formulation 
							WHERE form_rxcui = substring(@corr_scd_rxcui,5,20)
							)
				)
			AND NOT EXISTS (SELECT 1 FROM c_Drug_Formulation 
							WHERE form_descr = @generic_formulation)
			)
			BEGIN
			print 'INSERT INTO #new_generic_form'
			INSERT INTO #new_generic_form (
				form_rxcui,
				form_descr, 
				form_tty, 
				ingr_tty,
				ingr_rxcui,
				valid_in
				)
			SELECT @generic_form_rxcui,
				@generic_formulation,
				'SCD_' + upper(@country_code), 
				CASE WHEN @single_ingredient = 0 THEN 'MIN' ELSE 'IN' END 
					+ CASE WHEN @generic_rxcui IS NULL THEN '_' + upper(@country_code) ELSE '' END,
				CASE WHEN @generic_rxcui IS NULL THEN @generic_ingr_rxcui
					ELSE @generic_rxcui END,
				lower(@country_code) + ';'
			FROM c_1_record
			WHERE @generic_formulation NOT LIKE '%{%'
			AND @generic_formulation NOT LIKE '%GPCK%'
			-- Exclude where they would duplicate RXNORM ones
			AND NOT EXISTS (SELECT 1 FROM c_Drug_Formulation 
							WHERE form_descr = @generic_formulation)
			AND NOT EXISTS (SELECT 1 FROM c_Drug_Formulation 
							WHERE form_rxcui = @generic_form_rxcui)
			END -- 'INSERT INTO #new_generic_form'
		ELSE
			BEGIN
			-- generic formulation already exists
			print @generic_formulation + ' already exists'
			SELECT TOP 1 @generic_form_rxcui = form_rxcui 
				FROM c_Drug_Formulation 
				WHERE form_rxcui = substring(ISNULL(@corr_scd_rxcui,'XXXXXXXX'),5,20)
				OR form_descr = @generic_formulation
			END
	
	-- Generic drug?

	/* Use passed in @active_ingredients instead
	-- Derive generic ingredient 
	SET @generic_name_edited = @generic_formulation
	IF PATINDEX('% in [0-9]%', @generic_formulation) > 0
		-- " in " at the end of the name
		BEGIN
		IF PATINDEX('% [0-9]%', @generic_formulation) - PATINDEX('% in [0-9]%', @generic_formulation) = 3
			SET @generic_name_edited = left(@generic_formulation,PATINDEX('% in [0-9]%', @generic_formulation) - 1)
		ELSE
			-- " in " at a different place
			IF @single_ingredient = 1
				SET @generic_name_edited = left(@generic_formulation,PATINDEX('% [0-9]%', @generic_formulation) - 1)
		END
	ELSE IF @single_ingredient = 1 AND PATINDEX('% [0-9]%', @generic_formulation) > 0
		SET @generic_name_edited = left(@generic_formulation,PATINDEX('% [0-9]%', @generic_formulation) - 1)
	ELSE IF @single_ingredient = 1 AND charindex(' ', @generic_formulation) > 0
		SET @generic_name_edited = left(@generic_formulation,charindex(' ', @generic_formulation) - 1)			
	*/
	IF @generic_rxcui IS NOT NULL
		-- exact wording match for generic
		BEGIN
		print @active_ingredients + ' already exists'
		UPDATE #new_generic_form
		SET ingr_rxcui = @generic_rxcui
		UPDATE c_Drug_Generic
		SET valid_in = valid_in + lower(@country_code) + ';'
		WHERE generic_rxcui = @generic_rxcui
		AND valid_in NOT LIKE '%' + @country_code + ';%'
		END
	ELSE
		BEGIN
		print 'Inserting ' + @active_ingredients + ' INTO #Drug_Generic'
		INSERT INTO #Drug_Generic (
			generic_rxcui,
			generic_name,
			is_single_ingredient,
			valid_in,
			drug_id
		)
		SELECT @generic_ingr_rxcui,
			@active_ingredients,
			@single_ingredient,
			lower(@country_code) + ';',
			@generic_ingr_rxcui
		FROM c_1_record
		END

	-- Brand formulation?
	IF @generic_only = 0 
		BEGIN
		print 'INSERT INTO #new_form'
		INSERT INTO #new_form (
			form_rxcui,
			form_descr, 
			form_tty, 
			ingr_tty,
			ingr_rxcui,
			valid_in,
			generic_form_rxcui
			)
		SELECT @brand_form_rxcui,
			@brand_name_formulation, 
			'SBD_' + upper(@country_code), 
			'BN' + '_' + upper(@country_code),
			@brand_ingr_rxcui,
			lower(@country_code) + ';',
			@generic_form_rxcui -- select *  
		FROM c_1_record
		-- Exclude packs
		WHERE @brand_name_formulation NOT LIKE '%{%'
		AND @brand_name_formulation NOT LIKE '%BPCK%'
		-- Exclude if brand name identical to generic
		AND @brand_name_formulation != @generic_formulation 
		-- Exclude where they would duplicate RXNORM ones
		AND NOT EXISTS (SELECT 1 FROM c_Drug_Formulation 
						WHERE form_descr = @brand_name_formulation)
		AND NOT EXISTS (SELECT 1 FROM c_Drug_Formulation 
						WHERE form_rxcui = @brand_form_rxcui)

		-- Derive brand ingredient record
		SET @brand_name_edited = @brand_name_formulation
		IF PATINDEX('% in [0-9]%', @brand_name_formulation) > 0
			-- " in " at the end of the name
			BEGIN
			IF PATINDEX('% [0-9]%', @brand_name_formulation) - PATINDEX('% in [0-9]%', @brand_name_formulation) = 3
				SET @brand_name_edited = left(@brand_name_formulation,PATINDEX('% in [0-9]%', @brand_name_formulation) - 1)
			ELSE
				-- " in " at a different place
				SET @brand_name_edited = left(@brand_name_formulation,PATINDEX('% [0-9]%', @brand_name_formulation) - 1)
			END
		ELSE IF PATINDEX('% [0-9]%', @brand_name_formulation) > 0
			SET @brand_name_edited = left(@brand_name_formulation,PATINDEX('% [0-9]%', @brand_name_formulation) - 1)
		ELSE IF charindex(' ', @brand_name_formulation) > 0
			SET @brand_name_edited = left(@brand_name_formulation,charindex(' ', @brand_name_formulation) - 1)

		IF EXISTS (SELECT 1 FROM c_Drug_Brand b
						WHERE brand_name = @brand_name_edited)
			BEGIN
			print @brand_name_edited + ' Brand already exists'
			SELECT @brand_name_rxcui = b.brand_name_rxcui
				FROM c_Drug_Brand b 
				WHERE b.brand_name = @brand_name_edited
			UPDATE #new_form
			SET ingr_rxcui = @brand_name_rxcui
			UPDATE c_Drug_Brand
			SET valid_in = valid_in + lower(@country_code) + ';'
			WHERE brand_name_rxcui = @brand_name_rxcui
			AND valid_in NOT LIKE '%' + @country_code + ';%'
			END
		ELSE
			BEGIN
			print 'Inserting ' + @brand_name_edited + ' INTO #Drug_Brand'
			INSERT INTO #Drug_Brand (
				brand_name_rxcui,
				brand_name,
				generic_rxcui,
				is_single_ingredient,
				valid_in,
				drug_id
			)
			SELECT @brand_ingr_rxcui,
				@brand_name_edited,
				CASE WHEN @generic_rxcui IS NULL THEN @generic_ingr_rxcui
				ELSE @generic_rxcui END,
				@single_ingredient,
				lower(@country_code) + ';',
				@brand_ingr_rxcui
			FROM c_1_record
			END

		print 'UPDATE #Drug_Brand name'
		UPDATE #Drug_Brand 
		SET brand_name = REPLACE(REPLACE(REPLACE(
			brand_name, 
			'-25 UNIT/ML /',''),
			' Effervescent Granules',''),
			' Oral Suspension','')
		WHERE brand_name LIKE '%-25 UNIT/ML /%'
			OR brand_name LIKE '% Effervescent Granules%'
			OR brand_name LIKE '% Oral Suspension%'
		END -- brand formulation

	IF (SELECT count(*) FROM #new_generic_form) > 0
	BEGIN
	print 'INSERT INTO c_Drug_Formulation from #new_generic_form'
	INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty, ingr_tty, ingr_rxcui, valid_in)
	SELECT form_rxcui, form_descr, form_tty, ingr_tty, ingr_rxcui, valid_in
	FROM #new_generic_form
	END

	IF (SELECT count(*) FROM #new_form) > 0
	BEGIN
	print 'INSERT INTO c_Drug_Formulation from #new_form'
	INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty, ingr_tty, ingr_rxcui, valid_in, generic_form_rxcui)
	SELECT form_rxcui, form_descr, form_tty, ingr_tty, ingr_rxcui, valid_in, @generic_form_rxcui
	FROM #new_form
	END

	IF (SELECT count(*) FROM #Drug_Brand) > 0
	BEGIN
	print 'INSERT INTO c_Drug_Brand'
	INSERT INTO c_Drug_Brand (drug_id, brand_name_rxcui, brand_name, generic_rxcui, is_single_ingredient, valid_in) 
	SELECT drug_id,
		brand_name_rxcui,
		brand_name,
		generic_rxcui,
		is_single_ingredient,
		valid_in
	FROM #Drug_Brand b2
	WHERE NOT EXISTS (SELECT 1 FROM c_Drug_Brand b
						WHERE brand_name = b2.brand_name)
	END

	IF (SELECT count(*) FROM #Drug_Generic) > 0
	BEGIN
	print 'INSERT INTO c_Drug_Generic'
	INSERT INTO c_Drug_Generic (drug_id, generic_rxcui, generic_name, is_single_ingredient, valid_in) 
	SELECT drug_id,
		generic_rxcui,
		generic_name,
		is_single_ingredient,
		valid_in
	FROM #Drug_Generic g2
	WHERE NOT EXISTS (SELECT 1 FROM c_Drug_Generic g
						WHERE g.generic_name = g2.generic_name)

	END

	-- Insert to drug_definition now, to specify @drug_type;
	-- sp_add_missing_drug_defn_pkg_adm_method will not duplicate

	-- Missing KE brand definitions
	print 'INSERT INTO c_Drug_Definition brand'
	INSERT INTO c_Drug_Definition (drug_id, drug_type, common_name, generic_name)
	SELECT b.drug_id, @drug_type,
		CASE WHEN LEN(b.brand_name) <= 80 THEN b.brand_name ELSE left(b.brand_name,77) + '...' END, 
		CASE WHEN LEN(g.generic_name) <= 500 THEN g.generic_name ELSE left(g.generic_name,497) + '...' END -- select '''' + g.generic_name + ''','
	FROM #Drug_Brand b
	JOIN #Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
	WHERE NOT EXISTS (SELECT 1 FROM c_Drug_Definition d where d.drug_id = b.drug_id)
	AND EXISTS (SELECT 1 FROM c_Drug_Formulation f where b.brand_name_rxcui = f.ingr_rxcui)

	-- Missing KE generic definitions
	print 'INSERT INTO c_Drug_Definition generic'
	INSERT INTO c_Drug_Definition (drug_id, drug_type, common_name, generic_name)
	SELECT g.drug_id, @drug_type, 
		CASE WHEN LEN(g.generic_name) <= 80 THEN g.generic_name ELSE left(g.generic_name,77) + '...' END, 
		CASE WHEN LEN(g.generic_name) <= 500 THEN g.generic_name ELSE left(g.generic_name,497) + '...' END -- select '''' + g.generic_name + ''','
	FROM #Drug_Generic g
	WHERE NOT EXISTS (SELECT 1 FROM c_Drug_Definition d where d.drug_id = g.drug_id)
	AND EXISTS (SELECT 1 FROM c_Drug_Formulation f where g.generic_rxcui = f.ingr_rxcui)

	exec sp_add_missing_drug_defn_pkg_adm_method

	INSERT INTO [c_Drug_Brand_Related] (
		[country_code],
		[source_id],
		[source_brand_form_descr],
		[brand_name_rxcui],
		[is_single_ingredient])
	SELECT lower(@country_code),
		@country_drug_id,
		@brand_name_formulation,
		CASE WHEN @brand_name_rxcui IS NULL THEN @brand_ingr_rxcui
				ELSE @brand_name_rxcui END,
		@single_ingredient
	WHERE NOT EXISTS (SELECT 1 FROM [c_Drug_Brand_Related] r
		WHERE r.[source_id] = @country_drug_id)

	INSERT INTO [c_Drug_Generic_Related] (
		[country_code],
		[source_id],
		source_generic_form_descr,
		[active_ingredients],
		[generic_rxcui],
		[is_single_ingredient])
	SELECT lower(@country_code),
		@country_drug_id,
		@generic_formulation,
		@active_ingredients,
		CASE WHEN @generic_rxcui IS NULL THEN @generic_ingr_rxcui
				ELSE @generic_rxcui END,
		@single_ingredient		
	WHERE NOT EXISTS (SELECT 1 FROM [c_Drug_Generic_Related] r
		WHERE r.[source_id] = @country_drug_id)

	END -- @is_rxnorm = 0

	ELSE
	print 'use sp_add_rxnorm_drug instead'
	
END