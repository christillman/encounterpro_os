/****** Object:  Stored Procedure dbo.sp_get_drug_packages    Script Date: 7/25/2000 8:43:44 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_drug_packages    Script Date: 2/16/99 12:00:47 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_drug_packages    Script Date: 10/26/98 2:20:33 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_drug_packages    Script Date: 10/4/98 6:28:07 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_drug_packages    Script Date: 9/24/98 3:06:01 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_drug_packages    Script Date: 8/17/98 4:16:39 PM ******/
CREATE PROCEDURE sp_get_drug_packages (
	@ps_drug_id varchar(24) )
AS
SELECT c_Drug_Package.package_id,
c_Drug_Package.sort_order,
c_Drug_Package.prescription_flag,
c_Drug_Package.default_dispense_amount,
c_Drug_Package.default_dispense_unit,
c_Drug_Package.take_as_directed,
c_Package.description
FROM c_Drug_Package,
c_Package
WHERE c_Drug_Package.package_id = c_Package.package_id
AND c_Drug_Package.drug_id = @ps_drug_id

