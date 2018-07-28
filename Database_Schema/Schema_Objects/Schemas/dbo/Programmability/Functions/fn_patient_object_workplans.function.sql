CREATE FUNCTION fn_patient_object_workplans (
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(24),
	@pl_object_key int )

RETURNS @workplans TABLE (
	[patient_workplan_id] [int] NOT NULL ,
	[cpr_id] [varchar] (12) NULL ,
	[workplan_id] [int] NOT NULL ,
	[workplan_type] [varchar] (12) NOT NULL ,
	[in_office_flag] [char] (1) NULL ,
	[mode] [varchar] (32) NULL ,
	[last_step_dispatched] [smallint] NULL ,
	[last_step_date] [datetime] NULL ,
	[encounter_id] [int] NULL ,
	[problem_id] [int] NULL ,
	[treatment_id] [int] NULL ,
	[observation_sequence] [int] NULL ,
	[attachment_id] [int] NULL ,
	[description] [varchar] (80) NULL ,
	[ordered_by] [varchar] (24) NOT NULL ,
	[owned_by] [varchar] (24) NULL ,
	[parent_patient_workplan_item_id] [int] NULL ,
	[status] [varchar] (12) NULL ,
	[created_by] [varchar] (24) NOT NULL ,
	[created] [datetime] NULL ,
	[id] [uniqueidentifier] NOT NULL )

AS

BEGIN

IF @ps_context_object = 'Patient'
	INSERT INTO @workplans (	
		[patient_workplan_id] ,
		[cpr_id] ,
		[workplan_id] ,
		[workplan_type] ,
		[in_office_flag] ,
		[mode] ,
		[last_step_dispatched] ,
		[last_step_date] ,
		[encounter_id] ,
		[problem_id] ,
		[treatment_id] ,
		[observation_sequence] ,
		[attachment_id] ,
		[description] ,
		[ordered_by] ,
		[owned_by] ,
		[parent_patient_workplan_item_id] ,
		[status] ,
		[created_by] ,
		[created] ,
		[id] )
	SELECT 
		[patient_workplan_id] ,
		[cpr_id] ,
		[workplan_id] ,
		[workplan_type] ,
		[in_office_flag] ,
		[mode] ,
		[last_step_dispatched] ,
		[last_step_date] ,
		[encounter_id] ,
		[problem_id] ,
		[treatment_id] ,
		[observation_sequence] ,
		[attachment_id] ,
		[description] ,
		[ordered_by] ,
		[owned_by] ,
		[parent_patient_workplan_item_id] ,
		[status] ,
		[created_by] ,
		[created] ,
		[id] 
	FROM p_Patient_WP
	WHERE cpr_id = @ps_cpr_id
	AND workplan_type = 'Patient'
--	AND workplan_id > 0
	AND treatment_id IS NULL
	AND problem_id IS NULL
	AND attachment_id IS NULL
	
IF @ps_context_object = 'Encounter'
	INSERT INTO @workplans (	
		[patient_workplan_id] ,
		[cpr_id] ,
		[workplan_id] ,
		[workplan_type] ,
		[in_office_flag] ,
		[mode] ,
		[last_step_dispatched] ,
		[last_step_date] ,
		[encounter_id] ,
		[problem_id] ,
		[treatment_id] ,
		[observation_sequence] ,
		[attachment_id] ,
		[description] ,
		[ordered_by] ,
		[owned_by] ,
		[parent_patient_workplan_item_id] ,
		[status] ,
		[created_by] ,
		[created] ,
		[id] )
	SELECT 
		[patient_workplan_id] ,
		[cpr_id] ,
		[workplan_id] ,
		[workplan_type] ,
		[in_office_flag] ,
		[mode] ,
		[last_step_dispatched] ,
		[last_step_date] ,
		[encounter_id] ,
		[problem_id] ,
		[treatment_id] ,
		[observation_sequence] ,
		[attachment_id] ,
		[description] ,
		[ordered_by] ,
		[owned_by] ,
		[parent_patient_workplan_item_id] ,
		[status] ,
		[created_by] ,
		[created] ,
		[id] 
	FROM p_Patient_WP
	WHERE cpr_id = @ps_cpr_id
	AND workplan_type = 'Encounter'
--	AND workplan_id > 0
	AND encounter_id = @pl_object_key
	
IF @ps_context_object = 'Assessment'
	INSERT INTO @workplans (	
		[patient_workplan_id] ,
		[cpr_id] ,
		[workplan_id] ,
		[workplan_type] ,
		[in_office_flag] ,
		[mode] ,
		[last_step_dispatched] ,
		[last_step_date] ,
		[encounter_id] ,
		[problem_id] ,
		[treatment_id] ,
		[observation_sequence] ,
		[attachment_id] ,
		[description] ,
		[ordered_by] ,
		[owned_by] ,
		[parent_patient_workplan_item_id] ,
		[status] ,
		[created_by] ,
		[created] ,
		[id] )
	SELECT 
		[patient_workplan_id] ,
		[cpr_id] ,
		[workplan_id] ,
		[workplan_type] ,
		[in_office_flag] ,
		[mode] ,
		[last_step_dispatched] ,
		[last_step_date] ,
		[encounter_id] ,
		[problem_id] ,
		[treatment_id] ,
		[observation_sequence] ,
		[attachment_id] ,
		[description] ,
		[ordered_by] ,
		[owned_by] ,
		[parent_patient_workplan_item_id] ,
		[status] ,
		[created_by] ,
		[created] ,
		[id] 
	FROM p_Patient_WP
	WHERE cpr_id = @ps_cpr_id
	AND problem_id = @pl_object_key
	AND workplan_type IN ('Patient', 'Assessment')
--	AND workplan_id > 0
	AND treatment_id IS NULL
	AND attachment_id IS NULL

IF @ps_context_object = 'Treatment'
	INSERT INTO @workplans (	
		[patient_workplan_id] ,
		[cpr_id] ,
		[workplan_id] ,
		[workplan_type] ,
		[in_office_flag] ,
		[mode] ,
		[last_step_dispatched] ,
		[last_step_date] ,
		[encounter_id] ,
		[problem_id] ,
		[treatment_id] ,
		[observation_sequence] ,
		[attachment_id] ,
		[description] ,
		[ordered_by] ,
		[owned_by] ,
		[parent_patient_workplan_item_id] ,
		[status] ,
		[created_by] ,
		[created] ,
		[id] )
	SELECT 
		[patient_workplan_id] ,
		[cpr_id] ,
		[workplan_id] ,
		[workplan_type] ,
		[in_office_flag] ,
		[mode] ,
		[last_step_dispatched] ,
		[last_step_date] ,
		[encounter_id] ,
		[problem_id] ,
		[treatment_id] ,
		[observation_sequence] ,
		[attachment_id] ,
		[description] ,
		[ordered_by] ,
		[owned_by] ,
		[parent_patient_workplan_item_id] ,
		[status] ,
		[created_by] ,
		[created] ,
		[id] 
	FROM p_Patient_WP
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @pl_object_key
	AND workplan_type IN ('Patient', 'Treatment')
--	AND workplan_id > 0
	UNION
	SELECT 
		[patient_workplan_id] ,
		[cpr_id] ,
		[workplan_id] ,
		[workplan_type] ,
		[in_office_flag] ,
		[mode] ,
		[last_step_dispatched] ,
		[last_step_date] ,
		[encounter_id] ,
		[problem_id] ,
		[treatment_id] ,
		[observation_sequence] ,
		[attachment_id] ,
		[description] ,
		[ordered_by] ,
		[owned_by] ,
		[parent_patient_workplan_item_id] ,
		[status] ,
		[created_by] ,
		[created] ,
		[id] 
	FROM p_Patient_WP
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @pl_object_key
	AND workplan_type IN ('Referral', 'Followup')

IF @ps_context_object = 'Attachment'
	INSERT INTO @workplans (	
		[patient_workplan_id] ,
		[cpr_id] ,
		[workplan_id] ,
		[workplan_type] ,
		[in_office_flag] ,
		[mode] ,
		[last_step_dispatched] ,
		[last_step_date] ,
		[encounter_id] ,
		[problem_id] ,
		[treatment_id] ,
		[observation_sequence] ,
		[attachment_id] ,
		[description] ,
		[ordered_by] ,
		[owned_by] ,
		[parent_patient_workplan_item_id] ,
		[status] ,
		[created_by] ,
		[created] ,
		[id] )
	SELECT 
		[patient_workplan_id] ,
		[cpr_id] ,
		[workplan_id] ,
		[workplan_type] ,
		[in_office_flag] ,
		[mode] ,
		[last_step_dispatched] ,
		[last_step_date] ,
		[encounter_id] ,
		[problem_id] ,
		[treatment_id] ,
		[observation_sequence] ,
		[attachment_id] ,
		[description] ,
		[ordered_by] ,
		[owned_by] ,
		[parent_patient_workplan_item_id] ,
		[status] ,
		[created_by] ,
		[created] ,
		[id] 
	FROM p_Patient_WP
	WHERE cpr_id = @ps_cpr_id
	AND attachment_id = @pl_object_key
	AND workplan_type = 'Attachment'
--	AND workplan_id > 0


RETURN
END

