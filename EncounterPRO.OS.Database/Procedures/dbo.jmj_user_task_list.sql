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

