DROP VIEW v_drug_search
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

GO


GRANT EXECUTE
	ON [dbo].[sp_drug_search]
	TO [cprsystem]
GO
