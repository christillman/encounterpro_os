CREATE PROCEDURE jmj_archive_workplan_batch 
AS

DECLARE @ll_patient_workplan_id int

DECLARE @workplans TABLE (
	patient_workplan_id int NOT NULL )


-- First fill the temp table with the workplans we're going to archive on this pass
INSERT INTO @workplans (
	patient_workplan_id)
SELECT TOP 1000 patient_workplan_id
FROM p_Patient_WP
WHERE workplan_type IN ('Patient', 'Treatment')
AND status IN ('Completed', 'Cancelled')
AND created < DATEADD(month, -6, getdate())

-- Now archive each workplan in the temp table
DECLARE lc_archive CURSOR LOCAL FAST_FORWARD FOR
	SELECT patient_workplan_id
	FROM @workplans

OPEN lc_archive
FETCH lc_archive INTO @ll_patient_workplan_id

WHILE @@FETCH_STATUS = 0
	BEGIN
	
	EXECUTE jmj_archive_workplan @pl_patient_workplan_id = @ll_patient_workplan_id
	IF @@ERROR <> 0
		RETURN -1
	
	FETCH lc_archive INTO @ll_patient_workplan_id
	END

CLOSE lc_archive
DEALLOCATE lc_archive

