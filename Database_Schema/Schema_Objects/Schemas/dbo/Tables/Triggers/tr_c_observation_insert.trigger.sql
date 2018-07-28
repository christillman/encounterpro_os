CREATE TRIGGER tr_c_observation_insert ON dbo.c_Observation
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

UPDATE c_observation
SET owner_id = c_Database_Status.customer_id,
	definition = COALESCE(inserted.definition, inserted.description)
FROM c_observation
	INNER JOIN inserted
	ON c_observation.observation_id = inserted.observation_id
	CROSS JOIN c_Database_Status
WHERE inserted.owner_id = -1


UPDATE t
SET last_updated = i.last_updated
FROM c_Observation_Tree as t
	JOIN inserted as i
		ON t.child_observation_id = i.observation_id

DECLARE @ls_updated_by varchar(24)

SELECT @ls_updated_by = min(updated_by)
FROM inserted

EXECUTE sp_table_update @ps_table_name = 'c_Observation', @ps_updated_by = @ls_updated_by

-- Remove any equivalence records where the ID matches but the keys don't
DELETE e
FROM c_Equivalence e
	INNER JOIN inserted i
	ON e.object_id = i.id
WHERE (e.object_type <> 'Observation'
		OR e.object_key <> i.observation_id)

-- Remove any equivalence records where the keys match but the ID doesn't
DELETE e
FROM c_Equivalence e
	INNER JOIN inserted i
	ON e.object_type = 'Observation'
	AND e.object_key = i.observation_id
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
SELECT o.id,
	NULL,
	getdate(),
	'#SYSTEM',
	object_key = o.observation_id,
	description = ISNULL(o.description, '<No Description>'),
	object_type = 'Observation',
	o.owner_id
FROM inserted o
WHERE NOT EXISTS (
	SELECT 1
	FROM c_Equivalence e
	WHERE o.id = e.object_id
	)

