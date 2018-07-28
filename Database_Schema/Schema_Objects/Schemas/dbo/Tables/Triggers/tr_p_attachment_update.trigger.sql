CREATE TRIGGER tr_p_attachment_update ON dbo.p_Attachment
FOR UPDATE
AS

IF @@ROWCOUNT = 0
	RETURN

IF UPDATE(attachment_text)
BEGIN
	UPDATE p_Assessment_Progress
	SET progress_value = CASE WHEN LEN(CONVERT(varchar(50),p_Attachment.attachment_text)) <= 40 THEN p_Attachment.attachment_text ELSE NULL END,
		progress = CASE WHEN LEN(CONVERT(varchar(50),p_Attachment.attachment_text)) > 40 THEN p_Attachment.attachment_text ELSE NULL END
	FROM inserted, p_Attachment
	WHERE inserted.attachment_id = p_Attachment.attachment_id
	AND inserted.cpr_id = p_Assessment_Progress.cpr_id
	AND inserted.attachment_id = p_Assessment_Progress.attachment_id

	UPDATE p_Treatment_Progress
	SET progress_value = CASE WHEN LEN(CONVERT(varchar(50),p_Attachment.attachment_text)) <= 40 THEN p_Attachment.attachment_text ELSE NULL END,
		progress = CASE WHEN LEN(CONVERT(varchar(50),p_Attachment.attachment_text)) > 40 THEN p_Attachment.attachment_text ELSE NULL END
	FROM inserted, p_Attachment
	WHERE inserted.attachment_id = p_Attachment.attachment_id
	AND inserted.cpr_id = p_Treatment_Progress.cpr_id
	AND inserted.attachment_id = p_Treatment_Progress.attachment_id

	UPDATE p_Observation_Comment
	SET comment = p_Attachment.attachment_text
	FROM inserted, p_Attachment
	WHERE inserted.attachment_id = p_Attachment.attachment_id
	AND inserted.attachment_id = p_Observation_Comment.attachment_id

	UPDATE p_Patient_Progress
	SET progress_value = CASE WHEN LEN(CONVERT(varchar(50),p_Attachment.attachment_text)) <= 40 THEN p_Attachment.attachment_text ELSE NULL END,
		progress = CASE WHEN LEN(CONVERT(varchar(50),p_Attachment.attachment_text)) > 40 THEN p_Attachment.attachment_text ELSE NULL END
	FROM inserted, p_Attachment
	WHERE inserted.attachment_id = p_Attachment.attachment_id
	AND inserted.cpr_id = p_Patient_Progress.cpr_id
	AND inserted.attachment_id = p_Patient_Progress.attachment_id

	UPDATE p_Patient_Encounter_Progress
	SET progress_value = CASE WHEN LEN(CONVERT(varchar(50),p_Attachment.attachment_text)) <= 40 THEN p_Attachment.attachment_text ELSE NULL END,
		progress = CASE WHEN LEN(CONVERT(varchar(50),p_Attachment.attachment_text)) > 40 THEN p_Attachment.attachment_text ELSE NULL END
	FROM inserted, p_Attachment
	WHERE inserted.attachment_id = p_Attachment.attachment_id
	AND inserted.cpr_id = p_Patient_Encounter_Progress.cpr_id
	AND inserted.attachment_id = p_Patient_Encounter_Progress.attachment_id
END
