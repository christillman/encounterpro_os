CREATE TRIGGER tr_c_chart_insert ON dbo.c_chart
FOR INSERT
AS

UPDATE c_chart
SET owner_id = c_Database_Status.customer_id
FROM c_chart
	INNER JOIN inserted
	ON c_chart.chart_id = inserted.chart_id
	CROSS JOIN c_Database_Status
WHERE inserted.owner_id = -1

