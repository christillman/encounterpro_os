CREATE VIEW v_Report_Attribute (report_id, 
								param_mode,
								office_id,
								attribute_sequence, 
								attribute, 
								value, 
								attribute_description, 
								sort_sequence, 
								param_sequence) AS

SELECT r.report_id,   
		p.param_mode,
		'<Default>',
		a.attribute_sequence,   
		p.token1,   
		a.value,
		dbo.fn_attribute_description(p.token1, a.value) as attribute_description,
		p.sort_sequence * 2 as sort_sequence,
		p.param_sequence
FROM c_Report_Definition r
	INNER JOIN c_Component_Param p
	ON r.report_id = p.id
	LEFT OUTER JOIN c_Report_Attribute a
	ON r.report_id = a.report_id
	AND p.token1 = a.attribute
WHERE p.token1 IS NOT NULL
UNION 
SELECT r.report_id,   
		p.param_mode,
		o.office_id,
		a.attribute_sequence,   
		p.token1,   
		a.value,
		dbo.fn_attribute_description(p.token1, a.value) as attribute_description,
		p.sort_sequence * 2 as sort_sequence,
		p.param_sequence
FROM c_Report_Definition r
	CROSS JOIN c_Office o
	INNER JOIN c_Component_Param p
	ON r.report_id = p.id
	LEFT OUTER JOIN o_Report_Attribute a
	ON r.report_id = a.report_id
	AND o.office_id = a.office_id
	AND p.token1 = a.attribute
WHERE p.token1 IS NOT NULL
