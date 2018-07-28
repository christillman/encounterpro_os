/****** Object:  Stored Procedure dbo.sp_get_drug_admins    Script Date: 7/25/2000 8:43:43 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_drug_admins    Script Date: 2/16/99 12:00:46 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_drug_admins    Script Date: 10/26/98 2:20:33 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_drug_admins    Script Date: 10/4/98 6:28:07 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_drug_admins    Script Date: 9/24/98 3:06:00 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_drug_admins    Script Date: 8/17/98 4:16:38 PM ******/
CREATE PROCEDURE sp_get_drug_admins (
	@ps_drug_id varchar(24) )
AS
SELECT c_Drug_Administration.administration_sequence,
c_Drug_Administration.administer_frequency,
c_Drug_Administration.administer_unit,
c_Drug_Administration.administer_amount,
c_Drug_Administration.mult_by_what,
c_Drug_Administration.calc_per,
c_Drug_Administration.description
FROM c_Drug_Administration
WHERE c_Drug_Administration.drug_id = @ps_drug_id

