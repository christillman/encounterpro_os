/*
SELECT *
  FROM [c_Chart_Section_Page_Attribute] p
  left join c_display_script d on d.display_script_id = case when Isnumeric(p.value) = 1 and left(p.value,1) between '0' and '9' then convert(int,p.value) else 0 end
  where attribute like '%display_script%'
  and d.display_script_id is null
  */

  delete from [c_Chart_Section_Page_Attribute]
  where attribute_sequence = 2297

  -- substitute similar script for a missing one
  update [c_Chart_Section_Page_Attribute] 
  set value = '473'
  where attribute = 'display_script_id'
  and value = '286'

  /*
  SELECT *
  INTO c_Display_Script_Archive
  FROM c_display_script d 
  where not exists (select 1 from [c_Chart_Section_Page_Attribute] p 
  where attribute like 'display_script%'
  and d.display_script_id = case when Isnumeric(p.value) = 1 and charindex('.',p.value) = 0 and left(p.value,1) between '0' and '9' then convert(int,p.value) else 0 end
  )
  and not exists (select 1 from c_Display_Script_Cmd_Attribute p 
  where attribute like 'display_script%'
  and d.display_script_id = case when Isnumeric(p.value) = 1 and charindex('.',p.value) = 0 and left(p.value,1) between '0' and '9' then convert(int,p.value) else 0 end
  )
  and not exists (select 1 from [c_Report_Attribute] p 
  where attribute like 'display_script%'
  and d.display_script_id = case when Isnumeric(p.value) = 1 and charindex('.',p.value) = 0 and left(p.value,1) between '0' and '9' then convert(int,p.value) else 0 end
  )
  and not exists (select 1 from [c_Treatment_Type_Service_Attribute] p 
  where attribute like 'display_script%'
  and d.display_script_id = case when Isnumeric(p.value) = 1 and charindex('.',p.value) = 0 and left(p.value,1) between '0' and '9' then convert(int,p.value) else 0 end
  )
  and not exists (select 1 from [c_Workplan_Item_Attribute] p 
  where attribute like 'display_script%'
  and d.display_script_id = case when Isnumeric(p.value) = 1 and charindex('.',p.value) = 0 and left(p.value,1) between '0' and '9' then convert(int,p.value) else 0 end
  )
  and not exists (select 1 from [o_Service_Attribute] p 
  where attribute like 'display_script%'
  and d.display_script_id = case when Isnumeric(p.value) = 1 and charindex('.',p.value) = 0 and left(p.value,1) between '0' and '9' then convert(int,p.value) else 0 end
  )
  and not exists (select 1 from [p_Patient_WP_Item_Attribute] p 
  where attribute like 'display_script%'
  and d.display_script_id = case when Isnumeric(p.value) = 1 and charindex('.',p.value) = 0 and left(p.value,1) between '0' and '9' then convert(int,p.value) else 0 end
  )
  and not exists (select 1 from [tmprelease_display_scripts] p 
  where d.display_script_id = [active_display_script_id]
  )
  and not exists (select 1 from u_Display_Script_Selection p 
  where d.display_script_id = p.display_script_id
  )
  and not exists (select 1 from c_Treatment_Type p 
  where d.display_script_id = p.display_script_id
  )
  
  -- (1111 rows affected)
  */