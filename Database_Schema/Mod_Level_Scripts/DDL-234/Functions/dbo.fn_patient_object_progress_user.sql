
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_patient_object_progress_user]
Print 'Drop Function [dbo].[fn_patient_object_progress_user]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_patient_object_progress_user]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_patient_object_progress_user]
GO

-- Create Function [dbo].[fn_patient_object_progress_user]
Print 'Create Function [dbo].[fn_patient_object_progress_user]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_patient_object_progress_user (
	@ps_user_id varchar(24),
	@pdt_begin_date datetime,
	@pdt_end_date datetime)

RETURNS @objects TABLE (
	[cpr_id] [varchar] (12)  NOT NULL ,
	[context_object] [varchar] (24) NOT NULL ,
	[object_key] [int] NOT NULL ,
	[object_type] [varchar] (24) NOT NULL ,
	[description] [varchar] (255) NULL ,
	[encounter_id] [int] NULL ,
	[begin_date] [datetime] NOT NULL ,
	[end_date] [datetime] NULL ,
	[ordered_by] varchar(255)  NULL ,
	[status] [varchar] (12) NOT NULL ,
	[created] [datetime] NULL ,
	[created_by] varchar(255)  NULL ,
	[progress_sequence] [int] NOT NULL ,
	[progress_encounter_id] [int] NULL ,
	[progress_user_id] varchar(255)  NOT NULL ,
	[progress_date_time] [datetime] NOT NULL ,
	[progress_type] [varchar] (24)  NULL ,
	[progress_key] [varchar] (48)  NULL ,
	[progress] [varchar] (128)  NULL ,
	[progress_attachment_id] [int] NULL ,
	[progress_current_flag] [char] (1) NOT NULL ,
	[progress_created] [datetime] NULL ,
	[progress_created_by] varchar(255)  NULL )

AS

BEGIN

-- Since we filter to strictly less than the end date, set the end date to midnight of the day after the desired end date
IF @pdt_end_date IS NULL
	SET @pdt_end_date = CAST('1/1/2100' AS datetime)
ELSE
	SET @pdt_end_date = DATEADD(day, 1, dbo.fn_date_truncate(@pdt_end_date, 'DAY'))

-- Patient Progress
INSERT INTO @objects (	
	[cpr_id] ,
	[context_object] ,
	[object_key] ,
	[object_type] ,
	[description] ,
	[begin_date] ,
	[ordered_by] ,
	[status] ,
	[created] ,
	[created_by] ,
	[progress_sequence] ,
	[progress_encounter_id] ,
	[progress_user_id] ,
	[progress_date_time] ,
	[progress_type] ,
	[progress_key] ,
	[progress] ,
	[progress_attachment_id] ,
	[progress_current_flag] ,
	[progress_created] ,
	[progress_created_by] )
SELECT 
	o.[cpr_id] ,
	'Patient' ,
	0 ,
	o.patient_status ,
	dbo.fn_pretty_name(o.last_name ,
						o.first_name ,
						o.middle_name ,
						o.name_suffix ,
						o.name_prefix ,
						o.degree ) ,
	ISNULL(o.[created], p.[created]) ,
	ISNULL(o.[created_by], '#SYSTEM') ,
	o.[patient_status] ,
	o.[created] ,
	o.[created_by] ,
	p.[patient_progress_sequence] ,
	p.[encounter_id] ,
	p.[user_id] ,
	p.[progress_date_time] ,
	p.[progress_type] ,
	p.[progress_key] ,
	CASE WHEN p.progress_value Is Null THEN CAST(progress AS varchar(128)) ELSE p.progress_value END ,
	p.[attachment_id] ,
	p.[current_flag] ,
	p.[created] ,
	p.[created_by] 
FROM p_Patient o
	INNER JOIN p_Patient_progress p
	ON o.cpr_id = p.cpr_id
WHERE p.user_id = @ps_user_id
AND p.created >= @pdt_begin_date
AND p.created < @pdt_end_date
UNION
SELECT 
	o.[cpr_id] ,
	'Patient' ,
	0 ,
	o.patient_status ,
	dbo.fn_pretty_name(o.last_name ,
						o.first_name ,
						o.middle_name ,
						o.name_suffix ,
						o.name_prefix ,
						o.degree ) ,
	ISNULL(o.[created], p.[created]) ,
	ISNULL(o.[created_by], '#SYSTEM') ,
	o.[patient_status] ,
	o.[created] ,
	o.[created_by] ,
	p.[patient_progress_sequence] ,
	p.[encounter_id] ,
	p.[user_id] ,
	p.[progress_date_time] ,
	p.[progress_type] ,
	p.[progress_key] ,
	CASE WHEN p.progress_value Is Null THEN CAST(progress AS varchar(128)) ELSE p.progress_value END ,
	p.[attachment_id] ,
	p.[current_flag] ,
	p.[created] ,
	p.[created_by] 
FROM p_Patient o
	INNER JOIN p_Patient_progress p
	ON o.cpr_id = p.cpr_id
WHERE p.created_by = @ps_user_id
AND p.created >= @pdt_begin_date
AND p.created < @pdt_end_date


-- Encounter Progress
INSERT INTO @objects (	
	[cpr_id] ,
	[context_object] ,
	[object_key] ,
	[object_type] ,
	[description] ,
	[encounter_id] ,
	[begin_date] ,
	[end_date] ,
	[ordered_by] ,
	[status] ,
	[created] ,
	[created_by] ,
	[progress_sequence] ,
	[progress_encounter_id] ,
	[progress_user_id] ,
	[progress_date_time] ,
	[progress_type] ,
	[progress_key] ,
	[progress] ,
	[progress_attachment_id] ,
	[progress_current_flag] ,
	[progress_created] ,
	[progress_created_by] )
SELECT 
	o.[cpr_id] ,
	'Encounter' ,
	o.encounter_id ,
	o.encounter_type ,
	o.[encounter_description] ,
	o.[encounter_id] ,
	o.[encounter_date] ,
	o.[discharge_date] ,
	o.[created_by] ,
	o.[encounter_status] ,
	o.[created] ,
	o.[created_by] ,
	p.[encounter_progress_sequence] ,
	p.[encounter_id] ,
	p.[user_id] ,
	p.[progress_date_time] ,
	p.[progress_type] ,
	p.[progress_key] ,
	CASE WHEN p.progress_value Is Null THEN CAST(progress AS varchar(128)) ELSE p.progress_value END ,
	p.[attachment_id] ,
	p.[current_flag] ,
	p.[created] ,
	p.[created_by] 
FROM p_Patient_Encounter o
	INNER JOIN p_Patient_Encounter_progress p
	ON o.cpr_id = p.cpr_id
	AND o.encounter_id = p.encounter_id
WHERE p.user_id = @ps_user_id
AND p.created >= @pdt_begin_date
AND p.created < @pdt_end_date
UNION
SELECT 
	o.[cpr_id] ,
	'Encounter' ,
	o.encounter_id ,
	o.encounter_type ,
	o.[encounter_description] ,
	o.[encounter_id] ,
	o.[encounter_date] ,
	o.[discharge_date] ,
	o.[created_by] ,
	o.[encounter_status] ,
	o.[created] ,
	o.[created_by] ,
	p.[encounter_progress_sequence] ,
	p.[encounter_id] ,
	p.[user_id] ,
	p.[progress_date_time] ,
	p.[progress_type] ,
	p.[progress_key] ,
	CASE WHEN p.progress_value Is Null THEN CAST(progress AS varchar(128)) ELSE p.progress_value END ,
	p.[attachment_id] ,
	p.[current_flag] ,
	p.[created] ,
	p.[created_by] 
FROM p_Patient_Encounter o
	INNER JOIN p_Patient_Encounter_progress p
	ON o.cpr_id = p.cpr_id
	AND o.encounter_id = p.encounter_id
WHERE p.created_by = @ps_user_id
AND p.created >= @pdt_begin_date
AND p.created < @pdt_end_date


-- Assessment Progress
INSERT INTO @objects (	
	[cpr_id] ,
	[context_object] ,
	[object_key] ,
	[object_type] ,
	[description] ,
	[encounter_id] ,
	[begin_date] ,
	[end_date] ,
	[ordered_by] ,
	[status] ,
	[created] ,
	[created_by] ,
	[progress_sequence] ,
	[progress_encounter_id] ,
	[progress_user_id] ,
	[progress_date_time] ,
	[progress_type] ,
	[progress_key] ,
	[progress] ,
	[progress_attachment_id] ,
	[progress_current_flag] ,
	[progress_created] ,
	[progress_created_by] )
SELECT 
	o.[cpr_id] ,
	'Assessment' ,
	o.problem_id ,
	o.assessment_type ,
	o.[assessment] ,
	o.[open_encounter_id] ,
	o.[begin_date] ,
	o.[end_date] ,
	o.[diagnosed_by] ,
	ISNULL(o.[assessment_status], 'OPEN') ,
	o.[created] ,
	o.[created_by] ,
	p.[assessment_progress_sequence] ,
	p.[encounter_id] ,
	p.[user_id] ,
	p.[progress_date_time] ,
	p.[progress_type] ,
	p.[progress_key] ,
	CASE WHEN p.progress_value Is Null THEN CAST(progress AS varchar(128)) ELSE p.progress_value END ,
	p.[attachment_id] ,
	p.[current_flag] ,
	p.[created] ,
	p.[created_by] 
FROM p_Assessment o
	INNER JOIN p_Assessment_Progress p
	ON o.cpr_id = p.cpr_id
	AND o.problem_id = p.problem_id
WHERE p.user_id = @ps_user_id
AND p.created >= @pdt_begin_date
AND p.created < @pdt_end_date
UNION
SELECT 
	o.[cpr_id] ,
	'Assessment' ,
	o.problem_id ,
	o.assessment_type ,
	o.[assessment] ,
	o.[open_encounter_id] ,
	o.[begin_date] ,
	o.[end_date] ,
	o.[diagnosed_by] ,
	ISNULL(o.[assessment_status], 'OPEN') ,
	o.[created] ,
	o.[created_by] ,
	p.[assessment_progress_sequence] ,
	p.[encounter_id] ,
	p.[user_id] ,
	p.[progress_date_time] ,
	p.[progress_type] ,
	p.[progress_key] ,
	CASE WHEN p.progress_value Is Null THEN CAST(progress AS varchar(128)) ELSE p.progress_value END ,
	p.[attachment_id] ,
	p.[current_flag] ,
	p.[created] ,
	p.[created_by] 
FROM p_Assessment o
	INNER JOIN p_Assessment_Progress p
	ON o.cpr_id = p.cpr_id
	AND o.problem_id = p.problem_id
WHERE p.created_by = @ps_user_id
AND p.created >= @pdt_begin_date
AND p.created < @pdt_end_date

-- Treatment Progress
INSERT INTO @objects (	
	[cpr_id] ,
	[context_object] ,
	[object_key] ,
	[object_type] ,
	[description] ,
	[encounter_id] ,
	[begin_date] ,
	[end_date] ,
	[ordered_by] ,
	[status] ,
	[created] ,
	[created_by] ,
	[progress_sequence] ,
	[progress_encounter_id] ,
	[progress_user_id] ,
	[progress_date_time] ,
	[progress_type] ,
	[progress_key] ,
	[progress] ,
	[progress_attachment_id] ,
	[progress_current_flag] ,
	[progress_created] ,
	[progress_created_by] )
SELECT 
	o.[cpr_id] ,
	'Treatment' ,
	o.treatment_id ,
	o.treatment_type ,
	o.[treatment_description] ,
	o.[open_encounter_id] ,
	o.[begin_date] ,
	o.[end_date] ,
	o.[ordered_by] ,
	ISNULL(o.[treatment_status], 'OPEN') ,
	o.[created] ,
	o.[created_by] ,
	p.[treatment_progress_sequence] ,
	p.[encounter_id] ,
	p.[user_id] ,
	p.[progress_date_time] ,
	p.[progress_type] ,
	p.[progress_key] ,
	CASE WHEN p.progress_value Is Null THEN CAST(progress AS varchar(128)) ELSE p.progress_value END ,
	p.[attachment_id] ,
	p.[current_flag] ,
	p.[created] ,
	p.[created_by] 
FROM p_Treatment_Item o
	INNER JOIN p_Treatment_Progress p
	ON o.cpr_id = p.cpr_id
	AND o.treatment_id = p.treatment_id
WHERE p.user_id = @ps_user_id
AND p.created >= @pdt_begin_date
AND p.created < @pdt_end_date
UNION
SELECT 
	o.[cpr_id] ,
	'Treatment' ,
	o.treatment_id ,
	o.treatment_type ,
	o.[treatment_description] ,
	o.[open_encounter_id] ,
	o.[begin_date] ,
	o.[end_date] ,
	o.[ordered_by] ,
	ISNULL(o.[treatment_status], 'OPEN') ,
	o.[created] ,
	o.[created_by] ,
	p.[treatment_progress_sequence] ,
	p.[encounter_id] ,
	p.[user_id] ,
	p.[progress_date_time] ,
	p.[progress_type] ,
	p.[progress_key] ,
	CASE WHEN p.progress_value Is Null THEN CAST(progress AS varchar(128)) ELSE p.progress_value END ,
	p.[attachment_id] ,
	p.[current_flag] ,
	p.[created] ,
	p.[created_by] 
FROM p_Treatment_Item o
	INNER JOIN p_Treatment_Progress p
	ON o.cpr_id = p.cpr_id
	AND o.treatment_id = p.treatment_id
WHERE p.created_by = @ps_user_id
AND p.created >= @pdt_begin_date
AND p.created < @pdt_end_date


-- Attachment Progress
INSERT INTO @objects (	
	[cpr_id] ,
	[context_object] ,
	[object_key] ,
	[object_type] ,
	[description] ,
	[encounter_id] ,
	[begin_date] ,
	[ordered_by] ,
	[status] ,
	[created] ,
	[created_by] ,
	[progress_sequence] ,
	[progress_user_id] ,
	[progress_date_time] ,
	[progress_type] ,
	[progress] ,
	[progress_attachment_id] ,
	[progress_current_flag] ,
	[progress_created] ,
	[progress_created_by] )
SELECT 
	o.[cpr_id] ,
	'Attachment' ,
	o.attachment_id ,
	o.attachment_type ,
	o.attachment_tag ,
	o.encounter_id ,
	o.attachment_date ,
	o.attached_by ,
	o.status ,
	o.created ,
	o.created_by ,
	p.attachment_progress_sequence ,
	p.user_id ,
	p.progress_date_time ,
	p.progress_type ,
	CAST(p.progress AS varchar(128)) ,
	p.attachment_id ,
	p.current_flag ,
	p.created ,
	p.created_by 
FROM p_Attachment o
	INNER JOIN p_Attachment_Progress p
	ON o.cpr_id = p.cpr_id
	AND o.attachment_id = p.attachment_id
WHERE p.user_id = @ps_user_id
AND p.created >= @pdt_begin_date
AND p.created < @pdt_end_date
UNION
SELECT 
	o.[cpr_id] ,
	'Attachment' ,
	o.attachment_id ,
	o.attachment_type ,
	o.attachment_tag ,
	o.encounter_id ,
	o.attachment_date ,
	o.attached_by ,
	o.status ,
	o.created ,
	o.created_by ,
	p.attachment_progress_sequence ,
	p.user_id ,
	p.progress_date_time ,
	p.progress_type ,
	CAST(p.progress AS varchar(128)) ,
	p.attachment_id ,
	p.current_flag ,
	p.created ,
	p.created_by 
FROM p_Attachment o
	INNER JOIN p_Attachment_Progress p
	ON o.cpr_id = p.cpr_id
	AND o.attachment_id = p.attachment_id
WHERE p.created_by = @ps_user_id
AND p.created >= @pdt_begin_date
AND p.created < @pdt_end_date


-- Observation_Results tied to treatments
INSERT INTO @objects (	
	[cpr_id] ,
	[context_object] ,
	[object_key] ,
	[object_type] ,
	[description] ,
	[encounter_id] ,
	[begin_date] ,
	[end_date] ,
	[ordered_by] ,
	[status] ,
	[created] ,
	[created_by] ,
	[progress_sequence] ,
	[progress_encounter_id] ,
	[progress_user_id] ,
	[progress_date_time] ,
	[progress_type] ,
	[progress_key] ,
	[progress] ,
	[progress_attachment_id] ,
	[progress_current_flag] ,
	[progress_created] ,
	[progress_created_by] )
SELECT 
	o.[cpr_id] ,
	'Treatment' ,
	o.treatment_id ,
	o.treatment_type ,
	o.[treatment_description] + ' - ' + po.description,
	o.[open_encounter_id] ,
	o.[begin_date] ,
	o.[end_date] ,
	o.[ordered_by] ,
	ISNULL(o.[treatment_status], 'OPEN') ,
	o.[created] ,
	o.[created_by] ,
	p.[location_result_sequence] ,
	p.[encounter_id] ,
	p.[observed_by] ,
	p.[created] ,
	'Result' ,
	CASE p.location WHEN 'NA' THEN NULL ELSE l.description END ,
	p.[result]
		+ CASE WHEN p.result_value IS NULL THEN '' ELSE ' = ' + p.result_value END
		+ CASE WHEN u.description IS NULL THEN '' ELSE ' ' + u.description END,
	NULL ,
	p.[current_flag] ,
	p.[created] ,
	p.[created_by] 
FROM p_Treatment_Item o
	INNER JOIN p_Observation_Result p
	ON o.cpr_id = p.cpr_id
	AND o.treatment_id = p.treatment_id
	INNER JOIN p_Observation po
	ON p.cpr_id = po.cpr_id
	AND p.observation_sequence = po.observation_sequence
	INNER JOIN c_Location l
	ON p.location = l.location
	LEFT OUTER JOIN c_Unit u
	ON p.result_unit = u.unit_id
WHERE p.observed_by = @ps_user_id
AND p.created >= @pdt_begin_date
AND p.created < @pdt_end_date
UNION
SELECT 
	o.[cpr_id] ,
	'Treatment' ,
	o.treatment_id ,
	o.treatment_type ,
	o.[treatment_description] + ' - ' + po.description,
	o.[open_encounter_id] ,
	o.[begin_date] ,
	o.[end_date] ,
	o.[ordered_by] ,
	ISNULL(o.[treatment_status], 'OPEN') ,
	o.[created] ,
	o.[created_by] ,
	p.[location_result_sequence] ,
	p.[encounter_id] ,
	p.[observed_by] ,
	p.[created] ,
	'Result' ,
	CASE p.location WHEN 'NA' THEN NULL ELSE l.description END ,
	p.[result]
		+ CASE WHEN p.result_value IS NULL THEN '' ELSE ' = ' + p.result_value END
		+ CASE WHEN u.description IS NULL THEN '' ELSE ' ' + u.description END,
	NULL ,
	p.[current_flag] ,
	p.[created] ,
	p.[created_by] 
FROM p_Treatment_Item o
	INNER JOIN p_Observation_Result p
	ON o.cpr_id = p.cpr_id
	AND o.treatment_id = p.treatment_id
	INNER JOIN p_Observation po
	ON p.cpr_id = po.cpr_id
	AND p.observation_sequence = po.observation_sequence
	INNER JOIN c_Location l
	ON p.location = l.location
	LEFT OUTER JOIN c_Unit u
	ON p.result_unit = u.unit_id
WHERE p.created_by = @ps_user_id
AND p.created >= @pdt_begin_date
AND p.created < @pdt_end_date
	

-- Observation_Results NOT tied to treatments
INSERT INTO @objects (	
	[cpr_id] ,
	[context_object] ,
	[object_key] ,
	[object_type] ,
	[description] ,
	[encounter_id] ,
	[begin_date] ,
	[end_date] ,
	[ordered_by] ,
	[status] ,
	[created] ,
	[created_by] ,
	[progress_sequence] ,
	[progress_encounter_id] ,
	[progress_user_id] ,
	[progress_date_time] ,
	[progress_type] ,
	[progress_key] ,
	[progress] ,
	[progress_attachment_id] ,
	[progress_current_flag] ,
	[progress_created] ,
	[progress_created_by] )
SELECT 
	o.[cpr_id] ,
	'Observation' ,
	o.observation_sequence ,
	'Observation' ,
	o.[description] ,
	o.[encounter_id] ,
	o.[created] ,
	o.[created] ,
	o.[observed_by] ,
	'Closed' ,
	o.[created] ,
	o.[created_by] ,
	p.[location_result_sequence] ,
	p.[encounter_id] ,
	p.[observed_by] ,
	p.[created] ,
	'Result' ,
	CASE p.location WHEN 'NA' THEN NULL ELSE l.description END ,
	p.[result]
		+ CASE WHEN p.result_value IS NULL THEN '' ELSE ' = ' + p.result_value END
		+ CASE WHEN u.description IS NULL THEN '' ELSE ' ' + u.description END,
	NULL ,
	p.[current_flag] ,
	p.[created] ,
	p.[created_by] 
FROM p_Observation o
	INNER JOIN p_Observation_Result p
	ON o.cpr_id = p.cpr_id
	AND o.observation_sequence = p.observation_sequence
	INNER JOIN c_Location l
	ON p.location = l.location
	LEFT OUTER JOIN c_Unit u
	ON p.result_unit = u.unit_id
WHERE p.observed_by = @ps_user_id
AND p.created >= @pdt_begin_date
AND p.created < @pdt_end_date
AND o.treatment_id IS NULL
UNION
SELECT 
	o.[cpr_id] ,
	'Observation' ,
	o.observation_sequence ,
	'Observation' ,
	o.[description] ,
	o.[encounter_id] ,
	o.[created] ,
	o.[created] ,
	o.[observed_by] ,
	'Closed' ,
	o.[created] ,
	o.[created_by] ,
	p.[location_result_sequence] ,
	p.[encounter_id] ,
	p.[observed_by] ,
	p.[created] ,
	'Result' ,
	CASE p.location WHEN 'NA' THEN NULL ELSE l.description END ,
	p.[result]
		+ CASE WHEN p.result_value IS NULL THEN '' ELSE ' = ' + p.result_value END
		+ CASE WHEN u.description IS NULL THEN '' ELSE ' ' + u.description END,
	NULL ,
	p.[current_flag] ,
	p.[created] ,
	p.[created_by] 
FROM p_Observation o
	INNER JOIN p_Observation_Result p
	ON o.cpr_id = p.cpr_id
	AND o.observation_sequence = p.observation_sequence
	INNER JOIN c_Location l
	ON p.location = l.location
	LEFT OUTER JOIN c_Unit u
	ON p.result_unit = u.unit_id
WHERE p.created_by = @ps_user_id
AND p.created >= @pdt_begin_date
AND p.created < @pdt_end_date
AND o.treatment_id IS NULL
	

RETURN
END

GO
GRANT SELECT ON [dbo].[fn_patient_object_progress_user] TO [cprsystem]
GO

