
Print 'Drop Procedure [dbo].[sp_add_epro_drug]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'sp_add_epro_drug') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_add_epro_drug]
GO

Print 'Create Procedure [dbo].[sp_add_epro_drug]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_add_epro_drug (
	@generic_only bit,
	@country_code varchar(100), 
	@country_source_id varchar(21), 
	@brand_name_formulation varchar(300),
	@corr_sbd_rxcui varchar(20),
	@generic_formulation varchar(300),
	@corr_scd_rxcui varchar(20),
	@active_ingredients varchar(200),
	@generic_ingr_rxcui varchar(20),
	@brand_name varchar(200),
	@brand_rxcui varchar(20),
	@drug_type varchar(20) = 'Single Drug',
	@notes varchar(200) = NULL
	)
AS

BEGIN


DECLARE @new_id int
/*
DECLARE	@generic_only bit = 0
DECLARE	@country_code varchar(100) = 'KE' 
DECLARE	@country_source_id varchar(21) = '517' 
DECLARE	@brand_name_formulation varchar(300) = 'Aldara 5 % Topical Cream'
DECLARE	@corr_sbd_rxcui varchar(20),
DECLARE	@generic_formulation varchar(300) = 'imiquimod 5 % Topical Cream'
DECLARE	@corr_scd_rxcui varchar(20) = 'PSN-310982'
DECLARE	@active_ingredients varchar(200) = 'imiquimod'
DECLARE	@generic_ingr_rxcui varchar(20)
DECLARE	@brand_name varchar(200)
DECLARE	@drug_type varchar(20) = 'Single Drug'
*/
-- local variables
DECLARE @brand_form_rxcui varchar(20)
DECLARE @generic_form_rxcui varchar(20)
DECLARE @brand_ingr_rxcui varchar(20)
DECLARE @single_ingredient bit = CASE 
	WHEN @active_ingredients LIKE '% / %'
		OR @generic_formulation LIKE '% / %' THEN 0 
		ELSE 1 END
DECLARE @generic_rxcui varchar(20)
DECLARE @brand_name_rxcui varchar(20)
DECLARE @sbd_rxcui varchar(20)
DECLARE @scd_rxcui varchar(20)
DECLARE @generic_ingr_exists bit

DECLARE @brand_name_edited varchar(300)
-- DECLARE @generic_name_edited varchar(300)

-- set this before potentially reassigning @country_source_id
IF @brand_name_formulation LIKE 'No %'
	OR @country_source_id = '00nobrandfound'
	SET @generic_only = 1
	
IF @corr_sbd_rxcui LIKE 'No %' OR @corr_sbd_rxcui = '' OR @corr_sbd_rxcui IS NULL
	SET @sbd_rxcui = NULL

IF @corr_sbd_rxcui LIKE 'SBD_PSN-%'
	SET @sbd_rxcui = substring(@corr_sbd_rxcui, 9, 20)

IF @corr_sbd_rxcui LIKE 'PSN-%' OR @corr_sbd_rxcui LIKE 'SBD-%'
	SET @sbd_rxcui = substring(@corr_sbd_rxcui, 5, 20)

IF @corr_scd_rxcui LIKE 'No %' OR @corr_scd_rxcui = '' OR @corr_scd_rxcui IS NULL
	SET @scd_rxcui = NULL
	
IF @corr_scd_rxcui LIKE 'SCD_PSN-%'
	SET @scd_rxcui = 'PSN-' + substring(@corr_scd_rxcui, 9, 20)

IF @corr_scd_rxcui NOT LIKE 'PSN-%' AND @corr_scd_rxcui NOT LIKE 'SCD-%'
	SET @scd_rxcui = 'SCD-' + @corr_scd_rxcui
	
IF @country_source_id IS NULL 
	OR @country_source_id IN ('00nobrandfound','NO RXCUI', 'No Retention No', 
		'No Retention Number', 'Not in Retention List', 'None')
	BEGIN 
	-- Check to see it hasn't already been executed
	SELECT @country_source_id = source_id 
	FROM c_Drug_Source_Formulation
	WHERE source_brand_form_descr = @brand_name_formulation
		AND country_code = @country_code

	IF @@ROWCOUNT > 0
		BEGIN
		print 'source_id already exists: ' + @country_source_id
		print 'Aborting'
		RETURN
		END
	-- Make up a @country_source_id
	SELECT @country_source_id = dbo.fn_next_country_id(@country_code)

	END

SET @brand_form_rxcui = upper(@country_code) + 'B' + @country_source_id
SET @generic_form_rxcui = upper(@country_code) + 'G' + @country_source_id
SET @brand_ingr_rxcui = upper(@country_code) + 'BI' + @country_source_id

-- If a generic rxcui had been supplied, or can be found using ingredients, 
-- use it, otherwise make a new one up
IF @generic_ingr_rxcui IS NULL OR @generic_ingr_rxcui = ''
	BEGIN
	-- exact wording match for generic?
	SELECT @generic_rxcui = generic_rxcui
	FROM c_Drug_Generic g 
	WHERE g.generic_name = @active_ingredients
	SET @generic_ingr_exists = CASE WHEN @generic_rxcui IS NULL THEN 0 ELSE 1 END

	IF @generic_ingr_exists = 0
		SET @generic_rxcui = upper(@country_code) + 'GI' + @country_source_id
	END
ELSE
	BEGIN
	SELECT @generic_rxcui = generic_rxcui
	FROM c_Drug_Generic g 
	WHERE g.generic_rxcui = @generic_ingr_rxcui
	SET @generic_ingr_exists = CASE WHEN @generic_rxcui IS NULL THEN 0 ELSE 1 END

	IF @generic_ingr_exists = 0
		SET @generic_rxcui = upper(@country_code) + 'GI' + @country_source_id
	ELSE
		SET @generic_rxcui = @generic_ingr_rxcui
	END

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

/*
	-- In case @country_source_id had to be made up above, use this 
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
		@country_source_id, 
		@brand_name_formulation, 
		@generic_formulation, 
		@corr_scd_rxcui, 
		@active_ingredients,
		@generic_only,
		@notes
		)
*/

	-- Generic formulation?
	IF (	@scd_rxcui IS NULL -- No corresponding rxcui
			OR ( -- there is not already a valid generic pointed to by SCD_Version
				@scd_rxcui IS NOT NULL 
				AND NOT (	left(@scd_rxcui,4) IN ('SCD-','PSN-')
							AND EXISTS (SELECT 1 FROM c_Drug_Formulation 
								WHERE form_rxcui = substring(@scd_rxcui,5,20)
								)
				)
			)
		)
		AND NOT EXISTS (SELECT 1 FROM c_Drug_Formulation 
						WHERE form_descr = @generic_formulation)
		AND NOT EXISTS (SELECT 1 FROM c_Drug_Formulation 
						WHERE form_rxcui = @generic_form_rxcui)
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
					+ CASE WHEN @generic_rxcui LIKE upper(@country_code) + '%'
						 THEN '_' + upper(@country_code) ELSE '' END,
				@generic_rxcui,
				lower(@country_code) + ';'
			FROM c_1_record
			WHERE @generic_formulation NOT LIKE '%{%'
			AND @generic_formulation NOT LIKE '%GPCK%'
			END -- 'INSERT INTO #new_generic_form'
		ELSE
			BEGIN
			-- generic formulation already exists
			print @generic_formulation + ' already exists'
			SELECT TOP 1 @generic_form_rxcui = form_rxcui 
				FROM c_Drug_Formulation 
				WHERE form_rxcui = substring(ISNULL(@scd_rxcui,'XXXXXXXX'),5,20)
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
	IF @generic_ingr_exists = 1
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
		SELECT @generic_rxcui,
			@active_ingredients,
			@single_ingredient,
			lower(@country_code) + ';',
			@generic_rxcui
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
		AND NOT EXISTS (SELECT 1 FROM c_Drug_Formulation 
						WHERE form_rxcui = IsNull(@sbd_rxcui,'XXXXXX'))

		-- Derive brand ingredient record
		IF @brand_name IS NOT NULL
			SET @brand_name_edited = @brand_name
		ELSE
			BEGIN
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
			END

		IF EXISTS (SELECT 1 FROM c_Drug_Brand b
						WHERE brand_name = @brand_name_edited
						OR brand_name_rxcui = @brand_rxcui)
			BEGIN
			print @brand_name_edited + ' Brand already exists'
			SELECT @brand_name_rxcui = b.brand_name_rxcui
				FROM c_Drug_Brand b 
				WHERE b.brand_name = @brand_name_edited
					OR brand_name_rxcui = @brand_rxcui
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
				@generic_rxcui,
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
	SELECT form_rxcui, form_descr, form_tty, ingr_tty, ingr_rxcui, valid_in, generic_form_rxcui
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

	print 'INSERT INTO c_Drug_Source_Formulation'
	INSERT INTO c_Drug_Source_Formulation (
		[country_code],
		[source_id],
		[source_brand_form_descr],
		[brand_name_rxcui],
		source_generic_form_descr,
		[active_ingredients],
		[generic_rxcui],
		[is_single_ingredient],
		generic_form_rxcui,
		brand_form_rxcui)
	SELECT lower(@country_code),
		@country_source_id,
		@brand_name_formulation,
		COALESCE(@brand_name_rxcui, @brand_ingr_rxcui),
		@generic_formulation,
		@active_ingredients,
		@generic_rxcui,
		@single_ingredient,
		@generic_form_rxcui,
		@brand_form_rxcui
	WHERE NOT EXISTS (SELECT 1 FROM c_Drug_Source_Formulation r
		WHERE r.[source_id] = @country_source_id
		AND r.country_code = @country_code)

	exec sp_add_missing_drug_defn_pkg_adm_method
END