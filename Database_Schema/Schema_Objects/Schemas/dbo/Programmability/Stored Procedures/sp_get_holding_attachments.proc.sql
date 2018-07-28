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
    FROM c_User WITH (NOLOCK),   
       	 c_Attachment_Type WITH (NOLOCK),   
         p_Attachment WITH (NOLOCK) 
   WHERE ( c_Attachment_Type.attachment_type = p_Attachment.attachment_type ) and  
       	 ( c_User.user_id = p_Attachment.created_by ) and  
         ( p_Attachment.cpr_id is null ) and
	 ( p_Attachment.status = 'OK' )
   ORDER BY p_Attachment.created desc


