--EncounterPRO Open Source Project
--
--Copyright 2010-2011 The EncounterPRO Foundation, Inc.
--
--This program is free software: you can redistribute it and/or modify it under the terms of 
--the GNU Affero General Public License as published by the Free Software Foundation, either 
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Affero General Public License for more details.
--
--You should have received a copy of the GNU Affero General Public License along with this 
--program. If not, see http://www.gnu.org/licenses.
--
--EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero 
--General Public License version 3, or any later version. As such, linking the Project 
--statically or dynamically with other components is making a combined work based on the 
--Project. Thus, the terms and conditions of the GNU Affero General Public License version 3, 
--or any later version, cover the whole combination.
--
--However, as an additional permission, the copyright holders of EncounterPRO Open Source 
--Project give you permission to link the Project with independent components, regardless of 
--the license terms of these independent components, provided that all of the following are true:
--
--1. All access from the independent component to persisted data which resides
--   inside any EncounterPRO Open Source data store (e.g. SQL Server database) 
--   be made through a publically available database driver (e.g. ODBC, SQL 
--   Native Client, etc) or through a service which itself is part of The Project.
--2. The independent component does not create or rely on any code or data 
--   structures within the EncounterPRO Open Source data store unless such 
--   code or data structures, and all code and data structures referred to 
--   by such code or data structures, are themselves part of The Project.
--3. The independent component either a) runs locally on the user's computer,
--   or b) is linked to at runtime by The Project’s Component Manager object 
--   which in turn is called by code which itself is part of The Project.
--
--An independent component is a component which is not derived from or based on the Project.
--If you modify the Project, you may extend this additional permission to your version of 
--the Project, but you are not obligated to do so. If you do not wish to do so, delete this 
--additional permission statement from your version.
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_scheduled_services]
Print 'Drop Function [dbo].[fn_scheduled_services]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_scheduled_services]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_scheduled_services]
GO

-- Create Function [dbo].[fn_scheduled_services]
Print 'Create Function [dbo].[fn_scheduled_services]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
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
	next_run_date datetime NULL 
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
	parent_object_base_table_key,
	next_run_date
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
	parent_object_base_table_key = o.base_table_key,
	dbo.get_client_datetime()
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
-- Remember next_run_date contains dbo.get_client_datetime() at this point
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
GO
GRANT SELECT
	ON [dbo].[fn_scheduled_services]
	TO [cprsystem]
GO

