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

-- Drop Function [dbo].[fn_followup_treatment_status]
Print 'Drop Function [dbo].[fn_followup_treatment_status]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_followup_treatment_status]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_followup_treatment_status]
GO

-- Create Function [dbo].[fn_followup_treatment_status]
Print 'Create Function [dbo].[fn_followup_treatment_status]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_followup_treatment_status (
	@ps_cpr_id varchar(12),
	@pl_followup_treatment_id int)

RETURNS @treatments TABLE (
	treatment_id int NOT NULL,
	treatment_description varchar(1024) NOT NULL,
	treatment_type varchar(24) NOT NULL,
	treatment_type_description varchar(80) NOT NULL,
	treatment_type_icon varchar(64) NULL,
	treatment_status varchar(12) NOT NULL,
	parent_patient_workplan_item_id int NOT NULL )


AS

BEGIN

-- First get the list of treatment workplan_items in any followup workplans attached to the passed in treatment
DECLARE @ll_items TABLE (
	patient_workplan_item_id int NOT NULL,
	treatment_id int NOT NULL)

INSERT INTO @ll_items (
	patient_workplan_item_id,
	treatment_id)
SELECT i.patient_workplan_item_id,
		i.treatment_id
FROM p_Patient_WP w
	INNER JOIN p_Patient_WP_Item i
	ON i.patient_workplan_id = w.patient_workplan_id
WHERE w.cpr_id = @ps_cpr_id
AND w.treatment_id = @pl_followup_treatment_id
AND ISNULL(w.workplan_type, 'Followup') NOT IN ('Patient', 'Encounter', 'Treatment')
AND ISNULL(i.status, 'OPEN') <> 'CANCELLED'
AND i.item_type = 'Treatment'
AND i.treatment_id > 0

-- Then return the status of each treatment
INSERT INTO @treatments (
	treatment_id ,
	treatment_description ,
	treatment_type ,
	treatment_type_description ,
	treatment_type_icon ,
	treatment_status ,
	parent_patient_workplan_item_id )
SELECT t.treatment_id ,
	t.treatment_description ,
	t.treatment_type ,
	tt.description ,
	tt.icon ,
	ISNULL(t.treatment_status, 'Open') ,
	x.patient_workplan_item_id
FROM @ll_items x
	INNER JOIN p_Treatment_Item t
	ON t.cpr_id = @ps_cpr_id
	AND x.treatment_id = t.treatment_id
	INNER JOIN c_Treatment_Type tt
	ON t.treatment_type = tt.treatment_type

UPDATE x
SET treatment_description = CAST(progress AS varchar(1024))
FROM @treatments x
	INNER JOIN p_Treatment_Progress p
	ON p.cpr_id = @ps_cpr_id
	AND p.treatment_id = x.treatment_id
	AND p.progress_type = 'Modify'
	AND p.progress_key = 'treatment_description'
	AND p.current_flag = 'Y'
	AND p.progress IS NOT NULL

RETURN

END

GO
GRANT SELECT
	ON [dbo].[fn_followup_treatment_status]
	TO [cprsystem]
GO

