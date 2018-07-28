CREATE TRIGGER tr_c_procedure_update ON dbo.c_procedure
FOR UPDATE
AS


IF UPDATE(vaccine_id)
	BEGIN
	UPDATE dd
	SET procedure_id = i.procedure_id
	FROM c_Drug_Definition dd
		INNER JOIN inserted i
		ON dd.drug_id = i.vaccine_id
	WHERE dd.procedure_id IS NULL
	END

UPDATE e
SET object_key = p.procedure_id,
	description = ISNULL(p.description, '<No Description>')
FROM c_Equivalence e
	INNER JOIN inserted p
	ON e.object_id = p.id


