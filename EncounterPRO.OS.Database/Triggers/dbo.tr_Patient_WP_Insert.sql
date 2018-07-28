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

-- Drop Trigger [dbo].[tr_Patient_WP_Insert]
Print 'Drop Trigger [dbo].[tr_Patient_WP_Insert]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_Patient_WP_Insert]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_Patient_WP_Insert]
GO

-- Create Trigger [dbo].[tr_Patient_WP_Insert]
Print 'Create Trigger [dbo].[tr_Patient_WP_Insert]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_Patient_WP_Insert ON dbo.p_Patient_WP
FOR INSERT 
AS

IF EXISTS(SELECT 1 FROM inserted WHERE workplan_type = 'Attachment')
	BEGIN
	-- If there are any attachment workplans, then update the appropriate key according to
	-- what the attachment is attached to
	UPDATE p
	SET encounter_id = CASE a.context_object WHEN 'Encounter' THEN COALESCE(p.encounter_id, a.object_key) ELSE p.encounter_id END,
		problem_id = CASE a.context_object WHEN 'Assessment' THEN COALESCE(p.problem_id, a.object_key) ELSE p.problem_id END,
		treatment_id = CASE a.context_object WHEN 'Treatment' THEN COALESCE(p.treatment_id, a.object_key) ELSE p.treatment_id END,
		observation_sequence = CASE a.context_object WHEN 'Observation' THEN COALESCE(p.observation_sequence, a.object_key) ELSE p.observation_sequence END
	FROM p_Patient_WP p
		INNER JOIN inserted i
		ON p.patient_workplan_id = i.patient_workplan_id
		INNER JOIN p_Attachment a
		ON p.attachment_id = a.attachment_id
	END

UPDATE p
SET context_object = CASE i.workplan_type WHEN 'Patient' THEN 'Patient'
										WHEN 'Encounter' THEN 'Encounter'
										WHEN 'Assessment' THEN 'Assessment'
										WHEN 'Treatment' THEN 'Treatment'
										WHEN 'Referral' THEN 'Treatment'
										WHEN 'Followup' THEN 'Treatment'
										WHEN 'Attachment' THEN 'Attachment'
										ELSE 'General' END
FROM p_Patient_WP p
	INNER JOIN inserted i
	ON p.patient_workplan_id = i.patient_workplan_id

-------------------------------------------------------------------------------
-- If there is no encounter context, pick one.

-- If there is a treatment context, then use the open encounter of the specified treatment
UPDATE p
SET encounter_id = t.open_encounter_id
FROM p_Patient_WP p
	INNER JOIN inserted i
	ON p.patient_workplan_id = i.patient_workplan_id
	INNER JOIN p_Treatment_Item t
	ON p.cpr_id = t.cpr_id
	AND p.treatment_id = t.treatment_id
WHERE p.encounter_id IS NULL
AND p.treatment_id IS NOT NULL

-- Otherwise, use the last encounter
UPDATE p
SET encounter_id = e.max_encounter_id
FROM p_Patient_WP p
	INNER JOIN 
		(	SELECT i.patient_workplan_id, i.cpr_id, max(pe.encounter_id) as max_encounter_id
			FROM p_Patient_Encounter pe
				INNER JOIN inserted i
				ON pe.cpr_id = i.cpr_id
			GROUP BY i.patient_workplan_id, i.cpr_id ) e
	ON p.cpr_id = e.cpr_id
WHERE p.encounter_id IS NULL
-------------------------------------------------------------------------------

GO

