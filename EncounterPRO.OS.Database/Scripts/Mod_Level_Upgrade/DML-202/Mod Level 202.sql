

-- nvarchar columns take 2x as much space
UPDATE c_database_column SET column_length = 256 
WHERE tablename = 'o_Log' and columnname = 'compile_name'
UPDATE c_database_column SET column_length = 96
WHERE tablename = 'c_Component_Version' and columnname = 'system_id'
UPDATE c_database_column SET column_length = 256 
WHERE tablename = 'c_Component_Version' and columnname = 'build_name'
UPDATE c_database_column SET column_length = 256 
WHERE tablename = 'c_Component_Version' and columnname = 'compile_name'

-- Other reconciliations status to actual
UPDATE c_database_column SET default_constraint = 'False' 
WHERE tablename = 'c_Patient_material' and columnname = 'document_id'
UPDATE c_database_column SET default_constraint_text = '((0))' 
WHERE tablename = 'c_XML_Code' and columnname = 'unique_flag'

DELETE FROM [c_Database_Column]
WHERE tablename = 'c_Component_Type' and columnname = 'plugin_type'

INSERT INTO [c_Database_Column]
           ([tablename]
           ,[columnname]
           ,[column_sequence]
           ,[column_datatype]
           ,[column_length]
           ,[column_identity]
           ,[column_nullable]
           ,[column_definition]
           ,[default_constraint]
           ,[default_constraint_name]
           ,[default_constraint_text]
           ,[modification_level]
           ,[last_updated])
     VALUES
           ('c_Component_Type'
           ,'plugin_type'
           ,7
           ,'varchar'
           ,40
           ,0
           ,1
           ,'[varchar](40)'
           ,0
           ,null
           ,null
           ,202
           ,getdate()
		   )


DELETE FROM [c_Database_Column]
WHERE tablename = 'c_Config_Object' and columnname = 'installed_local_key'

INSERT INTO [c_Database_Column]
           ([tablename]
           ,[columnname]
           ,[column_sequence]
           ,[column_datatype]
           ,[column_length]
           ,[column_identity]
           ,[column_nullable]
           ,[column_definition]
           ,[default_constraint]
           ,[default_constraint_name]
           ,[default_constraint_text]
           ,[modification_level]
           ,[last_updated])
     VALUES
           ('c_Config_Object'
           ,'installed_local_key'
           ,26
           ,'int'
           ,4
           ,0
           ,1
           ,'[int]'
           ,0
           ,null
           ,null
           ,202
           ,getdate()
		   )


DELETE FROM [c_Database_Column]
WHERE tablename = 'c_Epro_Object' and columnname = 'default_ordinal'

INSERT INTO [c_Database_Column]
           ([tablename]
           ,[columnname]
           ,[column_sequence]
           ,[column_datatype]
           ,[column_length]
           ,[column_identity]
           ,[column_nullable]
           ,[column_definition]
           ,[default_constraint]
           ,[default_constraint_name]
           ,[default_constraint_text]
           ,[modification_level]
           ,[last_updated])
     VALUES
           ('c_Epro_Object'
           ,'default_ordinal'
           ,14
           ,'nchar'
           ,20
           ,0
           ,1
           ,'[nchar](10)'
           ,0
           ,null
           ,null
           ,202
           ,getdate()
		   )


DELETE FROM [c_Database_Column]
WHERE tablename = 'p_Encounter_Charge' and columnname = 'units_billed'

INSERT INTO [c_Database_Column]
           ([tablename]
           ,[columnname]
           ,[column_sequence]
           ,[column_datatype]
           ,[column_length]
           ,[column_identity]
           ,[column_nullable]
           ,[column_definition]
           ,[default_constraint]
           ,[default_constraint_name]
           ,[default_constraint_text]
           ,[modification_level]
           ,[last_updated])
     VALUES
           ('p_Encounter_Charge'
           ,'units_billed'
           ,23
           ,'int'
           ,4
           ,0
           ,1
           ,'[int]'
           ,0
           ,null
           ,null
           ,202
           ,getdate()
		   )

DELETE FROM [c_Database_Column]
WHERE tablename = 'p_Encounter_Charge' and columnname = 'charge_billed'

INSERT INTO [c_Database_Column]
           ([tablename]
           ,[columnname]
           ,[column_sequence]
           ,[column_datatype]
           ,[column_length]
           ,[column_identity]
           ,[column_nullable]
           ,[column_definition]
           ,[default_constraint]
           ,[default_constraint_name]
           ,[default_constraint_text]
           ,[modification_level]
           ,[last_updated])
     VALUES
           ('p_Encounter_Charge'
           ,'charge_billed'
           ,24
           ,'money'
           ,8
           ,0
           ,1
           ,'[money]'
           ,0
           ,null
           ,null
           ,202
           ,getdate()
		   )


update 	[c_Database_Column] set  column_length = 20
where tablename = 'p_Assessment'
and columnname = 'acuteness'

update 	[c_Database_Column] set  column_length = '80'
where tablename = 'v_Diagnosed_Patients'
and columnname = 'assessment'


DELETE FROM c_Database_Column
WHERE tablename = 'c_Assessment_Definition'
AND columnname IN ('icd10_code')

INSERT INTO [dbo].[c_Database_Column]
           ([tablename]
           ,[columnname]
           ,[column_sequence]
           ,[column_datatype]
           ,[column_length]
           ,[column_identity]
           ,[column_nullable]
           ,[column_definition]
           ,[default_constraint]
           ,[modification_level]
           ,[last_updated])
     VALUES
           ('c_Assessment_Definition'
           ,'icd10_code'
           ,2
           ,'varchar'
           ,10
           ,0
           ,0
           ,'[varchar](10)'
           ,0
           ,202
           ,getdate()
		   )

DELETE FROM c_Database_Column
WHERE tablename = 'c_Assessment_Category'
AND columnname IN ('icd10_start','icd10_end')

INSERT INTO [dbo].[c_Database_Column]
           ([tablename]
           ,[columnname]
           ,[column_sequence]
           ,[column_datatype]
           ,[column_length]
           ,[column_identity]
           ,[column_nullable]
           ,[column_definition]
           ,[default_constraint]
           ,[modification_level]
           ,[last_updated])
     VALUES
           ('c_Assessment_Category'
           ,'icd10_start'
           ,5
           ,'varchar'
           ,3
           ,0
           ,1
           ,'[varchar](3)'
           ,0
           ,202
           ,getdate()
		   )


INSERT INTO [dbo].[c_Database_Column]
           ([tablename]
           ,[columnname]
           ,[column_sequence]
           ,[column_datatype]
           ,[column_length]
           ,[column_identity]
           ,[column_nullable]
           ,[column_definition]
           ,[default_constraint]
           ,[modification_level]
           ,[last_updated])
     VALUES
           ('c_Assessment_Category'
           ,'icd10_end'
           ,6
           ,'varchar'
           ,3
           ,0
           ,1
           ,'[varchar](3)'
           ,0
           ,202
           ,getdate()
		   )

GO


DELETE FROM [dbo].[c_Privilege]
WHERE privilege_id = 'Edit Assessment'

INSERT INTO [dbo].[c_Privilege]
           ([privilege_id]
           ,[description]
           ,[secure_flag]
           ,[created]
           ,[created_by]
           ,[last_updated]
           ,[id])
     VALUES
           ('Edit Assessment'
           ,'User may edit assessment descriptions and metadata'
           ,'Y'
           ,getdate()
           ,'#SYSTEM'
           ,getdate()
           ,newid()
		   )

GO


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

UPDATE c_Database_Status   set modification_level = 202, last_scripts_update = getdate() where 1 = 1

  -- select * from [fn_database_schemacheck_columns]()
