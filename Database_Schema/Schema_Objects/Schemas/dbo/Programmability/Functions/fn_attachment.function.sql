CREATE FUNCTION fn_attachment (
	@ps_cpr_id varchar(12),
	@pl_attachment_id int)

RETURNS @attachment TABLE (
	attachment_image image)

AS

BEGIN

DECLARE @ll_attachment_progress_sequence int

SELECT @ll_attachment_progress_sequence = max(attachment_progress_sequence)
FROM p_Attachment_Progress
WHERE cpr_id = @ps_cpr_id
AND attachment_id = @pl_attachment_id
AND progress_type = 'UPDATE'

IF @ll_attachment_progress_sequence IS NULL
	INSERT INTO @attachment (
		attachment_image)
	SELECT attachment_image
	FROM p_Attachment
	WHERE cpr_id = @ps_cpr_id
	AND attachment_id = @pl_attachment_id
ELSE
	INSERT INTO @attachment (
		attachment_image)
	SELECT attachment_image
	FROM p_Attachment_Progress
	WHERE cpr_id = @ps_cpr_id
	AND attachment_id = @pl_attachment_id
	AND attachment_progress_sequence = @ll_attachment_progress_sequence


RETURN
END

