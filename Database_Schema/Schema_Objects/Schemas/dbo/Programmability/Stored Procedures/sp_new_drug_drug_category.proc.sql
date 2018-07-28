/****** Object:  Stored Procedure dbo.sp_new_drug_drug_category    Script Date: 7/25/2000 8:43:59 AM ******/
/****** Object:  Stored Procedure dbo.sp_new_drug_drug_category    Script Date: 2/16/99 12:00:59 PM ******/
/****** Object:  Stored Procedure dbo.sp_new_drug_drug_category    Script Date: 10/26/98 2:20:44 PM ******/
/****** Object:  Stored Procedure dbo.sp_new_drug_drug_category    Script Date: 10/4/98 6:28:16 PM ******/
/****** Object:  Stored Procedure dbo.sp_new_drug_drug_category    Script Date: 9/24/98 3:06:09 PM ******/
/****** Object:  Stored Procedure dbo.sp_new_drug_drug_category    Script Date: 8/17/98 4:16:50 PM ******/
CREATE PROCEDURE sp_new_drug_drug_category (
	@ps_drug_id varchar(24),
	@ps_drug_category_id varchar(24) )
AS
INSERT INTO c_Drug_Drug_Category (
	drug_id,
	drug_category_id )
VALUES (
	@ps_drug_id,
	@ps_drug_category_id)

