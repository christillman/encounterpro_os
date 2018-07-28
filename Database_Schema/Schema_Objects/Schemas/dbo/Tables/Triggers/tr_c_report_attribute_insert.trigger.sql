CREATE TRIGGER tr_c_report_attribute_insert ON dbo.c_report_attribute
FOR INSERT, UPDATE
AS

IF @@ROWCOUNT = 0
	RETURN

UPDATE a
SET component_attribute = 'Y'
FROM c_Report_Attribute a
	INNER JOIN inserted i
	ON a.report_id = i.report_id
	AND a.attribute_sequence = i.attribute_sequence
	INNER JOIN c_Report_Definition r
	ON r.report_id = a.report_id
	INNER JOIN c_Component_Registry c
	ON r.component_id = c.component_id
	INNER JOIN c_Component_Param p
	ON c.id = p.id
	AND p.token1 = a.attribute
WHERE a.component_attribute = 'N'

-- If we're attaching an rtf script that was only just now created then assume that we're
-- copying/creating an RTF report and rename the RTF script to match the report name
UPDATE d
SET description = r.description,
	display_script = CAST(r.description AS varchar(40))
FROM c_Display_Script d
	INNER JOIN (SELECT report_id, display_script_id = CAST(value AS int)
				FROM inserted
				WHERE attribute IN ('display_script_id', 'xml_script_id')
				AND ISNUMERIC(value) = 1
				) x
	ON d.display_script_id = x.display_script_id
	INNER JOIN c_Report_Definition r
	ON r.report_id = x.report_id
	CROSS JOIN c_Database_Status s
WHERE s.customer_id = r.owner_id
AND d.last_updated > DATEADD(second, -30, r.last_updated)


UPDATE a
SET last_modified = getdate()
FROM c_report_attribute a
	INNER JOIN inserted i
	ON a.report_id = i.report_id
	AND a.attribute_sequence = i.attribute_sequence

