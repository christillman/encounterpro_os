
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_Get_Child_Auto_Perform_Service]
Print 'Drop Procedure [dbo].[sp_Get_Child_Auto_Perform_Service]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_Get_Child_Auto_Perform_Service]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_Get_Child_Auto_Perform_Service]
GO

-- Create Procedure [dbo].[sp_Get_Child_Auto_Perform_Service]
Print 'Create Procedure [dbo].[sp_Get_Child_Auto_Perform_Service]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_Get_Child_Auto_Perform_Service
	 @pl_patient_workplan_item_id int
	,@ps_user_id varchar(24)
	,@pl_next_patient_workplan_item_id int OUTPUT
AS

DECLARE  @ls_in_office_flag char(1)
	,@li_iteration smallint
	,@li_more_records smallint
	,@ls_cpr_id varchar(12)
	,@ll_encounter_id int
	,@rows int
	,@ll_patient_workplan_id int

DECLARE @tmp_items TABLE  -- Altered to use table variable instead of temp table
(
	 patient_workplan_item_id int NOT NULL
	,in_office_flag CHAR(1)
	,item_type VARCHAR(12)
	,auto_perform_flag CHAR (1)
	,owned_by_item VARCHAR (24)
	,owned_by_role VARCHAR (24)
	,patient_workplan_item_id_lock INT
	,status VARCHAR (12)
	,iteration smallint DEFAULT (0)
)

SELECT	 @ls_in_office_flag = in_office_flag
	,@ls_cpr_id = cpr_id
	,@ll_encounter_id = encounter_id
	,@ll_patient_workplan_id = patient_workplan_id
FROM 	p_Patient_WP_Item WITH (NOLOCK)
WHERE	patient_workplan_item_id = @pl_patient_workplan_item_id

IF @ll_patient_workplan_id IS NULL
	RETURN

-- If the associated encounter is open then look for in office items even if this service is not-in-office
-- Changed "IF" to only execute query if @ls_in_office_flag <> 'Y'

IF @ls_in_office_flag <> 'Y'
BEGIN
	SELECT 
		 @ls_in_office_flag = 'Y'
	FROM 	p_Patient_encounter WITH (NOLOCK)
	WHERE	cpr_id = @ls_cpr_id
	AND	encounter_id = @ll_encounter_id
	AND	encounter_status = 'OPEN'
END

INSERT INTO @tmp_items 
(
	 patient_workplan_item_id
	,in_office_flag
)
VALUES
(
	 @pl_patient_workplan_item_id
	,@ls_in_office_flag
)

/* Modify looping to increment an iteration variable instead of executing a "processed" UPDATE
and DELETE during each loop
*/

SET @li_more_records = 1
SET @li_iteration = 0
SET @pl_next_patient_workplan_item_id = NULL

WHILE @li_more_records = 1
BEGIN
	SET @li_iteration = @li_iteration + 1

/*  Using outer join to pull back additional fields.  This allows the subsequent select to avoid
using any joins including a NOT EXISTS and a SELECT subquery.  
*/

	INSERT INTO @tmp_items 
	(	 patient_workplan_item_id
		,in_office_flag
		,item_type
		,auto_perform_flag
		,owned_by_item
		,owned_by_role
		,patient_workplan_item_id_lock
		,status
		,iteration
	)
	SELECT	 i.patient_workplan_item_id
		,i.in_office_flag	
		,i.item_type
		,i.auto_perform_flag	
		,i.owned_by
		,r.user_id
		,l.patient_workplan_item_id
		,i.status
		,@li_iteration
	FROM 	@tmp_items x
	INNER JOIN p_Patient_WP w WITH (NOLOCK)
	ON	w.parent_patient_workplan_item_id = x.patient_workplan_item_id
	INNER JOIN p_Patient_WP_item i WITH (NOLOCK)
	ON	i.patient_workplan_id = w.patient_workplan_id
	AND	i.in_office_flag = w.in_office_flag
	LEFT OUTER JOIN c_user_role r WITH (NOLOCK)
	ON	i.owned_by = r.role_id
	LEFT OUTER JOIN o_User_Service_Lock l WITH (NOLOCK)
	ON	i.patient_workplan_item_id = l.patient_workplan_item_id 
	WHERE	x.iteration = @li_iteration - 1
	AND 	w.in_office_flag = @ls_in_office_flag
	AND 	i.in_office_flag = @ls_in_office_flag
	AND 	i.status IN ('DISPATCHED', 'STARTED')

	SET @rows = @@rowcount

	IF @rows > 0  -- Candidates exist - else skip query
	BEGIN

		SELECT 
			 @pl_next_patient_workplan_item_id = min(patient_workplan_item_id)
		FROM 	@tmp_items
		WHERE   item_type = 'Service'
		AND 	status IN ('DISPATCHED', 'STARTED')
		AND 	auto_perform_flag = 'Y'
		AND 	patient_workplan_item_id_lock IS NULL
		AND 	iteration = @li_iteration
		AND
		(	   owned_by_item IS NULL
			OR owned_by_item = @ps_user_id
			OR owned_by_role = @ps_user_id
		)
		
		IF @pl_next_patient_workplan_item_id IS NOT NULL
			SET @li_more_records = 0 -- End while and return value
	END
	ELSE  -- no Candiate records - Return
		SET @li_more_records = 0
END


GO
GRANT EXECUTE
	ON [dbo].[sp_Get_Child_Auto_Perform_Service]
	TO [cprsystem]
GO

