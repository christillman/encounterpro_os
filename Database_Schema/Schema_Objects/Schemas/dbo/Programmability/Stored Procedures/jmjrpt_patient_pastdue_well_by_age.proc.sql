



CREATE PROCEDURE jmjrpt_patient_pastdue_well_by_age
	@ps_months varchar(4),@pl_age_range integer
AS
Declare @months varchar(4)
Declare @age_range_control integer
Declare @patient_age_range integer
Declare @cpr_id varchar(12),@billing_id varchar(24),@birth_date datetime,@begin_date datetime
Declare @last_name varchar(40),@first_name varchar(20)
Select @months = @ps_months
CREATE TABLE #t(id int IDENTITY PRIMARY KEY,tbilling_id varchar(24),tlastname varchar(40),tfirstname varchar(20),tbirth_date datetime,tbegin_date datetime NULL )
Declare my_curse cursor LOCAL FAST_FORWARD TYPE_WARNING for
SELECT p1.cpr_id,a1.begin_date,p1.date_of_birth,p1.billing_id,p1.last_name,p1.first_name
FROM   p_patient p1 WITH (NOLOCK)
Left Outer JOIN p_assessment a1 WITH (NOLOCK)
ON p1.cpr_id = a1.cpr_id
AND a1.assessment_type = 'WELL'
AND ISNULL(a1.assessment_status, 'OPEN') <> 'CANCELLED'
AND a1.begin_date = (SELECT MAX(a2.begin_date) 
                    FROM p_assessment a2 WITH (NOLOCK)
                    WHERE p1.cpr_id = a2.cpr_id 
                    AND a2.assessment_type = 'WELL'
                    AND ISNULL(a2.assessment_status, 'OPEN' ) <> 'CANCELLED'
                    )
WHERE p1.patient_status = 'ACTIVE'
AND p1.cpr_id not in
(SELECT cpr_id from p_assessment a3 WITH (NOLOCK)
WHERE   a3.assessment_type = 'WELL'
AND     ISNULL( a3.assessment_status, 'OPEN' ) <> 'CANCELLED'
AND     DATEDIFF( month, a3.begin_date, getdate() ) <= Cast(@months As integer)
AND     a3.begin_date =  (SELECT MAX( a4.begin_date ) 
                         FROM p_assessment a4 WITH (NOLOCK)
                         WHERE p1.cpr_id = a4.cpr_id
                         AND a4.assessment_type = 'WELL'
                         AND ISNULL( a4.assessment_status, 'OPEN' ) <> 'CANCELLED'
                         ))
ORDER BY p1.date_of_birth desc,a1.begin_date

Select @age_range_control = @pl_age_range
Open my_curse
Fetch Next from my_curse INTO @cpr_id,@begin_date,@birth_date,@billing_id,@last_name,@first_name 
WHILE (@@FETCH_STATUS <> -1)
 BEGIN
  IF (@@FETCH_STATUS <> -2)
   BEGIN   
    IF @birth_date IS NOT NULL
     BEGIN 
       EXEC sp_Get_Patient_Age_Range @cpr_id, 'Stages', @pl_age_range_id = @patient_age_range OUTPUT
       IF @patient_age_range = @age_range_control
          BEGIN
	    	if(select count(*) from p_assessment a4 WITH (NOLOCK) where cpr_id = @cpr_id and 
			a4.assessment_id in (select assessment_id from c_age_range_assessment
				where age_range_id = @age_range_control)) = 0
		BEGIN
           		INSERT INTO #t VALUES(@billing_id,@last_name,@first_name,@birth_date,@begin_date)
		END
          END
     END
    Fetch Next from my_curse INTO @cpr_id,@begin_date,@birth_date,@billing_id,@last_name,@first_name 
   END
 END
Close my_curse
Select distinct tbilling_id As Billing_id,
       	tlastname AS Last_Name,
       	tfirstname AS First_Name,
	convert(varchar(10),tbirth_date,101) as Birth_Date,
        convert(varchar(10),tbegin_date,101) as Last_Well
From #t
Deallocate my_curse
--Drop #t