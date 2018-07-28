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

-- Drop Procedure [dbo].[sp_assessment_progress_status]
Print 'Drop Procedure [dbo].[sp_assessment_progress_status]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_assessment_progress_status]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_assessment_progress_status]
GO

-- Create Procedure [dbo].[sp_assessment_progress_status]
Print 'Create Procedure [dbo].[sp_assessment_progress_status]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_assessment_progress_status
	(
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@pl_problem_id int,
	@pl_total_count int OUTPUT,
	@pl_this_encounter_count int OUTPUT
	)
AS

DECLARE @prg TABLE (
	progress_type varchar(24) NULL,
	progress_key varchar(40) NULL,
	progress_date_time datetime NULL,
	encounter_id int NULL,
	assessment_progress_sequence int NULL)

INSERT INTO @prg (
	progress_type ,
	progress_key ,
	progress_date_time ,
	encounter_id,
	assessment_progress_sequence)
SELECT p.progress_type ,
	p.progress_key ,
	p.progress_date_time ,
	min(encounter_id) as encounter_id,
	max(p.assessment_progress_sequence) as assessment_progress_sequence
FROM p_Assessment_Progress p
	INNER JOIN p_Assessment a
	ON p.cpr_id = a.cpr_id
	AND p.problem_id = a.problem_id
	AND p.diagnosis_sequence = a.diagnosis_sequence
	INNER JOIN c_Assessment_Type_Progress_Type t
	ON a.assessment_type = t.assessment_type
	AND p.progress_type = t.progress_type
WHERE p.cpr_id = @ps_cpr_id
AND p.problem_id = @pl_problem_id
GROUP BY p.progress_type ,
	p.progress_key ,
	p.progress_date_time

SELECT @pl_total_count = count(*)
FROM @prg t
	INNER JOIN p_Assessment_Progress p
	ON t.assessment_progress_sequence = p.assessment_progress_sequence
WHERE p.cpr_id = @ps_cpr_id
AND p.problem_id = @pl_problem_id
AND (progress_value IS NOT NULL OR progress IS NOT NULL)

SELECT @pl_this_encounter_count = count(*)
FROM @prg t
	INNER JOIN p_Assessment_Progress p
	ON t.assessment_progress_sequence = p.assessment_progress_sequence
WHERE p.cpr_id = @ps_cpr_id
AND p.problem_id = @pl_problem_id
AND t.encounter_id = @pl_encounter_id
AND (progress_value IS NOT NULL OR progress IS NOT NULL)

GO
GRANT EXECUTE
	ON [dbo].[sp_assessment_progress_status]
	TO [cprsystem]
GO

