CREATE TRIGGER tr_p_Encounter_Charge_update ON dbo.p_Encounter_Charge
FOR UPDATE
AS

IF @@ROWCOUNT = 0
	RETURN

