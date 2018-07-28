CREATE TRIGGER tr_c_Observation_Treatment_Type_delete ON dbo.c_Observation_Treatment_Type
FOR DELETE
AS

DELETE c_Observation_Observation_Cat
FROM deleted
WHERE c_Observation_Observation_Cat.observation_id = deleted.observation_id
AND c_Observation_Observation_Cat.treatment_type = deleted.treatment_type
