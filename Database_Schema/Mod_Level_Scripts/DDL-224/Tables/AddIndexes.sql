
IF (select count(*) from sysindexes where name = 'idx_observation_cpr') = 0
	CREATE NONCLUSTERED INDEX [idx_observation_cpr]
	ON [dbo].[p_Observation] ([cpr_id],[observation_id])
	INCLUDE ([description],[treatment_id],[result_expected_date],[parent_observation_sequence],[service])


IF (select count(*) from sysindexes where name = 'idx_observation_cpr_parent') = 0
	CREATE NONCLUSTERED INDEX [idx_observation_cpr_parent]
	ON [dbo].[p_Observation] ([cpr_id], [parent_observation_sequence])
	INCLUDE ([observation_id], [description], [service])

IF (select count(*) from sysindexes where name = 'idx_ordered_active_service') = 0
	CREATE NONCLUSTERED INDEX [idx_ordered_active_service]
		ON [dbo].[p_Patient_WP_Item] ([ordered_service], [active_service_flag], [owned_by])
		INCLUDE ([priority])
		WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
	GO
IF (select count(*) from sysindexes where name = 'idx_owner_flag') = 0
	CREATE NONCLUSTERED INDEX [idx_owner_flag]
		ON [dbo].[p_Patient_WP_Item] ([owner_flag])
		INCLUDE ([patient_workplan_id], [owned_by])
		WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
	GO
IF (select count(*) from sysindexes where name = 'idx_item_type') = 0
	CREATE NONCLUSTERED INDEX [idx_item_type]
		ON [dbo].[p_Patient_WP_Item] ([item_type], [context_object])
		WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
	GO
IF (select count(*) from sysindexes where name = 'idx_cpr_treatment_id') = 0
	CREATE NONCLUSTERED INDEX [idx_cpr_treatment_id]
		ON [dbo].[p_Patient_WP_Item] ([cpr_id], [treatment_id])
		WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
	GO
IF (select count(*) from sysindexes where name = 'idx_ordered_service') = 0
	CREATE NONCLUSTERED INDEX [idx_ordered_service]
		ON [dbo].[p_Patient_WP_Item] ([ordered_service])
		INCLUDE ([patient_workplan_id], [encounter_id], [workplan_id], [item_number], [step_number], [item_type], [active_service_flag], [in_office_flag], [ordered_treatment_type], [ordered_workplan_id], [followup_workplan_id], [description], [ordered_by], [ordered_for], [priority], [step_flag], [auto_perform_flag], [cancel_workplan_flag], [dispatch_date], [dispatch_method], [consolidate_flag], [owner_flag], [runtime_configured_flag], [observation_tag], [dispatched_patient_workplan_item_id], [owned_by], [begin_date], [end_date], [escalation_date], [expiration_date], [completed_by], [room_id], [status], [retries], [folder], [created_by], [created], [id], [treatment_id], [problem_id], [attachment_id], [context_object])
		WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
	GO


IF (select count(*) from sysindexes where name = 'idx_pprg_cpr_current_flag') = 0
	CREATE NONCLUSTERED INDEX [idx_pprg_cpr_current_flag]
		ON [dbo].[p_Patient_Progress] ([cpr_id], [current_flag])
		INCLUDE ([attachment_id])
		WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [PRIMARY]
	GO

IF (select count(*) from sysindexes where name = 'idx_pprg_encounter_id') = 0
	CREATE NONCLUSTERED INDEX [idx_pprg_encounter_id]
		ON [dbo].[p_Patient_Progress] ([cpr_id], [encounter_id])
		WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [PRIMARY]
	GO

IF (select count(*) from sysindexes where name = 'idx_pprg_progress_key') = 0
	CREATE NONCLUSTERED INDEX [idx_pprg_progress_key]
		ON [dbo].[p_Patient_Progress] ([cpr_id], [progress_type], [progress_key])
		INCLUDE ([progress_date_time])
		WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [PRIMARY]
	GO


IF (select count(*) from sysindexes where name = 'idx_c_Display_Script_Type') = 0
	CREATE NONCLUSTERED INDEX [idx_c_Display_Script_Type]
		ON [dbo].[c_Display_Script] ([script_type])
		INCLUDE ([description], [status], [id], [owner_id], [context_object], [display_script])
		WITH ( PAD_INDEX = ON, FILLFACTOR = 90) ON [PRIMARY]
	GO

IF (select count(*) from sysindexes where name = 'idx_top_20_item_id') = 0
	CREATE NONCLUSTERED INDEX [idx_top_20_item_id]
		ON [dbo].[u_Top_20] ([item_id])
		WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [PRIMARY]
	GO