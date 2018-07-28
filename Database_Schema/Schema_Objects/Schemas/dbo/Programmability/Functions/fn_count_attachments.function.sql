CREATE FUNCTION fn_count_attachments (
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(24),
	@pl_object_key int)

RETURNS int

AS
BEGIN
DECLARE @ll_count int

IF @ps_context_object = 'Patient'
	BEGIN
	SELECT @ll_count = count(*)
	FROM p_Attachment a
		INNER JOIN c_Attachment_Type at
		ON a.attachment_type = at.attachment_type
		INNER JOIN c_User u
		ON a.created_by = u.user_id
		LEFT OUTER JOIN p_Patient_Progress pp
		ON a.cpr_id = pp.cpr_id
		AND a.attachment_id = pp.attachment_id
		LEFT OUTER JOIN c_Folder f
		ON a.attachment_folder = f.folder
	WHERE a.status = 'OK'
	AND a.cpr_id = @ps_cpr_id
	END
ELSE
	BEGIN
	SELECT @ll_count = count(*)
	FROM dbo.fn_progress(@ps_cpr_id , @ps_context_object, @pl_object_key, NULL, NULL, 'Y') p
		INNER JOIN c_User u
		ON p.user_id = u.user_id
		INNER JOIN p_Attachment a
		ON a.cpr_id = p.cpr_id
		AND a.attachment_id = p.attachment_id
		INNER JOIN c_Attachment_Type at
		ON a.attachment_type = at.attachment_type
		LEFT OUTER JOIN c_Folder f
		ON a.attachment_folder = f.folder
	WHERE a.status = 'OK'
	AND a.cpr_id = @ps_cpr_id
	END

RETURN @ll_count

END

