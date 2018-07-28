CREATE TRIGGER tr_c_actor_address_all ON dbo.c_Actor_Address
FOR INSERT, UPDATE
AS

-----------------------------------------------------------------------------
-- Update the consultant records which match this user record
-----------------------------------------------------------------------------
UPDATE c
SET address1 = i.address_line_1
FROM c_Consultant c
	INNER JOIN c_User u
	ON c.consultant_id = u.user_id
	INNER JOIN inserted i
	ON i.actor_id = u.actor_id
WHERE i.description = 'Address'
AND ISNULL(c.address1, '!NULL') <> ISNULL(i.address_line_1, '!NULL')
AND i.status = 'OK'

UPDATE c
SET address2 = i.address_line_2
FROM c_Consultant c
	INNER JOIN c_User u
	ON c.consultant_id = u.user_id
	INNER JOIN inserted i
	ON i.actor_id = u.actor_id
WHERE i.description = 'Address'
AND ISNULL(c.address2, '!NULL') <> ISNULL(i.address_line_2, '!NULL')
AND i.status = 'OK'

UPDATE c
SET city = i.city
FROM c_Consultant c
	INNER JOIN c_User u
	ON c.consultant_id = u.user_id
	INNER JOIN inserted i
	ON i.actor_id = u.actor_id
WHERE i.description = 'Address'
AND ISNULL(c.city, '!NULL') <> ISNULL(i.city, '!NULL')
AND i.status = 'OK'

UPDATE c
SET state = i.state
FROM c_Consultant c
	INNER JOIN c_User u
	ON c.consultant_id = u.user_id
	INNER JOIN inserted i
	ON i.actor_id = u.actor_id
WHERE i.description = 'Address'
AND ISNULL(c.state, '!NULL') <> ISNULL(i.state, '!NULL')
AND i.status = 'OK'

UPDATE c
SET zip = i.zip
FROM c_Consultant c
	INNER JOIN c_User u
	ON c.consultant_id = u.user_id
	INNER JOIN inserted i
	ON i.actor_id = u.actor_id
WHERE i.description = 'Address'
AND ISNULL(c.zip, '!NULL') <> ISNULL(i.zip, '!NULL')
AND i.status = 'OK'

-----------------------------------------------------------------------------
-- Update the authority records which match this user record
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
	CROSS JOIN c_Database_Status s
WHERE p.progress_type = 'ID'
AND p.progress_key = @ls_progress_key
AND p.current_flag = 'Y'

UPDATE a
SET authority_address_line_1 = i.address_line_1
FROM c_Authority a
	INNER JOIN @authorities x
	ON a.authority_id = x.authority_id
	INNER JOIN inserted i
	ON i.actor_id = x.actor_id
WHERE i.description = 'Address'
AND ISNULL(a.authority_address_line_1, '!NULL') <> ISNULL(i.address_line_1, '!NULL')
AND i.status = 'OK'

UPDATE a
SET authority_address_line_2 = i.address_line_2
FROM c_Authority a
	INNER JOIN @authorities x
	ON a.authority_id = x.authority_id
	INNER JOIN inserted i
	ON i.actor_id = x.actor_id
WHERE i.description = 'Address'
AND ISNULL(a.authority_address_line_2, '!NULL') <> ISNULL(i.address_line_2, '!NULL')
AND i.status = 'OK'

UPDATE a
SET authority_city = i.city
FROM c_Authority a
	INNER JOIN @authorities x
	ON a.authority_id = x.authority_id
	INNER JOIN inserted i
	ON i.actor_id = x.actor_id
WHERE i.description = 'Address'
AND ISNULL(a.authority_city, '!NULL') <> ISNULL(i.city, '!NULL')
AND i.status = 'OK'

UPDATE a
SET authority_state = i.state
FROM c_Authority a
	INNER JOIN @authorities x
	ON a.authority_id = x.authority_id
	INNER JOIN inserted i
	ON i.actor_id = x.actor_id
WHERE i.description = 'Address'
AND ISNULL(a.authority_state, '!NULL') <> ISNULL(i.state, '!NULL')
AND i.status = 'OK'

UPDATE a
SET authority_zip = i.zip
FROM c_Authority a
	INNER JOIN @authorities x
	ON a.authority_id = x.authority_id
	INNER JOIN inserted i
	ON i.actor_id = x.actor_id
WHERE i.description = 'Address'
AND ISNULL(a.authority_zip, '!NULL') <> ISNULL(i.zip, '!NULL')
AND i.status = 'OK'

-----------------------------------------------------------------------------
-- Update the office records which match this user record
-----------------------------------------------------------------------------
UPDATE o
SET address1 = i.address_line_1
FROM c_Office o
	INNER JOIN c_User u
	ON o.office_id = u.office_id
	INNER JOIN inserted i
	ON i.actor_id = u.actor_id
WHERE i.description = 'Address'
AND u.actor_class = 'Office'
AND ISNULL(o.address1, '!NULL') <> ISNULL(i.address_line_1, '!NULL')
AND i.status = 'OK'

UPDATE o
SET address2 = i.address_line_2
FROM c_Office o
	INNER JOIN c_User u
	ON o.office_id = u.office_id
	INNER JOIN inserted i
	ON i.actor_id = u.actor_id
WHERE i.description = 'Address'
AND u.actor_class = 'Office'
AND ISNULL(o.address2, '!NULL') <> ISNULL(i.address_line_2, '!NULL')
AND i.status = 'OK'

UPDATE o
SET city = i.city
FROM c_Office o
	INNER JOIN c_User u
	ON o.office_id = u.office_id
	INNER JOIN inserted i
	ON i.actor_id = u.actor_id
WHERE i.description = 'Address'
AND u.actor_class = 'Office'
AND ISNULL(o.city, '!NULL') <> ISNULL(i.city, '!NULL')
AND i.status = 'OK'

UPDATE o
SET state = i.state
FROM c_Office o
	INNER JOIN c_User u
	ON o.office_id = u.office_id
	INNER JOIN inserted i
	ON i.actor_id = u.actor_id
WHERE i.description = 'Address'
AND u.actor_class = 'Office'
AND ISNULL(o.state, '!NULL') <> ISNULL(i.state, '!NULL')
AND i.status = 'OK'

UPDATE o
SET zip = CAST(i.zip AS varchar(5))
FROM c_Office o
	INNER JOIN c_User u
	ON o.office_id = u.office_id
	INNER JOIN inserted i
	ON i.actor_id = u.actor_id
WHERE i.description = 'Address'
AND u.actor_class = 'Office'
AND ISNULL(o.zip, '!NULL') <> ISNULL(CAST(i.zip AS varchar(5)), '!NULL')
AND i.status = 'OK'

UPDATE o
SET zip_plus4 = SUBSTRING(i.zip, 6, 4)
FROM c_Office o
	INNER JOIN c_User u
	ON o.office_id = u.office_id
	INNER JOIN inserted i
	ON i.actor_id = u.actor_id
WHERE i.description = 'Address'
AND u.actor_class = 'Office'
AND ISNULL(o.zip_plus4, '!NULL') <> ISNULL(SUBSTRING(i.zip, 6, 4), '!NULL')
AND i.status = 'OK'


