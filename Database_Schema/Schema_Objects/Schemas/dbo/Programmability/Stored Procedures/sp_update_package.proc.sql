/****** Object:  Stored Procedure dbo.sp_update_package    Script Date: 7/25/2000 8:44:13 AM ******/
/****** Object:  Stored Procedure dbo.sp_update_package    Script Date: 2/16/99 12:01:16 PM ******/
/****** Object:  Stored Procedure dbo.sp_update_package    Script Date: 10/26/98 2:20:56 PM ******/
/****** Object:  Stored Procedure dbo.sp_update_package    Script Date: 10/4/98 6:28:25 PM ******/
/****** Object:  Stored Procedure dbo.sp_update_package    Script Date: 9/24/98 3:06:20 PM ******/
/****** Object:  Stored Procedure dbo.sp_update_package    Script Date: 8/17/98 4:17:01 PM ******/
CREATE PROCEDURE sp_update_package (
	@ps_package_id varchar(24),
	@ps_administer_method varchar(12),
	@ps_description varchar(80),
	@ps_administer_unit varchar(12),
	@ps_dose_unit varchar(12),
	@pr_administer_per_dose real,
	@ps_dosage_form varchar(24),
	@pr_dose_amount real )
AS
UPDATE c_Package
SET	administer_method = @ps_administer_method,
	description = @ps_description,
	administer_unit = @ps_administer_unit,
	dose_unit = @ps_dose_unit,
	administer_per_dose = @pr_administer_per_dose,
	dosage_form = @ps_dosage_form,
	dose_amount = @pr_dose_amount
WHERE package_id = @ps_package_id

