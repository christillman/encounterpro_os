CREATE VIEW v_Display_Script_Cmd_Attribute (display_script_id, display_command_id, attribute_sequence, attribute, value, attribute_description, sort_sequence, param_sequence) AS

SELECT c.display_script_id,   
		c.display_command_id,   
		a.attribute_sequence,   
		p.token1,   
		COALESCE(a.value, a.long_value) as value,   
		CASE WHEN a.value IS NULL AND a.long_value IS NOT NULL THEN CAST('<Long Value>' AS varchar(255))
			ELSE dbo.fn_attribute_description(p.token1, a.value) END as attribute_description,
		p.sort_sequence * 2 as sort_sequence,
		p.param_sequence
FROM c_Display_Script_Command c
	INNER JOIN c_Display_Script ds
	ON c.display_script_id = ds.display_script_id
	INNER JOIN c_Display_Command_Definition cd
	ON c.context_object = cd.context_object
	AND c.display_command = cd.display_command
	AND ds.script_type = cd.script_type
	INNER JOIN c_Component_Param p
	ON cd.id = p.id
	LEFT OUTER JOIN c_Display_Script_Cmd_Attribute a
	ON c.display_script_id = a.display_script_id
	AND c.display_command_id = a.display_command_id
	AND p.token1 = a.attribute
WHERE p.token1 IS NOT NULL
