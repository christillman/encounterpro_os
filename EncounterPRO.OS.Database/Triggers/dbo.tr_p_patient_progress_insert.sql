
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Trigger [dbo].[tr_p_patient_progress_insert]
Print 'Drop Trigger [dbo].[tr_p_patient_progress_insert]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_p_patient_progress_insert]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_p_patient_progress_insert]
GO

-- Create Trigger [dbo].[tr_p_patient_progress_insert]
Print 'Create Trigger [dbo].[tr_p_patient_progress_insert]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_p_patient_progress_insert ON dbo.p_patient_Progress
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

DECLARE
	 @ATTACHMENT_FOLDER_flag INT
	,@ATTACHMENT_TAG_flag INT
	,@CANCELLED_flag INT
	,@Care_Team_flag INT
	,@CHANGED_flag INT
	,@Closed_flag INT
	,@COLLECTED_flag INT
	,@COMPLETED_flag INT
	,@Communication_email_flag INT
	,@Communication_phone_flag INT
	,@CONSOLIDATED_flag INT
	,@DECEASED_flag INT
	,@DELETED_flag INT
	,@DISPATCHED_flag INT
	,@DOLATER_flag INT
	,@ESCALATE_flag INT
	,@EXPIRE_flag INT
	,@Modify_flag INT
	,@MOVED_flag INT
	,@NEEDSAMPLE_flag INT
	,@Property_flag INT
	,@REDIAGNOSED_flag INT
	,@ReOpen_flag INT
	,@Revert_flag INT
	,@Runtime_Configured_flag INT
	,@skipped_flag INT
	,@STARTED_flag INT
	,@TEXT_flag INT

DECLARE @progress TABLE (
	cpr_id varchar(12) NOT NULL,
	patient_progress_sequence int NOT NULL,
	progress_key varchar(40) NOT NULL,
	inserted_progress_sequence int NOT NULL)

/*
	This query sets a numeric flag to a value greater than 0 whenever one or more records in the 
	inserted table has the progress_type be checked for.  The flags are then used to only execute
	applicable queries.
*/

SELECT
	 @ATTACHMENT_FOLDER_flag = SUM( CHARINDEX( 'ATTACHMENT_FOLDER', inserted.progress_type ) )
	,@ATTACHMENT_TAG_flag = SUM( CHARINDEX( 'ATTACHMENT_TAG', inserted.progress_type ) )
	,@CANCELLED_flag = SUM( CHARINDEX( 'CANCELLED', inserted.progress_type ) )
	,@Care_Team_flag = SUM( CHARINDEX( 'Care Team', inserted.progress_type ) )
	,@CHANGED_flag = SUM( CHARINDEX( 'CHANGED', inserted.progress_type ) )
	,@Closed_flag = SUM( CHARINDEX( 'Closed', inserted.progress_type ) )
	,@COLLECTED_flag = SUM( CHARINDEX( 'COLLECTED', inserted.progress_type ) )
	,@COMPLETED_flag = SUM( CHARINDEX( 'COMPLETED', inserted.progress_type ) )
	,@Communication_email_flag = SUM( CHARINDEX( 'Communication Email', inserted.progress_type ) )
	,@Communication_phone_flag = SUM( CHARINDEX( 'Communication Phone', inserted.progress_type ) )
	,@CONSOLIDATED_flag = SUM( CHARINDEX( 'CONSOLIDATED', inserted.progress_type ) )
	,@DECEASED_flag = SUM( CHARINDEX( 'DECEASED', inserted.progress_type ) )
	,@DELETED_flag = SUM( CHARINDEX( 'DELETED', inserted.progress_type ) )
	,@DISPATCHED_flag = SUM( CHARINDEX( 'DISPATCHED', inserted.progress_type ) )
	,@DOLATER_flag = SUM( CHARINDEX( 'DOLATER', inserted.progress_type ) )
	,@ESCALATE_flag = SUM( CHARINDEX( 'ESCALATE', inserted.progress_type ) )
	,@EXPIRE_flag = SUM( CHARINDEX( 'EXPIRE', inserted.progress_type ) )
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
FROM inserted

IF @DECEASED_flag > 0 OR @MOVED_flag > 0 OR @CHANGED_flag > 0
BEGIN
	UPDATE p_patient
	SET	patient_status = inserted.progress_type
	FROM inserted
	WHERE inserted.cpr_id = p_patient.cpr_id
	AND inserted.progress_type in ('DECEASED', 'MOVED', 'CHANGED')
	AND p_patient.patient_status IS NULL
END

-- Update Encounter Field
IF @Modify_flag > 0
BEGIN
	UPDATE p_Patient
	SET 	address_line_1 = CASE inserted.progress_key WHEN 'address_line_1' then inserted.progress_value ELSE p_Patient.address_line_1 END,
			address_line_2 = CASE inserted.progress_key WHEN 'address_line_2' then inserted.progress_value ELSE p_Patient.address_line_2 END,
			attachment_location_id = CASE inserted.progress_key WHEN 'attachment_location_id' then CONVERT(int, inserted.progress_value) ELSE p_Patient.attachment_location_id END,
			attachment_path = CASE inserted.progress_key WHEN 'attachment_path' then inserted.progress_value ELSE p_Patient.attachment_path END,
			billing_id = CASE inserted.progress_key WHEN 'billing_id' then inserted.progress_value ELSE p_Patient.billing_id END,
			city = CASE inserted.progress_key WHEN 'city' then left(inserted.progress_value,40) ELSE p_Patient.city END,
			country = CASE inserted.progress_key WHEN 'country' then left(inserted.progress_value,2) ELSE p_Patient.country END,
--			date_of_birth = CASE inserted.progress_key WHEN 'date_of_birth' then CONVERT(datetime, inserted.progress_value) ELSE p_Patient.date_of_birth END,
			date_of_conception = CASE inserted.progress_key WHEN 'date_of_conception' then CONVERT(datetime, inserted.progress_value) ELSE p_Patient.date_of_conception END,
			degree = CASE inserted.progress_key WHEN 'degree' then inserted.progress_value ELSE p_Patient.degree END,
			department = CASE inserted.progress_key WHEN 'department' then inserted.progress_value ELSE p_Patient.department END,
			email_address = CASE inserted.progress_key WHEN 'email_address' then inserted.progress_value ELSE p_Patient.email_address END,
			employeeID = CASE inserted.progress_key WHEN 'employeeID' then inserted.progress_value ELSE p_Patient.employeeID END,
			employer = CASE inserted.progress_key WHEN 'employer' then inserted.progress_value ELSE p_Patient.employer END,
			employment_status = CASE inserted.progress_key WHEN 'employment_status' then inserted.progress_value ELSE p_Patient.employment_status END,
			financial_class = CASE inserted.progress_key WHEN 'financial_class' then inserted.progress_value ELSE p_Patient.financial_class END,
			first_name = CASE inserted.progress_key WHEN 'first_name' then left(inserted.progress_value,20) ELSE p_Patient.first_name END,
			job_description = CASE inserted.progress_key WHEN 'job_description' then inserted.progress_value ELSE p_Patient.job_description END,
			last_name = CASE inserted.progress_key WHEN 'last_name' then left(inserted.progress_value,40) ELSE p_Patient.last_name END,
			maiden_name = CASE inserted.progress_key WHEN 'maiden_name' then left(inserted.progress_value,12) ELSE p_Patient.maiden_name END,
			marital_status = CASE inserted.progress_key WHEN 'marital_status' then CAST(inserted.progress_value AS char(1)) ELSE p_Patient.marital_status END,
			middle_name = CASE inserted.progress_key WHEN 'middle_name' then left(inserted.progress_value,20) ELSE p_Patient.middle_name END,
			name_prefix = CASE inserted.progress_key WHEN 'name_prefix' then inserted.progress_value ELSE p_Patient.name_prefix END,
			name_suffix = CASE inserted.progress_key WHEN 'name_suffix' then inserted.progress_value ELSE p_Patient.name_suffix END,
			nickname = CASE inserted.progress_key WHEN 'nickname' then inserted.progress_value ELSE p_Patient.nickname END,
			nationality = CASE inserted.progress_key WHEN 'nationality' then inserted.progress_value ELSE p_Patient.nationality END,
			office_id = CASE inserted.progress_key WHEN 'office_id' then inserted.progress_value ELSE p_Patient.office_id END,
			patient_status = CASE inserted.progress_key WHEN 'patient_status' then inserted.progress_value ELSE p_Patient.patient_status END,
			phone_number = CASE inserted.progress_key WHEN 'phone_number' then inserted.progress_value ELSE p_Patient.phone_number END,
			primary_language = CASE inserted.progress_key WHEN 'primary_language' then inserted.progress_value ELSE p_Patient.primary_language END,
			primary_provider_id = CASE inserted.progress_key WHEN 'primary_provider_id' then inserted.progress_value ELSE p_Patient.primary_provider_id END,
			race = CASE inserted.progress_key WHEN 'race' then left(inserted.progress_value,24) ELSE p_Patient.race END,
			referring_provider_id = CASE inserted.progress_key WHEN 'referring_provider_id' then inserted.progress_value ELSE p_Patient.referring_provider_id END,
			religion = CASE inserted.progress_key WHEN 'religion' then inserted.progress_value ELSE p_Patient.religion END,
			secondary_phone_number = CASE inserted.progress_key WHEN 'secondary_phone_number' then inserted.progress_value ELSE p_Patient.secondary_phone_number END,
			secondary_provider_id = CASE inserted.progress_key WHEN 'secondary_provider_id' then inserted.progress_value ELSE p_Patient.secondary_provider_id END,
			sex = CASE inserted.progress_key WHEN 'sex' then CASE LEFT(inserted.progress_value, 1) WHEN 'M' THEN 'M' WHEN 'F' THEN 'F' ELSE p_Patient.sex END ELSE p_Patient.sex END,
			shift = CASE inserted.progress_key WHEN 'shift' then inserted.progress_value ELSE p_Patient.shift END,
			ssn = CASE inserted.progress_key WHEN 'ssn' then left(inserted.progress_value,24) ELSE p_Patient.ssn END,
			start_date = CASE inserted.progress_key WHEN 'start_date' then CONVERT(datetime, inserted.progress_value) ELSE p_Patient.start_date END,
			state = CASE inserted.progress_key WHEN 'state' then inserted.progress_value ELSE p_Patient.state END,
			termination_date = CASE inserted.progress_key WHEN 'termination_date' then CONVERT(datetime, inserted.progress_value) ELSE p_Patient.termination_date END,
			zip = CASE inserted.progress_key WHEN 'zip' then inserted.progress_value ELSE p_Patient.zip END
	FROM inserted
	WHERE inserted.cpr_id = p_Patient.cpr_id
	AND inserted.progress_type = 'Modify'
	AND inserted.progress_key NOT IN ('date_of_birth', 'time_of_birth')

	UPDATE p_Patient
	SET 	date_of_birth = CONVERT(datetime, inserted.progress_value + ' ' + ISNULL(CONVERT(varchar(20), p_Patient.date_of_birth, 114), ''))
	FROM inserted
	WHERE inserted.cpr_id = p_Patient.cpr_id
	AND inserted.progress_type = 'Modify'
	AND inserted.progress_key = 'date_of_birth'

	UPDATE p_Patient
	SET 	date_of_birth = CONVERT(datetime, CONVERT(varchar(10), p_Patient.date_of_birth, 101) + ' ' + inserted.progress_value)
	FROM inserted
	WHERE inserted.cpr_id = p_Patient.cpr_id
	AND inserted.progress_type = 'Modify'
	AND inserted.progress_key = 'time_of_birth'

	INSERT INTO p_Patient_Progress (
		cpr_id,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		progress_key,
		progress_value,
		progress,
		created_by)
	SELECT
		p.cpr_id,
		p.encounter_id,
		p.user_id,
		p.progress_date_time,
		'Communication Email',
		'Email Address',
		p.progress_value,
		p.progress,
		p.created_by
	FROM inserted i
		INNER JOIN p_Patient_Progress p
		ON i.cpr_id = p.cpr_id
		AND i.patient_progress_sequence = p.patient_progress_sequence
	WHERE i.progress_type = 'Modify'
	AND i.progress_key = 'email_address'

	INSERT INTO p_Patient_Progress (
		cpr_id,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		progress_key,
		progress_value,
		progress,
		created_by)
	SELECT
		p.cpr_id,
		p.encounter_id,
		p.user_id,
		p.progress_date_time,
		'Communication Phone',
		'Phone',
		p.progress_value,
		p.progress,
		p.created_by
	FROM inserted i
		INNER JOIN p_Patient_Progress p
		ON i.cpr_id = p.cpr_id
		AND i.patient_progress_sequence = p.patient_progress_sequence
	WHERE i.progress_type = 'Modify'
	AND i.progress_key = 'phone_number'
END


-- Update email address
IF @Communication_email_flag > 0
BEGIN
	UPDATE p_Patient
	SET 	email_address = COALESCE(p.progress_value, CAST(p.progress AS varchar(40)))
	FROM inserted i
		INNER JOIN p_Patient_Progress p
		ON i.cpr_id = p.cpr_id
		AND i.patient_progress_sequence = p.patient_progress_sequence
	WHERE i.cpr_id = p_Patient.cpr_id
	AND i.progress_type = 'Communication Email'
	AND i.progress_key = 'Email Address'
END

-- Update phone number
IF @Communication_phone_flag > 0
BEGIN
	UPDATE p_Patient
	SET 	phone_number = COALESCE(p.progress_value, CAST(p.progress AS varchar(32)))
	FROM inserted i
		INNER JOIN p_Patient_Progress p
		ON i.cpr_id = p.cpr_id
		AND i.patient_progress_sequence = p.patient_progress_sequence
	WHERE i.cpr_id = p_Patient.cpr_id
	AND i.progress_type = 'Communication Phone'
	AND i.progress_key = 'Phone'
END

-- Then get the latest attachment text if applicable
UPDATE p_patient_Progress
SET progress = a.attachment_text
FROM inserted, p_Attachment a
WHERE inserted.cpr_id = p_patient_Progress.cpr_id
AND inserted.patient_progress_sequence  = p_patient_Progress.patient_progress_sequence
AND inserted.attachment_id = a.attachment_id
AND a.attachment_text IS NOT NULL

-- Set previous progress note to not current using the progress_date_time
-- Progress types other than 'Property', 'ID', 'Care Team' and 'Communication %'
UPDATE t1
SET current_flag = 'N'
FROM p_Patient_Progress t1
	INNER JOIN inserted t2
	ON t1.cpr_id = t2.cpr_id
	AND t1.progress_type = t2.progress_type
	AND t1.progress_key = t2.progress_key
	AND t1.progress_date_time = t2.progress_date_time
WHERE (t1.patient_progress_sequence < t2.patient_progress_sequence
		OR (t1.progress_key IS NOT NULL AND t1.progress_value IS NULL AND t1.progress IS NULL AND t1.attachment_id IS NULL) )
AND t2.progress_type NOT IN ('Property', 'ID', 'Care Team')
AND t2.progress_type NOT LIKE 'Communication %'

-- Set previous progress note to not current
-- Progress types 'Property', 'ID', 'Care Team' and 'Communication %'
UPDATE t1
SET current_flag = 'N'
FROM p_Patient_Progress t1
	INNER JOIN inserted t2
	ON t1.cpr_id = t2.cpr_id
	AND t1.progress_type = t2.progress_type
	AND t1.progress_key = t2.progress_key
WHERE (t1.patient_progress_sequence < t2.patient_progress_sequence
		OR (t1.progress_key IS NOT NULL AND t1.progress_value IS NULL AND t1.progress IS NULL AND t1.attachment_id IS NULL) )
AND (t2.progress_type IN ('Property', 'ID', 'Care Team')
	OR t2.progress_type LIKE 'Communication %')


UPDATE p
SET progress_key = 'Portrait'
FROM p_Patient_Progress p
	INNER JOIN inserted i
	ON p.cpr_id = i.cpr_id
	AND p.patient_progress_sequence = i.patient_progress_sequence
	INNER JOIN p_Attachment a
	ON p.cpr_id = a.cpr_id
	AND p.attachment_id = a.attachment_id
WHERE p.progress_type = 'Attachment'
AND a.attachment_type = 'Image'
AND a.attachment_folder = 'Portraits'
AND p.progress_key <> 'Portrait'

IF (SELECT sum(attachment_id) FROM inserted) > 0
	UPDATE a
	SET context_object = 'Patient',
		object_key = NULL
	FROM p_Attachment a
		INNER JOIN inserted i
		ON a.cpr_id = i.cpr_id
		AND a.attachment_id = i.attachment_id
	WHERE i.attachment_id > 0


IF @Care_Team_flag > 0
BEGIN
	INSERT INTO @progress (
		cpr_id ,
		patient_progress_sequence ,
		progress_key,
		inserted_progress_sequence)
	SELECT DISTINCT p.cpr_id ,
		p.patient_progress_sequence ,
		p.progress_key,
		i.patient_progress_sequence
	FROM inserted i
		INNER JOIN c_User u
		ON i.progress_key = u.user_id
		INNER JOIN p_Patient_Progress p -- All the primary care team members for all the referenced patients
		ON p.cpr_id = i.cpr_id
		AND p.progress_type = 'Care Team'
		AND p.current_flag = 'Y'
		AND LEFT(p.progress_value, 1) = 'P'
		INNER JOIN c_User u2
		ON p.progress_key = u2.user_id
	WHERE u.actor_class = u2.actor_class
	AND ISNULL(u.specialty_id, '!NULL') = ISNULL(u2.specialty_id, '!NULL')
	AND u.user_id <> u2.user_id -- exclude the newly designated care team members
	AND LEFT(i.progress_value, 1) = 'P'

	-- First add new 'Y' progress records for the other primary members because they are still part of the care team
	-- but not primary members any more
	INSERT INTO p_Patient_Progress (
		cpr_id,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		progress_key,
		progress_value,
		created,
		created_by)
	SELECT DISTINCT p.cpr_id,
		i.encounter_id,
		i.user_id,
		getdate(),
		'Care Team',
		p.progress_key,
		'Y',
		getdate(),
		i.created_by
	FROM @progress p
		INNER JOIN inserted i
		ON p.cpr_id = i.cpr_id
		AND p.inserted_progress_sequence = i.patient_progress_sequence

	-- Then turn off any progress notes for other primary members because this trigger will not fire recursively
	UPDATE p
	SET current_flag = 'N'
	FROM p_Patient_Progress p
		INNER JOIN @progress x
		ON p.cpr_id = x.cpr_id
		AND p.patient_progress_sequence = x.patient_progress_sequence

END


GO

