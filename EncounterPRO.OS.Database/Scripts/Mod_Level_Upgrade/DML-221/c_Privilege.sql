
IF NOT EXISTS (SELECT 1 FROM [c_Privilege]
		WHERE [privilege_id] = 'Edit Patient Details') 
  INSERT INTO [c_Privilege] ( [privilege_id]
      ,[description]
      ,[secure_flag]
	  ,[created]
	  ,[created_by]
	  ,id
	  )
	VALUES ('Edit Patient Details', 
		'User may edit patient personal details', 
		'Y',
		getdate(),
		SYSTEM_USER,
		newid()
		)