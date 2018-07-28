



CREATE PROCEDURE jmjrpt_audit_todo
	@ps_cpr_id varchar(12)
AS
Declare @cpr_id varchar(12)
SELECT @cpr_id = @ps_cpr_id
SELECT
Convert(varchar(10),i.dispatch_date,101) As Dispatch
,ordered_service AS Service
--,i.ordered_by
,u.user_short_name AS Ordered_by 
--,i.ordered_for
,u2.user_short_name AS Ordered_for
,i.description AS Title
,ia.value AS Request
,ia.message AS Detail
,i.status as Status
--,i.completed_by
,u3.user_short_name AS Done_by
from p_patient_wp_item i WITH (NOLOCK)
LEFT OUTER JOIN p_patient_wp_item_attribute ia
ON i.patient_workplan_item_id = ia.patient_workplan_item_id
LEFT OUTER JOIN c_user u WITH (NOLOCK)
ON i.ordered_by = u.[user_id]
LEFT OUTER JOIN c_user u2 WITH (NOLOCK)
ON i.completed_by = u2.[user_id]
LEFT OUTER JOIN c_user u3
ON i.completed_by = u3.[user_id]
WHERE i.ordered_service in ('TODO')
AND i.cpr_id = @cpr_id
order by i.dispatch_date


