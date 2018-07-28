/****** Object:  Stored Procedure dbo.sp_get_treatment_status    Script Date: 7/25/2000 8:43:56 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_treatment_status    Script Date: 2/16/99 12:00:56 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_treatment_status    Script Date: 10/26/98 2:20:41 PM ******/
CREATE PROCEDURE sp_get_treatment_status (
	@ps_cpr_id varchar(12),
	@pl_treatment_id integer,
	@pl_encounter_id integer,
	@ps_status varchar(12) OUTPUT)
AS
DECLARE @ldt_encounter_date datetime,
	@ll_sequence integer
SELECT @ldt_encounter_date = encounter_date
FROM p_Patient_Encounter
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id
SELECT @ll_sequence = max(treatment_progress_sequence)
FROM p_Treatment_Progress
WHERE cpr_id = @ps_cpr_id
AND treatment_id = @pl_treatment_id
AND progress_type IN ('CLOSED', 'CANCELLED', 'MODIFIED')
AND (progress_date_time <= @ldt_encounter_date
OR encounter_id = @pl_encounter_id)
IF @ll_sequence IS NOT NULL
	SELECT @ps_status = progress_type
	FROM p_Treatment_Progress
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @pl_treatment_id
	AND treatment_progress_sequence = @ll_sequence
ELSE
	SELECT @ps_status = NULL

