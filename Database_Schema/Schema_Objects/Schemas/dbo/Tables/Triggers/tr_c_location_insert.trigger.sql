CREATE TRIGGER tr_c_location_insert ON dbo.c_location
FOR INSERT
AS

UPDATE c_location
SET owner_id = c_Database_Status.customer_id
FROM c_location
	INNER JOIN inserted
	ON c_location.location = inserted.location
	CROSS JOIN c_Database_Status
WHERE inserted.owner_id = -1

