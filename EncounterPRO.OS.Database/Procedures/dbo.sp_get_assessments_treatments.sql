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

-- Drop Procedure [dbo].[sp_get_assessments_treatments]
Print 'Drop Procedure [dbo].[sp_get_assessments_treatments]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_assessments_treatments]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_assessments_treatments]
GO

-- Create Procedure [dbo].[sp_get_assessments_treatments]
Print 'Create Procedure [dbo].[sp_get_assessments_treatments]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_assessments_treatments (
	@ps_cpr_id varchar(12)
	)
AS
SELECT
	 p_Assessment.diagnosis_sequence
	,p_Assessment.assessment_type
	,p_Assessment.assessment_id
	,p_Assessment.assessment
	,p_Assessment.begin_date as assessment_begin_date
	,p_Assessment.assessment_status
	,p_Assessment.end_date as assessment_end_date
	,p_Assessment.close_encounter_id as assessment_close_encounter_id
	,p_Assessment.cpr_id
	,p_Assessment.problem_id
	,p_Assessment.open_encounter_id as assessment_open_encounter_id
	,p_Assessment.diagnosed_by
	,CONVERT(int, NULL) as attachment_id
	,p_Assessment_Treatment.treatment_id
	,b.open_encounter_id as treatment_open_encounter_id
	,b.treatment_type
	,b.treatment_description
	,b.treatment_status
	,b.end_date  as treatment_end_date
	,b.close_encounter_id as treatment_close_encounter_id
	,b.begin_date as treatment_begin_date
	,c_Assessment_Type.icon_open
	,c_Assessment_Type.icon_closed
	,selected_flag=0
	,treatment_icon=convert(varchar(128), '')
FROM p_Assessment WITH (NOLOCK)
INNER JOIN c_Assessment_Type
ON p_Assessment.assessment_type = c_Assessment_Type.assessment_type 
LEFT OUTER JOIN p_Assessment_Treatment WITH (NOLOCK)
ON	p_Assessment.cpr_id = p_Assessment_Treatment.cpr_id
AND	p_Assessment.problem_id = p_Assessment_Treatment.problem_id
LEFT OUTER JOIN p_treatment_item b WITH (NOLOCK)
ON 	p_Assessment_Treatment.treatment_id = b.treatment_id
and 	p_Assessment_Treatment.cpr_id = b.cpr_id    
WHERE
	p_Assessment.cpr_id = @ps_cpr_id
order by
	p_assessment_treatment.treatment_id  
     
GO
GRANT EXECUTE
	ON [dbo].[sp_get_assessments_treatments]
	TO [cprsystem]
GO

