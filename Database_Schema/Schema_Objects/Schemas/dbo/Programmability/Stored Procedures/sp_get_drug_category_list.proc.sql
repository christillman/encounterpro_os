/****** Object:  Stored Procedure dbo.sp_get_drug_category_list    Script Date: 7/25/2000 8:43:43 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_drug_category_list    Script Date: 2/16/99 12:00:47 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_drug_category_list    Script Date: 10/26/98 2:20:33 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_drug_category_list    Script Date: 10/4/98 6:28:07 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_drug_category_list    Script Date: 9/24/98 3:06:01 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_drug_category_list    Script Date: 8/17/98 4:16:39 PM ******/
CREATE PROCEDURE sp_get_drug_category_list (
	@ps_drug_id varchar(24) )
AS
SELECT	drug_category_id,
	description,
	selected_flag=0
FROM c_Drug_Category
WHERE drug_category_id NOT IN (SELECT drug_category_id
				FROM c_Drug_Drug_Category
				WHERE drug_id = @ps_drug_id)

