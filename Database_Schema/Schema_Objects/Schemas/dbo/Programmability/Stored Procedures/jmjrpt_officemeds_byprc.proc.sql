


CREATE PROCEDURE jmjrpt_officemeds_byprc
AS
Select count(d.common_name)AS count, d.common_name As Med 
from p_treatment_item i with (NOLOCK)
INNER JOIN p_assessment_treatment at WITH (NOLOCK) ON
	i.cpr_id = at.cpr_id
AND	i.treatment_id	= at.treatment_id
INNER JOIN c_drug_definition d WITH (NOLOCK) ON
d.drug_id = i.drug_id
where i.treatment_type = 'OFFICEMED'
group by d.common_name
order by count desc