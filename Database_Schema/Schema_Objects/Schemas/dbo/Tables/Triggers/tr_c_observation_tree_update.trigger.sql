CREATE TRIGGER tr_c_observation_tree_update ON dbo.c_observation_tree
FOR UPDATE
AS

IF @@ROWCOUNT = 0
	RETURN

IF UPDATE(last_updated)
	BEGIN
	IF (SELECT count(*) FROM inserted) > 0
		UPDATE o
		SET last_updated = i.last_updated
		FROM c_observation as o
			JOIN inserted as i
				ON o.observation_id = i.parent_observation_id
	END
ELSE
	BEGIN
	UPDATE t
	SET last_updated = getdate()
	FROM c_observation_tree as t
		JOIN inserted as i
			ON t.branch_id = i.branch_id
	END
