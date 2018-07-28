CREATE TRIGGER tr_c_Actor_Route_Purpose_insert ON dbo.c_Actor_Route_Purpose
FOR INSERT
AS

UPDATE c
SET c_actor_id = u.id
FROM c_Actor_Route_Purpose c
	INNER JOIN inserted i
	ON c.actor_id = i.actor_id
	AND c.route_purpose_sequence = i.route_purpose_sequence
	INNER JOIN c_User u
	ON c.actor_id = u.actor_id
WHERE c.c_actor_id IS NULL

UPDATE c
SET current_flag = 'N'
FROM c_Actor_Route_Purpose c
	INNER JOIN inserted i
	ON c.actor_id = i.actor_id
	AND c.document_route = i.document_route
	AND c.purpose = i.purpose
WHERE c.route_purpose_sequence < i.route_purpose_sequence
AND c.current_flag = 'Y'

