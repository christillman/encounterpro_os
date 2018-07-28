CREATE TRIGGER tr_c_Drug_Definition_insert ON dbo.c_Drug_Definition
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

INSERT INTO c_Vaccine
       (vaccine_id
       ,description
       ,status
       ,sort_sequence)
SELECT drug_id
       ,common_name
       ,status
       ,999
FROM inserted i
WHERE drug_type = 'Vaccine'
AND NOT EXISTS (
	SELECT 1
	FROM c_Vaccine v
	WHERE i.drug_id = v.vaccine_id)

-- Remove any equivalence records where the ID matches but the keys don't
DELETE e
FROM c_Equivalence e
	INNER JOIN inserted i
	ON e.object_id = i.id
WHERE (e.object_type <> 'Drug'
		OR e.object_key <> i.drug_id)

-- Remove any equivalence records where the keys match but the ID doesn't
DELETE e
FROM c_Equivalence e
	INNER JOIN inserted i
	ON e.object_type = 'Drug'
	AND e.object_key = i.drug_id
WHERE e.object_id <> i.id


INSERT INTO c_Equivalence (
	object_id ,
	equivalence_group_id ,
	created ,
	created_by ,
	object_key ,
	description ,
	object_type,
	owner_id )
SELECT d.id,
	NULL,
	getdate(),
	'#SYSTEM',
	object_key = d.drug_id,
	description = ISNULL(d.common_name, '<No Description>'),
	object_type = 'Drug',
	d.owner_id
FROM inserted d
WHERE NOT EXISTS (
	SELECT 1
	FROM c_Equivalence e
	WHERE d.id = e.object_id
	)

