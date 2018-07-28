CREATE FUNCTION fn_count_progress_in_encounter (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@ps_context_object varchar(12),
	@pl_object_key int,
	@ps_progress_type varchar(24) )

RETURNS int

AS
BEGIN

-- This function counts the number of attachments for the specified context object within the specified encounter.  


DECLARE @ll_count int,
		@ldt_discharge_date datetime,
		@ll_prev_encounter_id int,
		@ldt_prev_discharge_date datetime,
		@ls_in_office_flag char(1)

-- As a temporary measure, we're going to count all the progress for the object.
SET @ll_count = dbo.fn_count_progress_for_object (	@ps_cpr_id ,
													@ps_context_object ,
													@pl_object_key ,
													@ps_progress_type )
RETURN @ll_count


SET @ll_count = 0

SELECT @ldt_discharge_date = ISNULL(discharge_date, CAST('1/1/2100' AS datetime))
FROM p_Patient_Encounter
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id
IF @@ROWCOUNT = 0
	RETURN -1

SELECT @ll_prev_encounter_id = max(encounter_id)
FROM p_Patient_Encounter
WHERE cpr_id = @ps_cpr_id
AND encounter_id < @pl_encounter_id
AND encounter_status <> 'CANCELED'
IF @ll_prev_encounter_id IS NULL
	SET @ldt_prev_discharge_date = NULL
ELSE
	BEGIN
	SELECT @ldt_prev_discharge_date = discharge_date
	FROM p_Patient_Encounter
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @ll_prev_encounter_id
	IF @@ROWCOUNT = 0
		SET @ldt_prev_discharge_date = NULL
	END


IF @ps_context_object = 'Patient'
	BEGIN
	SELECT @ll_count = count(*)
	FROM p_Patient_Progress
	WHERE cpr_id = @ps_cpr_id
	AND progress_type = @ps_progress_type
	AND current_flag = 'Y'
	AND (encounter_id = @pl_encounter_id
		OR progress_date_time > @ldt_prev_discharge_date AND progress_date_time <= @ldt_discharge_date)
	END


IF @ps_context_object = 'Encounter'
	BEGIN
	SELECT @ll_count = count(*)
	FROM p_Patient_Encounter_Progress
	WHERE cpr_id = @ps_cpr_id
	AND progress_type = @ps_progress_type
	AND current_flag = 'Y'
	AND (encounter_id = @pl_encounter_id
		OR progress_date_time > @ldt_prev_discharge_date AND progress_date_time <= @ldt_discharge_date)
	END


IF @ps_context_object = 'Assessment'
	BEGIN
	SELECT @ll_count = count(*)
	FROM p_Assessment_Progress
	WHERE cpr_id = @ps_cpr_id
	AND problem_id = @pl_object_key
	AND progress_type = @ps_progress_type
	AND current_flag = 'Y'
	AND (encounter_id = @pl_encounter_id
		OR progress_date_time > @ldt_prev_discharge_date AND progress_date_time <= @ldt_discharge_date)
	END


IF @ps_context_object = 'Treatment'
	BEGIN
	SELECT @ls_in_office_flag = c.in_office_flag
	FROM c_Treatment_Type c
		INNER JOIN p_Treatment_Item t
		ON c.treatment_type = t.treatment_type
	WHERE t.cpr_id = @ps_cpr_id
	AND t.treatment_id = @pl_object_key
	
	SELECT @ll_count = count(*)
	FROM p_Treatment_Progress
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @pl_object_key
	AND progress_type = @ps_progress_type
	AND current_flag = 'Y'
	AND (encounter_id = @pl_encounter_id
		OR progress_date_time > @ldt_prev_discharge_date AND progress_date_time <= @ldt_discharge_date
		OR @ls_in_office_flag = 'Y')
	AND NOT (progress_type = 'Attachment' and progress_key = 'Signature')
	END


RETURN @ll_count 

END

