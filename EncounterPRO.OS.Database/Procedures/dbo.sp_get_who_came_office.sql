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

-- Drop Procedure [dbo].[sp_get_who_came_office]
Print 'Drop Procedure [dbo].[sp_get_who_came_office]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_who_came_office]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_who_came_office]
GO

-- Create Procedure [dbo].[sp_get_who_came_office]
Print 'Create Procedure [dbo].[sp_get_who_came_office]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE  PROCEDURE sp_get_who_came_office
(	 @ps_office_id varchar(4) = NULL
	,@ps_user_id varchar(24) = NULL
	,@pdt_date datetime
	,@ps_indirect_flag varchar(12) = '%'
	,@ps_encounter_type varchar(24) = '%'
	,@ps_billing_status char(1) = '%'
)
AS
DECLARE	 @ldt_today datetime
	,@ldt_tomorrow datetime

SET @ldt_today = convert(datetime, convert(varchar,@pdt_date, 112))

SET @ldt_tomorrow = DATEADD(day, 1, @ldt_today)

IF @ps_office_id IS NULL
	SET @ps_office_id = '%'

IF @ps_user_id IS NULL
	SET @ps_user_id = '%'

SELECT	 p_Patient.cpr_id
	,p_Patient_Encounter.encounter_id
	,p_Patient.billing_id
	,p_Patient.first_name
	,p_Patient.last_name
	,o_Rooms.room_name
	,COALESCE(p_Patient_Encounter.encounter_description, c_Encounter_Type.description) as encounter_description
	,p_Patient_Encounter.discharge_date
	,p_Patient_Encounter.bill_flag
	,p_Patient_Encounter.billing_posted
	,p_Patient_Encounter.billing_hold_flag
	,p_Patient_Encounter.stone_flag
	,c_User.color
	,selected_flag = 0
	,bill_status=ISNULL(c_Domain.domain_item_bitmap, 'Icon026.bmp')
	,doc_status=dbo.fn_patient_object_document_status(p_Patient_Encounter.cpr_id, 'Encounter', p_Patient_Encounter.encounter_id)
	,code_check_status = dbo.fn_patient_object_property(p_Patient_Encounter.cpr_id, 'Encounter', p_Patient_Encounter.encounter_id, 'Code Check Status')
FROM	p_Patient_Encounter WITH (NOLOCK, INDEX( idx_encounter_date ) )
INNER JOIN p_Patient WITH (NOLOCK)
ON	p_Patient_Encounter.cpr_id = p_Patient.cpr_id
INNER JOIN c_Encounter_Type WITH (NOLOCK)
ON	p_Patient_Encounter.encounter_type = c_Encounter_Type.encounter_type
LEFT OUTER JOIN o_Rooms WITH (NOLOCK)
ON	p_Patient_Encounter.patient_location = o_Rooms.room_id
LEFT OUTER JOIN	c_User WITH (NOLOCK)
ON	p_Patient_Encounter.attending_doctor = c_User.user_id
LEFT OUTER JOIN	c_Domain WITH (NOLOCK)
ON	ISNULL(p_Patient_Encounter.billing_posted, 'N') = c_Domain.domain_item
AND		c_Domain.domain_id = 'billing_posted'
WHERE 
	p_Patient_Encounter.encounter_date >= @ldt_today
AND 	p_Patient_Encounter.encounter_date < @ldt_tomorrow
AND 	p_Patient_Encounter.encounter_status = 'CLOSED'
AND 	p_Patient_Encounter.office_id LIKE @ps_office_id
AND 	p_Patient_Encounter.attending_doctor LIKE @ps_user_id
AND 	p_Patient_Encounter.indirect_flag LIKE @ps_indirect_flag
AND 	p_Patient_Encounter.encounter_type LIKE @ps_encounter_type
AND 	p_Patient_Encounter.billing_posted LIKE @ps_billing_status

GO
GRANT EXECUTE
	ON [dbo].[sp_get_who_came_office]
	TO [cprsystem]
GO

