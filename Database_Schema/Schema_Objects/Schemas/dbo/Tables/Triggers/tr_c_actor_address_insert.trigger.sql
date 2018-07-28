CREATE TRIGGER tr_c_actor_address_insert ON dbo.c_actor_address
FOR INSERT
AS

UPDATE a
SET c_actor_id = u.id
FROM c_Actor_Address a
	INNER JOIN inserted i
	ON a.actor_id = i.actor_id
	AND a.address_sequence = i.address_sequence
	INNER JOIN c_User u
	ON a.actor_id = u.actor_id
WHERE a.c_actor_id IS NULL


UPDATE a
SET status = 'NA'
FROM c_Actor_Address a
	INNER JOIN inserted i
	ON a.actor_id = i.actor_id
	AND a.description = i.description
WHERE a.address_sequence < i.address_sequence
AND a.status = 'OK'

