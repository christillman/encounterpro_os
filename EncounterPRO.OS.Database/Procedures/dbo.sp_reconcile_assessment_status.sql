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

-- Drop Procedure [dbo].[sp_reconcile_assessment_status]
Print 'Drop Procedure [dbo].[sp_reconcile_assessment_status]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_reconcile_assessment_status]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_reconcile_assessment_status]
GO

-- Create Procedure [dbo].[sp_reconcile_assessment_status]
Print 'Create Procedure [dbo].[sp_reconcile_assessment_status]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.sp_reconcile_assessment_status    Script Date: 7/25/2000 8:44:17 AM ******/
/****** Object:  Stored Procedure dbo.sp_reconcile_assessment_status    Script Date: 2/16/99 12:01:05 PM ******/
/****** Object:  Stored Procedure dbo.sp_reconcile_assessment_status    Script Date: 10/26/98 2:20:49 PM ******/
CREATE PROCEDURE sp_reconcile_assessment_status
AS
-- This procedure recalculates the p_Assessment.treatment_status field.
-- It is important that each site in a multi-site organization calculate
-- the same value, even if they don't share the same primary key values.
-- Therefore, we will get the close record with the latest date_time.
-- It is unlikely but possible that two close records have the same date_time
-- We will handle this by selecting the highest user_id from any records which
-- tie on the date_time.
-- First get all the close progress records, with complete alternate keys
SELECT cpr_id, problem_id, max(progress_date_time) as progress_date_time, count(*) as progress_count
INTO #tmp_as_progress1
FROM p_Assessment_Progress
WHERE progress_type in ('CLOSED', 'CANCELLED', 'MODIFIED')
GROUP BY cpr_id, problem_id
-- Now get the records with the highest date_time and only one record
SELECT a.cpr_id, a.problem_id, a.progress_type as assessment_status, a.progress_date_time as end_date, a.encounter_id
INTO #tmp_as_progress_upd
FROM p_Assessment_Progress a, #tmp_as_progress1 b
WHERE a.cpr_id = b.cpr_id
AND a.problem_id = b.problem_id
AND a.progress_type in ('CLOSED', 'CANCELLED', 'MODIFIED')
AND a.progress_date_time = b.progress_date_time
AND b.progress_count = 1
-- Now isolate the records (presumably very few) which had more than one
-- progress record with the same date_time
SELECT cpr_id, problem_id, progress_date_time
INTO #tmp_as_progress2
FROM #tmp_as_progress1
WHERE progress_count > 1
-- Now get the highest user_id from all the records which match the
-- highest date_time
SELECT a.cpr_id, a.problem_id, max(a.user_id) as user_id
INTO #tmp_as_progress3
FROM p_Assessment_Progress a, #tmp_as_progress2 b
WHERE a.cpr_id = b.cpr_id
AND a.problem_id = b.problem_id
AND a.progress_type in ('CLOSED', 'CANCELLED', 'MODIFIED')
AND a.progress_date_time = b.progress_date_time
GROUP BY a.cpr_id, a.problem_id
-- Now get the records which win the date_time and the highest user_id
INSERT INTO #tmp_as_progress_upd
	(cpr_id,
	problem_id,
	assessment_status,
	end_date,
	encounter_id)
SELECT a.cpr_id,
	a.problem_id,
	a.progress_type as assessment_status,
	a.progress_date_time as end_date,
	a.encounter_id
FROM p_Assessment_Progress a,
	#tmp_as_progress2 b,
	#tmp_as_progress3 c
WHERE a.cpr_id = b.cpr_id
AND a.problem_id = b.problem_id
AND a.cpr_id = c.cpr_id
AND a.problem_id = c.problem_id
AND a.progress_type in ('CLOSED', 'CANCELLED', 'MODIFIED')
AND a.progress_date_time = b.progress_date_time
AND a.user_id = c.user_id
-- Now update p_Assessment
UPDATE p_Assessment
SET	assessment_status = NULL,
	end_date = NULL,
	close_encounter_id = NULL
UPDATE p_Assessment
SET	assessment_status = t.assessment_status,
	end_date = t.end_date,
	close_encounter_id = t.encounter_id
FROM #tmp_as_progress_upd t
WHERE p_Assessment.cpr_id = t.cpr_id
AND p_Assessment.problem_id = t.problem_id

GO
GRANT EXECUTE
	ON [dbo].[sp_reconcile_assessment_status]
	TO [cprsystem]
GO

