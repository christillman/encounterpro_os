
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
/****** Object:  Stored Procedure dbo.sp_reconcile_assessment_status    Script Date: 10/26/98 2:20:49 PM ******/
CREATE PROCEDURE sp_reconcile_assessment_status
AS
-- This procedure recalculates the p_Assessment.treatment_status field.
-- It is important that each site in a multi-site organization calculate
-- the same value, even if they don't share the same primary key values.
-- Therefore, we will get the close record with the latest date_time.
-- It is unlikely but possible that two close records have the same date_time
-- We will handle this by selecting the highest [user_id] from any records which
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
FROM p_Assessment_Progress a
JOIN #tmp_as_progress1 b ON a.cpr_id = b.cpr_id
	AND a.problem_id = b.problem_id
	AND a.progress_date_time = b.progress_date_time
WHERE a.progress_type in ('CLOSED', 'CANCELLED', 'MODIFIED')
AND b.progress_count = 1
-- Now isolate the records (presumably very few) which had more than one
-- progress record with the same date_time
SELECT cpr_id, problem_id, progress_date_time
INTO #tmp_as_progress2
FROM #tmp_as_progress1
WHERE progress_count > 1
-- Now get the highest [user_id] from all the records which match the
-- highest date_time
SELECT a.cpr_id, a.problem_id, max(a.user_id) as user_id
INTO #tmp_as_progress3
FROM p_Assessment_Progress a
JOIN #tmp_as_progress2 b ON a.cpr_id = b.cpr_id
	AND a.problem_id = b.problem_id
	AND a.progress_date_time = b.progress_date_time
WHERE a.progress_type in ('CLOSED', 'CANCELLED', 'MODIFIED')
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
FROM p_Assessment_Progress a
JOIN #tmp_as_progress2 b ON a.cpr_id = b.cpr_id
	AND a.problem_id = b.problem_id
	AND a.progress_date_time = b.progress_date_time
JOIN #tmp_as_progress3 c ON a.cpr_id = c.cpr_id
	AND a.problem_id = c.problem_id
	AND a.user_id = c.user_id
WHERE a.progress_type in ('CLOSED', 'CANCELLED', 'MODIFIED')
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
JOIN p_Assessment ON p_Assessment.cpr_id = t.cpr_id
AND p_Assessment.problem_id = t.problem_id

GO
GRANT EXECUTE
	ON [dbo].[sp_reconcile_assessment_status]
	TO [cprsystem]
GO

