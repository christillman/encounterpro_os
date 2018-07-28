/****** Object:  Stored Procedure dbo.sp_new_package    Script Date: 7/25/2000 8:44:16 AM ******/
/****** Object:  Stored Procedure dbo.sp_new_package    Script Date: 2/16/99 12:01:01 PM ******/
/****** Object:  Stored Procedure dbo.sp_new_package    Script Date: 10/26/98 2:20:46 PM ******/
/****** Object:  Stored Procedure dbo.sp_new_package    Script Date: 10/4/98 6:28:18 PM ******/
/****** Object:  Stored Procedure dbo.sp_new_package    Script Date: 9/24/98 3:06:11 PM ******/
/****** Object:  Stored Procedure dbo.sp_new_package    Script Date: 8/17/98 4:16:52 PM ******/
CREATE PROCEDURE sp_new_package (
	@ps_package_id varchar(24) OUTPUT,
	@ps_administer_method varchar(12),
	@ps_description varchar(80),
	@ps_administer_unit varchar(12),
	@ps_dose_unit varchar(12),
	@pr_administer_per_dose real,
	@ps_dosage_form varchar(24),
	@pr_dose_amount real )
AS
DECLARE @ll_suffix integer
EXECUTE sp_get_next_key
	@ps_cpr_id = '!CPR',
	@ps_key_id = 'PACKAGE_ID',
	@pl_key_value = @ll_suffix OUTPUT
SELECT @ps_package_id = office_id + convert(varchar(14), @ps_dosage_form) + convert(varchar(6), @ll_suffix)
FROM o_Office
WHILE exists (select * from c_Package where package_id = @ps_package_id)
	BEGIN
	EXECUTE sp_get_next_key
		@ps_cpr_id = '!CPR',
		@ps_key_id = 'PACKAGE_ID',
		@pl_key_value = @ll_suffix OUTPUT
	SELECT @ps_package_id = office_id + convert(varchar(14), @ps_dosage_form) + convert(varchar(6), @ll_suffix)
	FROM o_Office
	END
INSERT INTO c_Package (
	package_id,
	administer_method,
	description,
	administer_unit,
	dose_unit,
	administer_per_dose,
	dosage_form,
	dose_amount )
VALUES (
	@ps_package_id,
	@ps_administer_method,
	@ps_description,
	@ps_administer_unit,
	@ps_dose_unit,
	@pr_administer_per_dose,
	@ps_dosage_form,
	@pr_dose_amount )

