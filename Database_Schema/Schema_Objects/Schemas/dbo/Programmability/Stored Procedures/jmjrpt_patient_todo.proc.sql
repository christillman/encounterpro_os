

CREATE PROCEDURE jmjrpt_patient_todo
	@ps_begin_date varchar(10),
	@ps_end_date varchar(10) 
AS
Declare @begin_date varchar(10), @end_date varchar(10)
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
SELECT
p.first_name 
,p.last_name
,uob.user_short_name as sender
,COALESCE( uof.user_short_name, r.role_name) as recipient
,uoc.user_short_name AS DoneBy
,i.dispatch_date ,i.status
,i.description
,a.value
,i.end_date 
FROM p_patient_WP_Item I  WITH (NOLOCK)
INNER JOIN P_patient p  WITH (NOLOCK)
ON i.cpr_id = p.cpr_id  
LEFT OUTER JOIN c_user  uob  WITH (NOLOCK)
ON i.ordered_by = uob.user_id 
LEFT OUTER JOIN c_user  uof  WITH (NOLOCK)
ON i.ordered_for = uof.user_id   
LEFT OUTER JOIN c_user uoc  WITH (NOLOCK)
ON i.completed_by = uoc.user_id  
LEFT OUTER JOIN c_Role r  WITH (NOLOCK)
ON i.ordered_for = r.role_id
LEFT OUTER JOIN p_patient_WP_Item_Attribute a  WITH (NOLOCK)
ON i.patient_workplan_item_id = a.patient_workplan_item_id  
WHERE
i.cpr_id IS NOT NULL  
AND     i.ordered_service = 'TODO'  
AND     i.dispatch_date IS NOT NULL  
AND     a.attribute = 'message'  
AND     i.dispatch_date >= @begin_date 
AND     i.dispatch_date <= @end_date   
ORDER BY               i.dispatch_date ASC