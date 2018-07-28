CREATE TRIGGER tr_Patient_WP_Delete ON dbo.p_Patient_WP
FOR DELETE 
AS

DELETE p_Patient_WP_Item
FROM deleted
WHERE p_Patient_WP_Item.cpr_id = deleted.cpr_id
AND p_Patient_WP_Item.patient_workplan_id = deleted.patient_workplan_id

