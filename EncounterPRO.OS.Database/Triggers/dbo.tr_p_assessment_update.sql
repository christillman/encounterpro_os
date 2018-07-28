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

-- Drop Trigger [dbo].[tr_p_assessment_update]
Print 'Drop Trigger [dbo].[tr_p_assessment_update]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_p_assessment_update]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_p_assessment_update]
GO

-- Create Trigger [dbo].[tr_p_assessment_update]
Print 'Create Trigger [dbo].[tr_p_assessment_update]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_p_assessment_update ON dbo.p_Assessment
FOR UPDATE
AS

IF @@ROWCOUNT = 0
	RETURN

DECLARE @ls_cpr_id varchar(12),
		@ll_problem_id int,
		@ll_treatment_id int,
		@ll_encounter_id int,
		@ls_user_id varchar(24),
		@ls_created_by varchar(24),
		@ll_count int

-- Get every treatment that is still open and linked to an assessment that is closing
DECLARE lc_treatments CURSOR LOCAL FAST_FORWARD FOR
	SELECT i.cpr_id, i.problem_id, t.treatment_id, i.close_encounter_id
	FROM inserted i
		INNER JOIN deleted d
		ON i.cpr_id = d.cpr_id
		AND i.problem_id = d.problem_id
		AND i.diagnosis_sequence = d.diagnosis_sequence
		INNER JOIN p_Assessment_Treatment pat
		ON i.cpr_id = pat.cpr_id
		AND i.problem_id = pat.problem_id
		INNER JOIN p_Treatment_Item t
		ON pat.cpr_id = t.cpr_id
		AND pat.treatment_id = t.treatment_id
	WHERE ISNULL(d.assessment_status, 'OPEN') = 'OPEN'
	AND ISNULL(i.assessment_status, 'OPEN') = 'CLOSED'
	AND ISNULL(t.treatment_status, 'OPEN') = 'OPEN'

OPEN lc_treatments

FETCH lc_treatments INTO @ls_cpr_id, @ll_problem_id, @ll_treatment_id, @ll_encounter_id
WHILE @@FETCH_STATUS = 0
	BEGIN
	-- Get who closed the assessment
	SELECT @ls_user_id = user_id,
			@ls_created_by = ISNULL(created_by, '#SYSTEM')
	FROM p_Assessment_Progress
	WHERE cpr_id = @ls_cpr_id
	AND problem_id = @ll_problem_id
	AND assessment_progress_sequence = (SELECT MAX(assessment_progress_sequence) 
										FROM p_Assessment_Progress 
										WHERE cpr_id = @ls_cpr_id 
										AND problem_id = @ll_problem_id
										AND progress_type = 'Closed')

	IF @@ROWCOUNT <> 1
		BEGIN
		SET @ls_user_id = '#SYSTEM'
		SET @ls_created_by = '#SYSTEM'
		END

	-- Make sure the treatment isn't associated with an other open assessments
	SELECT @ll_count = count(*)
	FROM p_Assessment_Treatment pat
		INNER JOIN p_Assessment a
		ON pat.cpr_id = a.cpr_id
		AND pat.problem_id = a.problem_id
	WHERE pat.cpr_id = @ls_cpr_id
	AND pat.treatment_id = @ll_treatment_id
	AND pat.problem_id <> @ll_problem_id
	AND a.current_flag = 'Y'
	AND ISNULL(a.assessment_status, 'OPEN') = 'OPEN'

	IF @ll_count = 0
		BEGIN
		-- Close the treatment
		EXECUTE sp_set_treatment_progress
					@ps_cpr_id = @ls_cpr_id,
					@pl_treatment_id = @ll_treatment_id,
					@pl_encounter_id = @ll_encounter_id,
					@ps_progress_type = 'Closed',
					@ps_user_id = @ls_user_id,
					@ps_created_by = @ls_created_by
		END

	FETCH lc_treatments INTO @ls_cpr_id, @ll_problem_id, @ll_treatment_id, @ll_encounter_id
	END

CLOSE lc_treatments
DEALLOCATE lc_treatments


GO

