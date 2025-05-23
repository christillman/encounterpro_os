﻿--EncounterPRO Open Source Project
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

-- Drop Function [dbo].[fn_patient_object_progress_current]
Print 'Drop Function [dbo].[fn_patient_object_progress_current]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_patient_object_progress_current]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_patient_object_progress_current]
GO

-- Create Function [dbo].[fn_patient_object_progress_current]
Print 'Create Function [dbo].[fn_patient_object_progress_current]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
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
	[progress] [nvarchar](max)  NULL ,
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

GO
GRANT SELECT
	ON [dbo].[fn_patient_object_progress_current]
	TO [cprsystem]
GO

