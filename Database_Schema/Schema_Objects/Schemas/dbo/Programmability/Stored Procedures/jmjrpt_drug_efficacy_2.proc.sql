


CREATE PROCEDURE jmjrpt_drug_efficacy_2
	@ps_assessment_id varchar(24)
	,@ps_weeks varchar(4)   
AS
Declare @assessment_id varchar(24)
Declare @weeks varchar(4)
Select @assessment_id = @ps_assessment_id
Select @weeks = @ps_weeks
SELECT Count(pa.assessment) As Med_Count, 
d.common_name As Drug_1, 
d2.common_name AS Drug_2,AVG(DateDiff(day,i.begin_date, i2.begin_date)) As Avg_Days_After_1st,
d3.common_name AS Drug_3,AVG(DateDiff(day,i2.begin_date, i3.begin_date)) As Avg_Days_After_2nd
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
INNER JOIN p_Treatment_Item i2 WITH (NOLOCK) ON
        i2.cpr_id = i.cpr_id
AND i2.treatment_type IN ('MEDICATION','OFFICEMED')
AND i2.begin_date BETWEEN DATEADD( day, 1, i.begin_date)
AND DATEADD(week, Cast(@weeks As integer), i.begin_date )
INNER JOIN p_assessment_treatment at2 WITH (NOLOCK) ON
	i2.cpr_id = at2.cpr_id
AND	i2.treatment_id	= at2.treatment_id
INNER JOIN p_assessment pa2 WITH (NOLOCK) ON
	at2.cpr_id = pa2.cpr_id
AND	at2.problem_id = pa2.problem_id
AND     pa2.assessment_id = pa.assessment_id
INNER JOIN c_drug_definition d2 WITH (NOLOCK) ON
d2.drug_id = i2.drug_id
Left Outer JOIN p_Treatment_Item i3 WITH (NOLOCK) ON
        i3.cpr_id = i.cpr_id
AND i3.treatment_type IN ('MEDICATION','OFFICEMED')
AND i3.begin_date BETWEEN DATEADD( day, 1, i2.begin_date)
AND DATEADD(week, Cast(@weeks As integer), i.begin_date )
Left Outer JOIN p_assessment_treatment at3 WITH (NOLOCK) ON
	i3.cpr_id = at3.cpr_id
AND	i3.treatment_id	= at3.treatment_id
Left Outer JOIN p_assessment pa3 WITH (NOLOCK) ON
	at3.cpr_id = pa3.cpr_id
AND	at3.problem_id = pa3.problem_id
AND     pa3.assessment_id = pa.assessment_id
Left Outer JOIN c_drug_definition d3 WITH (NOLOCK) ON
d3.drug_id = i3.drug_id
where i.treatment_type IN ('MEDICATION','OFFICEMED')
group by d.common_name,d2.common_name,d3.common_name,i.begin_date,i2.begin_date,i3.begin_date
ORDER BY Med_Count desc