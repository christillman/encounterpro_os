CREATE TRIGGER tr_c_assessment_definition_update ON dbo.c_assessment_definition
FOR UPDATE
AS

UPDATE e
SET object_key = a.assessment_id,
	description = ISNULL(a.description, '<No Description>')
FROM c_Equivalence e
	INNER JOIN inserted a
	ON e.object_id = a.id

