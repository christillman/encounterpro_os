/****** Object:  Stored Procedure dbo.sp_update_drug_package    Script Date: 7/25/2000 8:44:12 AM ******/
/****** Object:  Stored Procedure dbo.sp_update_drug_package    Script Date: 2/16/99 12:01:15 PM ******/
/****** Object:  Stored Procedure dbo.sp_update_drug_package    Script Date: 10/26/98 2:20:56 PM ******/
/****** Object:  Stored Procedure dbo.sp_update_drug_package    Script Date: 10/4/98 6:28:25 PM ******/
/****** Object:  Stored Procedure dbo.sp_update_drug_package    Script Date: 9/24/98 3:06:19 PM ******/
/****** Object:  Stored Procedure dbo.sp_update_drug_package    Script Date: 8/17/98 4:17:00 PM ******/
CREATE PROCEDURE sp_update_drug_package (
	@ps_drug_id varchar(24),
	@ps_package_id varchar(24),
	@ps_prescription_flag char(1),
	@pr_default_dispense_amount real,
	@ps_default_dispense_unit varchar(12),
	@ps_take_as_directed char(1),
	@pi_sort_order smallint )
AS
UPDATE c_Drug_Package
SET prescription_flag = @ps_prescription_flag,
default_dispense_amount = @pr_default_dispense_amount,
default_dispense_unit = @ps_default_dispense_unit,
take_as_directed = @ps_take_as_directed,
sort_order = @pi_sort_order
WHERE drug_id = @ps_drug_id
AND package_id = @ps_package_id

