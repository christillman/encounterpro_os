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

-- Drop Procedure [dbo].[jmjrpt_Encounters_For_Select_Date]
Print 'Drop Procedure [dbo].[jmjrpt_Encounters_For_Select_Date]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_Encounters_For_Select_Date]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_Encounters_For_Select_Date]
GO

-- Create Procedure [dbo].[jmjrpt_Encounters_For_Select_Date]
Print 'Create Procedure [dbo].[jmjrpt_Encounters_For_Select_Date]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE jmjrpt_Encounters_For_Select_Date
	@pdt_select_date Datetime
AS
Declare @select_date Datetime
Select @select_date = @pdt_select_date
SELECT
(p.last_name + ',' + p.first_name) As Patient,
p.billing_id As Bill_ID,
ce.description,
pe.bill_flag As Bill,
Convert(varchar(10),pe.encounter_date,101) As 'StartDate',
cu1.user_short_name AS 'Created_by',
Convert(varchar(10),pe.discharge_date,101) As 'CloseDate',
cu2.user_short_name AS 'Closed_by'
FROM p_Patient_Encounter pe WITH (NOLOCK)
        inner join p_patient p  
        on p.cpr_id = pe.cpr_id
        inner join c_encounter_type ce with (NOLOCK)
        on ce.encounter_type = pe.encounter_type
        inner join p_patient_encounter_progress pep with (NOLOCK)
        on pep.cpr_id = pe.cpr_id
 	AND pep.encounter_id = pe.encounter_id
        AND pep.progress_type = 'Closed'
        inner join c_User cu2 
        ON pep.user_id = cu2.user_id
	inner join c_User cu1 with (NOLOCK)
        on pe.created_by = cu1.user_id 
WHERE
encounter_status = 'CLOSED'
AND pe.discharge_date BETWEEN @select_date  AND DATEADD( day, 1, @select_date )
order by Patient

GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_Encounters_For_Select_Date]
	TO [cprsystem]
GO

