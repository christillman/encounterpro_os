


CREATE PROCEDURE jmjrpt_drug_efficacy_1
	@ps_assessment_id varchar(24)
	,@ps_weeks varchar(4)   
AS
Declare @assessment_id varchar(24)
Declare @weeks varchar(4)
Select @assessment_id = @ps_assessment_id
Select @weeks = @ps_weeks
SELECT Count(pa.assessment) As Med_Count,d.common_name 
FROM p_Treatment_Item i WITH (NOLOCK)
INNER JOIN c_drug_definition d WITH (NOLOCK) ON
d.drug_id = i.drug_id
INNER JOIN p_assessment_treatment at WITH (NOLOCK) ON
	i.cpr_id = at.cpr_id
AND	i.treatment_id	= at.treatment_id
INNER JOIN p_assessment pa WITH (NOLOCK) ON
	at.cpr_id = pa.cpr_id
AND	at.problem_id = pa.problem_id
AND     pa.assessment_id = @assessment_id
AND i.treatment_id NOT IN
(Select i2.treatment_id
FROM p_Treatment_Item i2 WITH (NOLOCK)
INNER JOIN p_assessment_treatment at2 WITH (NOLOCK) ON
	i2.cpr_id = at2.cpr_id
AND	i2.treatment_id	= at2.treatment_id
INNER JOIN p_assessment pa2 WITH (NOLOCK) ON
	at2.cpr_id = pa2.cpr_id
AND	at2.problem_id = pa2.problem_id
AND     pa2.assessment_id = pa.assessment_id
Where
i2.cpr_id = i.cpr_id
AND i2.treatment_type IN ('MEDICATION','OFFICEMED')
AND i2.begin_date BETWEEN DATEADD( day, 1, i.begin_date)
AND DATEADD(week, Cast(@weeks As integer), i.begin_date )
)

group by d.common_name
ORDER BY Med_Count desc