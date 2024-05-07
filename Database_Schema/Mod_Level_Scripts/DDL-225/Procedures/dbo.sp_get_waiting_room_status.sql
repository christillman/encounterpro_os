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

-- Drop Procedure [dbo].[sp_get_waiting_room_status]
Print 'Drop Procedure [dbo].[sp_get_waiting_room_status]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_waiting_room_status]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_waiting_room_status]
GO

-- Create Procedure [dbo].[sp_get_waiting_room_status]
Print 'Create Procedure [dbo].[sp_get_waiting_room_status]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_waiting_room_status
	@ps_office_id varchar(4)
AS
SELECT
	p_Patient_Encounter.patient_location,
	o_Rooms.room_name,
	p_Patient.cpr_id,
	p_Patient_Encounter.encounter_id,
	p_Patient_Encounter.attending_doctor,
	p_Patient.date_of_birth,
	p_Patient.sex,
	p_Patient.first_name,
	p_Patient.last_name,
	p_Patient.degree,
	p_Patient.name_prefix,
	p_Patient.middle_name,
	p_Patient.name_suffix,
	p_Patient.locked_by,
	o_Service.description,
	minutes=DATEDIFF(minute, p_Patient_WP_Item.dispatch_date, dbo.get_client_datetime()),
	pretty_name='',
	status=0,
	p_Patient_WP_Item.ordered_service,
	p_Patient_WP_Item.description,
	p_Patient_WP_Item.ordered_for,
	p_Patient_WP_Item.patient_workplan_item_id,
	p_Patient_Encounter.attending_doctor,
	encounter_description = COALESCE(p_Patient_Encounter.encounter_description, c_Encounter_Type.description),
	c_User.color,
	service_color=0,
	alert_count=0
FROM p_Patient_WP_Item WITH (NOLOCK)
	INNER JOIN p_Patient_WP WITH (NOLOCK)
	ON p_Patient_WP.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
	INNER JOIN p_Patient WITH (NOLOCK)
	ON p_Patient_WP_Item.cpr_id = p_Patient.cpr_id
	INNER JOIN p_Patient_Encounter WITH (NOLOCK)
	ON p_Patient_WP_Item.cpr_id = p_Patient_Encounter.cpr_id
	AND p_Patient_WP_Item.encounter_id = p_Patient_Encounter.encounter_id
	INNER JOIN c_Encounter_Type WITH (NOLOCK)
	ON p_Patient_Encounter.encounter_type = c_Encounter_Type.encounter_type
	INNER JOIN o_Service WITH (NOLOCK)
	ON p_Patient_WP_Item.ordered_service = o_Service.service
	LEFT OUTER JOIN c_User WITH (NOLOCK)
	ON p_Patient_Encounter.attending_doctor = c_User.user_id
	LEFT OUTER JOIN o_Rooms WITH (NOLOCK)
	ON p_Patient_Encounter.patient_location = o_Rooms.room_id
WHERE p_Patient_WP_Item.ordered_service = 'GET_PATIENT'
AND p_Patient_WP_Item.item_type = 'Service'
AND p_Patient_WP_Item.active_service_flag = 'Y'
AND p_Patient_WP.in_office_flag = 'Y'
AND p_Patient_Encounter.office_id = @ps_office_id
AND p_Patient_Encounter.encounter_status = 'OPEN'

GO
GRANT EXECUTE
	ON [dbo].[sp_get_waiting_room_status]
	TO [cprsystem]
GO

