CREATE PROCEDURE sp_forward_todo_service (
	@pl_patient_workplan_item_id integer,
	@ps_from_user_id varchar(24) = NULL,
	@ps_to_user_id varchar(24),
	@ps_description varchar(80) = NULL,
	@ps_service varchar(24) = NULL,
	@ps_created_by varchar(24),
	@ps_new_message text = NULL )
AS

DECLARE @ll_patient_workplan_item_id integer

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
	consolidate_flag,
	owner_flag,
	observation_tag,
	dispatched_patient_workplan_item_id,
	created_by )
SELECT cpr_id ,
	patient_workplan_id  ,
	encounter_id ,
	workplan_id ,
	item_number,
	step_number,
	item_type ,
	COALESCE(@ps_service, ordered_service) ,
	in_office_flag ,
	runtime_configured_flag ,
	COALESCE(@ps_description, description) ,
	COALESCE(@ps_from_user_id, owned_by, @ps_created_by) ,
	@ps_to_user_id ,
	priority,
	step_flag,
	auto_perform_flag,
	cancel_workplan_flag,
	consolidate_flag,
	owner_flag,
	observation_tag,
	dispatched_patient_workplan_item_id,
	@ps_created_by 
FROM p_Patient_WP_Item
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

SELECT @ll_patient_workplan_item_id = @@IDENTITY

-- Transfer all the attributes except disposition and message
INSERT INTO p_Patient_WP_Item_Attribute (
	patient_workplan_id,
	patient_workplan_item_id,
	cpr_id,
	attribute,
	value_short,
	message,
	created_by)
SELECT
	patient_workplan_id,
	@ll_patient_workplan_item_id ,
	cpr_id,
	attribute,
	value_short,
	message,
	@ps_created_by
FROM p_Patient_WP_Item_Attribute
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id
AND attribute NOT IN ('disposition', 'message')

-- Add the new message to the recipient
IF @ps_new_message IS NOT NULL
	EXECUTE sp_add_workplan_item_attribute
		@ps_cpr_id = NULL,
		@pl_patient_workplan_id = NULL,
		@pl_patient_workplan_item_id = @ll_patient_workplan_item_id,
		@ps_attribute = 'message',
		@ps_value = @ps_new_message,
		@ps_created_by = @ps_created_by

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
	patient_workplan_item_id,
	encounter_id,
	COALESCE(@ps_from_user_id, ordered_by) ,
	getdate(),
	'DISPATCHED',
	@ps_created_by
FROM p_Patient_WP_Item
WHERE patient_workplan_item_id = @ll_patient_workplan_item_id
