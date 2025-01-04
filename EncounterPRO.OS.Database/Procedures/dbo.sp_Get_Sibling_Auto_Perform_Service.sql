
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_Get_Sibling_Auto_Perform_Service]
Print 'Drop Procedure [dbo].[sp_Get_Sibling_Auto_Perform_Service]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_Get_Sibling_Auto_Perform_Service]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_Get_Sibling_Auto_Perform_Service]
GO

-- Create Procedure [dbo].[sp_Get_Sibling_Auto_Perform_Service]
Print 'Create Procedure [dbo].[sp_Get_Sibling_Auto_Perform_Service]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE sp_Get_Sibling_Auto_Perform_Service
	 @pl_patient_workplan_item_id int
	,@ps_user_id varchar(24)
	,@pl_next_patient_workplan_item_id int OUTPUT
AS

DECLARE	 @ls_in_office_flag char(1)
	,@li_count smallint
	,@ll_patient_workplan_id int
	,@ll_patient_workplan_item_id int
	,@ls_item_type varchar(12)

SET @pl_next_patient_workplan_item_id = NULL

SELECT	@ls_in_office_flag = in_office_flag,
		@ll_patient_workplan_id = patient_workplan_id
FROM 	p_Patient_WP_Item WITH (NOLOCK)
WHERE 	patient_workplan_item_id = @pl_patient_workplan_item_id

IF @ll_patient_workplan_id IS NULL
	RETURN

-- If this is the "default" workplan, then don't check
IF @ll_patient_workplan_id = 0
	RETURN

DECLARE lc_siblings CURSOR LOCAL FAST_FORWARD TYPE_WARNING FOR
	SELECT
		 i2.patient_workplan_item_id
		,i2.item_type
	FROM	p_Patient_WP_Item i2 WITH (NOLOCK)
	LEFT OUTER JOIN c_user_role r WITH (NOLOCK)
	ON 	i2.owned_by = r.role_id
	LEFT OUTER JOIN o_User_Service_Lock l WITH (NOLOCK)
	ON 	i2.patient_workplan_item_id = l.patient_workplan_item_id 
	WHERE i2.patient_workplan_id = @ll_patient_workplan_id
	AND 	i2.patient_workplan_item_id <> @pl_patient_workplan_item_id
	AND 	i2.auto_perform_flag = 'Y'
	AND 	i2.in_office_flag = @ls_in_office_flag
	AND 	i2.status IN ('DISPATCHED', 'STARTED')
	AND 	l.patient_workplan_item_id IS NULL
	AND
	(	   i2.owned_by IS NULL
		OR i2.owned_by = @ps_user_id
		OR r.user_id = @ps_user_id
	)
	ORDER BY i2.patient_workplan_item_id

OPEN lc_siblings

FETCH lc_siblings INTO 
	 @ll_patient_workplan_item_id
	,@ls_item_type

WHILE @@FETCH_STATUS = 0
BEGIN

	-- If the sibling is an auto perform service, then we're done
	IF @ls_item_type = 'Service'
	BEGIN
		SET @pl_next_patient_workplan_item_id = @ll_patient_workplan_item_id
		RETURN
	END

	-- If the item wasn't a service, then check it's children for auto-perform services
	EXECUTE sp_Get_Child_Auto_Perform_Service
		 @pl_patient_workplan_item_id = @ll_patient_workplan_item_id
		,@ps_user_id = @ps_user_id
		,@pl_next_patient_workplan_item_id = @pl_next_patient_workplan_item_id OUTPUT

	IF @pl_next_patient_workplan_item_id IS NOT NULL
		RETURN
	
	-- If we still haven't found one, then get the next sibling
	FETCH lc_siblings INTO 
		 @ll_patient_workplan_item_id
		,@ls_item_type
END

CLOSE lc_siblings
DEALLOCATE lc_siblings


GO
GRANT EXECUTE
	ON [dbo].[sp_Get_Sibling_Auto_Perform_Service]
	TO [cprsystem]
GO

