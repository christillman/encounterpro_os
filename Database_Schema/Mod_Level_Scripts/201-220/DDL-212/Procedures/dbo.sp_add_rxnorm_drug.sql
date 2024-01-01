
Print 'Drop Procedure [dbo].[sp_add_rxnorm_drug]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'sp_add_rxnorm_drug') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_add_rxnorm_drug]
GO

Print 'Create Procedure [dbo].[sp_add_rxnorm_drug]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_add_rxnorm_drug (
	@generic_only bit,
	@brand_form_rxcui varchar(20), -- (rxcui for rxnorm brand formulation)
	@brand_name_formulation varchar(300),
	@brand_name varchar(300),
	@brand_name_rxcui varchar(20), -- (rxcui for rxnorm brand ingredient)
	@generic_rxcui varchar(20), -- (rxcui for generic ingredient)
	@generic_form_rxcui varchar(20), -- (rxcui for rxnorm generic formulation)
	@generic_formulation varchar(300),
	@generic_name varchar(500),
	@drug_type varchar(20) = 'Single Drug',
	@notes varchar(200) = NULL
	)
AS

BEGIN

IF @brand_name_formulation LIKE 'No %'
	SET @generic_only = 1

DECLARE @single_ingredient bit = CASE 
	WHEN @generic_name LIKE '% / %'
		OR @generic_formulation LIKE '% / %' THEN 0 
		ELSE 1 END
		
	-- Generic formulation?
	IF NOT EXISTS (SELECT 1 FROM c_Drug_Formulation 
			WHERE form_rxcui = @generic_form_rxcui
			)
		BEGIN
		print 'INSERT INTO c_Drug_Formulation for generic'
		INSERT INTO c_Drug_Formulation (
			form_rxcui,
			form_descr, 
			form_tty, 
			ingr_tty,
			ingr_rxcui,
			valid_in
			)
		SELECT @generic_form_rxcui,
			@generic_formulation,
			'SCD', 
			CASE WHEN @single_ingredient = 0 THEN 'MIN' ELSE 'IN' END,
			@generic_rxcui,
			'us;'
		FROM c_1_record
		WHERE @generic_formulation NOT LIKE '%{%'
		AND @generic_formulation NOT LIKE '%GPCK%'
		-- Exclude where they would duplicate existing RXNORM ones
		AND NOT EXISTS (SELECT 1 FROM c_Drug_Formulation 
						WHERE form_descr = @generic_formulation)
		END 
	ELSE
		BEGIN
		-- generic formulation already exists
		print @generic_formulation + ' already exists'
		END
	
-- Generic drug?
IF EXISTS (SELECT 1 FROM c_Drug_Generic 
			WHERE generic_rxcui = @generic_rxcui
			)
	BEGIN
	print @generic_name + ' already exists'
	UPDATE c_Drug_Generic
	SET valid_in = valid_in + 'us;'
	WHERE generic_rxcui = @generic_rxcui
	AND valid_in NOT LIKE '%us;%'
	END
ELSE
	BEGIN
	print 'Inserting ' + @generic_name + ' INTO c_Drug_Generic'
	INSERT INTO c_Drug_Generic (
		generic_rxcui,
		generic_name,
		is_single_ingredient,
		valid_in,
		drug_id
	)
	SELECT @generic_rxcui,
		@generic_name,
		@single_ingredient,
		'us;',
		'RXNG' + @generic_rxcui
	FROM c_1_record
	END

-- Brand formulation?
IF @generic_only = 0 
	BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM c_Drug_Formulation 
		WHERE form_rxcui = @brand_form_rxcui)
		BEGIN
		print 'INSERT INTO c_Drug_Formulation for Brand'
		INSERT INTO c_Drug_Formulation (
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
			'SBD', 
			'BN',
			@brand_name_rxcui,
			'us;', 
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
		END
	
	IF EXISTS (SELECT 1 FROM c_Drug_Brand b
				WHERE brand_name_rxcui = @brand_name_rxcui)
		BEGIN
		print @brand_name + ' Brand already exists'
		UPDATE c_Drug_Brand
		SET valid_in = valid_in + 'us;'
		WHERE brand_name_rxcui = @brand_name_rxcui
		AND valid_in NOT LIKE '%us;%'
		END
	ELSE
		BEGIN
		print 'Inserting ' + @brand_name + ' INTO c_Drug_Brand'
		INSERT INTO c_Drug_Brand (
			brand_name_rxcui,
			brand_name,
			generic_rxcui,
			is_single_ingredient,
			valid_in,
			drug_id
		)
		SELECT @brand_name_rxcui,
			@brand_name,
			@generic_rxcui,
			@single_ingredient,
			'us;',
			'RXNB' + @brand_name_rxcui
		FROM c_1_record
		END
	END 

	-- Insert to drug_definition now, to specify @drug_type;
	-- sp_add_missing_drug_defn_pkg_adm_method will not duplicate
	print 'INSERT INTO c_Drug_Definition brand'
	INSERT INTO c_Drug_Definition (drug_id, drug_type, common_name, generic_name)
	SELECT 'RXNB' + @brand_name_rxcui, @drug_type,
		CASE WHEN LEN(@brand_name) <= 80 THEN @brand_name ELSE left(@brand_name,77) + '...' END, 
		CASE WHEN LEN(@generic_name) <= 500 THEN @generic_name ELSE left(@generic_name,497) + '...' END -- select '''' + @generic_name + ''','
	FROM c_1_record
	WHERE NOT EXISTS (SELECT 1 FROM c_Drug_Definition d where d.drug_id = 'RXNB' + @brand_name_rxcui)
	AND EXISTS (SELECT 1 FROM c_Drug_Formulation f where f.ingr_rxcui = @brand_name_rxcui)

	-- Missing KE generic definitions
	print 'INSERT INTO c_Drug_Definition generic'
	INSERT INTO c_Drug_Definition (drug_id, drug_type, common_name, generic_name)
	SELECT 'RXNG' + @generic_rxcui, @drug_type, 
		CASE WHEN LEN(@generic_name) <= 80 THEN @generic_name ELSE left(@generic_name,77) + '...' END, 
		CASE WHEN LEN(@generic_name) <= 500 THEN @generic_name ELSE left(@generic_name,497) + '...' END -- select '''' + @generic_name + ''','
	FROM c_1_record
	WHERE NOT EXISTS (SELECT 1 FROM c_Drug_Definition d where d.drug_id = 'RXNG' + @generic_rxcui)
	AND EXISTS (SELECT 1 FROM c_Drug_Formulation f where f.ingr_rxcui = @generic_rxcui)

	exec sp_add_missing_drug_defn_pkg_adm_method
	
END