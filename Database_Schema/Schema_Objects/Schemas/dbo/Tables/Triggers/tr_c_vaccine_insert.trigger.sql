CREATE TRIGGER tr_c_vaccine_insert ON dbo.c_vaccine
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

INSERT INTO c_drug_definition (
drug_id, drug_type, common_name, status)
SELECT i.vaccine_id, 'Vaccine', CAST(i.description AS varchar(40)), i.status
FROM inserted i
WHERE NOT EXISTS(
	SELECT 1
	FROM c_Drug_Definition dd
	WHERE dd.drug_id = i.vaccine_id)

