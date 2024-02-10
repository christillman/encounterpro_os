
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmjrpt_track_msg]
Print 'Drop Procedure [dbo].[jmjrpt_track_msg]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_track_msg]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_track_msg]
GO

-- Create Procedure [dbo].[jmjrpt_track_msg]
Print 'Create Procedure [dbo].[jmjrpt_track_msg]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE jmjrpt_track_msg
	@ps_user_id varchar(24)
	,@ps_begin_date varchar(10)
	,@ps_end_date varchar(10)     
AS
Declare @user_id varchar(24)
Declare @begin_date varchar(10)
Declare @end_date varchar(10)
Select @user_id = @ps_user_id
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
IF  ISNULL(@user_id, '' ) <> ''
BEGIN
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
WHERE i.ordered_service in ('TODO','MESSAGE')
AND i.status not in ('DISPATCHED','STARTED')
AND i.ordered_for <> completed_by
AND i.completed_by not in
(SELECT [user_id] from c_user_role ur
WHERE ur.role_id = i.ordered_for)
AND i.completed_by not in
(SELECT primary_provider_id from p_patient p
WHERE p.cpr_id = i.cpr_id
AND i.ordered_for = '#PATIENT_PROVIDER')
AND i.completed_by not in
(SELECT attending_doctor from p_patient_encounter e with (NOLOCK)
WHERE e.cpr_id = i.cpr_id
AND i.ordered_for = '#ENCOUNTER_OWNER')
AND ia.attribute = 'message'
AND i.dispatch_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
AND i.ordered_by = @user_id
order by i.dispatch_date
END
ELSE
BEGIN
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
WHERE i.ordered_service in ('TODO','MESSAGE')
AND i.status not in ('DISPATCHED','STARTED')
AND i.ordered_for <> completed_by
AND i.completed_by not in
(SELECT [user_id] from c_user_role ur
WHERE ur.role_id = i.ordered_for)
AND i.completed_by not in
(SELECT primary_provider_id from p_patient p
WHERE p.cpr_id = i.cpr_id
AND i.ordered_for = '#PATIENT_PROVIDER')
AND i.completed_by not in
(SELECT attending_doctor from p_patient_encounter e with (NOLOCK)
WHERE e.cpr_id = i.cpr_id
AND i.ordered_for = '#ENCOUNTER_OWNER')
AND ia.attribute = 'message'
AND i.dispatch_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
order by i.dispatch_date
END
GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_track_msg]
	TO [cprsystem]
GO

