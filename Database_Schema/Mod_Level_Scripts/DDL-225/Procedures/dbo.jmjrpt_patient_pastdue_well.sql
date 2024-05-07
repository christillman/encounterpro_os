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

-- Drop Procedure [dbo].[jmjrpt_patient_pastdue_well]
Print 'Drop Procedure [dbo].[jmjrpt_patient_pastdue_well]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_patient_pastdue_well]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_patient_pastdue_well]
GO

-- Create Procedure [dbo].[jmjrpt_patient_pastdue_well]
Print 'Create Procedure [dbo].[jmjrpt_patient_pastdue_well]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE jmjrpt_patient_pastdue_well
	@ps_months varchar(4)
AS
Declare @months varchar(4)
Select @months = @ps_months
SELECT 
             p.billing_id
            ,p.last_name
            ,p.first_name
            ,convert(varchar(10),p.date_of_birth,101) as Birth_Date
            ,convert(varchar(10),a.begin_date,101) as Last_Well
FROM   p_patient p WITH (NOLOCK)
Left Outer JOIN p_assessment a WITH (NOLOCK)
ON p.cpr_id = a.cpr_id
AND a.assessment_type = 'WELL'
AND ISNULL(a.assessment_status, 'OPEN') <> 'CANCELLED'
AND a.begin_date = (SELECT MAX(a2.begin_date) 
                    FROM p_assessment a2 WITH (NOLOCK)
                    WHERE p.cpr_id = a2.cpr_id 
                    AND a2.assessment_type = 'WELL'
                    AND ISNULL(a2.assessment_status, 'OPEN' ) <> 'CANCELLED'
                    )
WHERE p.patient_status = 'ACTIVE'
AND p.cpr_id not in
(SELECT cpr_id from p_assessment a3 WITH (NOLOCK)
WHERE   a3.assessment_type = 'WELL'
AND     ISNULL( a3.assessment_status, 'OPEN' ) <> 'CANCELLED'
AND     DATEDIFF( month, a3.begin_date, dbo.get_client_datetime() ) <= Cast(@months As integer)
AND     a3.begin_date =  (SELECT MAX( a4.begin_date ) 
                         FROM p_assessment a4 WITH (NOLOCK)
                         WHERE p.cpr_id = a4.cpr_id
                         AND a4.assessment_type = 'WELL'
                         AND ISNULL( a4.assessment_status, 'OPEN' ) <> 'CANCELLED'
                         ))
ORDER BY p.date_of_birth desc,a.begin_date

GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_patient_pastdue_well]
	TO [cprsystem]
GO

