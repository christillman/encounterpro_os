
-- minor correction for new chart page
update [c_Chart_Page_Definition]
set default_tab_description = 'Lab Results'
where description = 'Lab Results'
