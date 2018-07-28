CREATE TRIGGER tr_c_patient_material_insert ON dbo.c_patient_material
FOR INSERT
AS

UPDATE c_patient_material
SET owner_id = c_Database_Status.customer_id
FROM c_patient_material
	INNER JOIN inserted
	ON c_patient_material.material_id = inserted.material_id
	CROSS JOIN c_Database_Status
WHERE inserted.owner_id = -1

UPDATE m
SET status = 'NA'
FROM c_Patient_Material m
	INNER JOIN inserted i
	ON m.id = i.id
WHERE m.version < i.version

-- Remove any equivalence records where the ID matches but the keys don't
DELETE e
FROM c_Equivalence e
	INNER JOIN inserted i
	ON e.object_id = i.id
WHERE (e.object_type <> 'Material'
		OR e.object_key <> CAST(i.material_id AS varchar(64)))

-- Remove any equivalence records where the keys match but the ID doesn't
DELETE e
FROM c_Equivalence e
	INNER JOIN inserted i
	ON e.object_type = 'Material'
	AND e.object_key = CAST(i.material_id AS varchar(64))
WHERE e.object_id <> i.id

INSERT INTO c_Equivalence (
	object_id ,
	equivalence_group_id ,
	created ,
	created_by ,
	object_key ,
	description ,
	object_type ,
	owner_id)
SELECT m.id,
	NULL,
	getdate(),
	'#SYSTEM',
	object_key = CAST(m.material_id AS varchar(64)),
	description = ISNULL(m.title, '<No Description>'),
	object_type = 'Material',
	m.owner_id
FROM inserted m
WHERE NOT EXISTS (
	SELECT 1
	FROM c_Equivalence e
	WHERE m.id = e.object_id
	)

