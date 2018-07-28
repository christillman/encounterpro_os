/****** Object:  Stored Procedure dbo.sp_update_charge    Script Date: 7/25/2000 8:44:12 AM ******/
/****** Object:  Stored Procedure dbo.sp_update_charge    Script Date: 2/16/99 12:01:15 PM ******/
/****** Object:  Stored Procedure dbo.sp_update_charge    Script Date: 10/26/98 2:20:55 PM ******/
/****** Object:  Stored Procedure dbo.sp_update_charge    Script Date: 10/4/98 6:28:25 PM ******/
/****** Object:  Stored Procedure dbo.sp_update_charge    Script Date: 9/24/98 3:06:19 PM ******/
/****** Object:  Stored Procedure dbo.sp_update_charge    Script Date: 8/17/98 4:17:00 PM ******/
CREATE PROCEDURE sp_update_charge (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@pl_encounter_charge_id integer,
	@ps_procedure_id varchar(24),
	@pm_charge money )
AS
UPDATE p_Encounter_Charge
SET	procedure_id = @ps_procedure_id,
	charge = @pm_charge
WHERE	cpr_id = @ps_cpr_id
AND	encounter_id = @pl_encounter_id
AND	encounter_charge_id = @pl_encounter_charge_id

