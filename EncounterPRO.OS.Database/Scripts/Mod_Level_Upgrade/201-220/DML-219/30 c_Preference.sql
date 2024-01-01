

IF NOT EXISTS (SELECT 1 FROM c_preference WHERE preference_id = 'Rich Text Popup Menu')
INSERT INTO c_preference
	( [preference_type]
      ,[preference_id]
      ,[description]
      ,[param_class]
      ,[global_flag]
      ,[office_flag]
      ,[computer_flag]
      ,[specialty_flag]
      ,[user_flag]
      ,[help]
      ,[encrypted]
	)
VALUES ('PREFERENCES',
	'Rich Text Popup Menu',
	'Enable the right click menu in rich text areas',
	'u_param_yesno',
	'Y', 'Y', 'N', 'N', 'Y', 'Select "Yes" to allow the popup menu to be activated in rich text areas.  Default is "No"',
	'N'
	)

IF NOT EXISTS (SELECT 1 FROM o_Preferences WHERE preference_id = 'Rich Text Popup Menu')
INSERT INTO [dbo].[o_Preferences]
           ([preference_type]
           ,[preference_level]
           ,[preference_key]
           ,[preference_id]
           ,[preference_value])
     VALUES
           ('PREFERENCES'
			,'User'
			,'CLINSUPT'
			,'Rich Text Popup Menu'
			,'Y'
		   )
 
-- select dbo.fn_get_specific_preference('PREFERENCES','User','CLINSUPT','Rich Text Popup Menu')

UPDATE p
set query = replace(replace(replace(convert(varchar(500),query), 
	'c_Folder', 'c_Folder f'),
	'SELECT folder, folder','SELECT f.folder, f.folder'),
	'BY folder','BY f.folder')
from c_Preference p
where query  like '%folder, folder%'

