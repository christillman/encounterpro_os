/****** Object:  Stored Procedure dbo.sp_get_drug_categories    Script Date: 7/25/2000 8:43:43 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_drug_categories    Script Date: 2/16/99 12:00:46 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_drug_categories    Script Date: 10/26/98 2:20:33 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_drug_categories    Script Date: 10/4/98 6:28:07 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_drug_categories    Script Date: 9/24/98 3:06:01 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_drug_categories    Script Date: 8/17/98 4:16:39 PM ******/
CREATE PROCEDURE sp_get_drug_categories (
	@ps_drug_id varchar(24) )
AS
SELECT	c_Drug_Category.drug_category_id,
	c_Drug_Category.description
FROM	c_Drug_Category,
	c_Drug_Drug_Category
WHERE c_Drug_Category.drug_category_id = c_Drug_Drug_Category.drug_category_id
AND c_Drug_Drug_Category.drug_id = @ps_drug_id

