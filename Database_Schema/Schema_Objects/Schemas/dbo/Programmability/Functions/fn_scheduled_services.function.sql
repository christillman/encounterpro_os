CREATE FUNCTION dbo.fn_scheduled_services ()

RETURNS @schedules TABLE (
	description varchar(80) NOT NULL,
	user_id varchar(24) NOT NULL,
	user_full_name varchar(64) NOT NULL,
	service_sequence int NOT NULL,
	office_id varchar(4) NULL,
	service varchar(24) NOT NULL,
	service_description varchar(80) NOT NULL,
	schedule_type varchar(24) NOT NULL,
	schedule_interval varchar(40) NULL,
	schedule_description varchar(40) NOT NULL,
	last_service_date datetime NULL,
	last_service_status varchar(12) NULL,
	created datetime NOT NULL ,
	created_by varchar(24) NOT NULL,
	status varchar(12) NOT NULL ,
	id uniqueidentifier NOT NULL ,
	last_successful_date datetime NULL,
	parent_object_id uniqueidentifier NULL,
	parent_object_class varchar(12) NULL,
	parent_object_type varchar(24) NULL,
	parent_object_description varchar(80) NULL,
	parent_object_type_prefix varchar(8) NULL,
	parent_object_owner_id int NULL,
	parent_object_status varchar(12) NULL,
	parent_object_base_table varchar(64) NULL,
	parent_object_base_table_key varchar(64) NULL,
	interval_amount int NULL,
	interval_unit varchar(40) NULL,
	running_status varchar(12) NOT NULL DEFAULT ('Not Running'),
	running_patient_workplan_item_id int NULL,
	next_run_date datetime NULL DEFAULT (getdate())
)

AS
BEGIN

INSERT INTO @schedules (
	user_id,
	user_full_name,
	service_sequence,
	office_id,
	service,
	service_description,
	schedule_type,
	schedule_interval,
	schedule_description,
	last_service_date,
	last_service_status,
	created,
	created_by,
	status,
	id,
	last_successful_date,
	description,
	parent_object_id ,
	parent_object_class ,
	parent_object_type ,
	parent_object_description ,
	parent_object_type_prefix ,
	parent_object_owner_id ,
	parent_object_status ,
	parent_object_base_table ,
	parent_object_base_table_key
	)
SELECT s.user_id,
	ISNULL(u.user_full_name, '<No Name>'),
	s.service_sequence,
	s.office_id,
	s.service,
	service_description = os.description,
	s.schedule_type,
	s.schedule_interval,
	schedule_description = CASE s.schedule_type WHEN 'Daily' THEN 'Every Day at ' + s.schedule_interval
												WHEN 'Interval' THEN 'Every ' + s.schedule_interval
												WHEN 'Constant' THEN 'Every 5 Seconds'
												ELSE 'Invalid Schedule' END,
	s.last_service_date,
	s.last_service_status,
	s.created,
	s.created_by,
	s.status,
	s.id,
	s.last_successful_date,
	ISNULL(s.description, os.description),
	parent_object_id = o.id,
	parent_object_class = o.object_class,
	parent_object_type = o.object_type,
	parent_object_description = o.description,
	parent_object_type_prefix = o.object_type_prefix,
	parent_object_owner_id = o.owner_id,
	parent_object_status = o.status,
	parent_object_base_table = o.base_table,
	parent_object_base_table_key = o.base_table_key
FROM o_Service_Schedule s
	INNER JOIN o_Service os
	ON s.service = os.service
	INNER JOIN c_User u
	ON s.user_id = u.user_id
	LEFT OUTER JOIN dbo.fn_object_info(NULL) o
	ON s.parent_component = o.id

-- The old "Constant" schedule type is treated like a 5 second interval type
UPDATE @schedules
SET	schedule_type = 'Interval',
	schedule_interval = '5 Second'
WHERE schedule_type = 'Constant'

UPDATE s
SET running_patient_workplan_item_id = x.patient_workplan_item_id,
	running_status = 'Running',
	next_run_date = NULL
FROM @schedules s
	INNER JOIN ( SELECT service = ordered_service, service_sequence = item_number, patient_workplan_item_id = max(patient_workplan_item_id)
				FROM p_Patient_WP_Item
				WHERE active_service_flag = 'Y'
				AND patient_workplan_id = 0
				AND workplan_id = -1
				GROUP BY ordered_service, item_number
				) x
	ON s.service = x.service
	AND s.service_sequence = x.service_sequence

-- Split the amount/unit for the interval schedules to make the next_run_date calculation easier
UPDATE @schedules
SET	interval_amount = CAST(SUBSTRING(schedule_interval, 1, CHARINDEX(' ', schedule_interval) - 1) AS INT),
	interval_unit = SUBSTRING(schedule_interval, CHARINDEX(' ', schedule_interval) + 1, 40)
WHERE schedule_type = 'INTERVAL'
AND CHARINDEX(' ', schedule_interval) > 1

-- Calculate the next_run_date for the interval schedules
UPDATE @schedules
SET next_run_date = CASE LEFT(interval_unit, 3) WHEN 'SEC' THEN DATEADD(second, interval_amount, last_service_date)
								WHEN 'MIN' THEN DATEADD(minute, interval_amount, last_service_date)
								WHEN 'HOU' THEN DATEADD(hour, interval_amount, last_service_date)
								WHEN 'DAY' THEN DATEADD(day, interval_amount, last_service_date)
								ELSE CAST(0 as datetime) END
WHERE schedule_type = 'INTERVAL'
AND running_status = 'Not Running'

-- Calculate the next_run_date for the daily schedules that haven't run yet
-- Remember next_run_date contains getdate() at this point
-- Assume the next run date is today
UPDATE @schedules
SET next_run_date = CAST(convert(varchar(10),next_run_date, 101) + ' ' + schedule_interval AS datetime)
WHERE schedule_type = 'DAILY'
AND running_status = 'Not Running'

-- If it's already run today then make it tomorrow instead
UPDATE @schedules
SET next_run_date = DATEADD(day, 1, next_run_date)
WHERE schedule_type = 'DAILY'
AND running_status = 'Not Running'
AND (last_service_date >= next_run_date OR last_service_date IS NULL)

UPDATE @schedules
SET schedule_description = schedule_description + 's'
WHERE schedule_type = 'Interval'
AND RIGHT(schedule_description, 1) <> 's'
AND LEFT(schedule_interval, 2) <> '1 '

RETURN
END
