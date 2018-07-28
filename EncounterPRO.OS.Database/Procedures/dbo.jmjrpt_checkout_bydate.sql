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

-- Drop Procedure [dbo].[jmjrpt_checkout_bydate]
Print 'Drop Procedure [dbo].[jmjrpt_checkout_bydate]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_checkout_bydate]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_checkout_bydate]
GO

-- Create Procedure [dbo].[jmjrpt_checkout_bydate]
Print 'Create Procedure [dbo].[jmjrpt_checkout_bydate]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE jmjrpt_checkout_bydate @ps_discharge_date varchar(10)
AS
Declare @dischargedate varchar(10)
Select @dischargedate = @ps_discharge_date
SELECT   co.description As Location,
       	 (p.last_name + ',' + p.first_name) As Patient,
         p.billing_id As Bill_ID,
	     user_short_name AS Provider,
         pe.billing_posted AS Post,
         pe.bill_flag As Bill,
         ce.description         
FROM p_Patient_Encounter pe (NOLOCK),
	 p_patient p (NOLOCK),
     c_office co (NOLOCK),
	 c_encounter_type ce (NOLOCK),
     c_User (NOLOCK)
  	WHERE 
	encounter_status = 'CLOSED'
	AND pe.discharge_date BETWEEN @dischargedate AND DATEADD( day, 1, @dischargedate)
	AND p.cpr_id = pe.cpr_id
    AND co.office_id = pe.office_id
    AND pe.attending_doctor = c_User.user_id 
    AND ce.encounter_type = pe.encounter_type 
    order by pe.office_id,pe.attending_doctor,pe.encounter_type

GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_checkout_bydate]
	TO [cprsystem]
GO

