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

-- Drop Procedure [dbo].[sp_scheduled_services]
Print 'Drop Procedure [dbo].[sp_scheduled_services]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_scheduled_services]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_scheduled_services]
GO

-- Create Procedure [dbo].[sp_scheduled_services]
Print 'Create Procedure [dbo].[sp_scheduled_services]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_scheduled_services
	(
	@ps_user_id varchar(24) = NULL,
	@ps_office_id varchar(4) = NULL
	)
AS

DECLARE @ll_sort_sequence int,
	@ll_workplan_sequence int,
	@ls_today varchar(32),
	@ldt_today datetime

IF @ps_user_id IS NULL
	SET @ps_user_id = '%'

SET @ls_today = convert(varchar(10),getdate(), 101)
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
AND user_id LIKE @ps_user_id

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
AND user_id LIKE @ps_user_id

DELETE @services
WHERE schedule_type = 'INTERVAL'
AND CASE LEFT(interval_unit, 3) WHEN 'SEC' THEN DATEADD(second, interval_amount, last_service_date)
								WHEN 'MIN' THEN DATEADD(minute, interval_amount, last_service_date)
								WHEN 'HOU' THEN DATEADD(hour, interval_amount, last_service_date)
								WHEN 'DAY' THEN DATEADD(day, interval_amount, last_service_date)
								ELSE CAST(0 as datetime) END > getdate()

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
AND user_id LIKE @ps_user_id
AND last_service_date < @ldt_today
AND ISDATE(@ls_today + ' ' + schedule_interval) = 1

DELETE @services
WHERE schedule_type = 'DAILY'
AND getdate() < daily_datetime

SELECT t.service_sequence,
	t.service,
	s.user_id
FROM @services t
	INNER JOIN o_Service_Schedule s
	ON t.service_sequence = s.service_sequence
WHERE t.service IN ('EXTERNAL_SOURCE', 'BATCH_BILLING')

GO
GRANT EXECUTE
	ON [dbo].[sp_scheduled_services]
	TO [cprsystem]
GO

