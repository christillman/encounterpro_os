

CREATE PROCEDURE jmjrpt_patient_todo_outstanding
AS
SELECT
             p.first_name
            ,p.last_name
            ,uob.user_short_name as sender
            ,COALESCE(uof.user_short_name, r.role_name) as recipient
            ,i.dispatch_date
            ,i.description as TODO
            ,a.value
            ,DATEDIFF( hour, i.dispatch_date, getdate() ) - 24 AS Hours_Late
FROM
            p_patient_WP_Item I  WITH (NOLOCK)
INNER JOIN P_patient p WITH (NOLOCK) ON  
            p.cpr_id = i.cpr_id
INNER JOIN c_user  uob  WITH (NOLOCK) ON
            uob.user_id = i.ordered_by
LEFT OUTER JOIN c_user  uof  WITH (NOLOCK) ON
            i.ordered_for = uof.user_id
LEFT OUTER JOIN c_role r WITH (NOLOCK) 
ON i.ordered_for = r.role_id
LEFT OUTER JOIN p_patient_WP_Item_Attribute a  WITH (NOLOCK) ON
            i.patient_workplan_item_id = a.patient_workplan_item_id
WHERE
            i.cpr_id IS NOT NULL
AND     i.ordered_service = 'TODO'
AND     i.active_service_flag = 'Y'
AND     i.dispatch_date IS NOT NULL
AND     a.attribute = 'message'
AND     DATEDIFF( hour, i.dispatch_date, getdate() ) >= 
       24*(1 + CHARINDEX ( CAST(DATEPART( weekday, i.dispatch_date)AS VARCHAR (1) ), '76' ) )
ORDER BY
             Hours_Late DESC