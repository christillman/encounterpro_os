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

-- Drop Procedure [dbo].[jmjrpt_patient_pastdue_well_by_age]
Print 'Drop Procedure [dbo].[jmjrpt_patient_pastdue_well_by_age]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_patient_pastdue_well_by_age]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_patient_pastdue_well_by_age]
GO

-- Create Procedure [dbo].[jmjrpt_patient_pastdue_well_by_age]
Print 'Create Procedure [dbo].[jmjrpt_patient_pastdue_well_by_age]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE jmjrpt_patient_pastdue_well_by_age
	@ps_months varchar(4),@pl_age_range integer
AS
Declare @months varchar(4)
Declare @age_range_control integer
Declare @patient_age_range integer
Declare @cpr_id varchar(12),@billing_id varchar(24),@birth_date datetime,@begin_date datetime
Declare @last_name varchar(40),@first_name varchar(20)
Select @months = @ps_months
CREATE TABLE #t(id int IDENTITY PRIMARY KEY,tbilling_id varchar(24),tlastname varchar(40),tfirstname varchar(20),tbirth_date datetime,tbegin_date datetime NULL )
Declare my_curse cursor LOCAL FAST_FORWARD TYPE_WARNING for
SELECT p1.cpr_id,a1.begin_date,p1.date_of_birth,p1.billing_id,p1.last_name,p1.first_name
FROM   p_patient p1 WITH (NOLOCK)
Left Outer JOIN p_assessment a1 WITH (NOLOCK)
ON p1.cpr_id = a1.cpr_id
AND a1.assessment_type = 'WELL'
AND ISNULL(a1.assessment_status, 'OPEN') <> 'CANCELLED'
AND a1.begin_date = (SELECT MAX(a2.begin_date) 
                    FROM p_assessment a2 WITH (NOLOCK)
                    WHERE p1.cpr_id = a2.cpr_id 
                    AND a2.assessment_type = 'WELL'
                    AND ISNULL(a2.assessment_status, 'OPEN' ) <> 'CANCELLED'
                    )
WHERE p1.patient_status = 'ACTIVE'
AND p1.cpr_id not in
(SELECT cpr_id from p_assessment a3 WITH (NOLOCK)
WHERE   a3.assessment_type = 'WELL'
AND     ISNULL( a3.assessment_status, 'OPEN' ) <> 'CANCELLED'
AND     DATEDIFF( month, a3.begin_date, dbo.get_client_datetime() ) <= Cast(@months As integer)
AND     a3.begin_date =  (SELECT MAX( a4.begin_date ) 
                         FROM p_assessment a4 WITH (NOLOCK)
                         WHERE p1.cpr_id = a4.cpr_id
                         AND a4.assessment_type = 'WELL'
                         AND ISNULL( a4.assessment_status, 'OPEN' ) <> 'CANCELLED'
                         ))
ORDER BY p1.date_of_birth desc,a1.begin_date

Select @age_range_control = @pl_age_range
Open my_curse
Fetch Next from my_curse INTO @cpr_id,@begin_date,@birth_date,@billing_id,@last_name,@first_name 
WHILE (@@FETCH_STATUS <> -1)
 BEGIN
  IF (@@FETCH_STATUS <> -2)
   BEGIN   
    IF @birth_date IS NOT NULL
     BEGIN 
       EXEC sp_Get_Patient_Age_Range @cpr_id, 'Stages', @pl_age_range_id = @patient_age_range OUTPUT
       IF @patient_age_range = @age_range_control
          BEGIN
	    	if(select count(*) from p_assessment a4 WITH (NOLOCK) where cpr_id = @cpr_id and 
			a4.assessment_id in (select assessment_id from c_age_range_assessment
				where age_range_id = @age_range_control)) = 0
		BEGIN
           		INSERT INTO #t VALUES(@billing_id,@last_name,@first_name,@birth_date,@begin_date)
		END
          END
     END
    Fetch Next from my_curse INTO @cpr_id,@begin_date,@birth_date,@billing_id,@last_name,@first_name 
   END
 END
Close my_curse
Select distinct tbilling_id As Billing_id,
       	tlastname AS Last_Name,
       	tfirstname AS First_Name,
	convert(varchar(10),tbirth_date,101) as Birth_Date,
        convert(varchar(10),tbegin_date,101) as Last_Well
From #t
Deallocate my_curse
--Drop #t

GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_patient_pastdue_well_by_age]
	TO [cprsystem]
GO

