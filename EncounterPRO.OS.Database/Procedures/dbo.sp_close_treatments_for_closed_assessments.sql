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

-- Drop Procedure [dbo].[sp_close_treatments_for_closed_assessments]
Print 'Drop Procedure [dbo].[sp_close_treatments_for_closed_assessments]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_close_treatments_for_closed_assessments]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_close_treatments_for_closed_assessments]
GO

-- Create Procedure [dbo].[sp_close_treatments_for_closed_assessments]
Print 'Create Procedure [dbo].[sp_close_treatments_for_closed_assessments]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_close_treatments_for_closed_assessments
	(
	@ps_cpr_id varchar(12) = NULL)
AS

DECLARE @ls_cpr_id varchar(12) ,
		@ll_problem_id int ,
		@ll_treatment_id int ,
		@ls_progress_type varchar(24),
		@ll_encounter_id int,
		@ls_user_id varchar(24),
		@ls_created_by varchar(24)
	
DECLARE @close_treatments TABLE (
	cpr_id varchar(12) NOT NULL,
	problem_id int NOT NULL,
	treatment_id int NOT NULL,
	progress_type varchar(24) NOT NULL ,
	encounter_id int NULL,
	user_id varchar(24) NOT NULL,
	created_by varchar(24) NOT NULL )

-- Get a list of the treatments still open for closed assessments
INSERT INTO @close_treatments (
	cpr_id ,
	problem_id ,
	treatment_id,
	progress_type,
	encounter_id,
	user_id,
	created_by )
SELECT a.cpr_id,
	a.problem_id,
	a.treatment_id,
	p.assessment_status,
	p.close_encounter_id,
	'#SYSTEM',
	'#SYSTEM'
FROM p_Assessment p
	INNER JOIN p_Assessment_Treatment a
	ON p.cpr_id = a.cpr_id
	AND p.problem_id = a.problem_id
	INNER JOIN p_Treatment_Item t
	ON a.cpr_id = t.cpr_id
	AND a.treatment_id = t.treatment_id
WHERE p.assessment_status IN ('Closed', 'Cancelled')
AND p.current_flag = 'Y'
AND ISNULL(t.treatment_status, 'Open') = 'Open'
AND (@ps_cpr_id IS NULL OR p.cpr_id = @ps_cpr_id)

-- Delete the treatments which are associated with another open assessment
DELETE t
FROM @close_treatments t
	INNER JOIN p_Assessment_Treatment a
	ON t.cpr_id = a.cpr_id
	AND t.treatment_id = a.treatment_id
	INNER JOIN p_Assessment p
	ON a.cpr_id = p.cpr_id
	AND a.problem_id = p.problem_id
WHERE a.problem_id <> t.problem_id
AND p.current_flag = 'Y'
AND ISNULL(p.assessment_status, 'Open') = 'Open'

DECLARE lc_treatments CURSOR LOCAL FAST_FORWARD FOR
	SELECT cpr_id ,
			problem_id ,
			treatment_id,
			encounter_id,
			user_id,
			created_by
	FROM @close_treatments

OPEN lc_treatments

FETCH lc_treatments INTO @ls_cpr_id, @ll_problem_id, @ll_treatment_id, @ll_encounter_id, @ls_user_id, @ls_created_by

WHILE @@FETCH_STATUS = 0
	BEGIN
	-- Close the treatment
	EXECUTE sp_set_treatment_progress
				@ps_cpr_id = @ls_cpr_id,
				@pl_treatment_id = @ll_treatment_id,
				@pl_encounter_id = @ll_encounter_id,
				@ps_progress_type = 'Closed',
				@ps_user_id = @ls_user_id,
				@ps_created_by = @ls_created_by
	
	FETCH lc_treatments INTO @ls_cpr_id, @ll_problem_id, @ll_treatment_id, @ll_encounter_id, @ls_user_id, @ls_created_by
	END

CLOSE lc_treatments
DEALLOCATE lc_treatments

GO
GRANT EXECUTE
	ON [dbo].[sp_close_treatments_for_closed_assessments]
	TO [cprsystem]
GO

