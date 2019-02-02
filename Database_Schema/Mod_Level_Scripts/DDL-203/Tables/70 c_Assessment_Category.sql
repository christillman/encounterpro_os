
IF NOT EXISTS (SELECT 1 FROM sys.columns c join sys.tables t on t.object_id = c.object_id 
	WHERE t.name = 'c_Assessment_Category' and c.name = 'is_default')
	 BEGIN ALTER TABLE c_Assessment_Category ADD is_default char(1)  END
