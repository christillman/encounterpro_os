CREATE PROCEDURE jmj_get_available_sources (
	@pl_computer_id int )
AS

-- Get all the external sources for the specified computer that are either always available
-- or on the computer
SELECT DISTINCT s.external_source,   
        s.external_source_type,   
        s.description,   
        s.component_id,   
        button=COALESCE(s.button, t.button),   
        button_title = COALESCE(s.button_title, t.button_title),   
        s.in_office_workplan_id,   
        s.workplan_id,   
        t.sort_sequence,
        s.always_available,
        CASE WHEN c.external_source IS NULL THEN 0 ELSE 1 END as on_computer
FROM c_External_Source s
	INNER JOIN c_External_Source_Type t
	ON s.external_source_type = t.external_source_type
	LEFT OUTER JOIN o_Computer_External_Source c
	ON s.external_source = c.external_source
	AND c.computer_id = @pl_computer_id
WHERE s.always_available = 1
OR CASE WHEN c.external_source IS NULL THEN 0 ELSE 1 END = 1
ORDER BY CASE WHEN c.external_source IS NULL THEN 0 ELSE 1 END desc
/* EXISTS (
	SELECT 1
	FROM o_Computer_External_Source c
	WHERE s.external_source = c.external_source
	AND c.computer_id = @pl_computer_id )
*/

