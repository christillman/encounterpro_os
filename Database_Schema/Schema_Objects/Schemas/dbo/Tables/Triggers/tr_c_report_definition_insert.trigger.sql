CREATE TRIGGER tr_c_report_definition_insert ON dbo.c_report_definition
FOR INSERT
AS

-- Set the report to be locally owned if an owner_id wasn't specified
UPDATE c_report_definition
SET owner_id = c_Database_Status.customer_id
FROM c_report_definition
	INNER JOIN inserted
	ON c_report_definition.report_id = inserted.report_id
	CROSS JOIN c_Database_Status
WHERE inserted.owner_id = -1

-- Add the report to c_Config_Object if it's not already there
INSERT INTO c_Config_Object (
	config_object_id,
	config_object_type,
	context_object,
	description,
	config_object_category,
	installed_version,
	latest_version,
	owner_id,
	owner_description,
	created,
	created_by,
	status)
SELECT i.report_id,
	i.config_object_type,
	r.report_type,
	r.description,
	r.report_category,
	CASE WHEN r.version >= 0 THEN r.version 
							ELSE CASE WHEN r.owner_id = d.customer_id THEN 1 ELSE 0 END
							END,
	CASE WHEN r.version >= 0 THEN r.version 
							ELSE CASE WHEN r.owner_id = d.customer_id THEN 1 ELSE 0 END
							END,
	r.owner_id,
	dbo.fn_owner_description(r.owner_id),
	r.last_updated,
	ISNULL(dbo.fn_current_epro_user(), '#SYSTEM'),
	r.status
FROM c_report_definition r
	INNER JOIN inserted i
	ON r.report_id = i.report_id
	CROSS JOIN c_Database_Status d
WHERE NOT EXISTS (
	SELECT 1
	FROM c_Config_Object c
	WHERE r.report_id = c.config_object_id)




