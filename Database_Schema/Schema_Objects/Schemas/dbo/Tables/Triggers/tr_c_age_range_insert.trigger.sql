CREATE TRIGGER tr_c_age_range_insert ON dbo.c_Age_Range
FOR INSERT
AS

UPDATE c_age_range
SET owner_id = c_Database_Status.customer_id
FROM c_age_range
	INNER JOIN inserted
	ON c_age_range.age_range_id = inserted.age_range_id
	CROSS JOIN c_Database_Status
WHERE inserted.owner_id = -1

