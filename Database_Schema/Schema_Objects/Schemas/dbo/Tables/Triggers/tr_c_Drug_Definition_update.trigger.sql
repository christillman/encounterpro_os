CREATE TRIGGER tr_c_Drug_Definition_update ON dbo.c_Drug_Definition
FOR UPDATE
AS

IF @@ROWCOUNT = 0
	RETURN

IF UPDATE(status)
	UPDATE v
	SET status = i.status
	FROM c_Vaccine v
		INNER JOIN inserted i
		ON v.vaccine_id = i.drug_id
		INNER JOIN deleted d
		ON i.drug_id = d.drug_id
	WHERE i.drug_type = 'Vaccine'
	AND i.status <> d.status


