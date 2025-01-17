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

-- Drop Procedure [dbo].[sp_remove_attachment]
Print 'Drop Procedure [dbo].[sp_remove_attachment]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_remove_attachment]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_remove_attachment]
GO

-- Create Procedure [dbo].[sp_remove_attachment]
Print 'Create Procedure [dbo].[sp_remove_attachment]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_remove_attachment (
	@ps_cpr_id varchar(12),
	@pl_attachment_id int,
	@ps_user_id varchar(24),
	@ps_created_by varchar(24),
	@ps_context_object varchar(24) = NULL,
	@pl_object_key int = NULL)
AS

-- If a patient attachment exists, remove it
IF @ps_context_object = 'Patient' 
	OR EXISTS(	SELECT 1
				FROM p_Patient_Progress p
				WHERE cpr_id = @ps_cpr_id
				AND attachment_id = @pl_attachment_id )
	INSERT INTO p_Patient_Progress (
		cpr_id,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		progress_key,
		patient_workplan_item_id,
		risk_level,
		created,
		created_by)
	SELECT cpr_id,
		encounter_id,
		@ps_user_id,
		progress_date_time,
		progress_type,
		progress_key,
		patient_workplan_item_id,
		risk_level,
		dbo.get_client_datetime(),
		@ps_created_by
	FROM p_Patient_Progress
	WHERE cpr_id = @ps_cpr_id
	AND attachment_id = @pl_attachment_id
	AND current_flag = 'Y'
	
-- If an encounter attachment exists, remove it
IF @ps_context_object = 'Encounter'
	OR EXISTS(	SELECT 1
				FROM p_Patient_Encounter_Progress p
				WHERE cpr_id = @ps_cpr_id
				AND attachment_id = @pl_attachment_id )
	INSERT INTO p_Patient_Encounter_Progress (
		cpr_id,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		progress_key,
		patient_workplan_item_id,
		risk_level,
		created,
		created_by)
	SELECT cpr_id,
		encounter_id,
		@ps_user_id,
		progress_date_time,
		progress_type,
		progress_key,
		patient_workplan_item_id,
		risk_level,
		dbo.get_client_datetime(),
		@ps_created_by
	FROM p_Patient_Encounter_Progress
	WHERE cpr_id = @ps_cpr_id
	AND attachment_id = @pl_attachment_id
	AND current_flag = 'Y'
	AND (@pl_object_key IS NULL OR encounter_id = @pl_object_key)
	
-- If a patient attachment exists, remove it
IF @ps_context_object = 'Assessment' 
	OR EXISTS(	SELECT 1
				FROM p_Assessment_Progress p
				WHERE cpr_id = @ps_cpr_id
				AND attachment_id = @pl_attachment_id )
	INSERT INTO p_Assessment_Progress (
		cpr_id,
		problem_id,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		progress_key,
		patient_workplan_item_id,
		risk_level,
		created,
		created_by)
	SELECT cpr_id,
		problem_id,
		encounter_id,
		@ps_user_id,
		progress_date_time,
		progress_type,
		progress_key,
		patient_workplan_item_id,
		risk_level,
		dbo.get_client_datetime(),
		@ps_created_by
	FROM p_Assessment_Progress
	WHERE cpr_id = @ps_cpr_id
	AND attachment_id = @pl_attachment_id
	AND current_flag = 'Y'
	AND (@pl_object_key IS NULL OR encounter_id = @pl_object_key)
	
-- If a patient attachment exists, remove it
IF @ps_context_object = 'Treatment' 
	OR EXISTS(	SELECT 1
				FROM p_Treatment_Progress p
				WHERE cpr_id = @ps_cpr_id
				AND attachment_id = @pl_attachment_id )
	INSERT INTO p_Treatment_Progress (
		cpr_id,
		treatment_id,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		progress_key,
		patient_workplan_item_id,
		risk_level,
		created,
		created_by)
	SELECT cpr_id,
		treatment_id,
		encounter_id,
		@ps_user_id,
		progress_date_time,
		progress_type,
		progress_key,
		patient_workplan_item_id,
		risk_level,
		dbo.get_client_datetime(),
		@ps_created_by
	FROM p_Treatment_Progress
	WHERE cpr_id = @ps_cpr_id
	AND attachment_id = @pl_attachment_id
	AND current_flag = 'Y'
	AND (@pl_object_key IS NULL OR encounter_id = @pl_object_key)
	
-- If a patient attachment exists, remove it
IF @ps_context_object = 'Observation' 
	OR EXISTS(	SELECT 1
				FROM p_Observation_Comment p
				WHERE cpr_id = @ps_cpr_id
				AND attachment_id = @pl_attachment_id )
	INSERT INTO p_Observation_Comment (
		cpr_id,
		observation_sequence,
		encounter_id,
		observation_id,
		user_id,
		comment_date_time,
		comment_type,
		comment_title,
		created,
		created_by)
	SELECT cpr_id,
		observation_sequence,
		encounter_id,
		observation_id,
		@ps_user_id,
		comment_date_time,
		comment_type,
		comment_title,
		dbo.get_client_datetime(),
		@ps_created_by
	FROM p_Observation_Comment
	WHERE cpr_id = @ps_cpr_id
	AND attachment_id = @pl_attachment_id
	AND current_flag = 'Y'
	AND (@pl_object_key IS NULL OR encounter_id = @pl_object_key)
		

GO
GRANT EXECUTE
	ON [dbo].[sp_remove_attachment]
	TO [cprsystem]
GO

