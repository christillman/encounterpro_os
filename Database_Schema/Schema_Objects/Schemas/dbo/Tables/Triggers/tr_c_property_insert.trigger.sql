CREATE TRIGGER tr_c_property_insert ON dbo.c_property
FOR INSERT
AS

UPDATE c_property
SET owner_id = c_Database_Status.customer_id
FROM c_property
	INNER JOIN inserted
	ON c_property.property_id = inserted.property_id
	CROSS JOIN c_Database_Status
WHERE inserted.owner_id = -1

UPDATE p
SET epro_object = COALESCE(p.epro_object, p.property_object),
	property_name = COALESCE(p.property_name, p.function_name)
FROM c_property p
	INNER JOIN inserted i
	ON p.property_id = i.property_id

