CREATE TRIGGER tr_c_vaccine_update ON dbo.c_vaccine
FOR UPDATE
AS

IF @@ROWCOUNT = 0
	RETURN

IF UPDATE(description)
	UPDATE d
	SET common_name = CAST(v.description AS varchar(40))
	FROM c_drug_definition d
		INNER JOIN inserted v
		ON d.drug_id = v.vaccine_id
	WHERE d.common_name <> CAST(v.description AS varchar(40))


IF UPDATE(status)
	UPDATE d
	SET status = v.status
	FROM c_drug_definition d
		INNER JOIN inserted v
		ON d.drug_id = v.vaccine_id
	WHERE d.status <> v.status


