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

-- Drop Procedure [dbo].[sp_get_office_status]
Print 'Drop Procedure [dbo].[sp_get_office_status]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_office_status]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_office_status]
GO

-- Create Procedure [dbo].[sp_get_office_status]
Print 'Create Procedure [dbo].[sp_get_office_status]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_office_status (
	@pl_group_id integer )
AS

SELECT p.cpr_id,
	e.encounter_id,
	e.patient_location,
	p.date_of_birth,
	p.sex,
	p.first_name,
	p.last_name,
	p.degree,
	p.name_prefix,
	p.middle_name,
	p.name_suffix,
	p.locked_by,
	minutes=DATEDIFF(minute, i.dispatch_date, dbo.get_client_datetime()),
	r.room_name,
	r.room_sequence,
	age='',
	pretty_name='',
	status=1,
	i.ordered_service,
	i.description,
	i.owned_by,
	i.completed_by,
	i.patient_workplan_item_id,
	service_color=0,
	e.attending_doctor,
	patient_color=0,
	l.user_id,
	user_short_name = '',
	in_use = ''
FROM p_Patient_WP_Item i (NOLOCK)
	INNER JOIN p_Patient_WP w (NOLOCK)
	ON i.patient_workplan_id = w.patient_workplan_id
	INNER JOIN p_Patient p (NOLOCK)
	ON i.cpr_id = p.cpr_id
	INNER JOIN p_Patient_Encounter e (NOLOCK)
	ON i.cpr_id = e.cpr_id
	AND	i.encounter_id = e.encounter_id
	INNER JOIN o_Rooms r (NOLOCK)
	ON e.patient_location = r.room_id
	INNER JOIN o_Group_Rooms g (NOLOCK)
	ON r.room_id = g.room_id
	LEFT OUTER JOIN o_Users l (NOLOCK)
	ON r.computer_id = l.computer_id
WHERE i.active_service_flag = 'Y'
AND	i.item_type = 'Service'
AND	w.status = 'Current'
AND	w.in_office_flag = 'Y'
AND	i.in_office_flag = 'Y'
AND	e.encounter_status = 'OPEN'
AND	g.group_id = @pl_group_id

GO
GRANT EXECUTE
	ON [dbo].[sp_get_office_status]
	TO [cprsystem]
GO

