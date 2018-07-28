CREATE PROCEDURE sp_get_objects_since_last_encounter (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int)
AS

DECLARE @ldt_begin_date datetime,
		@ldt_last_begin_date datetime,
		@ldt_end_date datetime,
		@ll_last_encounter_id int

DECLARE @objects TABLE (
	cpr_id varchar(12) NOT NULL,
	context_object varchar(24) NOT NULL,
	object_key int NOT NULL,
	object_type varchar(24) NOT NULL,
	progress_sequence int NOT NULL,
	description varchar(255) NOT NULL,
	progress_type varchar(24) NOT NULL,
	progress varchar(128) NULL,
	progress_attachment_id int NULL,
	progress_current_flag char(1) NOT NULL,
	progress_created datetime NOT NULL)

DECLARE @objects_first_touch TABLE (
	cpr_id varchar(12) NOT NULL,
	context_object varchar(24) NOT NULL,
	object_key int NOT NULL,
	progress_sequence int NOT NULL )

SELECT 	@ldt_end_date = DATEADD(second, -1, created)
FROM p_Patient_Encounter
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id

SELECT 	@ll_last_encounter_id = max(encounter_id)
FROM p_Patient_Encounter
WHERE cpr_id = @ps_cpr_id
AND encounter_id < @pl_encounter_id
AND indirect_flag = 'D'

IF @ll_last_encounter_id IS NULL
	SET @ldt_begin_date = '1/1/1900'
ELSE
	BEGIN
	SELECT 	@ldt_begin_date = DATEADD(second, 1, discharge_date),
			@ldt_last_begin_date = encounter_date
	FROM p_Patient_Encounter
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @ll_last_encounter_id

	-- If the previous encounter is still open then use
	-- one hour after it was opened as the effective end_date
	IF @ldt_begin_date IS NULL 
		SET @ldt_begin_date = DATEADD(hour, 1, @ldt_last_begin_date)
	END



INSERT INTO @objects (
	cpr_id ,
	context_object ,
	object_key ,
	object_type ,
	progress_sequence ,
	description ,
	progress_type ,
	progress ,
	progress_attachment_id ,
	progress_current_flag ,
	progress_created )
SELECT cpr_id ,
	context_object ,
	object_key ,
	object_type ,
	progress_sequence ,
	COALESCE(description, context_object + ' ' + COALESCE(object_type, '') ) ,
	progress_type ,
	progress ,
	progress_attachment_id ,
	progress_current_flag ,
	progress_created
FROM dbo.fn_patient_object_progress(@ps_cpr_id, @ldt_begin_date, @ldt_end_date)

INSERT INTO @objects_first_touch (
	cpr_id ,
	context_object ,
	object_key ,
	progress_sequence )
SELECT o.cpr_id ,
	o.context_object ,
	o.object_key ,
	min(o.progress_sequence) as progress_sequence
FROM @objects o
	INNER JOIN (SELECT cpr_id ,
						context_object ,
						object_key ,
						min(progress_created) as first_touched
					FROM @objects
					WHERE progress_attachment_id IS NULL
					GROUP BY cpr_id, context_object, object_key ) f
	ON o.cpr_id = f.cpr_id
	AND o.context_object = f.context_object
	AND o.object_key = f.object_key
	AND o.progress_created = f.first_touched
	AND o.progress_attachment_id IS NULL
GROUP BY o.cpr_id ,
	o.context_object ,
	o.object_key

SELECT o.cpr_id ,
		o.context_object ,
		o.object_key ,
		o.object_type ,
		o.progress_sequence ,
		o.description ,
		o.progress_type ,
		o.progress ,
		o.progress_attachment_id ,
		CAST(NULL as varchar(24)) as attachment_extension ,
		o.progress_current_flag ,
		o.progress_created
FROM @objects o
	INNER JOIN @objects_first_touch f
	ON o.cpr_id = f.cpr_id
	AND o.context_object = f.context_object
	AND o.object_key = f.object_key
	AND o.progress_sequence = f.progress_sequence
UNION
SELECT o.cpr_id ,
		o.context_object ,
		o.object_key ,
		o.object_type ,
		o.progress_sequence ,
		o.description ,
		o.progress_type ,
		o.progress ,
		o.progress_attachment_id ,
		a.extension as attachment_extension ,
		o.progress_current_flag ,
		o.progress_created
FROM @objects o
	INNER JOIN p_Attachment a
	ON o.cpr_id = a.cpr_id
	AND o.progress_attachment_id = a.attachment_id
WHERE progress_attachment_id IS NOT NULL
AND progress_current_flag = 'Y'
ORDER BY progress_created

