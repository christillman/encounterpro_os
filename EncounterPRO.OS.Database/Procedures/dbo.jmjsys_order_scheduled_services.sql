
-- Drop Procedure [dbo].[jmjsys_order_scheduled_services]
Print 'Drop Procedure [dbo].[jmjsys_order_scheduled_services]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjsys_order_scheduled_services]') AND [type] = 'P'))
DROP PROCEDURE [dbo].[jmjsys_order_scheduled_services]
GO

-- Create Procedure [dbo].[jmjsys_order_scheduled_services]
Print 'Create Procedure [dbo].[jmjsys_order_scheduled_services]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [jmjsys_order_scheduled_services]
	(
	@ps_user_id varchar(24) = NULL
	)
AS

/*
DECLARE @ll_sort_sequence int,
	@ll_workplan_sequence int,
	@ls_today varchar(32),
	@ldt_today datetime

IF @ps_user_id IS NULL
	SET @ps_user_id = '%'

SET @ls_today = convert(varchar(10),dbo.get_client_datetime(), 101)
SET @ldt_today = CAST(@ls_today AS datetime)

DECLARE @services TABLE (
	service_sequence INT NOT NULL,
	schedule_type varchar(24) NOT NULL,
	service varchar(24) NOT NULL,
	interval_amount int NULL,
	interval_unit varchar(40) NULL,
	daily_datetime datetime NULL,
	last_service_date datetime NULL)

-- Get the constant service
INSERT INTO @services (
	service_sequence,
	schedule_type,
	service)
SELECT service_sequence,
	schedule_type,
	service
FROM o_Service_Schedule
WHERE ISNULL(ISNULL(office_id, @ps_office_id), 'NULL') = ISNULL(@ps_office_id, 'NULL')
AND schedule_type = 'CONSTANT'
AND status = 'OK'
AND [user_id] LIKE @ps_user_id

-- Get the Interval Services
INSERT INTO @services (
	service_sequence,
	schedule_type,
	service,
	interval_amount,
	interval_unit,
	last_service_date)
SELECT service_sequence,
	schedule_type,
	service,
	CAST(SUBSTRING(schedule_interval, 1, CHARINDEX(' ', schedule_interval) - 1) AS INT),
	SUBSTRING(schedule_interval, CHARINDEX(' ', schedule_interval) + 1, 40),
	ISNULL(last_service_date, CAST('1/1/1900' as datetime))
FROM o_Service_Schedule
WHERE ISNULL(ISNULL(office_id, @ps_office_id), 'NULL') = ISNULL(@ps_office_id, 'NULL')
AND schedule_type = 'INTERVAL'
AND CHARINDEX(' ', schedule_interval) > 1
AND status = 'OK'
AND [user_id] LIKE @ps_user_id

DELETE @services
WHERE schedule_type = 'INTERVAL'
AND CASE LEFT(interval_unit, 3) WHEN 'SEC' THEN DATEADD(second, interval_amount, last_service_date)
								WHEN 'MIN' THEN DATEADD(minute, interval_amount, last_service_date)
								WHEN 'HOU' THEN DATEADD(hour, interval_amount, last_service_date)
								WHEN 'DAY' THEN DATEADD(day, interval_amount, last_service_date)
								ELSE CAST(0 as datetime) END > dbo.get_client_datetime()

-- Get the Daily Services
INSERT INTO @services (
	service_sequence,
	schedule_type,
	service,
	last_service_date,
	daily_datetime)
SELECT service_sequence,
	schedule_type,
	service,
	ISNULL(last_service_date, 0),
	CAST(@ls_today + ' ' + schedule_interval AS datetime)
FROM o_Service_Schedule
WHERE ISNULL(ISNULL(office_id, @ps_office_id), 'NULL') = ISNULL(@ps_office_id, 'NULL')
AND schedule_type = 'DAILY'
AND status = 'OK'
AND [user_id] LIKE @ps_user_id
AND last_service_date < @ldt_today
AND ISDATE(@ls_today + ' ' + schedule_interval) = 1

DELETE @services
WHERE schedule_type = 'DAILY'
AND dbo.get_client_datetime() < daily_datetime

SELECT t.service_sequence,
	t.service,
	s.user_id
FROM @services t
	INNER JOIN o_Service_Schedule s
	ON t.service_sequence = s.service_sequence

*/

GO
GRANT EXECUTE ON [jmjsys_order_scheduled_services] TO [cprsystem] AS [dbo]
GO
