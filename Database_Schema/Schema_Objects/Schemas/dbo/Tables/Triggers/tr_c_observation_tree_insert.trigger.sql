CREATE TRIGGER tr_c_observation_tree_insert ON dbo.c_observation_tree
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

UPDATE o
SET last_updated = i.last_updated
FROM c_observation as o
	JOIN inserted as i
		ON o.observation_id = i.parent_observation_id

