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

-- Drop Procedure [dbo].[jmjrpt_patient_takehome_meds]
Print 'Drop Procedure [dbo].[jmjrpt_patient_takehome_meds]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_patient_takehome_meds]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_patient_takehome_meds]
GO

-- Create Procedure [dbo].[jmjrpt_patient_takehome_meds]
Print 'Create Procedure [dbo].[jmjrpt_patient_takehome_meds]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE jmjrpt_patient_takehome_meds
	@ps_cpr_id varchar(12)
AS
Declare @cprid varchar(12)
Select @cprid = @ps_cpr_id

SELECT  distinct cd.common_name as Common_name
	,cd.generic_name as Generic_name
	,Cast(cp.administer_per_dose AS varchar(10)) + cp.administer_unit as Package	
	,pt.dose_amount as Dose_amount
	,cu.description as Dose_unit
	,caf.description as Frequency
FROM p_treatment_item pt WITH (NOLOCK)
inner join c_drug_definition cd WITH (NOLOCK) 
ON cd.drug_id = pt.drug_id
left outer join c_unit cu WITH (NOLOCK) 
ON cu.unit_id = pt.dose_unit
left outer join c_package cp WITH (NOLOCK) 
ON cp.package_id = pt.package_id
left outer join c_administration_frequency caf WITH (NOLOCK) 
ON caf.administer_frequency = pt.administer_frequency
WHERE pt.cpr_id = @cprid
AND treatment_type = 'MEDICATION'
AND Isnull(treatment_status,'Open') = 'Open'
ORDER BY  cd.common_name

GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_patient_takehome_meds]
	TO [cprsystem]
GO

