CREATE TRIGGER tr_c_observation_result_insert ON dbo.c_Observation_Result
FOR INSERT
AS

UPDATE o
SET last_updated = i.last_updated
FROM c_observation as o
	JOIN inserted as i
		ON o.observation_id = i.observation_id

-- For now we don't allow single quote characters in the comment_title.  This will be
-- fixed in a future build of EncounterPRO, but in the mean time, substitute a backwards quote (`)
UPDATE r
SET result = REPLACE(i.result, '''', '`')
FROM c_observation_result r
	INNER JOIN inserted i
	ON i.observation_id = r.observation_id
	AND i.result_sequence = r.result_sequence
WHERE i.result_type = 'COMMENT' 
AND CHARINDEX('''', i.result) > 0

-- If the result_unit is 'NA' then the result_amount flag must be 'N'
UPDATE r
SET result_amount_flag = 'N'
FROM c_observation_result r
	INNER JOIN inserted i
	ON i.observation_id = r.observation_id
	AND i.result_sequence = r.result_sequence
WHERE i.result_amount_flag = 'Y' 
AND i.result_unit = 'NA'

-- UPDATE the numeric units display mask to force to display the zero (.0) if the
-- observation is owned by a third party (i.e. lab)
UPDATE r
SET display_mask = replace(u.display_mask,'.#','.0#')
FROM c_observation_result r
	INNER JOIN inserted i
	ON i.observation_id = r.observation_id
	AND i.result_sequence = r.result_sequence
	INNER JOIN c_Unit u
	ON u.unit_id = r.result_unit
	INNER JOIN c_Observation o
	ON r.observation_id = o.observation_id
WHERE u.unit_type = 'NUMBER'
AND u.display_mask LIKE '%.#%'
AND r.display_mask IS NULL
AND o.owner_id > 0 
AND o.owner_id < 900

-- Remove any equivalence records where the ID matches but the keys don't
DELETE e
FROM c_Equivalence e
	INNER JOIN inserted i
	ON e.object_id = i.id
WHERE (e.object_type <> 'Result'
		OR e.object_key <> i.observation_id + '|' + CAST(i.result_sequence AS varchar(8)))

-- Remove any equivalence records where the keys match but the ID doesn't
DELETE e
FROM c_Equivalence e
	INNER JOIN inserted i
	ON e.object_type = 'Result'
	AND e.object_key = i.observation_id + '|' + CAST(i.result_sequence AS varchar(8))
WHERE e.object_id <> i.id

INSERT INTO c_Equivalence (
	object_id ,
	equivalence_group_id ,
	created ,
	created_by ,
	object_key ,
	description ,
	object_type )
SELECT r.id,
	NULL,
	getdate(),
	'#SYSTEM',
	object_key = r.observation_id + '|' + CAST(r.result_sequence AS varchar(8)),
	description = r.result,
	object_type = 'Result'
FROM inserted r
WHERE NOT EXISTS (
	SELECT 1
	FROM c_Equivalence e
	WHERE r.id = e.object_id
	)

