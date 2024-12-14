--EncounterPRO Open Source Project
--
--Copyright 2010-2011 The EncounterPRO Foundation, Inc.
--
--This program is free software: you can redistribute it and/or modify it under the terms of 
--the GNU Affero General Public License as published by the Free Software Foundation, either 
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Affero General Public License for more details.
--
--You should have received a copy of the GNU Affero General Public License along with this 
--program. If not, see http://www.gnu.org/licenses.
--
--EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero 
--General Public License version 3, or any later version. As such, linking the Project 
--statically or dynamically with other components is making a combined work based on the 
--Project. Thus, the terms and conditions of the GNU Affero General Public License version 3, 
--or any later version, cover the whole combination.
--
--However, as an additional permission, the copyright holders of EncounterPRO Open Source 
--Project give you permission to link the Project with independent components, regardless of 
--the license terms of these independent components, provided that all of the following are true:
--
--1. All access from the independent component to persisted data which resides
--   inside any EncounterPRO Open Source data store (e.g. SQL Server database) 
--   be made through a publically available database driver (e.g. ODBC, SQL 
--   Native Client, etc) or through a service which itself is part of The Project.
--2. The independent component does not create or rely on any code or data 
--   structures within the EncounterPRO Open Source data store unless such 
--   code or data structures, and all code and data structures referred to 
--   by such code or data structures, are themselves part of The Project.
--3. The independent component either a) runs locally on the user's computer,
--   or b) is linked to at runtime by The Project’s Component Manager object 
--   which in turn is called by code which itself is part of The Project.
--
--An independent component is a component which is not derived from or based on the Project.
--If you modify the Project, you may extend this additional permission to your version of 
--the Project, but you are not obligated to do so. If you do not wish to do so, delete this 
--additional permission statement from your version.
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_patient_object_progress_in_encounter]
Print 'Drop Function [dbo].[fn_patient_object_progress_in_encounter]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_patient_object_progress_in_encounter]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_patient_object_progress_in_encounter]
GO

-- Create Function [dbo].[fn_patient_object_progress_in_encounter]
Print 'Create Function [dbo].[fn_patient_object_progress_in_encounter]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_patient_object_progress_in_encounter (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int)

RETURNS @objects TABLE (
	[cpr_id] [varchar] (12)  NOT NULL ,
	[context_object] [varchar] (24) NOT NULL ,
	[object_key] [int] NOT NULL ,
	[object_type] [varchar] (24) NOT NULL ,
	[description] [varchar] (255) NULL ,
	[encounter_id] [int] NULL ,
	[begin_date] [datetime] NOT NULL ,
	[end_date] [datetime] NULL ,
	[ordered_by] [varchar] (24)  NULL ,
	[status] [varchar] (12) NOT NULL ,
	[created] [datetime] NULL ,
	[created_by] [varchar] (24)  NULL ,
	[progress_sequence] [int] NOT NULL ,
	[progress_encounter_id] [int] NULL ,
	[progress_user_id] [varchar] (24)  NOT NULL ,
	[progress_date_time] [datetime] NOT NULL ,
	[progress_type] [varchar] (24)  NULL ,
	[progress_key] [varchar] (48)  NULL ,
	[progress] [varchar] (128)  NULL ,
	[progress_attachment_id] [int] NULL ,
	[progress_current_flag] [char] (1) NOT NULL ,
	[progress_created] [datetime] NULL ,
	[progress_created_by] [varchar] (24)  NULL )

AS

BEGIN


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
FROM p_Patient_progress p
	INNER JOIN p_Patient o
	ON o.cpr_id = p.cpr_id
WHERE p.cpr_id = @ps_cpr_id
AND p.encounter_id = @pl_encounter_id

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
FROM p_Patient_Encounter_Progress p
	INNER JOIN p_Patient_Encounter o
	ON o.cpr_id = p.cpr_id
	AND o.encounter_id = p.encounter_id
WHERE p.cpr_id = @ps_cpr_id
AND p.encounter_id = @pl_encounter_id


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
FROM p_Assessment_Progress p
	INNER JOIN p_Assessment o
	ON o.cpr_id = p.cpr_id
	AND o.problem_id = p.problem_id
WHERE p.cpr_id = @ps_cpr_id
AND p.encounter_id = @pl_encounter_id

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
FROM p_Treatment_Progress p
	INNER JOIN p_Treatment_Item o
	ON o.cpr_id = p.cpr_id
	AND o.treatment_id = p.treatment_id
WHERE p.cpr_id = @ps_cpr_id
AND p.encounter_id = @pl_encounter_id


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
FROM p_Observation_Result p
	INNER JOIN p_Treatment_Item o
	ON o.cpr_id = p.cpr_id
	AND o.treatment_id = p.treatment_id
	INNER JOIN p_Observation po
	ON p.cpr_id = po.cpr_id
	AND p.observation_sequence = po.observation_sequence
	INNER JOIN c_Location l
	ON p.location = l.location
	LEFT OUTER JOIN c_Unit u
	ON p.result_unit = u.unit_id
WHERE p.cpr_id = @ps_cpr_id
AND p.encounter_id = @pl_encounter_id
	

-- Observation_Comments tied to treatments
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
	p.[observation_comment_id] ,
	p.[encounter_id] ,
	p.[user_id] ,
	p.[created] ,
	p.comment_type ,
	p.comment_title ,
	CASE WHEN p.short_comment Is Null THEN CAST(p.[comment] AS varchar(128)) ELSE short_comment END ,
	p.attachment_id ,
	p.[current_flag] ,
	p.[created] ,
	p.[created_by] 
FROM p_Observation_Comment p
	INNER JOIN p_Treatment_Item o
	ON o.cpr_id = p.cpr_id
	AND o.treatment_id = p.treatment_id
WHERE p.cpr_id = @ps_cpr_id
AND p.encounter_id = @pl_encounter_id


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
FROM p_Observation_Result p
	INNER JOIN p_Observation o
	ON o.cpr_id = p.cpr_id
	AND o.observation_sequence = p.observation_sequence
	INNER JOIN c_Location l
	ON p.location = l.location
	LEFT OUTER JOIN c_Unit u
	ON p.result_unit = u.unit_id
WHERE p.cpr_id = @ps_cpr_id
AND p.encounter_id = @pl_encounter_id
AND p.treatment_id IS NULL
	

-- Observation_Comments NOT tied to treatments
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
	p.[observation_comment_id] ,
	p.[encounter_id] ,
	p.[user_id] ,
	p.[created] ,
	p.comment_type ,
	p.comment_title ,
	CASE WHEN p.short_comment Is Null THEN CAST(p.[comment] AS varchar(128)) ELSE short_comment END ,
	p.attachment_id ,
	p.[current_flag] ,
	p.[created] ,
	p.[created_by] 
FROM p_Observation_Comment p
	INNER JOIN p_Observation o
	ON o.cpr_id = p.cpr_id
	AND o.observation_sequence = p.observation_sequence
WHERE p.cpr_id = @ps_cpr_id
AND p.encounter_id = @pl_encounter_id
AND p.treatment_id IS NULL



RETURN
END

GO
GRANT SELECT ON [dbo].[fn_patient_object_progress_in_encounter] TO [cprsystem]
GO

