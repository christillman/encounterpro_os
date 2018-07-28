CREATE TRIGGER tr_c_Classification_Set_insert ON dbo.c_Classification_Set
FOR INSERT
AS

UPDATE c_Classification_Set
SET owner_id = c_Database_Status.customer_id
FROM c_Classification_Set
	INNER JOIN inserted
	ON c_Classification_Set.classification_set_id = inserted.classification_set_id
	CROSS JOIN c_Database_Status
WHERE inserted.owner_id = -1

