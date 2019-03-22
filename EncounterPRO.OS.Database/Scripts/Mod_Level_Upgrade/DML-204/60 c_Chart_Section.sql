
-- Orphaned from c_Chart_Section_Page
DELETE a
FROM [c_Chart_Section_Page_Attribute] a
WHERE NOT EXISTS (select 1 from c_Chart_Section_page p
	where p.page_id = a.page_id and p.chart_id = a.chart_id and p.section_id = a.section_id)

-- Orphaned from c_Display_Script
DELETE FROM [c_Chart_Section_Page_Attribute] 
WHERE value in ('192','193','378','407')

