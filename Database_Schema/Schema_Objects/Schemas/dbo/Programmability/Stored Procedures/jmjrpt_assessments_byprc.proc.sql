


CREATE PROCEDURE jmjrpt_assessments_byprc
AS
SELECT count(pa.assessment)AS Count, pa.assessment,ca.icd_9_code AS ICD_9,
ca.risk_level as EM_Risk, ca.complexity as EM_Complexity
FROM p_assessment pa WITH (NOLOCK)
LEFT OUTER JOIN c_assessment_definition ca WITH (NOLOCK) ON
	pa.assessment_id = ca.assessment_id
where Isnull(pa.assessment_status,'Open') <> 'CANCELLED'
group by pa.assessment,ca.icd_9_code,ca.risk_level,ca.complexity 
order by Count desc,pa.assessment asc
