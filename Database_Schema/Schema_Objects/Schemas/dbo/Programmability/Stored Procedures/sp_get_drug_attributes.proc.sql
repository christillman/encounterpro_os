/****** Object:  Stored Procedure dbo.sp_get_drug_attributes    Script Date: 7/25/2000 8:44:14 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_drug_attributes    Script Date: 2/16/99 12:00:46 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_drug_attributes    Script Date: 10/26/98 2:20:33 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_drug_attributes    Script Date: 10/4/98 6:28:07 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_drug_attributes    Script Date: 9/24/98 3:06:00 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_drug_attributes    Script Date: 8/17/98 4:16:39 PM ******/
CREATE PROCEDURE sp_get_drug_attributes (
	@ps_drug_id varchar(24) )
AS
EXECUTE sp_get_drug_categories @ps_drug_id = @ps_drug_id
EXECUTE sp_get_drug_packages @ps_drug_id = @ps_drug_id
EXECUTE sp_get_drug_admins @ps_drug_id = @ps_drug_id
EXECUTE sp_get_hcpcs @ps_drug_id = @ps_drug_id

