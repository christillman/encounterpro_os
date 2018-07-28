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

-- Drop Procedure [dbo].[sp_Get_Patients_Waiting_On_Services]
Print 'Drop Procedure [dbo].[sp_Get_Patients_Waiting_On_Services]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_Get_Patients_Waiting_On_Services]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_Get_Patients_Waiting_On_Services]
GO

-- Create Procedure [dbo].[sp_Get_Patients_Waiting_On_Services]
Print 'Create Procedure [dbo].[sp_Get_Patients_Waiting_On_Services]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_Get_Patients_Waiting_On_Services (
	@ps_office_id varchar(4),
	@ps_service varchar(24) )
AS

DECLARE @ls_sort_sequence varchar(255)

SET @ls_sort_sequence = dbo.fn_get_specific_preference('SYSTEM', 'Room', '$Waiting', 'sort')
IF @ls_sort_sequence IS NULL
	SET @ls_sort_sequence = 'Encounter Descending'


SELECT DISTINCT
	i.patient_workplan_item_id,
	i.description as item_description,
	p.cpr_id,   
	e.encounter_id,   
	e.attending_doctor,
	e.patient_location,
	encounter_description = COALESCE(e.encounter_description, et.description),  
	minutes=DATEDIFF(minute, i.dispatch_date, getdate()),   
	p.first_name,
	p.middle_name,
	p.last_name,
	p.sex,
	p.date_of_birth,
	p.billing_id,
	item_color = COALESCE(u.color, r.color),
	room_name = rr.room_name,
	selected_flag=0
FROM	p_Patient_WP_Item i WITH (NOLOCK)
	INNER JOIN p_Patient_WP w WITH (NOLOCK)
	ON i.cpr_id = w.cpr_id
	AND i.patient_workplan_id = w.patient_workplan_id
	INNER JOIN p_Patient p WITH (NOLOCK)
	ON w.cpr_id = p.cpr_id
	INNER JOIN p_Patient_Encounter e WITH (NOLOCK)
	ON w.cpr_id = e.cpr_id
	AND w.encounter_id = e.encounter_id
	INNER JOIN c_Encounter_Type et WITH (NOLOCK)
	ON e.encounter_type = et.encounter_type
	LEFT OUTER JOIN c_User u WITH (NOLOCK)
	ON e.attending_doctor = u.user_id
	LEFT OUTER JOIN c_Role r WITH (NOLOCK)
	ON e.attending_doctor = r.role_id
	LEFT OUTER JOIN o_Rooms rr WITH (NOLOCK)
	ON e.patient_location = rr.room_id
WHERE i.ordered_service = @ps_service
AND i.item_type = 'Service'
AND i.active_service_flag = 'Y'
AND e.office_id = @ps_office_id
ORDER BY minutes desc

GO
GRANT EXECUTE
	ON [dbo].[sp_Get_Patients_Waiting_On_Services]
	TO [cprsystem]
GO

