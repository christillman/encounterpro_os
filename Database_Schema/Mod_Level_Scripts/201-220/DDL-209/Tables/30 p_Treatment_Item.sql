

IF NOT EXISTS (SELECT * FROM sys.columns c 
		JOIN sys.tables t ON t.object_id = c.object_id
		WHERE c.object_id = OBJECT_ID(N'[dbo].[p_Treatment_Item]') AND c.name = 'route')
BEGIN
	ALTER TABLE p_Treatment_Item ADD route varchar(30) null
END

ALTER TABLE p_Treatment_Item ALTER COLUMN treatment_description varchar(500) null

GO
