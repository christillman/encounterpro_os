CREATE TRIGGER tr_c_Office_insert ON dbo.c_Office
FOR INSERT
AS


INSERT INTO c_User (
	user_id,
	user_status,
	user_full_name,
	office_id,
	actor_class,
	owner_id)
SELECT '$!!' + CAST(s.customer_id AS varchar(10)) + '|' + o.office_id,
	'Actor',
	CAST(o.description AS varchar(64)),
	o.office_id,
	'Office',
	s.customer_id
FROM inserted o
	CROSS JOIN c_Database_Status s
WHERE '$!!' + CAST(s.customer_id AS varchar(10)) + '|' + o.office_id NOT IN (
	SELECT user_id
	FROM c_User)
AND NOT EXISTS (
	SELECT 1
	FROM c_User u
	WHERE u.actor_class = 'office'
	AND u.office_id = o.office_id
	)


