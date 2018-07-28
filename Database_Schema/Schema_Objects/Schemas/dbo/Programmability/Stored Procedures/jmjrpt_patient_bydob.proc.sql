


CREATE PROCEDURE jmjrpt_patient_bydob @ps_begin_date varchar(10), @ps_end_date varchar(10)
AS
Declare @begindate varchar(10)
Declare @enddate varchar(10)
Select @begindate = @ps_begin_date
Select @enddate = @ps_end_date
SELECT  p.billing_id As Bill_ID,
        (p.last_name + ',' + p.first_name) As Patient,
         Convert(varchar(10),p.date_of_birth,101)
	FROM p_patient p (NOLOCK) 
	WHERE 
	date_of_birth BETWEEN @begindate AND DATEADD( day, 1, @enddate)
	order by date_of_birth