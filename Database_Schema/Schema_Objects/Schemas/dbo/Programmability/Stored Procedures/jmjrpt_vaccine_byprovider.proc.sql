


CREATE PROCEDURE jmjrpt_vaccine_byprovider
	@ps_user_id varchar(24),@ps_begin_date varchar(10),@ps_end_date varchar(10)
AS
Declare @user_id varchar(24)
Declare @begin_date varchar(10)
Declare @end_date varchar(10)
Select @user_id = @ps_user_id
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
SELECT 
	convert(varchar(10),b.begin_date,101) As ReportDate,
        p.last_name + ',' + p.first_name AS Patient, 
	b.treatment_description, 
	b.maker_id, 
	b.lot_number,
	convert(varchar(10),b.expiration_date,101) As Expiration,
	cl.description As location,
	b.duration_prn As Lit_Date
	FROM 	p_treatment_item b WITH (NOLOCK)

INNER JOIN p_patient p WITH (NOLOCK)
ON	p.cpr_id = b.cpr_id
Left Outer JOIN c_location cl with (NOLOCK)
ON 	b.location =  cl.location
WHERE 
b.ordered_by = @user_id 
AND	b.treatment_type = 'IMMUNIZATION' 
AND 	b.treatment_description is not null 
AND 	b.treatment_status = 'CLOSED'
AND     b.begin_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
order by
	 
	b.begin_date desc
	,Patient
        ,b.treatment_description asc