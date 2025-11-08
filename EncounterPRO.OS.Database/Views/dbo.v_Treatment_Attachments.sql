
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop View [dbo].[v_Treatment_Attachments]
Print 'Drop View [dbo].[v_Treatment_Attachments]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[v_Treatment_Attachments]') AND [type]='V'))
DROP VIEW [dbo].[v_Treatment_Attachments]
GO
-- Create View [dbo].[v_Treatment_Attachments]
Print 'Create View [dbo].[v_Treatment_Attachments]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  View dbo.v_Treatment_Attachments    Script Date: 7/25/2000 8:42:39 AM ******/
CREATE VIEW v_Treatment_Attachments
AS
SELECT
	p.cpr_id,
	p.treatment_id,
	p.treatment_progress_sequence,
	p.progress_type,
	p.progress_key,
	p.encounter_id,
	p.attachment_id,
	a.attachment_type,
	a.attachment_tag,
	a.attachment_file,
	a.extension,
	a.attachment_text,
	a.attachment_image,
	a.storage_flag,
	a.attachment_date,
	a.attachment_folder,
	a.box_id,
	a.item_id,
	a.attached_by,
	a.created,
	a.created_by,
	a.status,
	a.id,
	a.context_object,
	a.object_key,
	a.default_grant,
	a.interpreted
FROM p_Treatment_Progress p
	INNER JOIN p_Attachment a
	ON p.cpr_id = a.cpr_id
	AND p.attachment_id = a.attachment_id
WHERE p.current_flag = 'Y'
AND a.status = 'OK'
GO
GRANT SELECT ON [dbo].[v_Treatment_Attachments] TO [cprsystem]
GO

