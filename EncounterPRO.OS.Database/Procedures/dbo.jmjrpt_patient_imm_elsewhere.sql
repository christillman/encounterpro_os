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

-- Drop Procedure [dbo].[jmjrpt_patient_imm_elsewhere]
Print 'Drop Procedure [dbo].[jmjrpt_patient_imm_elsewhere]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_patient_imm_elsewhere]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_patient_imm_elsewhere]
GO

-- Create Procedure [dbo].[jmjrpt_patient_imm_elsewhere]
Print 'Create Procedure [dbo].[jmjrpt_patient_imm_elsewhere]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE jmjrpt_patient_imm_elsewhere
	@ps_cpr_id varchar(12)
AS
Declare @cpr_id varchar(12)
Select @cpr_id = @ps_cpr_id
SELECT convert(varchar(10),b.begin_date,101)As ReportDate,
treatment_description, 
maker_id, 
lot_number,
convert(varchar(10),b.expiration_date,101) As Expiration,
cl.description As location,
pp2.progress_value AS Site,
cu2.user_short_name AS Entered_by 
FROM p_treatment_item b WITH (NOLOCK)
INNER JOIN 
p_treatment_progress pp WITH (NOLOCK)
ON  pp.cpr_id = b.cpr_id 
AND pp.treatment_id = b.treatment_id
AND progress_type = 'CLOSED'
INNER JOIN 
p_patient_encounter a WITH (NOLOCK)
ON a.encounter_id =  b.open_encounter_id 
AND a.cpr_id = b.cpr_id 
Left Outer JOIN c_location cl with (NOLOCK)
ON b.location = cl.location
Left Outer JOIN 
p_treatment_progress pp2 WITH (NOLOCK)
ON  pp2.cpr_id = b.cpr_id 
AND pp2.treatment_id = b.treatment_id
AND pp2.progress_type = 'PROPERTY'
AND pp2.progress_key = 'Place Administered'
Left Outer JOIN c_user cu2 with (NOLOCK)
ON pp.user_id = cu2.user_id
WHERE a.cpr_id = @cpr_id 
and treatment_type = 'IMMUNIZATION' 
and treatment_description is not null 
and procedure_id is null
and IsNull(treatment_status,'Open') = 'CLOSED'
order by treatment_description asc,b.begin_date desc
GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_patient_imm_elsewhere]
	TO [cprsystem]
GO

