

CREATE PROCEDURE jmjrpt_patient_pastdue_well
	@ps_months varchar(4)
AS
Declare @months varchar(4)
Select @months = @ps_months
SELECT 
             p.billing_id
            ,p.last_name
            ,p.first_name
            ,convert(varchar(10),p.date_of_birth,101) as Birth_Date
            ,convert(varchar(10),a.begin_date,101) as Last_Well
FROM   p_patient p WITH (NOLOCK)
Left Outer JOIN p_assessment a WITH (NOLOCK)
ON p.cpr_id = a.cpr_id
AND a.assessment_type = 'WELL'
AND ISNULL(a.assessment_status, 'OPEN') <> 'CANCELLED'
AND a.begin_date = (SELECT MAX(a2.begin_date) 
                    FROM p_assessment a2 WITH (NOLOCK)
                    WHERE p.cpr_id = a2.cpr_id 
                    AND a2.assessment_type = 'WELL'
                    AND ISNULL(a2.assessment_status, 'OPEN' ) <> 'CANCELLED'
                    )
WHERE p.patient_status = 'ACTIVE'
AND p.cpr_id not in
(SELECT cpr_id from p_assessment a3 WITH (NOLOCK)
WHERE   a3.assessment_type = 'WELL'
AND     ISNULL( a3.assessment_status, 'OPEN' ) <> 'CANCELLED'
AND     DATEDIFF( month, a3.begin_date, getdate() ) <= Cast(@months As integer)
AND     a3.begin_date =  (SELECT MAX( a4.begin_date ) 
                         FROM p_assessment a4 WITH (NOLOCK)
                         WHERE p.cpr_id = a4.cpr_id
                         AND a4.assessment_type = 'WELL'
                         AND ISNULL( a4.assessment_status, 'OPEN' ) <> 'CANCELLED'
                         ))
ORDER BY p.date_of_birth desc,a.begin_date