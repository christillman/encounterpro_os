-- Fix for #40

UPDATE c_Display_Script_Cmd_Attribute
SET long_value =
'SELECT distinct treatment_description,p.begin_date,created.user_short_name AS created_by,p.end_date,cancelled.user_short_name AS cancelled_by 
FROM p_treatment_item p WITH (NOLOCK)   
LEFT OUTER JOIN p_treatment_progress pp WITH (NOLOCK)  
	ON p.treatment_id = pp.treatment_id  
INNER JOIN c_user cancelled WITH (NOLOCK)  
	ON pp.created_by = cancelled.user_id 
INNER JOIN c_user created WITH  (NOLOCK)  
	ON p.created_by = created.user_id    
WHERE  p.treatment_type = ''MEDICATION''  
AND progress_type in (''CANCELLED'',''Cancelled'')  
AND (datediff(day, p.begin_date, p.end_date) > 0 OR created.user_id <> IsNull(cancelled.user_id,created.user_id))    
AND p.cpr_id = ''%cpr_id%''    
order by p.begin_date Desc'
-- select display_command_id, attribute, long_value from c_Display_Script_Cmd_Attribute 
where display_script_id = 1017 
and display_command_id = 27664
and attribute = 'query'

UPDATE c_Display_Script_Cmd_Attribute
SET long_value = 
'SELECT distinct   pti.treatment_description  ,
	CONVERT(varchar,pti.begin_date,120) as begin_date  ,
	created.user_short_name as Created_By  ,
	CONVERT(varchar,pti.end_date,120) as end_date  ,
	cancelled.user_short_name as Cancelled_By  
FROM p_treatment_item pti WITH (NOLOCK)   
LEFT OUTER JOIN p_treatment_progress ptp WITH (NOLOCK)  ON pti.treatment_id = ptp.treatment_id  
INNER JOIN c_user cancelled WITH (NOLOCK)  ON pti.completed_by = cancelled.user_id  
INNER JOIN c_user created WITH (NOLOCK)  ON pti.created_by = created.user_id    
WHERE  ptp.progress_type in (''CANCELLED'',''Cancelled'')  
AND (datediff(day, pti.begin_date, pti.end_date) > 0 OR created.user_id <> IsNull(cancelled.user_id,created.user_id))    
AND pti.cpr_id = ''%cpr_id%''    
order by CONVERT(varchar,pti.begin_date,120) Desc'
-- select display_command_id, attribute, long_value from c_Display_Script_Cmd_Attribute 
where display_script_id = 1000969  
and display_command_id = 1075165
and attribute = 'query'

