CREATE FUNCTION fn_progress_all (
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(24),
	@pl_object_key int)

RETURNS @progress TABLE (
	[cpr_id] [varchar] (12)  NOT NULL ,
	[context_object] [varchar] (24) NOT NULL ,
	[object_key] [int] NULL ,
	[progress_sequence] [int] NOT NULL ,
	[encounter_id] [int] NULL ,
	[user_id] [varchar] (24)  NOT NULL ,
	[progress_date_time] [datetime] NOT NULL ,
	[progress_type] [varchar] (24)  NULL ,
	[progress_key] [varchar] (48)  NULL ,
	[progress_value] [varchar] (40) NULL ,
	[progress] [text]  NULL ,
	[attachment_id] [int] NULL ,
	[patient_workplan_item_id] [int] NULL ,
	[risk_level] [int] NULL ,
	[created] [datetime] NULL ,
	[created_by] [varchar] (24)  NULL )

AS

BEGIN

IF @ps_context_object = 'Patient'
	INSERT INTO @progress (	
		[cpr_id] ,
		[context_object] ,
		[object_key] ,
		[progress_sequence] ,
		[encounter_id] ,
		[user_id] ,
		[progress_date_time] ,
		[progress_type] ,
		[progress_key] ,
		[progress_value] ,
		[progress] ,
		[attachment_id] ,
		[patient_workplan_item_id] ,
		[risk_level] ,
		[created] ,
		[created_by] )
	SELECT 
		[cpr_id] ,
		@ps_context_object ,
		NULL ,
		[patient_progress_sequence] ,
		[encounter_id] ,
		[user_id] ,
		[progress_date_time] ,
		[progress_type] ,
		[progress_key] ,
		[progress_value] ,
		[progress] ,
		[attachment_id] ,
		[patient_workplan_item_id] ,
		[risk_level] ,
		[created] ,
		[created_by] 
	FROM p_Patient_Progress WITH (NOLOCK)
	WHERE cpr_id = @ps_cpr_id

IF @ps_context_object = 'Encounter'
	INSERT INTO @progress (	
		[cpr_id] ,
		[context_object] ,
		[object_key] ,
		[progress_sequence] ,
		[encounter_id] ,
		[user_id] ,
		[progress_date_time] ,
		[progress_type] ,
		[progress_key] ,
		[progress_value] ,
		[progress] ,
		[attachment_id] ,
		[patient_workplan_item_id] ,
		[risk_level] ,
		[created] ,
		[created_by] )
	SELECT 
		[cpr_id] ,
		@ps_context_object ,
		[encounter_id] ,
		[encounter_progress_sequence] ,
		[encounter_id] ,
		[user_id] ,
		[progress_date_time] ,
		[progress_type] ,
		[progress_key] ,
		[progress_value] ,
		[progress] ,
		[attachment_id] ,
		[patient_workplan_item_id] ,
		[risk_level] ,
		[created] ,
		[created_by] 
	FROM p_Patient_Encounter_Progress WITH (NOLOCK)
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_object_key

IF @ps_context_object = 'Assessment'
	INSERT INTO @progress (	
		[cpr_id] ,
		[context_object] ,
		[object_key] ,
		[progress_sequence] ,
		[encounter_id] ,
		[user_id] ,
		[progress_date_time] ,
		[progress_type] ,
		[progress_key] ,
		[progress_value] ,
		[progress] ,
		[attachment_id] ,
		[patient_workplan_item_id] ,
		[risk_level] ,
		[created] ,
		[created_by] )
	SELECT 
		[cpr_id] ,
		@ps_context_object ,
		[problem_id] ,
		[assessment_progress_sequence] ,
		[encounter_id] ,
		[user_id] ,
		[progress_date_time] ,
		[progress_type] ,
		[progress_key] ,
		[progress_value] ,
		[progress] ,
		[attachment_id] ,
		[patient_workplan_item_id] ,
		[risk_level] ,
		[created] ,
		[created_by] 
	FROM p_Assessment_Progress WITH (NOLOCK)
	WHERE cpr_id = @ps_cpr_id
	AND problem_id = @pl_object_key

IF @ps_context_object = 'Treatment'
	INSERT INTO @progress (	
		[cpr_id] ,
		[context_object] ,
		[object_key] ,
		[progress_sequence] ,
		[encounter_id] ,
		[user_id] ,
		[progress_date_time] ,
		[progress_type] ,
		[progress_key] ,
		[progress_value] ,
		[progress] ,
		[attachment_id] ,
		[patient_workplan_item_id] ,
		[risk_level] ,
		[created] ,
		[created_by] )
	SELECT 
		[cpr_id] ,
		@ps_context_object ,
		[treatment_id] ,
		[treatment_progress_sequence] ,
		[encounter_id] ,
		[user_id] ,
		[progress_date_time] ,
		[progress_type] ,
		[progress_key] ,
		[progress_value] ,
		[progress] ,
		[attachment_id] ,
		[patient_workplan_item_id] ,
		[risk_level] ,
		[created] ,
		[created_by] 
	FROM p_Treatment_Progress WITH (NOLOCK)
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @pl_object_key

IF @ps_context_object = 'Observation'
	INSERT INTO @progress (	
		[cpr_id] ,
		[context_object] ,
		[object_key] ,
		[progress_sequence] ,
		[encounter_id] ,
		[user_id] ,
		[progress_date_time] ,
		[progress_type] ,
		[progress_key] ,
		[progress_value] ,
		[progress] ,
		[attachment_id] ,
		[patient_workplan_item_id] ,
		[risk_level] ,
		[created] ,
		[created_by] )
	SELECT 
		[cpr_id] ,
		@ps_context_object ,
		[observation_sequence] ,
		[Observation_comment_id] ,
		[encounter_id] ,
		[user_id] ,
		[comment_date_time] ,
		[comment_type] ,
		[comment_title] ,
		[short_comment] ,
		[comment] ,
		[attachment_id] ,
		CAST(NULL as int) ,
		CAST(NULL as int) ,
		[created] ,
		[created_by] 
	FROM p_Observation_Comment WITH (NOLOCK)
	WHERE cpr_id = @ps_cpr_id
	AND observation_sequence = @pl_object_key

IF @ps_context_object = 'Attachment'
	INSERT INTO @progress (	
		[cpr_id] ,
		[context_object] ,
		[object_key] ,
		[progress_sequence] ,
		[encounter_id] ,
		[user_id] ,
		[progress_date_time] ,
		[progress_type] ,
		[progress_key] ,
		[progress_value] ,
		[progress] ,
		[attachment_id] ,
		[patient_workplan_item_id] ,
		[risk_level] ,
		[created] ,
		[created_by] )
	SELECT 
		[cpr_id] ,
		@ps_context_object ,
		[attachment_id] ,
		[attachment_progress_sequence] ,
		CAST(NULL as int) ,
		[user_id] ,
		[progress_date_time] ,
		[progress_type] ,
		CAST(NULL as varchar(48)) ,
		CAST(NULL as varchar(40)) ,
		progress ,
		CAST(NULL as int) ,
		[patient_workplan_item_id] ,
		CAST(NULL as int) ,
		[created] ,
		[created_by] 
	FROM p_Attachment_Progress WITH (NOLOCK)
	WHERE cpr_id = @ps_cpr_id
	AND attachment_id = @pl_object_key


RETURN
END

