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

-- Drop Procedure [dbo].[jmjrpt_nonvfc_rpt1]
Print 'Drop Procedure [dbo].[jmjrpt_nonvfc_rpt1]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_nonvfc_rpt1]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_nonvfc_rpt1]
GO

-- Create Procedure [dbo].[jmjrpt_nonvfc_rpt1]
Print 'Create Procedure [dbo].[jmjrpt_nonvfc_rpt1]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE jmjrpt_nonvfc_rpt1
	@ps_begin_date varchar(10)
   ,@ps_end_date varchar(10)    
AS

Declare @begin_date varchar(10)
Declare @end_date varchar(10)
Declare @today datetime
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
SELECT @today = dbo.get_client_datetime()
SELECT pp.billing_id As Bill_Id,
pp.first_name + ', ' + pp.last_name AS Patient,
convert(varchar(10),p_treatment_item.end_date,101) As Shot_Date,
convert(varchar(10),pp.date_of_birth,101) As Birth_day,
Isnull(ca.authority_category,'') As Class,
p_treatment_item.treatment_description As Vaccine
FROM p_treatment_item with (NOLOCK)
Inner Join 
p_patient pp with (NOLOCK) ON
pp.cpr_id = p_treatment_item.cpr_id
AND pp.date_of_birth is not NULL
AND DateDIFF(YEAR,pp.date_of_birth,@today) < 19
Left Outer Join
p_patient_authority pa with (NOLOCK) ON
pa.cpr_id = p_treatment_item.cpr_id
Left Outer Join
c_authority ca with (NOLOCK) ON
ca.authority_id = pa.authority_id
WHERE (p_treatment_item.treatment_type IN ('PASTIMMUN', 'IMMUNIZATION'))
 AND (p_treatment_item.treatment_status = 'CLOSED')
 AND (p_treatment_item.treatment_description NOT LIKE '%(vfc)%')
 AND (p_treatment_item.end_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date))
 ORDER BY Bill_Id,Shot_Date
GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_nonvfc_rpt1]
	TO [cprsystem]
GO

