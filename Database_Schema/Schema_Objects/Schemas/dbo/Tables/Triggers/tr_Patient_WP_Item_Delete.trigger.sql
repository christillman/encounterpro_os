CREATE TRIGGER tr_Patient_WP_Item_Delete ON p_Patient_WP_Item
FOR DELETE 
AS

DELETE p_Patient_WP_Item_Attribute
FROM deleted
WHERE p_Patient_WP_Item_Attribute.cpr_id = deleted.cpr_id
AND p_Patient_WP_Item_Attribute.patient_workplan_id = deleted.patient_workplan_id
AND p_Patient_WP_Item_Attribute.patient_workplan_item_id = deleted.patient_workplan_item_id

DELETE p_Patient_WP_Item_Progress
FROM deleted
WHERE p_Patient_WP_Item_Progress.cpr_id = deleted.cpr_id
AND p_Patient_WP_Item_Progress.patient_workplan_id = deleted.patient_workplan_id
AND p_Patient_WP_Item_Progress.patient_workplan_item_id = deleted.patient_workplan_item_id

DELETE o_Active_Services
FROM deleted
WHERE o_Active_Services.patient_workplan_item_id = deleted.patient_workplan_item_id

