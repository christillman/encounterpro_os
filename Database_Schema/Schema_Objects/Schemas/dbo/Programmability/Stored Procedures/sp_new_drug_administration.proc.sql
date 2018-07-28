/****** Object:  Stored Procedure dbo.sp_new_drug_administration    Script Date: 7/25/2000 8:43:59 AM ******/
/****** Object:  Stored Procedure dbo.sp_new_drug_administration    Script Date: 2/16/99 12:00:59 PM ******/
/****** Object:  Stored Procedure dbo.sp_new_drug_administration    Script Date: 10/26/98 2:20:44 PM ******/
/****** Object:  Stored Procedure dbo.sp_new_drug_administration    Script Date: 10/4/98 6:28:16 PM ******/
/****** Object:  Stored Procedure dbo.sp_new_drug_administration    Script Date: 9/24/98 3:06:09 PM ******/
/****** Object:  Stored Procedure dbo.sp_new_drug_administration    Script Date: 8/17/98 4:16:50 PM ******/
CREATE PROCEDURE sp_new_drug_administration (
	@ps_drug_id varchar(24),
	@pi_administration_sequence smallint,
	@ps_administer_frequency varchar(12),
	@pr_administer_amount real,
	@ps_administer_unit varchar(12), 	@ps_mult_by_what varchar(12),
	@ps_calc_per varchar(12),
	@ps_description varchar(40) )
AS
INSERT INTO c_Drug_Administration (
	drug_id,
	administration_sequence,
	administer_frequency,
	administer_amount,
	administer_unit,
	mult_by_what,
	calc_per,
	description )
VALUES (
	@ps_drug_id,
	@pi_administration_sequence,
	@ps_administer_frequency,
	@pr_administer_amount,
	@ps_administer_unit,
	@ps_mult_by_what,
	@ps_calc_per,
	@ps_description )

