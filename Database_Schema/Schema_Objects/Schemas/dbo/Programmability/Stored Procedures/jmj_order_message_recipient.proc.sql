CREATE PROCEDURE jmj_order_message_recipient
	(
	@pl_dispatched_patient_workplan_item_id int,
	@ps_ordered_for varchar(24) = NULL,
	@ps_created_by varchar(24),
	@pl_patient_workplan_item_id int OUTPUT ,
	@ps_dispatch_method varchar(24) = NULL
	)
AS

DECLARE @ls_in_office_flag char(1)

-- If the dispatch method was not passed in then pull the in_office_flag and dispatch_method from the parent message
IF @ps_dispatch_method IS NULL
	SET @ls_in_office_flag = NULL
ELSE IF @ps_dispatch_method = 'Office View'
	SET @ls_in_office_flag = 'Y'
ELSE
	SET @ls_in_office_flag = 'N'

-- Create the new service record
INSERT INTO p_Patient_WP_Item (
	cpr_id ,
	patient_workplan_id ,
	encounter_id ,
	workplan_id ,
	item_number,
	step_number,
	item_type ,
	ordered_service ,
	in_office_flag ,
	runtime_configured_flag ,
	description ,
	ordered_by,
	ordered_for ,
	priority,
	step_flag,
	auto_perform_flag,
	cancel_workplan_flag,
	dispatch_method,
	consolidate_flag,
	owner_flag,
	observation_tag,
	dispatched_patient_workplan_item_id,
	created_by ,
	created )
SELECT cpr_id ,
	patient_workplan_id  ,
	encounter_id ,
	workplan_id ,
	item_number,
	step_number,
	item_type ,
	ordered_service ,
	COALESCE(@ls_in_office_flag, in_office_flag ),
	runtime_configured_flag ,
	description ,
	ordered_by ,
	@ps_ordered_for ,
	priority,
	step_flag,
	auto_perform_flag,
	cancel_workplan_flag,
	COALESCE(@ps_dispatch_method, in_office_flag ),
	consolidate_flag,
	owner_flag,
	observation_tag,
	@pl_dispatched_patient_workplan_item_id,
	@ps_created_by ,
	created
FROM p_Patient_WP_Item
WHERE patient_workplan_item_id = @pl_dispatched_patient_workplan_item_id

SELECT @pl_patient_workplan_item_id = SCOPE_IDENTITY()

-- Transfer all the attributes except disposition and message
INSERT INTO p_Patient_WP_Item_Attribute (
	patient_workplan_id,
	patient_workplan_item_id,
	cpr_id,
	attribute,
	value_short,
	message,
	actor_id,
	created_by)
SELECT
	patient_workplan_id,
	@pl_patient_workplan_item_id ,
	cpr_id,
	attribute,
	value_short,
	message,
	actor_id,
	@ps_created_by
FROM p_Patient_WP_Item_Attribute
WHERE patient_workplan_item_id = @pl_dispatched_patient_workplan_item_id

-- Dispatch the service
INSERT INTO p_Patient_WP_Item_Progress (
	cpr_id,
	patient_workplan_id,
	patient_workplan_item_id,
	encounter_id,
	user_id,
	progress_date_time,
	progress_type,
	created_by)
SELECT
	cpr_id,
	patient_workplan_id,
	@pl_patient_workplan_item_id,
	encounter_id,
	COALESCE(ordered_by, @ps_created_by) ,
	getdate(),
	'DISPATCHED',
	@ps_created_by
FROM p_Patient_WP_Item
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

RETURN 1

