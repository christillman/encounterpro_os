
select * from o_Groups
select top 1 * from o_preferences 
where preference_type = 'General'

update o_preferences
set preference_type = 'PREFERENCES' 
where preference_type = 'General'

insert into o_preferences
select 'PREFERENCES','Office','0001','default_group_id','119'
from c_1_record
where not exists (select 1 
	from o_preferences where preference_id = 'default_group_id')

select top 10 * from c_Preference