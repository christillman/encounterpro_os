CREATE VIEW v_Report_Component_Attribute (report_id, 
								param_mode,
								attribute_sequence, 
								attribute, 
								value, 
								attribute_description, 
								sort_sequence, 
								param_sequence,
								component_id) AS
SELECT r.report_id,   
		p.param_mode,
		a.attribute_sequence,   
		p.token1,   
		a.value,
		dbo.fn_attribute_description(p.token1, a.value) as attribute_description,
		p.sort_sequence * 2 as sort_sequence,
		p.param_sequence,
		a.component_id
FROM c_Report_Definition r
	INNER JOIN c_Component_Registry c
	ON r.component_id = c.component_id
	INNER JOIN c_Component_Param p
	ON c.id = p.id
	LEFT OUTER JOIN c_Report_Attribute a
	ON r.report_id = a.report_id
	AND p.token1 = a.attribute
	AND a.component_attribute = 'Y'
WHERE p.token1 IS NOT NULL
UNION
SELECT r.report_id,   
		'Config',
		a.attribute_sequence,   
		a.attribute,   
		a.value,
		dbo.fn_attribute_description(a.attribute, a.value) as attribute_description,
		a.attribute_sequence + 2000000 as sort_sequence,
		0,
		a.component_id
FROM c_Report_Definition r
	INNER JOIN c_Component_Registry c
	ON r.component_id = c.component_id
	INNER JOIN c_Report_Attribute a
	ON r.report_id = a.report_id
WHERE a.component_attribute = 'Y'
AND NOT EXISTS (
	SELECT 1
	FROM c_Component_Param p
	WHERE c.id = p.id
	AND a.attribute = p.token1)
