CREATE TRIGGER tr_c_age_range_category_insert ON dbo.c_age_range_category
FOR INSERT
AS

UPDATE c_age_range_category
SET owner_id = c_Database_Status.customer_id
FROM c_age_range_category
	INNER JOIN inserted
	ON c_age_range_category.age_range_category = inserted.age_range_category
	AND c_age_range_category.owner_id = inserted.owner_id
	CROSS JOIN c_Database_Status
WHERE inserted.owner_id = -1

