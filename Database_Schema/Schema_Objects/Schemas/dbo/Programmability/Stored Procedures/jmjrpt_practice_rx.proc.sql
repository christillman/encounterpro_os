

CREATE PROCEDURE jmjrpt_practice_rx
As
Select count(d.common_name)AS Count, d.common_name As Rx 
from p_treatment_item i with (NOLOCK)
INNER JOIN p_assessment_treatment at WITH (NOLOCK) ON
	i.cpr_id = at.cpr_id
AND	i.treatment_id	= at.treatment_id
INNER JOIN c_drug_definition d WITH (NOLOCK) ON
d.drug_id = i.drug_id
where i.treatment_type = 'MEDICATION'
group by d.common_name
having count(d.common_name) > 0
order by Count desc, Rx asc