CREATE TRIGGER tr_c_workplan_insert ON dbo.c_workplan
FOR INSERT
AS

UPDATE c_Workplan
SET owner_id = c_Database_Status.customer_id
FROM c_workplan
	INNER JOIN inserted
	ON c_Workplan.workplan_id = inserted.workplan_id
	CROSS JOIN c_Database_Status
WHERE inserted.owner_id = -1
