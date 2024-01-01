
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_reconcile_treatment_status]
Print 'Drop Procedure [dbo].[sp_reconcile_treatment_status]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_reconcile_treatment_status]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_reconcile_treatment_status]
GO

-- Create Procedure [dbo].[sp_reconcile_treatment_status]
Print 'Create Procedure [dbo].[sp_reconcile_treatment_status]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.sp_reconcile_treatment_status    Script Date: 7/25/2000 8:44:04 AM ******/
CREATE PROCEDURE sp_reconcile_treatment_status
AS
-- This procedure recalculates the p_Treatment_Item.treatment_status field.
-- It is important that each site in a multi-site organization calculate
-- the same value, even if they don't share the same primary key values.
-- Therefore, we will get the close record with the latest date_time.
-- It is unlikely but possible that two close records have the same date_time
-- We will handle this by selecting the highest user_id from any records which -- tie on the date_time.
-- Create temp table to hold progress records created at the same time
CREATE TABLE #tmp_tr_prg_dups (
	cpr_id varchar(12),
	treatment_id int,
	treatment_progress_sequence int,
	created datetime,
	progress_date_time datetime,
	user_id varchar(24),
	dup_sequence int IDENTITY (1,1))
-- First get all the close progress records, with complete alternate keys
SELECT cpr_id, treatment_id, max(created) as created, count(*) as progress_count
INTO #tmp_tr_progress1
FROM p_Treatment_Progress
WHERE progress_type in ('CLOSED', 'CANCELLED', 'MODIFIED', 'COLLECTED', 'NEEDSAMPLE')
GROUP BY cpr_id, treatment_id
-- Now get the progress records where there is only one progress record
SELECT a.cpr_id, a.treatment_id, a.progress_type as treatment_status, a.progress_date_time as end_date, a.encounter_id
INTO #tmp_tr_progress_upd
FROM p_Treatment_Progress a
JOIN #tmp_tr_progress1 b ON a.cpr_id = b.cpr_id
	AND a.treatment_id = b.treatment_id
WHERE a.progress_type in ('CLOSED', 'CANCELLED', 'MODIFIED', 'COLLECTED', 'NEEDSAMPLE')
AND b.progress_count = 1
-- Now isolate the latest progress records from the treatments which have more than one progress record
INSERT INTO  #tmp_tr_prg_dups (
	cpr_id ,
	treatment_id,
	treatment_progress_sequence,
	created ,
	progress_date_time ,
	user_id )
SELECT	b.cpr_id,
		b.treatment_id,
		b.treatment_progress_sequence,
		b.created,
		b.progress_date_time,
		b.user_id
FROM #tmp_tr_progress1 a
JOIN p_Treatment_Progress b ON a.cpr_id = b.cpr_id
	AND a.treatment_id = b.treatment_id
	AND a.created = b.created
WHERE a.progress_count > 1
AND b.progress_type in ('CLOSED', 'CANCELLED', 'MODIFIED', 'COLLECTED', 'NEEDSAMPLE')
ORDER BY b.cpr_id, b.treatment_id, b.progress_date_time desc, b.user_id
-- Get only one progress record for each treatment from ordered list created above
SELECT cpr_id, treatment_id, min(dup_sequence) as dup_sequence
INTO #tmp_tr_nodups
FROM #tmp_tr_prg_dups
GROUP BY cpr_id, treatment_id
-- Now add the isolated progress records to the existing list
INSERT INTO #tmp_tr_progress_upd (
	cpr_id,
	treatment_id,
	treatment_status,
	end_date,
	encounter_id)	
SELECT a.cpr_id,
	a.treatment_id,
	a.progress_type as treatment_status,
	a.progress_date_time as end_date,
	a.encounter_id
FROM p_Treatment_Progress a
JOIN #tmp_tr_prg_dups b ON a.cpr_id = b.cpr_id
	AND a.treatment_id = b.treatment_id
	AND a.treatment_progress_sequence = b.treatment_progress_sequence
JOIN #tmp_tr_nodups c ON a.cpr_id = c.cpr_id
	AND a.treatment_id = c.treatment_id
WHERE a.progress_type in ('CLOSED', 'CANCELLED', 'MODIFIED', 'COLLECTED', 'NEEDSAMPLE')
AND b.dup_sequence = c.dup_sequence
-- Now update p_Treatment_Item
UPDATE p_Treatment_Item
SET	treatment_status = NULL,
	end_date = NULL,
	close_encounter_id = NULL
UPDATE p_Treatment_Item
SET	treatment_status = t.treatment_status,
	end_date = t.end_date,
	close_encounter_id = t.encounter_id
FROM #tmp_tr_progress_upd t
JOIN p_Treatment_Item ON p_Treatment_Item.cpr_id = t.cpr_id
	AND p_Treatment_Item.treatment_id = t.treatment_id

GO
GRANT EXECUTE
	ON [dbo].[sp_reconcile_treatment_status]
	TO [cprsystem]
GO

