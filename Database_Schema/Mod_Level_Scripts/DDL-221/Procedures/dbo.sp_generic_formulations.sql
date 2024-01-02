
Print 'Drop Procedure [dbo].[sp_generic_formulations]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_generic_formulations]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_generic_formulations]
GO

Print 'Create Procedure [dbo].[sp_generic_formulations]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_generic_formulations (
	@ps_generic_ingr_rxcui varchar(20),
	@ps_brand_name_rxcui varchar(20),
	@country_code varchar(100) )
AS

BEGIN

/* The generic that was picked, if any (0 if brand was picked)*/
SELECT form_descr, form_rxcui, ingr_rxcui, 
	dbo.fn_strength_sort(form_descr) AS strength_sort
	/* , 'Y' as matches_brand */
FROM c_Drug_Formulation
WHERE ingr_rxcui = @ps_generic_ingr_rxcui
AND valid_in LIKE '%' + @country_code + ';%'
UNION
/* If no generic picked, then only the generic formulations matching 
	the available formulations for the brand that was picked */
SELECT f.form_descr, f.form_rxcui, f.ingr_rxcui, 
	dbo.fn_strength_sort(f.form_descr) AS strength_sort
FROM c_Drug_Formulation fb 
JOIN c_Drug_Formulation f ON f.form_rxcui = fb.generic_form_rxcui
WHERE fb.ingr_rxcui = @ps_brand_name_rxcui
AND f.valid_in LIKE '%' + @country_code + ';%'
AND fb.valid_in LIKE '%' + @country_code + ';%'
AND @ps_generic_ingr_rxcui = '0'
ORDER BY strength_sort

END

GO
GRANT EXECUTE
	ON [dbo].[sp_generic_formulations]
	TO [cprsystem]
GO
-- EXEC sp_generic_formulations '0', '1366149', 'ke' -- US only should return no result
-- EXEC sp_generic_formulations '214186', '0', 'us' -- oddly named PSN
-- EXEC sp_generic_formulations '284635', '0', 'us' -- slashes in strengths
-- EXEC sp_generic_formulations '0', '284756', 'KE' -- should only have one in the list
