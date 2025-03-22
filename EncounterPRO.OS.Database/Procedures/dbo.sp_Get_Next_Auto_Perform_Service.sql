
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_Get_Next_Auto_Perform_Service]
Print 'Drop Procedure [dbo].[sp_Get_Next_Auto_Perform_Service]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_Get_Next_Auto_Perform_Service]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_Get_Next_Auto_Perform_Service]
GO

-- Create Procedure [dbo].[sp_Get_Next_Auto_Perform_Service]
Print 'Create Procedure [dbo].[sp_Get_Next_Auto_Perform_Service]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_Get_Next_Auto_Perform_Service
	@pl_patient_workplan_item_id int,
	@ps_user_id varchar(24),
	@pl_next_patient_workplan_item_id int OUTPUT
AS

DECLARE @ll_patient_workplan_item_id int,
	@ls_in_office_flag char(1),
	@ll_workplan_id int

SELECT @pl_next_patient_workplan_item_id = NULL

SELECT @ll_patient_workplan_item_id = @pl_patient_workplan_item_id

SELECT @ls_in_office_flag = in_office_flag, @ll_workplan_id = workplan_id
FROM p_Patient_WP_Item
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

IF @ll_workplan_id IS NULL
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
		  AND NOT EXISTS (SELECT [user_id] FROM o_User_Service_Lock
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
	FROM p_Patient_WP w
	JOIN p_Patient_WP_Item i ON w.patient_workplan_id = i.patient_workplan_id
	WHERE i.patient_workplan_item_id = @ll_patient_workplan_item_id

	END



GO
GRANT EXECUTE
	ON [dbo].[sp_Get_Next_Auto_Perform_Service]
	TO [cprsystem]
GO

