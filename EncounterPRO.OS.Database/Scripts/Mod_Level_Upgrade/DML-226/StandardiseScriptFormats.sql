/*

select distinct trim(s.value) --, a.value
from c_Display_Script_Cmd_Attribute a
cross apply string_split([value],',') as s
where attribute = 'format'
and a.value not in ('List','Grid','Lab','Roots','Task','Dates','Message')
order by 1
-- 170
*/

-- references missing display_script
DELETE from c_Display_Script_Cmd_Attribute
-- select * from c_Display_Script_Cmd_Attribute
where display_command_id = 1828

DELETE from c_Display_Script_Command
where display_command_id = 1828

-- long_value incorrect and ignored
UPDATE c_Display_Script_Cmd_Attribute
SET long_value = NULL
-- select * from c_Display_Script_Cmd_Attribute
where value is not null and long_value is not null
-- 1 record

DELETE FROM c_Display_Script_Cmd_Attribute
-- select * from c_Display_Script_Cmd_Attribute
where value is null and long_value is null
-- 1 record

UPDATE c_Display_Script_Cmd_Attribute
SET long_value = NULL
-- select * from c_Display_Script_Cmd_Attribute
where attribute = 'blank line' and long_value is not null
-- 1 record

UPDATE c_Display_Script_Command set sort_sequence = sort_sequence - 4194 
-- select * from c_Display_Script_Command
where display_script_id = 32 and sort_sequence > 1000
-- 5

UPDATE c_Display_Script_Command set sort_sequence = sort_sequence - 2066 
-- select * from c_Display_Script_Command
where display_script_id = 48 and sort_sequence > 1000
-- 3

UPDATE c_Display_Script_Cmd_Attribute 
SET value = replace(value,'500,1000,1500','500/1000/1500')
-- select * from c_Display_Script_Cmd_Attribute
WHERE attribute = 'format' 
AND value like '%500,1000,1500%'
-- 5

UPDATE c_Display_Script_Cmd_Attribute 
SET value = replace(value,',0/0/0',',margin=0/0/0')
-- select * from c_Display_Script_Cmd_Attribute
WHERE attribute = 'format' 
AND value like '%,0/0/0%'
-- 2

UPDATE c_Display_Script_Cmd_Attribute 
SET value = replace(value,'margin=0/0/0/','margin=0/0/0')
-- select * from c_Display_Script_Cmd_Attribute
WHERE attribute = 'format' 
AND value like '%margin=0/0/0/%'
-- 1

UPDATE c_Display_Script_Cmd_Attribute 
SET value = left(value, len(value)-1)
-- select distinct left(value, len(value)-1) from c_Display_Script_Cmd_Attribute
WHERE attribute = 'format' 
AND value like '%,'
-- 3

UPDATE c_Display_Script_Cmd_Attribute 
SET value = replace(value,'margin=000','margin=0/0/0')
-- select * from c_Display_Script_Cmd_Attribute
WHERE attribute = 'format' 
AND value like '%margin=000%'
-- 10

UPDATE c_Display_Script_Cmd_Attribute 
SET value = replace(value,'xold','xbold')
-- select * from c_Display_Script_Cmd_Attribute
WHERE attribute = 'format' 
AND value like '%xold%'
-- 1

UPDATE c_Display_Script_Cmd_Attribute 
SET value = replace(value,'tabs','tabs=')
-- select * from c_Display_Script_Cmd_Attribute
WHERE attribute = 'format' 
AND value like '%tabs[^=]%'
-- 7

UPDATE c_Display_Script_Cmd_Attribute 
SET value = replace(value,' ','')
-- select distinct replace(value,' ','') from c_Display_Script_Cmd_Attribute
WHERE attribute = 'format' 
AND value like '% %'
AND value not like '%fn%'
-- 44

UPDATE c_Display_Script_Cmd_Attribute 
SET value = replace(value,'tabs=0/0/0','')
-- select * from c_Display_Script_Cmd_Attribute
WHERE attribute = 'format' 
AND value like '%tabs=0/0/0%'
-- 2

UPDATE c_Display_Script_Cmd_Attribute 
SET value = replace(value,'tabs=0/0','')
-- select * from c_Display_Script_Cmd_Attribute
WHERE attribute = 'format' 
AND value like '%tabs=0/0%'
-- 9

UPDATE c_Display_Script_Cmd_Attribute 
SET value = replace(value,'fontsize+12','fontsize=12')
-- select * from c_Display_Script_Cmd_Attribute
WHERE attribute = 'format' 
AND value like '%fontsize+12%'
-- 1

UPDATE c_Display_Script_Cmd_Attribute 
SET value = replace(value,'fontsize=10xbold','fontsize=10,xbold')
-- select * from c_Display_Script_Cmd_Attribute
WHERE attribute = 'format' 
AND value like '%fontsize=10xbold%'
-- 8

UPDATE c_Display_Script_Cmd_Attribute 
SET value = replace(value,'.',',')
-- select * from c_Display_Script_Cmd_Attribute
WHERE attribute = 'format' 
AND value like '%.%'
-- 3

UPDATE c_Display_Script_Cmd_Attribute 
SET value = replace(value,'fontsize=14-','fontsize=14')
-- select * from c_Display_Script_Cmd_Attribute
WHERE attribute = 'format' 
AND value like '%fontsize=14-%'
-- 63

UPDATE c_Display_Script_Cmd_Attribute 
SET value = replace(value,'fc=o','fc=0')
-- select * from c_Display_Script_Cmd_Attribute
WHERE attribute = 'format' 
AND value like '%fc=o%'
-- 2
