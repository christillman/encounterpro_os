CREATE PROCEDURE sp_get_attachments (
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(24),
	@pl_object_key int)
AS

IF @ps_context_object = 'Patient'
	BEGIN
	SELECT u.user_full_name,   
			at.button,   
			a.attachment_id,   
			a.attachment_tag,   
			a.attachment_text,   
			a.created,  
			a.attachment_folder,
			a.attachment_type,
			a.attached_by,
			ISNULL(pp.progress_type, 'Attachment'),
			pp.progress_key,
			a.attachment_date,   
			selected_flag = 0,
			a.extension,
			f.status AS folder_status,
			DATALENGTH(a.attachment_image) as attachment_length
	FROM p_Attachment a
		INNER JOIN c_Attachment_Type at
		ON a.attachment_type = at.attachment_type
		INNER JOIN c_User u
		ON a.created_by = u.user_id
		LEFT OUTER JOIN p_Patient_Progress pp
		ON a.cpr_id = pp.cpr_id
		AND a.attachment_id = pp.attachment_id
		AND pp.current_flag = 'Y'
		LEFT OUTER JOIN c_Folder f
		ON a.attachment_folder = f.folder
	WHERE a.status = 'OK'
	AND a.cpr_id = @ps_cpr_id
	ORDER BY a.created desc
	END
ELSE
	BEGIN
	SELECT u.user_full_name,   
			at.button,   
			a.attachment_id,   
			a.attachment_tag,   
			a.attachment_text,   
			a.created,
			a.attachment_folder,
			a.attachment_type,
			p.user_id,
			p.progress_type,
			p.progress_key,
			p.progress_date_time,   
			selected_flag=0,
			a.extension,
			f.status AS folder_status,
			DATALENGTH(a.attachment_image) as attachment_length
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

