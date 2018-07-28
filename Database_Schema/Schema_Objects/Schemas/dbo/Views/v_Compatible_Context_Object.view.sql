CREATE VIEW v_Compatible_Context_Object (context_object, compatible_context_object) AS

SELECT d1.domain_item as context_object,
		d2.domain_item as compatible_context_object
FROM c_Domain d1
	INNER JOIN c_Domain d2
	ON d1.domain_id = d2.domain_id
WHERE d1.domain_id = 'CONTEXT_OBJECT'
AND dbo.fn_context_compatible(d1.domain_item, d2.domain_item) = 1


