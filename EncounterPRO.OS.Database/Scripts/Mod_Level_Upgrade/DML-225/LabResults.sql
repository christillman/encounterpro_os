
update p_Attachment
set attachment_folder = 'Lab Reports'
where attachment_folder = 'Lab Results'

delete from c_Folder
where folder = 'Lab Results'
