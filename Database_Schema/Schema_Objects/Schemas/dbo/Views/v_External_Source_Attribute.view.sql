CREATE VIEW v_External_Source_Attribute (external_source, 
								param_mode,
								office_id,
								attribute_sequence, 
								attribute, 
								value, 
								attribute_description, 
								sort_sequence, 
								param_sequence) AS

SELECT r.external_source,   
		p.param_mode,
		'<Default>',
		a.attribute_sequence,   
		p.token1,   
		a.value,
		dbo.fn_attribute_description(p.token1, a.value) as attribute_description,
		p.sort_sequence * 2 as sort_sequence,
		p.param_sequence
FROM c_External_Source r
	INNER JOIN c_Component_Param p
	ON r.id = p.id
	LEFT OUTER JOIN c_External_Source_Attribute a
	ON r.external_source = a.external_source
	AND p.token1 = a.attribute
WHERE p.token1 IS NOT NULL
UNION 
SELECT r.external_source,   
		p.param_mode,
		o.office_id,
		a.attribute_sequence,   
		p.token1,   
		a.value,
		dbo.fn_attribute_description(p.token1, a.value) as attribute_description,
		p.sort_sequence * 2 as sort_sequence,
		p.param_sequence
FROM c_External_Source r
	CROSS JOIN c_Office o
	INNER JOIN c_Component_Param p
	ON r.id = p.id
	LEFT OUTER JOIN o_External_Source_Attribute a
	ON r.external_source = a.external_source
	AND o.office_id = a.office_id
	AND p.token1 = a.attribute
WHERE p.token1 IS NOT NULL
