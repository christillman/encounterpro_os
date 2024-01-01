
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_holding_attachments]
Print 'Drop Procedure [dbo].[sp_get_holding_attachments]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_holding_attachments]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_holding_attachments]
GO

-- Create Procedure [dbo].[sp_get_holding_attachments]
Print 'Create Procedure [dbo].[sp_get_holding_attachments]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_holding_attachments
AS

  SELECT c_User.user_full_name,   
         p_Attachment.attachment_id,   
       	 p_Attachment.attachment_tag,   
       	 p_Attachment.created,  
	 p_Attachment.attachment_type,
	 p_Attachment.attachment_file_path,
	 p_Attachment.attachment_file,
	 p_Attachment.extension,
	 p_Attachment.storage_flag,
	 selected_flag=0
    FROM c_User WITH (NOLOCK)      
         JOIN p_Attachment WITH (NOLOCK) ON c_User.user_id = p_Attachment.created_by
       	 JOIN c_Attachment_Type WITH (NOLOCK) ON c_Attachment_Type.attachment_type = p_Attachment.attachment_type
   WHERE p_Attachment.cpr_id is null
	AND p_Attachment.status = 'OK'
   ORDER BY p_Attachment.created desc


GO
GRANT EXECUTE
	ON [dbo].[sp_get_holding_attachments]
	TO [cprsystem]
GO

