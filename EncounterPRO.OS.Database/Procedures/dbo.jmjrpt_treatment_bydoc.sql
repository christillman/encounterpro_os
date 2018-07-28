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

-- Drop Procedure [dbo].[jmjrpt_treatment_bydoc]
Print 'Drop Procedure [dbo].[jmjrpt_treatment_bydoc]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_treatment_bydoc]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_treatment_bydoc]
GO

-- Create Procedure [dbo].[jmjrpt_treatment_bydoc]
Print 'Create Procedure [dbo].[jmjrpt_treatment_bydoc]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE jmjrpt_treatment_bydoc
	@ps_user_id varchar(24)
	,@ps_begin_date varchar(10)
	,@ps_end_date varchar(10) 
	,@ps_observation_id varchar(24)     
AS
Declare @user_id varchar(24)
Declare @begin_date varchar(10)
Declare @end_date varchar(10)
Declare @observation_id varchar(24)
Select @user_id = @ps_user_id
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
Select @observation_id = @ps_observation_id
SELECT DISTINCT
             p.first_name
            ,p.last_name
            ,p.billing_id
            ,et.description As Observation
            ,convert(varchar(10),i.begin_date,101) AS For_Date
            ,cp.risk_level As EM_Risk
            ,COALESCE(usr4.user_full_name,usr1.user_full_name) AS 'Ordered_by'
            ,usr2.user_full_name As 'Attendant'
            ,usr3.user_full_name As 'Supervisor'
 FROM
            p_treatment_item i WITH (NOLOCK) 
INNER JOIN P_patient p WITH (NOLOCK) ON 
            p.cpr_id = i.cpr_id
INNER JOIN c_observation  et WITH (NOLOCK) ON
            et.observation_id = i.observation_id
INNER JOIN p_patient_encounter a WITH (NOLOCK) ON
            a.cpr_id = i.cpr_id 
AND         a.encounter_id = i.open_encounter_id
Left Outer JOIN c_procedure cp WITH (NOLOCK) ON
           cp.procedure_id = i.procedure_id
INNER Join p_patient_wp pwp WITH (NOLOCK) ON
           pwp.cpr_id = i.cpr_id
           AND pwp.encounter_id = i.open_encounter_id
INNER Join c_user usr4 WITH (NOLOCK) ON
           usr4.user_id = i.ordered_by
Left Outer JOIN c_user usr1 WITH (NOLOCK) ON
           usr1.user_id = pwp.ordered_by
Left Outer JOIN c_user usr2 WITH (NOLOCK) ON
           usr2.user_id = a.attending_doctor
Left Outer Join c_user usr3 WITH (NOLOCK) ON
           usr3.user_id = a.supervising_doctor
WHERE
        i.observation_id = @observation_id
AND     i.begin_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date) 
AND     Isnull(i.treatment_status,'Open') <> 'CANCELLED'
AND     (i.ordered_by = @user_id OR a.attending_doctor = @user_id OR a.supervising_doctor = @user_id OR pwp.ordered_by = @user_id )

GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_treatment_bydoc]
	TO [cprsystem]
GO

