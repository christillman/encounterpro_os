CREATE TRIGGER tr_p_encounter_assessment_update ON dbo.p_Encounter_Assessment
FOR UPDATE
AS

IF @@ROWCOUNT = 0
	RETURN

