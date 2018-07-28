CREATE FUNCTION fn_context_object_services (
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(24),
	@pl_object_key int)

RETURNS @services TABLE (
	[patient_workplan_id] [int] NOT NULL,
	[patient_workplan_item_id] [int] NOT NULL,
	[cpr_id] [varchar](12) NULL,
	[encounter_id] [int] NULL,
	[workplan_id] [int] NOT NULL,
	[item_number] [int] NULL,
	[step_number] [smallint] NULL,
	[item_type] [varchar](12) NOT NULL,
	[ordered_service] [varchar](24) NULL,
	[active_service_flag] [char](1) ,
	[in_office_flag] [char](1) NULL ,
	[ordered_treatment_type] [varchar](24) NULL,
	[ordered_workplan_id] [int] NULL,
	[followup_workplan_id] [int] NULL,
	[description] [varchar](80) NULL,
	[ordered_by] [varchar](24) NOT NULL,
	[ordered_for] [varchar](24) NULL,
	[priority] [smallint] NULL,
	[step_flag] [char](1) NULL,
	[auto_perform_flag] [char](1) NULL,
	[cancel_workplan_flag] [char](1) NULL,
	[dispatch_date] [datetime] NULL,
	[dispatch_method] [varchar](24) NULL,
	[consolidate_flag] [char](1) NULL,
	[owner_flag] [char](1) NULL,
	[runtime_configured_flag] [char](1) NULL ,
	[observation_tag] [varchar](12) NULL,
	[dispatched_patient_workplan_item_id] [int] NULL,
	[owned_by] [varchar](24) NULL,
	[begin_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[escalation_date] [datetime] NULL,
	[expiration_date] [datetime] NULL,
	[completed_by] [varchar](24) NULL,
	[room_id] [varchar](12) NULL,
	[status] [varchar](12) NULL,
	[retries] [smallint] NULL,
	[folder] [varchar](40) NULL,
	[created_by] [varchar](24) NOT NULL,
	[created] [datetime] NULL ,
	[id] [uniqueidentifier] NOT NULL ,
	[treatment_id] [int] NULL ,
	[problem_id] [int] NULL ,
	[attachment_id] [int] NULL ,
	[context_object] [varchar] (24) NULL )

AS

BEGIN

IF @ps_context_object = 'Encounter'
	INSERT INTO @services (
		   [patient_workplan_id]
		  ,[patient_workplan_item_id]
		  ,[cpr_id]
		  ,[encounter_id]
		  ,[workplan_id]
		  ,[item_number]
		  ,[step_number]
		  ,[item_type]
		  ,[ordered_service]
		  ,[active_service_flag]
		  ,[in_office_flag]
		  ,[ordered_treatment_type]
		  ,[ordered_workplan_id]
		  ,[followup_workplan_id]
		  ,[description]
		  ,[ordered_by]
		  ,[ordered_for]
		  ,[priority]
		  ,[step_flag]
		  ,[auto_perform_flag]
		  ,[cancel_workplan_flag]
		  ,[dispatch_date]
		  ,[dispatch_method]
		  ,[consolidate_flag]
		  ,[owner_flag]
		  ,[runtime_configured_flag]
		  ,[observation_tag]
		  ,[dispatched_patient_workplan_item_id]
		  ,[owned_by]
		  ,[begin_date]
		  ,[end_date]
		  ,[escalation_date]
		  ,[expiration_date]
		  ,[completed_by]
		  ,[room_id]
		  ,[status]
		  ,[retries]
		  ,[folder]
		  ,[created_by]
		  ,[created]
		  ,[id]
		  ,[treatment_id]
			,[problem_id]
			,[attachment_id]
			,[context_object] )
	SELECT [patient_workplan_id]
		  ,[patient_workplan_item_id]
		  ,[cpr_id]
		  ,[encounter_id]
		  ,[workplan_id]
		  ,[item_number]
		  ,[step_number]
		  ,[item_type]
		  ,[ordered_service]
		  ,[active_service_flag]
		  ,[in_office_flag]
		  ,[ordered_treatment_type]
		  ,[ordered_workplan_id]
		  ,[followup_workplan_id]
		  ,[description]
		  ,[ordered_by]
		  ,[ordered_for]
		  ,[priority]
		  ,[step_flag]
		  ,[auto_perform_flag]
		  ,[cancel_workplan_flag]
		  ,[dispatch_date]
		  ,[dispatch_method]
		  ,[consolidate_flag]
		  ,[owner_flag]
		  ,[runtime_configured_flag]
		  ,[observation_tag]
		  ,[dispatched_patient_workplan_item_id]
		  ,[owned_by]
		  ,[begin_date]
		  ,[end_date]
		  ,[escalation_date]
		  ,[expiration_date]
		  ,[completed_by]
		  ,[room_id]
		  ,[status]
		  ,[retries]
		  ,[folder]
		  ,[created_by]
		  ,[created]
		  ,[id]
		  ,[treatment_id]
			,[problem_id]
			,[attachment_id]
			,[context_object]
	FROM p_Patient_WP_Item
	WHERE cpr_id = @ps_cpr_id
	AND context_object = @ps_context_object
	AND encounter_id = @pl_object_key
	AND status NOT IN ('Cancelled', 'skipped')
	AND item_type = 'Service'

IF @ps_context_object = 'Assessment'
	INSERT INTO @services (
		   [patient_workplan_id]
		  ,[patient_workplan_item_id]
		  ,[cpr_id]
		  ,[encounter_id]
		  ,[workplan_id]
		  ,[item_number]
		  ,[step_number]
		  ,[item_type]
		  ,[ordered_service]
		  ,[active_service_flag]
		  ,[in_office_flag]
		  ,[ordered_treatment_type]
		  ,[ordered_workplan_id]
		  ,[followup_workplan_id]
		  ,[description]
		  ,[ordered_by]
		  ,[ordered_for]
		  ,[priority]
		  ,[step_flag]
		  ,[auto_perform_flag]
		  ,[cancel_workplan_flag]
		  ,[dispatch_date]
		  ,[dispatch_method]
		  ,[consolidate_flag]
		  ,[owner_flag]
		  ,[runtime_configured_flag]
		  ,[observation_tag]
		  ,[dispatched_patient_workplan_item_id]
		  ,[owned_by]
		  ,[begin_date]
		  ,[end_date]
		  ,[escalation_date]
		  ,[expiration_date]
		  ,[completed_by]
		  ,[room_id]
		  ,[status]
		  ,[retries]
		  ,[folder]
		  ,[created_by]
		  ,[created]
		  ,[id]
		  ,[treatment_id]
			,[problem_id]
			,[attachment_id]
			,[context_object] )
	SELECT [patient_workplan_id]
		  ,[patient_workplan_item_id]
		  ,[cpr_id]
		  ,[encounter_id]
		  ,[workplan_id]
		  ,[item_number]
		  ,[step_number]
		  ,[item_type]
		  ,[ordered_service]
		  ,[active_service_flag]
		  ,[in_office_flag]
		  ,[ordered_treatment_type]
		  ,[ordered_workplan_id]
		  ,[followup_workplan_id]
		  ,[description]
		  ,[ordered_by]
		  ,[ordered_for]
		  ,[priority]
		  ,[step_flag]
		  ,[auto_perform_flag]
		  ,[cancel_workplan_flag]
		  ,[dispatch_date]
		  ,[dispatch_method]
		  ,[consolidate_flag]
		  ,[owner_flag]
		  ,[runtime_configured_flag]
		  ,[observation_tag]
		  ,[dispatched_patient_workplan_item_id]
		  ,[owned_by]
		  ,[begin_date]
		  ,[end_date]
		  ,[escalation_date]
		  ,[expiration_date]
		  ,[completed_by]
		  ,[room_id]
		  ,[status]
		  ,[retries]
		  ,[folder]
		  ,[created_by]
		  ,[created]
		  ,[id]
		  ,[treatment_id]
			,[problem_id]
			,[attachment_id]
			,[context_object]
	FROM p_Patient_WP_Item
	WHERE cpr_id = @ps_cpr_id
	AND context_object = @ps_context_object
	AND problem_id = @pl_object_key
	AND status NOT IN ('Cancelled', 'skipped')
	AND item_type = 'Service'

IF @ps_context_object = 'Treatment'
	INSERT INTO @services (
		   [patient_workplan_id]
		  ,[patient_workplan_item_id]
		  ,[cpr_id]
		  ,[encounter_id]
		  ,[workplan_id]
		  ,[item_number]
		  ,[step_number]
		  ,[item_type]
		  ,[ordered_service]
		  ,[active_service_flag]
		  ,[in_office_flag]
		  ,[ordered_treatment_type]
		  ,[ordered_workplan_id]
		  ,[followup_workplan_id]
		  ,[description]
		  ,[ordered_by]
		  ,[ordered_for]
		  ,[priority]
		  ,[step_flag]
		  ,[auto_perform_flag]
		  ,[cancel_workplan_flag]
		  ,[dispatch_date]
		  ,[dispatch_method]
		  ,[consolidate_flag]
		  ,[owner_flag]
		  ,[runtime_configured_flag]
		  ,[observation_tag]
		  ,[dispatched_patient_workplan_item_id]
		  ,[owned_by]
		  ,[begin_date]
		  ,[end_date]
		  ,[escalation_date]
		  ,[expiration_date]
		  ,[completed_by]
		  ,[room_id]
		  ,[status]
		  ,[retries]
		  ,[folder]
		  ,[created_by]
		  ,[created]
		  ,[id]
		  ,[treatment_id]
			,[problem_id]
			,[attachment_id]
			,[context_object] )
	SELECT [patient_workplan_id]
		  ,[patient_workplan_item_id]
		  ,[cpr_id]
		  ,[encounter_id]
		  ,[workplan_id]
		  ,[item_number]
		  ,[step_number]
		  ,[item_type]
		  ,[ordered_service]
		  ,[active_service_flag]
		  ,[in_office_flag]
		  ,[ordered_treatment_type]
		  ,[ordered_workplan_id]
		  ,[followup_workplan_id]
		  ,[description]
		  ,[ordered_by]
		  ,[ordered_for]
		  ,[priority]
		  ,[step_flag]
		  ,[auto_perform_flag]
		  ,[cancel_workplan_flag]
		  ,[dispatch_date]
		  ,[dispatch_method]
		  ,[consolidate_flag]
		  ,[owner_flag]
		  ,[runtime_configured_flag]
		  ,[observation_tag]
		  ,[dispatched_patient_workplan_item_id]
		  ,[owned_by]
		  ,[begin_date]
		  ,[end_date]
		  ,[escalation_date]
		  ,[expiration_date]
		  ,[completed_by]
		  ,[room_id]
		  ,[status]
		  ,[retries]
		  ,[folder]
		  ,[created_by]
		  ,[created]
		  ,[id]
		  ,[treatment_id]
			,[problem_id]
			,[attachment_id]
			,[context_object]
	FROM p_Patient_WP_Item
	WHERE cpr_id = @ps_cpr_id
	AND context_object = @ps_context_object
	AND treatment_id = @pl_object_key
	AND status NOT IN ('Cancelled', 'skipped')
	AND item_type = 'Service'

IF @ps_context_object = 'Attachment'
	INSERT INTO @services (
		   [patient_workplan_id]
		  ,[patient_workplan_item_id]
		  ,[cpr_id]
		  ,[encounter_id]
		  ,[workplan_id]
		  ,[item_number]
		  ,[step_number]
		  ,[item_type]
		  ,[ordered_service]
		  ,[active_service_flag]
		  ,[in_office_flag]
		  ,[ordered_treatment_type]
		  ,[ordered_workplan_id]
		  ,[followup_workplan_id]
		  ,[description]
		  ,[ordered_by]
		  ,[ordered_for]
		  ,[priority]
		  ,[step_flag]
		  ,[auto_perform_flag]
		  ,[cancel_workplan_flag]
		  ,[dispatch_date]
		  ,[dispatch_method]
		  ,[consolidate_flag]
		  ,[owner_flag]
		  ,[runtime_configured_flag]
		  ,[observation_tag]
		  ,[dispatched_patient_workplan_item_id]
		  ,[owned_by]
		  ,[begin_date]
		  ,[end_date]
		  ,[escalation_date]
		  ,[expiration_date]
		  ,[completed_by]
		  ,[room_id]
		  ,[status]
		  ,[retries]
		  ,[folder]
		  ,[created_by]
		  ,[created]
		  ,[id]
		  ,[treatment_id]
			,[problem_id]
			,[attachment_id]
			,[context_object] )
	SELECT [patient_workplan_id]
		  ,[patient_workplan_item_id]
		  ,[cpr_id]
		  ,[encounter_id]
		  ,[workplan_id]
		  ,[item_number]
		  ,[step_number]
		  ,[item_type]
		  ,[ordered_service]
		  ,[active_service_flag]
		  ,[in_office_flag]
		  ,[ordered_treatment_type]
		  ,[ordered_workplan_id]
		  ,[followup_workplan_id]
		  ,[description]
		  ,[ordered_by]
		  ,[ordered_for]
		  ,[priority]
		  ,[step_flag]
		  ,[auto_perform_flag]
		  ,[cancel_workplan_flag]
		  ,[dispatch_date]
		  ,[dispatch_method]
		  ,[consolidate_flag]
		  ,[owner_flag]
		  ,[runtime_configured_flag]
		  ,[observation_tag]
		  ,[dispatched_patient_workplan_item_id]
		  ,[owned_by]
		  ,[begin_date]
		  ,[end_date]
		  ,[escalation_date]
		  ,[expiration_date]
		  ,[completed_by]
		  ,[room_id]
		  ,[status]
		  ,[retries]
		  ,[folder]
		  ,[created_by]
		  ,[created]
		  ,[id]
		  ,[treatment_id]
			,[problem_id]
			,[attachment_id]
			,[context_object]
	FROM p_Patient_WP_Item
	WHERE cpr_id = @ps_cpr_id
	AND context_object = @ps_context_object
	AND attachment_id = @pl_object_key
	AND status NOT IN ('Cancelled', 'skipped')
	AND item_type = 'Service'

RETURN
END

