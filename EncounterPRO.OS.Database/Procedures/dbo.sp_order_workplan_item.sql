
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_order_workplan_item]
Print 'Drop Procedure [dbo].[sp_order_workplan_item]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_order_workplan_item]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_order_workplan_item]
GO

-- Create Procedure [dbo].[sp_order_workplan_item]
Print 'Create Procedure [dbo].[sp_order_workplan_item]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_order_workplan_item
	(
	@ps_cpr_id varchar(12),
	@pl_encounter_id int = NULL,
	@pl_patient_workplan_id int,
	@ps_ordered_service varchar(24),
	@ps_in_office_flag char(1) = NULL,
	@ps_auto_perform_flag char(1) = NULL,
	@ps_observation_tag varchar(12) = NULL,
	@ps_description varchar(80) = NULL,
	@ps_ordered_by varchar(24),
	@ps_ordered_for varchar(24) = NULL,
	@pi_step_number smallint = NULL,
	@pi_priority smallint = NULL,
	@ps_created_by varchar(24)
	)
AS

DECLARE @ll_workplan_id int,
	@li_count smallint,
	@ls_status varchar(12),
	@li_last_step_dispatched smallint,
	@ll_patient_workplan_item_id int,
	@ll_error int,
	@ll_rowcount int

-- If we have a workplan then get some defaults from the workplan
IF @pl_patient_workplan_id > 0
	BEGIN
	SELECT @ll_workplan_id = workplan_id,
		@pl_encounter_id = COALESCE(@pl_encounter_id, encounter_id),
		@li_last_step_dispatched = last_step_dispatched,
		@ps_in_office_flag = COALESCE(@ps_in_office_flag, in_office_flag),
		@ps_ordered_for = COALESCE(@ps_ordered_for, owned_by)
	FROM p_Patient_WP
	WHERE patient_workplan_id = @pl_patient_workplan_id

	IF @@ERROR <> 0
		RETURN -1
	END
ELSE
	BEGIN
	SET @ll_workplan_id = 0
	SET	@li_last_step_dispatched = NULL
	SET	@ps_in_office_flag = COALESCE(@ps_in_office_flag, 'N')
	SET	@ps_ordered_for = COALESCE(@ps_ordered_for, @ps_ordered_by)
	END

IF @ps_description IS NULL
	BEGIN
	SELECT @ps_description = description
	FROM o_Service
	WHERE service = @ps_ordered_service

	IF @@ERROR <> 0
		RETURN -1
	END

-- If the workplan is already past the desired step, then set the step number
-- to null so it will get dispatched immediately
IF @li_last_step_dispatched > @pi_step_number
	SET @pi_step_number = NULL

INSERT INTO p_Patient_WP_Item
	(
	cpr_id,
	patient_workplan_id,
	encounter_id,
	workplan_id,
	item_type,
	ordered_service,
	in_office_flag,
	auto_perform_flag,
	observation_tag,
	description,
	ordered_by,
	ordered_for,
	step_number,
	priority,
	created_by)
VALUES	(
	@ps_cpr_id,
	@pl_patient_workplan_id,
	@pl_encounter_id,
	@ll_workplan_id,
	'Service',
	@ps_ordered_service,
	@ps_in_office_flag,
	@ps_auto_perform_flag,
	@ps_observation_tag,
	@ps_description,
	@ps_ordered_by,
	@ps_ordered_for,
	@pi_step_number,
	@pi_priority,
	@ps_created_by )

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT,
		@ll_patient_workplan_item_id = @@identity

IF @ll_error <> 0
	RETURN -1

IF @ll_rowcount <> 1
	BEGIN
	RAISERROR ('Could not insert record into p_Patient_WP_Item',16,-1)
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF (@pi_step_number IS NULL) OR (@li_last_step_dispatched IS NULL) OR (@pi_step_number <= @li_last_step_dispatched)
	BEGIN
	-- Dispatch workplan item
	INSERT INTO p_Patient_WP_Item_Progress (
		cpr_id,
		patient_workplan_id,
		patient_workplan_item_id,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		created_by)
	VALUES (
		@ps_cpr_id,
		@pl_patient_workplan_id,
		@ll_patient_workplan_item_id,
		@pl_encounter_id,
		@ps_ordered_by,
		dbo.get_client_datetime(),
		'DISPATCHED',
		@ps_created_by)

	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT
			
	IF @ll_error <> 0
		RETURN -1
	END
	

RETURN @ll_patient_workplan_item_id


GO
GRANT EXECUTE
	ON [dbo].[sp_order_workplan_item]
	TO [cprsystem]
GO

