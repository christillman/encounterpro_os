
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Trigger [dbo].[tr_p_attachment_update]
Print 'Drop Trigger [dbo].[tr_p_attachment_update]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_p_attachment_update]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_p_attachment_update]
GO

-- Create Trigger [dbo].[tr_p_attachment_update]
Print 'Create Trigger [dbo].[tr_p_attachment_update]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
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
	FROM inserted
	JOIN p_Attachment ON inserted.attachment_id = p_Attachment.attachment_id
	JOIN p_Assessment_Progress ON inserted.attachment_id = p_Assessment_Progress.attachment_id
		AND inserted.cpr_id = p_Assessment_Progress.cpr_id

	UPDATE p_Treatment_Progress
	SET progress_value = CASE WHEN LEN(CONVERT(varchar(50),p_Attachment.attachment_text)) <= 40 THEN p_Attachment.attachment_text ELSE NULL END,
		progress = CASE WHEN LEN(CONVERT(varchar(50),p_Attachment.attachment_text)) > 40 THEN p_Attachment.attachment_text ELSE NULL END
	FROM inserted
	JOIN p_Attachment ON inserted.attachment_id = p_Attachment.attachment_id
	JOIN p_Treatment_Progress ON inserted.attachment_id = p_Treatment_Progress.attachment_id
		AND inserted.cpr_id = p_Treatment_Progress.cpr_id

	UPDATE p_Observation_Comment
	SET comment = p_Attachment.attachment_text
	FROM inserted
	JOIN p_Attachment ON inserted.attachment_id = p_Attachment.attachment_id
	JOIN p_Observation_Comment ON inserted.attachment_id = p_Observation_Comment.attachment_id

	UPDATE p_Patient_Progress
	SET progress_value = CASE WHEN LEN(CONVERT(varchar(50),p_Attachment.attachment_text)) <= 40 THEN p_Attachment.attachment_text ELSE NULL END,
		progress = CASE WHEN LEN(CONVERT(varchar(50),p_Attachment.attachment_text)) > 40 THEN p_Attachment.attachment_text ELSE NULL END
	FROM inserted
	JOIN p_Attachment ON inserted.attachment_id = p_Attachment.attachment_id
	JOIN p_Patient_Progress ON inserted.attachment_id = p_Patient_Progress.attachment_id
		AND inserted.cpr_id = p_Patient_Progress.cpr_id

	UPDATE p_Patient_Encounter_Progress
	SET progress_value = CASE WHEN LEN(CONVERT(varchar(50),p_Attachment.attachment_text)) <= 40 THEN p_Attachment.attachment_text ELSE NULL END,
		progress = CASE WHEN LEN(CONVERT(varchar(50),p_Attachment.attachment_text)) > 40 THEN p_Attachment.attachment_text ELSE NULL END
	FROM inserted
	JOIN p_Attachment ON inserted.attachment_id = p_Attachment.attachment_id
	JOIN p_Patient_Encounter_Progress ON inserted.attachment_id = p_Patient_Encounter_Progress.attachment_id
		AND inserted.cpr_id = p_Patient_Encounter_Progress.cpr_id
END
GO

