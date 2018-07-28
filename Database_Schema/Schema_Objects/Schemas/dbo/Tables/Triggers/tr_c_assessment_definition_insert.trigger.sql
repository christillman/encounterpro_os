CREATE TRIGGER tr_c_assessment_definition_insert ON dbo.c_assessment_definition
FOR INSERT
AS

UPDATE c_assessment_definition
SET owner_id = c_Database_Status.customer_id,
	definition = COALESCE(inserted.definition, inserted.description)
FROM c_assessment_definition
	INNER JOIN inserted
	ON c_assessment_definition.assessment_id = inserted.assessment_id
	CROSS JOIN c_Database_Status
WHERE inserted.owner_id = -1

-- Remove any equivalence records where the ID matches but the keys don't
DELETE e
FROM c_Equivalence e
	INNER JOIN inserted i
	ON e.object_id = i.id
WHERE (e.object_type <> 'Assessment'
		OR e.object_key <> i.assessment_id)

-- Remove any equivalence records where the keys match but the ID doesn't
DELETE e
FROM c_Equivalence e
	INNER JOIN inserted i
	ON e.object_type = 'Assessment'
	AND e.object_key = i.assessment_id
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
SELECT a.id,
	NULL,
	getdate(),
	'#SYSTEM',
	object_key = a.assessment_id,
	description = ISNULL(a.description, '<No Description>'),
	object_type = 'Assessment',
	a.owner_id
FROM inserted a
WHERE NOT EXISTS (
	SELECT 1
	FROM c_Equivalence e
	WHERE a.id = e.object_id
	)


