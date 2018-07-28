

CREATE PROCEDURE jmjrpt_Orderedby_OpenLabs
	@ps_user_id varchar(24)
AS
Declare @user_id varchar(24)
Select @user_id= @ps_user_id
SELECT     convert(varchar(10),i.begin_date,101) AS RecordDate 
            ,p.first_name
            ,p.last_name
            ,p.billing_id 
            ,i.treatment_description AS Ordered_Lab       
FROM
            p_treatment_Item i WITH (NOLOCK) 
INNER JOIN P_patient p  WITH (NOLOCK) ON 
            p.cpr_id = i.cpr_id

WHERE treatment_status is NULL
and ordered_by = @user_id
and treatment_type = 'LAB'
ORDER BY i.begin_date ASC