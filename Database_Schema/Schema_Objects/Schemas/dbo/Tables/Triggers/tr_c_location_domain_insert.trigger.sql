CREATE TRIGGER tr_c_location_domain_insert ON dbo.c_location_domain
FOR INSERT
AS

UPDATE c_location_domain
SET owner_id = c_Database_Status.customer_id
FROM c_location_domain
	INNER JOIN inserted
	ON c_location_domain.location_domain = inserted.location_domain
	AND c_location_domain.owner_id = inserted.owner_id
	CROSS JOIN c_Database_Status
WHERE inserted.owner_id = -1

