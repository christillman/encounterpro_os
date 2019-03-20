
-- Remove unused specialty details
DELETE from c_Common_Drug 
 where specialty_id not in (select specialty_id from c_Specialty)
DELETE from c_Common_Assessment
 where specialty_id not in (select specialty_id from c_Specialty)
DELETE from c_Common_Observation 
 where specialty_id not in (select specialty_id from c_Specialty)
DELETE from c_Common_Procedure 
 where specialty_id not in (select specialty_id from c_Specialty)


GO

DELETE FROM [c_Database_System]
WHERE [system_id] = 'Assessments ICD'
AND [current_version] = 'Kenya'

-- New record to indicate installation country
INSERT INTO [c_Database_System]
           ([system_id]
           ,[system_type]
           ,[current_version]
           ,[sort_sequence])
     VALUES
           ('Assessments ICD'
           ,'Version'
           ,'Kenya'
           ,10
		   )
GO



DELETE FROM [c_Database_Column]
WHERE tablename = 'c_ICD_Updates' and columnname = 'assessment_category_id'

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
           ('c_ICD_Updates'
           ,'assessment_category_id'
           ,8
           ,'varchar'
           ,12
           ,0
           ,1
           ,'[varchar](12)'
           ,0
           ,null
           ,null
           ,203
           ,getdate()
		   )


DELETE FROM [c_Database_Column]
WHERE tablename = 'c_ICD_Updates' and columnname = 'assessment_type'

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
           ('c_ICD_Updates'
           ,'assessment_type'
           ,7
           ,'varchar'
           ,12
           ,0
           ,1
           ,'[varchar](12)'
           ,0
           ,null
           ,null
           ,203
           ,getdate()
		   )


DELETE FROM [c_Database_Column]
WHERE tablename = 'c_ICD_Updates' and columnname = 'assessment_id'

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
           ('c_ICD_Updates'
           ,'assessment_id'
           ,12
           ,'varchar'
           ,24
           ,0
           ,1
           ,'[varchar](24)'
           ,0
           ,null
           ,null
           ,203
           ,getdate()
		   )

-- We retained the icd_9_code column in these tables
exec [add_c_database_column] 'c_Assessment_Coding', 'icd_9_code'
exec [add_c_database_column] 'c_Assessment_Definition', 'icd_9_code'
exec [add_c_database_column] 'c_Authority_Formulary', 'icd_9_code'
exec [add_c_database_column] 'c_ICD_Code', 'icd_9_code'
exec [add_c_database_column] 'c_ICD_Properties', 'icd_9_code'
exec [add_c_database_column] 'c_ICD_Updates', 'icd_9_code'
exec [add_c_database_column] 'c_Maintenance_Assessment', 'icd_9_code'
exec [add_c_database_column] 'p_Encounter_Assessment', 'icd_9_code'

UPDATE c 
SET column_sequence = (select count(*) from c_Database_Column c2 where c2.tablename = c.tablename)
FROM c_Database_Column c
WHERE columnname = 'icd10_code'  AND tablename IN ('c_Assessment_Coding', 'c_Assessment_Definition', 'c_Authority_Formulary',
	'c_ICD_Code', 'c_ICD_Properties', 'c_ICD_Updates', 'c_Maintenance_Assessment', 'p_Encounter_Assessment')

-- Wrong column widths for icd10_code
UPDATE c_Database_Column 
SET column_length = 10, column_definition = '[varchar](10)', column_nullable = 1, modification_level = 203
WHERE columnname = 'icd10_code'

UPDATE c_Database_Column
SET column_length = 24, column_definition = '[varchar](24)', modification_level = 203
WHERE tablename = 'p_Assessment' AND columnname = 'acuteness'

UPDATE c_Database_Column
SET column_nullable = 1, default_constraint = 0, modification_level = 203
WHERE tablename = 'c_Assessment_Definition' AND columnname = 'acuteness'

UPDATE c_Database_Column
SET column_length = 500, column_datatype = 'varchar', column_definition = '[varchar](500)', modification_level = 203
WHERE tablename = 'c_Assessment_Definition' AND columnname = 'long_description'

-- Changes for Mod 203
DELETE FROM [c_Database_Column]
WHERE tablename IN ('c_Drug_Brand', 'c_Reccomended_Observation')
DELETE FROM [c_Database_Table]
WHERE tablename IN ('c_Drug_Brand', 'c_Reccomended_Observation')

exec [add_c_database_table] 'c_List_Item'
exec [add_c_database_table] 'c_Patient_List_Item'

UPDATE c_Database_Column
SET column_length = 80, modification_level = 203
WHERE tablename = 'p_Patient' AND columnname = 'address_line_1'

DELETE FROM [c_Database_Column]
WHERE tablename = 'p_Patient_Progress' AND columnname = 'id'

UPDATE c_Database_Column
SET default_constraint = 1, 
	default_constraint_name = 'DF__o_Service__id',
	default_constraint_text = '(newid())', 
	modification_level = 203
WHERE tablename = 'o_Service' AND columnname = 'id'

UPDATE c_Database_Column
SET column_length = 500, column_definition = '[varchar](500)', modification_level = 203
WHERE tablename = 'c_Drug_Definition' AND columnname = 'generic_name'

UPDATE c_Database_Column
SET column_length = 80, column_definition = '[varchar](80)', modification_level = 203
WHERE tablename = 'c_Drug_Definition' AND columnname = 'common_name'


UPDATE c_Database_Status   set modification_level = 203, last_scripts_update = getdate() where 1 = 1

  -- select * from [fn_database_schemacheck_columns]()