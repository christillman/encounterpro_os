CREATE PROCEDURE sp_get_todo_list_null_n
(
	@ps_user_id varchar(24),
	@pdt_begin_date datetime = NULL,
	@pdt_end_date datetime = NULL
)
AS

-- This procedure displays all of the NOT IN OFFICE completed services for the given user and date range.

IF @pdt_begin_date IS NULL OR @pdt_end_date IS NULL
	BEGIN
	SET @pdt_end_date = getdate()
	SET @pdt_begin_date = DATEADD(day, -5, @pdt_end_date)
	END


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
	i.owned_by as user_id,
	i.patient_workplan_item_id,
	i.ordered_service,
	s.description as service_description,
	s.icon as service_icon,
	s.visible_flag,
	i.in_office_flag,
	i.ordered_by,
	i.description,
	i.dispatch_date,
	i.begin_date,
	i.end_date,
	i.status,
	i.retries,
	i.escalation_date,
	i.expiration_date,
	u.user_short_name,
	u.color,
	dispatch_minutes = DATEDIFF(minute, i.dispatch_date, getdate()),
	selected_flag=0,
	ISNULL(p.last_name, '') + ', ' + ISNULL(p.first_name, '') + ' ' + ISNULL(p.middle_name, '') AS patient_name,
	CAST(NULL AS varchar(24)) as room_name,
	1,
	i.cpr_id,
	i.encounter_id,
	i.priority
FROM p_Patient_WP_Item i WITH (NOLOCK)
	INNER JOIN o_Service s WITH (NOLOCK)
	ON i.ordered_service = s.service
	INNER JOIN c_User u WITH (NOLOCK)
	ON i.ordered_by = u.user_id
	LEFT OUTER JOIN p_patient p WITH (NOLOCK)
	ON i.cpr_id = p.cpr_id
WHERE 	i.owned_by = @ps_user_id
AND		i.dispatch_date >= @pdt_begin_date
AND		i.dispatch_date <= @pdt_end_date
AND 	i.in_office_flag = 'N'
AND 	i.active_service_flag = 'N'
AND 	(i.owned_by = '!Exception' OR i.ordered_service <> 'MESSAGE')


UPDATE s
SET encounter_owner = u.user_short_name,
	encounter_owner_color = u.color
FROM @services s
	INNER JOIN p_Patient_Encounter e
	ON s.cpr_id = e.cpr_id
	AND s.encounter_id = e.encounter_id
	INNER JOIN c_User u
	ON e.attending_doctor = u.user_id

SELECT user_id ,
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
	encounter_owner,
	encounter_owner_color,
	priority
FROM @services
WHERE ready = 1

