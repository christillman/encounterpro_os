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

-- Drop Procedure [dbo].[jmjrpt_Encounters_for_today_by_office]
Print 'Drop Procedure [dbo].[jmjrpt_Encounters_for_today_by_office]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_Encounters_for_today_by_office]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_Encounters_for_today_by_office]
GO

-- Create Procedure [dbo].[jmjrpt_Encounters_for_today_by_office]
Print 'Create Procedure [dbo].[jmjrpt_Encounters_for_today_by_office]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE jmjrpt_Encounters_for_today_by_office 
         @ps_office_id varchar(24)     
AS
Declare @office_id varchar(24)
Select @office_id = @ps_office_id
SELECT c_user.user_short_name As Provider
       ,p_patient.first_name + ', ' + p_patient.last_name AS Name
       ,c_encounter_type.description As Type
       ,p_patient_encounter.encounter_description as chief_complaint
FROM
p_patient_encounter(NOLOCK)
inner join p_patient with (NOLOCK)
ON p_patient_encounter.cpr_id = p_patient.cpr_id
inner join c_encounter_type with (NOLOCK)
ON p_patient_encounter.encounter_type = c_encounter_type.encounter_type
inner join c_Office with (NOLOCK)
ON p_patient_encounter.office_id = c_Office.office_id
inner join c_user with (NOLOCK)
ON p_patient_encounter.attending_doctor = c_user.user_id
WHERE
p_patient_encounter.office_id = @office_id
AND DATEDIFF(day, p_patient_encounter.encounter_date, getdate()) = 0
ORDER BY
Provider,Name,Type
GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_Encounters_for_today_by_office]
	TO [cprsystem]
GO

