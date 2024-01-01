
IF NOT EXISTS (SELECT 1 FROM sys.columns c join sys.tables t on t.object_id = c.object_id 
	WHERE t.name = 'c_Assessment_Definition' and c.name = 'source')
	 BEGIN ALTER TABLE c_Assessment_Definition 
	 ADD [source] varchar(10)
	 END

IF NOT EXISTS (SELECT 1 FROM sys.columns c join sys.tables t on t.object_id = c.object_id 
	WHERE t.name = 'c_Assessment_Definition' and c.name = 'icd10_who_code')
	 BEGIN ALTER TABLE c_Assessment_Definition 
	 ADD icd10_who_code varchar(10)
	 END
