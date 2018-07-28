CREATE TRIGGER tr_c_actor_communication_all ON dbo.c_actor_communication
FOR INSERT, UPDATE
AS

-- Update consultant columns
UPDATE c
SET phone = CAST(i.communication_value AS varchar(32))
FROM c_Consultant c
	INNER JOIN c_User u
	ON c.consultant_id = u.user_id
	INNER JOIN inserted i
	ON i.actor_id = u.actor_id
WHERE communication_type = 'Phone'
AND communication_name = 'Phone'
AND ISNULL(c.phone, '!NULL') <> ISNULL(i.communication_value, '!NULL')
AND i.status = 'OK'

UPDATE c
SET phone2 = CAST(i.communication_value AS varchar(32))
FROM c_Consultant c
	INNER JOIN c_User u
	ON c.consultant_id = u.user_id
	INNER JOIN inserted i
	ON i.actor_id = u.actor_id
WHERE communication_type = 'Phone'
AND communication_name = 'Phone2'
AND ISNULL(c.phone2, '!NULL') <> ISNULL(i.communication_value, '!NULL')
AND i.status = 'OK'

UPDATE c
SET fax = CAST(i.communication_value AS varchar(32))
FROM c_Consultant c
	INNER JOIN c_User u
	ON c.consultant_id = u.user_id
	INNER JOIN inserted i
	ON i.actor_id = u.actor_id
WHERE communication_type = 'Fax'
AND communication_name = 'Fax'
AND ISNULL(c.fax, '!NULL') <> ISNULL(i.communication_value, '!NULL')
AND i.status = 'OK'

UPDATE c
SET email = CAST(i.communication_value AS varchar(64))
FROM c_Consultant c
	INNER JOIN c_User u
	ON c.consultant_id = u.user_id
	INNER JOIN inserted i
	ON i.actor_id = u.actor_id
WHERE communication_type = 'Email'
AND communication_name = 'Email'
AND ISNULL(c.email, '!NULL') <> ISNULL(i.communication_value, '!NULL')
AND i.status = 'OK'

-----------------------------------------------------------------------------
-- Update the authority phone number
-----------------------------------------------------------------------------
DECLARE @ls_progress_key varchar(40)

SELECT @ls_progress_key = CASE WHEN customer_id > 0 THEN CAST(customer_id AS varchar(12)) + '^authority_id'
													ELSE 'authority_id' END
FROM c_Database_Status

DECLARE @authorities TABLE (
	user_id varchar(24) NOT NULL,
	actor_id int NOT NULL,
	authority_id varchar(24) NOT NULL)

INSERT INTO @authorities (
	user_id,
	actor_id,
	authority_id)
SELECT u.user_id,
		u.actor_id,
		CAST(p.progress_value AS varchar(24))
FROM inserted i
	INNER JOIN c_User u
	ON i.actor_id = u.actor_id
	INNER JOIN c_User_Progress p
	ON p.user_id = u.user_id
WHERE p.progress_type = 'ID'
AND p.progress_key = @ls_progress_key
AND p.current_flag = 'Y'
AND i.status = 'OK'

UPDATE a
SET authority_phone_number = CAST(i.communication_value AS varchar(16))
FROM c_Authority a
	INNER JOIN @authorities x
	ON a.authority_id = x.authority_id
	INNER JOIN inserted i
	ON i.actor_id = x.actor_id
WHERE i.communication_type = 'Phone'
AND i.communication_name = 'Phone'
AND ISNULL(a.authority_phone_number, '!NULL') <> ISNULL(i.communication_value, '!NULL')
AND i.status = 'OK'

UPDATE u
SET email_address = CAST(i.communication_value AS varchar(64))
FROM c_User u
	INNER JOIN inserted i
	ON i.actor_id = u.actor_id
WHERE i.communication_type = 'Email'
AND i.communication_name = 'Email'
AND ISNULL(u.email_address, '!NULL') <> ISNULL(i.communication_value, '!NULL')
AND i.status = 'OK'


-- Update office columns

UPDATE o
SET phone = CAST(i.communication_value AS varchar(14))
FROM c_Office o
	INNER JOIN c_User u
	ON o.office_id = u.office_id
	INNER JOIN inserted i
	ON i.actor_id = u.actor_id
WHERE i.communication_type = 'Phone'
AND i.communication_name = 'Phone'
AND u.actor_class = 'Office'
AND ISNULL(o.phone, '!NULL') <> ISNULL(i.communication_value, '!NULL')
AND i.status = 'OK'

UPDATE o
SET fax = CAST(i.communication_value AS varchar(14))
FROM c_Office o
	INNER JOIN c_User u
	ON o.office_id = u.office_id
	INNER JOIN inserted i
	ON i.actor_id = u.actor_id
WHERE i.communication_type = 'Fax'
AND i.communication_name = 'Fax'
AND u.actor_class = 'Office'
AND ISNULL(o.fax, '!NULL') <> ISNULL(i.communication_value, '!NULL')
AND i.status = 'OK'


