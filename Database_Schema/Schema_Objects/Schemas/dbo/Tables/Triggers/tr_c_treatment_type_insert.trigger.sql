CREATE TRIGGER tr_c_treatment_type_insert ON dbo.c_treatment_type
FOR INSERT
AS

UPDATE c_treatment_type
SET owner_id = c_Database_Status.customer_id
FROM c_treatment_type
	INNER JOIN inserted
	ON c_treatment_type.treatment_type = inserted.treatment_type
	CROSS JOIN c_Database_Status
WHERE inserted.owner_id = -1

