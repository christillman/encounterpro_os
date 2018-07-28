CREATE FUNCTION fn_patient_object_progress_current (
	@ps_cpr_id varchar(12))

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
	'Patient' ,
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
AND current_flag = 'Y'


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
	'Encounter' ,
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
AND current_flag = 'Y'


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
	'Assessment' ,
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
AND current_flag = 'Y'


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
	'Treatment' ,
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
AND current_flag = 'Y'

RETURN
END

