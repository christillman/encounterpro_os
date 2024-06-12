/*
SELECT *
  FROM [Ciru_20240517].[dbo].[c_Preference]
  where (
  help like '%rtf%'
  or description like '%rtf%'
  or help like '%script%'
  or description like '%script%'
  or param_class = 'u_param_display_script')
and help not like '%prescription%'
and help not like '%surescript%'
and description not like '%surescript%'
and preference_type not in ('RX','V2V4')
*/

DELETE FROM [c_Preference_Type] WHERE preference_type = 'SCRIPT'
INSERT INTO [c_Preference_Type] VALUES('SCRIPT','Display Scripts Preferences')

DELETE FROM [c_Preference]
WHERE [preference_id] IN ('Progress Note Title Format','Progress Note Text Format')
DELETE FROM [o_Preferences]
WHERE [preference_id] IN ('Progress Note Title Format','Progress Note Text Format')

INSERT INTO [c_Preference]
           ([preference_type]
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
           ,[universal_flag])
     VALUES
           ('SCRIPT'
           ,'Progress Note Title Format'
           ,'Font settings for progress note titles'
           ,'u_param_string'
           ,'Y'
           ,'Y'
           ,'N'
           ,'Y'
           ,'Y'
           ,'Set to font formatting string to be used for displaying progress note titles.  (See RTF Report Documentation for a description of formattting strings)'
           ,'N'
           ,'N'
		   )

		   
INSERT INTO [c_Preference]
           ([preference_type]
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
           ,[universal_flag])
     VALUES
           ('SCRIPT'
           ,'Progress Note Text Format'
           ,'Font settings for progress note text'
           ,'u_param_string'
           ,'Y'
           ,'Y'
           ,'N'
           ,'Y'
           ,'Y'
           ,'Set to font formatting string to be used for displaying progress note text.  (See RTF Report Documentation for a description of formattting strings)'
           ,'N'
           ,'N'
		   )


INSERT INTO [o_Preferences]
           ([preference_type]
           ,[preference_level]
           ,[preference_key]
           ,[preference_id]
           ,[preference_value])
     VALUES
           ('SCRIPT'
           ,'Global'
           ,'Global'
           ,'Progress Note Title Format'
           ,'fontsize=11,left,bold,margin=0/0/0,fc=0'
		   )

INSERT INTO [o_Preferences]
           ([preference_type]
           ,[preference_level]
           ,[preference_key]
           ,[preference_id]
           ,[preference_value])
     VALUES
           ('SCRIPT'
           ,'Global'
           ,'Global'
           ,'Progress Note Text Format'
           ,'fontsize=11,left,xbold,margin=0/0/0,fc=10485760'
		   )
GO

