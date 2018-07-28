

CREATE PROCEDURE jmjrpt_vfc_rpt1
	@ps_begin_date varchar(10)
   ,@ps_end_date varchar(10)    
AS

Declare @begin_date varchar(10)
Declare @end_date varchar(10)
Declare @today datetime
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
SELECT @today = Getdate()
SELECT pp.billing_id As Bill_Id,
pp.first_name + ', ' + pp.last_name AS Patient,
convert(varchar(10),p_treatment_item.end_date,101) As Shot_Date,
convert(varchar(10),pp.date_of_birth,101) As Birth_day,
Isnull(ca.authority_category,'') As Class,
p_treatment_item.treatment_description As Vaccine
FROM p_treatment_item with (NOLOCK)
Inner Join 
p_patient pp with (NOLOCK) ON
pp.cpr_id = p_treatment_item.cpr_id
AND pp.date_of_birth is not NULL
AND DateDIFF(YEAR,pp.date_of_birth,@today) < 19
Left Outer Join
p_patient_authority pa with (NOLOCK) ON
pa.cpr_id = p_treatment_item.cpr_id
Left Outer Join
c_authority ca with (NOLOCK) ON
ca.authority_id = pa.authority_id
WHERE (p_treatment_item.treatment_type In ('PASTIMMUN','IMMUNIZATION'))
 AND (p_treatment_item.treatment_status = 'CLOSED')
 AND (p_treatment_item.treatment_description LIKE '%(VFC)%')
 AND (p_treatment_item.end_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date))
 ORDER BY Bill_Id,Shot_Date