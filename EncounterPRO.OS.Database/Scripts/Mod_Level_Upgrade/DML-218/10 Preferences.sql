

IF NOT EXISTS (SELECT 1 FROM c_preference WHERE preference_id = 'NameCap')
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
	'NameCap',
	'Force people names to be formatted with initial caps',
	'u_param_yesno',
	'Y', 'Y', 'N', 'N', 'N', 'Select "Yes" to force people names to be formatted with first letters capitalized.  Default is "No"',
	'N'
	)

IF NOT EXISTS (SELECT 1 FROM o_Preferences WHERE preference_id = 'NameCap')
INSERT INTO [dbo].[o_Preferences]
           ([preference_type]
           ,[preference_level]
           ,[preference_key]
           ,[preference_id]
           ,[preference_value])
     VALUES
           ('PREFERENCES'
			,'Global'
			,'Global'
			,'NameCap'
			,'Y'
		   )
  
UPDATE o_preferences
SET preference_value = '{Last}, {First}{ Middle}'
where preference_value = '{Last}, {First}{Middle}'

-- Fix for bug I ran across in fn_epro_object_properties
 UPDATE p 
  SET return_data_type = 
  CASE WHEN function_name like '%date%' or function_name like '%time%' THEN 'datetime'
	WHEN function_name like '%key%' THEN 'string'
	WHEN function_name like '%image%' or function_name like '%object%' THEN 'binary'
	WHEN function_name like '%seq%' THEN 'number'
	WHEN function_name like '%amount%' THEN 'number'
	WHEN function_name like '%flag%'  or function_name like '%ed' or function_name = 'default_grant' THEN 'boolean'
	WHEN function_name like '%instructions%'  or function_name like '%long_description%'  or function_name like '%text%' THEN 'text'
	ELSE 'string' END
	FROM c_Property p
	WHERE return_data_type IS NULL