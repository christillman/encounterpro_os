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

-- Drop Procedure [dbo].[sp_get_todo_list_notpct_n]
Print 'Drop Procedure [dbo].[sp_get_todo_list_notpct_n]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_todo_list_notpct_n]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_todo_list_notpct_n]
GO

-- Create Procedure [dbo].[sp_get_todo_list_notpct_n]
Print 'Create Procedure [dbo].[sp_get_todo_list_notpct_n]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_todo_list_notpct_n
(
	@ps_user_id varchar(24),
	@ps_office_id varchar(4),
	@pdt_begin_date datetime = NULL,
	@pdt_end_date datetime = NULL
)
AS

IF @pdt_begin_date IS NULL OR @pdt_end_date IS NULL
	BEGIN
	SET @pdt_end_date = dbo.get_client_datetime()
	SET @pdt_begin_date = DATEADD(day, -5, @pdt_end_date)
	END


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
	dispatch_minutes = DATEDIFF(minute, i.dispatch_date, dbo.get_client_datetime()),
	selected_flag=0,
	ISNULL(p.last_name, '') + ', ' + ISNULL(p.first_name, '') + ' ' + ISNULL(p.middle_name, '') AS patient_name,
	r.room_name,
	eu.user_short_name as encounter_owner,
	eu.color as encounter_owner_color,
	i.priority
FROM p_Patient_WP_Item i WITH (NOLOCK)
	INNER JOIN o_Service s WITH (NOLOCK)
	ON i.ordered_service = s.service
	INNER JOIN c_User u WITH (NOLOCK)
	ON i.ordered_by = u.user_id
	INNER JOIN p_patient p
	ON i.cpr_id = p.cpr_id
	INNER LOOP JOIN p_patient_encounter pe
	ON i.cpr_id = pe.cpr_id
	AND i.encounter_id = pe.encounter_id
	LEFT OUTER JOIN c_User eu
	ON pe.attending_doctor = eu.user_id
	LEFT OUTER JOIN o_Rooms r
	ON pe.patient_location = r.room_id
WHERE 	i.owned_by = @ps_user_id
AND		i.dispatch_date >= @pdt_begin_date
AND		i.dispatch_date <= @pdt_end_date
AND 	i.active_service_flag = 'N'
AND 	i.in_office_flag = 'Y'
AND 	(i.owned_by = '!Exception' OR i.ordered_service <> 'MESSAGE')
AND		pe.office_id LIKE @ps_office_id

GO
GRANT EXECUTE
	ON [dbo].[sp_get_todo_list_notpct_n]
	TO [cprsystem]
GO

