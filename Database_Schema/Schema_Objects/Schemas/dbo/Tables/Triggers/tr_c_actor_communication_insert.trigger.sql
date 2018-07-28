CREATE TRIGGER tr_c_actor_communication_insert ON dbo.c_actor_communication
FOR INSERT
AS

UPDATE c
SET c_actor_id = u.id
FROM c_Actor_Communication c
	INNER JOIN inserted i
	ON c.actor_id = i.actor_id
	AND c.communication_sequence = i.communication_sequence
	INNER JOIN c_User u
	ON c.actor_id = u.actor_id
WHERE c.c_actor_id IS NULL

UPDATE c
SET status = 'NA'
FROM c_Actor_Communication c
	INNER JOIN inserted i
	ON c.actor_id = i.actor_id
	AND c.communication_type = i.communication_type
	AND c.communication_name = i.communication_name
WHERE c.communication_sequence < i.communication_sequence
AND c.status = 'OK'

