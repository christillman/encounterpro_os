CREATE PROCEDURE sp_get_patient_folder_list (
	@ps_cpr_id varchar(12) )
AS

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
WHERE context_object IS NOT NULL
AND context_object <> 'General'
AND status = 'OK'

IF @ps_cpr_id IS NOT NULL
	UPDATE f
	SET object_count = a.attachment_count
	FROM @folders f
		INNER JOIN (
					SELECT a.attachment_folder, count(*) as attachment_count
					FROM p_Attachment a
						LEFT OUTER JOIN p_Patient_Progress pp
						ON a.cpr_id = pp.cpr_id
						AND a.attachment_id = pp.attachment_id
						AND pp.current_flag = 'Y'
					WHERE a.status = 'OK'
					AND a.cpr_id = @ps_cpr_id
					AND a.attachment_type <> 'Signature'
					GROUP BY a.attachment_folder ) a
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

