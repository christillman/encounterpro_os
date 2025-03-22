

SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Trigger tr_p_patient_insert
Print 'Drop Trigger tr_p_patient_insert'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'tr_p_patient_insert') AND [type]='TR'))
DROP TRIGGER tr_p_patient_insert
GO

-- Create Trigger tr_p_patient_insert
Print 'Create Trigger tr_p_patient_insert'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER tr_p_patient_insert ON dbo.p_Patient
FOR INSERT
AS


IF @@ROWCOUNT = 0
	RETURN

DECLARE @ll_count int

IF UPDATE(billing_id)
	BEGIN
	SELECT @ll_count = count(*)
	FROM inserted i
	WHERE EXISTS (
		SELECT 1
		FROM p_Patient p
		WHERE p.billing_id = i.billing_id
		AND p.cpr_id <> i.cpr_id)

	IF @ll_count > 0
		BEGIN
		RAISERROR('ERROR:  Duplicate billing_id.  Insert will be aborted', 16, -1)
		ROLLBACK TRANSACTION
		RETURN
		END
	END

INSERT INTO p_Patient_Progress(
	cpr_id,
	user_id,
	progress_date_time,
	progress_type,
	created,
	created_by)
SELECT cpr_id,
	ISNULL(created_by, '#SYSTEM'),
	ISNULL(created, dbo.get_client_datetime()),
	'Created',
	ISNULL(created, dbo.get_client_datetime()),
	ISNULL(created_by, '#SYSTEM')
FROM inserted

UPDATE p
SET primary_provider_id = NULL
FROM inserted i
	INNER JOIN p_Patient p
	ON i.cpr_id = p.cpr_id
WHERE i.primary_provider_id = ''

DECLARE @ll_sort_sequence smallint,
		@ll_attachment_location_id int

SELECT @ll_sort_sequence = min(sort_sequence)
FROM c_Attachment_Location

IF @ll_sort_sequence IS NULL
	SELECT @ll_attachment_location_id = min(attachment_location_id)
	FROM c_Attachment_Location
ELSE
	SELECT @ll_attachment_location_id = min(attachment_location_id)
	FROM c_Attachment_Location
	WHERE sort_sequence = @ll_sort_sequence

UPDATE p
SET attachment_location_id = @ll_attachment_location_id
FROM inserted i
	INNER JOIN p_Patient p
	ON i.cpr_id = p.cpr_id
WHERE i.attachment_location_id IS NULL

UPDATE p
SET attachment_path = dbo.fn_string_to_identifier(i.cpr_id)
FROM inserted i
	INNER JOIN p_Patient p
	ON i.cpr_id = p.cpr_id
WHERE i.attachment_path IS NULL


-- Update Alias Table
INSERT INTO [p_Patient_Alias] (
	[cpr_id] ,
	[alias_type] ,
	[first_name] ,
	[last_name] ,
	[middle_name] ,
	[name_prefix] ,
	[name_suffix] ,
	[degree] ,
	[created] ,
	[created_by] ,
	[id] )
SELECT [cpr_id] ,
	'Primary' ,
	[first_name] ,
	[last_name] ,
	[middle_name] ,
	[name_prefix] ,
	[name_suffix] ,
	[degree] ,
	[created] ,
	COALESCE([created_by], '#SYSTEM') ,
	newid()
FROM inserted
WHERE last_name IS NOT NULL


IF UPDATE(phone_number)
	BEGIN
	UPDATE p
	SET phone_number = CASE WHEN COALESCE(p.zip,'00000') = '00000' 
		THEN dbo.fn_pretty_phone(p.phone_number)
		ELSE dbo.fn_pretty_phone_us(p.phone_number) END
	FROM p_Patient p
		INNER JOIN inserted i
		ON p.cpr_id = i.cpr_id

	UPDATE p
	SET phone_number_7digit = RIGHT(p.phone_number, 8)
	FROM p_Patient p
		INNER JOIN inserted i
		ON p.cpr_id = i.cpr_id

	END
	
GO

