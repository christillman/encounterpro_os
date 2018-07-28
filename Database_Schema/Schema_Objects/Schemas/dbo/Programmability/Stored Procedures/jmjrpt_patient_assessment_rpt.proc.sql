

CREATE PROCEDURE [dbo].[jmjrpt_patient_assessment_rpt]
	@ps_assessment_id varchar(24)
AS
Declare @assessment_id varchar(24)
Select @assessment_id= @ps_assessment_id
SELECT distinct
             p.first_name
            ,p.last_name
            ,p.billing_id        
FROM
            p_assessment i WITH (NOLOCK)
INNER JOIN P_patient p WITH (NOLOCK)
ON 
            p.cpr_id = i.cpr_id

WHERE 
(IsNULL(assessment_status,'Open')) <> 'CANCELLED'
and assessment_id = @assessment_id
order by p.last_name