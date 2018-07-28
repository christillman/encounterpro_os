CREATE TRIGGER tr_c_config_object_insert_update ON dbo.c_config_object
FOR INSERT, UPDATE
AS

IF UPDATE(description)
	BEGIN
	UPDATE v
	SET description = i.description
	FROM c_Config_Object_Version v
		INNER JOIN inserted i
		ON v.config_object_id = i.config_object_id
	WHERE v.description <> i.description

	UPDATE r
	SET description = i.description
	FROM c_Report_Definition r
		INNER JOIN inserted i
		ON r.report_id = i.config_object_id
	WHERE r.description <> i.description

	END

