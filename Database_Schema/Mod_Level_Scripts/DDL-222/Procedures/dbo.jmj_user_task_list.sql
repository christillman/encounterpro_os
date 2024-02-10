
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_user_task_list]
Print 'Drop Procedure [dbo].[jmj_user_task_list]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_user_task_list]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_user_task_list]
GO

-- Create Procedure [dbo].[jmj_user_task_list]
Print 'Create Procedure [dbo].[jmj_user_task_list]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_user_task_list
(
	@ps_user_id varchar(24)
)
AS

-- This procedure gets the pending NOT IN OFFICE tasks for the specified role

DECLARE @ll_patient_workplan_item_id int

DECLARE @services TABLE (
	user_id varchar(24),
	patient_workplan_item_id int,
	ordered_service varchar(24),
	service_description varchar(80),
	service_icon varchar(64),
	visible_flag char(1),
	in_office_flag char(1),
	ordered_by varchar(24),
	description varchar(80),
	dispatch_date datetime,
	begin_date datetime,
	end_date datetime,
	status varchar(12),
	retries smallint,
	escalation_date datetime,
	expiration_date datetime,
	user_short_name varchar(12),
	color int,
	dispatch_minutes int,
	selected_flag int,
	patient_name varchar(80),
	room_name varchar(24),
	ready int,
	cpr_id varchar(12) NULL ,
	encounter_id int NULL,
	encounter_owner varchar(12) NULL,
	encounter_owner_color int NULL,
	priority int NULL )

INSERT INTO @services (
	user_id ,
	patient_workplan_item_id ,
	ordered_service ,
	service_description ,
	service_icon ,
	visible_flag ,
	in_office_flag ,
	ordered_by ,
	description ,
	dispatch_date ,
	begin_date ,
	end_date ,
	status ,
	retries ,
	escalation_date ,
	expiration_date ,
	user_short_name ,
	color ,
	dispatch_minutes ,
	selected_flag ,
	patient_name ,
	room_name,
	ready,
	cpr_id,
	encounter_id,
	priority )
SELECT
	a.owned_by as user_id,
	a.patient_workplan_item_id,
	a.ordered_service,
	s.description as service_description,
	s.icon as service_icon,
	s.visible_flag,
	a.in_office_flag,
	a.ordered_by,
	a.description,
	a.dispatch_date,
	a.begin_date,
	end_date = NULL,
	a.status,
	retries = 0,
	a.escalation_date,
	a.expiration_date,
	u.user_short_name,
	u.color,
	dispatch_minutes = DATEDIFF(minute, a.dispatch_date, getdate()),
	selected_flag=0,
	ISNULL(p.last_name, '') + ', ' + ISNULL(p.first_name, '') + ' ' + ISNULL(p.middle_name, '') AS patient_name,
	CAST(NULL AS varchar(24)) as room_name,
	CASE a.ordered_service WHEN 'WAIT' THEN 0 ELSE 1 END,
	a.cpr_id,
	a.encounter_id,
	ISNULL(a.priority, 2)
FROM o_Active_Services a
	INNER JOIN o_Service s WITH (NOLOCK)
	ON a.ordered_service = s.service
	INNER JOIN c_User u WITH (NOLOCK)
	ON a.ordered_by = u.user_id
	LEFT OUTER JOIN p_patient p WITH (NOLOCK)
	ON a.cpr_id = p.cpr_id
WHERE a.in_office_flag = 'N'
AND a.owned_by = @ps_user_id
AND (a.owned_by = '!Exception' OR a.ordered_service <> 'MESSAGE')


-- Turn on WAIT ready flag if we think the service is ready to complete
UPDATE @services
SET ready = dbo.fn_is_wait_service_ready(patient_workplan_item_id, getdate())
WHERE ordered_service = 'WAIT'

UPDATE s
SET encounter_owner = u.user_short_name,
	encounter_owner_color = u.color
FROM @services s
	INNER JOIN p_Patient_Encounter e
	ON s.cpr_id = e.cpr_id
	AND s.encounter_id = e.encounter_id
	INNER JOIN c_User u
	ON e.attending_doctor = u.user_id

SELECT [user_id] ,
	patient_workplan_item_id ,
	ordered_service ,
	service_description ,
	service_icon ,
	visible_flag ,
	in_office_flag ,
	ordered_by ,
	description ,
	dispatch_date ,
	begin_date ,
	end_date ,
	status ,
	retries ,
	escalation_date ,
	expiration_date ,
	user_short_name ,
	color ,
	dispatch_minutes ,
	selected_flag ,
	patient_name ,
	room_name ,
	encounter_owner ,
	encounter_owner_color,
	priority
FROM @services
WHERE ready = 1

GO
GRANT EXECUTE
	ON [dbo].[jmj_user_task_list]
	TO [cprsystem]
GO

