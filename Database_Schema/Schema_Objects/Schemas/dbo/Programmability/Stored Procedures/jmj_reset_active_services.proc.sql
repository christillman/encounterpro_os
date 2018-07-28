CREATE PROCEDURE jmj_reset_active_services 

AS

-- Don't do anything prior to mod level 127
IF (SELECT modification_level FROM c_Database_Status) <= 126
	RETURN

-- Remove all active services
DELETE
FROM o_Active_Services

-- Go through each active service and reset its o_Active_Service record
DECLARE @ll_patient_workplan_item_id int

DECLARE lc_active_service CURSOR LOCAL FAST_FORWARD FOR
	SELECT patient_workplan_item_id
	FROM p_Patient_WP_Item
	WHERE active_service_flag = 'Y'

OPEN lc_active_service

FETCH lc_active_service INTO @ll_patient_workplan_item_id

WHILE @@FETCH_STATUS = 0
	BEGIN
	EXECUTE jmj_set_active_service
		@pl_patient_workplan_item_id = @ll_patient_workplan_item_id

	FETCH lc_active_service INTO @ll_patient_workplan_item_id
	END

CLOSE lc_active_service
DEALLOCATE lc_active_service

