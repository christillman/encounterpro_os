
Print 'Drop Procedure [dbo].[sp_brand_formulations]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_brand_formulations]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_brand_formulations]
GO

Print 'Create Procedure [dbo].[sp_brand_formulations]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_brand_formulations (
	@ps_brand_name_rxcui varchar(20),
	@ps_generic_ingr_rxcui varchar(20),
	@country_code varchar(100) )
AS

BEGIN

/* The brand that was picked, if any (0 if unpicked)*/
SELECT form_descr, form_rxcui, ingr_rxcui, dbo.fn_strength_sort(form_descr) as sort_order
FROM c_Drug_Formulation
WHERE ingr_rxcui = @ps_brand_name_rxcui
AND valid_in LIKE '%' + @country_code + ';%'
UNION
/* If no brand picked, then all brands for the generic that was picked */
SELECT form_descr, form_rxcui, ingr_rxcui, dbo.fn_strength_sort(form_descr) as sort_order
FROM c_Drug_Formulation f
JOIN c_Drug_Brand b ON b.generic_rxcui = @ps_generic_ingr_rxcui
WHERE ingr_rxcui = b.brand_name_rxcui
AND @ps_brand_name_rxcui = '0'
AND f.valid_in LIKE '%' + @country_code + ';%'
ORDER BY dbo.fn_strength_sort(form_descr)
END

GO
GRANT EXECUTE
	ON [dbo].[sp_brand_formulations]
	TO [cprsystem]
GO
-- exec sp_brand_formulations '301543', '284635', 'us'
-- exec sp_brand_formulations '0', '284635', 'us'
-- exec sp_brand_formulations 'KEBI10367', '0', 'ke'