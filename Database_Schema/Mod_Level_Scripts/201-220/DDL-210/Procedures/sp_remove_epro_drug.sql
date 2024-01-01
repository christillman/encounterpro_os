
Print 'Drop Procedure [dbo].[sp_remove_epro_drug]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'sp_remove_epro_drug') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_remove_epro_drug]
GO

Print 'Create Procedure [dbo].[sp_remove_epro_drug]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_remove_epro_drug (
	@is_rxnorm bit,
	@country_code varchar(100),
	@country_drug_id varchar(21),
	@brand_name_rxcui varchar(20) = NULL,
	@generic_rxcui varchar(20) = NULL,
	@brand_form_rxcui varchar(20) = NULL,
	@generic_form_rxcui varchar(20) = NULL
	)
AS

BEGIN

/*
	@is_rxnorm bit,
	@generic_only bit,
	@country_code varchar(100), 
	-- specifying @country_drug_id also removes from Kenya_Drugs and _Related tables
	@country_drug_id varchar(21),
	-- if only brand is specified, will leave generic in place
	@brand_name_rxcui varchar(20),
	-- if generic is used by other countries, it will not be removed
	@generic_rxcui varchar(20),
	-- make @brand_name_rxcui and @generic_rxcui NULL if you only want to remove the formulation(s)
	-- (if either are specified, formulations will also be removed)
	@brand_form_rxcui varchar(20),
	@generic_form_rxcui varchar(20)
*/

DECLARE @msg varchar(100)
DECLARE @replacement_generic_rxcui varchar(20)
DECLARE @replacement_brand_name_rxcui varchar(20)

IF @is_rxnorm = 0 
	BEGIN

	IF @brand_name_rxcui IS NULL
		AND @generic_rxcui IS NULL 
		AND @brand_form_rxcui IS NULL
		AND @generic_form_rxcui IS NULL
		BEGIN

		-- remove all brands and generics related to this @country_drug_id
		-- (if not used by other related records)
		SELECT @brand_name_rxcui = brand_name_rxcui
		FROM c_Drug_Brand_Related r
		WHERE source_id = @country_drug_id
		AND brand_name_rxcui LIKE @country_code + 'BI%'
		AND country_code = @country_code

		IF @brand_name_rxcui IS NULL
			SELECT @brand_name_rxcui = brand_name_rxcui
			FROM c_Drug_Brand b
			WHERE brand_name_rxcui = @country_code + 'BI' + @country_drug_id

		SELECT @replacement_brand_name_rxcui 
				= upper(@country_code) + 'BI' + min(source_id) 
			FROM c_Drug_Brand_Related r2
			WHERE source_id != @country_drug_id
			AND brand_name_rxcui = @brand_name_rxcui
			AND country_code = @country_code

		IF @replacement_brand_name_rxcui IS NOT NULL
			BEGIN
			-- We are intending to retire this country_drug_id, 
			-- but it's been chosen as the representative ID for this
			-- brand name. So we need to substitute the replacement.
			print 'Replacing ' + @brand_name_rxcui + ' with ' + @replacement_brand_name_rxcui
			UPDATE c_Drug_Formulation
			SET ingr_rxcui = @replacement_brand_name_rxcui
			WHERE ingr_rxcui = @brand_name_rxcui
			UPDATE c_Drug_Definition
			SET drug_id = @replacement_brand_name_rxcui
			WHERE drug_id = @brand_name_rxcui
			UPDATE c_Drug_Brand
			SET brand_name_rxcui = @replacement_brand_name_rxcui
			WHERE brand_name_rxcui = @brand_name_rxcui
			UPDATE c_Drug_Brand
			SET drug_id = @replacement_brand_name_rxcui
			WHERE drug_id = @brand_name_rxcui
			UPDATE c_Drug_Brand_Related 
			SET brand_name_rxcui = @replacement_brand_name_rxcui
			WHERE source_id != @country_drug_id
			AND brand_name_rxcui = @brand_name_rxcui

			END

		SELECT @generic_rxcui = generic_rxcui
			FROM c_Drug_Generic_Related r 
			WHERE source_id = @country_drug_id
			AND generic_rxcui LIKE @country_code + 'GI%'
		IF @generic_rxcui IS NULL
			SELECT @generic_rxcui = generic_rxcui
			FROM c_Drug_Generic g
			WHERE generic_rxcui = @country_code + 'GI' + @country_drug_id
		SELECT @replacement_generic_rxcui 
				= upper(@country_code) + 'GI' + min(source_id) 
			FROM c_Drug_Generic_Related r2
			WHERE source_id != @country_drug_id
			AND generic_rxcui = @generic_rxcui
			AND country_code = @country_code

		IF @replacement_generic_rxcui IS NOT NULL
			BEGIN
			-- We are intending to retire this country_drug_id, 
			-- but it's been chosen as the representative ID for this
			-- generic. So we need to substitute the replacement.
			print 'Replacing ' + @generic_rxcui + ' with ' + @replacement_generic_rxcui
			UPDATE c_Drug_Formulation
			SET ingr_rxcui = @replacement_generic_rxcui
			WHERE ingr_rxcui = @generic_rxcui
			UPDATE c_Drug_Brand
			SET generic_rxcui = @replacement_generic_rxcui
			WHERE generic_rxcui = @generic_rxcui
			UPDATE c_Drug_Definition
			SET drug_id = @replacement_generic_rxcui
			WHERE drug_id = @generic_rxcui
			UPDATE c_Drug_Generic
			SET generic_rxcui = @replacement_generic_rxcui
			WHERE generic_rxcui = @generic_rxcui
			UPDATE c_Drug_Generic
			SET drug_id = @replacement_generic_rxcui
			WHERE drug_id = @generic_rxcui
			UPDATE c_Drug_Generic_Related 
			SET generic_rxcui = @replacement_generic_rxcui
			WHERE source_id != @country_drug_id
			AND generic_rxcui = @generic_rxcui

			END

		END

	IF @generic_rxcui IS NULL AND @brand_name_rxcui IS NULL
		BEGIN

		-- only remove specified formulations with their packages
		SELECT package_id
		INTO #remove_pkgs
		FROM c_Drug_Package
		WHERE form_rxcui IN (@brand_form_rxcui, @generic_form_rxcui)
		DELETE FROM c_Package_Administration_Method
		WHERE package_id IN (SELECT package_id FROM #remove_pkgs)
		DELETE FROM c_Package
		WHERE package_id IN (SELECT package_id FROM #remove_pkgs)
		DELETE FROM c_Drug_Package
		WHERE package_id IN (SELECT package_id FROM #remove_pkgs)

		END
	ELSE IF @brand_name_rxcui IS NOT NULL
		BEGIN
		-- remove brands with their formulations and packages
			SELECT form_rxcui
			INTO #remove_brand_forms
			FROM c_Drug_Formulation
			WHERE form_rxcui LIKE @country_code + 'B%'
				AND form_rxcui = replace(@brand_name_rxcui,
				@country_code + 'BI', @country_code + 'B')

			SELECT @msg = 'Removing ' + convert(varchar(2), count(*)) 
				+ ' brand formulations for ' 
				+ replace(@brand_name_rxcui, @country_code + 'BI', @country_code + 'B')
			FROM #remove_brand_forms
			print @msg

			SELECT package_id
			INTO #remove_brand_pkgs
			FROM c_Drug_Package
			WHERE form_rxcui IN (SELECT form_rxcui FROM #remove_brand_forms)
			DELETE FROM c_Package_Administration_Method
			WHERE package_id IN (SELECT package_id FROM #remove_brand_pkgs)
			DELETE FROM c_Package
			WHERE package_id IN (SELECT package_id FROM #remove_brand_pkgs)
			DELETE FROM c_Drug_Package
			WHERE package_id IN (SELECT package_id FROM #remove_brand_pkgs)
			DELETE FROM c_Drug_Formulation
			WHERE form_rxcui IN (SELECT form_rxcui FROM #remove_brand_forms)

			SELECT @msg = 'Removing drug defn ' + drug_id + ', ' + common_name 
			FROM c_Drug_Definition
			WHERE drug_id = (
				SELECT drug_id FROM c_Drug_Brand
				WHERE brand_name_rxcui = @brand_name_rxcui
				AND @brand_name_rxcui LIKE @country_code + 'BI%'
				)
			print @msg
			DELETE FROM c_Drug_Definition
			WHERE drug_id = (
				SELECT drug_id FROM c_Drug_Brand
				WHERE brand_name_rxcui = @brand_name_rxcui
				AND @brand_name_rxcui LIKE @country_code + 'BI%'
				)

			SELECT @msg = 'Removing brand ' + brand_name_rxcui + ', ' + brand_name 
			FROM c_Drug_Brand
			WHERE brand_name_rxcui = @brand_name_rxcui
				AND @brand_name_rxcui LIKE @country_code + 'BI%'
			print @msg
			DELETE FROM c_Drug_Brand
			WHERE brand_name_rxcui = @brand_name_rxcui
				AND @brand_name_rxcui LIKE @country_code + 'BI%'

		END
	ELSE IF @generic_rxcui IS NOT NULL
		BEGIN
		-- remove generics with their formulations and packages

			SELECT form_rxcui
			INTO #remove_generic_forms
			FROM c_Drug_Formulation
			WHERE form_rxcui LIKE @country_code + 'G%'
				AND form_rxcui = replace(@generic_rxcui,
				@country_code + 'GI', @country_code + 'G')
			SELECT @msg = 'Removing ' + convert(varchar(2), count(*)) 
				+ ' generic formulations for ' + @generic_rxcui
			FROM #remove_generic_forms
			print @msg

			SELECT package_id
			INTO #remove_generic_pkgs
			FROM c_Drug_Package
			WHERE form_rxcui IN (SELECT form_rxcui FROM #remove_generic_forms)
			DELETE FROM c_Package_Administration_Method
			WHERE package_id IN (SELECT package_id FROM #remove_generic_pkgs)
			DELETE FROM c_Package
			WHERE package_id IN (SELECT package_id FROM #remove_generic_pkgs)
			DELETE FROM c_Drug_Package
			WHERE package_id IN (SELECT package_id FROM #remove_generic_pkgs)
			DELETE FROM c_Drug_Formulation
			WHERE form_rxcui IN (SELECT form_rxcui FROM #remove_generic_forms)

			SELECT @msg = 'Removing drug defn ' + drug_id + ', ' + common_name 
			FROM c_Drug_Definition
			WHERE drug_id = (
				SELECT drug_id FROM c_Drug_Generic
				WHERE generic_rxcui = @generic_rxcui
				AND @generic_rxcui LIKE @country_code + 'GI%'
				)
			print @msg
			DELETE FROM c_Drug_Definition
			WHERE drug_id = (
				SELECT drug_id FROM c_Drug_Generic
				WHERE generic_rxcui = @generic_rxcui
				AND @generic_rxcui LIKE @country_code + 'GI%'
				)

			SELECT @msg = 'Removing generic ' + generic_rxcui + ', ' + generic_name 
			FROM c_Drug_Generic 
			WHERE generic_rxcui = @generic_rxcui
				AND @generic_rxcui LIKE @country_code + 'GI%'
			print @msg
			DELETE FROM c_Drug_Generic
			WHERE generic_rxcui = @generic_rxcui
				AND @generic_rxcui LIKE @country_code + 'GI%'

		END

	IF @country_drug_id IS NOT NULL
		BEGIN

		DELETE FROM [c_Drug_Brand_Related]
		WHERE source_id = @country_drug_id
		AND country_code = @country_code
		DELETE FROM [c_Drug_Generic_Related]
		WHERE source_id = @country_drug_id
		AND country_code = @country_code
		DELETE FROM Kenya_Drugs
		WHERE Retention_No = @country_drug_id

		END
	END -- @is_rxnorm = 0
	ELSE
		print 'removing rxnorm DRUG'
	
END