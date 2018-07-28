CREATE PROCEDURE sp_get_letter_count
	(
	@ps_cpr_id varchar(12)
	)
AS

 SELECT  DISTINCT c_Domain.domain_item,   
         selected_flag=0,   
         p_Attachment.attachment_folder,   
         c_Domain.domain_sequence  
FROM c_Domain LEFT OUTER JOIN p_Attachment 
	ON c_Domain.domain_item = p_Attachment.attachment_folder
	AND p_Attachment.cpr_id = @ps_cpr_id
	AND p_Attachment.status = 'OK'
WHERE ( c_Domain.domain_id = 'ATTACHMENT_FOLDER' )
ORDER BY c_Domain.domain_sequence ASC   



