CREATE PROCEDURE sp_get_folder_list
	(
	@ps_context_object varchar(40) = NULL,
	@ps_cpr_id varchar(12) = NULL,
	@ps_status varchar(12) = 'OK'
	)
AS

IF @ps_context_object IS NULL
	SET @ps_context_object = '%'

DECLARE @folders TABLE (
	[folder] [varchar] (40) NOT NULL ,
	[context_object] [varchar] (50) NOT NULL ,
	[description] [varchar] (255) NOT NULL ,
	[status] [varchar] (12) NOT NULL ,
	[sort_sequence] [int] NULL ,
	[id] [varchar] (36) NOT NULL,
	[object_count] [int] NOT NULL DEFAULT (0) )

INSERT INTO @folders (
	[folder] ,
	[context_object] ,
	[description] ,
	[status] ,
	[sort_sequence] ,
	[id] )
SELECT 
	[folder] ,
	[context_object] ,
	[description] ,
	[status] ,
	[sort_sequence] ,
	CAST([id] as varchar(36))
FROM c_Folder
WHERE context_object LIKE @ps_context_object
AND status = @ps_status

IF @ps_cpr_id IS NOT NULL
	UPDATE f
	SET object_count = a.attachment_count
	FROM @folders f
		INNER JOIN (SELECT attachment_folder, count(*) as attachment_count
					FROM p_Attachment
					WHERE cpr_id = @ps_cpr_id
					AND status = 'OK'
					AND attachment_type <> 'Signature'
					GROUP BY attachment_folder) a
		ON f.folder = a.attachment_folder

SELECT 	[folder] ,
	[context_object] ,
	[description] ,
	[status] ,
	[sort_sequence] ,
	[id],
	[object_count],
	selected_flag=0
FROM @folders

