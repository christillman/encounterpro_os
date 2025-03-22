
update p_Observation_Result
set long_result_value = substring(long_result_value,3,8000)
-- select substring(long_result_value,3,8000)
from p_Observation_Result 
where long_result_value like char(13) + char(10) + '%'

update p_Observation_Result
set long_result_value = substring(long_result_value,3,8000)
-- select substring(long_result_value,3,8000)
from p_Observation_Result 
where long_result_value like char(13) + char(10) + '%'

update p_Observation_Result
set result_value = substring(result_value,3,40)
-- select substring(result_value,3,50)
from p_Observation_Result 
where result_value like char(13) + char(10) + '%'

update p_Observation_Result
set result_value = substring(result_value,3,40)
-- select *
from p_Observation_Result 
where result_value like char(13) + char(10) + '%'

update p_Observation_Result
set result_value = left(result_value, len(result_value) - 2)
-- select left(result_value, len(result_value) - 2)
from p_Observation_Result 
where result_value like  '%' + char(13) + char(10) 

update p_Observation_Result
set result_value = left(result_value, len(result_value) - 2)
-- select left(result_value, len(result_value) - 2)
from p_Observation_Result 
where result_value like  '%' + char(13) + char(10) 

update p_Observation_Result
set long_result_value = left(long_result_value, len(long_result_value) - 2)
-- select left(long_result_value, len(long_result_value) - 2), cpr_id
from p_Observation_Result 
where long_result_value like  '%' + char(13) + char(10) 

update p_Observation_Result
set long_result_value = left(long_result_value, len(long_result_value) - 2)
-- select left(long_result_value, len(long_result_value) - 2), cpr_id
from p_Observation_Result 
where long_result_value like  '%' + char(13) + char(10) 

update p_Observation_Result
set long_result_value = left(long_result_value, len(long_result_value) - 2)
-- select left(long_result_value, len(long_result_value) - 2), cpr_id
from p_Observation_Result 
where long_result_value like  '%' + char(13) + char(10) 

update p_Observation_Result
set long_result_value = trim(long_result_value)
-- select trim(long_result_value)
from p_Observation_Result 
where long_result_value like  '% '
or long_result_value like  ' %'

update p_Observation_Result
set result_value = trim(result_value)
-- select trim(result_value)
from p_Observation_Result 
where result_value like  '% '
or result_value like  ' %'
