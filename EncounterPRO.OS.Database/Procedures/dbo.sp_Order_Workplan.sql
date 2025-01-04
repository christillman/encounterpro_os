
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_Order_Workplan]
Print 'Drop Procedure [dbo].[sp_Order_Workplan]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_Order_Workplan]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_Order_Workplan]
GO

-- Create Procedure [dbo].[sp_Order_Workplan]
Print 'Create Procedure [dbo].[sp_Order_Workplan]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE sp_Order_Workplan
(	 @ps_cpr_id varchar(12)
	,@pl_workplan_id int = NULL
	,@pl_encounter_id int = NULL
	,@pl_problem_id int = NULL
	,@pl_treatment_id int = NULL
	,@pl_observation_sequence int = NULL
	,@pl_attachment_id int = NULL
	,@ps_description varchar(80) = NULL
	,@ps_ordered_by varchar(24)
	,@ps_ordered_for varchar(24) = NULL
	,@ps_in_office_flag char(1) = NULL
	,@ps_mode varchar(32) = NULL
	,@pl_parent_patient_workplan_item_id int = NULL
	,@ps_created_by varchar(24)
	,@ps_dispatch_flag char(1) = 'Y'
	,@pl_patient_workplan_id int OUTPUT
)
AS

DECLARE  @ls_workplan_type varchar(12)
	,@ls_in_office_flag char(1)
	,@ls_wp_description varchar(80)
	,@ll_patient_workplan_item_id int
	,@li_first_step_number smallint
	,@ls_wp_token varchar(32)
	,@ls_assessment_id varchar(24)
	,@ls_procedure_id varchar(24)
	,@ls_owned_by varchar(24)
	,@ll_parent_patient_workplan_id int
	,@ls_encounter_status varchar(8)
	,@ll_actual_workplan_id int
	,@ll_id uniqueidentifier
	,@ll_actor_id int
	,@ls_dispatch_method varchar(24)

DECLARE @t_wp_item TABLE
(	 item_number INT NOT NULL
	,step_number SMALLINT NOT NULL
	,item_type VARCHAR(12) NOT NULL
	,ordered_service VARCHAR(24) NULL
	,item_in_office_flag CHAR(1) NULL
	,ordered_treatment_type  VARCHAR(24) NULL
	,ordered_workplan_id INT NULL
	,followup_workplan_id INT NULL
	,ordered_for VARCHAR(24) NULL
	,priority SMALLINT NULL
	,step_flag CHAR(1) NULL
	,auto_perform_flag CHAR(1) NULL
	,cancel_workplan_flag CHAR(1) NULL
	,consolidate_flag CHAR(1) NULL
	,owner_flag CHAR(1) NULL
	,runtime_configured_flag CHAR(1) NULL
	,observation_tag VARCHAR(12) NULL
	,description VARCHAR(80) NULL
	,sort_sequence SMALLINT NULL
)

SELECT @ll_actor_id = actor_id
FROM c_User
WHERE [user_id] = @ps_ordered_by


SET @ls_wp_token = '%WP%'


IF (@pl_workplan_id IS NULL) OR (@pl_workplan_id = 0)
BEGIN
	SET @ls_workplan_type = CASE
					WHEN 
						@pl_treatment_id IS NULL THEN 'Patient'
					ELSE 	'Treatment'
				END
	SET @ls_wp_description = COALESCE(@ps_description, 'Custom Workplan')
	SET @ls_in_office_flag = COALESCE(@ps_in_office_flag, 'N')
	SET @ls_assessment_id = NULL
	SET @ls_procedure_id = NULL
	SET @pl_workplan_id = 0
END
ELSE
BEGIN
	-- First decide which workplan we should actually order based on the id field
	-- and which workplan with this id is enabled.
	SELECT @ll_id = id
	FROM c_Workplan WITH (NOLOCK)
	WHERE workplan_id = @pl_workplan_id

	IF @ll_id IS NULL
	BEGIN
		RAISERROR ('Workplan not found (%d)',16,-1, @pl_workplan_id)
		ROLLBACK TRANSACTION
		RETURN
	END

	SELECT @ll_actual_workplan_id = max(workplan_id)
	FROM c_Workplan WITH (NOLOCK)
	WHERE id = @ll_id
	AND STATUS = 'OK'
	IF @ll_actual_workplan_id IS NOT NULL
		SET @pl_workplan_id = @ll_actual_workplan_id
	
	SELECT @ls_workplan_type = workplan_type,
		@ls_wp_description = COALESCE(@ps_description, description),
		@ls_in_office_flag = 	CASE @ps_in_office_flag 
						WHEN 	'N' THEN 'N' 
						ELSE 	in_office_flag
					END,
		@ls_assessment_id = assessment_id,
		@ls_procedure_id = procedure_id
	FROM c_Workplan WITH (NOLOCK)
	WHERE workplan_id = @pl_workplan_id

	IF @ls_workplan_type IS NULL
	BEGIN
		RAISERROR ('Workplan not found (%d)',16,-1, @pl_workplan_id)
		ROLLBACK TRANSACTION
		RETURN
	END
END

IF @pl_problem_id IS NULL AND @ls_assessment_id IS NOT NULL
	EXECUTE sp_order_assessment
		@ps_cpr_id = @ps_cpr_id,
		@pl_encounter_id = @pl_encounter_id,
		@ps_assessment_id = @ls_assessment_id,
		@ps_diagnosed_by = @ps_ordered_by,
		@ps_created_by = @ps_created_by,
		@pl_problem_id = @pl_problem_id OUTPUT

-- Determine the owned_by value
IF @pl_parent_patient_workplan_item_id IS NULL
	BEGIN
	SET @ll_parent_patient_workplan_id = NULL
	SET @ls_dispatch_method = NULL
	END
ELSE
	SELECT @ll_parent_patient_workplan_id = patient_workplan_id,
			@ls_dispatch_method = dispatch_method
	FROM p_Patient_WP_Item WITH (NOLOCK)
	WHERE patient_workplan_item_id = @pl_parent_patient_workplan_item_id

SET @ls_owned_by = dbo.fn_workplan_item_owned_by_2
	(	 @ps_ordered_for
		,@ll_parent_patient_workplan_id
		,@ps_cpr_id
		,@pl_encounter_id
		,@ps_ordered_by
		,@ls_dispatch_method
	)

SELECT @ls_encounter_status = encounter_status
FROM p_Patient_Encounter WITH (NOLOCK)
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id

IF @ls_encounter_status IS NULL
	SET @ls_encounter_status = 'NA'

-- If the in_office_flag is 'E', then set it to 'Y' if the associated encounter is still open
-- Otherwise, set the in_office_flag = 'N'
IF @ls_in_office_flag = 'E'
BEGIN
	IF @ls_encounter_status = 'OPEN'
		SET @ls_in_office_flag = 'Y'
	ELSE
		SET @ls_in_office_flag = 'N'
END

-- If the in_office_flag is 'Y' then see if we have an open encounter
IF @ls_in_office_flag = 'Y'
BEGIN
	IF (@pl_encounter_id IS NULL) OR (@ps_cpr_id IS NULL)
	BEGIN
		RAISERROR 
		(	 'In office workplan must have encounter_id (%d)'
			,16
			,-1
			,@pl_workplan_id
		)
		ROLLBACK TRANSACTION
		RETURN
	END
	
	IF @ls_encounter_status = 'NA'
	BEGIN
		RAISERROR ('Encounter not found (%s,%d)',16,-1, @ps_cpr_id, @pl_encounter_id)
		ROLLBACK TRANSACTION
		RETURN
	END
	
	-- If the encounter is closed then reopen it
	IF @ls_encounter_status = 'CLOSED'
	BEGIN
		EXECUTE sp_Set_Encounter_Progress
			@ps_cpr_id = @ps_cpr_id,
			@pl_encounter_id = @pl_encounter_id,
			@pl_attachment_id = NULL,
			@ps_progress_type = 'ReOpen',
			@ps_progress_key = NULL,
			@ps_progress = NULL,
			@pdt_progress_date_time = NULL,
			@pl_patient_workplan_item_id = @pl_parent_patient_workplan_item_id,
			@pl_risk_level = NULL,
			@ps_user_id = @ps_ordered_by,
			@ps_created_by = @ps_created_by
	END
END


/*
	Create temp table of all WP_items.  Message in_office_flag and description.
	Then bulk insert WP items and attributes into patient tables.
*/

IF @pl_workplan_id <> 0
BEGIN
	INSERT INTO @t_wp_item
	(	 item_number
		,step_number
		,item_type
		,ordered_service
		,item_in_office_flag
		,ordered_treatment_type
		,ordered_workplan_id
		,followup_workplan_id
		,ordered_for
		,priority
		,step_flag
		,auto_perform_flag
		,cancel_workplan_flag
		,consolidate_flag
		,owner_flag
		,runtime_configured_flag
		,observation_tag
		,description
		,sort_sequence
	)
	SELECT	 item_number
		,step_number
		,item_type
		,ordered_service
		,in_office_flag
		,ordered_treatment_type
		,ordered_workplan_id
		,followup_workplan_id
		,ordered_for
		,priority
		,step_flag
		,auto_perform_flag
		,cancel_workplan_flag
		,consolidate_flag
		,owner_flag
		,runtime_configured_flag
		,observation_tag
		,description
		,sort_sequence
	FROM	c_Workplan_Item WITH (NOLOCK)
	WHERE	workplan_id = @pl_workplan_id
	ORDER BY 
		 step_number
		,sort_sequence
	
	
	UPDATE @t_wp_item
	SET	description = 	CAST (
								STUFF
								(		description
									,CHARINDEX(@ls_wp_token, description)
									,DATALENGTH(@ls_wp_token)
									,@ls_wp_description
								) AS varchar(80) )
	WHERE
		CHARINDEX(@ls_wp_token, description) > 0
	
	-- If the workplan in_office_flag is 'N', then all the items must also be 'N'
	IF @ls_in_office_flag = 'N'
		UPDATE @t_wp_item
		SET item_in_office_flag = 'N'
		WHERE item_in_office_flag <> 'N'
	ELSE
		BEGIN
		-- If the workplan in_office_flag is 'Y', then set the item in_office_flag as follows:
		-- item's in_office_flag:
		--		Y = set to 'Y'
		--		N = set to 'N'
		--		W = set to whatever the workplan's in_office_flag is
		--		E = set to 'Y' if the corresponding encounter is still open
		UPDATE @t_wp_item
		SET item_in_office_flag = CASE item_in_office_flag WHEN 'N' THEN 'N'
															WHEN 'Y' THEN 'Y'
															WHEN 'W' THEN @ls_in_office_flag
															WHEN 'E' THEN CASE @ls_encounter_status WHEN 'OPEN' THEN 'Y' ELSE 'N' END
															ELSE @ls_in_office_flag END
		END
END

INSERT INTO p_Patient_WP
(	cpr_id,
	workplan_id,
	workplan_type,
	in_office_flag,
	encounter_id,
	problem_id,
	treatment_id,
	observation_sequence,
	attachment_id,
	description,
	ordered_by,
	owned_by,
	mode,
	parent_patient_workplan_item_id,
	created_by
)
VALUES
(	@ps_cpr_id,
	@pl_workplan_id,
	@ls_workplan_type,
	@ls_in_office_flag,
	@pl_encounter_id,
	@pl_problem_id,
	@pl_treatment_id,
	@pl_observation_sequence,
	@pl_attachment_id,
	@ls_wp_description,
	@ps_ordered_by,
	@ls_owned_by,
	@ps_mode,
	@pl_parent_patient_workplan_item_id,
	@ps_created_by
)

SET @pl_patient_workplan_id = @@IDENTITY

-- If there's no workplan ordered then we're done
IF @pl_workplan_id = 0
	RETURN


INSERT INTO p_Patient_WP_Item
(	 cpr_id
	,patient_workplan_id
	,encounter_id
	,workplan_id
	,item_number
	,step_number
	,item_type
	,ordered_service
	,in_office_flag
	,ordered_treatment_type
	,ordered_workplan_id
	,followup_workplan_id
	,description
	,ordered_by
	,ordered_for
	,priority
	,step_flag
	,auto_perform_flag
	,cancel_workplan_flag
	,consolidate_flag
	,owner_flag
	,runtime_configured_flag
	,observation_tag
	,created_by
)
SELECT
	 @ps_cpr_id
	,@pl_patient_workplan_id
	,@pl_encounter_id
	,@pl_workplan_id
	,item_number
	,step_number
	,item_type
	,ordered_service
	,item_in_office_flag
	,ordered_treatment_type
	,ordered_workplan_id
	,followup_workplan_id
	,description
	,@ps_ordered_by
	,ordered_for
	,priority
	,step_flag
	,auto_perform_flag
	,cancel_workplan_flag
	,consolidate_flag
	,owner_flag
	,runtime_configured_flag
	,observation_tag
	,@ps_created_by
FROM	@t_wp_item
ORDER BY 
	 step_number
	,sort_sequence


DECLARE @t_new_p_item TABLE
(	patient_workplan_item_id int NOT NULL
	,item_number INT NOT NULL
)

INSERT INTO @t_new_p_item (
	patient_workplan_item_id
	,item_number )
SELECT patient_workplan_item_id
	,item_number
FROM p_patient_wp_item wi WITH (INDEX(idx_workplan_item_id))
WHERE patient_workplan_id = @pl_patient_workplan_id


INSERT INTO p_Patient_WP_Item_Attribute
(	 cpr_id
	,patient_workplan_id
	,patient_workplan_item_id
	,attribute
	,value_short
	,message
	,actor_id
	,created_by
)
SELECT		
	 @ps_cpr_id
	,@pl_patient_workplan_id
	,t.patient_workplan_item_id
	,ia.attribute
	,CASE WHEN len(ia.value) <= 50 THEN CAST(ia.value AS varchar(50)) ELSE NULL END
	,CASE WHEN len(ia.value) > 50 THEN ia.value ELSE NULL END
	,@ll_actor_id
	,@ps_created_by
FROM @t_new_p_item t
	INNER LOOP JOIN c_Workplan_Item_Attribute ia WITH (NOLOCK)
	ON	ia.workplan_id = @pl_workplan_id
	AND ia.item_number = t.item_number
ORDER BY t.patient_workplan_item_id



IF @ps_dispatch_flag = 'Y'
BEGIN
	-- Now find the first step
	SELECT @li_first_step_number = min(step_number)
	FROM p_Patient_WP_Item WITH (NOLOCK)
	WHERE cpr_id = @ps_cpr_id
	AND patient_workplan_id = @pl_patient_workplan_id
	AND status IS NULL

	-- If we found a first step, then dispatch it.  If not, then call sp_check_workplan_status to close it.
	IF @li_first_step_number > 0
		BEGIN
		EXECUTE sp_dispatch_workplan_step
			@ps_cpr_id = @ps_cpr_id,
			@pl_patient_workplan_id = @pl_patient_workplan_id,
			@pi_step_number = @li_first_step_number,
			@ps_dispatched_by = @ps_ordered_by,
			@ps_created_by = @ps_created_by
		
		-- If this is an in-office workplan associated with an object, 
		IF @ls_in_office_flag = 'Y' 
			AND @pl_parent_patient_workplan_item_id IS NULL 
			AND @ls_workplan_type IN ('Assessment', 'Treatment', 'Observation', 'Attachment')
				BEGIN
				EXECUTE jmj_add_workplan_to_encounter
					@ps_cpr_id = @ps_cpr_id,
					@pl_encounter_id = @pl_encounter_id,
					@pl_patient_workplan_id = @pl_patient_workplan_id,
					@ps_ordered_by = @ps_ordered_by,
					@ps_created_by = @ps_created_by
				
				END
		END
	ELSE
		EXECUTE sp_check_workplan_status
			@pl_patient_workplan_id = @pl_patient_workplan_id,
			@ps_user_id = @ps_ordered_by,
			@ps_created_by = @ps_created_by
END

GO
GRANT EXECUTE
	ON [dbo].[sp_Order_Workplan]
	TO [cprsystem]
GO

