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

-- Drop Procedure [dbo].[sp_set_assessment_progress]
Print 'Drop Procedure [dbo].[sp_set_assessment_progress]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_set_assessment_progress]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_set_assessment_progress]
GO

-- Create Procedure [dbo].[sp_set_assessment_progress]
Print 'Create Procedure [dbo].[sp_set_assessment_progress]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_set_assessment_progress (
	@ps_cpr_id varchar(12),
	@pl_problem_id integer,
	@pl_encounter_id integer,
	@pdt_progress_date_time datetime = NULL,
	@pi_diagnosis_sequence smallint = NULL,
	@ps_progress_type varchar(24),
	@ps_progress_key varchar(40) = NULL,
	@ps_progress varchar(max) = NULL,
	@ps_severity varchar(12) = NULL,
	@pl_attachment_id integer = NULL,
	@pl_patient_workplan_item_id integer = NULL,
	@pl_risk_level integer = NULL,
	@ps_user_id varchar(24),
	@ps_created_by varchar(24) )
AS

DECLARE @ls_progress_value varchar(40)

IF @pdt_progress_date_time IS NULL
	BEGIN
	IF @ps_progress_type = 'Property'
		BEGIN
		-- If the progress_date_time is null and the progress_type is 'Property' then we want to
		-- assume the previous property progress_date_time for the same key
		SELECT @pdt_progress_date_time = max(progress_date_time)
		FROM p_Assessment_Progress
		WHERE cpr_id = @ps_cpr_id
		AND problem_id = @pl_problem_id
		AND progress_type = @ps_progress_type
		AND progress_key = @ps_progress_key
		END
	
	-- If it's still null, then if it's a realtime encounter, then use the current datetime.
	-- Otherwise, use the encounter date
	IF @pdt_progress_date_time IS NULL
		SET @pdt_progress_date_time = dbo.get_client_datetime()
	END


IF @pi_diagnosis_sequence IS NULL
	SELECT @pi_diagnosis_sequence = max(diagnosis_sequence)
	FROM p_Assessment
	WHERE cpr_id = @ps_cpr_id
	AND problem_id = @pl_problem_id

IF LEN(CONVERT(varchar(50), @ps_progress)) <= 40
	BEGIN
	SELECT @ls_progress_value = CONVERT(varchar(40), @ps_progress)

	INSERT INTO p_Assessment_Progress(
		cpr_id,
		problem_id,
		encounter_id,
		user_id,
		progress_date_time,
		diagnosis_sequence,
		progress_type,
		progress_key,
		progress_value,
		severity,
		attachment_id,
		patient_workplan_item_id,
		risk_level,
		created,
		created_by)
	VALUES (
		@ps_cpr_id,
		@pl_problem_id,
		@pl_encounter_id,
		@ps_user_id,
		@pdt_progress_date_time,
		@pi_diagnosis_sequence,
		@ps_progress_type,
		@ps_progress_key,
		@ls_progress_value,
		@ps_severity,
		@pl_attachment_id,
		@pl_patient_workplan_item_id,
		@pl_risk_level,
		dbo.get_client_datetime(),
		@ps_created_by )
	END
ELSE
	BEGIN
	INSERT INTO p_Assessment_Progress(
		cpr_id,
		problem_id,
		encounter_id,
		user_id,
		progress_date_time,
		diagnosis_sequence,
		progress_type,
		progress_key,
		progress,
		severity,
		attachment_id,
		patient_workplan_item_id,
		risk_level,
		created,
		created_by)
	VALUES (
		@ps_cpr_id,
		@pl_problem_id,
		@pl_encounter_id,
		@ps_user_id,
		@pdt_progress_date_time,
		@pi_diagnosis_sequence,
		@ps_progress_type,
		@ps_progress_key,
		@ps_progress,
		@ps_severity,
		@pl_attachment_id,
		@pl_patient_workplan_item_id,
		@pl_risk_level,
		dbo.get_client_datetime(),
		@ps_created_by )
	END


-- Now check to see if this is an attachment, and, if so, what folder it should go in	
DECLARE	@ls_folder varchar(40),
		@ps_context_object_type varchar(40)

IF @pl_attachment_id IS NOT NULL
	BEGIN
	SELECT @ps_context_object_type = assessment_type
	FROM p_Assessment
	WHERE cpr_id = @ps_cpr_id
	AND problem_id = @pl_problem_id
	AND diagnosis_sequence = @pi_diagnosis_sequence
	
	SELECT @ls_folder = min(folder)
	FROM c_Folder
	WHERE context_object = 'Assessment'
	AND context_object_type = @ps_context_object_type

	IF @ls_folder IS NOT NULL
		UPDATE p_Attachment
		SET attachment_folder = @ls_folder
		WHERE attachment_id = @pl_attachment_id
		AND attachment_folder IS NULL

	END	

GO
GRANT EXECUTE
	ON [dbo].[sp_set_assessment_progress]
	TO [cprsystem]
GO

