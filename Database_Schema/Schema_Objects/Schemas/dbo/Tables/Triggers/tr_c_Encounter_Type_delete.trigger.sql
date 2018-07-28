CREATE TRIGGER tr_c_Encounter_Type_delete ON dbo.c_Encounter_Type
FOR DELETE
AS

DELETE t
FROM c_encounter_type_progress_type t
	INNER JOIN deleted i
	ON t.encounter_type = i.encounter_type

DELETE k
FROM c_encounter_type_progress_key k
	INNER JOIN deleted i
	ON k.encounter_type = i.encounter_type



