﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[jmjrpt_dx_meds_bydoc]
Print 'Drop Procedure [dbo].[jmjrpt_dx_meds_bydoc]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_dx_meds_bydoc]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_dx_meds_bydoc]
GO

-- Create Procedure [dbo].[jmjrpt_dx_meds_bydoc]
Print 'Create Procedure [dbo].[jmjrpt_dx_meds_bydoc]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE jmjrpt_dx_meds_bydoc
	@ps_user_id varchar(24)
	,@ps_begin_date varchar(10)
	,@ps_end_date varchar(10)     
AS
Declare @user_id varchar(24)
Declare @begin_date varchar(10)
Declare @end_date varchar(10)
Select @user_id = @ps_user_id
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
SELECT pa.assessment,ca.icd10_code,count(pa.assessment)AS Count,d.common_name AS Rx
FROM p_Treatment_Item i WITH (NOLOCK)
INNER JOIN c_user usr WITH (NOLOCK) ON
	usr.user_id = i.ordered_by
INNER JOIN c_drug_definition d WITH (NOLOCK) ON
d.drug_id = i.drug_id
INNER JOIN p_assessment_treatment at WITH (NOLOCK) ON
	i.cpr_id = at.cpr_id
AND	i.treatment_id	= at.treatment_id
INNER JOIN p_assessment pa WITH (NOLOCK) ON
	at.cpr_id = pa.cpr_id
AND	at.problem_id = pa.problem_id
INNER JOIN c_assessment_definition ca WITH (NOLOCK) ON
	pa.assessment_id = ca.assessment_id
where i.treatment_type in ('MEDICATION','OFFICEMED')
AND i.ordered_by = @user_id
AND i.begin_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
group by pa.assessment,ca.icd10_code,d.common_name
order by pa.assessment asc, Count desc
GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_dx_meds_bydoc]
	TO [cprsystem]
GO

