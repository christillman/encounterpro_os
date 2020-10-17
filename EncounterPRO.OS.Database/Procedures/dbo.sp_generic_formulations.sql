
Print 'Drop Procedure [dbo].[sp_generic_formulations]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_generic_formulations]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_generic_formulations]
GO

Print 'Create Procedure [dbo].[sp_generic_formulations]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_generic_formulations (
	@ps_generic_ingr_rxcui varchar(10),
	@ps_brand_name_rxcui varchar(10),
	@country_code varchar(100) )
AS

BEGIN

/* The generic that was picked, if any (0 if unpicked)*/
SELECT form_descr, form_rxcui, ingr_rxcui, dbo.fn_strength_sort(form_descr) 
	/* , 'Y' as matches_brand */
FROM c_Drug_Formulation
WHERE ingr_rxcui = @ps_generic_ingr_rxcui
AND valid_in LIKE '%' + @country_code + ';%'
UNION
/* If no generic picked, then only the generic formulations matching 
	the available formulations for the brand that was picked */
SELECT f.form_descr, f.form_rxcui, f.ingr_rxcui, dbo.fn_strength_sort(f.form_descr)
FROM c_Drug_Brand b 
JOIN c_Drug_Formulation f ON f.ingr_rxcui = b.generic_rxcui
WHERE b.brand_name_rxcui = @ps_brand_name_rxcui
AND f.valid_in LIKE '%' + @country_code + ';%'
AND @ps_generic_ingr_rxcui = '0'
AND EXISTS (SELECT 1 FROM c_Drug_Formulation f2 
			WHERE f2.ingr_rxcui = b.brand_name_rxcui
			AND IsNull(f2.RXN_available_strength,'') = IsNull(f.RXN_available_strength,''))
ORDER BY 4


END

GO
GRANT EXECUTE
	ON [dbo].[sp_generic_formulations]
	TO [cprsystem]
GO
-- EXEC sp_generic_formulations '0', '1366144', 'ke'
-- EXEC sp_generic_formulations '214186', '0', 'us'
-- EXEC sp_generic_formulations '284635', '0', 'us'
-- EXEC sp_generic_formulations '0', '301543', 'us'
