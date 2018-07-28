CREATE PROCEDURE sp_Get_Next_Auto_Perform_Service
	@pl_patient_workplan_item_id int,
	@ps_user_id varchar(24),
	@pl_next_patient_workplan_item_id int OUTPUT
AS

DECLARE @ll_patient_workplan_item_id int,
	@ls_in_office_flag char(1)

SELECT @pl_next_patient_workplan_item_id = NULL

SELECT @ll_patient_workplan_item_id = @pl_patient_workplan_item_id

SELECT @ls_in_office_flag = in_office_flag
FROM p_Patient_WP_Item
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

IF @@ROWCOUNT <> 1
	RETURN

-- Loop though the parents until we reach the top workplan
WHILE @ll_patient_workplan_item_id IS NOT NULL
	BEGIN
	-- First check for children
	EXECUTE sp_Get_Child_Auto_Perform_Service
		@pl_patient_workplan_item_id = @ll_patient_workplan_item_id,
		@ps_user_id = @ps_user_id,
		@pl_next_patient_workplan_item_id = @pl_next_patient_workplan_item_id OUTPUT

	IF @pl_next_patient_workplan_item_id IS NOT NULL
		BEGIN
		IF @pl_next_patient_workplan_item_id <> @pl_patient_workplan_item_id
		  AND NOT EXISTS (SELECT user_id FROM o_User_Service_Lock
						  WHERE patient_workplan_item_id = @pl_next_patient_workplan_item_id)
			BEGIN
			RETURN
			END
		ELSE
			BEGIN
			SET @pl_next_patient_workplan_item_id = NULL
			END
		END
		

	-- Then check for siblings
	EXECUTE sp_Get_Sibling_Auto_Perform_Service
		@pl_patient_workplan_item_id = @ll_patient_workplan_item_id,
		@ps_user_id = @ps_user_id,
		@pl_next_patient_workplan_item_id = @pl_next_patient_workplan_item_id OUTPUT

	IF @pl_next_patient_workplan_item_id IS NOT NULL
		RETURN

	-- Then keep going up the tree until we don't have another parent
	SELECT @ll_patient_workplan_item_id = w.parent_patient_workplan_item_id
	FROM p_Patient_WP w, p_Patient_WP_Item i
	WHERE w.patient_workplan_id = i.patient_workplan_id
	AND i.patient_workplan_item_id = @ll_patient_workplan_item_id

	END



