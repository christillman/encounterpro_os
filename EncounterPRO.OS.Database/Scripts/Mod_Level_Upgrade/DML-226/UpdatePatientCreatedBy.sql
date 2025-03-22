
with firsts as (
	select pp.cpr_id, min(pp.created) as min_created
	from p_Patient_Progress pp
	join p_patient p on p.cpr_id = pp.cpr_id
	where pp.created > '2019-01-01'
	and p.test_patient = 0
	and pp.created_by != '#SYSTEM'
	group by pp.cpr_id
), keys as (
	select p.cpr_id, pp.created_by
	from p_Patient_Progress pp
	join firsts p on p.cpr_id = pp.cpr_id
	AND	p.min_created = pp.created
	and pp.created_by != '#SYSTEM'
	group by p.cpr_id, pp.created_by
)
update p set created_by = k.created_by
from p_patient p
join keys k on k.cpr_id = p.cpr_id
where p.created_by is null or p.created_by = '#SYSTEM'
-- 337