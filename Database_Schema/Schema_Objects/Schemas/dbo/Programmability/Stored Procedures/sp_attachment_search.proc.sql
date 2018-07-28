CREATE PROCEDURE sp_attachment_search
	(
	@ps_cpr_id varchar(12),
	@ps_folder varchar(40),
	@ps_attachment_type varchar(24),
	@ps_attachment_tag varchar(80),
	@ps_extension varchar(24)
	)
AS

IF @ps_folder IS NULL
	SET @ps_folder = '%'

IF @ps_attachment_type IS NULL
	SET @ps_attachment_type = '%'

IF @ps_attachment_tag IS NULL
	SET @ps_attachment_tag = '%'

IF @ps_extension IS NULL
	SET @ps_extension = '%'

SELECT attachment_id,
		attachment_type,
		attachment_tag,
		extension,
		attachment_folder
FROM p_Attachment
WHERE cpr_id = @ps_cpr_id
AND ISNULL(attachment_folder, '') LIKE @ps_folder
AND ISNULL(attachment_type, '') LIKE @ps_attachment_type
AND ISNULL(attachment_tag, '') LIKE @ps_attachment_tag
AND ISNULL(extension, '') LIKE @ps_extension

