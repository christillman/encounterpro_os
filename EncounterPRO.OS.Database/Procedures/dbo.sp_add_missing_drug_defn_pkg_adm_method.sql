Print 'Drop Procedure [dbo].[sp_add_missing_drug_defn_pkg_adm_method]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'sp_add_missing_drug_defn_pkg_adm_method') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_add_missing_drug_defn_pkg_adm_method]
GO

Print 'Create Procedure [dbo].[sp_add_missing_drug_defn_pkg_adm_method]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_add_missing_drug_defn_pkg_adm_method
AS BEGIN

	-- Missing KE brand definitions
	print 'INSERT INTO c_Drug_Definition brand'
	INSERT INTO c_Drug_Definition (drug_id, common_name, generic_name)
	SELECT b.drug_id, 
		CASE WHEN LEN(b.brand_name) <= 80 THEN b.brand_name ELSE left(b.brand_name,77) + '...' END, 
		CASE WHEN LEN(g.generic_name) <= 500 THEN g.generic_name ELSE left(g.generic_name,497) + '...' END -- select '''' + g.generic_name + ''','
	FROM c_Drug_Brand b
	JOIN c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
	WHERE NOT EXISTS (SELECT 1 FROM c_Drug_Definition d where d.drug_id = b.drug_id)
	AND EXISTS (SELECT 1 FROM c_Drug_Formulation f where b.brand_name_rxcui = f.ingr_rxcui)

	-- Missing KE generic definitions
	print 'INSERT INTO c_Drug_Definition generic'
	INSERT INTO c_Drug_Definition (drug_id, common_name, generic_name)
	SELECT g.drug_id, 
		CASE WHEN LEN(g.generic_name) <= 80 THEN g.generic_name ELSE left(g.generic_name,77) + '...' END, 
		CASE WHEN LEN(g.generic_name) <= 500 THEN g.generic_name ELSE left(g.generic_name,497) + '...' END -- select '''' + g.generic_name + ''','
	FROM c_Drug_Generic g
	WHERE NOT EXISTS (SELECT 1 FROM c_Drug_Definition d where d.drug_id = g.drug_id)
	AND EXISTS (SELECT 1 FROM c_Drug_Formulation f where g.generic_rxcui = f.ingr_rxcui)

	-- drug_package
	print 'INSERT INTO c_Drug_Package brand'
	INSERT INTO c_Drug_Package
	(
			[drug_id]
		  ,[package_id]
		  ,[sort_order]
		  ,[prescription_flag]
		  ,[default_dispense_amount]
		  ,[default_dispense_unit]
		  ,[take_as_directed]
		  ,[hcpcs_procedure_id]
		  ,[form_rxcui]
		  )
	SELECT DISTINCT b.drug_id
		  ,'PK' + [form_rxcui] AS [package_id]
		  ,NULL AS [sort_order]
		  ,'Y' AS [prescription_flag]
		  ,NULL AS [default_dispense_amount]
		  ,NULL AS [default_dispense_unit]
		  ,NULL AS [take_as_directed]
		  ,NULL AS [hcpcs_procedure_id]
		  ,f.[form_rxcui]
	FROM c_Drug_Brand b
	JOIN c_Drug_Formulation f ON b.brand_name_rxcui = f.ingr_rxcui
	WHERE NOT EXISTS (SELECT 1 
			FROM [c_Drug_Package] a 
			WHERE a.drug_id = b.drug_id
			AND a.[form_rxcui] = f.[form_rxcui]
			AND a.[package_id] = 'PK' + [form_rxcui]
			)
			
	print 'INSERT INTO c_Drug_Package generic'
	INSERT INTO c_Drug_Package
	(
			[drug_id]
		  ,[package_id]
		  ,[sort_order]
		  ,[prescription_flag]
		  ,[default_dispense_amount]
		  ,[default_dispense_unit]
		  ,[take_as_directed]
		  ,[hcpcs_procedure_id]
		  ,[form_rxcui]
		  )
	SELECT DISTINCT g.drug_id
		  ,'PK' + [form_rxcui] AS [package_id]
		  ,NULL AS [sort_order]
		  ,'Y' AS [prescription_flag]
		  ,NULL AS [default_dispense_amount]
		  ,NULL AS [default_dispense_unit]
		  ,NULL AS [take_as_directed]
		  ,NULL AS [hcpcs_procedure_id]
		  ,f.[form_rxcui]
	FROM c_Drug_Generic g
	JOIN c_Drug_Formulation f ON g.generic_rxcui = f.ingr_rxcui
	WHERE NOT EXISTS (SELECT 1 
			FROM [c_Drug_Package] a 
			WHERE a.drug_id = g.drug_id
			AND a.[form_rxcui] = f.[form_rxcui]
			AND a.[package_id] = 'PK' + [form_rxcui]
			)

	-- Package
	print 'INSERT INTO c_Package brand'
	INSERT INTO c_Package
	(
			[package_id]
		  ,[description]
		  ,[administer_unit]
		  ,[dose_unit]
		  ,[administer_per_dose]
		  ,[dosage_form]
		  ,[dose_amount]
		  ,[status]
		  )
	SELECT dp.[package_id]
		  ,f.form_descr AS [description]
		  ,NULL AS [administer_unit]
		  ,df.[default_dose_unit] AS [dose_unit]
		  ,NULL AS [administer_per_dose]
		  ,df.[dosage_form]
		  ,NULL
		  ,'OK'
	FROM c_Drug_Formulation f
	LEFT JOIN c_Dosage_Form df ON df.dosage_form = dbo.fn_dosage_form_from_descr(f.form_descr)
	JOIN c_Drug_Brand b ON b.brand_name_rxcui = f.ingr_rxcui
	JOIN c_Drug_Package dp ON dp.drug_id = b.drug_id
		AND dp.form_rxcui = f.form_rxcui
	WHERE NOT EXISTS (SELECT 1 
			FROM [c_Package] a 
			WHERE a.package_id = dp.[package_id]
			)

	print 'INSERT INTO c_Package generic'
	INSERT INTO c_Package
	(
			[package_id]
		  ,[description]
		  ,[administer_unit]
		  ,[dose_unit]
		  ,[administer_per_dose]
		  ,[dosage_form]
		  ,[dose_amount]
		  ,[status]
		  )
	SELECT dp.[package_id]
		  ,f.form_descr AS [description]
		  ,NULL AS [administer_unit]
		  ,df.[default_dose_unit] AS [dose_unit]
		  ,NULL AS [administer_per_dose]
		  ,df.[dosage_form]
		  ,CASE WHEN df.[default_dose_unit] IN ('MG', 'ML', 'MG/ML') 
			THEN NULL ELSE 1 END
		  ,'OK' 
	FROM c_Drug_Formulation f
	LEFT JOIN c_Dosage_Form df ON df.dosage_form = dbo.fn_dosage_form_from_descr(f.form_descr)
	JOIN c_Drug_Generic g ON g.generic_rxcui = f.ingr_rxcui
	JOIN c_Drug_Package dp ON dp.drug_id = g.drug_id
		AND dp.form_rxcui = f.form_rxcui
	WHERE NOT EXISTS (SELECT 1 
			FROM [c_Package] a 
			WHERE a.package_id = dp.[package_id]
			)

	print 'INSERT INTO c_Package_Administration_Method'
	INSERT INTO c_Package_Administration_Method (
		 package_id, 
		 administer_method
		 )
	SELECT package_id, 
		df.default_administer_method
	FROM c_Package p
	LEFT JOIN c_Dosage_Form df ON df.dosage_form = p.dosage_form
	WHERE df.default_administer_method IS NOT NULL
	AND NOT EXISTS (SELECT 1 
		FROM c_Package_Administration_Method m
		WHERE m.package_id = p.package_id
		)

	-- Package_admin_method (null)	
	INSERT INTO c_Package_Administration_Method
	select package_id, NULL
	from c_Package p
	where not exists (select 1 
		from c_Package_Administration_Method m
		where m.package_id = p.package_id )
END