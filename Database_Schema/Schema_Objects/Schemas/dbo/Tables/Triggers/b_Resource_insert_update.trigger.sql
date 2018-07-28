CREATE TRIGGER b_Resource_insert_update ON b_Resource
FOR
	 INSERT
	,UPDATE
AS

-- Make sure the user_id is valid
IF EXISTS (SELECT 1
		FROM inserted
		WHERE user_id NOT IN (SELECT user_id FROM c_User)
		AND user_id NOT IN (SELECT role_id FROM c_Role) )
	BEGIN
		RAISERROR ( 'Invalid User ID', 16, 1 )
		ROLLBACK TRAN
	END

-- Make sure the case matches the actual key
UPDATE b
SET user_id = u.user_id
FROM b_Resource b
	INNER JOIN inserted i
	ON b.resource = i.resource
	AND b.resource_sequence = i.resource_sequence
	INNER JOIN c_User u
	ON b.user_id = u.user_id

UPDATE b
SET user_id = r.role_id
FROM b_Resource b
	INNER JOIN inserted i
	ON b.resource = i.resource
	AND b.resource_sequence = i.resource_sequence
	INNER JOIN c_Role r
	ON b.user_id = r.role_id

