CREATE TRIGGER tr_c_specialty_insert ON dbo.c_specialty
FOR INSERT
AS

UPDATE c_specialty
SET owner_id = c_Database_Status.customer_id
FROM c_specialty
	INNER JOIN inserted
	ON c_specialty.specialty_id = inserted.specialty_id
	CROSS JOIN c_Database_Status
WHERE inserted.owner_id = -1

