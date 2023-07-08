
-- PRINT 'Drop Procedure [dbo].[sp_add_epro_drug]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'sp_add_epro_drug') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_add_epro_drug]
GO

-- PRINT 'Create Procedure [dbo].[sp_add_epro_drug]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
GO
CREATE PROCEDURE sp_add_epro_drug (
	@in_generic_only bit,
	@country_code varchar(100), 
	@country_source_id varchar(21), 
	@in_brand_name_formulation varchar(300),
	@in_corr_sbd_rxcui varchar(30),
	@in_generic_formulation varchar(300),
	@in_corr_scd_rxcui varchar(30),
	@in_active_ingredients varchar(200),
	@in_generic_ingr_rxcui varchar(30),
	@in_brand_name varchar(200),
	@in_brand_rxcui varchar(30),
	@drug_type varchar(20) = 'Single Drug',
	@notes varchar(200) = NULL
	)
AS

BEGIN

-- Show @debug messages only for developer
DECLARE @debug bit = CASE WHEN @@servername LIKE 'DESKTOP-GU15HUD%' THEN 1 ELSE 0 END

IF @debug = 1 
	BEGIN
	PRINT '@in_generic_only ' +	CASE WHEN @in_generic_only = 1 Then 'Yes' ELSE 'No' END
	PRINT '@country_code ' +	@country_code
	PRINT '@country_source_id ' +	@country_source_id
	PRINT '@in_brand_name_formulation ' +IsNull(@in_brand_name_formulation,'NULL')
	PRINT '@in_corr_sbd_rxcui ' +	IsNull(@in_corr_sbd_rxcui,'NULL')
	PRINT '@in_generic_formulation ' +	IsNull(@in_generic_formulation,'NULL')
	PRINT '@in_corr_scd_rxcui ' +	IsNull(@in_corr_scd_rxcui,'NULL')
	PRINT '@in_active_ingredients ' +	IsNull(@in_active_ingredients,'NULL')
	PRINT '@in_generic_ingr_rxcui ' +	IsNull(@in_generic_ingr_rxcui,'NULL')
	PRINT '@in_brand_name ' +	IsNull(@in_brand_name,'NULL')
	PRINT '@in_brand_rxcui ' +	IsNull(@in_brand_rxcui,'NULL')
	END
ELSE	
	SET NOCOUNT ON

DECLARE @new_id int
/*
DECLARE	@in_generic_only bit = 0
DECLARE	@country_code varchar(100) = 'UG' 
DECLARE	@country_source_id varchar(21) = '0669' 
DECLARE	@in_brand_name_formulation varchar(300) = 'Axcel Fungicort 2 % / 1 % Topical Cream'
DECLARE	@in_corr_sbd_rxcui varchar(30)
DECLARE	@in_generic_formulation varchar(300) = 'miconazole nitrate 2 % / hydrocortisone acetate 1 % Topical Cream'
DECLARE	@in_corr_scd_rxcui varchar(30) = 'KEG7858'
DECLARE	@in_active_ingredients varchar(200) = NULL
DECLARE	@in_generic_ingr_rxcui varchar(30)
DECLARE	@in_brand_name varchar(200)
DECLARE	@drug_type varchar(20) = 'Single Drug'
*/
-- local variables
DECLARE @default_brand_form_rxcui varchar(30)
DECLARE @default_generic_form_rxcui varchar(30)
DECLARE @default_brand_ingr_rxcui varchar(30)
DECLARE @default_generic_ingr_rxcui varchar(30)
DECLARE @single_ingredient bit = CASE 
	WHEN @in_active_ingredients LIKE '% / %'
		OR @in_generic_formulation LIKE '% / %' THEN 0 
		ELSE 1 END
DECLARE @generic_rxcui varchar(30)
DECLARE @brand_name_rxcui varchar(30)
DECLARE @sbd_rxcui varchar(30)
DECLARE @scd_rxcui varchar(30)
DECLARE @generic_ingr_exists bit
DECLARE @generic_only bit = 0

DECLARE @brand_name_edited varchar(300)
DECLARE @generic_name varchar(1000)


CREATE TABLE #Drug_Brand (
	brand_name_rxcui varchar(30),
	brand_name varchar(200),
	generic_rxcui varchar(30),
	is_single_ingredient bit,
	valid_in varchar(100),
	drug_id varchar(24)
	)
	
CREATE TABLE #Drug_Generic (
	generic_rxcui varchar(30),
	generic_name varchar(200),
	is_single_ingredient bit,
	valid_in varchar(100),
	drug_id varchar(24)
	)
	
CREATE TABLE #new_form (
	form_rxcui varchar(30),
	form_descr varchar(1000), 
	form_tty varchar(20), 
	ingr_tty varchar(20),
	ingr_rxcui varchar(30),
	valid_in varchar(100),
	generic_form_rxcui varchar(20)
	)
	
CREATE TABLE #new_generic_form (
	form_rxcui varchar(30),
	form_descr varchar(1000), 
	form_tty varchar(20), 
	ingr_tty varchar(20),
	ingr_rxcui varchar(30),
	valid_in varchar(100)
	)

CREATE TABLE #new_pack (
	rxcui varchar(30),
	descr varchar(1000), 
	tty varchar(20), 
	valid_in varchar(100)
	)
	
CREATE TABLE #new_generic_pack (
	rxcui varchar(30),
	descr varchar(1000), 
	tty varchar(20), 
	valid_in varchar(100)
	)

-- set this before potentially reassigning @country_source_id
IF @in_brand_name_formulation LIKE 'No %'
	OR @country_source_id = '00nobrandfound'
	OR @in_generic_only = 1
	SET @generic_only = 1
	
SET @sbd_rxcui = CASE
	WHEN @in_corr_sbd_rxcui IS NULL THEN NULL
	WHEN @in_corr_sbd_rxcui LIKE 'No %' THEN NULL
	WHEN @in_corr_sbd_rxcui = '' THEN NULL
	WHEN @in_corr_sbd_rxcui LIKE 'SBD_PSN-%' THEN substring(@in_corr_sbd_rxcui, 9, 20)
	WHEN @in_corr_sbd_rxcui LIKE 'PSN-%' THEN substring(@in_corr_sbd_rxcui, 5, 20)
	WHEN @in_corr_sbd_rxcui LIKE 'SBD-%' THEN substring(@in_corr_sbd_rxcui, 5, 20)
	ELSE @in_corr_sbd_rxcui END

SET @scd_rxcui = CASE
	WHEN @in_corr_scd_rxcui IS NULL THEN NULL
	WHEN @in_corr_scd_rxcui LIKE 'No %' THEN NULL
	WHEN @in_corr_scd_rxcui = '' THEN NULL
	WHEN @in_corr_scd_rxcui LIKE 'SCD_PSN-%' THEN substring(@in_corr_sbd_rxcui, 9, 20)
	WHEN @in_corr_scd_rxcui LIKE 'PSN-%' THEN substring(@in_corr_sbd_rxcui, 5, 20)
	WHEN @in_corr_scd_rxcui LIKE 'SCD-%' THEN substring(@in_corr_sbd_rxcui, 5, 20)
	ELSE @in_corr_scd_rxcui END

IF @country_source_id IS NULL 
	OR @country_source_id IN ('00nobrandfound','NO RXCUI', 'No Retention No', 
		'No Retention Number', 'Not in Retention List', 'None')
	BEGIN 
	-- Check to see it hasn't already been executed
	SELECT @country_source_id = source_id 
	FROM c_Drug_Source_Formulation
	WHERE source_brand_form_descr = @in_brand_name_formulation
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

SET @default_brand_form_rxcui = upper(@country_code) + 'B' + @country_source_id
SET @default_generic_form_rxcui = upper(@country_code) + 'G' + @country_source_id
SET @default_brand_ingr_rxcui = upper(@country_code) + 'BI' + @country_source_id
SET @default_generic_ingr_rxcui = upper(@country_code) + 'GI' + @country_source_id

IF @generic_only = 1
	BEGIN
	SET @default_brand_form_rxcui = NULL
	SET @default_brand_ingr_rxcui = NULL
	SET @brand_name_rxcui = NULL
	SET @sbd_rxcui = NULL
	END

-- If a generic rxcui has not been supplied, validate it
IF @in_generic_ingr_rxcui IS NOT NULL AND @in_generic_ingr_rxcui != ''
	SELECT @generic_rxcui = generic_rxcui, @generic_name = generic_name
	FROM c_Drug_Generic g 
	WHERE g.generic_rxcui = @in_generic_ingr_rxcui

-- If a generic rxcui has not been supplied, try to find using ingredients
IF @generic_rxcui IS NULL
	BEGIN
	IF @debug = 1 PRINT '@in_generic_ingr_rxcui NULL, looking for ' + @scd_rxcui
	SELECT @generic_rxcui = f.ingr_rxcui, @generic_name = generic_name
	FROM c_Drug_Formulation f
	JOIN c_Drug_Generic g ON g.generic_rxcui = f.ingr_rxcui
	WHERE f.form_rxcui = @scd_rxcui
	
	-- exact wording match for generic?
	IF @generic_rxcui IS NULL
		BEGIN
		IF @debug = 1 PRINT 'generic name not found from formulation: ' + IsNull(@in_active_ingredients,'NULL')
		SELECT @generic_rxcui = generic_rxcui, @generic_name = generic_name
		FROM c_Drug_Generic g 
		WHERE g.generic_name = @in_active_ingredients
		END
	ELSE
		IF @debug = 1 PRINT 'generic name found from formulation: ' + @generic_rxcui
	
	SET @generic_ingr_exists = CASE WHEN @generic_rxcui IS NULL THEN 0 ELSE 1 END

	IF @generic_ingr_exists = 0
		BEGIN
		SET @generic_rxcui = @default_generic_ingr_rxcui
		IF @debug = 1 PRINT 'generic name not exists: ' + @generic_rxcui
		END
	ELSE
		IF @debug = 1 PRINT 'generic name exists: ' + @generic_name

	END

/*
	-- In case @country_source_id had to be made up above, use this 
	-- which should be unique to locate the records to delete
	DELETE FROM Kenya_Drugs
	WHERE [SBD_Version] = @in_brand_name_formulation
	AND [SCD_PSN_Version] = @in_generic_formulation

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
		@in_brand_name_formulation, 
		@in_generic_formulation, 
		@in_corr_scd_rxcui, 
		@in_active_ingredients,
		@generic_only,
		@notes
		)
*/

	-- Generic pack?
	IF ( @scd_rxcui IS NULL -- No corresponding rxcui
			OR ( -- there is not already a valid generic pointed to by SCD_Version
				@scd_rxcui IS NOT NULL 
				AND NOT EXISTS (SELECT 1 FROM c_Drug_Formulation 
								WHERE form_rxcui = @scd_rxcui
				)
			)
		)
		AND (@in_generic_formulation LIKE '%{%'
			OR @in_generic_formulation LIKE '%GPCK%')
		AND NOT EXISTS (SELECT 1 FROM c_Drug_Pack
						WHERE descr = @in_generic_formulation)
		AND NOT EXISTS (SELECT 1 FROM c_Drug_Pack 
						WHERE rxcui = @default_generic_form_rxcui)
			BEGIN
			IF @debug = 1 PRINT 'INSERT INTO #new_generic_pack'
			INSERT INTO #new_generic_pack (
				rxcui,
				descr, 
				tty, 
				valid_in
				)
			SELECT @default_generic_form_rxcui,
				@in_generic_formulation,
				'GPCK_' + upper(@country_code),
				lower(@country_code) + ';'
			FROM c_1_record
			
			END -- 'INSERT INTO #new_generic_form'
		ELSE
			BEGIN
			-- generic pack already exists
			IF @debug = 1 PRINT @in_generic_formulation + ' already exists'
			SELECT TOP 1 @default_generic_form_rxcui = rxcui 
				FROM c_Drug_Pack
				WHERE rxcui = ISNULL(@scd_rxcui,'XXXXXXXX')
				OR descr = @in_generic_formulation
			END
	
	-- Generic formulation?
	IF ( @scd_rxcui IS NULL -- No corresponding rxcui
			OR ( -- there is not already a valid generic pointed to by SCD_Version
				@scd_rxcui IS NOT NULL 
				AND NOT EXISTS (SELECT 1 FROM c_Drug_Formulation 
								WHERE form_rxcui = @scd_rxcui
				)
			)
		)
		AND NOT EXISTS (SELECT 1 FROM c_Drug_Formulation 
						WHERE form_descr = @in_generic_formulation)
		AND NOT EXISTS (SELECT 1 FROM c_Drug_Formulation 
						WHERE form_rxcui = @default_generic_form_rxcui)
			BEGIN
			IF @debug = 1 PRINT 'INSERT INTO #new_generic_form'
			INSERT INTO #new_generic_form (
				form_rxcui,
				form_descr, 
				form_tty, 
				ingr_tty,
				ingr_rxcui,
				valid_in
				)
			SELECT @default_generic_form_rxcui,
				@in_generic_formulation,
				'SCD_' + upper(@country_code), 
				CASE WHEN @single_ingredient = 0 THEN 'MIN' ELSE 'IN' END 
					+ CASE WHEN @generic_rxcui LIKE upper(@country_code) + '%'
						 THEN '_' + upper(@country_code) ELSE '' END,
				@generic_rxcui,
				lower(@country_code) + ';'
			FROM c_1_record
			WHERE @in_generic_formulation NOT LIKE '%{%'
			AND @in_generic_formulation NOT LIKE '%GPCK%'
			END -- 'INSERT INTO #new_generic_form'
		ELSE
			BEGIN
			-- generic formulation already exists
			IF @debug = 1 PRINT @in_generic_formulation + ' already exists'
			SELECT TOP 1 @default_generic_form_rxcui = form_rxcui 
				FROM c_Drug_Formulation 
				WHERE form_rxcui = ISNULL(@scd_rxcui,'XXXXXXXX')
				OR form_descr = @in_generic_formulation
			END
	
	-- Generic drug?
	IF @generic_ingr_exists = 1
		BEGIN
		IF @debug = 1 PRINT @generic_name + ' already exists'
		UPDATE #new_generic_form
		SET ingr_rxcui = @generic_rxcui
		UPDATE c_Drug_Generic
		SET valid_in = valid_in + lower(@country_code) + ';'
		WHERE generic_rxcui = @generic_rxcui
		AND valid_in NOT LIKE '%' + @country_code + ';%'
		END
	ELSE
		BEGIN
		IF @generic_name IS NULL
			SET @generic_name = dbo.fn_ingredients(@in_generic_formulation)

		IF @debug = 1 PRINT 'Inserting ' + @in_active_ingredients + ' INTO #Drug_Generic'
		INSERT INTO #Drug_Generic (
			generic_rxcui,
			generic_name,
			is_single_ingredient,
			valid_in,
			drug_id
		)
		SELECT @generic_rxcui,
			@generic_name,
			@single_ingredient,
			lower(@country_code) + ';',
			@generic_rxcui
		FROM c_1_record
		WHERE @generic_name IS NOT NULL
		END

	-- Brand pack?
	IF ( @sbd_rxcui IS NULL -- No corresponding rxcui
			OR ( -- there is not already a valid pack pointed to by @sbd_rxcui
				@sbd_rxcui IS NOT NULL 
				AND NOT EXISTS (SELECT 1 FROM c_Drug_Pack
								WHERE rxcui = @sbd_rxcui
				)
			)
		)
		AND (@in_brand_name_formulation LIKE '%{%'
			OR @in_brand_name_formulation LIKE '%BPCK%')
		AND NOT EXISTS (SELECT 1 FROM c_Drug_Pack
						WHERE descr = @in_brand_name_formulation)
		AND NOT EXISTS (SELECT 1 FROM c_Drug_Pack 
						WHERE rxcui = @default_brand_form_rxcui)
			BEGIN
			IF @debug = 1 PRINT 'INSERT INTO #new_pack'
			INSERT INTO #new_pack (
				rxcui,
				descr, 
				tty, 
				valid_in
				)
			SELECT @default_brand_form_rxcui,
				@in_brand_name_formulation,
				'BPCK_' + upper(@country_code),
				lower(@country_code) + ';'
			FROM c_1_record
			
			END -- 'INSERT INTO #new_form'
		ELSE
			BEGIN
			-- brand pack already exists
			IF @debug = 1 PRINT @in_brand_name_formulation + ' pack already exists'
			SELECT TOP 1 @default_brand_form_rxcui = rxcui 
				FROM c_Drug_Pack
				WHERE rxcui = ISNULL(@sbd_rxcui,'XXXXXXXX')
				OR descr = @in_brand_name_formulation
			END

	-- Brand formulation?
	IF @generic_only = 0 
		BEGIN
		IF @debug = 1 PRINT 'INSERT INTO #new_form'
		INSERT INTO #new_form (
			form_rxcui,
			form_descr, 
			form_tty, 
			ingr_tty,
			ingr_rxcui,
			valid_in,
			generic_form_rxcui
			)
		SELECT @default_brand_form_rxcui,
			@in_brand_name_formulation,
			'SBD_' + upper(@country_code), 
			'BN' + '_' + upper(@country_code),
			@default_brand_ingr_rxcui,
			lower(@country_code) + ';',
			@default_generic_form_rxcui -- select *  
		FROM c_1_record
		-- Exclude packs
		WHERE @in_brand_name_formulation NOT LIKE '%{%'
		AND @in_brand_name_formulation NOT LIKE '%BPCK%'
		-- Exclude if brand name identical to generic
		AND @in_brand_name_formulation != @in_generic_formulation 
		-- Exclude where they would duplicate existing formulations
		AND NOT EXISTS (SELECT 1 FROM c_Drug_Formulation 
						WHERE form_descr = @in_brand_name_formulation)
		AND NOT EXISTS (SELECT 1 FROM c_Drug_Formulation 
						WHERE form_rxcui = @default_brand_form_rxcui)
		AND NOT EXISTS (SELECT 1 FROM c_Drug_Formulation 
						WHERE form_rxcui = IsNull(@sbd_rxcui,'XXXXXX'))

		IF (SELECT count(*) FROM #new_form) = 0
			BEGIN
			-- brand formulation already exists
			IF @debug = 1 PRINT @in_brand_name_formulation + ' brand form already exists'
			SELECT TOP 1 @default_brand_form_rxcui = form_rxcui 
				FROM c_Drug_Formulation 
				WHERE form_rxcui = substring(ISNULL(@sbd_rxcui,'XXXXXXXX'),5,20)
				OR form_descr = @in_brand_name_formulation
			END

		-- Derive brand ingredient record
		IF @in_brand_name IS NOT NULL
			SET @brand_name_edited = @in_brand_name
		ELSE
			BEGIN
			SET @brand_name_edited = @in_brand_name_formulation
			IF PATINDEX('% in [0-9]%', @in_brand_name_formulation) > 0
				-- " in " at the end of the name
				BEGIN
				IF PATINDEX('% [0-9]%', @in_brand_name_formulation) - PATINDEX('% in [0-9]%', @in_brand_name_formulation) = 3
					SET @brand_name_edited = left(@in_brand_name_formulation,PATINDEX('% in [0-9]%', @in_brand_name_formulation) - 1)
				ELSE
					-- " in " at a different place
					SET @brand_name_edited = left(@in_brand_name_formulation,PATINDEX('% [0-9]%', @in_brand_name_formulation) - 1)
				END
			ELSE IF PATINDEX('% [0-9]%', @in_brand_name_formulation) > 0
				SET @brand_name_edited = left(@in_brand_name_formulation,PATINDEX('% [0-9]%', @in_brand_name_formulation) - 1)
			ELSE IF charindex(' ', @in_brand_name_formulation) > 0
				SET @brand_name_edited = left(@in_brand_name_formulation,charindex(' ', @in_brand_name_formulation) - 1)
			IF @debug = 1 PRINT @brand_name_edited + ' @brand_name_edited'
			END

		IF EXISTS (SELECT 1 FROM c_Drug_Brand b
						WHERE brand_name = @brand_name_edited
						OR brand_name_rxcui = @in_brand_rxcui)
			BEGIN
			IF @debug = 1 PRINT @brand_name_edited + ' Brand already exists'
			SELECT @brand_name_rxcui = b.brand_name_rxcui
				FROM c_Drug_Brand b 
				WHERE b.brand_name = @brand_name_edited
					OR brand_name_rxcui = @in_brand_rxcui
			UPDATE #new_form
			SET ingr_rxcui = @brand_name_rxcui
			UPDATE c_Drug_Brand
			SET valid_in = valid_in + lower(@country_code) + ';'
			WHERE brand_name_rxcui = @brand_name_rxcui
			AND valid_in NOT LIKE '%' + @country_code + ';%'
			END
		ELSE
			BEGIN
			IF @debug = 1 PRINT 'Inserting ' + @brand_name_edited + ' INTO #Drug_Brand'
			INSERT INTO #Drug_Brand (
				brand_name_rxcui,
				brand_name,
				generic_rxcui,
				is_single_ingredient,
				valid_in,
				drug_id
			)
			SELECT @default_brand_ingr_rxcui,
				@brand_name_edited,
				@generic_rxcui,
				@single_ingredient,
				lower(@country_code) + ';',
				@default_brand_ingr_rxcui
			FROM c_1_record
			END

		IF @debug = 1 PRINT 'UPDATE #Drug_Brand name'
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
	IF @debug = 1 PRINT 'INSERT INTO c_Drug_Formulation from #new_generic_form'
	INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty, ingr_tty, ingr_rxcui, valid_in)
	SELECT form_rxcui, form_descr, form_tty, ingr_tty, ingr_rxcui, valid_in
	FROM #new_generic_form
	END

	IF (SELECT count(*) FROM #new_form) > 0
	BEGIN
	IF @debug = 1 PRINT 'INSERT INTO c_Drug_Formulation from #new_form'
	INSERT INTO c_Drug_Formulation (form_rxcui, form_descr, form_tty, ingr_tty, ingr_rxcui, valid_in, generic_form_rxcui)
	SELECT form_rxcui, form_descr, form_tty, ingr_tty, ingr_rxcui, valid_in, generic_form_rxcui
	FROM #new_form
	END

	IF (SELECT count(*) FROM #new_generic_pack) > 0
	BEGIN
	IF @debug = 1 PRINT 'INSERT INTO c_Drug_Pack from #new_generic_pack'
	INSERT INTO c_Drug_Pack (rxcui, descr, tty, valid_in)
	SELECT rxcui, descr, tty, valid_in
	FROM #new_generic_pack
	END

	IF (SELECT count(*) FROM #new_pack) > 0
	BEGIN
	IF @debug = 1 PRINT 'INSERT INTO c_Drug_Pack from #new_pack'
	INSERT INTO c_Drug_Pack (rxcui, descr, tty, valid_in)
	SELECT rxcui, descr, tty, valid_in
	FROM #new_pack
	END

	IF (SELECT count(*) FROM #Drug_Brand) > 0
	BEGIN
	IF @debug = 1 PRINT 'INSERT INTO c_Drug_Brand'
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
	IF @debug = 1 PRINT 'INSERT INTO c_Drug_Generic'
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
	IF @debug = 1 PRINT 'INSERT INTO c_Drug_Definition brand'
	INSERT INTO c_Drug_Definition (drug_id, drug_type, common_name, generic_name)
	SELECT b.drug_id, @drug_type,
		CASE WHEN LEN(b.brand_name) <= 80 THEN b.brand_name ELSE left(b.brand_name,77) + '...' END, 
		CASE WHEN LEN(g.generic_name) <= 500 THEN g.generic_name ELSE left(g.generic_name,497) + '...' END -- select '''' + g.generic_name + ''','
	FROM #Drug_Brand b
	JOIN #Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
	WHERE NOT EXISTS (SELECT 1 FROM c_Drug_Definition d where d.drug_id = b.drug_id)
	AND EXISTS (SELECT 1 FROM c_Drug_Formulation f where b.brand_name_rxcui = f.ingr_rxcui)

	-- Missing KE generic definitions
	IF @debug = 1 PRINT 'INSERT INTO c_Drug_Definition generic'
	INSERT INTO c_Drug_Definition (drug_id, drug_type, common_name, generic_name)
	SELECT g.drug_id, @drug_type, 
		CASE WHEN LEN(g.generic_name) <= 80 THEN g.generic_name ELSE left(g.generic_name,77) + '...' END, 
		CASE WHEN LEN(g.generic_name) <= 500 THEN g.generic_name ELSE left(g.generic_name,497) + '...' END -- select '''' + g.generic_name + ''','
	FROM #Drug_Generic g
	WHERE NOT EXISTS (SELECT 1 FROM c_Drug_Definition d where d.drug_id = g.drug_id)
	AND EXISTS (SELECT 1 FROM c_Drug_Formulation f where g.generic_rxcui = f.ingr_rxcui)

	IF @debug = 1 PRINT 'INSERT INTO c_Drug_Source_Formulation'
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
		CASE WHEN @generic_only = 1 THEN NULL ELSE @in_brand_name_formulation END,
		CASE WHEN @generic_only = 1 THEN NULL ELSE COALESCE(@brand_name_rxcui, @default_brand_ingr_rxcui) END,
		@in_generic_formulation,
		COALESCE(@generic_name, @in_active_ingredients),
		@generic_rxcui,
		@single_ingredient,
		@default_generic_form_rxcui,
		CASE WHEN @generic_only = 1 THEN NULL ELSE @default_brand_form_rxcui END
	WHERE NOT EXISTS (SELECT 1 FROM c_Drug_Source_Formulation r
		WHERE r.[source_id] = @country_source_id
		AND r.country_code = @country_code)

	-- Skip package sync if nothing new was added
	IF (SELECT count(*) FROM #Drug_Brand) > 0
		OR (SELECT count(*) FROM #Drug_Generic) > 0
		OR (SELECT count(*) FROM #new_form) > 0
		OR (SELECT count(*) FROM #new_generic_form) > 0
		exec sp_add_missing_drug_defn_pkg_adm_method
END