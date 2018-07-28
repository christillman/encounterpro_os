

CREATE PROCEDURE jmjrpt_Type_OpenTreatments
	@ps_type varchar(24)
AS
Declare @type varchar(24)
Select @type = @ps_type
SELECT     convert(varchar(10),i.begin_date,101) AS RecordDate 
            ,p.first_name
            ,p.last_name
            ,p.billing_id 
            ,i.treatment_description AS Ordered
            ,cu.user_short_name As Ordered_by       
FROM
            p_treatment_Item i WITH (NOLOCK) 
INNER JOIN P_patient p  WITH (NOLOCK) ON 
            p.cpr_id = i.cpr_id
INNER JOIN c_user cu  WITH (NOLOCK) ON 
            cu.user_id = i.ordered_by    

WHERE treatment_status is NULL
and treatment_type = @type
ORDER BY i.begin_date ASC