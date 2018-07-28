/****** Object:  Stored Procedure dbo.sp_dont_bill_treatment    Script Date: 7/25/2000 8:43:39 AM ******/
/****** Object:  Stored Procedure dbo.sp_dont_bill_treatment    Script Date: 2/16/99 12:00:42 PM ******/
/****** Object:  Stored Procedure dbo.sp_dont_bill_treatment    Script Date: 10/26/98 2:20:30 PM ******/
/****** Object:  Stored Procedure dbo.sp_dont_bill_treatment    Script Date: 10/4/98 6:28:04 PM ******/
CREATE PROCEDURE sp_dont_bill_treatment (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@pl_encounter_charge_id integer)
AS
UPDATE p_Encounter_Charge
SET bill_flag = 'N'
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id
AND encounter_charge_id = @pl_encounter_charge_id

