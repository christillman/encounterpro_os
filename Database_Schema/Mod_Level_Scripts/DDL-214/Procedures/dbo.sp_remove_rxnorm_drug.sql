
Print 'Drop Procedure [dbo].[sp_remove_rxnorm_drug]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'sp_remove_rxnorm_drug') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_remove_rxnorm_drug]
GO

Print 'Create Procedure [dbo].[sp_remove_rxnorm_drug]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_remove_rxnorm_drug (
	@drug_id varchar(21),
	@brand_name_rxcui varchar(20) = NULL,
	@generic_rxcui varchar(20) = NULL,
	@brand_form_rxcui varchar(20) = NULL,
	@generic_form_rxcui varchar(20) = NULL
	)
AS

BEGIN

/*
	@drug_id varchar(21),
	-- if only brand is specified, will leave generic in place
	@brand_name_rxcui varchar(20),
	-- if generic is used by other countries, it will not be removed
	@generic_rxcui varchar(20),
	-- make @brand_name_rxcui and @generic_rxcui NULL if you only want to remove the formulation(s)
	-- (if either are specified, formulations will also be removed)
	@brand_form_rxcui varchar(20),
	@generic_form_rxcui varchar(20)
*/

DECLARE @msg varchar(500)
DECLARE @replacement_generic_rxcui varchar(20)
DECLARE @replacement_brand_name_rxcui varchar(20)

IF @brand_name_rxcui IS NULL
	AND @generic_rxcui IS NULL 
	AND @brand_form_rxcui IS NULL
	AND @generic_form_rxcui IS NULL
	BEGIN

	-- remove all brands and generics related to this @drug_id (rxcui)
	-- (if not used by related records)
	SELECT @brand_name_rxcui = brand_name_rxcui
	FROM c_Drug_Source_Formulation r
	WHERE 'RXNB' + brand_name_rxcui = @drug_id

	IF @@rowcount = 0
		SELECT @brand_name_rxcui = brand_name_rxcui
		FROM c_Drug_Brand b
		WHERE drug_id = @drug_id

	SELECT @generic_rxcui = generic_rxcui
		FROM c_Drug_Source_Formulation r 
		WHERE 'RXNG' + generic_rxcui = @drug_id

	IF @@rowcount = 0
		SELECT @generic_rxcui = generic_rxcui
		FROM c_Drug_Generic g
		WHERE drug_id = @drug_id

	END

print 'Removing drug_id ' + IsNull(@drug_id,'@drug_id NULL')
--print IsNull(@brand_name_rxcui,'@brand_name_rxcui NULL')
--print IsNull(@generic_rxcui,'@generic_rxcui NULL')

IF @brand_name_rxcui IS NOT NULL
	BEGIN
	-- remove brands with their formulations and packages
		SELECT form_rxcui
		INTO #remove_brand_forms1
		FROM c_Drug_Formulation
		WHERE ingr_rxcui = @brand_name_rxcui

		SELECT TOP 1 @msg = 'Removing ' + convert(varchar(2), count(*)) 
			+ ' brand formulations for ingredient ' 
			+ @brand_name_rxcui
		FROM #remove_brand_forms1
		print @msg

		SELECT package_id
		INTO #remove_brand_pkgs1
		FROM c_Drug_Package
		WHERE form_rxcui IN (SELECT form_rxcui FROM #remove_brand_forms1)
		DELETE FROM c_Package_Administration_Method
		WHERE package_id IN (SELECT package_id FROM #remove_brand_pkgs1)
		DELETE FROM c_Package
		WHERE package_id IN (SELECT package_id FROM #remove_brand_pkgs1)
		DELETE FROM c_Drug_Package
		WHERE package_id IN (SELECT package_id FROM #remove_brand_pkgs1)
		DELETE FROM c_Drug_Formulation
		WHERE form_rxcui IN (SELECT form_rxcui FROM #remove_brand_forms1)

		SELECT @msg = 'Removing drug defn ' + drug_id + ', ' + common_name 
		FROM c_Drug_Definition
		WHERE drug_id IN (
			SELECT drug_id FROM c_Drug_Brand
			WHERE brand_name_rxcui = @brand_name_rxcui
			)
		OR drug_id = @drug_id
		IF @@rowcount = 0
			SET @msg = 'c_Drug_Definition for ' + @brand_name_rxcui + ' not found'
		print @msg

		DELETE FROM c_Drug_Definition
		WHERE drug_id IN (
			SELECT drug_id FROM c_Drug_Brand
			WHERE brand_name_rxcui = @brand_name_rxcui
			)
		OR drug_id = @drug_id

		SELECT @msg = 'Removing brand ' + brand_name_rxcui + ', ' + brand_name 
		FROM c_Drug_Brand
		WHERE brand_name_rxcui = @brand_name_rxcui
		IF @@rowcount = 0
			SET @msg = 'c_Drug_Brand ' + @brand_name_rxcui + ' not found'
		print @msg

		DELETE FROM c_Drug_Brand
		WHERE brand_name_rxcui = @brand_name_rxcui

	END
		
IF @generic_rxcui IS NOT NULL
	BEGIN
	-- remove generics with their formulations and packages

		SELECT form_rxcui
		INTO #remove_generic_forms1
		FROM c_Drug_Formulation
		WHERE ingr_rxcui = @generic_rxcui
		SELECT TOP 1 @msg = 'Removing ' + convert(varchar(2), count(*)) 
			+ ' generic formulations for ' + @generic_rxcui
		FROM #remove_generic_forms1
		print @msg

		SELECT package_id
		INTO #remove_generic_pkgs1
		FROM c_Drug_Package
		WHERE form_rxcui IN (SELECT form_rxcui FROM #remove_generic_forms1)
		DELETE FROM c_Package_Administration_Method
		WHERE package_id IN (SELECT package_id FROM #remove_generic_pkgs1)
		DELETE FROM c_Package
		WHERE package_id IN (SELECT package_id FROM #remove_generic_pkgs1)
		DELETE FROM c_Drug_Package
		WHERE package_id IN (SELECT package_id FROM #remove_generic_pkgs1)
		DELETE FROM c_Drug_Formulation
		WHERE form_rxcui IN (SELECT form_rxcui FROM #remove_generic_forms1)

		SELECT @msg = 'Removing drug defn ' + drug_id + ', ' + generic_name 
		FROM c_Drug_Definition
		WHERE drug_id = (
			SELECT drug_id FROM c_Drug_Generic
			WHERE generic_rxcui = @generic_rxcui
			)
		OR drug_id = @drug_id
		IF @@rowcount = 0
			SET @msg = 'c_Drug_Definition for ' + @generic_rxcui + ' not found'
		print @msg
		DELETE FROM c_Drug_Definition
		WHERE drug_id = (
			SELECT drug_id FROM c_Drug_Generic
			WHERE generic_rxcui = @generic_rxcui
			)
		OR drug_id = @drug_id

		SELECT @msg = 'Removing generic ' + generic_rxcui + ', ' + generic_name 
		FROM c_Drug_Generic 
		WHERE generic_rxcui = @generic_rxcui
		IF @@rowcount = 0
			SET @msg = 'c_Drug_Generic ' + @generic_rxcui + ' not found'
		print @msg
		DELETE FROM c_Drug_Generic
		WHERE generic_rxcui = @generic_rxcui

	END

		
IF @generic_form_rxcui IS NOT NULL OR @brand_form_rxcui IS NOT NULL
	BEGIN
	-- remove the specified formulations with their packages
	SELECT package_id
	INTO #remove_pkgs1
	FROM c_Drug_Package
	WHERE form_rxcui IN (@brand_form_rxcui, @generic_form_rxcui)
	DELETE FROM c_Package_Administration_Method
	WHERE package_id IN (SELECT package_id FROM #remove_pkgs1)
	DELETE FROM c_Package
	WHERE package_id IN (SELECT package_id FROM #remove_pkgs1)
	DELETE FROM c_Drug_Package
	WHERE package_id IN (SELECT package_id FROM #remove_pkgs1)
	DELETE FROM c_Drug_Formulation
	WHERE form_rxcui IN (@brand_form_rxcui, @generic_form_rxcui)

	END

END