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

-- Drop Procedure [dbo].[jmjdoc_get_patient]
Print 'Drop Procedure [dbo].[jmjdoc_get_patient]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjdoc_get_patient]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjdoc_get_patient]
GO

-- Create Procedure [dbo].[jmjdoc_get_patient]
Print 'Create Procedure [dbo].[jmjdoc_get_patient]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmjdoc_get_patient (
	@ps_cpr_id varchar(24)
)

AS

  SELECT p_Patient.cpr_id as jmjinternalid,
	 p_Patient.billing_id as jmjexternalid,   
         p_Patient.race as race,   
         Convert(varchar(10),p_Patient.date_of_birth,101) as dateofbirth,   
         p_Patient.sex as sex,   
         p_Patient.primary_language as primarylanguage,   
         p_Patient.marital_status as maritalstatus,   
         p_Patient.ssn as ssn,   
         p_Patient.first_name as firstname,   
         p_Patient.last_name as lastname,   
         p_Patient.degree as degree,   
         p_Patient.name_prefix as nameprefix,   
         p_Patient.middle_name as middlename,   
         p_Patient.name_suffix as namesuffix,   
         p_Patient.maiden_name as maidenname,   
         p_Patient.phone_number as phone1,   
         p_Patient.patient_status as patientstatus,   
         p_Patient.address_line_1 as patientaddressaddressline1,   
         IsNull(p_Patient.address_line_2,'') as patientaddressaddressline2,   
         p_Patient.city as patientaddresscity,   
         IsNull(p_Patient.state,'') as patientaddressstate,   
         IsNull(p_Patient.zip,'') as patientaddresszip,   
         p_Patient.country as patientaddresscountry,   
         p_Patient.religion as religion,   
         p_Patient.nationality as nationality,   
         p_Patient.financial_class as financialclass,   
         p_Patient.employer as employer,   
         p_Patient.employeeID as employerid,   
         p_Patient.department as department,   
         p_Patient.shift as shift,   
         p_Patient.job_description as jobdescription,   
         p_Patient.start_date as startdate,   
         p_Patient.termination_date as terminationdate,   
         p_Patient.employment_status as employmentstatus   
    FROM p_Patient  
   WHERE p_Patient.cpr_id = @ps_cpr_id    



GO
GRANT EXECUTE
	ON [dbo].[jmjdoc_get_patient]
	TO [cprsystem]
GO

