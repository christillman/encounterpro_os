CREATE TRIGGER tr_p_patient_encounter_progress_insert ON dbo.p_patient_encounter_progress
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

DECLARE @ls_progress_key varchar(40),
		@ls_progress_value varchar(40),
		@lc_replace_flag char(1),
		@ls_cpr_id varchar(12),
		@ll_encounter_id int,
		@ls_created_by varchar(24)

DECLARE
	 @ATTACHMENT_FOLDER_flag int
	,@ATTACHMENT_TAG_flag int
	,@CANCELLED_flag int
	,@CHANGED_flag int
	,@Closed_flag int
	,@COLLECTED_flag int
	,@COMPLETED_flag int
	,@CONSOLIDATED_flag int
	,@DECEASED_flag int
	,@DELETED_flag int
	,@DISPATCHED_flag int
	,@DOLATER_flag int
	,@ESCALATE_flag int
	,@EXPIRE_flag int
	,@MODIFIED_flag int
	,@Modify_flag int
	,@MOVED_flag int
	,@NEEDSAMPLE_flag int
	,@Property_flag int
	,@REDIAGNOSED_flag int
	,@ReOpen_flag int
	,@Revert_flag int
	,@Runtime_Configured_flag int
	,@skipped_flag int
	,@STARTED_flag int
	,@TEXT_flag int
	,@UNCancelled_flag int
	,@Confidential_flag int


/*
	This query sets a numberic flag to a value greater than 0 whenever one or more records in the 
	inserted table has the progress_type be checked for.  The flags are then used to only execute
	applicable queries.
*/

SELECT
	 @ATTACHMENT_FOLDER_flag = SUM( CHARINDEX( 'ATTACHMENT_FOLDER', inserted.progress_type ) )
	,@ATTACHMENT_TAG_flag = SUM( CHARINDEX( 'ATTACHMENT_TAG', inserted.progress_type ) )
	,@CANCELLED_flag = SUM( CHARINDEX( 'CANCELLED', inserted.progress_type ) ) + SUM( CHARINDEX( 'Canceled', inserted.progress_type ) )
	,@CHANGED_flag = SUM( CHARINDEX( 'CHANGED', inserted.progress_type ) )
	,@Closed_flag = SUM( CHARINDEX( 'Closed', inserted.progress_type ) )
	,@COLLECTED_flag = SUM( CHARINDEX( 'COLLECTED', inserted.progress_type ) )
	,@COMPLETED_flag = SUM( CHARINDEX( 'COMPLETED', inserted.progress_type ) )
	,@CONSOLIDATED_flag = SUM( CHARINDEX( 'CONSOLIDATED', inserted.progress_type ) )
	,@DECEASED_flag = SUM( CHARINDEX( 'DECEASED', inserted.progress_type ) )
	,@DELETED_flag = SUM( CHARINDEX( 'DELETED', inserted.progress_type ) )
	,@DISPATCHED_flag = SUM( CHARINDEX( 'DISPATCHED', inserted.progress_type ) )
	,@DOLATER_flag = SUM( CHARINDEX( 'DOLATER', inserted.progress_type ) )
	,@ESCALATE_flag = SUM( CHARINDEX( 'ESCALATE', inserted.progress_type ) )
	,@EXPIRE_flag = SUM( CHARINDEX( 'EXPIRE', inserted.progress_type ) )
	,@MODIFIED_flag = SUM( CHARINDEX( 'MODIFIED', inserted.progress_type ) )
	,@Modify_flag = SUM( CHARINDEX( 'Modify', inserted.progress_type ) )
	,@MOVED_flag = SUM( CHARINDEX( 'MOVED', inserted.progress_type ) )
	,@NEEDSAMPLE_flag = SUM( CHARINDEX( 'NEEDSAMPLE', inserted.progress_type ) )
	,@Property_flag = SUM( CHARINDEX( 'Property', inserted.progress_type ) )
	,@REDIAGNOSED_flag = SUM( CHARINDEX( 'REDIAGNOSED', inserted.progress_type ) )
	,@ReOpen_flag = SUM( CHARINDEX( 'ReOpen', inserted.progress_type ) )
	,@Revert_flag = SUM( CHARINDEX( 'Revert To Original Owner', inserted.progress_type ) )
	,@Runtime_Configured_flag = SUM( CHARINDEX( 'Runtime_Configured', inserted.progress_type ) )
	,@skipped_flag = SUM( CHARINDEX( 'Skipped', inserted.progress_type ) )
	,@STARTED_flag = SUM( CHARINDEX( 'STARTED', inserted.progress_type ) )
	,@TEXT_flag = SUM( CHARINDEX( 'TEXT', inserted.progress_type ) )
	,@UNCancelled_flag = SUM( CHARINDEX( 'UNCancelled', inserted.progress_type ) )
	,@Confidential_flag = SUM( CHARINDEX( 'CONFIDENTIAL', inserted.progress_type ) )
FROM inserted

IF @Property_flag > 0
	BEGIN
	SET @lc_replace_flag = 'Y'

	DECLARE lc_visit_code CURSOR LOCAL FAST_FORWARD FOR
		SELECT cpr_id, encounter_id, progress_key, progress_value, created_by
		FROM inserted
		WHERE progress_type = 'Property'
		AND progress_key = 'Visit Code'
		
	OPEN lc_visit_code
	
	FETCH lc_visit_code INTO @ls_cpr_id, @ll_encounter_id, @ls_progress_key, @ls_progress_value, @ls_created_by
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
		
		EXECUTE sp_add_encounter_charge
			@ps_cpr_id = @ls_cpr_id,
			@pl_encounter_id = @ll_encounter_id,
			@ps_procedure_id = @ls_progress_value,
			@pl_treatment_id = NULL,
			@ps_created_by = @ls_created_by,
			@ps_replace_flag = @lc_replace_flag
		
		FETCH lc_visit_code INTO @ls_cpr_id, @ll_encounter_id, @ls_progress_key, @ls_progress_value, @ls_created_by
		END
	
	CLOSE lc_visit_code
	DEALLOCATE lc_visit_code
	END

IF @Confidential_flag > 0
	BEGIN
	UPDATE e
	SET	default_grant = CASE i.progress_key WHEN 'Allow' THEN 1 
												WHEN 'Deny' THEN 0 
												ELSE e.default_grant END
	FROM p_Patient_Encounter e
		INNER JOIN inserted i
		ON i.cpr_id = e.cpr_id
		AND i.encounter_id = e.encounter_id
	WHERE i.progress_type = 'CONFIDENTIAL'
	END

-- Update Status fields if we're closing the encounter

IF @Closed_flag > 0 OR @CANCELLED_flag > 0
BEGIN
	-- Since the encounter_status can only be 8 characters, treat progress_types 'Cancelled' and 'Canceled' as the same
	-- and map to the encounter_status = 'Canceled'
	UPDATE p_Patient_Encounter
	SET encounter_status = CASE inserted.progress_type WHEN 'Closed' THEN 'Closed' ELSE 'Canceled' END,
		discharge_date = inserted.progress_date_time
	FROM inserted
	WHERE inserted.cpr_id = p_Patient_Encounter.cpr_id
	AND inserted.encounter_id = p_Patient_Encounter.encounter_id
	AND inserted.progress_type IN ('Closed', 'Cancelled', 'Canceled')
END

IF @UNCancelled_flag > 0
BEGIN
	-- 
	UPDATE p_Patient_Encounter
	SET encounter_status = 'CLOSED'
	FROM inserted
	WHERE inserted.cpr_id = p_Patient_Encounter.cpr_id
	AND inserted.encounter_id = p_Patient_Encounter.encounter_id
	AND inserted.progress_type = 'UNCancelled'
	AND p_Patient_Encounter.encounter_status = 'Canceled'
END

-- Update Status fields if we're re-opening the encounter

IF @ReOpen_flag > 0
BEGIN
	UPDATE p_Patient_Encounter
	SET encounter_status = 'OPEN',
		discharge_date = NULL,
		patient_location = NULL
	FROM inserted
	WHERE inserted.cpr_id = p_Patient_Encounter.cpr_id
	AND inserted.encounter_id = p_Patient_Encounter.encounter_id
	AND inserted.progress_type = 'ReOpen'
END

-- Update Encounter Field
IF @Modify_flag > 0
BEGIN
	UPDATE p_Patient_Encounter
	SET attending_doctor = CASE inserted.progress_key WHEN 'attending_doctor' then inserted.progress_value ELSE p_Patient_Encounter.attending_doctor END,
		encounter_description = CASE inserted.progress_key WHEN 'encounter_description' then inserted.progress_value ELSE p_Patient_Encounter.encounter_description END,
		encounter_date = CASE inserted.progress_key WHEN 'encounter_date' then CONVERT(datetime, inserted.progress_value) ELSE p_Patient_Encounter.encounter_date END,
		encounter_type = CASE inserted.progress_key WHEN 'encounter_type' then inserted.progress_value ELSE p_Patient_Encounter.encounter_type END,
		indirect_flag = CASE inserted.progress_key WHEN 'indirect_flag' then inserted.progress_value ELSE p_Patient_Encounter.indirect_flag END,
		referring_doctor = CASE inserted.progress_key WHEN 'referring_doctor' then inserted.progress_value ELSE p_Patient_Encounter.referring_doctor END,
		new_flag = CASE inserted.progress_key WHEN 'new_flag' then inserted.progress_value ELSE p_Patient_Encounter.new_flag END,
		billing_posted = CASE inserted.progress_key WHEN 'billing_posted' then inserted.progress_value ELSE p_Patient_Encounter.billing_posted END,
		bill_flag = CASE inserted.progress_key WHEN 'bill_flag' then inserted.progress_value ELSE p_Patient_Encounter.bill_flag END,
		courtesy_code = CASE inserted.progress_key WHEN 'courtesy_code' then inserted.progress_value ELSE p_Patient_Encounter.courtesy_code END,
		billing_hold_flag = CASE inserted.progress_key WHEN 'billing_hold_flag' then inserted.progress_value ELSE p_Patient_Encounter.billing_hold_flag END,
		patient_location = CASE inserted.progress_key WHEN 'patient_location' then inserted.progress_value ELSE p_Patient_Encounter.patient_location END,
		next_patient_location = CASE inserted.progress_key WHEN 'next_patient_location' then inserted.progress_value ELSE p_Patient_Encounter.next_patient_location END,
		supervising_doctor = CASE inserted.progress_key WHEN 'supervising_doctor' then inserted.progress_value ELSE p_Patient_Encounter.supervising_doctor END,
		office_id = CASE inserted.progress_key WHEN 'office_id' then CAST(inserted.progress_value AS varchar(4)) ELSE p_Patient_Encounter.office_id END
	FROM inserted
	WHERE inserted.cpr_id = p_Patient_Encounter.cpr_id
	AND inserted.encounter_id = p_Patient_Encounter.encounter_id
	AND inserted.progress_type = 'Modify'


	-- Update billing_note if modified
	UPDATE e
	SET billing_note = COALESCE(p.progress_value, p.progress)
	FROM p_Patient_Encounter e
		INNER JOIN 	inserted i
		ON i.cpr_id = e.cpr_id
		AND i.encounter_id = e.encounter_id
		INNER JOIN p_Patient_Encounter_Progress p
		ON i.cpr_id = p.cpr_id
		AND i.encounter_id = p.encounter_id
		AND i.encounter_progress_sequence = p.encounter_progress_sequence
	WHERE i.progress_type = 'Modify'
	AND i.progress_key = 'billing_note'

	-- Update billing_posted if bill flag modified
	UPDATE p_Patient_Encounter
	SET billing_posted = 'X'
	FROM inserted
	WHERE inserted.cpr_id = p_Patient_Encounter.cpr_id
	AND inserted.encounter_id = p_Patient_Encounter.encounter_id
	AND inserted.progress_type = 'Modify'
	AND inserted.progress_key = 'bill_flag'
	AND inserted.progress_value = 'N'

	UPDATE p_Patient_Encounter
	SET billing_posted = 'N'
	FROM inserted
	WHERE inserted.cpr_id = p_Patient_Encounter.cpr_id
	AND inserted.encounter_id = p_Patient_Encounter.encounter_id
	AND inserted.progress_type = 'Modify'
	AND inserted.progress_key = 'bill_flag'
	AND inserted.progress_value = 'Y'
	AND p_Patient_Encounter.billing_posted IN ('X','F')
END

-- Get the latest attachment text if applicable
UPDATE p_patient_encounter_progress
SET progress = a.attachment_text
FROM inserted, p_Attachment a
WHERE inserted.cpr_id = p_patient_encounter_progress.cpr_id
AND inserted.encounter_progress_sequence  = p_patient_encounter_progress.encounter_progress_sequence
AND inserted.attachment_id = a.attachment_id
AND a.attachment_text IS NOT NULL

UPDATE t1
SET current_flag = 'N'
FROM p_Patient_Encounter_Progress t1
	INNER JOIN inserted t2
	ON t1.cpr_id = t2.cpr_id
	AND t1.encounter_id = t2.encounter_id
	AND t1.progress_type = t2.progress_type
	AND t1.progress_key = t2.progress_key
	AND t1.progress_date_time = t2.progress_date_time
WHERE t1.encounter_progress_sequence < t2.encounter_progress_sequence
OR (t1.progress_key IS NOT NULL AND t1.progress_value IS NULL AND t1.progress IS NULL AND t1.attachment_id IS NULL)


IF (SELECT sum(attachment_id) FROM inserted) > 0
	UPDATE a
	SET context_object = 'Encounter',
		object_key = i.encounter_id
	FROM p_Attachment a
		INNER JOIN inserted i
		ON a.cpr_id = i.cpr_id
		AND a.attachment_id = i.attachment_id
	WHERE i.attachment_id > 0

