Print 'Drop View [dbo].[v_drug_search]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[v_drug_search]') AND [type]='V'))
DROP VIEW v_drug_search
Print 'Create View [dbo].[v_drug_search]'
GO
CREATE VIEW v_drug_search AS
	SELECT -- top 10
		a.drug_id,
		a.drug_type,
		a.common_name,
		a.generic_name,
		a.common_name + CASE WHEN a.common_name = ISNULL(a.generic_name, a.common_name) THEN '' 
						ELSE ' (' + a.generic_name + ')' END as description ,
		a.status,
		COALESCE(t.button, 'b_new03.bmp') as icon,
		t.drug_flag,
		c.drug_category_id,
		cd.specialty_id,
		selected_flag=0
	FROM c_Drug_Definition a
		INNER JOIN c_Drug_Type t
		ON a.drug_type = t.drug_type
		LEFT OUTER JOIN c_Drug_Drug_Category c
		ON a.drug_id = c.drug_id
		LEFT OUTER JOIN c_Common_Drug cd
		ON a.drug_id = cd.drug_id 
	WHERE a.drug_type = 'Vaccine' OR (
		EXISTS (SELECT 1 FROM c_Drug_Generic g
			JOIN c_Drug_Formulation f ON f.ingr_rxcui = g.generic_rxcui
			CROSS JOIN o_Office oo
			JOIN c_Office co ON co.office_id = oo.office_id
			WHERE g.drug_id = a.drug_id
			AND g.valid_in LIKE '%' + co.country + ';%'
			AND f.valid_in LIKE '%' + co.country + ';%'
			)
		OR EXISTS (SELECT 1 FROM c_Drug_Brand b
			JOIN c_Drug_Formulation f ON f.ingr_rxcui = b.brand_name_rxcui
			CROSS JOIN o_Office oo
			JOIN c_Office co ON co.office_id = oo.office_id
			WHERE b.drug_id = a.drug_id
			AND b.valid_in LIKE '%' + co.country + ';%'
			AND f.valid_in LIKE '%' + co.country + ';%'
			)
		)

GO


GRANT EXECUTE
	ON [dbo].[sp_drug_search]
	TO [cprsystem]
GO
