
-- Remove invalid attachment locations
DELETE FROM c_Attachment_Location
WHERE attachment_server IN ('CORE','ict1')

INSERT INTO c_Attachment_Location (attachment_server, attachment_share, status)
SELECT 'localhost', 'attachments', 'OK'
FROM c_1_record
WHERE NOT EXISTS (SELECT 1 FROM c_Attachment_Location
	WHERE attachment_server = 'localhost')
GO
 
-- Replace EPImageViewer with shell command (uses Windows Photos for example)
update c_attachment_extension 
set open_command = null, edit_command = null
where open_command = 'jmj_image'

GO

UPDATE c_Database_Status   set modification_level = 201, last_scripts_update = getdate() where 1 = 1
