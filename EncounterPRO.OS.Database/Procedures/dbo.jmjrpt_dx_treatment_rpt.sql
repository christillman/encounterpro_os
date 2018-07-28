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

-- Drop Procedure [dbo].[jmjrpt_dx_treatment_rpt]
Print 'Drop Procedure [dbo].[jmjrpt_dx_treatment_rpt]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_dx_treatment_rpt]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_dx_treatment_rpt]
GO

-- Create Procedure [dbo].[jmjrpt_dx_treatment_rpt]
Print 'Create Procedure [dbo].[jmjrpt_dx_treatment_rpt]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE jmjrpt_dx_treatment_rpt
	@ps_assessment_id varchar(24)
        ,@ps_speciality varchar(24)
AS
Declare @assessment_id varchar(24)
Declare @speciality_id varchar(24)
Select @assessment_id = @ps_assessment_id
Select @speciality_id = @ps_speciality

SELECT u.treatment_type as sort_type
       ,u.treatment_description
FROM   u_assessment_treat_definition u WITH (NOLOCK)
inner join c_assessment_definition ac WITH (NOLOCK)
on u.assessment_id = ac.assessment_id
WHERE u.assessment_id = @assessment_id
and user_id = @speciality_id
and (parent_definition_id is NULL or parent_definition_id = '')
and u.treatment_type != '!COMPOSITE'
union
SELECT '!-' + cast(u.definition_id AS varchar) as sort_type
       ,u.treatment_description
FROM   u_assessment_treat_definition u WITH (NOLOCK)
inner join c_assessment_definition ac WITH (NOLOCK)
on u.assessment_id = ac.assessment_id
WHERE u.assessment_id = @assessment_id
and user_id = @speciality_id
and (parent_definition_id is NULL or parent_definition_id = '')
and u.treatment_type = '!COMPOSITE'
union
SELECT '!-' + cast(u.parent_definition_id AS varchar) + '-' + u.treatment_type as sort_type
       ,u.treatment_description
FROM   u_assessment_treat_definition u WITH (NOLOCK)
inner join c_assessment_definition ac WITH (NOLOCK)
on u.assessment_id = ac.assessment_id
WHERE u.assessment_id = @assessment_id
and user_id = @speciality_id
and u.parent_definition_id in 
(select ue.definition_id 
FROM   u_assessment_treat_definition ue WITH (NOLOCK) 
Where user_id = '$PEDS')
order by sort_type


GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_dx_treatment_rpt]
	TO [cprsystem]
GO

