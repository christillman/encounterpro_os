CREATE PROCEDURE sp_set_charge_billing (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@pl_encounter_charge_id integer,
	@ps_bill_flag char(1),
	@ps_created_by varchar(24) )
AS
UPDATE p_Encounter_Charge
SET	bill_flag = @ps_bill_flag
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id
AND encounter_charge_id = @pl_encounter_charge_id

IF @@ROWCOUNT = 0
	BEGIN
	RAISERROR ('Charge does not exist',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END

